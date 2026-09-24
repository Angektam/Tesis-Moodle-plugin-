/**
 * Genera el script SQL de prueba de estrés con 100 alumnos × 3 tareas.
 * Ejecutar: node scripts/generar-test-estres.js
 * Resultado: scripts/test-estres-100-alumnos.sql
 */
const fs = require('fs');
const path = require('path');

const TOTAL_STUDENTS = 100;
const OUTPUT = path.join(__dirname, 'test-estres-100-alumnos.sql');

const nombres = [
  'Carlos','María','Pedro','Ana','Luis','Sofía','Diego','Valentina','Andrés','Camila',
  'Sebastián','Isabella','Mateo','Lucía','Nicolás','Gabriela','Felipe','Daniela','Tomás','Valeria',
  'Emilio','Renata','Joaquín','Mariana','Rodrigo','Natalia','Alejandro','Paula','Ignacio','Catalina',
  'Fernando','Elena','Ricardo','Mónica','Héctor','Adriana','Óscar','Fernanda','Raúl','Lorena',
  'Arturo','Claudia','Enrique','Patricia','Gerardo','Verónica','Alberto','Silvia','Javier','Teresa',
  'Manuel','Rosa','Francisco','Carmen','Eduardo','Alicia','Roberto','Beatriz','Alfredo','Gloria',
  'Gustavo','Irene','Sergio','Pilar','Ramón','Cristina','Víctor','Laura','Ernesto','Sandra',
  'Armando','Leticia','Rubén','Norma','Ángel','Estela','César','Yolanda','Hugo','Martha',
  'Iván','Rocío','Julio','Graciela','Miguel','Elisa','Rafael','Josefina','Guillermo','Esperanza',
  'Martín','Olivia','Esteban','Jimena','Damián','Abril','Maximiliano','Florencia','Santiago','Agustina'
];
const apellidos = [
  'García','López','Martínez','Rodríguez','Hernández','Jiménez','Torres','Flores','Vargas','Reyes',
  'Cruz','Morales','Ortiz','Mendoza','Castillo','Ramos','Gutiérrez','Sánchez','Ramírez','Núñez',
  'Peña','Aguilar','Medina','Vega','Herrera','Ríos','Mora','Delgado','Fuentes','Espinoza',
  'Salazar','Rojas','Navarro','Guerrero','Campos','Molina','Domínguez','Suárez','Romero','Díaz',
  'Acosta','Bravo','Cabrera','Calderón','Carrillo','Cervantes','Contreras','Córdoba','Cortés','Duarte',
  'Estrada','Figueroa','Franco','Gallegos','Garrido','Gil','Gómez','González','Ibarra','Juárez',
  'León','Luna','Maldonado','Marin','Mejía','Miranda','Montoya','Muñoz','Ochoa','Orozco',
  'Pacheco','Padilla','Paredes','Pedraza','Peralta','Ponce','Quintero','Rivera','Rosales','Rubio',
  'Ruiz','Salas','Sandoval','Santos','Soto','Téllez','Trejo','Valdez','Valencia','Vázquez',
  'Velasco','Vera','Villalobos','Villanueva','Zamora','Zavala','Zúñiga','Arce','Ávila','Bautista'
];

