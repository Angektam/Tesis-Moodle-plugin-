/**
 * Judge0 CE Service
 * Servicio para ejecutar código en múltiples lenguajes
 */

const fetch = require('node-fetch');
require('dotenv').config();

class Judge0Service {
  constructor() {
    this.apiKey = process.env.JUDGE0_API_KEY;
    this.apiHost = process.env.JUDGE0_API_HOST || 'judge0-ce.p.rapidapi.com';
    this.apiUrl = process.env.JUDGE0_API_URL || 'https://judge0-ce.p.rapidapi.com';
    
    // IDs de lenguajes más comunes
    this.languages = {
      'javascript': 63,  // Node.js
      'python': 71,      // Python 3
      'java': 62,        // Java
      'cpp': 54,         // C++ (GCC 9.2.0)
      'c': 50,           // C (GCC 9.2.0)
      'csharp': 51,      // C# (Mono 6.6.0.161)
      'php': 68,         // PHP
      'ruby': 72,        // Ruby
      'go': 60,          // Go
      'rust': 73,        // Rust
      'typescript': 74,  // TypeScript
      'kotlin': 78,      // Kotlin
      'swift': 83        // Swift
    };
  }

  /**
   * Ejecutar código
   */
  async executeCode(sourceCode, language, stdin = '', expectedOutput = null) {
    try {
      const languageId = this.getLanguageId(language);
      
      // Crear submission
      const submission = await this.createSubmission(sourceCode, languageId, stdin);
      
      // Esperar resultado
      const result = await this.waitForResult(submission.token);
      
      // Validar output si se proporciona
      if (expectedOutput !== null) {
        result.isCorrect = this.validateOutput(result.stdout, expectedOutput);
      }
      
      return result;
    } catch (error) {
      console.error('Error ejecutando código:', error);
      throw error;
    }
  }

  /**
   * Crear submission
   */
  async createSubmission(sourceCode, languageId, stdin) {
    const response = await fetch(`${this.apiUrl}/submissions?base64_encoded=true&wait=false`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-RapidAPI-Key': this.apiKey,
        'X-RapidAPI-Host': this.apiHost
      },
      body: JSON.stringify({
        source_code: Buffer.from(sourceCode).toString('base64'),
        language_id: languageId,
        stdin: Buffer.from(stdin).toString('base64')
      })
    });

    if (!response.ok) {
      throw new Error(`Judge0 API error: ${response.status}`);
    }

    return await response.json();
  }

  /**
   * Obtener resultado de submission
   */
  async getSubmission(token) {
    const response = await fetch(
      `${this.apiUrl}/submissions/${token}?base64_encoded=true`,
      {
        headers: {
          'X-RapidAPI-Key': this.apiKey,
          'X-RapidAPI-Host': this.apiHost
        }
      }
    );

    if (!response.ok) {
      throw new Error(`Judge0 API error: ${response.status}`);
    }

    return await response.json();
  }

  /**
   * Esperar resultado (polling)
   */
  async waitForResult(token, maxAttempts = 10) {
    for (let i = 0; i < maxAttempts; i++) {
      const result = await this.getSubmission(token);
      
      // Status IDs: 1=In Queue, 2=Processing, 3=Accepted, 4=Wrong Answer, etc.
      if (result.status.id > 2) {
        // Decodificar outputs
        return {
          status: result.status,
          stdout: result.stdout ? Buffer.from(result.stdout, 'base64').toString() : '',
          stderr: result.stderr ? Buffer.from(result.stderr, 'base64').toString() : '',
          compile_output: result.compile_output ? Buffer.from(result.compile_output, 'base64').toString() : '',
          time: result.time,
          memory: result.memory,
          token: token
        };
      }
      
      // Esperar 1 segundo antes de reintentar
      await new Promise(resolve => setTimeout(resolve, 1000));
    }
    
    throw new Error('Timeout esperando resultado de ejecución');
  }

  /**
   * Validar output
   */
  validateOutput(actual, expected) {
    const cleanActual = actual.trim();
    const cleanExpected = expected.trim();
    return cleanActual === cleanExpected;
  }

  /**
   * Obtener ID de lenguaje
   */
  getLanguageId(language) {
    const langLower = language.toLowerCase();
    if (this.languages[langLower]) {
      return this.languages[langLower];
    }
    throw new Error(`Lenguaje no soportado: ${language}`);
  }

  /**
   * Ejecutar con casos de prueba
   */
  async executeWithTestCases(sourceCode, language, testCases) {
    const results = [];
    
    for (const testCase of testCases) {
      const result = await this.executeCode(
        sourceCode,
        language,
        testCase.input,
        testCase.expected
      );
      
      results.push({
        input: testCase.input,
        expected: testCase.expected,
        actual: result.stdout,
        isCorrect: result.isCorrect,
        time: result.time,
        memory: result.memory,
        status: result.status
      });
    }
    
    // Calcular score
    const passed = results.filter(r => r.isCorrect).length;
    const score = (passed / testCases.length) * 100;
    
    return {
      results,
      passed,
      total: testCases.length,
      score
    };
  }

  /**
   * Obtener lenguajes soportados
   */
  getSupportedLanguages() {
    return Object.keys(this.languages);
  }
}

module.exports = Judge0Service;
