/**
 * Genera script SQL para 150 alumnos, 6 salones, 3 maestros
 * Ejecutar: node scripts/generar-150-alumnos.js
 * Resultado: scripts/test-150-alumnos-6-salones.sql
 * PREFIJO: oy1n_ (Hostinger)
 */
const fs   = require('fs');
const path = require('path');

const OUTPUT = path.join(__dirname, 'test-150-alumnos-6-salones.sql');

// ── Configuración ─────────────────────────────────────────────
const PREFIJO    = 'oy1n_';   // prefijo de Hostinger
const MAESTROS   = 3;
const SALONES    = 6;         // 2 salones por maestro
const ALUMNOS_POR_SALON = 25; // 25 × 6 = 150 alumnos
const TAREAS_POR_SALON  = 2;  // 2 tareas por salón

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
  'Acosta','Bravo','Cabrera','Calderón','Carrillo','Cervantes','Contreras','Córdoba','Cortés','Duarte'
];

// Códigos de prueba con plagio conocido
const codigos = {
  original: (i) => `def factorial_${i}(n):\n    if n <= 1:\n        return 1\n    return n * factorial_${i}(n - 1)\n\nprint(factorial_${i}(5))`,
  plagio:   (i) => `def calc_fact_${i}(num):\n    if num <= 1:\n        return 1\n    return num * calc_fact_${i}(num - 1)\n\nprint(calc_fact_${i}(5))`,
  sospechoso: (i) => `def fact_iter_${i}(n):\n    resultado = 1\n    while n > 1:\n        resultado *= n\n        n -= 1\n    return resultado\n\nprint(fact_iter_${i}(5))`,
  sort_orig: (i) => `def bubble_sort_${i}(arr):\n    n = len(arr)\n    for i in range(n):\n        for j in range(n-i-1):\n            if arr[j] > arr[j+1]:\n                arr[j], arr[j+1] = arr[j+1], arr[j]\n    return arr\n\nprint(bubble_sort_${i}([5,3,8,1,9]))`,
  sort_plagio: (i) => `def ordenar_${i}(lista):\n    tam = len(lista)\n    for i in range(tam):\n        for j in range(tam-i-1):\n            if lista[j] > lista[j+1]:\n                lista[j], lista[j+1] = lista[j+1], lista[j]\n    return lista\n\nprint(ordenar_${i}([5,3,8,1,9]))`,
};

