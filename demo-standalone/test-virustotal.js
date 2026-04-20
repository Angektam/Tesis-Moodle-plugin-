/**
 * Script de prueba para VirusTotal API
 * Uso: node test-virustotal.js [archivo o URL]
 */

const VirusTotalService = require('./services/virustotal_service');
const fs = require('fs');

async function testVirusTotal() {
  const vt = new VirusTotalService();
  
  console.log('🧪 Probando VirusTotal API...\n');
  
  // Obtener argumento
  const target = process.argv[2];
  
  try {
    // Test 1: Escanear código seguro
    console.log('Test 1: Escanear código seguro');
    console.log('─'.repeat(50));
    
    const safeCode = `
def factorial(n):
    if n <= 1:
        return 1
    return n * factorial(n - 1)

print(factorial(5))
`;
    
    console.log('Código de muestra:');
    console.log(safeCode);
    console.log('\nEscaneando...');
    
    const codeResult = await vt.scanCode(safeCode, 'safe_code.py');
    
    console.log('\n✅ Resultado:');
    console.log(`  ¿Es seguro?: ${codeResult.isSafe ? '✅ SÍ' : '⚠️ NO'}`);
    console.log(`  ¿Es malicioso?: ${codeResult.isMalicious ? '⚠️ SÍ' : '✅ NO'}`);
    console.log(`  ¿Es sospechoso?: ${codeResult.isSuspicious ? '⚠️ SÍ' : '✅ NO'}`);
    console.log('\n  Estadísticas:');
    console.log(`    Malicioso: ${codeResult.stats.malicious}`);
    console.log(`    Sospechoso: ${codeResult.stats.suspicious}`);
    console.log(`    No detectado: ${codeResult.stats.undetected}`);
    console.log(`    Inofensivo: ${codeResult.stats.harmless}`);
    console.log(`    Total de motores: ${codeResult.stats.total}`);
    console.log(`\n  Permalink: ${codeResult.permalink}\n`);
    
    // Test 2: Escanear URL
    console.log('Test 2: Escanear URL');
    console.log('─'.repeat(50));
    
    const testUrl = 'https://www.google.com';
    console.log(`URL: ${testUrl}`);
    console.log('Escaneando...');
    
    const urlResult = await vt.scanUrl(testUrl);
    
    console.log('\n✅ Resultado:');
    console.log(`  ¿Es seguro?: ${urlResult.isSafe ? '✅ SÍ' : '⚠️ NO'}`);
    console.log(`  ¿Es malicioso?: ${urlResult.isMalicious ? '⚠️ SÍ' : '✅ NO'}`);
    console.log('\n  Estadísticas:');
    console.log(`    Malicioso: ${urlResult.stats.malicious}`);
    console.log(`    Sospechoso: ${urlResult.stats.suspicious}`);
    console.log(`    No detectado: ${urlResult.stats.undetected}`);
    console.log(`    Inofensivo: ${urlResult.stats.harmless}\n`);
    
    // Test 3: Escanear archivo si se proporciona
    if (target && fs.existsSync(target)) {
      console.log('Test 3: Escanear archivo proporcionado');
      console.log('─'.repeat(50));
      
      console.log(`Archivo: ${target}`);
      console.log('Escaneando...');
      
      const fileResult = await vt.scanFile(target);
      
      console.log('\n✅ Resultado:');
      console.log(`  ¿Es seguro?: ${fileResult.isSafe ? '✅ SÍ' : '⚠️ NO'}`);
      console.log(`  ¿Es malicioso?: ${fileResult.isMalicious ? '⚠️ SÍ' : '✅ NO'}`);
      
      if (fileResult.detections.length > 0) {
        console.log('\n  ⚠️ Detecciones:');
        fileResult.detections.forEach(d => {
          console.log(`    - ${d.engine}: ${d.result} (${d.category})`);
        });
      }
      
      console.log(`\n  Permalink: ${fileResult.permalink}\n`);
    }
    
    // Test 4: Verificar dominio
    console.log('Test 4: Verificar reputación de dominio');
    console.log('─'.repeat(50));
    
    const domain = 'google.com';
    console.log(`Dominio: ${domain}`);
    
    const domainRep = await vt.getDomainReputation(domain);
    
    console.log('\n✅ Reputación:');
    console.log(`  Score: ${domainRep.reputation}`);
    console.log(`  Categorías: ${Object.keys(domainRep.categories || {}).join(', ') || 'N/A'}`);
    console.log('\n  Último análisis:');
    console.log(`    Malicioso: ${domainRep.lastAnalysisStats.malicious || 0}`);
    console.log(`    Sospechoso: ${domainRep.lastAnalysisStats.suspicious || 0}`);
    console.log(`    Inofensivo: ${domainRep.lastAnalysisStats.harmless || 0}\n`);
    
    console.log('✅ Todas las pruebas completadas exitosamente!');
    console.log('\n💡 Nota: VirusTotal tiene un límite de 4 requests/minuto en el plan gratuito.');
    
  } catch (error) {
    console.error('❌ Error:', error.message);
    
    if (error.message.includes('API error: 401')) {
      console.log('\n💡 Asegúrate de configurar VIRUSTOTAL_API_KEY en .env');
      console.log('   Obtén tu API key en: https://www.virustotal.com/');
    } else if (error.message.includes('API error: 429')) {
      console.log('\n💡 Has excedido el límite de rate (4 requests/minuto).');
      console.log('   Espera un minuto antes de intentar de nuevo.');
    }
  }
}

// Ejecutar pruebas
testVirusTotal();
