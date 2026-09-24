-- ============================================================
-- Registrar 1 maestro (Yobani) + 5 alumnos en Moodle
-- Solo crea los usuarios — la inscripción al curso la hace
-- el maestro manualmente desde la interfaz de Moodle.
-- Contraseña de todos: Test1234!
-- ============================================================

-- Si tu base de datos tiene otro nombre, cambia la línea siguiente:
-- USE moodle;
-- En tu caso el nombre es u698086472_56plq (visible en phpMyAdmin)

-- ══════════════════════════════════════════════════════════════
-- MAESTRO — Yobani Martínez Ramírez
-- ══════════════════════════════════════════════════════════════
INSERT INTO mdl_user (auth, confirmed, username, password, firstname, lastname, email, mnethostid, lang, timezone, timecreated, timemodified, lastip)
SELECT 'manual', 1, 'yobani', MD5('Test1234!'), 'Yobani', 'Martínez Ramírez', 'yobani@test.com', 1, 'es', '99', UNIX_TIMESTAMP(), UNIX_TIMESTAMP(), '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username = 'yobani');

-- ══════════════════════════════════════════════════════════════
-- 5 ALUMNOS
-- ══════════════════════════════════════════════════════════════
INSERT INTO mdl_user (auth, confirmed, username, password, firstname, lastname, email, mnethostid, lang, timezone, timecreated, timemodified, lastip)
SELECT 'manual', 1, 'alumno01', MD5('Test1234!'), 'Kevin Ricardo', 'López Payán', 'alumno01@test.com', 1, 'es', '99', UNIX_TIMESTAMP(), UNIX_TIMESTAMP(), '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username = 'alumno01');

INSERT INTO mdl_user (auth, confirmed, username, password, firstname, lastname, email, mnethostid, lang, timezone, timecreated, timemodified, lastip)
SELECT 'manual', 1, 'alumno02', MD5('Test1234!'), 'Angel Gabriel', 'Flores Guevara', 'alumno02@test.com', 1, 'es', '99', UNIX_TIMESTAMP(), UNIX_TIMESTAMP(), '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username = 'alumno02');

INSERT INTO mdl_user (auth, confirmed, username, password, firstname, lastname, email, mnethostid, lang, timezone, timecreated, timemodified, lastip)
SELECT 'manual', 1, 'alumno03', MD5('Test1234!'), 'María', 'García López', 'alumno03@test.com', 1, 'es', '99', UNIX_TIMESTAMP(), UNIX_TIMESTAMP(), '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username = 'alumno03');

INSERT INTO mdl_user (auth, confirmed, username, password, firstname, lastname, email, mnethostid, lang, timezone, timecreated, timemodified, lastip)
SELECT 'manual', 1, 'alumno04', MD5('Test1234!'), 'Carlos', 'Hernández Torres', 'alumno04@test.com', 1, 'es', '99', UNIX_TIMESTAMP(), UNIX_TIMESTAMP(), '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username = 'alumno04');

INSERT INTO mdl_user (auth, confirmed, username, password, firstname, lastname, email, mnethostid, lang, timezone, timecreated, timemodified, lastip)
SELECT 'manual', 1, 'alumno05', MD5('Test1234!'), 'Sofía', 'Ramírez Cruz', 'alumno05@test.com', 1, 'es', '99', UNIX_TIMESTAMP(), UNIX_TIMESTAMP(), '127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username = 'alumno05');

-- ══════════════════════════════════════════════════════════════
-- VERIFICACIÓN
-- ══════════════════════════════════════════════════════════════
SELECT username, firstname, lastname, email
FROM mdl_user
WHERE username IN ('yobani', 'alumno01', 'alumno02', 'alumno03', 'alumno04', 'alumno05')
ORDER BY username;

-- ══════════════════════════════════════════════════════════════
-- CREDENCIALES — Todos usan: Test1234!
-- ══════════════════════════════════════════════════════════════
--
-- 👨‍🏫 yobani     Yobani Martínez Ramírez     yobani@test.com
-- 🎓 alumno01   Kevin Ricardo López Payán    alumno01@test.com
-- 🎓 alumno02   Angel Gabriel Flores Guevara alumno02@test.com
-- 🎓 alumno03   María García López           alumno03@test.com
-- 🎓 alumno04   Carlos Hernández Torres      alumno04@test.com
-- 🎓 alumno05   Sofía Ramírez Cruz           alumno05@test.com
--
-- El maestro los inscribe manualmente desde:
-- Moodle → Curso → Participantes → Matricular usuarios
-- ══════════════════════════════════════════════════════════════
