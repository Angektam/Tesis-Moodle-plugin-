/**
 * Test completo de la API con AST
 * Prueba ambos endpoints: /api/evaluate y /api/compare
 */

const fetch = require('node-fetch');

const API_URL = 'http://localhost:3000';

console.log('🧪 PRUEBAS COMPLETAS DE LA API CON AST\n');
console.log('═'.repeat(70));

// Códigos de prueba
const codigoProfesor = `
function factorial(n) {
    if (n <= 1) return 1;
    return n * factorial(n - 1);
}
`;

const codigoEstudianteExcelente = `
function factorial(n) {
    if (n <= 1) return 1;
    return n * factorial(n - 1);
}
`;

const codigoEstudianteBueno = `
function calcularFactorial(numero) {
    if (numero <= 1) {
        return 1;
    }
    return numero * calcularFactorial(numero - 1);
}
`;

const codigoEstudianteDiferente = `
function factorial(n) {
    let result = 1;
    for (let i = 2; i <= n; i++) {
        result *= i;
    }
    return result;
}
`;

const codigoEstudianteMalo = `
function bubbleSort(arr) {
    for (let i = 0; i < arr.length; i++) {
        for (let j = 0; j < arr.length - 1; j++) {
            if (arr[j] > arr[j + 1]) {
                let temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
            }
        }
    }
    return arr;
}
`;

// Test 1: Evaluación - Código Excelente
async function test1() {
    console.log('\n📝 Test 1: Evaluación - Código Idéntico');
    console.log('─'.repeat(70));
    
    try {
        const response = await fetch(`${API_URL}/api/evaluate`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                studentAnswer: codigoEstudianteExcelente,
                teacherSolution: codigoProfesor,
                language: 'javascript'
            })
        });
        
        const result = await response.json();
        
        console.log(`✅ Calificación: ${result.score}/100`);
        console.log(`📊 Método: ${result.method}`);
        console.log(`💬 Feedback: ${result.feedback}`);
        console.log(`📈 Esperado: ~100 puntos (código idéntico)`);
        console.log(result.score >= 95 ? '✅ PASS' : '❌ FAIL');
        
    } catch (error) {
        console.error('❌ Error:', error.message);
    }
}

// Test 2: Evaluación - Código Bueno (nombres diferentes)
async function test2() {
    console.log('\n📝 Test 2: Evaluación - Mismo algoritmo, nombres diferentes');
    console.log('─'.repeat(70));
    
    try {
        const response = await fetch(`${API_URL}/api/evaluate`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                studentAnswer: codigoEstudianteBueno,
                teacherSolution: codigoProfesor,
                language: 'javascript'
            })
        });
        
        const result = await response.json();
        
        console.log(`✅ Calificación: ${result.score}/100`);
        console.log(`📊 Método: ${result.method}`);
        console.log(`💬 Feedback: ${result.feedback}`);
        console.log(`📈 Esperado: 85-100 puntos (misma estructura)`);
        console.log(result.score >= 85 ? '✅ PASS' : '❌ FAIL');
        
    } catch (error) {
        console.error('❌ Error:', error.message);
    }
}

// Test 3: Evaluación - Algoritmo Diferente
async function test3() {
    console.log('\n📝 Test 3: Evaluación - Algoritmo diferente (iterativo)');
    console.log('─'.repeat(70));
    
    try {
        const response = await fetch(`${API_URL}/api/evaluate`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                studentAnswer: codigoEstudianteDiferente,
                teacherSolution: codigoProfesor,
                language: 'javascript'
            })
        });
        
        const result = await response.json();
        
        console.log(`✅ Calificación: ${result.score}/100`);
        console.log(`📊 Método: ${result.method}`);
        console.log(`💬 Feedback: ${result.feedback}`);
        console.log(`📈 Esperado: 40-70 puntos (diferente enfoque)`);
        console.log(result.score >= 40 && result.score <= 70 ? '✅ PASS' : '⚠️ REVIEW');
        
    } catch (error) {
        console.error('❌ Error:', error.message);
    }
}

// Test 4: Evaluación - Código Incorrecto
async function test4() {
    console.log('\n📝 Test 4: Evaluación - Código completamente diferente');
    console.log('─'.repeat(70));
    
    try {
        const response = await fetch(`${API_URL}/api/evaluate`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                studentAnswer: codigoEstudianteMalo,
                teacherSolution: codigoProfesor,
                language: 'javascript'
            })
        });
        
        const result = await response.json();
        
        console.log(`✅ Calificación: ${result.score}/100`);
        console.log(`📊 Método: ${result.method}`);
        console.log(`💬 Feedback: ${result.feedback}`);
        console.log(`📈 Esperado: 0-30 puntos (código diferente)`);
        console.log(result.score <= 30 ? '✅ PASS' : '❌ FAIL');
        
    } catch (error) {
        console.error('❌ Error:', error.message);
    }
}

