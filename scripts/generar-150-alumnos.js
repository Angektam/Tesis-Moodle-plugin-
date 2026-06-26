/**
 * Genera script SQL corregido para 150 alumnos, 6 salones, 3 maestros.
 * Incluye: contextos Moodle, secciones, course_modules, envíos y evaluaciones.
 *
 * Ejecutar: node scripts/generar-150-alumnos.js
 * Resultado: scripts/test-150-alumnos-6-salones.sql
 * Prefijo: oy1n_ (Hostinger) | Contraseña: Test1234!
 */
const fs = require('fs');
const path = require('path');

const OUTPUT = path.join(__dirname, 'test-150-alumnos-6-salones.sql');
const P = 'oy1n_';
const PASS_HASH = '$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u';
const MODIFIER_ID = 2; // usuario admin (ajustar si no es id 2)

const nombres = ['Carlos', 'María', 'Pedro', 'Ana', 'Luis', 'Sofía', 'Diego', 'Valentina', 'Andrés', 'Camila', 'Sebastián', 'Isabella', 'Mateo', 'Lucía', 'Nicolás', 'Gabriela', 'Felipe', 'Daniela', 'Tomás', 'Valeria', 'Emilio', 'Renata', 'Joaquín', 'Mariana', 'Rodrigo'];
const apellidos = ['García', 'López', 'Martínez', 'Rodríguez', 'Hernández', 'Jiménez', 'Torres', 'Flores', 'Vargas', 'Reyes', 'Cruz', 'Morales', 'Ortiz', 'Mendoza', 'Castillo', 'Ramos', 'Gutiérrez', 'Sánchez', 'Ramírez', 'Núñez', 'Peña', 'Aguilar', 'Medina', 'Vega', 'Herrera'];

const SALON_SHORTNAMES = ['salon01', 'salon02', 'salon03', 'salon04', 'salon05', 'salon06'];
const ALUMNO_LIKE = "al%_s0%";

