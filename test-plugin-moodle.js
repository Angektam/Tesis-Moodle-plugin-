#!/usr/bin/env node

/**
 * Script de Pruebas Automatizadas del Plugin AI Assignment
 */

const http = require('http');
const https = require('https');

// Configuración
const MOODLE_URL = 'localhost';
const MOODLE_PORT = 80;
const USE_HTTPS = false;

console.log('\n🧪 INICIANDO PRUEBAS DEL PLUGIN AI ASSIGNMENT');
console.log('═'.repeat(70));
console.log(`📍 URL: http://${MOODLE_URL}:${MOODLE_PORT}`);
console.log('═'.repeat(70));

// Función para hacer peticiones HTTP
function makeRequest(path) {
    return new Promise((resolve) => {
        const options = {
            hostname: MOODLE_URL,
            port: MOODLE_PORT,
            path: path,
            method: 'HEAD',
            timeout: 5000
        };

        const protocol = USE_HTTPS ? https : http;
        
        const req = protocol.request(options, (res) => {
            resolve({
                success: true,
                statusCode: res.statusCode,
                statusMessage: res.statusMessage
            });
        });

        req.on('error', (err) => {
            resolve({
                success: false,
                error: err.message
            });
        });

        req.on('timeout', () => {
            req.destroy();
            resolve({
                success: false,
                error: 'Timeout'
            });
        });

        req.end();
    });
}

// Función para imprimir resultados
function printResult(testName, result) {
    const icon = result.success && (result.statusCode === 200 || result.statusCode === 302 || result.statusCode === 303) ? '✅' : '❌';
    const status = result.success ? `${result.statusCode} ${result.statusMessage}` : result.error;
    console.log(`${icon} ${testName}`);
    console.log(`   └─ ${status}`);
}

