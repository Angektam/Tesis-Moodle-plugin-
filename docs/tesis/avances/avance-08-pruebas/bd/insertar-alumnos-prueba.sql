-- ============================================================
-- Inserta 5 alumnos de prueba + envíos con plagio para testear
-- Ejecutar en phpMyAdmin → base de datos moodle → pestaña SQL
-- ============================================================

USE moodle;

SET FOREIGN_KEY_CHECKS = 0;

-- ── 1. Crear 5 usuarios estudiantes de prueba ─────────────────
-- (si ya existen los ignora por el WHERE NOT EXISTS)

INSERT INTO mdl_user 
  (auth, confirmed, username, password, firstname, lastname, email, 
   mnethostid, lang, timezone, timecreated, timemodified, lastip)
SELECT 'manual',1,'alumno1',MD5('alumno1pass'),'Carlos','García','carlos@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='alumno1');

INSERT INTO mdl_user 
  (auth, confirmed, username, password, firstname, lastname, email,
   mnethostid, lang, timezone, timecreated, timemodified, lastip)
SELECT 'manual',1,'alumno2',MD5('alumno2pass'),'María','López','maria@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='alumno2');

INSERT INTO mdl_user 
  (auth, confirmed, username, password, firstname, lastname, email,
   mnethostid, lang, timezone, timecreated, timemodified, lastip)
SELECT 'manual',1,'alumno3',MD5('alumno3pass'),'Pedro','Martínez','pedro@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='alumno3');

INSERT INTO mdl_user 
  (auth, confirmed, username, password, firstname, lastname, email,
   mnethostid, lang, timezone, timecreated, timemodified, lastip)
SELECT 'manual',1,'alumno4',MD5('alumno4pass'),'Ana','Rodríguez','ana@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='alumno4');

INSERT INTO mdl_user 
  (auth, confirmed, username, password, firstname, lastname, email,
   mnethostid, lang, timezone, timecreated, timemodified, lastip)
SELECT 'manual',1,'alumno5',MD5('alumno5pass'),'Luis','Hernández','luis@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='alumno5');

-- ── 2. Obtener IDs de los usuarios y el assignment ────────────
-- Usamos variables para no hardcodear IDs

SET @U1 = (SELECT id FROM mdl_user WHERE username = 'alumno1' LIMIT 1);
SET @U2 = (SELECT id FROM mdl_user WHERE username = 'alumno2' LIMIT 1);
SET @U3 = (SELECT id FROM mdl_user WHERE username = 'alumno3' LIMIT 1);
SET @U4 = (SELECT id FROM mdl_user WHERE username = 'alumno4' LIMIT 1);
SET @U5 = (SELECT id FROM mdl_user WHERE username = 'alumno5' LIMIT 1);

-- ID del primer aiassignment que exista
SET @AID = (SELECT id FROM mdl_aiassignment ORDER BY id LIMIT 1);

-- ── 3. Limpiar envíos previos de estos usuarios ───────────────
DELETE FROM mdl_aiassignment_evaluations
  WHERE submission IN (
    SELECT id FROM mdl_aiassignment_submissions
    WHERE assignment = @AID
      AND userid IN (
        SELECT id FROM mdl_user WHERE username IN ('alumno1','alumno2','alumno3','alumno4','alumno5')
      )
  );

DELETE FROM mdl_aiassignment_submissions
  WHERE assignment = @AID
    AND userid IN (
      SELECT id FROM mdl_user WHERE username IN ('alumno1','alumno2','alumno3','alumno4','alumno5')
    );

-- ── 4. Insertar envíos con distintos niveles de plagio ────────

INSERT INTO mdl_aiassignment_submissions
  (assignment, userid, answer, status, score, feedback, attempt, timecreated, timemodified)
VALUES

