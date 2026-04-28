/**
 * ============================================================================
 * PRUEBA DE ESTRÉS — AI Assignment Plugin v2.4.0
 * ============================================================================
 *
 * Evalúa los límites del plugin en 6 áreas:
 *
 *   1. AST Comparator     — Código cada vez más grande hasta que falle/timeout
 *   2. Evaluación IA      — Ráfagas concurrentes al endpoint /api/evaluate
 *   3. Detección de plagio— N×N comparaciones con muchos alumnos simulados
 *   4. Sanitización       — Payloads maliciosos y edge cases
 *   5. Código extremo     — Archivos enormes, anidamiento profundo, Unicode
 *   6. Concurrencia       — Peticiones simultáneas al servidor
 *
 * USO:
 *   1. Inicia el servidor:  npm start
 *   2. En otra terminal:    node scripts/stress-test.js
 *
 * El script NO necesita Moodle — prueba contra el servidor demo standalone.
 * ============================================================================
 */

const http = require('http');

const BASE = 'http://localhost:3000';
const RESULTS = [];
let testNumber = 0;

// ─── Utilidades ──────────────────────────────────────────────────────────────

function post(path, body, timeoutMs = 30000) {
    return new Promise((resolve, reject) => {
        const data = JSON.stringify(body);
        const url = new URL(path, BASE);
        const opts = {
            hostname: url.hostname,
            port: url.port,
            path: url.pathname,
            method: 'POST',
            headers: { 'Content-Type': 'application/json', 'Content-Length': Buffer.byteLength(data) },
            timeout: timeoutMs,
        };
        const req = http.request(opts, (res) => {
            let chunks = '';
            res.on('data', (c) => chunks += c);
            res.on('end', () => {
                try { resolve({ status: res.statusCode, body: JSON.parse(chunks) }); }
                catch { resolve({ status: res.statusCode, body: chunks }); }
            });
        });
        req.on('timeout', () => { req.destroy(); reject(new Error('TIMEOUT')); });
        req.on('error', reject);
        req.write(data);
        req.end();
    });
}

function generateCode(lines, lang = 'javascript') {
    const parts = [];
    if (lang === 'python') {
        parts.push('import math');
        for (let i = 0; i < lines; i++) {
            parts.push(`def func_${i}(x):`);
            parts.push(`    result = x * ${i} + math.sqrt(${i + 1})`);
            parts.push(`    if result > ${i * 10}:`);
            parts.push(`        for j in range(${i}):`);
            parts.push(`            result += j`);
            parts.push(`    return result`);
        }
    } else {
        for (let i = 0; i < lines; i++) {
            parts.push(`function func_${i}(x) {`);
            parts.push(`    let result = x * ${i} + Math.sqrt(${i + 1});`);
            parts.push(`    if (result > ${i * 10}) {`);
            parts.push(`        for (let j = 0; j < ${i}; j++) { result += j; }`);
            parts.push(`    }`);
            parts.push(`    return result;`);
            parts.push(`}`);
        }
    }
    return parts.join('\n');
}

function generateDeepNesting(depth) {
    let code = '';
    for (let i = 0; i < depth; i++) code += `${'  '.repeat(i)}if (x > ${i}) {\n`;
    code += `${'  '.repeat(depth)}return x;\n`;
    for (let i = depth - 1; i >= 0; i--) code += `${'  '.repeat(i)}}\n`;
    return `function deep(x) {\n${code}}`;
}

function record(name, passed, time, detail) {
    testNumber++;
    const icon = passed ? '✅' : '❌';
    RESULTS.push({ n: testNumber, name, passed, time, detail });
    console.log(`  ${icon} [${time}ms] ${name}${detail ? ' — ' + detail : ''}`);
}

async function measure(fn) {
    const t0 = Date.now();
    try {
        const result = await fn();
        return { ok: true, result, ms: Date.now() - t0 };
    } catch (e) {
        return { ok: false, error: e.message, ms: Date.now() - t0 };
    }
}

