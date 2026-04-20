/**
 * Script de prueba para GitHub API
 * Uso: node test-github.js [query] [lenguaje]
 */

const GitHubService = require('./services/github_service');

async function testGitHub() {
  const github = new GitHubService();
  
  console.log('🧪 Probando GitHub API...\n');
  
  // Obtener argumentos
  const query = process.argv[2] || 'function factorial';
  const language = process.argv[3] || null;
  
  console.log(`Query: "${query}"`);
  if (language) {
    console.log(`Lenguaje: ${language}`);
  }
  console.log();
  
  try {
    // Test 1: Verificar rate limit
    console.log('Test 1: Verificar rate limit');
    console.log('─'.repeat(50));
    
    const rateLimit = await github.checkRateLimit();
    console.log('✅ Rate limit:');
    console.log(`  Límite: ${rateLimit.limit} requests/hora`);
    console.log(`  Restantes: ${rateLimit.remaining}`);
    console.log(`  Reset: ${rateLimit.reset.toLocaleString()}`);
    console.log(`  Búsquedas restantes: ${rateLimit.searchRemaining}/30\n`);
    
    // Test 2: Buscar código
    console.log('Test 2: Buscar código');
    console.log('─'.repeat(50));
    
    const searchResults = await github.searchCode(query, language, 5);
    
    console.log('✅ Resultados de búsqueda:');
    console.log(`  Total encontrado: ${searchResults.total}`);
    console.log(`  Mostrando: ${searchResults.items.length}\n`);
    
    searchResults.items.forEach((item, i) => {
      console.log(`  ${i + 1}. ${item.name}`);
      console.log(`     Repo: ${item.repository}`);
      console.log(`     Path: ${item.path}`);
      console.log(`     URL: ${item.url}`);
      console.log(`     Score: ${item.score}\n`);
    });
    
    // Test 3: Detectar plagio externo
    console.log('Test 3: Detectar plagio externo');
    console.log('─'.repeat(50));
    
    const sampleCode = `
function factorial(n) {
    if (n <= 1) return 1;
    return n * factorial(n - 1);
}
`;
    
    console.log('Código de muestra:');
    console.log(sampleCode);
    
    const plagiarismResult = await github.detectExternalPlagiarism(
      sampleCode,
      'javascript',
      0.5
    );
    
    console.log('✅ Resultado de detección:');
    console.log(`  ¿Es plagio?: ${plagiarismResult.isPlagiarized ? '⚠️ SÍ' : '✅ NO'}`);
    console.log(`  Score de similitud: ${(plagiarismResult.similarityScore * 100).toFixed(1)}%`);
    console.log(`  Fragmentos analizados: ${plagiarismResult.totalFragments}`);
    console.log(`  Fragmentos con coincidencias: ${plagiarismResult.matchedFragments}\n`);
    
    if (plagiarismResult.matches.length > 0) {
      console.log('  Coincidencias encontradas:');
      plagiarismResult.matches.forEach((match, i) => {
        console.log(`\n  Fragmento ${i + 1}:`);
        console.log(`    Total de coincidencias: ${match.totalMatches}`);
        console.log(`    Primeras coincidencias:`);
        match.matches.slice(0, 3).forEach(m => {
          console.log(`      - ${m.repository}: ${m.path}`);
        });
      });
    }
    
    // Test 4: Buscar repositorios
    console.log('\n\nTest 4: Buscar repositorios');
    console.log('─'.repeat(50));
    
    const repoResults = await github.searchRepositories('factorial algorithm', 3);
    
    console.log('✅ Repositorios encontrados:');
    console.log(`  Total: ${repoResults.total}\n`);
    
    repoResults.items.forEach((repo, i) => {
      console.log(`  ${i + 1}. ${repo.fullName}`);
      console.log(`     Descripción: ${repo.description || 'N/A'}`);
      console.log(`     Lenguaje: ${repo.language || 'N/A'}`);
      console.log(`     Stars: ⭐ ${repo.stars}`);
      console.log(`     URL: ${repo.url}\n`);
    });
    
    console.log('✅ Todas las pruebas completadas exitosamente!');
    
  } catch (error) {
    console.error('❌ Error:', error.message);
    
    if (error.message.includes('Rate limit')) {
      console.log('\n💡 Has excedido el límite de rate. Espera un momento.');
    } else if (error.message.includes('API error')) {
      console.log('\n💡 Asegúrate de configurar GITHUB_TOKEN en .env');
      console.log('   Obtén tu token en: https://github.com/settings/tokens');
    }
  }
}

// Ejecutar pruebas
testGitHub();
