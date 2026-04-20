/**
 * Test del comparador AST
 * Prueba la detección de plagio usando árboles sintácticos
 */

const ASTComparator = require('./services/ast_comparator');

const comparator = new ASTComparator();

console.log('🧪 PRUEBAS DE COMPARACIÓN AST\n');
console.log('═'.repeat(60));

// Test 1: Código idéntico
console.log('\n📝 Test 1: Código idéntico');
const code1a = `
function factorial(n) {
    if (n <= 1) return 1;
    return n * factorial(n - 1);
}
`;
const code1b = `
function factorial(n) {
    if (n <= 1) return 1;
    return n * factorial(n - 1);
}
`;

comparator.compare(code1a, code1b, 'javascript').then(result => {
    console.log(`Similitud: ${result.similarity}%`);
    console.log(`Método: ${result.method}`);
    console.log(`Esperado: ~100%`);
    console.log(result.similarity >= 95 ? '✅ PASS' : '❌ FAIL');
});

// Test 2: Mismo código, variables diferentes
setTimeout(() => {
    console.log('\n📝 Test 2: Mismo algoritmo, nombres diferentes');
    const code2a = `
function factorial(n) {
    if (n <= 1) return 1;
    return n * factorial(n - 1);
}
`;
    const code2b = `
function calcularFactorial(numero) {
    if (numero <= 1) return 1;
    return numero * calcularFactorial(numero - 1);
}
`;

    comparator.compare(code2a, code2b, 'javascript').then(result => {
        console.log(`Similitud: ${result.similarity}%`);
        console.log(`Método: ${result.method}`);
        console.log(`Esperado: 85-95%`);
        console.log(result.similarity >= 85 && result.similarity <= 95 ? '✅ PASS' : '❌ FAIL');
    });
}, 100);

// Test 3: Algoritmo diferente
setTimeout(() => {
    console.log('\n📝 Test 3: Algoritmo diferente (iterativo vs recursivo)');
    const code3a = `
function factorial(n) {
    if (n <= 1) return 1;
    return n * factorial(n - 1);
}
`;
    const code3b = `
function factorial(n) {
    let result = 1;
    for (let i = 2; i <= n; i++) {
        result *= i;
    }
    return result;
}
`;

    comparator.compare(code3a, code3b, 'javascript').then(result => {
        console.log(`Similitud: ${result.similarity}%`);
        console.log(`Método: ${result.method}`);
        console.log(`Esperado: 40-70%`);
        console.log(result.similarity >= 40 && result.similarity <= 70 ? '✅ PASS' : '❌ FAIL');
    });
}, 200);

// Test 4: Código completamente diferente
setTimeout(() => {
    console.log('\n📝 Test 4: Código completamente diferente');
    const code4a = `
function factorial(n) {
    if (n <= 1) return 1;
    return n * factorial(n - 1);
}
`;
    const code4b = `
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

    comparator.compare(code4a, code4b, 'javascript').then(result => {
        console.log(`Similitud: ${result.similarity}%`);
        console.log(`Método: ${result.method}`);
        console.log(`Esperado: 0-30%`);
        console.log(result.similarity <= 30 ? '✅ PASS' : '❌ FAIL');
    });
}, 300);

// Test 5: Plagio con cambios cosméticos
setTimeout(() => {
    console.log('\n📝 Test 5: Plagio con cambios cosméticos');
    const code5a = `
function factorial(n) {
    if (n <= 1) return 1;
    return n * factorial(n - 1);
}
`;
    const code5b = `
// Función para calcular factorial
function factorial(numero) {
    // Caso base
    if (numero <= 1) {
        return 1;
    }
    // Caso recursivo
    return numero * factorial(numero - 1);
}
`;

    comparator.compare(code5a, code5b, 'javascript').then(result => {
        console.log(`Similitud: ${result.similarity}%`);
        console.log(`Método: ${result.method}`);
        console.log(`Esperado: 90-100%`);
        console.log(result.similarity >= 90 ? '✅ PASS' : '❌ FAIL');
        console.log('\n' + '═'.repeat(60));
        console.log('✅ Pruebas completadas\n');
    });
}, 400);
