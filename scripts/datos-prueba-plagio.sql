-- ============================================================
-- Datos de prueba para detección de plagio en código fuente
-- Plugin: mod_aiassignment
--
-- ANTES de ejecutar:
--   1. Instala el plugin en Moodle
--   2. Crea una actividad "AI Assignment" en cualquier curso
--   3. Anota el ID de esa actividad (mdl_aiassignment.id)
--      y reemplaza el valor de @ASSIGNMENT_ID abajo
--   4. Ejecutar: mysql -u root -p moodle < datos-prueba-plagio.sql
--
-- Usuarios requeridos (IDs por defecto en Moodle demo):
--   2 = admin / profesor
--   Estudiantes: se crean con los IDs que tenga tu Moodle.
--   Ajusta @U1..@U5 con los IDs reales de tus usuarios.
-- ============================================================

USE moodle;

-- ── Configuración: ajusta estos valores ──────────────────────
SET @ASSIGNMENT_ID = 1;   -- ID de tu actividad aiassignment
SET @U1 = 3;              -- Estudiante 1: solución original
SET @U2 = 4;              -- Estudiante 2: plagio por renombrado
SET @U3 = 5;              -- Estudiante 3: plagio cambio de bucle
SET @U4 = 6;              -- Estudiante 4: plagio con código muerto
SET @U5 = 7;              -- Estudiante 5: solución original diferente

SET FOREIGN_KEY_CHECKS = 0;

-- ── Limpiar envíos previos de esta actividad ─────────────────
DELETE e FROM mdl_aiassignment_evaluations e
  INNER JOIN mdl_aiassignment_submissions s ON e.submission = s.id
  WHERE s.assignment = @ASSIGNMENT_ID;

DELETE FROM mdl_aiassignment_submissions WHERE assignment = @ASSIGNMENT_ID;

-- ── Insertar envíos ──────────────────────────────────────────
-- Cada answer es código Python real para la tarea:
-- "Implementa una función factorial(n) recursiva"

INSERT INTO mdl_aiassignment_submissions
  (assignment, userid, answer, status, score, feedback, attempt, timecreated, timemodified)
VALUES

