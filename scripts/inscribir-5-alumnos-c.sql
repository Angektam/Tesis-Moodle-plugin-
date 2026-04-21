-- ============================================================
-- 5 alumnos para tarea de Lenguaje C
-- Ejecutar completo en phpMyAdmin
-- ============================================================

USE moodle;
SET FOREIGN_KEY_CHECKS = 0;

-- ── PASO 0: Crear inscripción manual si no existe ─────────────
INSERT INTO mdl_enrol (enrol, status, courseid, sortorder, timecreated, timemodified)
SELECT 'manual', 0, c.id, 0, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
FROM mdl_course c
WHERE c.shortname = 'test'
  AND NOT EXISTS (SELECT 1 FROM mdl_enrol e WHERE e.courseid = c.id AND e.enrol = 'manual');

-- ── PASO 1: Crear 5 usuarios ──────────────────────────────────
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'alumno_c1',MD5('Test1234!'),'Juan','Perez','alumno_c1@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='alumno_c1');

INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'alumno_c2',MD5('Test1234!'),'Laura','Gonzalez','alumno_c2@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='alumno_c2');

INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'alumno_c3',MD5('Test1234!'),'Miguel','Ramirez','alumno_c3@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='alumno_c3');

INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'alumno_c4',MD5('Test1234!'),'Sofia','Torres','alumno_c4@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='alumno_c4');

INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'alumno_c5',MD5('Test1234!'),'Carlos','Mendoza','alumno_c5@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='alumno_c5');

-- ── PASO 2: Inscribir al curso (timestart/timeend) ────────────
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
WHERE u.username IN ('alumno_c1','alumno_c2','alumno_c3','alumno_c4','alumno_c5')
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
WHERE u.username IN ('alumno_c1','alumno_c2','alumno_c3','alumno_c4','alumno_c5')
  AND ra_exist.userid IS NULL;

-- ── PASO 4: Limpiar envíos previos ───────────────────────────
DELETE ev FROM mdl_aiassignment_evaluations ev
INNER JOIN mdl_aiassignment_submissions s ON ev.submission = s.id
INNER JOIN mdl_aiassignment a ON s.assignment = a.id
INNER JOIN mdl_course c ON a.course = c.id
INNER JOIN mdl_user u ON s.userid = u.id
WHERE c.shortname = 'test' AND u.username LIKE 'alumno_c%';

DELETE s FROM mdl_aiassignment_submissions s
INNER JOIN mdl_aiassignment a ON s.assignment = a.id
INNER JOIN mdl_course c ON a.course = c.id
INNER JOIN mdl_user u ON s.userid = u.id
WHERE c.shortname = 'test' AND u.username LIKE 'alumno_c%';

-- ── PASO 5: Variables ─────────────────────────────────────────
SET @aid = (SELECT a.id FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id WHERE c.shortname='test' LIMIT 1);
SET @u1  = (SELECT id FROM mdl_user WHERE username='alumno_c1');
SET @u2  = (SELECT id FROM mdl_user WHERE username='alumno_c2');
SET @u3  = (SELECT id FROM mdl_user WHERE username='alumno_c3');
SET @u4  = (SELECT id FROM mdl_user WHERE username='alumno_c4');
SET @u5  = (SELECT id FROM mdl_user WHERE username='alumno_c5');

-- ── PASO 6: Insertar envíos ───────────────────────────────────
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified) VALUES
(@aid, @u1,
'#include <stdio.h>

int main() {
    int numero = 10;
    float decimal = 3.14;
    int letra = 65;
    printf("Numero: %d\n", numero);
    printf("Decimal: %.2f\n", decimal);
    printf("Letra: %c\n", letra);
    return 0;
}',
'evaluated', 92.00, 'Excelente estructura. Directivas, main, variables y printf correctos.', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

(@aid, @u2,
'#include <stdio.h>

int main() {
    int num = 10;
    float dec = 3.14;
    int car = 65;
    printf("Numero: %d\n", num);
    printf("Decimal: %.2f\n", dec);
    printf("Letra: %c\n", car);
    return 0;
}',
'evaluated', 88.00, 'PLAGIO: Misma estructura, solo renombro variables (numero->num, decimal->dec).', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

(@aid, @u3,
'#include <stdio.h>

int main() {
    int numero = 10;
    float decimal = 3.14;
    int letra = 65;
    printf("Numero: %d\n", numero);
    printf("Decimal: %.2f\n", decimal);
    printf("Letra: %c\n", letra);
    return 0;
}',
'evaluated', 85.00, 'PLAGIO: Codigo identico al original con comentarios removidos.', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

(@aid, @u4,
'#include <stdio.h>

void mostrar(int n, float d, int c) {
    printf("Numero: %d\n", n);
    printf("Decimal: %.2f\n", d);
    printf("Letra: %c\n", c);
}

int main() {
    int numero = 10;
    float decimal = 3.14;
    int letra = 65;
    mostrar(numero, decimal, letra);
    return 0;
}',
'evaluated', 78.00, 'SOSPECHOSO: Agrega funcion mostrar() como distractor. Base similar al original.', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

(@aid, @u5,
'#include <stdio.h>
#include <string.h>

#define MAX 50

int sumar(int a, int b) {
    return a + b;
}

int main() {
    char nombre[MAX];
    int edad = 20;
    int resultado = sumar(5, 3);
    printf("Nombre: estudiante\n");
    printf("Edad: %d\n", edad);
    printf("Suma: %d\n", resultado);
    return 0;
}',
'evaluated', 95.00, 'Excelente. Solucion original con define, funcion propia y strings.', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- ── PASO 7: Insertar scores de plagio ─────────────────────────
INSERT INTO mdl_aiassignment_evaluations (submission, similarity_score, ai_feedback, ai_analysis, timecreated)
SELECT s.id,
  CASE u.username
    WHEN 'alumno_c1' THEN  8.00
    WHEN 'alumno_c2' THEN 87.00
    WHEN 'alumno_c3' THEN 82.00
    WHEN 'alumno_c4' THEN 55.00
    WHEN 'alumno_c5' THEN  9.00
  END,
  s.feedback, '{}', UNIX_TIMESTAMP()
FROM mdl_aiassignment_submissions s
JOIN mdl_user u ON s.userid = u.id
JOIN mdl_aiassignment a ON s.assignment = a.id
JOIN mdl_course c ON a.course = c.id
WHERE c.shortname = 'test' AND u.username LIKE 'alumno_c%';

SET FOREIGN_KEY_CHECKS = 1;

-- ── VERIFICACIÓN ──────────────────────────────────────────────
SELECT u.username, u.firstname, u.lastname,
       s.score AS calificacion,
       e.similarity_score AS pct_plagio,
       CASE WHEN e.similarity_score >= 75 THEN 'PLAGIO'
            WHEN e.similarity_score >= 50 THEN 'SOSPECHOSO'
            ELSE 'ORIGINAL' END AS nivel
FROM mdl_aiassignment_submissions s
JOIN mdl_user u ON s.userid = u.id
JOIN mdl_aiassignment a ON s.assignment = a.id
JOIN mdl_course c ON a.course = c.id
LEFT JOIN mdl_aiassignment_evaluations e ON e.submission = s.id
WHERE c.shortname = 'test' AND u.username LIKE 'alumno_c%'
ORDER BY e.similarity_score DESC;