// ─── TEST 1: Escalabilidad del AST Comparator ───────────────────────────────

async function testASTScalability() {
    console.log('\n╔══════════════════════════════════════════════════════════╗');
    console.log('║  TEST 1: ESCALABILIDAD DEL AST COMPARATOR              ║');
    console.log('╚══════════════════════════════════════════════════════════╝\n');

    const sizes = [10, 50, 100, 250, 500, 1000, 2000];
    let lastOk = 0;

    for (const size of sizes) {
        const code1 = generateCode(size);
        const code2 = generateCode(size);
        const chars = code1.length;

        const { ok, result, ms } = await measure(() =>
            post('/api/compare', { answer1: code1, answer2: code2, language: 'javascript' }, 60000)
        );

        if (ok && result.status === 200) {
            lastOk = size;
            record(`AST ${size} funciones (${(chars/1024).toFixed(0)}KB)`, true, ms,
                `similarity=${result.body.similarity}%`);
        } else {
            record(`AST ${size} funciones (${(chars/1024).toFixed(0)}KB)`, false, ms,
                ok ? `HTTP ${result.status}` : `ERROR: ${result?.error || 'timeout'}`);
            break;
        }
    }

    console.log(`\n  📊 Límite AST: ${lastOk} funciones procesadas OK`);
    return lastOk;
}

// ─── TEST 2: Ráfagas de evaluación concurrente ──────────────────────────────

async function testEvaluationBurst() {
    console.log('\n╔══════════════════════════════════════════════════════════╗');
    console.log('║  TEST 2: RÁFAGAS DE EVALUACIÓN CONCURRENTE             ║');
    console.log('╚══════════════════════════════════════════════════════════╝\n');

    const burstSizes = [5, 10, 20, 50];
    const student = 'function fibonacci(n) {\n  if (n <= 1) return n;\n  return fibonacci(n-1) + fibonacci(n-2);\n}';
    const teacher = 'function fib(n) {\n  if (n <= 1) return n;\n  return fib(n-1) + fib(n-2);\n}';

    for (const burst of burstSizes) {
        const t0 = Date.now();
        const promises = [];
        for (let i = 0; i < burst; i++) {
            promises.push(
                post('/api/evaluate', { studentAnswer: student, teacherSolution: teacher, language: 'javascript' }, 60000)
                    .then(r => ({ ok: true, status: r.status }))
                    .catch(e => ({ ok: false, error: e.message }))
            );
        }
        const results = await Promise.all(promises);
        const ms = Date.now() - t0;
        const succeeded = results.filter(r => r.ok && r.status === 200).length;
        const failed = burst - succeeded;
        const avgMs = Math.round(ms / burst);

        record(`Ráfaga de ${burst} evaluaciones`, failed === 0, ms,
            `${succeeded}/${burst} OK, avg=${avgMs}ms/req`);
    }
}

// ─── TEST 3: Plagio N×N (muchos alumnos) ────────────────────────────────────

async function testPlagiarismNxN() {
    console.log('\n╔══════════════════════════════════════════════════════════╗');
    console.log('║  TEST 3: DETECCIÓN DE PLAGIO N×N                       ║');
    console.log('╚══════════════════════════════════════════════════════════╝\n');

    const studentCounts = [5, 10, 20, 30, 50];

    for (const n of studentCounts) {
        // Generar N códigos ligeramente diferentes
        const codes = [];
        for (let i = 0; i < n; i++) {
            codes.push(`function solve_${i}(x) {\n  let r = x * ${i + 1};\n  for (let j=0; j<${i+1}; j++) r += j;\n  return r;\n}`);
        }

        const comparisons = (n * (n - 1)) / 2;
        const t0 = Date.now();
        let completed = 0;
        let errors = 0;

        // Hacer todas las comparaciones par a par
        const promises = [];
        for (let i = 0; i < n; i++) {
            for (let j = i + 1; j < n; j++) {
                promises.push(
                    post('/api/compare', { answer1: codes[i], answer2: codes[j], language: 'javascript' }, 30000)
                        .then(r => { if (r.status === 200) completed++; else errors++; })
                        .catch(() => errors++)
                );
            }
        }
        await Promise.all(promises);
        const ms = Date.now() - t0;

        record(`Plagio ${n} alumnos (${comparisons} comparaciones)`, errors === 0, ms,
            `${completed}/${comparisons} OK, ${(ms/1000).toFixed(1)}s total`);
    }
}

