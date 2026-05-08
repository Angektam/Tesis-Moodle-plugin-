-- ============================================================
-- CONSULTAR LAS TABLAS PRINCIPALES DEL PLUGIN AI Assignment
-- Ejecutar en phpMyAdmin con la base u698086472_56pkq
-- Prefijo de tablas: oy1n_
-- ============================================================

-- ══════════════════════════════════════════════════════════════
-- 1. TABLA: oy1n_aiassignment
--    Almacena las tareas creadas por el profesor
-- ══════════════════════════════════════════════════════════════
SELECT
    id,
    name                AS 'Nombre de la tarea',
    type                AS 'Tipo (math/programming)',
    grade               AS 'Calificación máxima',
    maxattempts         AS 'Intentos máximos (0=ilimitado)',
    use_rubric          AS 'Usa rúbrica (0/1)',
    exam_mode_local     AS 'Modo examen (0/1)',
    FROM_UNIXTIME(timecreated) AS 'Fecha de creación'
FROM oy1n_aiassignment
ORDER BY timecreated DESC;

-- ══════════════════════════════════════════════════════════════
-- 2. TABLA: oy1n_aiassignment_submissions
--    Almacena los envíos de los estudiantes
-- ══════════════════════════════════════════════════════════════
SELECT
    s.id,
    u.firstname         AS 'Nombre',
    u.lastname          AS 'Apellido',
    a.name              AS 'Tarea',
    s.attempt           AS 'Intento #',
    s.status            AS 'Estado',
    ROUND(s.score, 1)   AS 'Calificación (%)',
    LEFT(s.answer, 60)  AS 'Código (primeros 60 chars)',
    FROM_UNIXTIME(s.timecreated) AS 'Fecha de envío'
FROM oy1n_aiassignment_submissions s
JOIN oy1n_user u ON s.userid = u.id
JOIN oy1n_aiassignment a ON s.assignment = a.id
ORDER BY s.timecreated DESC
LIMIT 20;

-- ══════════════════════════════════════════════════════════════
-- 3. TABLA: oy1n_aiassignment_evaluations
--    Almacena los resultados del análisis de IA y plagio
-- ══════════════════════════════════════════════════════════════
SELECT
    e.id,
    u.firstname         AS 'Alumno',
    a.name              AS 'Tarea',
    ROUND(e.similarity_score, 1) AS 'Similitud plagio (%)',
    CASE
        WHEN e.similarity_score >= 75 THEN '🔴 PLAGIO'
        WHEN e.similarity_score >= 50 THEN '🟡 SOSPECHOSO'
        WHEN e.similarity_score IS NOT NULL THEN '🟢 ORIGINAL'
        ELSE '⏳ Sin analizar'
    END                 AS 'Nivel de riesgo',
    LEFT(e.ai_feedback, 80) AS 'Feedback IA (primeros 80 chars)',
    FROM_UNIXTIME(e.timecreated) AS 'Fecha de evaluación'
FROM oy1n_aiassignment_evaluations e
JOIN oy1n_aiassignment_submissions s ON e.submission = s.id
JOIN oy1n_user u ON s.userid = u.id
JOIN oy1n_aiassignment a ON s.assignment = a.id
ORDER BY e.similarity_score DESC
LIMIT 20;

-- ══════════════════════════════════════════════════════════════
-- 4. TABLA: oy1n_aiassignment_notifications
--    Notificaciones en tiempo real para alumnos y profesores
-- ══════════════════════════════════════════════════════════════
SELECT
    n.id,
    u.firstname         AS 'Usuario',
    n.type              AS 'Tipo de notificación',
    n.seen              AS 'Vista (0=no, 1=sí)',
    LEFT(n.payload, 100) AS 'Contenido (JSON)',
    FROM_UNIXTIME(n.timecreated) AS 'Fecha'
FROM oy1n_aiassignment_notifications n
JOIN oy1n_user u ON n.userid = u.id
ORDER BY n.timecreated DESC
LIMIT 10;

-- ══════════════════════════════════════════════════════════════
-- 5. TABLA: oy1n_aiassignment_sub_versions
--    Historial de versiones de cada envío
-- ══════════════════════════════════════════════════════════════
SELECT
    v.id,
    u.firstname         AS 'Alumno',
    v.submission_id     AS 'ID del envío',
    v.attempt           AS 'Intento',
    ROUND(v.score, 1)   AS 'Calificación anterior (%)',
    v.reason            AS 'Razón del cambio',
    FROM_UNIXTIME(v.timecreated) AS 'Fecha de versión'
