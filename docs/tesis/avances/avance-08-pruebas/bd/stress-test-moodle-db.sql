-- ============================================================================
-- PRUEBA DE ESTRÉS — Base de Datos Moodle (AI Assignment v2.4.0)
-- ============================================================================
--
-- Inserta datos masivos para probar los límites del plugin en Moodle real.
-- Ejecutar en phpMyAdmin o MySQL CLI contra la BD de Moodle.
--
-- PRECAUCIÓN: Esto inserta MUCHOS registros. Usar solo en entorno de pruebas.
--
-- Ajustar @course_id y @assignment_id según tu instalación.
-- ============================================================================

SET @course_id = 2;        -- ID del curso de prueba
SET @assignment_id = 1;    -- ID de la tarea AI Assignment

-- ============================================================================
-- FASE 1: Crear 100 usuarios de prueba (stress_user_001 a stress_user_100)
-- ============================================================================

DELIMITER //
DROP PROCEDURE IF EXISTS create_stress_users//
CREATE PROCEDURE create_stress_users()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 100 DO
        INSERT IGNORE INTO mdl_user (
            auth, confirmed, mnethostid, username, password,
            firstname, lastname, email, timecreated, timemodified
        ) VALUES (
            'manual', 1, 1,
            CONCAT('stress_user_', LPAD(i, 3, '0')),
            '$2y$10$abc123hashedpasswordplaceholder',
            CONCAT('Stress', i),
            CONCAT('User', LPAD(i, 3, '0')),
            CONCAT('stress', i, '@test.local'),
            UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
        );
        SET i = i + 1;
    END WHILE;
END//
DELIMITER ;

CALL create_stress_users();
DROP PROCEDURE IF EXISTS create_stress_users;

SELECT CONCAT('✅ Usuarios creados: ', COUNT(*)) AS resultado
FROM mdl_user WHERE username LIKE 'stress_user_%';

-- ============================================================================
-- FASE 2: Inscribir los 100 usuarios en el curso
-- ============================================================================

