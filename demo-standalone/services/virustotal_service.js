/**
 * VirusTotal API Service
 * Servicio para escanear archivos y URLs en busca de malware
 */

const fetch = require('node-fetch');
const fs = require('fs');
const FormData = require('form-data');
require('dotenv').config();

class VirusTotalService {
  constructor() {
    this.apiKey = process.env.VIRUSTOTAL_API_KEY;
    this.apiUrl = process.env.VIRUSTOTAL_API_URL || 'https://www.virustotal.com/api/v3';
  }

  /**
   * Escanear archivo
   */
  async scanFile(filePath) {
    try {
      // Leer archivo
      const fileBuffer = fs.readFileSync(filePath);
      const fileSize = fileBuffer.length;
      
      // VirusTotal tiene límite de 32MB para archivos
      if (fileSize > 32 * 1024 * 1024) {
        throw new Error('Archivo demasiado grande (máximo 32MB)');
      }

      // Crear FormData
      const formData = new FormData();
      formData.append('file', fileBuffer, {
        filename: filePath.split('/').pop()
      });

      // Subir archivo
      const response = await fetch(`${this.apiUrl}/files`, {
        method: 'POST',
        headers: {
          'x-apikey': this.apiKey
        },
        body: formData
      });

      if (!response.ok) {
        throw new Error(`VirusTotal API error: ${response.status}`);
      }

      const data = await response.json();
      
      // Esperar análisis
      const analysisId = data.data.id;
      const result = await this.waitForAnalysis(analysisId);
      
      return result;
    } catch (error) {
      console.error('Error escaneando archivo:', error);
      throw error;
    }
  }

  /**
   * Escanear URL
   */
  async scanUrl(url) {
    try {
      const formData = new FormData();
      formData.append('url', url);

      const response = await fetch(`${this.apiUrl}/urls`, {
        method: 'POST',
        headers: {
          'x-apikey': this.apiKey
        },
        body: formData
      });

      if (!response.ok) {
        throw new Error(`VirusTotal API error: ${response.status}`);
      }

      const data = await response.json();
      
      // Esperar análisis
      const analysisId = data.data.id;
      const result = await this.waitForAnalysis(analysisId);
      
      return result;
    } catch (error) {
      console.error('Error escaneando URL:', error);
      throw error;
    }
  }

  /**
   * Obtener análisis
   */
  async getAnalysis(analysisId) {
    try {
      const response = await fetch(`${this.apiUrl}/analyses/${analysisId}`, {
        headers: {
          'x-apikey': this.apiKey
        }
      });

      if (!response.ok) {
        throw new Error(`VirusTotal API error: ${response.status}`);
      }

      return await response.json();
    } catch (error) {
      console.error('Error obteniendo análisis:', error);
      throw error;
    }
  }

  /**
   * Esperar análisis (polling)
   */
  async waitForAnalysis(analysisId, maxAttempts = 10) {
    for (let i = 0; i < maxAttempts; i++) {
      const analysis = await this.getAnalysis(analysisId);
      
      if (analysis.data.attributes.status === 'completed') {
        return this.parseAnalysisResult(analysis);
      }
      
      // Esperar 5 segundos antes de reintentar
      await new Promise(resolve => setTimeout(resolve, 5000));
    }
    
    throw new Error('Timeout esperando análisis de VirusTotal');
  }

  /**
   * Parsear resultado de análisis
   */
  parseAnalysisResult(analysis) {
    const stats = analysis.data.attributes.stats;
    const results = analysis.data.attributes.results;
    
    // Contar detecciones
    const malicious = stats.malicious || 0;
    const suspicious = stats.suspicious || 0;
    const undetected = stats.undetected || 0;
    const harmless = stats.harmless || 0;
    const total = malicious + suspicious + undetected + harmless;
    
    // Determinar si es malicioso
    const isMalicious = malicious > 0;
    const isSuspicious = suspicious > 0;
    
    // Obtener detalles de detecciones
    const detections = [];
    if (results) {
      for (const [engine, result] of Object.entries(results)) {
        if (result.category === 'malicious' || result.category === 'suspicious') {
          detections.push({
            engine,
            category: result.category,
            result: result.result,
            method: result.method
          });
        }
      }
    }
    
    return {
      isMalicious,
      isSuspicious,
      isSafe: !isMalicious && !isSuspicious,
      stats: {
        malicious,
        suspicious,
        undetected,
        harmless,
        total
      },
      detections,
      analysisId: analysis.data.id,
      permalink: `https://www.virustotal.com/gui/file/${analysis.data.id}`
    };
  }

  /**
   * Escanear código (como texto)
   */
  async scanCode(code, filename = 'code.txt') {
    try {
      // Crear archivo temporal
      const tempPath = `/tmp/${filename}`;
      fs.writeFileSync(tempPath, code);
      
      // Escanear
      const result = await this.scanFile(tempPath);
      
      // Eliminar archivo temporal
      fs.unlinkSync(tempPath);
      
      return result;
    } catch (error) {
      console.error('Error escaneando código:', error);
      throw error;
    }
  }

  /**
   * Verificar si un archivo es seguro
   */
  async isFileSafe(filePath, threshold = 0) {
    try {
      const result = await this.scanFile(filePath);
      
      // Si hay detecciones maliciosas, no es seguro
      if (result.stats.malicious > threshold) {
        return {
          safe: false,
          reason: `Detectado como malicioso por ${result.stats.malicious} motores`,
          details: result
        };
      }
      
      // Si hay detecciones sospechosas, advertir
      if (result.stats.suspicious > 0) {
        return {
          safe: true,
          warning: `Detectado como sospechoso por ${result.stats.suspicious} motores`,
          details: result
        };
      }
      
      return {
        safe: true,
        details: result
      };
    } catch (error) {
      console.error('Error verificando seguridad:', error);
      throw error;
    }
  }

  /**
   * Obtener reputación de dominio
   */
  async getDomainReputation(domain) {
    try {
      const response = await fetch(`${this.apiUrl}/domains/${domain}`, {
        headers: {
          'x-apikey': this.apiKey
        }
      });

      if (!response.ok) {
        throw new Error(`VirusTotal API error: ${response.status}`);
      }

      const data = await response.json();
      
      return {
        reputation: data.data.attributes.reputation,
        categories: data.data.attributes.categories,
        lastAnalysisStats: data.data.attributes.last_analysis_stats
      };
    } catch (error) {
      console.error('Error obteniendo reputación de dominio:', error);
      throw error;
    }
  }
}

module.exports = VirusTotalService;
