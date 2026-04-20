-- ============================================================
-- 30 alumnos: crear + inscribir al curso "test" + envíos
-- Compatible con MySQL Workbench y Moodle 4.x
-- Ejecutar completo de una sola vez en phpMyAdmin o Workbench
-- ============================================================

USE moodle;
SET FOREIGN_KEY_CHECKS = 0;

-- ── PASO 0: Crear método de inscripción manual si no existe ───
INSERT INTO mdl_enrol (enrol, status, courseid, sortorder, timecreated, timemodified)
SELECT 'manual', 0, c.id, 0, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
FROM mdl_course c
WHERE c.shortname = 'test'
  AND NOT EXISTS (
    SELECT 1 FROM mdl_enrol e WHERE e.courseid = c.id AND e.enrol = 'manual'
  );

-- ── PASO 1: Crear 30 usuarios ─────────────────────────────────
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est01',MD5('Test1234!'),'Carlos','García','est01@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est01');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est02',MD5('Test1234!'),'María','López','est02@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est02');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est03',MD5('Test1234!'),'Pedro','Martínez','est03@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est03');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est04',MD5('Test1234!'),'Ana','Rodríguez','est04@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est04');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est05',MD5('Test1234!'),'Luis','Hernández','est05@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est05');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est06',MD5('Test1234!'),'Sofía','Jiménez','est06@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est06');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est07',MD5('Test1234!'),'Diego','Torres','est07@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est07');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est08',MD5('Test1234!'),'Valentina','Flores','est08@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est08');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est09',MD5('Test1234!'),'Andrés','Vargas','est09@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est09');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est10',MD5('Test1234!'),'Camila','Reyes','est10@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est10');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est11',MD5('Test1234!'),'Sebastián','Cruz','est11@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est11');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est12',MD5('Test1234!'),'Isabella','Morales','est12@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est12');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est13',MD5('Test1234!'),'Mateo','Ortiz','est13@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est13');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est14',MD5('Test1234!'),'Lucía','Mendoza','est14@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est14');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est15',MD5('Test1234!'),'Nicolás','Castillo','est15@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est15');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est16',MD5('Test1234!'),'Gabriela','Ramos','est16@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est16');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est17',MD5('Test1234!'),'Felipe','Gutiérrez','est17@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est17');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est18',MD5('Test1234!'),'Daniela','Sánchez','est18@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est18');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est19',MD5('Test1234!'),'Tomás','Ramírez','est19@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est19');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est20',MD5('Test1234!'),'Valeria','Núñez','est20@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est20');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est21',MD5('Test1234!'),'Emilio','Peña','est21@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est21');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est22',MD5('Test1234!'),'Renata','Aguilar','est22@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est22');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est23',MD5('Test1234!'),'Joaquín','Medina','est23@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est23');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est24',MD5('Test1234!'),'Mariana','Vega','est24@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est24');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est25',MD5('Test1234!'),'Rodrigo','Herrera','est25@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est25');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est26',MD5('Test1234!'),'Natalia','Ríos','est26@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est26');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est27',MD5('Test1234!'),'Alejandro','Mora','est27@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est27');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est28',MD5('Test1234!'),'Paula','Delgado','est28@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est28');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est29',MD5('Test1234!'),'Ignacio','Fuentes','est29@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est29');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est30',MD5('Test1234!'),'Catalina','Espinoza','est30@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est30');

-- ── PASO 2: Inscribir al curso con timestart/timeend ──────────
INSERT INTO mdl_user_enrolments (enrolid, userid, modifierid, timestart, timeend, status, timecreated, timemodified)
SELECT
    enrol_curso.enrolid,
    u.id,
    2,
    UNIX_TIMESTAMP(), 0, 0, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
FROM mdl_user u
JOIN (
    SELECT e.id AS enrolid
    FROM mdl_enrol e
    JOIN mdl_course c ON e.courseid = c.id
    WHERE c.shortname = 'test' AND e.enrol = 'manual'
    LIMIT 1
) enrol_curso ON 1=1
LEFT JOIN mdl_user_enrolments ue_exist
    ON ue_exist.enrolid = enrol_curso.enrolid AND ue_exist.userid = u.id
WHERE u.username IN ('est01','est02','est03','est04','est05','est06','est07','est08','est09','est10',
                     'est11','est12','est13','est14','est15','est16','est17','est18','est19','est20',
                     'est21','est22','est23','est24','est25','est26','est27','est28','est29','est30')
  AND ue_exist.userid IS NULL;