-- ── Estudiante 1: solución recursiva original ─────────────────
-- Esperado: SIN plagio con E5, PLAGIO con E2/E4, SOSPECHOSO con E3
(@ASSIGNMENT_ID, @U1,
'def factorial(n):
    if n == 0 or n == 1:
        return 1
    return n * factorial(n - 1)

# Pruebas
print(factorial(5))   # 120
print(factorial(0))   # 1
print(factorial(10))  # 3628800',
'evaluated', 92.00,
'Excelente implementación recursiva. Maneja correctamente los casos base.',
1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- ── Estudiante 2: PLAGIO — renombrado de variables ────────────
-- Solo cambió: n→num, factorial→calc_fact
-- Esperado: PLAGIO con E1 (~85-90%)
(@ASSIGNMENT_ID, @U2,
'def calc_fact(num):
    if num == 0 or num == 1:
        return 1
    return num * calc_fact(num - 1)

# Test
print(calc_fact(5))   # 120
print(calc_fact(0))   # 1
print(calc_fact(10))  # 3628800',
'evaluated', 88.00,
'Implementación correcta. Se detectó alta similitud con otro envío.',
1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- ── Estudiante 3: SOSPECHOSO — cambio de bucle ───────────────
-- Misma lógica pero con for en vez de recursión
-- Esperado: SOSPECHOSO con E1 (~55-65%)
(@ASSIGNMENT_ID, @U3,
'def factorial(n):
    resultado = 1
    for i in range(1, n + 1):
        resultado = resultado * i
    return resultado

print(factorial(5))
print(factorial(0))
print(factorial(10))',
'evaluated', 85.00,
'Solución iterativa correcta. Similitud estructural moderada con otro envío.',
1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- ── Estudiante 4: PLAGIO — reordenación + código muerto ───────
-- Misma lógica de E1 con comentarios falsos y variable extra inútil
-- Esperado: PLAGIO con E1 (~75-85%)
(@ASSIGNMENT_ID, @U4,
'def factorial(n):
    # funcion para calcular factorial
    aux = 0  # variable auxiliar
    if n == 1 or n == 0:
        return 1
    # llamada recursiva
    result = n * factorial(n - 1)
    return result

# ejecutar
print(factorial(5))
print(factorial(10))',
'evaluated', 78.00,
'Implementación con código redundante. Alta similitud estructural detectada.',
1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- ── Estudiante 5: ORIGINAL — enfoque while diferente ─────────
-- Lógica completamente diferente, no debe marcarse como plagio
-- Esperado: ORIGINAL con todos (~15-30%)
(@ASSIGNMENT_ID, @U5,
'def factorial(n):
    acumulador = 1
    numero = n
    while numero > 1:
        acumulador *= numero
        numero -= 1
    return acumulador

# verificacion
assert factorial(5) == 120
assert factorial(0) == 1
assert factorial(10) == 3628800
print("Todos los tests pasaron")',
'evaluated', 95.00,
'Solución original con while. Excelente uso de assertions para verificar.',
1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- ── Insertar evaluaciones IA ─────────────────────────────────
INSERT INTO mdl_aiassignment_evaluations
  (submission, similarity_score, ai_feedback, ai_analysis, timecreated)
SELECT
  s.id,
  CASE s.userid
    WHEN @U1 THEN 10.00
    WHEN @U2 THEN 88.00
    WHEN @U3 THEN 58.00
    WHEN @U4 THEN 79.00
    WHEN @U5 THEN 12.00
  END AS similarity_score,
  CASE s.userid
    WHEN @U1 THEN 'Solución recursiva original. Sin similitudes sospechosas.'
    WHEN @U2 THEN 'PLAGIO DETECTADO: Estructura idéntica a otro envío. Solo se renombraron variables (n→num, factorial→calc_fact).'
    WHEN @U3 THEN 'SOSPECHOSO: Misma lógica que otro envío pero con bucle for en lugar de recursión.'
    WHEN @U4 THEN 'PLAGIO PROBABLE: Misma lógica con comentarios y variable auxiliar añadidos artificialmente.'
    WHEN @U5 THEN 'Solución original con bucle while. Enfoque diferente al resto de envíos.'
  END AS ai_feedback,
  CASE s.userid
    WHEN @U1 THEN '{"verdict":"original","lexical":8,"structural":12,"semantic":10,"techniques":[]}'
    WHEN @U2 THEN '{"verdict":"plagio","lexical":91,"structural":95,"semantic":88,"techniques":["Renombrado de variables","Renombrado de función"]}'
    WHEN @U3 THEN '{"verdict":"sospechoso","lexical":42,"structural":68,"semantic":62,"techniques":["Cambio de tipo de bucle (recursión→for)"]}'
    WHEN @U4 THEN '{"verdict":"plagio","lexical":65,"structural":82,"semantic":79,"techniques":["Reordenación de sentencias","Inserción de código muerto","Comentarios falsos"]}'
    WHEN @U5 THEN '{"verdict":"original","lexical":15,"structural":22,"semantic":12,"techniques":[]}'
  END AS ai_analysis,
  UNIX_TIMESTAMP() AS timecreated
FROM mdl_aiassignment_submissions s
WHERE s.assignment = @ASSIGNMENT_ID
  AND s.userid IN (@U1, @U2, @U3, @U4, @U5);

SET FOREIGN_KEY_CHECKS = 1;

-- ── Verificar resultado ───────────────────────────────────────
SELECT
  u.firstname,
  u.lastname,
  s.score        AS calificacion,
  e.similarity_score AS pct_plagio,
  JSON_UNQUOTE(JSON_EXTRACT(e.ai_analysis, '$.verdict')) AS veredicto,
  JSON_UNQUOTE(JSON_EXTRACT(e.ai_analysis, '$.techniques[0]')) AS tecnica_detectada,
  LEFT(s.answer, 60) AS codigo_preview
FROM mdl_aiassignment_submissions s
JOIN mdl_user u ON s.userid = u.id
JOIN mdl_aiassignment_evaluations e ON e.submission = s.id
WHERE s.assignment = @ASSIGNMENT_ID
ORDER BY e.similarity_score DESC;