DELIMITER //
DROP PROCEDURE IF EXISTS enroll_stress_users//
CREATE PROCEDURE enroll_stress_users()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE uid INT;
    DECLARE enrol_id INT;

    -- Obtener el método de inscripción manual del curso
    SELECT id INTO enrol_id FROM mdl_enrol
    WHERE courseid = @course_id AND enrol = 'manual' LIMIT 1;

    IF enrol_id IS NULL THEN
        INSERT INTO mdl_enrol (enrol, status, courseid, timecreated, timemodified)
        VALUES ('manual', 0, @course_id, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());
        SET enrol_id = LAST_INSERT_ID();
    END IF;

    WHILE i <= 100 DO
        SELECT id INTO uid FROM mdl_user
        WHERE username = CONCAT('stress_user_', LPAD(i, 3, '0')) LIMIT 1;

        IF uid IS NOT NULL THEN
            INSERT IGNORE INTO mdl_user_enrolments (
                status, enrolid, userid, timecreated, timemodified
            ) VALUES (0, enrol_id, uid, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

            -- Asignar rol de estudiante (roleid=5)
            INSERT IGNORE INTO mdl_role_assignments (
                roleid, contextid, userid, timemodified
            ) SELECT 5, ctx.id, uid, UNIX_TIMESTAMP()
            FROM mdl_context ctx
            WHERE ctx.contextlevel = 50 AND ctx.instanceid = @course_id
            LIMIT 1;
        END IF;

        SET i = i + 1;
    END WHILE;
END//
DELIMITER ;

CALL enroll_stress_users();
DROP PROCEDURE IF EXISTS enroll_stress_users;

SELECT CONCAT('✅ Inscripciones: ', COUNT(*)) AS resultado
FROM mdl_user_enrolments ue
JOIN mdl_enrol e ON ue.enrolid = e.id
WHERE e.courseid = @course_id;

-- ============================================================================
-- FASE 3: Crear 500 submissions (5 por alumno, con variaciones de código)
-- ============================================================================

DELIMITER //
DROP PROCEDURE IF EXISTS create_stress_submissions//
CREATE PROCEDURE create_stress_submissions()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE uid INT;
    DECLARE attempt INT;
    DECLARE code TEXT;
    DECLARE score DECIMAL(5,2);

    WHILE i <= 100 DO
        SELECT id INTO uid FROM mdl_user
        WHERE username = CONCAT('stress_user_', LPAD(i, 3, '0')) LIMIT 1;

        IF uid IS NOT NULL THEN
            SET attempt = 1;
            WHILE attempt <= 5 DO
                -- Generar código con variaciones para simular intentos reales
                SET code = CONCAT(
                    'def solve(n):\n',
                    '    # Intento ', attempt, ' del alumno ', i, '\n',
                    '    result = 0\n',
                    '    for i in range(n):\n',
                    '        result += i * ', (i % 10) + 1, '\n',
                    CASE WHEN attempt > 2 THEN
                        CONCAT('    # Mejora: agregar validacion\n',
                               '    if n < 0:\n',
                               '        return -1\n')
                    ELSE '' END,
                    '    return result\n'
                );

                SET score = CASE
                    WHEN attempt = 1 THEN 40 + RAND() * 20
                    WHEN attempt = 2 THEN 50 + RAND() * 20
                    WHEN attempt = 3 THEN 60 + RAND() * 20
                    WHEN attempt = 4 THEN 70 + RAND() * 15
                    WHEN attempt = 5 THEN 75 + RAND() * 20
                END;

                INSERT INTO mdl_aiassignment_submissions (
                    assignment, userid, answer, status, score,
                    feedback, attempt, timecreated, timemodified
                ) VALUES (
                    @assignment_id, uid, code,
                    IF(attempt <= 4, 'evaluated', 'pending'),
                    IF(attempt <= 4, ROUND(score, 2), NULL),
                    IF(attempt <= 4, CONCAT('Evaluación automática. Score: ', ROUND(score, 1), '%'), NULL),
                    attempt,
                    UNIX_TIMESTAMP() - (6 - attempt) * 86400,
                    UNIX_TIMESTAMP() - (6 - attempt) * 86400
                );

                SET attempt = attempt + 1;
            END WHILE;
        END IF;

        SET i = i + 1;
    END WHILE;
END//
DELIMITER ;

CALL create_stress_submissions();
DROP PROCEDURE IF EXISTS create_stress_submissions;

SELECT CONCAT('✅ Submissions creadas: ', COUNT(*)) AS resultado
FROM mdl_aiassignment_submissions WHERE assignment = @assignment_id;

-- ============================================================================
-- FASE 4: Crear evaluaciones con scores de plagio variados
-- ============================================================================

INSERT INTO mdl_aiassignment_evaluations (submission, similarity_score, ai_feedback, ai_analysis, timecreated)
SELECT
    s.id,
    ROUND(
        CASE
            WHEN s.userid % 10 = 0 THEN 80 + RAND() * 20  -- 10% plagio alto
            WHEN s.userid % 5 = 0  THEN 50 + RAND() * 25  -- 20% sospechoso
            ELSE RAND() * 40                                 -- 70% original
        END, 2
    ),
    'Evaluación de prueba de estrés',
    '{"method":"stress_test","generated":true}',
    UNIX_TIMESTAMP()
FROM mdl_aiassignment_submissions s
WHERE s.assignment = @assignment_id
  AND s.status = 'evaluated'
  AND NOT EXISTS (
      SELECT 1 FROM mdl_aiassignment_evaluations e WHERE e.submission = s.id
  );

SELECT CONCAT('✅ Evaluaciones creadas: ', COUNT(*)) AS resultado
FROM mdl_aiassignment_evaluations e
JOIN mdl_aiassignment_submissions s ON e.submission = s.id
WHERE s.assignment = @assignment_id;

-- ============================================================================
-- FASE 5: Verificar conteos finales
-- ============================================================================

SELECT '═══ RESUMEN DE DATOS DE ESTRÉS ═══' AS '';

SELECT 'Usuarios de prueba' AS metrica,
       COUNT(*) AS cantidad
FROM mdl_user WHERE username LIKE 'stress_user_%'

UNION ALL

SELECT 'Submissions totales',
       COUNT(*)
FROM mdl_aiassignment_submissions WHERE assignment = @assignment_id

UNION ALL

SELECT 'Submissions evaluadas',
       COUNT(*)
FROM mdl_aiassignment_submissions
WHERE assignment = @assignment_id AND status = 'evaluated'

UNION ALL

SELECT 'Submissions pendientes',
       COUNT(*)
FROM mdl_aiassignment_submissions
WHERE assignment = @assignment_id AND status = 'pending'

UNION ALL

SELECT 'Evaluaciones con plagio alto (>=75%)',
       COUNT(*)
FROM mdl_aiassignment_evaluations e
JOIN mdl_aiassignment_submissions s ON e.submission = s.id
WHERE s.assignment = @assignment_id AND e.similarity_score >= 75

UNION ALL

SELECT 'Evaluaciones sospechosas (50-74%)',
       COUNT(*)
FROM mdl_aiassignment_evaluations e
JOIN mdl_aiassignment_submissions s ON e.submission = s.id
WHERE s.assignment = @assignment_id AND e.similarity_score >= 50 AND e.similarity_score < 75;

-- ============================================================================
-- LIMPIEZA (descomentar para eliminar datos de prueba)
-- ============================================================================
-- DELETE e FROM mdl_aiassignment_evaluations e
-- JOIN mdl_aiassignment_submissions s ON e.submission = s.id
-- WHERE s.assignment = @assignment_id AND s.userid IN (
--     SELECT id FROM mdl_user WHERE username LIKE 'stress_user_%'
-- );
-- DELETE FROM mdl_aiassignment_submissions
-- WHERE assignment = @assignment_id AND userid IN (
--     SELECT id FROM mdl_user WHERE username LIKE 'stress_user_%'
-- );
-- DELETE FROM mdl_user WHERE username LIKE 'stress_user_%';