-- ── PASO 3: Asignar rol estudiante ───────────────────────────
INSERT INTO mdl_role_assignments (roleid, contextid, userid, timemodified, modifierid, component, itemid)
SELECT
    rol.roleid,
    ctx.contextid,
    u.id,
    UNIX_TIMESTAMP(), 2, '', 0
FROM mdl_user u
JOIN (SELECT id AS roleid FROM mdl_role WHERE shortname='student' LIMIT 1) rol ON 1=1
JOIN (
    SELECT ctx2.id AS contextid
    FROM mdl_context ctx2
    JOIN mdl_course c2 ON ctx2.instanceid = c2.id
    WHERE ctx2.contextlevel = 50 AND c2.shortname = 'test'
    LIMIT 1
) ctx ON 1=1
LEFT JOIN mdl_role_assignments ra_exist
    ON ra_exist.roleid = rol.roleid
    AND ra_exist.contextid = ctx.contextid
    AND ra_exist.userid = u.id
WHERE u.username IN ('est01','est02','est03','est04','est05','est06','est07','est08','est09','est10',
                     'est11','est12','est13','est14','est15','est16','est17','est18','est19','est20',
                     'est21','est22','est23','est24','est25','est26','est27','est28','est29','est30')
  AND ra_exist.userid IS NULL;

-- ── PASO 4: Limpiar envíos previos ───────────────────────────
DELETE ev FROM mdl_aiassignment_evaluations ev
INNER JOIN mdl_aiassignment_submissions s ON ev.submission = s.id
INNER JOIN mdl_aiassignment a ON s.assignment = a.id
INNER JOIN mdl_course c ON a.course = c.id
INNER JOIN mdl_user u ON s.userid = u.id
WHERE c.shortname = 'test'
  AND u.username LIKE 'est%';

DELETE s FROM mdl_aiassignment_submissions s
INNER JOIN mdl_aiassignment a ON s.assignment = a.id
INNER JOIN mdl_course c ON a.course = c.id
INNER JOIN mdl_user u ON s.userid = u.id
WHERE c.shortname = 'test'
  AND u.username LIKE 'est%';

-- ── PASO 5: Insertar envíos de los 30 alumnos ────────────────
-- GRUPO A (est01-08): factorial recursivo — PLAGIO
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT aid.id, u.id, d.answer, 'evaluated', d.score, d.feedback, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
FROM (SELECT a.id FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id WHERE c.shortname='test' LIMIT 1) aid
JOIN mdl_user u ON u.username IN ('est01','est02','est03','est04','est05','est06','est07','est08')
JOIN (
  SELECT 'est01' AS un, 92.00 AS score, 'Original. Sin similitudes.' AS feedback, 'def factorial(n):\n    if n == 0 or n == 1:\n        return 1\n    return n * factorial(n - 1)\n\nprint(factorial(5))\nprint(factorial(10))' AS answer UNION ALL
  SELECT 'est02', 88.00, 'PLAGIO: Renombrado n->num, factorial->calc_fact.', 'def calc_fact(num):\n    if num == 0 or num == 1:\n        return 1\n    return num * calc_fact(num - 1)\n\nprint(calc_fact(5))\nprint(calc_fact(10))' UNION ALL
  SELECT 'est03', 87.00, 'PLAGIO: Renombrado n->x, factorial->fact.', 'def fact(x):\n    if x == 0 or x == 1:\n        return 1\n    return x * fact(x - 1)\n\nprint(fact(5))\nprint(fact(10))' UNION ALL
  SELECT 'est04', 79.00, 'PLAGIO: Variable auxiliar inutil.', 'def factorial(n):\n    aux = 0\n    if n == 1 or n == 0:\n        return 1\n    result = n * factorial(n - 1)\n    return result\n\nprint(factorial(5))\nprint(factorial(10))' UNION ALL
  SELECT 'est05', 82.00, 'PLAGIO: Comentarios anadidos.', 'def factorial(n):\n    # caso base\n    if n == 0 or n == 1:\n        return 1\n    # recursivo\n    return n * factorial(n - 1)\n\nprint(factorial(5))\nprint(factorial(10))' UNION ALL
  SELECT 'est06', 86.00, 'PLAGIO: Renombrado n->valor.', 'def calcular(valor):\n    if valor == 0 or valor == 1:\n        return 1\n    return valor * calcular(valor - 1)\n\nprint(calcular(5))\nprint(calcular(10))' UNION ALL
  SELECT 'est07', 80.00, 'PLAGIO: Prefijo mi_ anadido.', 'def mi_factorial(n):\n    if n == 0 or n == 1:\n        return 1\n    return n * mi_factorial(n - 1)\n\nprint("Resultado:", mi_factorial(5))\nprint("Resultado:", mi_factorial(10))' UNION ALL
  SELECT 'est08', 84.00, 'PLAGIO: Parentesis redundantes.', 'def factorial(n):\n    if (n == 0) or (n == 1):\n        return 1\n    return n * factorial((n - 1))\n\nprint(factorial(5))\nprint(factorial(10))'
) d ON u.username = d.un;