// Códigos base para 3 tareas distintas
const tarea1_codigos = {
  plagio_base: `def factorial(n):\\n    if n == 0 or n == 1:\\n        return 1\\n    return n * factorial(n - 1)\\n\\nprint(factorial(5))\\nprint(factorial(10))`,
  variantes_plagio: [
    (i) => `def calc_fact_${i}(num):\\n    if num == 0 or num == 1:\\n        return 1\\n    return num * calc_fact_${i}(num - 1)\\n\\nprint(calc_fact_${i}(5))`,
    (i) => `def fact(x):\\n    # alumno ${i}\\n    if x <= 1:\\n        return 1\\n    return x * fact(x - 1)\\n\\nresult = fact(5)\\nprint(result)`,
    (i) => `def factorial(n):\\n    aux_${i} = 0\\n    if n == 1 or n == 0:\\n        return 1\\n    result = n * factorial(n - 1)\\n    return result\\n\\nprint(factorial(5))`,
  ],
  sospechosos: [
    (i) => `def factorial_iter(n):\\n    resultado = 1\\n    while n > 1:\\n        resultado *= n\\n        n -= 1\\n    return resultado\\n\\n# version ${i}\\nprint(factorial_iter(5))`,
    (i) => `def factorial(n):\\n    resultado = 1\\n    for i in range(1, n+1):\\n        resultado = resultado * i\\n    return resultado\\n\\n# v${i}\\nprint(factorial(5))`,
  ],
  originales: [
    (i) => `import math\\n\\ndef factorial_v${i}(n):\\n    return math.prod(range(1, n+1)) if n > 0 else 1\\n\\nprint(factorial_v${i}(5))`,
    (i) => `cache_${i} = {}\\ndef factorial(n):\\n    if n in cache_${i}: return cache_${i}[n]\\n    if n <= 1: return 1\\n    cache_${i}[n] = n * factorial(n-1)\\n    return cache_${i}[n]\\nprint(factorial(10))`,
    (i) => `from functools import reduce\\ndef fact_${i}(n):\\n    if n == 0: return 1\\n    return reduce(lambda x,y: x*y, range(1,n+1))\\nprint(fact_${i}(5))`,
    (i) => `def factorial_stack_${i}(n):\\n    stack = list(range(2, n+1))\\n    result = 1\\n    while stack: result *= stack.pop()\\n    return result\\nprint(factorial_stack_${i}(10))`,
  ]
};

const tarea2_codigos = {
  plagio_base: `def bubble_sort(arr):\\n    n = len(arr)\\n    for i in range(n):\\n        for j in range(0, n-i-1):\\n            if arr[j] > arr[j+1]:\\n                arr[j], arr[j+1] = arr[j+1], arr[j]\\n    return arr\\n\\nprint(bubble_sort([64,34,25,12,22,11,90]))`,
  variantes_plagio: [
    (i) => `def ordenar_${i}(lista):\\n    tam = len(lista)\\n    for i in range(tam):\\n        for j in range(0, tam-i-1):\\n            if lista[j] > lista[j+1]:\\n                lista[j], lista[j+1] = lista[j+1], lista[j]\\n    return lista\\nprint(ordenar_${i}([5,3,8,1]))`,
    (i) => `def sort_burbuja(arr):\\n    # alumno ${i}\\n    n = len(arr)\\n    for i in range(n):\\n        for j in range(0, n-i-1):\\n            if arr[j] > arr[j+1]:\\n                temp = arr[j]\\n                arr[j] = arr[j+1]\\n                arr[j+1] = temp\\n    return arr\\nprint(sort_burbuja([9,1,5]))`,
  ],
  sospechosos: [
    (i) => `def bubble_opt_${i}(arr):\\n    n = len(arr)\\n    for i in range(n):\\n        swapped = False\\n        for j in range(0, n-i-1):\\n            if arr[j] > arr[j+1]:\\n                arr[j], arr[j+1] = arr[j+1], arr[j]\\n                swapped = True\\n        if not swapped: break\\n    return arr\\nprint(bubble_opt_${i}([3,1,2]))`,
  ],
  originales: [
    (i) => `def selection_sort_${i}(arr):\\n    for i in range(len(arr)):\\n        min_idx = i\\n        for j in range(i+1, len(arr)):\\n            if arr[j] < arr[min_idx]: min_idx = j\\n        arr[i], arr[min_idx] = arr[min_idx], arr[i]\\n    return arr\\nprint(selection_sort_${i}([5,2,8]))`,
    (i) => `def merge_sort_${i}(arr):\\n    if len(arr) <= 1: return arr\\n    mid = len(arr)//2\\n    left = merge_sort_${i}(arr[:mid])\\n    right = merge_sort_${i}(arr[mid:])\\n    return merge(left, right)\\ndef merge(l,r):\\n    res=[]\\n    i=j=0\\n    while i<len(l) and j<len(r):\\n        if l[i]<=r[j]: res.append(l[i]); i+=1\\n        else: res.append(r[j]); j+=1\\n    res.extend(l[i:]); res.extend(r[j:])\\n    return res\\nprint(merge_sort_${i}([5,2,8]))`,
    (i) => `def quick_sort_${i}(arr):\\n    if len(arr)<=1: return arr\\n    pivot=arr[len(arr)//2]\\n    left=[x for x in arr if x<pivot]\\n    mid=[x for x in arr if x==pivot]\\n    right=[x for x in arr if x>pivot]\\n    return quick_sort_${i}(left)+mid+quick_sort_${i}(right)\\nprint(quick_sort_${i}([5,2,8]))`,
  ]
};