FROM oy1n_aiassignment_sub_versions v
JOIN oy1n_user u ON v.userid = u.id
ORDER BY v.timecreated DESC
LIMIT 10;

-- ══════════════════════════════════════════════════════════════
-- 6. TABLA: oy1n_aiassignment_audit_log
--    Registro de auditoría de acciones del profesor
-- ══════════════════════════════════════════════════════════════
SELECT
    l.id,
    u.firstname         AS 'Profesor',
    l.action            AS 'Acción',
    l.targettype        AS 'Tipo de objeto',
    l.targetid          AS 'ID del objeto',
    l.ip                AS 'IP',
    FROM_UNIXTIME(l.timecreated) AS 'Fecha'
FROM oy1n_aiassignment_audit_log l
JOIN oy1n_user u ON l.userid = u.id
ORDER BY l.timecreated DESC
LIMIT 10;

-- ══════════════════════════════════════════════════════════════
-- 7. TABLA: oy1n_aiassignment_sus_surveys
--    Resultados de la encuesta de usabilidad SUS
-- ══════════════════════════════════════════════════════════════
SELECT
    sv.id,
    u.firstname         AS 'Participante',
    u.lastname          AS 'Apellido',
    ROUND(sv.sus_score, 1) AS 'Score SUS (0-100)',
    CASE
        WHEN sv.sus_score >= 85 THEN '🌟 Excelente'
        WHEN sv.sus_score >= 70 THEN '✅ Bueno'
        WHEN sv.sus_score >= 50 THEN '⚠️ Aceptable'
        ELSE '❌ Deficiente'
    END                 AS 'Interpretación',
    FROM_UNIXTIME(sv.timecreated) AS 'Fecha'
FROM oy1n_aiassignment_sus_surveys sv
JOIN oy1n_user u ON sv.userid = u.id
ORDER BY sv.sus_score DESC;

-- ══════════════════════════════════════════════════════════════
-- 8. RESUMEN GENERAL DEL SISTEMA
--    Una sola query que muestra el estado completo
-- ══════════════════════════════════════════════════════════════
SELECT
    (SELECT COUNT(*) FROM oy1n_aiassignment)                    AS 'Total tareas',
    (SELECT COUNT(*) FROM oy1n_aiassignment_submissions)        AS 'Total envíos',
    (SELECT COUNT(DISTINCT userid) FROM oy1n_aiassignment_submissions) AS 'Alumnos activos',
    (SELECT ROUND(AVG(score), 1) FROM oy1n_aiassignment_submissions WHERE score IS NOT NULL) AS 'Promedio general (%)',
    (SELECT COUNT(*) FROM oy1n_aiassignment_submissions WHERE status = 'pending') AS 'Envíos pendientes',
    (SELECT COUNT(*) FROM oy1n_aiassignment_evaluations WHERE similarity_score >= 75) AS 'Alertas de plagio',
    (SELECT COUNT(*) FROM oy1n_user WHERE username IN ('yobani','alumno01','alumno02','alumno03','alumno04','alumno05')) AS 'Usuarios de prueba registrados';

-- ══════════════════════════════════════════════════════════════
-- 9. RANKING DE ALUMNOS POR PLAGIO (para validar el experimento)
-- ══════════════════════════════════════════════════════════════
SELECT
    u.firstname         AS 'Nombre',
    u.lastname          AS 'Apellido',
    COUNT(s.id)         AS 'Total envíos',
    ROUND(AVG(s.score), 1) AS 'Promedio calificación (%)',
    ROUND(MAX(e.similarity_score), 1) AS 'Plagio máximo (%)',
    CASE
        WHEN MAX(e.similarity_score) >= 75 THEN '🔴 ALTO RIESGO'
        WHEN MAX(e.similarity_score) >= 50 THEN '🟡 SOSPECHOSO'
        WHEN MAX(e.similarity_score) IS NOT NULL THEN '🟢 ORIGINAL'
        ELSE '⏳ Sin analizar'
    END AS 'Nivel de riesgo'
FROM oy1n_user u
JOIN oy1n_aiassignment_submissions s ON s.userid = u.id
LEFT JOIN oy1n_aiassignment_evaluations e ON e.submission = s.id
GROUP BY u.id, u.firstname, u.lastname
ORDER BY MAX(e.similarity_score) DESC;