-- GRUPO B (est09-14): bubble sort — PLAGIO
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT aid.id, u.id, d.answer, 'evaluated', d.score, d.feedback, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
FROM (SELECT a.id FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id WHERE c.shortname='test' LIMIT 1) aid
JOIN mdl_user u ON u.username IN ('est09','est10','est11','est12','est13','est14')
JOIN (
  SELECT 'est09' AS un, 90.00 AS score, 'Original. Bubble sort.' AS feedback, 'def bubble_sort(arr):\n    n = len(arr)\n    for i in range(n):\n        for j in range(0, n-i-1):\n            if arr[j] > arr[j+1]:\n                arr[j], arr[j+1] = arr[j+1], arr[j]\n    return arr\n\nprint(bubble_sort([64,34,25,12,22,11,90]))' AS answer UNION ALL
  SELECT 'est10', 87.00, 'PLAGIO: arr->lista, n->tam.', 'def bubble_sort(lista):\n    tam = len(lista)\n    for i in range(tam):\n        for j in range(0, tam-i-1):\n            if lista[j] > lista[j+1]:\n                lista[j], lista[j+1] = lista[j+1], lista[j]\n    return lista\n\nprint(bubble_sort([64,34,25,12,22,11,90]))' UNION ALL
  SELECT 'est11', 88.00, 'PLAGIO: funcion->ordenar.', 'def ordenar(datos):\n    n = len(datos)\n    for i in range(n):\n        for j in range(0, n-i-1):\n            if datos[j] > datos[j+1]:\n                datos[j], datos[j+1] = datos[j+1], datos[j]\n    return datos\n\nprint(ordenar([64,34,25,12,22,11,90]))' UNION ALL
  SELECT 'est12', 83.00, 'PLAGIO: Swap con variable temp.', 'def bubble_sort(arr):\n    n = len(arr)\n    for i in range(n):\n        for j in range(0, n-i-1):\n            if arr[j] > arr[j+1]:\n                temp = arr[j]\n                arr[j] = arr[j+1]\n                arr[j+1] = temp\n    return arr\n\nprint(bubble_sort([64,34,25,12,22,11,90]))' UNION ALL
  SELECT 'est13', 81.00, 'PLAGIO: Comentarios anadidos.', 'def bubble_sort(arr):\n    n = len(arr)\n    # recorrer\n    for i in range(n):\n        for j in range(0, n-i-1):\n            if arr[j] > arr[j+1]:\n                arr[j], arr[j+1] = arr[j+1], arr[j]\n    return arr\n\nprint(bubble_sort([64,34,25,12,22,11,90]))' UNION ALL
  SELECT 'est14', 85.00, 'PLAGIO: Renombrado completo.', 'def sort_burbuja(arreglo):\n    longitud = len(arreglo)\n    for i in range(longitud):\n        for j in range(0, longitud-i-1):\n            if arreglo[j] > arreglo[j+1]:\n                arreglo[j], arreglo[j+1] = arreglo[j+1], arreglo[j]\n    return arreglo\n\nprint(sort_burbuja([64,34,25,12,22,11,90]))'
) d ON u.username = d.un;

-- GRUPO C (est15-18): SOSPECHOSOS
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT aid.id, u.id, d.answer, 'evaluated', d.score, d.feedback, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
FROM (SELECT a.id FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id WHERE c.shortname='test' LIMIT 1) aid
JOIN mdl_user u ON u.username IN ('est15','est16','est17','est18')
JOIN (
  SELECT 'est15' AS un, 75.00 AS score, 'SOSPECHOSO: while en vez de recursion.' AS feedback, 'def factorial(n):\n    resultado = 1\n    while n > 1:\n        resultado *= n\n        n -= 1\n    return resultado\n\nprint(factorial(5))\nprint(factorial(10))' AS answer UNION ALL
  SELECT 'est16', 76.00, 'SOSPECHOSO: for en vez de recursion.', 'def factorial(n):\n    resultado = 1\n    for i in range(1, n+1):\n        resultado = resultado * i\n    return resultado\n\nprint(factorial(5))\nprint(factorial(10))' UNION ALL
  SELECT 'est17', 72.00, 'SOSPECHOSO: Bubble sort con flag.', 'def bubble_sort(arr):\n    n = len(arr)\n    for i in range(n):\n        swapped = False\n        for j in range(0, n-i-1):\n            if arr[j] > arr[j+1]:\n                arr[j], arr[j+1] = arr[j+1], arr[j]\n                swapped = True\n        if not swapped:\n            break\n    return arr\n\nprint(bubble_sort([64,34,25,12,22,11,90]))' UNION ALL
  SELECT 'est18', 68.00, 'SOSPECHOSO: Usa reduce.', 'from functools import reduce\n\ndef factorial(n):\n    if n == 0:\n        return 1\n    return reduce(lambda x, y: x * y, range(1, n+1))\n\nprint(factorial(5))\nprint(factorial(10))'
) d ON u.username = d.un;