const tarea3_codigos = {
  plagio_base: `def fibonacci(n):\\n    if n <= 0: return 0\\n    if n == 1: return 1\\n    return fibonacci(n-1) + fibonacci(n-2)\\n\\nfor i in range(10): print(fibonacci(i))`,
  variantes_plagio: [
    (i) => `def fib_${i}(num):\\n    if num <= 0: return 0\\n    if num == 1: return 1\\n    return fib_${i}(num-1) + fib_${i}(num-2)\\nfor i in range(10): print(fib_${i}(i))`,
    (i) => `def fibonacci(n):\\n    # version ${i}\\n    if n <= 0: return 0\\n    elif n == 1: return 1\\n    else: return fibonacci(n-1) + fibonacci(n-2)\\nfor i in range(10): print(fibonacci(i))`,
  ],
  sospechosos: [
    (i) => `def fib_iter_${i}(n):\\n    a, b = 0, 1\\n    for _ in range(n): a, b = b, a+b\\n    return a\\nfor i in range(10): print(fib_iter_${i}(i))`,
  ],
  originales: [
    (i) => `def fib_memo_${i}(n, memo={}):\\n    if n in memo: return memo[n]\\n    if n<=1: return n\\n    memo[n]=fib_memo_${i}(n-1,memo)+fib_memo_${i}(n-2,memo)\\n    return memo[n]\\nprint([fib_memo_${i}(i) for i in range(15)])`,
    (i) => `def fib_gen_${i}():\\n    a,b=0,1\\n    while True:\\n        yield a\\n        a,b=b,a+b\\ng=fib_gen_${i}()\\nprint([next(g) for _ in range(15)])`,
    (i) => `import numpy as np\\ndef fib_matrix_${i}(n):\\n    if n<=0: return 0\\n    M=np.array([[1,1],[1,0]])\\n    result=np.linalg.matrix_power(M,n-1)\\n    return int(result[0][0])\\nprint([fib_matrix_${i}(i) for i in range(1,16)])`,
  ]
};