// ─── TEST 4: Payloads maliciosos y edge cases ───────────────────────────────

async function testMaliciousPayloads() {
    console.log('\n╔══════════════════════════════════════════════════════════╗');
    console.log('║  TEST 4: PAYLOADS MALICIOSOS Y EDGE CASES              ║');
    console.log('╚══════════════════════════════════════════════════════════╝\n');

    const cases = [
        { name: 'String vacío', a1: '', a2: '' },
        { name: 'Null bytes', a1: 'function\0 test() {}', a2: 'function test() {}' },
        { name: 'XSS en código', a1: '<script>alert("xss")</script>', a2: 'console.log("safe")' },
        { name: 'SQL injection', a1: "'; DROP TABLE users; --", a2: 'SELECT * FROM users' },
        { name: 'Unicode extremo', a1: '函数 = (x) => x * 2; // 日本語コメント 🚀', a2: 'const f = (x) => x * 2;' },
        { name: 'Solo espacios', a1: '   \n\n\t\t   ', a2: '   \n\n\t\t   ' },
        { name: 'Código binario', a1: '\x00\x01\x02\x03\x04\x05', a2: '\xFF\xFE\xFD' },
        { name: 'Path traversal', a1: '../../../etc/passwd', a2: 'normal code' },
        { name: 'Mega string (1MB)', a1: 'x'.repeat(1024 * 1024), a2: 'y'.repeat(1024 * 1024) },
        { name: 'JSON injection', a1: '{"__proto__":{"admin":true}}', a2: '{}' },
        { name: 'Regex DoS (ReDoS)', a1: 'a'.repeat(50) + '!', a2: 'aaaa' },
        { name: 'Newlines masivos', a1: '\n'.repeat(100000), a2: '\n'.repeat(100000) },
    ];

    for (const tc of cases) {
        const { ok, result, ms } = await measure(() =>
            post('/api/compare', { answer1: tc.a1, answer2: tc.a2, language: 'javascript' }, 15000)
        );

        // El servidor NO debe crashear — cualquier respuesta HTTP es aceptable
        const passed = ok && (result.status === 200 || result.status === 400 || result.status === 413);
        record(tc.name, passed, ms,
            ok ? `HTTP ${result.status}` : `CRASH: ${result?.error || 'sin respuesta'}`);
    }
}

// ─── TEST 5: Código extremo ─────────────────────────────────────────────────