-- GRUPO D (est19-22): PLAGIO con codigo muerto
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT aid.id, u.id, d.answer, 'evaluated', d.score, d.feedback, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
FROM (SELECT a.id FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id WHERE c.shortname='test' LIMIT 1) aid
JOIN mdl_user u ON u.username IN ('est19','est20','est21','est22')
JOIN (
  SELECT 'est19' AS un, 77.00 AS score, 'PLAGIO: Variables inutiles x,y,z.' AS feedback, 'def factorial(n):\n    x = 0\n    y = 1\n    z = n + 0\n    if z == 0 or z == 1:\n        return 1\n    return z * factorial(z - 1)\n\nprint(factorial(5))\nprint(factorial(10))' AS answer UNION ALL
  SELECT 'est20', 78.00, 'PLAGIO: Variables dummy.', 'def bubble_sort(arr):\n    n = len(arr)\n    dummy = []\n    count = 0\n    for i in range(n):\n        for j in range(0, n-i-1):\n            count += 1\n            if arr[j] > arr[j+1]:\n                arr[j], arr[j+1] = arr[j+1], arr[j]\n    return arr\n\nprint(bubble_sort([64,34,25,12,22,11,90]))' UNION ALL
  SELECT 'est21', 80.00, 'PLAGIO: Assert como distractor.', 'def factorial(n):\n    assert isinstance(n, int)\n    if n == 0 or n == 1:\n        return 1\n    return n * factorial(n - 1)\n\nprint(factorial(5))\nprint(factorial(10))' UNION ALL
  SELECT 'est22', 76.00, 'PLAGIO: Try/except innecesario.', 'def factorial(n):\n    try:\n        if n == 0 or n == 1:\n            return 1\n        return n * factorial(n - 1)\n    except:\n        return -1\n\nprint(factorial(5))\nprint(factorial(10))'
) d ON u.username = d.un;

-- GRUPO E (est23-30): ORIGINALES
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT aid.id, u.id, d.answer, 'evaluated', d.score, d.feedback, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
FROM (SELECT a.id FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id WHERE c.shortname='test' LIMIT 1) aid
JOIN mdl_user u ON u.username IN ('est23','est24','est25','est26','est27','est28','est29','est30')
JOIN (
  SELECT 'est23' AS un, 91.00 AS score, 'Original: selection sort.' AS feedback, 'def selection_sort(arr):\n    n = len(arr)\n    for i in range(n):\n        min_idx = i\n        for j in range(i+1, n):\n            if arr[j] < arr[min_idx]:\n                min_idx = j\n        arr[i], arr[min_idx] = arr[min_idx], arr[i]\n    return arr\n\nprint(selection_sort([64,34,25,12,22,11,90]))' AS answer UNION ALL
  SELECT 'est24', 93.00, 'Original: insertion sort.', 'def insertion_sort(arr):\n    for i in range(1, len(arr)):\n        key = arr[i]\n        j = i - 1\n        while j >= 0 and arr[j] > key:\n            arr[j+1] = arr[j]\n            j -= 1\n        arr[j+1] = key\n    return arr\n\nprint(insertion_sort([64,34,25,12,22,11,90]))' UNION ALL
  SELECT 'est25', 88.00, 'Original: math.prod.', 'import math\n\ndef factorial(n):\n    return math.prod(range(1, n+1)) if n > 0 else 1\n\nprint(factorial(5))\nprint(factorial(10))' UNION ALL
  SELECT 'est26', 96.00, 'Original: merge sort.', 'def merge_sort(arr):\n    if len(arr) <= 1:\n        return arr\n    mid = len(arr) // 2\n    left = merge_sort(arr[:mid])\n    right = merge_sort(arr[mid:])\n    result = []\n    i = j = 0\n    while i < len(left) and j < len(right):\n        if left[i] <= right[j]:\n            result.append(left[i]); i += 1\n        else:\n            result.append(right[j]); j += 1\n    result.extend(left[i:])\n    result.extend(right[j:])\n    return result\n\nprint(merge_sort([64,34,25,12,22,11,90]))' UNION ALL
  SELECT 'est27', 94.00, 'Original: memoizacion.', 'cache = {}\n\ndef factorial(n):\n    if n in cache:\n        return cache[n]\n    if n <= 1:\n        return 1\n    cache[n] = n * factorial(n - 1)\n    return cache[n]\n\nprint(factorial(5))\nprint(factorial(10))' UNION ALL
  SELECT 'est28', 95.00, 'Original: quick sort.', 'def quick_sort(arr):\n    if len(arr) <= 1:\n        return arr\n    pivot = arr[len(arr) // 2]\n    left = [x for x in arr if x < pivot]\n    middle = [x for x in arr if x == pivot]\n    right = [x for x in arr if x > pivot]\n    return quick_sort(left) + middle + quick_sort(right)\n\nprint(quick_sort([64,34,25,12,22,11,90]))' UNION ALL
  SELECT 'est29', 89.00, 'Original: stack explicito.', 'def factorial(n):\n    stack = list(range(2, n+1))\n    result = 1\n    while stack:\n        result *= stack.pop()\n    return result\n\nprint(factorial(5))\nprint(factorial(10))' UNION ALL
  SELECT 'est30', 92.00, 'Original: counting sort.', 'def counting_sort(arr):\n    if not arr:\n        return arr\n    max_val = max(arr)\n    count = [0] * (max_val + 1)\n    for num in arr:\n        count[num] += 1\n    result = []\n    for i, c in enumerate(count):\n        result.extend([i] * c)\n    return result\n\nprint(counting_sort([64,34,25,12,22,11,90]))'
) d ON u.username = d.un;