-- Carlos: solución recursiva ORIGINAL
(@AID, @U1,
'def factorial(n):
    if n == 0 or n == 1:
        return 1
    return n * factorial(n - 1)

print(factorial(5))   # 120
print(factorial(10))  # 3628800',
'evaluated', 92.00,
'Excelente implementación recursiva. Solución original.',
1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- María: PLAGIO por renombrado de variables (n→num, factorial→calc_fact)
(@AID, @U2,
'def calc_fact(num):
    if num == 0 or num == 1:
        return 1
    return num * calc_fact(num - 1)

print(calc_fact(5))   # 120
print(calc_fact(10))  # 3628800',
'evaluated', 88.00,
'Implementación correcta. Alta similitud con otro envío detectada.',
1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- Pedro: SOSPECHOSO — cambio de bucle (recursión → for)
(@AID, @U3,
'def factorial(n):
    resultado = 1
    for i in range(1, n + 1):
        resultado = resultado * i
    return resultado

print(factorial(5))
print(factorial(10))',
'evaluated', 85.00,
'Solución iterativa. Similitud estructural moderada con otro envío.',
1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- Ana: PLAGIO con código muerto y reordenación
(@AID, @U4,
'def factorial(n):
    # calcula el factorial de n
    aux = 0
    if n == 1 or n == 0:
        return 1
    result = n * factorial(n - 1)
    return result

print(factorial(5))
print(factorial(10))',
'evaluated', 78.00,
'Código con variables redundantes. Alta similitud estructural detectada.',
1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- Luis: ORIGINAL con while — enfoque completamente diferente
(@AID, @U5,
'def factorial(n):
    acumulador = 1
    numero = n
    while numero > 1:
        acumulador *= numero
        numero -= 1
    return acumulador

assert factorial(5) == 120
assert factorial(0) == 1
print("Tests OK")',
'evaluated', 95.00,
'Solución original con while. Excelente uso de assertions.',
1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- ── 5. Insertar evaluaciones IA ───────────────────────────────
INSERT INTO mdl_aiassignment_evaluations
  (submission, similarity_score, ai_feedback, ai_analysis, timecreated)
SELECT
  s.id,
  CASE s.userid
    WHEN @U1 THEN 10.00
    WHEN @U2 THEN 88.00
    WHEN @U3 THEN 52.00
    WHEN @U4 THEN 79.00
    WHEN @U5 THEN 12.00
  END,
  CASE s.userid
    WHEN @U1 THEN 'Solución original. Sin similitudes sospechosas.'
    WHEN @U2 THEN 'PLAGIO: Estructura idéntica, solo renombró variables (n→num, factorial→calc_fact).'
    WHEN @U3 THEN 'SOSPECHOSO: Misma lógica con bucle for en lugar de recursión.'
    WHEN @U4 THEN 'PLAGIO PROBABLE: Misma lógica con comentarios y variable auxiliar añadidos.'
    WHEN @U5 THEN 'Solución original con while. Enfoque diferente al resto.'
  END,
  CASE s.userid
    WHEN @U1 THEN '{"verdict":"original","lexical":8,"structural":12,"semantic":10}'
    WHEN @U2 THEN '{"verdict":"plagio","lexical":91,"structural":95,"semantic":88,"techniques":["Renombrado de variables"]}'
    WHEN @U3 THEN '{"verdict":"sospechoso","lexical":42,"structural":68,"semantic":52,"techniques":["Cambio de bucle"]}'
    WHEN @U4 THEN '{"verdict":"plagio","lexical":65,"structural":82,"semantic":79,"techniques":["Codigo muerto","Reordenacion"]}'
    WHEN @U5 THEN '{"verdict":"original","lexical":15,"structural":22,"semantic":12}'
  END,
  UNIX_TIMESTAMP()
FROM mdl_aiassignment_submissions s
WHERE s.assignment = @AID AND s.userid IN (@U1,@U2,@U3,@U4,@U5);

SET FOREIGN_KEY_CHECKS = 1;

-- ── 6. Verificar ──────────────────────────────────────────────
SELECT 
  u.firstname, u.lastname,
  s.score AS calificacion,
  e.similarity_score AS pct_plagio,
  LEFT(s.answer, 50) AS codigo_preview
FROM mdl_aiassignment_submissions s
JOIN mdl_user u ON s.userid = u.id
LEFT JOIN mdl_aiassignment_evaluations e ON e.submission = s.id
WHERE s.assignment = @AID AND u.username LIKE 'alumno%'
ORDER BY e.similarity_score DESC;