// Test 5: Comparación - Plagio Obvio
async function test5() {
    console.log('\n📝 Test 5: Comparación - Plagio obvio (código idéntico)');
    console.log('─'.repeat(70));
    
    try {
        const response = await fetch(`${API_URL}/api/compare`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                answer1: codigoEstudianteExcelente,
                answer2: codigoEstudianteExcelente,
                language: 'javascript'
            })
        });
        
        const result = await response.json();
        
        console.log(`✅ Similitud: ${result.similarity}%`);
        console.log(`📊 Método: ${result.method}`);
        console.log(`💬 Mensaje: ${result.message || 'N/A'}`);
        console.log(`📈 Esperado: ~100% (código idéntico)`);
        console.log(result.similarity >= 95 ? '✅ PASS' : '❌ FAIL');
        
    } catch (error) {
        console.error('❌ Error:', error.message);
    }
}

// Test 6: Comparación - Plagio con Cambios
async function test6() {
    console.log('\n📝 Test 6: Comparación - Plagio con cambios cosméticos');
    console.log('─'.repeat(70));
    
    try {
        const response = await fetch(`${API_URL}/api/compare`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                answer1: codigoEstudianteExcelente,
                answer2: codigoEstudianteBueno,
                language: 'javascript'
            })
        });
        
        const result = await response.json();
        
        console.log(`✅ Similitud: ${result.similarity}%`);
        console.log(`📊 Método: ${result.method}`);
        console.log(`💬 Mensaje: ${result.message || 'N/A'}`);
        console.log(`📈 Esperado: 85-100% (misma estructura)`);
        console.log(result.similarity >= 85 ? '✅ PASS' : '❌ FAIL');
        
    } catch (error) {
        console.error('❌ Error:', error.message);
    }
}

// Test 7: Comparación - Códigos Diferentes
async function test7() {
    console.log('\n📝 Test 7: Comparación - Códigos completamente diferentes');
    console.log('─'.repeat(70));
    
    try {
        const response = await fetch(`${API_URL}/api/compare`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                answer1: codigoProfesor,
                answer2: codigoEstudianteMalo,
                language: 'javascript'
            })
        });
        
        const result = await response.json();
        
        console.log(`✅ Similitud: ${result.similarity}%`);
        console.log(`📊 Método: ${result.method}`);
        console.log(`💬 Mensaje: ${result.message || 'N/A'}`);
        console.log(`📈 Esperado: 0-30% (códigos diferentes)`);
        console.log(result.similarity <= 30 ? '✅ PASS' : '❌ FAIL');
        
    } catch (error) {
        console.error('❌ Error:', error.message);
    }
}

// Ejecutar todos los tests
async function runAllTests() {
    console.log('\n🚀 Iniciando pruebas...\n');
    
    await test1();
    await new Promise(resolve => setTimeout(resolve, 500));
    
    await test2();
    await new Promise(resolve => setTimeout(resolve, 500));
    
    await test3();
    await new Promise(resolve => setTimeout(resolve, 500));
    
    await test4();
    await new Promise(resolve => setTimeout(resolve, 500));
    
    await test5();
    await new Promise(resolve => setTimeout(resolve, 500));
    
    await test6();
    await new Promise(resolve => setTimeout(resolve, 500));
    
    await test7();
    
    console.log('\n' + '═'.repeat(70));
    console.log('✅ Pruebas completadas\n');
    console.log('📊 Resumen:');
    console.log('   • Evaluación con AST: Tests 1-4');
    console.log('   • Detección de plagio con AST: Tests 5-7');
    console.log('   • Método híbrido (AST + IA) cuando es necesario');
    console.log('\n💡 Nota: El servidor debe estar corriendo en http://localhost:3000');
}

// Verificar que el servidor esté corriendo
async function checkServer() {
    try {
        const response = await fetch(`${API_URL}/plugin-funcional.html`);
        if (response.ok) {
            console.log('✅ Servidor detectado en http://localhost:3000\n');
            return true;
        }
    } catch (error) {
        console.error('❌ Error: El servidor no está corriendo');
        console.error('   Ejecuta: npm start');
        return false;
    }
}

// Main
(async () => {
    const serverRunning = await checkServer();
    if (serverRunning) {
        await runAllTests();
    }
})();
