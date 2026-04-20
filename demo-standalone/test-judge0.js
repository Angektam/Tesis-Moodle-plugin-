/**
 * Script de prueba para Judge0 API
 * Uso: node test-judge0.js [lenguaje] [código]
 */

const Judge0Service = require('./services/judge0_service');

async function testJudge0() {
  const judge0 = new Judge0Service();
  
  console.log('🧪 Probando Judge0 API...\n');
  
  // Obtener argumentos
  const language = process.argv[2] || 'python';
  const code = process.argv[3] || `print("Hello from Judge0!")`;
  
  console.log(`Lenguaje: ${language}`);
  console.log(`Código:\n${code}\n`);
  
  try {
    // Test 1: Ejecución simple
    console.log('Test 1: Ejecución simple');
    console.log('─'.repeat(50));
    
    const result = await judge0.executeCode(code, language);
    
    console.log('✅ Resultado:');
    console.log(`  Status: ${result.status.description}`);
    console.log(`  Output: ${result.stdout || '(vacío)'}`);
    console.log(`  Error: ${result.stderr || '(ninguno)'}`);
    console.log(`  Tiempo: ${result.time}s`);
    console.log(`  Memoria: ${result.memory}KB\n`);
    
    // Test 2: Con casos de prueba
    console.log('Test 2: Con casos de prueba');
    console.log('─'.repeat(50));
    
    const testCases = [
      { input: '5', expected: '120' },
      { input: '3', expected: '6' },
      { input: '0', expected: '1' }
    ];
    
    const factorialCode = language === 'python' 
      ? `n = int(input())
result = 1
for i in range(1, n + 1):
    result *= i
print(result)`
      : `const n = parseInt(require('fs').readFileSync(0, 'utf-8'));
let result = 1;
for (let i = 1; i <= n; i++) {
    result *= i;
}
console.log(result);`;
    
    const testResult = await judge0.executeWithTestCases(
      factorialCode,
      language,
      testCases
    );
    
    console.log('✅ Resultados de casos de prueba:');
    console.log(`  Pasados: ${testResult.passed}/${testResult.total}`);
    console.log(`  Score: ${testResult.score}%\n`);
    
    testResult.results.forEach((r, i) => {
      const icon = r.isCorrect ? '✅' : '❌';
      console.log(`  ${icon} Caso ${i + 1}:`);
      console.log(`     Input: ${r.input}`);
      console.log(`     Esperado: ${r.expected}`);
      console.log(`     Obtenido: ${r.actual.trim()}`);
    });
    
    // Test 3: Lenguajes soportados
    console.log('\n\nTest 3: Lenguajes soportados');
    console.log('─'.repeat(50));
    
    const languages = judge0.getSupportedLanguages();
    console.log('✅ Lenguajes disponibles:');
    console.log(`  ${languages.join(', ')}\n`);
    
    console.log('✅ Todas las pruebas completadas exitosamente!');
    
  } catch (error) {
    console.error('❌ Error:', error.message);
    
    if (error.message.includes('API Key')) {
      console.log('\n💡 Asegúrate de configurar JUDGE0_API_KEY en .env');
      console.log('   Obtén tu API key en: https://rapidapi.com/judge0-official/api/judge0-ce');
    }
  }
}

// Ejecutar pruebas
testJudge0();