function esc(s) { return s.replace(/\\/g, '\\\\').replace(/'/g, "\\'"); }
function nombre(i) { return nombres[i % nombres.length]; }
function apellido(i) { return apellidos[i % apellidos.length]; }

// Distribución de plagio: 40% plagio, 20% sospechoso, 40% original
function getTipo(idx) {
  if (idx % 5 === 0) return 'original';
  if (idx % 5 === 1 || idx % 5 === 2) return 'plagio';
  if (idx % 5 === 3) return 'sospechoso';
  return 'original';
}
function getCodigo(idx, tarea) {
  const tipo = getTipo(idx);
  if (tarea % 2 === 0) {
    if (tipo === 'plagio')     return esc(codigos.plagio(idx));
    if (tipo === 'sospechoso') return esc(codigos.sospechoso(idx));
    return esc(codigos.original(idx));
  } else {
    if (tipo === 'plagio')     return esc(codigos.sort_plagio(idx));
    if (tipo === 'sospechoso') return esc(codigos.sospechoso(idx));
    return esc(codigos.sort_orig(idx));
  }
}
function getScore(idx) { return 70 + (idx % 25); }
function getPlag(idx) {
  const tipo = getTipo(idx);
  if (tipo === 'plagio')     return 75 + (idx % 20);
  if (tipo === 'sospechoso') return 45 + (idx % 25);
  return 5 + (idx % 18);
}

const P = PREFIJO;
let sql = `-- ============================================================
-- TEST MASIVO: 150 alumnos × 6 salones × 3 maestros
-- Generado por generar-150-alumnos.js
-- Prefijo: ${P} (Hostinger)
-- Contraseña de todos: Test1234!
-- ============================================================
-- RESUMEN:
--   3 maestros (maestro01, maestro02, maestro03)
--   6 cursos (salon01 a salon06) — 2 por maestro
--   150 alumnos (al01_s01 a al25_s06) — 25 por salón
--   12 tareas (2 por salón)
--   300 envíos (2 por alumno)
--   Distribución: 40% plagio, 20% sospechoso, 40% original
-- ============================================================

SET FOREIGN_KEY_CHECKS = 0;

-- ══════════════════════════════════════════════════════════════
-- PASO 1: Crear 3 maestros
-- ══════════════════════════════════════════════════════════════
`;

// Maestros
for (let m = 1; m <= MAESTROS; m++) {
  const un = `maestro0${m}`;
  const fn = ['Yobani','Herman','Geovany'][m-1];
  const ln = ['Martínez Ramírez','Ayala Zúñiga','López Pérez'][m-1];
  sql += `INSERT INTO ${P}user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'${un}','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','${fn}','${ln}','${un}@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM ${P}user WHERE username='${un}');\n\n`;
}

// Cursos (6 salones)
sql += `-- ══════════════════════════════════════════════════════════════
-- PASO 2: Crear 6 cursos (salones)
-- ══════════════════════════════════════════════════════════════
`;
const materias = ['Programación I','Programación II','Estructuras de Datos','Algoritmos','Bases de Datos','Ingeniería de Software'];
for (let s = 1; s <= SALONES; s++) {
  const sn = `salon0${s}`;
  const fn = materias[s-1];
  sql += `INSERT INTO ${P}course (category,fullname,shortname,summary,format,startdate,timecreated,timemodified)
SELECT 1,'${fn} — Salón ${s}','${sn}','Curso de prueba salón ${s}','topics',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM ${P}course WHERE shortname='${sn}');\n\n`;
}

// Método de inscripción para cada salón
sql += `-- ══════════════════════════════════════════════════════════════
-- PASO 3: Métodos de inscripción
-- ══════════════════════════════════════════════════════════════
`;
for (let s = 1; s <= SALONES; s++) {
  const sn = `salon0${s}`;
  sql += `INSERT INTO ${P}enrol (enrol,status,courseid,sortorder,timecreated,timemodified)
SELECT 'manual',0,c.id,0,UNIX_TIMESTAMP(),UNIX_TIMESTAMP() FROM ${P}course c
WHERE c.shortname='${sn}' AND NOT EXISTS (SELECT 1 FROM ${P}enrol e WHERE e.courseid=c.id AND e.enrol='manual');\n\n`;
}

// Maestros → inscribir como editingteacher en sus 2 salones
sql += `-- ══════════════════════════════════════════════════════════════
-- PASO 4: Inscribir maestros a sus salones (2 salones por maestro)
-- ══════════════════════════════════════════════════════════════
`;
// maestro01 → salon01, salon02 | maestro02 → salon03, salon04 | maestro03 → salon05, salon06
const maestroSalones = {1:[1,2], 2:[3,4], 3:[5,6]};
for (let m = 1; m <= MAESTROS; m++) {
  for (const s of maestroSalones[m]) {
    const sn = `salon0${s}`;
    sql += `INSERT INTO ${P}user_enrolments (enrolid,userid,modifierid,timestart,timeend,status,timecreated,timemodified)
SELECT e.id,u.id,2,UNIX_TIMESTAMP(),0,0,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM ${P}user u JOIN ${P}enrol e ON e.courseid=(SELECT id FROM ${P}course WHERE shortname='${sn}' LIMIT 1) AND e.enrol='manual'
LEFT JOIN ${P}user_enrolments ue ON ue.enrolid=e.id AND ue.userid=u.id
WHERE u.username='maestro0${m}' AND ue.userid IS NULL;\n`;
    sql += `INSERT INTO ${P}role_assignments (roleid,contextid,userid,timemodified,modifierid,component,itemid)
SELECT r.id,ctx.id,u.id,UNIX_TIMESTAMP(),2,'',0
FROM ${P}user u JOIN ${P}role r ON r.shortname='editingteacher'
JOIN ${P}context ctx ON ctx.contextlevel=50 AND ctx.instanceid=(SELECT id FROM ${P}course WHERE shortname='${sn}' LIMIT 1)
LEFT JOIN ${P}role_assignments ra ON ra.roleid=r.id AND ra.contextid=ctx.id AND ra.userid=u.id
WHERE u.username='maestro0${m}' AND ra.userid IS NULL;\n\n`;
  }
}

// 150 alumnos (25 por salón)
sql += `-- ══════════════════════════════════════════════════════════════
-- PASO 5: Crear 150 alumnos (25 por salón)
-- ══════════════════════════════════════════════════════════════
`;
let alumnoIdx = 0;
for (let s = 1; s <= SALONES; s++) {
  for (let a = 1; a <= ALUMNOS_POR_SALON; a++) {
    const un = `al${String(a).padStart(2,'0')}_s0${s}`;
    const fn = nombre(alumnoIdx);
    const ln = apellido(alumnoIdx);
    sql += `INSERT INTO ${P}user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'${un}','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','${fn}','${ln}','${un}@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM ${P}user WHERE username='${un}');\n`;
    alumnoIdx++;
  }
  sql += '\n';
}

// Inscribir alumnos a sus salones
sql += `-- ══════════════════════════════════════════════════════════════
-- PASO 6: Inscribir alumnos a sus salones
-- ══════════════════════════════════════════════════════════════
`;
for (let s = 1; s <= SALONES; s++) {
  const sn = `salon0${s}`;
  const usernames = Array.from({length: ALUMNOS_POR_SALON}, (_,a) =>
    `'al${String(a+1).padStart(2,'0')}_s0${s}'`).join(',');
  sql += `INSERT INTO ${P}user_enrolments (enrolid,userid,modifierid,timestart,timeend,status,timecreated,timemodified)
SELECT e.id,u.id,2,UNIX_TIMESTAMP(),0,0,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM ${P}user u JOIN ${P}enrol e ON e.courseid=(SELECT id FROM ${P}course WHERE shortname='${sn}' LIMIT 1) AND e.enrol='manual'
LEFT JOIN ${P}user_enrolments ue ON ue.enrolid=e.id AND ue.userid=u.id
WHERE u.username IN (${usernames}) AND ue.userid IS NULL;\n`;
  sql += `INSERT INTO ${P}role_assignments (roleid,contextid,userid,timemodified,modifierid,component,itemid)
SELECT r.id,ctx.id,u.id,UNIX_TIMESTAMP(),2,'',0
FROM ${P}user u JOIN ${P}role r ON r.shortname='student'
JOIN ${P}context ctx ON ctx.contextlevel=50 AND ctx.instanceid=(SELECT id FROM ${P}course WHERE shortname='${sn}' LIMIT 1)
LEFT JOIN ${P}role_assignments ra ON ra.roleid=r.id AND ra.contextid=ctx.id AND ra.userid=u.id
WHERE u.username IN (${usernames}) AND ra.userid IS NULL;\n\n`;
}

// Crear 2 tareas por salón (12 tareas total)
sql += `-- ══════════════════════════════════════════════════════════════
-- PASO 7: Crear 2 tareas por salón (12 tareas total)
-- ══════════════════════════════════════════════════════════════
`;
const tareaNames = ['Factorial recursivo','Algoritmo de ordenamiento'];
for (let s = 1; s <= SALONES; s++) {
  for (let t = 0; t < TAREAS_POR_SALON; t++) {
    const tname = `${tareaNames[t]} — Salón ${s}`;
    const sol = t === 0
      ? `def factorial(n):\\n    if n<=1: return 1\\n    return n*factorial(n-1)`
      : `def bubble_sort(arr):\\n    n=len(arr)\\n    for i in range(n):\\n        for j in range(n-i-1):\\n            if arr[j]>arr[j+1]: arr[j],arr[j+1]=arr[j+1],arr[j]\\n    return arr`;
    sql += `INSERT INTO ${P}aiassignment (course,teacher_id,name,intro,introformat,description,type,solution,grade,maxattempts,timecreated,timemodified)
SELECT c.id,(SELECT id FROM ${P}user WHERE username='maestro0${Math.ceil(s/2)}' LIMIT 1),
'${tname}','Implementa el algoritmo en Python',0,'Tarea de programación salón ${s}','programming','${sol}',100,0,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM ${P}course c WHERE c.shortname='salon0${s}'
AND NOT EXISTS (SELECT 1 FROM ${P}aiassignment WHERE name='${tname}' AND course=c.id);\n\n`;
  }
}

// Limpiar envíos previos de prueba
sql += `-- ══════════════════════════════════════════════════════════════
-- PASO 8: Limpiar envíos previos de estos alumnos
-- ══════════════════════════════════════════════════════════════
DELETE ev FROM ${P}aiassignment_evaluations ev
INNER JOIN ${P}aiassignment_submissions s ON ev.submission=s.id
INNER JOIN ${P}user u ON s.userid=u.id
WHERE u.username LIKE 'al%_s0%';\n\n`;
sql += `DELETE s FROM ${P}aiassignment_submissions s
INNER JOIN ${P}user u ON s.userid=u.id
WHERE u.username LIKE 'al%_s0%';\n\n`;

// Insertar envíos
sql += `-- ══════════════════════════════════════════════════════════════
-- PASO 9: Insertar envíos (300 total — 2 por alumno)
-- ══════════════════════════════════════════════════════════════
`;
alumnoIdx = 0;
for (let s = 1; s <= SALONES; s++) {
  for (let t = 0; t < TAREAS_POR_SALON; t++) {
    const tname = `${tareaNames[t]} — Salón ${s}`;
    for (let a = 1; a <= ALUMNOS_POR_SALON; a++) {
      const un = `al${String(a).padStart(2,'0')}_s0${s}`;
      const idx = (s-1)*ALUMNOS_POR_SALON + (a-1);
      const code = getCodigo(idx, t);
      const score = getScore(idx);
      const tipo = getTipo(idx);
      sql += `INSERT INTO ${P}aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'${code}','evaluated',${score}.00,'${tipo.toUpperCase()}: salón ${s} alumno ${a}',1,UNIX_TIMESTAMP()-${Math.floor(Math.random()*86400*14)},UNIX_TIMESTAMP()
FROM ${P}aiassignment a JOIN ${P}course c ON a.course=c.id JOIN ${P}user u ON u.username='${un}'
WHERE c.shortname='salon0${s}' AND a.name='${tname}';\n`;
    }
  }
  sql += '\n';
}

// Insertar evaluaciones con scores de plagio
sql += `-- ══════════════════════════════════════════════════════════════
-- PASO 10: Insertar evaluaciones con scores de plagio
-- ══════════════════════════════════════════════════════════════
`;
for (let s = 1; s <= SALONES; s++) {
  for (let t = 0; t < TAREAS_POR_SALON; t++) {
    const tname = `${tareaNames[t]} — Salón ${s}`;
    sql += `INSERT INTO ${P}aiassignment_evaluations (submission,similarity_score,ai_feedback,ai_analysis,timecreated)
SELECT s.id,
  CASE
    WHEN MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),5) IN (1,2) THEN 75 + MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),20)
    WHEN MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),5) = 3     THEN 45 + MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),25)
    ELSE 5 + MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),18)
  END,
  s.feedback,'{}',UNIX_TIMESTAMP()
FROM ${P}aiassignment_submissions s
JOIN ${P}user u ON s.userid=u.id
JOIN ${P}aiassignment a ON s.assignment=a.id
WHERE a.name='${tname}' AND u.username LIKE 'al%_s0${s}'
AND NOT EXISTS (SELECT 1 FROM ${P}aiassignment_evaluations e WHERE e.submission=s.id);\n\n`;
  }
}

sql += `SET FOREIGN_KEY_CHECKS = 1;\n\n`;

// Verificación final
sql += `-- ══════════════════════════════════════════════════════════════
-- VERIFICACIÓN FINAL
-- ══════════════════════════════════════════════════════════════
SELECT 'MAESTROS' AS tipo, COUNT(*) AS total FROM ${P}user WHERE username LIKE 'maestro0%'
UNION ALL
SELECT 'ALUMNOS', COUNT(*) FROM ${P}user WHERE username LIKE 'al%_s0%'
UNION ALL
SELECT 'CURSOS', COUNT(*) FROM ${P}course WHERE shortname LIKE 'salon0%'
UNION ALL
SELECT 'TAREAS', COUNT(*) FROM ${P}aiassignment a JOIN ${P}course c ON a.course=c.id WHERE c.shortname LIKE 'salon0%'
UNION ALL
SELECT 'ENVIOS', COUNT(*) FROM ${P}aiassignment_submissions s JOIN ${P}user u ON s.userid=u.id WHERE u.username LIKE 'al%_s0%'
UNION ALL
SELECT 'EVALUACIONES', COUNT(*) FROM ${P}aiassignment_evaluations e JOIN ${P}aiassignment_submissions s ON e.submission=s.id JOIN ${P}user u ON s.userid=u.id WHERE u.username LIKE 'al%_s0%';

-- Distribución de plagio por salón
SELECT
  c.shortname AS salon,
  COUNT(s.id) AS total_envios,
  SUM(CASE WHEN e.similarity_score >= 75 THEN 1 ELSE 0 END) AS plagio_alto,
  SUM(CASE WHEN e.similarity_score >= 50 AND e.similarity_score < 75 THEN 1 ELSE 0 END) AS sospechoso,
  SUM(CASE WHEN e.similarity_score < 50 THEN 1 ELSE 0 END) AS original,
  ROUND(AVG(s.score),1) AS promedio_calificacion
FROM ${P}course c
JOIN ${P}aiassignment a ON a.course=c.id
JOIN ${P}aiassignment_submissions s ON s.assignment=a.id
JOIN ${P}user u ON s.userid=u.id
LEFT JOIN ${P}aiassignment_evaluations e ON e.submission=s.id
WHERE c.shortname LIKE 'salon0%' AND u.username LIKE 'al%_s0%'
GROUP BY c.shortname
ORDER BY c.shortname;
`;

fs.writeFileSync(OUTPUT, sql, 'utf8');
console.log(`✅ Script generado: ${OUTPUT}`);
console.log(`   3 maestros × 6 salones × 25 alumnos = 150 alumnos`);
console.log(`   12 tareas × 25 alumnos = 300 envíos`);
console.log(`   Prefijo: ${P}`);