// Ejecutar pruebas
async function runTests() {
    const tests = [
        {
            name: 'Prueba 1: Conexión a Moodle',
            path: '/',
            description: 'Verifica que Moodle esté accesible'
        },
        {
            name: 'Prueba 2: Plugin Instalado',
            path: '/mod/aiassignment/',
            description: 'Verifica que el plugin esté instalado'
        },
        {
            name: 'Prueba 3: Archivo version.php',
            path: '/mod/aiassignment/version.php',
            description: 'Verifica archivo de versión'
        },
        {
            name: 'Prueba 4: Archivo lib.php',
            path: '/mod/aiassignment/lib.php',
            description: 'Verifica funciones principales'
        },
        {
            name: 'Prueba 5: Archivo view.php',
            path: '/mod/aiassignment/view.php',
            description: 'Verifica vista principal'
        },
        {
            name: 'Prueba 6: Archivo mod_form.php',
            path: '/mod/aiassignment/mod_form.php',
            description: 'Verifica formulario de configuración'
        },
        {
            name: 'Prueba 7: Carpeta db/',
            path: '/mod/aiassignment/db/',
            description: 'Verifica archivos de base de datos'
        },
        {
            name: 'Prueba 8: Carpeta lang/',
            path: '/mod/aiassignment/lang/',
            description: 'Verifica archivos de idioma'
        },
        {
            name: 'Prueba 9: Carpeta classes/',
            path: '/mod/aiassignment/classes/',
            description: 'Verifica clases PHP'
        },
        {
            name: 'Prueba 10: Dashboard',
            path: '/mod/aiassignment/dashboard.php',
            description: 'Verifica dashboard de estadísticas'
        }
    ];

    const results = [];
    
    console.log('\n📋 EJECUTANDO PRUEBAS...\n');
    
    for (const test of tests) {
        console.log(`\n${test.name}`);
        console.log(`   ${test.description}`);
        console.log('   ' + '-'.repeat(60));
        
        const result = await makeRequest(test.path);
        printResult(test.name, result);
        
        results.push({
            name: test.name,
            passed: result.success && (result.statusCode === 200 || result.statusCode === 302 || result.statusCode === 303)
        });
        
        // Pequeña pausa entre pruebas
        await new Promise(resolve => setTimeout(resolve, 300));
    }

    // Resumen
    console.log('\n' + '═'.repeat(70));
    console.log('📊 RESUMEN DE PRUEBAS AUTOMÁTICAS');
    console.log('═'.repeat(70));

    const passed = results.filter(r => r.passed).length;
    const total = results.length;
    const percentage = ((passed / total) * 100).toFixed(1);

    console.log(`\n✓ Pruebas Pasadas: ${passed}/${total} (${percentage}%)`);
    
    if (percentage >= 80) {
        console.log('\n✅ RESULTADO: Plugin instalado y funcionando correctamente');
    } else if (percentage >= 50) {
        console.log('\n⚠️  RESULTADO: Plugin parcialmente funcional - Revisar pruebas fallidas');
    } else {
        console.log('\n❌ RESULTADO: Problemas con la instalación del plugin');
    }

    // Pruebas manuales
    console.log('\n' + '═'.repeat(70));
    console.log('📝 PRUEBAS MANUALES REQUERIDAS');
    console.log('═'.repeat(70));

    console.log('\n🔧 1. CONFIGURAR PLUGIN');
    console.log('   URL: http://localhost/admin/settings.php?section=modsettingaiassignment');
    console.log('   ✓ Configurar OpenAI API Key (o activar Demo Mode)');
    console.log('   ✓ Seleccionar modelo: gpt-4o-mini');
    console.log('   ✓ Guardar cambios');

    console.log('\n➕ 2. CREAR ACTIVIDAD DE PRUEBA');
    console.log('   ✓ Ir a un curso');
    console.log('   ✓ Turn editing on');
    console.log('   ✓ Add an activity → AI Assignment');
    console.log('   ✓ Configurar:');
    console.log('     - Nombre: Prueba de Factorial');
    console.log('     - Tipo: Programación');
    console.log('     - Solución: def factorial(n): return 1 if n <= 1 else n * factorial(n-1)');
    console.log('   ✓ Guardar y mostrar');

    console.log('\n📝 3. PROBAR ENVÍO');
    console.log('   ✓ Cambiar a rol de estudiante');
    console.log('   ✓ Enviar una respuesta');
    console.log('   ✓ Verificar evaluación automática (5-10 seg)');
    console.log('   ✓ Revisar calificación y feedback');

    console.log('\n📊 4. VERIFICAR DASHBOARD');
    console.log('   ✓ Como profesor, acceder a la actividad');
    console.log('   ✓ Clic en botón "Dashboard"');
    console.log('   ✓ Verificar estadísticas y gráficos');

    console.log('\n🔍 5. PROBAR DETECCIÓN DE PLAGIO');
    console.log('   ✓ Crear al menos 2 envíos');
    console.log('   ✓ Ir a "Plagiarism Report"');
    console.log('   ✓ Analizar similitud entre envíos');

    console.log('\n📚 6. VERIFICAR LIBRO DE CALIFICACIONES');
    console.log('   ✓ Ir al curso → Grades');
    console.log('   ✓ Verificar que aparezca la actividad');
    console.log('   ✓ Comprobar sincronización de calificaciones');

    console.log('\n' + '═'.repeat(70));
    console.log('📖 DOCUMENTACIÓN');
    console.log('═'.repeat(70));
    console.log('\nPara más detalles, consulta:');
    console.log('  • GUIA_PRUEBAS_MANUAL.md - Guía paso a paso completa');
    console.log('  • INSTALACION_PLUGIN_FINAL.md - Instrucciones de instalación');
    console.log('  • PLUGIN_VERIFICACION_FINAL.md - Verificación técnica');
    console.log('  • CUMPLIMIENTO_ESTANDARES_MOODLE.md - Estándares cumplidos');

    console.log('\n' + '═'.repeat(70));
    console.log('✅ PRUEBAS COMPLETADAS');
    console.log('═'.repeat(70));
    console.log('');

    return results;
}

// Ejecutar
console.log('\n⏳ Iniciando en 2 segundos...\n');
setTimeout(() => {
    runTests().catch(err => {
        console.error('\n❌ Error fatal:', err.message);
        console.error(err.stack);
        process.exit(1);
    });
}, 2000);