async function testExtremeCode() {
    console.log('\n╔══════════════════════════════════════════════════════════╗');
    console.log('║  TEST 5: CÓDIGO EXTREMO                                ║');
    console.log('╚══════════════════════════════════════════════════════════╝\n');

    // 5a. Anidamiento profundo
    const depths = [10, 50, 100, 200, 500];
    for (const d of depths) {
        const code = generateDeepNesting(d);
        const { ok, result, ms } = await measure(() =>
            post('/api/compare', { answer1: code, answer2: code, language: 'javascript' }, 30000)
        );
        const passed = ok && result.status === 200;
        record(`Anidamiento ${d} niveles (${(code.length/1024).toFixed(1)}KB)`, passed, ms,
            ok ? `HTTP ${result.status}` : result?.error);
    }

    // 5b. Muchas funciones pequeñas
    const funcCounts = [100, 500, 1000, 5000];
    for (const fc of funcCounts) {
        let code = '';
        for (let i = 0; i < fc; i++) code += `function f${i}(){return ${i};}\n`;
        const { ok, result, ms } = await measure(() =>
            post('/api/compare', { answer1: code, answer2: code, language: 'javascript' }, 60000)
        );
        const passed = ok && result.status === 200;
        record(`${fc} funciones pequeñas (${(code.length/1024).toFixed(0)}KB)`, passed, ms,
            ok ? `HTTP ${result.status}` : result?.error);
    }

    // 5c. Python con list comprehensions anidadas
    const pyCode = `
import itertools
data = [[[[i*j*k*l for l in range(5)] for k in range(5)] for j in range(5)] for i in range(5)]
result = list(itertools.chain.from_iterable(itertools.chain.from_iterable(itertools.chain.from_iterable(data))))
print(sum(result))
`;
    const { ok: okPy, result: resPy, ms: msPy } = await measure(() =>
        post('/api/compare', { answer1: pyCode, answer2: pyCode, language: 'python' }, 15000)
    );
    record('Python comprehensions anidadas', okPy && resPy.status === 200, msPy,
        okPy ? `similarity=${resPy.body?.similarity}%` : resPy?.error);

    // 5d. Código con 10000 líneas de comentarios
    let commentCode = '';
    for (let i = 0; i < 10000; i++) commentCode += `// Comment line ${i}\n`;
    commentCode += 'function real() { return 42; }';
    const { ok: okC, result: resC, ms: msC } = await measure(() =>
        post('/api/compare', { answer1: commentCode, answer2: 'function real() { return 42; }', language: 'javascript' }, 30000)
    );
    record('10000 líneas de comentarios + 1 función', okC && resC.status === 200, msC,
        okC ? `similarity=${resC.body?.similarity}%` : resC?.error);
}

// ─── TEST 6: Concurrencia sostenida ─────────────────────────────────────────

async function testSustainedConcurrency() {
    console.log('\n╔══════════════════════════════════════════════════════════╗');
    console.log('║  TEST 6: CONCURRENCIA SOSTENIDA (30 segundos)          ║');
    console.log('╚══════════════════════════════════════════════════════════╝\n');

    const durationMs = 30000;
    const concurrency = 10;
    let totalRequests = 0;
    let successCount = 0;
    let errorCount = 0;
    let minMs = Infinity;
    let maxMs = 0;
    let totalMs = 0;

    const code1 = 'function add(a,b) { return a + b; }';
    const code2 = 'function sum(x,y) { return x + y; }';

    const startTime = Date.now();

    async function worker() {
        while (Date.now() - startTime < durationMs) {
            const t0 = Date.now();
            try {
                const r = await post('/api/compare', { answer1: code1, answer2: code2, language: 'javascript' }, 10000);
                const elapsed = Date.now() - t0;
                totalRequests++;
                if (r.status === 200) successCount++;
                else errorCount++;
                minMs = Math.min(minMs, elapsed);
                maxMs = Math.max(maxMs, elapsed);
                totalMs += elapsed;
            } catch {
                totalRequests++;
                errorCount++;
            }
        }
    }

    const workers = [];
    for (let i = 0; i < concurrency; i++) workers.push(worker());
    await Promise.all(workers);

    const elapsed = Date.now() - startTime;
    const rps = (totalRequests / (elapsed / 1000)).toFixed(1);
    const avgMs = totalRequests > 0 ? Math.round(totalMs / totalRequests) : 0;

    record(`${concurrency} workers × 30s`, errorCount === 0, elapsed,
        `${totalRequests} reqs, ${rps} req/s, avg=${avgMs}ms, min=${minMs}ms, max=${maxMs}ms`);

    if (errorCount > 0) {
        record(`Errores en concurrencia`, false, 0, `${errorCount}/${totalRequests} fallaron`);
    }

    return { totalRequests, successCount, errorCount, rps, avgMs, minMs, maxMs };
}

// ─── MAIN ────────────────────────────────────────────────────────────────────