function esc(s) {
  return s.replace(/\\/g, '\\\\').replace(/'/g, "\\'");
}

function getTipo(i) {
  const r = i % 5;
  if (r === 1 || r === 2) return 'plagio';
  if (r === 3) return 'sospechoso';
  return 'original';
}

function getScore(i) {
  return 70 + (i % 25);
}

const CONFIG = [
  {
    user: 'maestro01', fn: 'Yobani', ln: 'Martínez Ramírez',
    salones: [
      { sn: 'salon01', fn: 'Programación I — Salón 1' },
      { sn: 'salon02', fn: 'Programación II — Salón 2' },
    ],
    tareas: [
      {
        nombre: 'Factorial recursivo',
        tipo: 'programming',
        sol: `def factorial(n):\\n    if n<=1: return 1\\n    return n*factorial(n-1)\\nprint(factorial(5))`,
        orig: (i) => `def factorial_${i}(n):\\n    if n<=1: return 1\\n    return n*factorial_${i}(n-1)\\nprint(factorial_${i}(5))`,
        plag: (i) => `def calc_fact_${i}(num):\\n    if num<=1: return 1\\n    return num*calc_fact_${i}(num-1)\\nprint(calc_fact_${i}(5))`,
        sosp: (i) => `def fact_iter_${i}(n):\\n    r=1\\n    while n>1:\\n        r*=n\\n        n-=1\\n    return r\\nprint(fact_iter_${i}(5))`,
      },
      {
        nombre: 'Serie de Fibonacci',
        tipo: 'programming',
        sol: `def fibonacci(n):\\n    a,b=0,1\\n    for _ in range(n):\\n        print(a)\\n        a,b=b,a+b\\nfibonacci(10)`,
        orig: (i) => `def fib_${i}(n):\\n    a,b=0,1\\n    for _ in range(n):\\n        print(a)\\n        a,b=b,a+b\\nfib_${i}(10)`,
        plag: (i) => `def serie_${i}(num):\\n    x,y=0,1\\n    for _ in range(num):\\n        print(x)\\n        x,y=y,x+y\\nserie_${i}(10)`,
        sosp: (i) => `def fib_rec_${i}(n):\\n    if n<=1: return n\\n    return fib_rec_${i}(n-1)+fib_rec_${i}(n-2)\\nfor i in range(10): print(fib_rec_${i}(i))`,
      },
    ],
  },
  {
    user: 'maestro02', fn: 'Herman', ln: 'Ayala Zúñiga',
    salones: [
      { sn: 'salon03', fn: 'Estructuras de Datos — Salón 3' },
      { sn: 'salon04', fn: 'Algoritmos — Salón 4' },
    ],
    tareas: [
      {
        nombre: 'Bubble Sort',
        tipo: 'programming',
        sol: `def bubble_sort(arr):\\n    n=len(arr)\\n    for i in range(n):\\n        for j in range(n-i-1):\\n            if arr[j]>arr[j+1]: arr[j],arr[j+1]=arr[j+1],arr[j]\\n    return arr\\nprint(bubble_sort([5,3,8,1,9]))`,
        orig: (i) => `def bubble_sort_${i}(arr):\\n    n=len(arr)\\n    for i in range(n):\\n        for j in range(n-i-1):\\n            if arr[j]>arr[j+1]: arr[j],arr[j+1]=arr[j+1],arr[j]\\n    return arr\\nprint(bubble_sort_${i}([5,3,8,1]))`,
        plag: (i) => `def ordenar_${i}(lista):\\n    tam=len(lista)\\n    for i in range(tam):\\n        for j in range(tam-i-1):\\n            if lista[j]>lista[j+1]: lista[j],lista[j+1]=lista[j+1],lista[j]\\n    return lista\\nprint(ordenar_${i}([5,3,8,1]))`,
        sosp: (i) => `def bubble_opt_${i}(arr):\\n    n=len(arr)\\n    for i in range(n):\\n        sw=False\\n        for j in range(n-i-1):\\n            if arr[j]>arr[j+1]: arr[j],arr[j+1]=arr[j+1],arr[j]; sw=True\\n        if not sw: break\\n    return arr\\nprint(bubble_opt_${i}([5,3,8,1]))`,
      },
      {
        nombre: 'Búsqueda binaria',
        tipo: 'programming',
        sol: `def binary_search(arr,target):\\n    l,r=0,len(arr)-1\\n    while l<=r:\\n        mid=(l+r)//2\\n        if arr[mid]==target: return mid\\n        elif arr[mid]<target: l=mid+1\\n        else: r=mid-1\\n    return -1\\nprint(binary_search([1,3,5,7,9],7))`,
        orig: (i) => `def binary_search_${i}(arr,target):\\n    l,r=0,len(arr)-1\\n    while l<=r:\\n        mid=(l+r)//2\\n        if arr[mid]==target: return mid\\n        elif arr[mid]<target: l=mid+1\\n        else: r=mid-1\\n    return -1\\nprint(binary_search_${i}([1,3,5,7,9],7))`,
        plag: (i) => `def buscar_${i}(lista,valor):\\n    ini,fin=0,len(lista)-1\\n    while ini<=fin:\\n        medio=(ini+fin)//2\\n        if lista[medio]==valor: return medio\\n        elif lista[medio]<valor: ini=medio+1\\n        else: fin=medio-1\\n    return -1\\nprint(buscar_${i}([1,3,5,7,9],7))`,
        sosp: (i) => `def bin_rec_${i}(arr,t,l=0,r=None):\\n    if r is None: r=len(arr)-1\\n    if l>r: return -1\\n    mid=(l+r)//2\\n    if arr[mid]==t: return mid\\n    if arr[mid]<t: return bin_rec_${i}(arr,t,mid+1,r)\\n    return bin_rec_${i}(arr,t,l,mid-1)\\nprint(bin_rec_${i}([1,3,5,7,9],7))`,
      },
    ],
  },
  {
    user: 'maestro03', fn: 'Geovany', ln: 'López Pérez',
    salones: [
      { sn: 'salon05', fn: 'Bases de Datos — Salón 5' },
      { sn: 'salon06', fn: 'Ingeniería de Software — Salón 6' },
    ],
    tareas: [
      {
        nombre: 'Consulta SQL con JOIN',
        tipo: 'programming',
        sol: `SELECT e.nombre, e.apellido, c.calificacion FROM estudiantes e INNER JOIN calificaciones c ON e.id=c.estudiante_id WHERE c.calificacion>=70 ORDER BY c.calificacion DESC;`,
        orig: (i) => `SELECT e.nombre, e.apellido, c.calificacion FROM estudiantes e INNER JOIN calificaciones c ON e.id=c.estudiante_id WHERE c.calificacion>=70 ORDER BY c.calificacion DESC; -- v${i}`,
        plag: (i) => `SELECT est.nombre, est.apellido, cal.calificacion FROM estudiantes est JOIN calificaciones cal ON est.id=cal.estudiante_id WHERE cal.calificacion>=70 ORDER BY cal.calificacion DESC; -- p${i}`,
        sosp: (i) => `SELECT e.nombre, e.apellido, c.calificacion FROM calificaciones c INNER JOIN estudiantes e ON c.estudiante_id=e.id WHERE c.calificacion>=70 ORDER BY 3 DESC; -- s${i}`,
      },
      {
        nombre: 'Diagrama de clases UML',
        tipo: 'programming',
        sol: `Un sistema de biblioteca tiene las clases: Libro, Usuario, Prestamo y Bibliotecario con sus relaciones.`,
        orig: (i) => `El sistema de biblioteca incluye Libro, Usuario, Prestamo y Bibliotecario. Version ${i}.`,
        plag: (i) => `Diagrama biblioteca: Libro, Usuario, Prestamo, Bibliotecario. Copia ${i}.`,
        sosp: (i) => `Biblioteca modela libros, usuarios y prestamos con fechas. Ref ${i}.`,
      },
    ],
  },
];

const allSalones = CONFIG.flatMap((m) => m.salones);
const shortnameList = SALON_SHORTNAMES.map((s) => `'${s}'`).join(',');

let sql = `-- ============================================================
-- TEST MASIVO CORREGIDO: 150 alumnos × 6 salones × 3 maestros
-- Generado por: node scripts/generar-150-alumnos.js
-- Prefijo: ${P} (Hostinger) | Contraseña: Test1234!
-- ============================================================
-- Incluye: usuarios, cursos, contextos, secciones, course_modules,
--          tareas aiassignment, 300 envíos, 300 evaluaciones.
-- POST-EJECUCIÓN: Administración → Notificaciones (reconstruir caché).
-- ============================================================

SET FOREIGN_KEY_CHECKS = 0;

-- ══════════════════════════════════════════════════════════════
-- PASO 1: Maestros
-- ══════════════════════════════════════════════════════════════
`;

for (const m of CONFIG) {
  sql += `INSERT INTO ${P}user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'${m.user}','${PASS_HASH}','${m.fn}','${m.ln}','${m.user}@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM ${P}user WHERE username='${m.user}');

`;
}

sql += `-- ══════════════════════════════════════════════════════════════
-- PASO 2: Cursos (campos mínimos + visible)
-- ══════════════════════════════════════════════════════════════
`;

for (const s of allSalones) {
  sql += `INSERT INTO ${P}course (category,fullname,shortname,summary,summaryformat,format,startdate,enddate,visible,timecreated,timemodified)
SELECT 1,'${esc(s.fn)}','${s.sn}','Curso de prueba ${esc(s.fn)}',1,'topics',UNIX_TIMESTAMP(),0,1,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM ${P}course WHERE shortname='${s.sn}');

`;
}

sql += `-- ══════════════════════════════════════════════════════════════
-- PASO 3: Contextos de curso (CONTEXT_COURSE = 50)
-- Sin esto, role_assignments no asigna permisos.
-- ══════════════════════════════════════════════════════════════
`;

for (const s of allSalones) {
  sql += `INSERT INTO ${P}context (contextlevel,instanceid,depth,path,locked)
SELECT 50,c.id,0,'',0
FROM ${P}course c
WHERE c.shortname='${s.sn}'
AND NOT EXISTS (SELECT 1 FROM ${P}context ctx WHERE ctx.contextlevel=50 AND ctx.instanceid=c.id);

UPDATE ${P}context ctx
INNER JOIN ${P}course c ON ctx.instanceid=c.id AND ctx.contextlevel=50
SET ctx.path=CONCAT('/1/',ctx.id), ctx.depth=2
WHERE c.shortname='${s.sn}' AND (ctx.path IS NULL OR ctx.path='');

`;
}

sql += `-- ══════════════════════════════════════════════════════════════
-- PASO 4: Secciones del curso (sin timecreated — solo timemodified)
-- ══════════════════════════════════════════════════════════════
`;

for (const s of allSalones) {
  for (const sec of [0, 1]) {
    const name = sec === 0 ? 'General' : 'Tareas';
    sql += `INSERT INTO ${P}course_sections (course,section,name,summary,summaryformat,visible,timemodified)
SELECT c.id,${sec},'${name}','',1,1,UNIX_TIMESTAMP()
FROM ${P}course c
WHERE c.shortname='${s.sn}'
AND NOT EXISTS (SELECT 1 FROM ${P}course_sections cs WHERE cs.course=c.id AND cs.section=${sec});

`;
  }
}

sql += `-- ══════════════════════════════════════════════════════════════
-- PASO 5: Métodos de inscripción manual
-- ══════════════════════════════════════════════════════════════
`;

for (const s of allSalones) {
  sql += `INSERT INTO ${P}enrol (enrol,status,courseid,sortorder,timecreated,timemodified)
SELECT 'manual',0,c.id,0,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM ${P}course c
WHERE c.shortname='${s.sn}'
AND NOT EXISTS (SELECT 1 FROM ${P}enrol e WHERE e.courseid=c.id AND e.enrol='manual');

`;
}

sql += `-- ══════════════════════════════════════════════════════════════
-- PASO 6: Inscribir maestros (editingteacher)
-- ══════════════════════════════════════════════════════════════
`;

for (const m of CONFIG) {
  for (const s of m.salones) {
    sql += `INSERT INTO ${P}user_enrolments (enrolid,userid,modifierid,timestart,timeend,status,timecreated,timemodified)
SELECT e.id,u.id,${MODIFIER_ID},UNIX_TIMESTAMP(),0,0,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM ${P}user u
JOIN ${P}enrol e ON e.courseid=(SELECT id FROM ${P}course WHERE shortname='${s.sn}' LIMIT 1) AND e.enrol='manual'
LEFT JOIN ${P}user_enrolments ue ON ue.enrolid=e.id AND ue.userid=u.id
WHERE u.username='${m.user}' AND ue.userid IS NULL;

INSERT INTO ${P}role_assignments (roleid,contextid,userid,timemodified,modifierid,component,itemid)
SELECT r.id,ctx.id,u.id,UNIX_TIMESTAMP(),${MODIFIER_ID},'',0
FROM ${P}user u
JOIN ${P}role r ON r.shortname='editingteacher'
JOIN ${P}context ctx ON ctx.contextlevel=50 AND ctx.instanceid=(SELECT id FROM ${P}course WHERE shortname='${s.sn}' LIMIT 1)
LEFT JOIN ${P}role_assignments ra ON ra.roleid=r.id AND ra.contextid=ctx.id AND ra.userid=u.id
WHERE u.username='${m.user}' AND ra.userid IS NULL;

`;
  }
}

sql += `-- ══════════════════════════════════════════════════════════════
-- PASO 7: Crear 150 alumnos (idempotente)
-- ══════════════════════════════════════════════════════════════
`;

let salonIdx = 0;
for (const m of CONFIG) {
  for (const s of m.salones) {
    for (let a = 1; a <= 25; a++) {
      const un = `al${String(a).padStart(2, '0')}_${s.sn}`;
      const fn = nombres[(salonIdx * 25 + a - 1) % nombres.length];
      const ln = apellidos[(salonIdx * 25 + a - 1) % apellidos.length];
      sql += `INSERT INTO ${P}user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'${un}','${PASS_HASH}','${fn}','${ln}','${un}@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM ${P}user WHERE username='${un}');

`;
    }
    salonIdx++;
  }
}

sql += `-- ══════════════════════════════════════════════════════════════
-- PASO 8: Inscribir alumnos (student)
-- ══════════════════════════════════════════════════════════════
`;

for (const m of CONFIG) {
  for (const s of m.salones) {
    const uns = Array.from({ length: 25 }, (_, i) => `'al${String(i + 1).padStart(2, '0')}_${s.sn}'`).join(',');
    sql += `INSERT INTO ${P}user_enrolments (enrolid,userid,modifierid,timestart,timeend,status,timecreated,timemodified)
SELECT e.id,u.id,${MODIFIER_ID},UNIX_TIMESTAMP(),0,0,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM ${P}user u
JOIN ${P}enrol e ON e.courseid=(SELECT id FROM ${P}course WHERE shortname='${s.sn}' LIMIT 1) AND e.enrol='manual'
LEFT JOIN ${P}user_enrolments ue ON ue.enrolid=e.id AND ue.userid=u.id
WHERE u.username IN (${uns}) AND ue.userid IS NULL;

INSERT INTO ${P}role_assignments (roleid,contextid,userid,timemodified,modifierid,component,itemid)
SELECT r.id,ctx.id,u.id,UNIX_TIMESTAMP(),${MODIFIER_ID},'',0
FROM ${P}user u
JOIN ${P}role r ON r.shortname='student'
JOIN ${P}context ctx ON ctx.contextlevel=50 AND ctx.instanceid=(SELECT id FROM ${P}course WHERE shortname='${s.sn}' LIMIT 1)
LEFT JOIN ${P}role_assignments ra ON ra.roleid=r.id AND ra.contextid=ctx.id AND ra.userid=u.id
WHERE u.username IN (${uns}) AND ra.userid IS NULL;

`;
  }
}

sql += `-- ══════════════════════════════════════════════════════════════
-- PASO 9: Instancias aiassignment (2 por salón)
-- ══════════════════════════════════════════════════════════════
`;

for (const m of CONFIG) {
  sql += `-- ${m.fn} (${m.user})\n`;
  for (const s of m.salones) {
    for (const t of m.tareas) {
      const tname = `${t.nombre} — ${s.fn}`;
      sql += `INSERT INTO ${P}aiassignment (course,teacher_id,name,intro,introformat,description,type,solution,grade,maxattempts,timecreated,timemodified)
SELECT c.id,(SELECT id FROM ${P}user WHERE username='${m.user}' LIMIT 1),
'${esc(tname)}','${esc(t.nombre)}',1,'Tarea de ${esc(m.fn)}','${t.tipo}','${esc(t.sol)}',100,3,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM ${P}course c
WHERE c.shortname='${s.sn}'
AND NOT EXISTS (SELECT 1 FROM ${P}aiassignment aa WHERE aa.name='${esc(tname)}' AND aa.course=c.id);

`;
    }
  }
}

sql += `-- ══════════════════════════════════════════════════════════════
-- PASO 10: course_modules (actividades visibles en el curso)
-- Requiere que exista el módulo aiassignment en ${P}modules
-- ══════════════════════════════════════════════════════════════
`;

for (const m of CONFIG) {
  for (const s of m.salones) {
    for (const t of m.tareas) {
      const tname = `${t.nombre} — ${s.fn}`;
      // No usar alias "mod" — es palabra reservada en MySQL 8 (función MOD).
      sql += `INSERT INTO ${P}course_modules (course,module,instance,section,added)
SELECT c.id,m.id,a.id,cs.id,UNIX_TIMESTAMP()
FROM ${P}aiassignment a
JOIN ${P}course c ON a.course=c.id
JOIN ${P}modules m ON m.name='aiassignment'
JOIN ${P}course_sections cs ON cs.course=c.id AND cs.section=1
WHERE c.shortname='${s.sn}' AND a.name='${esc(tname)}'
AND NOT EXISTS (
  SELECT 1 FROM ${P}course_modules cm
  WHERE cm.course=c.id AND cm.module=m.id AND cm.instance=a.id
);

`;
    }
  }
}

sql += `-- ══════════════════════════════════════════════════════════════
-- PASO 11: Contextos de módulo (CONTEXT_MODULE = 70)
-- ══════════════════════════════════════════════════════════════
`;

sql += `INSERT INTO ${P}context (contextlevel,instanceid,depth,path,locked)
SELECT 70,cm.id,0,'',0
FROM ${P}course_modules cm
JOIN ${P}modules m ON m.id=cm.module AND m.name='aiassignment'
JOIN ${P}course c ON c.id=cm.course
WHERE c.shortname IN (${shortnameList})
AND NOT EXISTS (SELECT 1 FROM ${P}context ctx WHERE ctx.contextlevel=70 AND ctx.instanceid=cm.id);

UPDATE ${P}context modctx
INNER JOIN ${P}course_modules cm ON modctx.instanceid=cm.id AND modctx.contextlevel=70
INNER JOIN ${P}course c ON c.id=cm.course
INNER JOIN ${P}context crsctx ON crsctx.contextlevel=50 AND crsctx.instanceid=c.id
SET modctx.path=CONCAT(crsctx.path,'/',modctx.id), modctx.depth=crsctx.depth+1
WHERE c.shortname IN (${shortnameList})
AND (modctx.path IS NULL OR modctx.path='');

`;

sql += `-- Actualizar sequence de sección 1 con los cm ids
`;
for (const s of allSalones) {
  sql += `UPDATE ${P}course_sections cs
INNER JOIN ${P}course c ON cs.course=c.id
SET cs.sequence = (
  SELECT GROUP_CONCAT(cm.id ORDER BY cm.id SEPARATOR ',')
  FROM ${P}course_modules cm
  JOIN ${P}modules m ON m.id=cm.module AND m.name='aiassignment'
  WHERE cm.course=c.id AND cm.section=cs.id
)
WHERE c.shortname='${s.sn}' AND cs.section=1;

`;
}

sql += `-- ══════════════════════════════════════════════════════════════
-- PASO 12: Limpiar envíos previos (re-ejecutable)
-- ══════════════════════════════════════════════════════════════
DELETE ev FROM ${P}aiassignment_evaluations ev
INNER JOIN ${P}aiassignment_submissions s ON ev.submission=s.id
INNER JOIN ${P}user u ON s.userid=u.id
WHERE u.username LIKE '${ALUMNO_LIKE}';

DELETE s FROM ${P}aiassignment_submissions s
INNER JOIN ${P}user u ON s.userid=u.id
WHERE u.username LIKE '${ALUMNO_LIKE}';

`;

sql += `-- ══════════════════════════════════════════════════════════════
-- PASO 13: Envíos (300 total, idempotente tras limpieza)
-- ══════════════════════════════════════════════════════════════
`;

for (const m of CONFIG) {
  for (const s of m.salones) {
    for (const t of m.tareas) {
      const tname = `${t.nombre} — ${s.fn}`;
      for (let a = 1; a <= 25; a++) {
        const un = `al${String(a).padStart(2, '0')}_${s.sn}`;
        const tipo = getTipo(a);
        let code;
        if (tipo === 'plagio') code = esc(t.plag(a));
        else if (tipo === 'sospechoso') code = esc(t.sosp(a));
        else code = esc(t.orig(a));
        const score = getScore(a);
        const ago = Math.floor(Math.random() * 86400 * 14);
        sql += `INSERT INTO ${P}aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'${code}','evaluated',${score}.00,'${tipo.toUpperCase()}: ${esc(s.fn)} alumno ${a}',1,UNIX_TIMESTAMP()-${ago},UNIX_TIMESTAMP()
FROM ${P}aiassignment a
JOIN ${P}course c ON a.course=c.id
JOIN ${P}user u ON u.username='${un}'
WHERE c.shortname='${s.sn}' AND a.name='${esc(tname)}'
AND NOT EXISTS (
  SELECT 1 FROM ${P}aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

`;
      }
    }
  }
}

sql += `-- ══════════════════════════════════════════════════════════════
-- PASO 14: Evaluaciones con similitud de plagio
-- ══════════════════════════════════════════════════════════════
`;

for (const m of CONFIG) {
  for (const s of m.salones) {
    for (const t of m.tareas) {
      const tname = `${t.nombre} — ${s.fn}`;
      sql += `INSERT INTO ${P}aiassignment_evaluations (submission,similarity_score,ai_feedback,ai_analysis,timecreated)
SELECT s.id,
  CASE
    WHEN MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),5) IN (1,2) THEN 75+MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),20)
    WHEN MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),5)=3        THEN 45+MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),25)
    ELSE 5+MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),18)
  END,
  s.feedback,'{}',UNIX_TIMESTAMP()
FROM ${P}aiassignment_submissions s
JOIN ${P}user u ON s.userid=u.id
JOIN ${P}aiassignment a ON s.assignment=a.id
WHERE a.name='${esc(tname)}' AND u.username LIKE 'al%_${s.sn}'
AND NOT EXISTS (SELECT 1 FROM ${P}aiassignment_evaluations e WHERE e.submission=s.id);

`;
    }
  }
}

sql += `SET FOREIGN_KEY_CHECKS = 1;

-- ══════════════════════════════════════════════════════════════
-- VERIFICACIÓN FINAL
-- ══════════════════════════════════════════════════════════════
SELECT 'MAESTROS' AS tipo, COUNT(*) AS total FROM ${P}user WHERE username IN ('maestro01','maestro02','maestro03')
UNION ALL
SELECT 'ALUMNOS', COUNT(*) FROM ${P}user WHERE username LIKE '${ALUMNO_LIKE}'
UNION ALL
SELECT 'CURSOS', COUNT(*) FROM ${P}course WHERE shortname IN (${shortnameList})
UNION ALL
SELECT 'CONTEXTOS_CURSO', COUNT(*) FROM ${P}context ctx
  JOIN ${P}course c ON ctx.contextlevel=50 AND ctx.instanceid=c.id
  WHERE c.shortname IN (${shortnameList})
UNION ALL
SELECT 'MODULOS_CM', COUNT(*) FROM ${P}course_modules cm
  INNER JOIN ${P}modules m ON m.id=cm.module AND m.name='aiassignment'
  JOIN ${P}course c ON c.id=cm.course
  WHERE c.shortname IN (${shortnameList})
UNION ALL
SELECT 'TAREAS', COUNT(*) FROM ${P}aiassignment a
  JOIN ${P}course c ON a.course=c.id WHERE c.shortname IN (${shortnameList})
UNION ALL
SELECT 'ENVIOS', COUNT(*) FROM ${P}aiassignment_submissions s
  JOIN ${P}user u ON s.userid=u.id WHERE u.username LIKE '${ALUMNO_LIKE}'
UNION ALL
SELECT 'EVALUACIONES', COUNT(*) FROM ${P}aiassignment_evaluations e
  JOIN ${P}aiassignment_submissions s ON e.submission=s.id
  JOIN ${P}user u ON s.userid=u.id WHERE u.username LIKE '${ALUMNO_LIKE}';

SELECT c.shortname AS salon,
  COUNT(DISTINCT s.userid) AS alumnos,
  COUNT(s.id) AS envios,
  SUM(CASE WHEN e.similarity_score>=75 THEN 1 ELSE 0 END) AS plagio_alto,
  SUM(CASE WHEN e.similarity_score>=50 AND e.similarity_score<75 THEN 1 ELSE 0 END) AS sospechoso,
  SUM(CASE WHEN e.similarity_score<50 THEN 1 ELSE 0 END) AS original,
  ROUND(AVG(s.score),1) AS promedio
FROM ${P}course c
JOIN ${P}aiassignment a ON a.course=c.id
JOIN ${P}aiassignment_submissions s ON s.assignment=a.id
JOIN ${P}user u ON s.userid=u.id
LEFT JOIN ${P}aiassignment_evaluations e ON e.submission=s.id
WHERE c.shortname IN (${shortnameList}) AND u.username LIKE '${ALUMNO_LIKE}'
GROUP BY c.shortname
ORDER BY c.shortname;
`;

fs.writeFileSync(OUTPUT, sql, 'utf8');
console.log(`Script generado: ${OUTPUT}`);
console.log('Conteos esperados: 3 maestros, 150 alumnos, 6 cursos, 12 tareas, 12 course_modules, 300 envíos');