function esc(s) { return s.replace(/'/g, "''"); }

function getCode(tarea, studentIdx) {
  const t = tarea;
  // 40% plagio (0-39), 20% sospechoso (40-59), 40% original (60-99)
  if (studentIdx < 40) {
    if (studentIdx === 0) return { code: t.plagio_base, score: 92, plag: 8, type: 'ORIGINAL_BASE' };
    const fn = t.variantes_plagio[studentIdx % t.variantes_plagio.length];
    return { code: fn(studentIdx), score: 80 + (studentIdx % 15), plag: 75 + (studentIdx % 20), type: 'PLAGIO' };
  } else if (studentIdx < 60) {
    const fn = t.sospechosos[(studentIdx - 40) % t.sospechosos.length];
    return { code: fn(studentIdx), score: 70 + (studentIdx % 10), plag: 45 + (studentIdx % 25), type: 'SOSPECHOSO' };
  } else {
    const fn = t.originales[(studentIdx - 60) % t.originales.length];
    return { code: fn(studentIdx), score: 85 + (studentIdx % 12), plag: 5 + (studentIdx % 18), type: 'ORIGINAL' };
  }
}

let sql = `-- ============================================================
-- PRUEBA DE ESTRÉS: ${TOTAL_STUDENTS} alumnos × 3 tareas = ${TOTAL_STUDENTS * 3} envíos
-- Generado automáticamente por generar-test-estres.js
-- Objetivo: conocer los límites del plugin bajo carga masiva
-- ============================================================
-- MÉTRICAS ESPERADAS:
--   ${TOTAL_STUDENTS} usuarios (stress01-stress${TOTAL_STUDENTS})
--   3 tareas de programación
--   ${TOTAL_STUDENTS * 3} submissions totales
--   ${TOTAL_STUDENTS * 3} evaluaciones con scores de plagio
--   ${TOTAL_STUDENTS * (TOTAL_STUDENTS - 1) / 2} comparaciones por tarea
--   ${TOTAL_STUDENTS * (TOTAL_STUDENTS - 1) / 2 * 3} comparaciones totales
--   40% plagio directo, 20% sospechoso, 40% original
-- ============================================================

USE moodle;
SET FOREIGN_KEY_CHECKS = 0;

-- ── Método de inscripción ─────────────────────────────────────
INSERT INTO mdl_enrol (enrol, status, courseid, sortorder, timecreated, timemodified)
SELECT 'manual', 0, c.id, 0, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
FROM mdl_course c WHERE c.shortname = 'test'
  AND NOT EXISTS (SELECT 1 FROM mdl_enrol e WHERE e.courseid = c.id AND e.enrol = 'manual');

-- ── PASO 1: Crear ${TOTAL_STUDENTS} usuarios ─────────────────\n`;

for (let i = 1; i <= TOTAL_STUDENTS; i++) {
  const num = String(i).padStart(3, '0');
  const un = `stress${num}`;
  const fn = nombres[(i - 1) % nombres.length];
  const ln = apellidos[(i - 1) % apellidos.length];
  sql += `INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'${un}',MD5('Test1234!'),'${fn}','${ln}','${un}@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='${un}');\n`;
}

// Inscripción masiva
const usernames = Array.from({length: TOTAL_STUDENTS}, (_, i) => `'stress${String(i+1).padStart(3,'0')}'`);
const chunks = [];
for (let i = 0; i < usernames.length; i += 50) {
  chunks.push(usernames.slice(i, i + 50).join(','));
}

sql += `\n-- ── PASO 2: Inscribir al curso ─────────────────────────────\n`;
for (const chunk of chunks) {
  sql += `INSERT INTO mdl_user_enrolments (enrolid, userid, modifierid, timestart, timeend, status, timecreated, timemodified)
SELECT e.id, u.id, 2, UNIX_TIMESTAMP(), 0, 0, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
FROM mdl_user u
JOIN mdl_enrol e ON e.courseid = (SELECT id FROM mdl_course WHERE shortname='test' LIMIT 1) AND e.enrol='manual'
LEFT JOIN mdl_user_enrolments ue ON ue.enrolid=e.id AND ue.userid=u.id
WHERE u.username IN (${chunk}) AND ue.userid IS NULL;\n\n`;
}

sql += `-- ── PASO 3: Asignar rol estudiante ─────────────────────────\n`;
for (const chunk of chunks) {
  sql += `INSERT INTO mdl_role_assignments (roleid, contextid, userid, timemodified, modifierid, component, itemid)
SELECT r.id, ctx.id, u.id, UNIX_TIMESTAMP(), 2, '', 0
FROM mdl_user u
JOIN mdl_role r ON r.shortname='student'
JOIN mdl_context ctx ON ctx.contextlevel=50 AND ctx.instanceid=(SELECT id FROM mdl_course WHERE shortname='test' LIMIT 1)
LEFT JOIN mdl_role_assignments ra ON ra.roleid=r.id AND ra.contextid=ctx.id AND ra.userid=u.id
WHERE u.username IN (${chunk}) AND ra.userid IS NULL;\n\n`;
}

// Crear 3 tareas de estrés
sql += `-- ── PASO 4: Crear 3 tareas de estrés ──────────────────────
INSERT INTO mdl_aiassignment (course, teacher_id, name, intro, introformat, description, type, solution, grade, maxattempts, timecreated, timemodified)
SELECT c.id, 2, 'Stress Test: Factorial', 'Implementa factorial', 0, 'Implementa la función factorial en Python', 'programming',
'def factorial(n):\\n    if n <= 1: return 1\\n    return n * factorial(n-1)', 100, 0, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
FROM mdl_course c WHERE c.shortname='test'
AND NOT EXISTS (SELECT 1 FROM mdl_aiassignment WHERE name='Stress Test: Factorial' AND course=c.id);

INSERT INTO mdl_aiassignment (course, teacher_id, name, intro, introformat, description, type, solution, grade, maxattempts, timecreated, timemodified)
SELECT c.id, 2, 'Stress Test: Ordenamiento', 'Implementa un algoritmo de ordenamiento', 0, 'Implementa bubble sort u otro algoritmo', 'programming',
'def bubble_sort(arr):\\n    n=len(arr)\\n    for i in range(n):\\n        for j in range(n-i-1):\\n            if arr[j]>arr[j+1]: arr[j],arr[j+1]=arr[j+1],arr[j]\\n    return arr', 100, 0, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
FROM mdl_course c WHERE c.shortname='test'
AND NOT EXISTS (SELECT 1 FROM mdl_aiassignment WHERE name='Stress Test: Ordenamiento' AND course=c.id);

INSERT INTO mdl_aiassignment (course, teacher_id, name, intro, introformat, description, type, solution, grade, maxattempts, timecreated, timemodified)
SELECT c.id, 2, 'Stress Test: Fibonacci', 'Implementa la serie de Fibonacci', 0, 'Genera los primeros N números de Fibonacci', 'programming',
'def fibonacci(n):\\n    if n<=0: return 0\\n    if n==1: return 1\\n    return fibonacci(n-1)+fibonacci(n-2)', 100, 0, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
FROM mdl_course c WHERE c.shortname='test'
AND NOT EXISTS (SELECT 1 FROM mdl_aiassignment WHERE name='Stress Test: Fibonacci' AND course=c.id);

`;

// Limpiar envíos previos de stress
sql += `-- ── PASO 5: Limpiar envíos previos de stress ───────────────
DELETE ev FROM mdl_aiassignment_evaluations ev
INNER JOIN mdl_aiassignment_submissions s ON ev.submission = s.id
INNER JOIN mdl_user u ON s.userid = u.id
WHERE u.username LIKE 'stress%';

DELETE s FROM mdl_aiassignment_submissions s
INNER JOIN mdl_user u ON s.userid = u.id
WHERE u.username LIKE 'stress%';

`;

// Insertar envíos para cada tarea
const tareas = [
  { name: 'Stress Test: Factorial', codigos: tarea1_codigos },
  { name: 'Stress Test: Ordenamiento', codigos: tarea2_codigos },
  { name: 'Stress Test: Fibonacci', codigos: tarea3_codigos },
];

for (const tarea of tareas) {
  sql += `-- ── PASO 6: Envíos para "${tarea.name}" ────────────────────\n`;
  
  for (let i = 0; i < TOTAL_STUDENTS; i++) {
    const num = String(i + 1).padStart(3, '0');
    const un = `stress${num}`;
    const { code, score, plag, type } = getCode(tarea.codigos, i);
    
    sql += `INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, '${esc(code)}', 'evaluated', ${score.toFixed(2)}, '${type}: stress test alumno ${num}', 1, UNIX_TIMESTAMP()-${Math.floor(Math.random()*86400*7)}, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='${un}'
WHERE c.shortname='test' AND a.name='${tarea.name}';\n`;
  }
  sql += '\n';
}

// Insertar evaluaciones con scores de plagio
sql += `-- ── PASO 7: Evaluaciones con scores de plagio ──────────────\n`;
for (const tarea of tareas) {
  sql += `INSERT INTO mdl_aiassignment_evaluations (submission, similarity_score, ai_feedback, ai_analysis, timecreated)
SELECT s.id,
  CASE
    WHEN u.username REGEXP 'stress0[0-3][0-9]$' AND CAST(SUBSTRING(u.username,7) AS UNSIGNED) <= 40
      THEN 75 + (CAST(SUBSTRING(u.username,7) AS UNSIGNED) % 20)
    WHEN u.username REGEXP 'stress0[4-5][0-9]$' AND CAST(SUBSTRING(u.username,7) AS UNSIGNED) BETWEEN 41 AND 60
      THEN 45 + (CAST(SUBSTRING(u.username,7) AS UNSIGNED) % 25)
    ELSE 5 + (CAST(SUBSTRING(u.username,7) AS UNSIGNED) % 18)
  END,
  s.feedback, '{}', UNIX_TIMESTAMP()
FROM mdl_aiassignment_submissions s
JOIN mdl_user u ON s.userid = u.id
JOIN mdl_aiassignment a ON s.assignment = a.id
WHERE a.name = '${tarea.name}' AND u.username LIKE 'stress%'
AND NOT EXISTS (SELECT 1 FROM mdl_aiassignment_evaluations e WHERE e.submission = s.id);\n\n`;
}

sql += `SET FOREIGN_KEY_CHECKS = 1;

-- ══════════════════════════════════════════════════════════════
-- VERIFICACIÓN Y MÉTRICAS DE ESTRÉS
-- ══════════════════════════════════════════════════════════════

-- Total de usuarios de estrés
SELECT COUNT(*) AS total_stress_users FROM mdl_user WHERE username LIKE 'stress%';

-- Total de envíos por tarea
SELECT a.name, COUNT(s.id) AS total_submissions
FROM mdl_aiassignment a
JOIN mdl_aiassignment_submissions s ON s.assignment = a.id
JOIN mdl_user u ON s.userid = u.id
WHERE u.username LIKE 'stress%'
GROUP BY a.name;

-- Distribución de plagio
SELECT
  CASE
    WHEN e.similarity_score >= 75 THEN 'PLAGIO (>=75%)'
    WHEN e.similarity_score >= 50 THEN 'SOSPECHOSO (50-74%)'
    ELSE 'ORIGINAL (<50%)'
  END AS nivel,
  COUNT(*) AS cantidad,
  ROUND(AVG(e.similarity_score), 1) AS promedio_similitud,
  ROUND(AVG(s.score), 1) AS promedio_calificacion
FROM mdl_aiassignment_submissions s
JOIN mdl_user u ON s.userid = u.id
JOIN mdl_aiassignment_evaluations e ON e.submission = s.id
WHERE u.username LIKE 'stress%'
GROUP BY nivel
ORDER BY promedio_similitud DESC;

-- Top 10 pares con mayor similitud (para validar el detector)
SELECT
  u.firstname, u.lastname,
  a.name AS tarea,
  s.score AS calificacion,
  e.similarity_score AS pct_plagio,
  s.feedback AS tipo
FROM mdl_aiassignment_submissions s
JOIN mdl_user u ON s.userid = u.id
JOIN mdl_aiassignment a ON s.assignment = a.id
JOIN mdl_aiassignment_evaluations e ON e.submission = s.id
WHERE u.username LIKE 'stress%'
ORDER BY e.similarity_score DESC
LIMIT 20;

-- Métricas de rendimiento esperadas
SELECT
  '${TOTAL_STUDENTS} alumnos' AS escenario,
  COUNT(DISTINCT s.id) AS total_envios,
  COUNT(DISTINCT u.id) AS alumnos_unicos,
  COUNT(DISTINCT a.id) AS tareas,
  ROUND(AVG(s.score), 1) AS promedio_general,
  SUM(CASE WHEN e.similarity_score >= 75 THEN 1 ELSE 0 END) AS alertas_plagio,
  CONCAT(COUNT(DISTINCT u.id) * (COUNT(DISTINCT u.id) - 1) / 2, ' por tarea') AS comparaciones_plagio
FROM mdl_aiassignment_submissions s
JOIN mdl_user u ON s.userid = u.id
JOIN mdl_aiassignment a ON s.assignment = a.id
LEFT JOIN mdl_aiassignment_evaluations e ON e.submission = s.id
WHERE u.username LIKE 'stress%';
`;

fs.writeFileSync(OUTPUT, sql, 'utf8');
console.log(`✅ Script generado: ${OUTPUT}`);
console.log(`   ${TOTAL_STUDENTS} alumnos × 3 tareas = ${TOTAL_STUDENTS * 3} envíos`);
console.log(`   ${TOTAL_STUDENTS * (TOTAL_STUDENTS - 1) / 2 * 3} comparaciones de plagio totales`);