-- ── PASO 6: Insertar scores de plagio ────────────────────────
INSERT INTO mdl_aiassignment_evaluations (submission, similarity_score, ai_feedback, ai_analysis, timecreated)
SELECT s.id,
  CASE u.username
    WHEN 'est01' THEN  8.00  WHEN 'est02' THEN 91.00  WHEN 'est03' THEN 89.00
    WHEN 'est04' THEN 79.00  WHEN 'est05' THEN 82.00  WHEN 'est06' THEN 87.00
    WHEN 'est07' THEN 78.00  WHEN 'est08' THEN 84.00  WHEN 'est09' THEN  9.00
    WHEN 'est10' THEN 88.00  WHEN 'est11' THEN 90.00  WHEN 'est12' THEN 81.00
    WHEN 'est13' THEN 80.00  WHEN 'est14' THEN 86.00  WHEN 'est15' THEN 58.00
    WHEN 'est16' THEN 55.00  WHEN 'est17' THEN 52.00  WHEN 'est18' THEN 48.00
    WHEN 'est19' THEN 77.00  WHEN 'est20' THEN 76.00  WHEN 'est21' THEN 80.00
    WHEN 'est22' THEN 75.00  WHEN 'est23' THEN 11.00  WHEN 'est24' THEN  9.00
    WHEN 'est25' THEN 14.00  WHEN 'est26' THEN  7.00  WHEN 'est27' THEN 16.00
    WHEN 'est28' THEN  8.00  WHEN 'est29' THEN 13.00  WHEN 'est30' THEN 10.00
  END,
  s.feedback,
  '{}',
  UNIX_TIMESTAMP()
FROM mdl_aiassignment_submissions s
JOIN mdl_user u ON s.userid = u.id
JOIN mdl_aiassignment a ON s.assignment = a.id
JOIN mdl_course c ON a.course = c.id
WHERE c.shortname = 'test'
  AND u.username LIKE 'est%';

SET FOREIGN_KEY_CHECKS = 1;

-- ── VERIFICACIÓN FINAL ────────────────────────────────────────
SELECT
  u.firstname, u.lastname,
  s.score        AS calificacion,
  e.similarity_score AS pct_plagio,
  CASE
    WHEN e.similarity_score >= 75 THEN 'PLAGIO'
    WHEN e.similarity_score >= 50 THEN 'SOSPECHOSO'
    ELSE 'ORIGINAL'
  END AS nivel
FROM mdl_aiassignment_submissions s
JOIN mdl_user u ON s.userid = u.id
JOIN mdl_aiassignment a ON s.assignment = a.id
JOIN mdl_course c ON a.course = c.id
LEFT JOIN mdl_aiassignment_evaluations e ON e.submission = s.id
WHERE c.shortname = 'test'
  AND u.username LIKE 'est%'
ORDER BY e.similarity_score DESC;