async function main() {
    console.log('');
    console.log('╔══════════════════════════════════════════════════════════╗');
    console.log('║                                                          ║');
    console.log('║   🔥 PRUEBA DE ESTRÉS — AI Assignment Plugin v2.4.0    ║');
    console.log('║                                                          ║');
    console.log('╚══════════════════════════════════════════════════════════╝');
    console.log(`\n  Servidor: ${BASE}`);
    console.log(`  Fecha:    ${new Date().toLocaleString()}`);

    // Verificar que el servidor esté corriendo
    try {
        await post('/api/compare', { answer1: 'x=1', answer2: 'x=1', language: 'javascript' }, 5000);
        console.log('  Estado:   ✅ Servidor respondiendo\n');
    } catch {
        console.error('\n  ❌ ERROR: El servidor no está corriendo en ' + BASE);
        console.error('  Ejecuta primero: npm start\n');
        process.exit(1);
    }

    const t0 = Date.now();

    // Ejecutar todos los tests
    const astLimit = await testASTScalability();
    await testEvaluationBurst();
    await testPlagiarismNxN();
    await testMaliciousPayloads();
    await testExtremeCode();
    const concurrencyStats = await testSustainedConcurrency();

    const totalTime = ((Date.now() - t0) / 1000).toFixed(1);

    // ─── REPORTE FINAL ──────────────────────────────────────────────────────

    const passed = RESULTS.filter(r => r.passed).length;
    const failed = RESULTS.filter(r => !r.passed).length;
    const total = RESULTS.length;

    console.log('\n');
    console.log('╔══════════════════════════════════════════════════════════╗');
    console.log('║                  REPORTE FINAL                          ║');
    console.log('╚══════════════════════════════════════════════════════════╝');
    console.log('');
    console.log(`  Total de pruebas:    ${total}`);
    console.log(`  Pasaron:             ${passed} ✅`);
    console.log(`  Fallaron:            ${failed} ❌`);
    console.log(`  Tasa de éxito:       ${((passed/total)*100).toFixed(1)}%`);
    console.log(`  Tiempo total:        ${totalTime}s`);
    console.log('');
    console.log('  ── LÍMITES DETECTADOS ──');
    console.log('');
    console.log(`  AST Comparator:      ${astLimit} funciones (máx procesado OK)`);
    console.log(`  Concurrencia:        ${concurrencyStats.rps} req/s sostenido`);
    console.log(`  Latencia promedio:   ${concurrencyStats.avgMs}ms`);
    console.log(`  Latencia mínima:     ${concurrencyStats.minMs}ms`);
    console.log(`  Latencia máxima:     ${concurrencyStats.maxMs}ms`);
    console.log(`  Errores concurrencia:${concurrencyStats.errorCount}`);
    console.log('');

    if (failed > 0) {
        console.log('  ── PRUEBAS FALLIDAS ──');
        console.log('');
        RESULTS.filter(r => !r.passed).forEach(r => {
            console.log(`  ❌ #${r.n} ${r.name}: ${r.detail}`);
        });
        console.log('');
    }

    console.log('  ── RECOMENDACIONES ──');
    console.log('');
    if (astLimit < 500) {
        console.log('  ⚠️  AST: Limitar tamaño de código a ~500 funciones para evitar timeouts');
    }
    if (concurrencyStats.errorCount > 0) {
        console.log('  ⚠️  Concurrencia: Hay errores bajo carga — considerar rate limiting en el servidor');
    }
    if (concurrencyStats.maxMs > 5000) {
        console.log('  ⚠️  Latencia: Picos de >5s detectados — revisar timeouts del servidor');
    }
    if (concurrencyStats.avgMs > 1000) {
        console.log('  ⚠️  Rendimiento: Latencia promedio >1s — considerar caché de resultados');
    }
    console.log('  ✅ Ejecutar con Moodle real para pruebas de BD y evaluación con OpenAI');
    console.log('');
}

main().catch(e => {
    console.error('Error fatal:', e);
    process.exit(1);
});
