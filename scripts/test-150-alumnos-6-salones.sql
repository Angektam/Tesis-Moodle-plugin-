-- ============================================================
-- TEST MASIVO CORREGIDO: 150 alumnos × 6 salones × 3 maestros
-- Generado por: node scripts/generar-150-alumnos.js
-- Prefijo: oy1n_ (Hostinger) | Contraseña: Test1234!
-- ============================================================
-- Incluye: usuarios, cursos, contextos, secciones, course_modules,
--          tareas aiassignment, 300 envíos, 300 evaluaciones.
-- POST-EJECUCIÓN: Administración → Notificaciones (reconstruir caché).
-- ============================================================

SET FOREIGN_KEY_CHECKS = 0;

-- ══════════════════════════════════════════════════════════════
-- PASO 1: Maestros
-- ══════════════════════════════════════════════════════════════
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'maestro01','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Yobani','Martínez Ramírez','maestro01@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='maestro01');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'maestro02','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Herman','Ayala Zúñiga','maestro02@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='maestro02');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'maestro03','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Geovany','López Pérez','maestro03@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='maestro03');

-- ══════════════════════════════════════════════════════════════
-- PASO 2: Cursos (campos mínimos + visible)
-- ══════════════════════════════════════════════════════════════
INSERT INTO oy1n_course (category,fullname,shortname,summary,summaryformat,format,startdate,enddate,visible,timecreated,timemodified)
SELECT 1,'Programación I — Salón 1','salon01','Curso de prueba Programación I — Salón 1',1,'topics',UNIX_TIMESTAMP(),0,1,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM oy1n_course WHERE shortname='salon01');

INSERT INTO oy1n_course (category,fullname,shortname,summary,summaryformat,format,startdate,enddate,visible,timecreated,timemodified)
SELECT 1,'Programación II — Salón 2','salon02','Curso de prueba Programación II — Salón 2',1,'topics',UNIX_TIMESTAMP(),0,1,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM oy1n_course WHERE shortname='salon02');

INSERT INTO oy1n_course (category,fullname,shortname,summary,summaryformat,format,startdate,enddate,visible,timecreated,timemodified)
SELECT 1,'Estructuras de Datos — Salón 3','salon03','Curso de prueba Estructuras de Datos — Salón 3',1,'topics',UNIX_TIMESTAMP(),0,1,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM oy1n_course WHERE shortname='salon03');

INSERT INTO oy1n_course (category,fullname,shortname,summary,summaryformat,format,startdate,enddate,visible,timecreated,timemodified)
SELECT 1,'Algoritmos — Salón 4','salon04','Curso de prueba Algoritmos — Salón 4',1,'topics',UNIX_TIMESTAMP(),0,1,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM oy1n_course WHERE shortname='salon04');

INSERT INTO oy1n_course (category,fullname,shortname,summary,summaryformat,format,startdate,enddate,visible,timecreated,timemodified)
SELECT 1,'Bases de Datos — Salón 5','salon05','Curso de prueba Bases de Datos — Salón 5',1,'topics',UNIX_TIMESTAMP(),0,1,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM oy1n_course WHERE shortname='salon05');

INSERT INTO oy1n_course (category,fullname,shortname,summary,summaryformat,format,startdate,enddate,visible,timecreated,timemodified)
SELECT 1,'Ingeniería de Software — Salón 6','salon06','Curso de prueba Ingeniería de Software — Salón 6',1,'topics',UNIX_TIMESTAMP(),0,1,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM oy1n_course WHERE shortname='salon06');

-- ══════════════════════════════════════════════════════════════
-- PASO 3: Contextos de curso (CONTEXT_COURSE = 50)
-- Sin esto, role_assignments no asigna permisos.
-- ══════════════════════════════════════════════════════════════
INSERT INTO oy1n_context (contextlevel,instanceid,depth,path,locked)
SELECT 50,c.id,0,'',0
FROM oy1n_course c
WHERE c.shortname='salon01'
AND NOT EXISTS (SELECT 1 FROM oy1n_context ctx WHERE ctx.contextlevel=50 AND ctx.instanceid=c.id);

UPDATE oy1n_context ctx
INNER JOIN oy1n_course c ON ctx.instanceid=c.id AND ctx.contextlevel=50
SET ctx.path=CONCAT('/1/',ctx.id), ctx.depth=2
WHERE c.shortname='salon01' AND (ctx.path IS NULL OR ctx.path='');

INSERT INTO oy1n_context (contextlevel,instanceid,depth,path,locked)
SELECT 50,c.id,0,'',0
FROM oy1n_course c
WHERE c.shortname='salon02'
AND NOT EXISTS (SELECT 1 FROM oy1n_context ctx WHERE ctx.contextlevel=50 AND ctx.instanceid=c.id);

UPDATE oy1n_context ctx
INNER JOIN oy1n_course c ON ctx.instanceid=c.id AND ctx.contextlevel=50
SET ctx.path=CONCAT('/1/',ctx.id), ctx.depth=2
WHERE c.shortname='salon02' AND (ctx.path IS NULL OR ctx.path='');

INSERT INTO oy1n_context (contextlevel,instanceid,depth,path,locked)
SELECT 50,c.id,0,'',0
FROM oy1n_course c
WHERE c.shortname='salon03'
AND NOT EXISTS (SELECT 1 FROM oy1n_context ctx WHERE ctx.contextlevel=50 AND ctx.instanceid=c.id);

UPDATE oy1n_context ctx
INNER JOIN oy1n_course c ON ctx.instanceid=c.id AND ctx.contextlevel=50
SET ctx.path=CONCAT('/1/',ctx.id), ctx.depth=2
WHERE c.shortname='salon03' AND (ctx.path IS NULL OR ctx.path='');

INSERT INTO oy1n_context (contextlevel,instanceid,depth,path,locked)
SELECT 50,c.id,0,'',0
FROM oy1n_course c
WHERE c.shortname='salon04'
AND NOT EXISTS (SELECT 1 FROM oy1n_context ctx WHERE ctx.contextlevel=50 AND ctx.instanceid=c.id);

UPDATE oy1n_context ctx
INNER JOIN oy1n_course c ON ctx.instanceid=c.id AND ctx.contextlevel=50
SET ctx.path=CONCAT('/1/',ctx.id), ctx.depth=2
WHERE c.shortname='salon04' AND (ctx.path IS NULL OR ctx.path='');

INSERT INTO oy1n_context (contextlevel,instanceid,depth,path,locked)
SELECT 50,c.id,0,'',0
FROM oy1n_course c
WHERE c.shortname='salon05'
AND NOT EXISTS (SELECT 1 FROM oy1n_context ctx WHERE ctx.contextlevel=50 AND ctx.instanceid=c.id);

UPDATE oy1n_context ctx
INNER JOIN oy1n_course c ON ctx.instanceid=c.id AND ctx.contextlevel=50
SET ctx.path=CONCAT('/1/',ctx.id), ctx.depth=2
WHERE c.shortname='salon05' AND (ctx.path IS NULL OR ctx.path='');

INSERT INTO oy1n_context (contextlevel,instanceid,depth,path,locked)
SELECT 50,c.id,0,'',0
FROM oy1n_course c
WHERE c.shortname='salon06'
AND NOT EXISTS (SELECT 1 FROM oy1n_context ctx WHERE ctx.contextlevel=50 AND ctx.instanceid=c.id);

UPDATE oy1n_context ctx
INNER JOIN oy1n_course c ON ctx.instanceid=c.id AND ctx.contextlevel=50
SET ctx.path=CONCAT('/1/',ctx.id), ctx.depth=2
WHERE c.shortname='salon06' AND (ctx.path IS NULL OR ctx.path='');

-- ══════════════════════════════════════════════════════════════
-- PASO 4: Secciones del curso (sin timecreated — solo timemodified)
-- ══════════════════════════════════════════════════════════════
INSERT INTO oy1n_course_sections (course,section,name,summary,summaryformat,visible,timemodified)
SELECT c.id,0,'General','',1,1,UNIX_TIMESTAMP()
FROM oy1n_course c
WHERE c.shortname='salon01'
AND NOT EXISTS (SELECT 1 FROM oy1n_course_sections cs WHERE cs.course=c.id AND cs.section=0);

INSERT INTO oy1n_course_sections (course,section,name,summary,summaryformat,visible,timemodified)
SELECT c.id,1,'Tareas','',1,1,UNIX_TIMESTAMP()
FROM oy1n_course c
WHERE c.shortname='salon01'
AND NOT EXISTS (SELECT 1 FROM oy1n_course_sections cs WHERE cs.course=c.id AND cs.section=1);

INSERT INTO oy1n_course_sections (course,section,name,summary,summaryformat,visible,timemodified)
SELECT c.id,0,'General','',1,1,UNIX_TIMESTAMP()
FROM oy1n_course c
WHERE c.shortname='salon02'
AND NOT EXISTS (SELECT 1 FROM oy1n_course_sections cs WHERE cs.course=c.id AND cs.section=0);

INSERT INTO oy1n_course_sections (course,section,name,summary,summaryformat,visible,timemodified)
SELECT c.id,1,'Tareas','',1,1,UNIX_TIMESTAMP()
FROM oy1n_course c
WHERE c.shortname='salon02'
AND NOT EXISTS (SELECT 1 FROM oy1n_course_sections cs WHERE cs.course=c.id AND cs.section=1);

INSERT INTO oy1n_course_sections (course,section,name,summary,summaryformat,visible,timemodified)
SELECT c.id,0,'General','',1,1,UNIX_TIMESTAMP()
FROM oy1n_course c
WHERE c.shortname='salon03'
AND NOT EXISTS (SELECT 1 FROM oy1n_course_sections cs WHERE cs.course=c.id AND cs.section=0);

INSERT INTO oy1n_course_sections (course,section,name,summary,summaryformat,visible,timemodified)
SELECT c.id,1,'Tareas','',1,1,UNIX_TIMESTAMP()
FROM oy1n_course c
WHERE c.shortname='salon03'
AND NOT EXISTS (SELECT 1 FROM oy1n_course_sections cs WHERE cs.course=c.id AND cs.section=1);

INSERT INTO oy1n_course_sections (course,section,name,summary,summaryformat,visible,timemodified)
SELECT c.id,0,'General','',1,1,UNIX_TIMESTAMP()
FROM oy1n_course c
WHERE c.shortname='salon04'
AND NOT EXISTS (SELECT 1 FROM oy1n_course_sections cs WHERE cs.course=c.id AND cs.section=0);

INSERT INTO oy1n_course_sections (course,section,name,summary,summaryformat,visible,timemodified)
SELECT c.id,1,'Tareas','',1,1,UNIX_TIMESTAMP()
FROM oy1n_course c
WHERE c.shortname='salon04'
AND NOT EXISTS (SELECT 1 FROM oy1n_course_sections cs WHERE cs.course=c.id AND cs.section=1);

INSERT INTO oy1n_course_sections (course,section,name,summary,summaryformat,visible,timemodified)
SELECT c.id,0,'General','',1,1,UNIX_TIMESTAMP()
FROM oy1n_course c
WHERE c.shortname='salon05'
AND NOT EXISTS (SELECT 1 FROM oy1n_course_sections cs WHERE cs.course=c.id AND cs.section=0);

INSERT INTO oy1n_course_sections (course,section,name,summary,summaryformat,visible,timemodified)
SELECT c.id,1,'Tareas','',1,1,UNIX_TIMESTAMP()
FROM oy1n_course c
WHERE c.shortname='salon05'
AND NOT EXISTS (SELECT 1 FROM oy1n_course_sections cs WHERE cs.course=c.id AND cs.section=1);

INSERT INTO oy1n_course_sections (course,section,name,summary,summaryformat,visible,timemodified)
SELECT c.id,0,'General','',1,1,UNIX_TIMESTAMP()
FROM oy1n_course c
WHERE c.shortname='salon06'
AND NOT EXISTS (SELECT 1 FROM oy1n_course_sections cs WHERE cs.course=c.id AND cs.section=0);

INSERT INTO oy1n_course_sections (course,section,name,summary,summaryformat,visible,timemodified)
SELECT c.id,1,'Tareas','',1,1,UNIX_TIMESTAMP()
FROM oy1n_course c
WHERE c.shortname='salon06'
AND NOT EXISTS (SELECT 1 FROM oy1n_course_sections cs WHERE cs.course=c.id AND cs.section=1);

-- ══════════════════════════════════════════════════════════════
-- PASO 5: Métodos de inscripción manual
-- ══════════════════════════════════════════════════════════════
INSERT INTO oy1n_enrol (enrol,status,courseid,sortorder,timecreated,timemodified)
SELECT 'manual',0,c.id,0,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM oy1n_course c
WHERE c.shortname='salon01'
AND NOT EXISTS (SELECT 1 FROM oy1n_enrol e WHERE e.courseid=c.id AND e.enrol='manual');

INSERT INTO oy1n_enrol (enrol,status,courseid,sortorder,timecreated,timemodified)
SELECT 'manual',0,c.id,0,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM oy1n_course c
WHERE c.shortname='salon02'
AND NOT EXISTS (SELECT 1 FROM oy1n_enrol e WHERE e.courseid=c.id AND e.enrol='manual');

INSERT INTO oy1n_enrol (enrol,status,courseid,sortorder,timecreated,timemodified)
SELECT 'manual',0,c.id,0,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM oy1n_course c
WHERE c.shortname='salon03'
AND NOT EXISTS (SELECT 1 FROM oy1n_enrol e WHERE e.courseid=c.id AND e.enrol='manual');

INSERT INTO oy1n_enrol (enrol,status,courseid,sortorder,timecreated,timemodified)
SELECT 'manual',0,c.id,0,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM oy1n_course c
WHERE c.shortname='salon04'
AND NOT EXISTS (SELECT 1 FROM oy1n_enrol e WHERE e.courseid=c.id AND e.enrol='manual');

INSERT INTO oy1n_enrol (enrol,status,courseid,sortorder,timecreated,timemodified)
SELECT 'manual',0,c.id,0,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM oy1n_course c
WHERE c.shortname='salon05'
AND NOT EXISTS (SELECT 1 FROM oy1n_enrol e WHERE e.courseid=c.id AND e.enrol='manual');

INSERT INTO oy1n_enrol (enrol,status,courseid,sortorder,timecreated,timemodified)
SELECT 'manual',0,c.id,0,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM oy1n_course c
WHERE c.shortname='salon06'
AND NOT EXISTS (SELECT 1 FROM oy1n_enrol e WHERE e.courseid=c.id AND e.enrol='manual');

-- ══════════════════════════════════════════════════════════════
-- PASO 6: Inscribir maestros (editingteacher)
-- ══════════════════════════════════════════════════════════════
INSERT INTO oy1n_user_enrolments (enrolid,userid,modifierid,timestart,timeend,status,timecreated,timemodified)
SELECT e.id,u.id,2,UNIX_TIMESTAMP(),0,0,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM oy1n_user u
JOIN oy1n_enrol e ON e.courseid=(SELECT id FROM oy1n_course WHERE shortname='salon01' LIMIT 1) AND e.enrol='manual'
LEFT JOIN oy1n_user_enrolments ue ON ue.enrolid=e.id AND ue.userid=u.id
WHERE u.username='maestro01' AND ue.userid IS NULL;

INSERT INTO oy1n_role_assignments (roleid,contextid,userid,timemodified,modifierid,component,itemid)
SELECT r.id,ctx.id,u.id,UNIX_TIMESTAMP(),2,'',0
FROM oy1n_user u
JOIN oy1n_role r ON r.shortname='editingteacher'
JOIN oy1n_context ctx ON ctx.contextlevel=50 AND ctx.instanceid=(SELECT id FROM oy1n_course WHERE shortname='salon01' LIMIT 1)
LEFT JOIN oy1n_role_assignments ra ON ra.roleid=r.id AND ra.contextid=ctx.id AND ra.userid=u.id
WHERE u.username='maestro01' AND ra.userid IS NULL;

INSERT INTO oy1n_user_enrolments (enrolid,userid,modifierid,timestart,timeend,status,timecreated,timemodified)
SELECT e.id,u.id,2,UNIX_TIMESTAMP(),0,0,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM oy1n_user u
JOIN oy1n_enrol e ON e.courseid=(SELECT id FROM oy1n_course WHERE shortname='salon02' LIMIT 1) AND e.enrol='manual'
LEFT JOIN oy1n_user_enrolments ue ON ue.enrolid=e.id AND ue.userid=u.id
WHERE u.username='maestro01' AND ue.userid IS NULL;

INSERT INTO oy1n_role_assignments (roleid,contextid,userid,timemodified,modifierid,component,itemid)
SELECT r.id,ctx.id,u.id,UNIX_TIMESTAMP(),2,'',0
FROM oy1n_user u
JOIN oy1n_role r ON r.shortname='editingteacher'
JOIN oy1n_context ctx ON ctx.contextlevel=50 AND ctx.instanceid=(SELECT id FROM oy1n_course WHERE shortname='salon02' LIMIT 1)
LEFT JOIN oy1n_role_assignments ra ON ra.roleid=r.id AND ra.contextid=ctx.id AND ra.userid=u.id
WHERE u.username='maestro01' AND ra.userid IS NULL;

INSERT INTO oy1n_user_enrolments (enrolid,userid,modifierid,timestart,timeend,status,timecreated,timemodified)
SELECT e.id,u.id,2,UNIX_TIMESTAMP(),0,0,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM oy1n_user u
JOIN oy1n_enrol e ON e.courseid=(SELECT id FROM oy1n_course WHERE shortname='salon03' LIMIT 1) AND e.enrol='manual'
LEFT JOIN oy1n_user_enrolments ue ON ue.enrolid=e.id AND ue.userid=u.id
WHERE u.username='maestro02' AND ue.userid IS NULL;

INSERT INTO oy1n_role_assignments (roleid,contextid,userid,timemodified,modifierid,component,itemid)
SELECT r.id,ctx.id,u.id,UNIX_TIMESTAMP(),2,'',0
FROM oy1n_user u
JOIN oy1n_role r ON r.shortname='editingteacher'
JOIN oy1n_context ctx ON ctx.contextlevel=50 AND ctx.instanceid=(SELECT id FROM oy1n_course WHERE shortname='salon03' LIMIT 1)
LEFT JOIN oy1n_role_assignments ra ON ra.roleid=r.id AND ra.contextid=ctx.id AND ra.userid=u.id
WHERE u.username='maestro02' AND ra.userid IS NULL;

INSERT INTO oy1n_user_enrolments (enrolid,userid,modifierid,timestart,timeend,status,timecreated,timemodified)
SELECT e.id,u.id,2,UNIX_TIMESTAMP(),0,0,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM oy1n_user u
JOIN oy1n_enrol e ON e.courseid=(SELECT id FROM oy1n_course WHERE shortname='salon04' LIMIT 1) AND e.enrol='manual'
LEFT JOIN oy1n_user_enrolments ue ON ue.enrolid=e.id AND ue.userid=u.id
WHERE u.username='maestro02' AND ue.userid IS NULL;

INSERT INTO oy1n_role_assignments (roleid,contextid,userid,timemodified,modifierid,component,itemid)
SELECT r.id,ctx.id,u.id,UNIX_TIMESTAMP(),2,'',0
FROM oy1n_user u
JOIN oy1n_role r ON r.shortname='editingteacher'
JOIN oy1n_context ctx ON ctx.contextlevel=50 AND ctx.instanceid=(SELECT id FROM oy1n_course WHERE shortname='salon04' LIMIT 1)
LEFT JOIN oy1n_role_assignments ra ON ra.roleid=r.id AND ra.contextid=ctx.id AND ra.userid=u.id
WHERE u.username='maestro02' AND ra.userid IS NULL;

INSERT INTO oy1n_user_enrolments (enrolid,userid,modifierid,timestart,timeend,status,timecreated,timemodified)
SELECT e.id,u.id,2,UNIX_TIMESTAMP(),0,0,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM oy1n_user u
JOIN oy1n_enrol e ON e.courseid=(SELECT id FROM oy1n_course WHERE shortname='salon05' LIMIT 1) AND e.enrol='manual'
LEFT JOIN oy1n_user_enrolments ue ON ue.enrolid=e.id AND ue.userid=u.id
WHERE u.username='maestro03' AND ue.userid IS NULL;

INSERT INTO oy1n_role_assignments (roleid,contextid,userid,timemodified,modifierid,component,itemid)
SELECT r.id,ctx.id,u.id,UNIX_TIMESTAMP(),2,'',0
FROM oy1n_user u
JOIN oy1n_role r ON r.shortname='editingteacher'
JOIN oy1n_context ctx ON ctx.contextlevel=50 AND ctx.instanceid=(SELECT id FROM oy1n_course WHERE shortname='salon05' LIMIT 1)
LEFT JOIN oy1n_role_assignments ra ON ra.roleid=r.id AND ra.contextid=ctx.id AND ra.userid=u.id
WHERE u.username='maestro03' AND ra.userid IS NULL;

INSERT INTO oy1n_user_enrolments (enrolid,userid,modifierid,timestart,timeend,status,timecreated,timemodified)
SELECT e.id,u.id,2,UNIX_TIMESTAMP(),0,0,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM oy1n_user u
JOIN oy1n_enrol e ON e.courseid=(SELECT id FROM oy1n_course WHERE shortname='salon06' LIMIT 1) AND e.enrol='manual'
LEFT JOIN oy1n_user_enrolments ue ON ue.enrolid=e.id AND ue.userid=u.id
WHERE u.username='maestro03' AND ue.userid IS NULL;

INSERT INTO oy1n_role_assignments (roleid,contextid,userid,timemodified,modifierid,component,itemid)
SELECT r.id,ctx.id,u.id,UNIX_TIMESTAMP(),2,'',0
FROM oy1n_user u
JOIN oy1n_role r ON r.shortname='editingteacher'
JOIN oy1n_context ctx ON ctx.contextlevel=50 AND ctx.instanceid=(SELECT id FROM oy1n_course WHERE shortname='salon06' LIMIT 1)
LEFT JOIN oy1n_role_assignments ra ON ra.roleid=r.id AND ra.contextid=ctx.id AND ra.userid=u.id
WHERE u.username='maestro03' AND ra.userid IS NULL;

-- ══════════════════════════════════════════════════════════════
-- PASO 7: Crear 150 alumnos (idempotente)
-- ══════════════════════════════════════════════════════════════
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al01_salon01','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Carlos','García','al01_salon01@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al01_salon01');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al02_salon01','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','María','López','al02_salon01@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al02_salon01');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al03_salon01','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Pedro','Martínez','al03_salon01@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al03_salon01');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al04_salon01','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Ana','Rodríguez','al04_salon01@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al04_salon01');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al05_salon01','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Luis','Hernández','al05_salon01@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al05_salon01');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al06_salon01','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Sofía','Jiménez','al06_salon01@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al06_salon01');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al07_salon01','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Diego','Torres','al07_salon01@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al07_salon01');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al08_salon01','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Valentina','Flores','al08_salon01@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al08_salon01');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al09_salon01','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Andrés','Vargas','al09_salon01@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al09_salon01');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al10_salon01','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Camila','Reyes','al10_salon01@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al10_salon01');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al11_salon01','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Sebastián','Cruz','al11_salon01@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al11_salon01');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al12_salon01','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Isabella','Morales','al12_salon01@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al12_salon01');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al13_salon01','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Mateo','Ortiz','al13_salon01@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al13_salon01');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al14_salon01','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Lucía','Mendoza','al14_salon01@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al14_salon01');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al15_salon01','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Nicolás','Castillo','al15_salon01@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al15_salon01');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al16_salon01','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Gabriela','Ramos','al16_salon01@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al16_salon01');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al17_salon01','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Felipe','Gutiérrez','al17_salon01@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al17_salon01');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al18_salon01','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Daniela','Sánchez','al18_salon01@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al18_salon01');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al19_salon01','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Tomás','Ramírez','al19_salon01@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al19_salon01');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al20_salon01','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Valeria','Núñez','al20_salon01@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al20_salon01');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al21_salon01','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Emilio','Peña','al21_salon01@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al21_salon01');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al22_salon01','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Renata','Aguilar','al22_salon01@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al22_salon01');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al23_salon01','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Joaquín','Medina','al23_salon01@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al23_salon01');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al24_salon01','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Mariana','Vega','al24_salon01@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al24_salon01');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al25_salon01','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Rodrigo','Herrera','al25_salon01@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al25_salon01');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al01_salon02','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Carlos','García','al01_salon02@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al01_salon02');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al02_salon02','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','María','López','al02_salon02@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al02_salon02');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al03_salon02','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Pedro','Martínez','al03_salon02@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al03_salon02');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al04_salon02','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Ana','Rodríguez','al04_salon02@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al04_salon02');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al05_salon02','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Luis','Hernández','al05_salon02@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al05_salon02');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al06_salon02','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Sofía','Jiménez','al06_salon02@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al06_salon02');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al07_salon02','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Diego','Torres','al07_salon02@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al07_salon02');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al08_salon02','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Valentina','Flores','al08_salon02@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al08_salon02');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al09_salon02','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Andrés','Vargas','al09_salon02@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al09_salon02');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al10_salon02','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Camila','Reyes','al10_salon02@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al10_salon02');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al11_salon02','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Sebastián','Cruz','al11_salon02@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al11_salon02');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al12_salon02','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Isabella','Morales','al12_salon02@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al12_salon02');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al13_salon02','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Mateo','Ortiz','al13_salon02@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al13_salon02');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al14_salon02','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Lucía','Mendoza','al14_salon02@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al14_salon02');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al15_salon02','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Nicolás','Castillo','al15_salon02@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al15_salon02');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al16_salon02','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Gabriela','Ramos','al16_salon02@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al16_salon02');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al17_salon02','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Felipe','Gutiérrez','al17_salon02@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al17_salon02');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al18_salon02','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Daniela','Sánchez','al18_salon02@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al18_salon02');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al19_salon02','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Tomás','Ramírez','al19_salon02@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al19_salon02');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al20_salon02','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Valeria','Núñez','al20_salon02@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al20_salon02');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al21_salon02','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Emilio','Peña','al21_salon02@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al21_salon02');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al22_salon02','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Renata','Aguilar','al22_salon02@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al22_salon02');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al23_salon02','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Joaquín','Medina','al23_salon02@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al23_salon02');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al24_salon02','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Mariana','Vega','al24_salon02@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al24_salon02');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al25_salon02','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Rodrigo','Herrera','al25_salon02@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al25_salon02');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al01_salon03','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Carlos','García','al01_salon03@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al01_salon03');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al02_salon03','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','María','López','al02_salon03@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al02_salon03');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al03_salon03','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Pedro','Martínez','al03_salon03@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al03_salon03');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al04_salon03','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Ana','Rodríguez','al04_salon03@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al04_salon03');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al05_salon03','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Luis','Hernández','al05_salon03@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al05_salon03');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al06_salon03','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Sofía','Jiménez','al06_salon03@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al06_salon03');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al07_salon03','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Diego','Torres','al07_salon03@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al07_salon03');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al08_salon03','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Valentina','Flores','al08_salon03@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al08_salon03');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al09_salon03','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Andrés','Vargas','al09_salon03@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al09_salon03');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al10_salon03','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Camila','Reyes','al10_salon03@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al10_salon03');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al11_salon03','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Sebastián','Cruz','al11_salon03@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al11_salon03');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al12_salon03','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Isabella','Morales','al12_salon03@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al12_salon03');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al13_salon03','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Mateo','Ortiz','al13_salon03@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al13_salon03');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al14_salon03','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Lucía','Mendoza','al14_salon03@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al14_salon03');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al15_salon03','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Nicolás','Castillo','al15_salon03@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al15_salon03');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al16_salon03','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Gabriela','Ramos','al16_salon03@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al16_salon03');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al17_salon03','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Felipe','Gutiérrez','al17_salon03@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al17_salon03');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al18_salon03','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Daniela','Sánchez','al18_salon03@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al18_salon03');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al19_salon03','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Tomás','Ramírez','al19_salon03@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al19_salon03');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al20_salon03','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Valeria','Núñez','al20_salon03@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al20_salon03');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al21_salon03','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Emilio','Peña','al21_salon03@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al21_salon03');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al22_salon03','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Renata','Aguilar','al22_salon03@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al22_salon03');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al23_salon03','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Joaquín','Medina','al23_salon03@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al23_salon03');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al24_salon03','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Mariana','Vega','al24_salon03@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al24_salon03');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al25_salon03','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Rodrigo','Herrera','al25_salon03@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al25_salon03');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al01_salon04','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Carlos','García','al01_salon04@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al01_salon04');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al02_salon04','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','María','López','al02_salon04@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al02_salon04');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al03_salon04','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Pedro','Martínez','al03_salon04@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al03_salon04');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al04_salon04','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Ana','Rodríguez','al04_salon04@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al04_salon04');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al05_salon04','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Luis','Hernández','al05_salon04@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al05_salon04');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al06_salon04','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Sofía','Jiménez','al06_salon04@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al06_salon04');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al07_salon04','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Diego','Torres','al07_salon04@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al07_salon04');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al08_salon04','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Valentina','Flores','al08_salon04@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al08_salon04');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al09_salon04','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Andrés','Vargas','al09_salon04@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al09_salon04');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al10_salon04','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Camila','Reyes','al10_salon04@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al10_salon04');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al11_salon04','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Sebastián','Cruz','al11_salon04@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al11_salon04');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al12_salon04','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Isabella','Morales','al12_salon04@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al12_salon04');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al13_salon04','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Mateo','Ortiz','al13_salon04@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al13_salon04');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al14_salon04','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Lucía','Mendoza','al14_salon04@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al14_salon04');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al15_salon04','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Nicolás','Castillo','al15_salon04@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al15_salon04');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al16_salon04','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Gabriela','Ramos','al16_salon04@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al16_salon04');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al17_salon04','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Felipe','Gutiérrez','al17_salon04@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al17_salon04');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al18_salon04','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Daniela','Sánchez','al18_salon04@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al18_salon04');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al19_salon04','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Tomás','Ramírez','al19_salon04@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al19_salon04');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al20_salon04','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Valeria','Núñez','al20_salon04@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al20_salon04');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al21_salon04','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Emilio','Peña','al21_salon04@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al21_salon04');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al22_salon04','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Renata','Aguilar','al22_salon04@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al22_salon04');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al23_salon04','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Joaquín','Medina','al23_salon04@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al23_salon04');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al24_salon04','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Mariana','Vega','al24_salon04@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al24_salon04');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al25_salon04','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Rodrigo','Herrera','al25_salon04@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al25_salon04');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al01_salon05','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Carlos','García','al01_salon05@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al01_salon05');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al02_salon05','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','María','López','al02_salon05@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al02_salon05');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al03_salon05','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Pedro','Martínez','al03_salon05@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al03_salon05');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al04_salon05','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Ana','Rodríguez','al04_salon05@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al04_salon05');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al05_salon05','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Luis','Hernández','al05_salon05@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al05_salon05');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al06_salon05','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Sofía','Jiménez','al06_salon05@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al06_salon05');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al07_salon05','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Diego','Torres','al07_salon05@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al07_salon05');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al08_salon05','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Valentina','Flores','al08_salon05@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al08_salon05');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al09_salon05','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Andrés','Vargas','al09_salon05@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al09_salon05');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al10_salon05','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Camila','Reyes','al10_salon05@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al10_salon05');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al11_salon05','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Sebastián','Cruz','al11_salon05@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al11_salon05');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al12_salon05','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Isabella','Morales','al12_salon05@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al12_salon05');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al13_salon05','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Mateo','Ortiz','al13_salon05@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al13_salon05');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al14_salon05','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Lucía','Mendoza','al14_salon05@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al14_salon05');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al15_salon05','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Nicolás','Castillo','al15_salon05@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al15_salon05');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al16_salon05','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Gabriela','Ramos','al16_salon05@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al16_salon05');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al17_salon05','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Felipe','Gutiérrez','al17_salon05@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al17_salon05');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al18_salon05','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Daniela','Sánchez','al18_salon05@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al18_salon05');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al19_salon05','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Tomás','Ramírez','al19_salon05@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al19_salon05');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al20_salon05','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Valeria','Núñez','al20_salon05@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al20_salon05');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al21_salon05','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Emilio','Peña','al21_salon05@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al21_salon05');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al22_salon05','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Renata','Aguilar','al22_salon05@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al22_salon05');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al23_salon05','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Joaquín','Medina','al23_salon05@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al23_salon05');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al24_salon05','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Mariana','Vega','al24_salon05@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al24_salon05');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al25_salon05','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Rodrigo','Herrera','al25_salon05@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al25_salon05');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al01_salon06','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Carlos','García','al01_salon06@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al01_salon06');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al02_salon06','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','María','López','al02_salon06@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al02_salon06');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al03_salon06','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Pedro','Martínez','al03_salon06@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al03_salon06');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al04_salon06','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Ana','Rodríguez','al04_salon06@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al04_salon06');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al05_salon06','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Luis','Hernández','al05_salon06@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al05_salon06');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al06_salon06','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Sofía','Jiménez','al06_salon06@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al06_salon06');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al07_salon06','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Diego','Torres','al07_salon06@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al07_salon06');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al08_salon06','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Valentina','Flores','al08_salon06@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al08_salon06');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al09_salon06','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Andrés','Vargas','al09_salon06@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al09_salon06');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al10_salon06','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Camila','Reyes','al10_salon06@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al10_salon06');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al11_salon06','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Sebastián','Cruz','al11_salon06@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al11_salon06');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al12_salon06','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Isabella','Morales','al12_salon06@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al12_salon06');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al13_salon06','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Mateo','Ortiz','al13_salon06@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al13_salon06');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al14_salon06','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Lucía','Mendoza','al14_salon06@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al14_salon06');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al15_salon06','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Nicolás','Castillo','al15_salon06@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al15_salon06');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al16_salon06','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Gabriela','Ramos','al16_salon06@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al16_salon06');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al17_salon06','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Felipe','Gutiérrez','al17_salon06@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al17_salon06');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al18_salon06','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Daniela','Sánchez','al18_salon06@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al18_salon06');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al19_salon06','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Tomás','Ramírez','al19_salon06@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al19_salon06');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al20_salon06','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Valeria','Núñez','al20_salon06@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al20_salon06');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al21_salon06','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Emilio','Peña','al21_salon06@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al21_salon06');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al22_salon06','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Renata','Aguilar','al22_salon06@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al22_salon06');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al23_salon06','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Joaquín','Medina','al23_salon06@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al23_salon06');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al24_salon06','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Mariana','Vega','al24_salon06@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al24_salon06');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al25_salon06','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Rodrigo','Herrera','al25_salon06@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al25_salon06');

-- ══════════════════════════════════════════════════════════════
-- PASO 8: Inscribir alumnos (student)
-- ══════════════════════════════════════════════════════════════
INSERT INTO oy1n_user_enrolments (enrolid,userid,modifierid,timestart,timeend,status,timecreated,timemodified)
SELECT e.id,u.id,2,UNIX_TIMESTAMP(),0,0,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM oy1n_user u
JOIN oy1n_enrol e ON e.courseid=(SELECT id FROM oy1n_course WHERE shortname='salon01' LIMIT 1) AND e.enrol='manual'
LEFT JOIN oy1n_user_enrolments ue ON ue.enrolid=e.id AND ue.userid=u.id
WHERE u.username IN ('al01_salon01','al02_salon01','al03_salon01','al04_salon01','al05_salon01','al06_salon01','al07_salon01','al08_salon01','al09_salon01','al10_salon01','al11_salon01','al12_salon01','al13_salon01','al14_salon01','al15_salon01','al16_salon01','al17_salon01','al18_salon01','al19_salon01','al20_salon01','al21_salon01','al22_salon01','al23_salon01','al24_salon01','al25_salon01') AND ue.userid IS NULL;

INSERT INTO oy1n_role_assignments (roleid,contextid,userid,timemodified,modifierid,component,itemid)
SELECT r.id,ctx.id,u.id,UNIX_TIMESTAMP(),2,'',0
FROM oy1n_user u
JOIN oy1n_role r ON r.shortname='student'
JOIN oy1n_context ctx ON ctx.contextlevel=50 AND ctx.instanceid=(SELECT id FROM oy1n_course WHERE shortname='salon01' LIMIT 1)
LEFT JOIN oy1n_role_assignments ra ON ra.roleid=r.id AND ra.contextid=ctx.id AND ra.userid=u.id
WHERE u.username IN ('al01_salon01','al02_salon01','al03_salon01','al04_salon01','al05_salon01','al06_salon01','al07_salon01','al08_salon01','al09_salon01','al10_salon01','al11_salon01','al12_salon01','al13_salon01','al14_salon01','al15_salon01','al16_salon01','al17_salon01','al18_salon01','al19_salon01','al20_salon01','al21_salon01','al22_salon01','al23_salon01','al24_salon01','al25_salon01') AND ra.userid IS NULL;

INSERT INTO oy1n_user_enrolments (enrolid,userid,modifierid,timestart,timeend,status,timecreated,timemodified)
SELECT e.id,u.id,2,UNIX_TIMESTAMP(),0,0,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM oy1n_user u
JOIN oy1n_enrol e ON e.courseid=(SELECT id FROM oy1n_course WHERE shortname='salon02' LIMIT 1) AND e.enrol='manual'
LEFT JOIN oy1n_user_enrolments ue ON ue.enrolid=e.id AND ue.userid=u.id
WHERE u.username IN ('al01_salon02','al02_salon02','al03_salon02','al04_salon02','al05_salon02','al06_salon02','al07_salon02','al08_salon02','al09_salon02','al10_salon02','al11_salon02','al12_salon02','al13_salon02','al14_salon02','al15_salon02','al16_salon02','al17_salon02','al18_salon02','al19_salon02','al20_salon02','al21_salon02','al22_salon02','al23_salon02','al24_salon02','al25_salon02') AND ue.userid IS NULL;

INSERT INTO oy1n_role_assignments (roleid,contextid,userid,timemodified,modifierid,component,itemid)
SELECT r.id,ctx.id,u.id,UNIX_TIMESTAMP(),2,'',0
FROM oy1n_user u
JOIN oy1n_role r ON r.shortname='student'
JOIN oy1n_context ctx ON ctx.contextlevel=50 AND ctx.instanceid=(SELECT id FROM oy1n_course WHERE shortname='salon02' LIMIT 1)
LEFT JOIN oy1n_role_assignments ra ON ra.roleid=r.id AND ra.contextid=ctx.id AND ra.userid=u.id
WHERE u.username IN ('al01_salon02','al02_salon02','al03_salon02','al04_salon02','al05_salon02','al06_salon02','al07_salon02','al08_salon02','al09_salon02','al10_salon02','al11_salon02','al12_salon02','al13_salon02','al14_salon02','al15_salon02','al16_salon02','al17_salon02','al18_salon02','al19_salon02','al20_salon02','al21_salon02','al22_salon02','al23_salon02','al24_salon02','al25_salon02') AND ra.userid IS NULL;

INSERT INTO oy1n_user_enrolments (enrolid,userid,modifierid,timestart,timeend,status,timecreated,timemodified)
SELECT e.id,u.id,2,UNIX_TIMESTAMP(),0,0,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM oy1n_user u
JOIN oy1n_enrol e ON e.courseid=(SELECT id FROM oy1n_course WHERE shortname='salon03' LIMIT 1) AND e.enrol='manual'
LEFT JOIN oy1n_user_enrolments ue ON ue.enrolid=e.id AND ue.userid=u.id
WHERE u.username IN ('al01_salon03','al02_salon03','al03_salon03','al04_salon03','al05_salon03','al06_salon03','al07_salon03','al08_salon03','al09_salon03','al10_salon03','al11_salon03','al12_salon03','al13_salon03','al14_salon03','al15_salon03','al16_salon03','al17_salon03','al18_salon03','al19_salon03','al20_salon03','al21_salon03','al22_salon03','al23_salon03','al24_salon03','al25_salon03') AND ue.userid IS NULL;

INSERT INTO oy1n_role_assignments (roleid,contextid,userid,timemodified,modifierid,component,itemid)
SELECT r.id,ctx.id,u.id,UNIX_TIMESTAMP(),2,'',0
FROM oy1n_user u
JOIN oy1n_role r ON r.shortname='student'
JOIN oy1n_context ctx ON ctx.contextlevel=50 AND ctx.instanceid=(SELECT id FROM oy1n_course WHERE shortname='salon03' LIMIT 1)
LEFT JOIN oy1n_role_assignments ra ON ra.roleid=r.id AND ra.contextid=ctx.id AND ra.userid=u.id
WHERE u.username IN ('al01_salon03','al02_salon03','al03_salon03','al04_salon03','al05_salon03','al06_salon03','al07_salon03','al08_salon03','al09_salon03','al10_salon03','al11_salon03','al12_salon03','al13_salon03','al14_salon03','al15_salon03','al16_salon03','al17_salon03','al18_salon03','al19_salon03','al20_salon03','al21_salon03','al22_salon03','al23_salon03','al24_salon03','al25_salon03') AND ra.userid IS NULL;

INSERT INTO oy1n_user_enrolments (enrolid,userid,modifierid,timestart,timeend,status,timecreated,timemodified)
SELECT e.id,u.id,2,UNIX_TIMESTAMP(),0,0,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM oy1n_user u
JOIN oy1n_enrol e ON e.courseid=(SELECT id FROM oy1n_course WHERE shortname='salon04' LIMIT 1) AND e.enrol='manual'
LEFT JOIN oy1n_user_enrolments ue ON ue.enrolid=e.id AND ue.userid=u.id
WHERE u.username IN ('al01_salon04','al02_salon04','al03_salon04','al04_salon04','al05_salon04','al06_salon04','al07_salon04','al08_salon04','al09_salon04','al10_salon04','al11_salon04','al12_salon04','al13_salon04','al14_salon04','al15_salon04','al16_salon04','al17_salon04','al18_salon04','al19_salon04','al20_salon04','al21_salon04','al22_salon04','al23_salon04','al24_salon04','al25_salon04') AND ue.userid IS NULL;

INSERT INTO oy1n_role_assignments (roleid,contextid,userid,timemodified,modifierid,component,itemid)
SELECT r.id,ctx.id,u.id,UNIX_TIMESTAMP(),2,'',0
FROM oy1n_user u
JOIN oy1n_role r ON r.shortname='student'
JOIN oy1n_context ctx ON ctx.contextlevel=50 AND ctx.instanceid=(SELECT id FROM oy1n_course WHERE shortname='salon04' LIMIT 1)
LEFT JOIN oy1n_role_assignments ra ON ra.roleid=r.id AND ra.contextid=ctx.id AND ra.userid=u.id
WHERE u.username IN ('al01_salon04','al02_salon04','al03_salon04','al04_salon04','al05_salon04','al06_salon04','al07_salon04','al08_salon04','al09_salon04','al10_salon04','al11_salon04','al12_salon04','al13_salon04','al14_salon04','al15_salon04','al16_salon04','al17_salon04','al18_salon04','al19_salon04','al20_salon04','al21_salon04','al22_salon04','al23_salon04','al24_salon04','al25_salon04') AND ra.userid IS NULL;

INSERT INTO oy1n_user_enrolments (enrolid,userid,modifierid,timestart,timeend,status,timecreated,timemodified)
SELECT e.id,u.id,2,UNIX_TIMESTAMP(),0,0,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM oy1n_user u
JOIN oy1n_enrol e ON e.courseid=(SELECT id FROM oy1n_course WHERE shortname='salon05' LIMIT 1) AND e.enrol='manual'
LEFT JOIN oy1n_user_enrolments ue ON ue.enrolid=e.id AND ue.userid=u.id
WHERE u.username IN ('al01_salon05','al02_salon05','al03_salon05','al04_salon05','al05_salon05','al06_salon05','al07_salon05','al08_salon05','al09_salon05','al10_salon05','al11_salon05','al12_salon05','al13_salon05','al14_salon05','al15_salon05','al16_salon05','al17_salon05','al18_salon05','al19_salon05','al20_salon05','al21_salon05','al22_salon05','al23_salon05','al24_salon05','al25_salon05') AND ue.userid IS NULL;

INSERT INTO oy1n_role_assignments (roleid,contextid,userid,timemodified,modifierid,component,itemid)
SELECT r.id,ctx.id,u.id,UNIX_TIMESTAMP(),2,'',0
FROM oy1n_user u
JOIN oy1n_role r ON r.shortname='student'
JOIN oy1n_context ctx ON ctx.contextlevel=50 AND ctx.instanceid=(SELECT id FROM oy1n_course WHERE shortname='salon05' LIMIT 1)
LEFT JOIN oy1n_role_assignments ra ON ra.roleid=r.id AND ra.contextid=ctx.id AND ra.userid=u.id
WHERE u.username IN ('al01_salon05','al02_salon05','al03_salon05','al04_salon05','al05_salon05','al06_salon05','al07_salon05','al08_salon05','al09_salon05','al10_salon05','al11_salon05','al12_salon05','al13_salon05','al14_salon05','al15_salon05','al16_salon05','al17_salon05','al18_salon05','al19_salon05','al20_salon05','al21_salon05','al22_salon05','al23_salon05','al24_salon05','al25_salon05') AND ra.userid IS NULL;

INSERT INTO oy1n_user_enrolments (enrolid,userid,modifierid,timestart,timeend,status,timecreated,timemodified)
SELECT e.id,u.id,2,UNIX_TIMESTAMP(),0,0,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM oy1n_user u
JOIN oy1n_enrol e ON e.courseid=(SELECT id FROM oy1n_course WHERE shortname='salon06' LIMIT 1) AND e.enrol='manual'
LEFT JOIN oy1n_user_enrolments ue ON ue.enrolid=e.id AND ue.userid=u.id
WHERE u.username IN ('al01_salon06','al02_salon06','al03_salon06','al04_salon06','al05_salon06','al06_salon06','al07_salon06','al08_salon06','al09_salon06','al10_salon06','al11_salon06','al12_salon06','al13_salon06','al14_salon06','al15_salon06','al16_salon06','al17_salon06','al18_salon06','al19_salon06','al20_salon06','al21_salon06','al22_salon06','al23_salon06','al24_salon06','al25_salon06') AND ue.userid IS NULL;

INSERT INTO oy1n_role_assignments (roleid,contextid,userid,timemodified,modifierid,component,itemid)
SELECT r.id,ctx.id,u.id,UNIX_TIMESTAMP(),2,'',0
FROM oy1n_user u
JOIN oy1n_role r ON r.shortname='student'
JOIN oy1n_context ctx ON ctx.contextlevel=50 AND ctx.instanceid=(SELECT id FROM oy1n_course WHERE shortname='salon06' LIMIT 1)
LEFT JOIN oy1n_role_assignments ra ON ra.roleid=r.id AND ra.contextid=ctx.id AND ra.userid=u.id
WHERE u.username IN ('al01_salon06','al02_salon06','al03_salon06','al04_salon06','al05_salon06','al06_salon06','al07_salon06','al08_salon06','al09_salon06','al10_salon06','al11_salon06','al12_salon06','al13_salon06','al14_salon06','al15_salon06','al16_salon06','al17_salon06','al18_salon06','al19_salon06','al20_salon06','al21_salon06','al22_salon06','al23_salon06','al24_salon06','al25_salon06') AND ra.userid IS NULL;

-- ══════════════════════════════════════════════════════════════
-- PASO 9: Instancias aiassignment (2 por salón)
-- ══════════════════════════════════════════════════════════════
-- Yobani (maestro01)
INSERT INTO oy1n_aiassignment (course,teacher_id,name,intro,introformat,description,type,solution,grade,maxattempts,timecreated,timemodified)
SELECT c.id,(SELECT id FROM oy1n_user WHERE username='maestro01' LIMIT 1),
'Factorial recursivo — Programación I — Salón 1','Factorial recursivo',1,'Tarea de Yobani','programming','def factorial(n):\\n    if n<=1: return 1\\n    return n*factorial(n-1)\\nprint(factorial(5))',100,3,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM oy1n_course c
WHERE c.shortname='salon01'
AND NOT EXISTS (SELECT 1 FROM oy1n_aiassignment aa WHERE aa.name='Factorial recursivo — Programación I — Salón 1' AND aa.course=c.id);

INSERT INTO oy1n_aiassignment (course,teacher_id,name,intro,introformat,description,type,solution,grade,maxattempts,timecreated,timemodified)
SELECT c.id,(SELECT id FROM oy1n_user WHERE username='maestro01' LIMIT 1),
'Serie de Fibonacci — Programación I — Salón 1','Serie de Fibonacci',1,'Tarea de Yobani','programming','def fibonacci(n):\\n    a,b=0,1\\n    for _ in range(n):\\n        print(a)\\n        a,b=b,a+b\\nfibonacci(10)',100,3,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM oy1n_course c
WHERE c.shortname='salon01'
AND NOT EXISTS (SELECT 1 FROM oy1n_aiassignment aa WHERE aa.name='Serie de Fibonacci — Programación I — Salón 1' AND aa.course=c.id);

INSERT INTO oy1n_aiassignment (course,teacher_id,name,intro,introformat,description,type,solution,grade,maxattempts,timecreated,timemodified)
SELECT c.id,(SELECT id FROM oy1n_user WHERE username='maestro01' LIMIT 1),
'Factorial recursivo — Programación II — Salón 2','Factorial recursivo',1,'Tarea de Yobani','programming','def factorial(n):\\n    if n<=1: return 1\\n    return n*factorial(n-1)\\nprint(factorial(5))',100,3,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM oy1n_course c
WHERE c.shortname='salon02'
AND NOT EXISTS (SELECT 1 FROM oy1n_aiassignment aa WHERE aa.name='Factorial recursivo — Programación II — Salón 2' AND aa.course=c.id);

INSERT INTO oy1n_aiassignment (course,teacher_id,name,intro,introformat,description,type,solution,grade,maxattempts,timecreated,timemodified)
SELECT c.id,(SELECT id FROM oy1n_user WHERE username='maestro01' LIMIT 1),
'Serie de Fibonacci — Programación II — Salón 2','Serie de Fibonacci',1,'Tarea de Yobani','programming','def fibonacci(n):\\n    a,b=0,1\\n    for _ in range(n):\\n        print(a)\\n        a,b=b,a+b\\nfibonacci(10)',100,3,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM oy1n_course c
WHERE c.shortname='salon02'
AND NOT EXISTS (SELECT 1 FROM oy1n_aiassignment aa WHERE aa.name='Serie de Fibonacci — Programación II — Salón 2' AND aa.course=c.id);

-- Herman (maestro02)
INSERT INTO oy1n_aiassignment (course,teacher_id,name,intro,introformat,description,type,solution,grade,maxattempts,timecreated,timemodified)
SELECT c.id,(SELECT id FROM oy1n_user WHERE username='maestro02' LIMIT 1),
'Bubble Sort — Estructuras de Datos — Salón 3','Bubble Sort',1,'Tarea de Herman','programming','def bubble_sort(arr):\\n    n=len(arr)\\n    for i in range(n):\\n        for j in range(n-i-1):\\n            if arr[j]>arr[j+1]: arr[j],arr[j+1]=arr[j+1],arr[j]\\n    return arr\\nprint(bubble_sort([5,3,8,1,9]))',100,3,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM oy1n_course c
WHERE c.shortname='salon03'
AND NOT EXISTS (SELECT 1 FROM oy1n_aiassignment aa WHERE aa.name='Bubble Sort — Estructuras de Datos — Salón 3' AND aa.course=c.id);

INSERT INTO oy1n_aiassignment (course,teacher_id,name,intro,introformat,description,type,solution,grade,maxattempts,timecreated,timemodified)
SELECT c.id,(SELECT id FROM oy1n_user WHERE username='maestro02' LIMIT 1),
'Búsqueda binaria — Estructuras de Datos — Salón 3','Búsqueda binaria',1,'Tarea de Herman','programming','def binary_search(arr,target):\\n    l,r=0,len(arr)-1\\n    while l<=r:\\n        mid=(l+r)//2\\n        if arr[mid]==target: return mid\\n        elif arr[mid]<target: l=mid+1\\n        else: r=mid-1\\n    return -1\\nprint(binary_search([1,3,5,7,9],7))',100,3,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM oy1n_course c
WHERE c.shortname='salon03'
AND NOT EXISTS (SELECT 1 FROM oy1n_aiassignment aa WHERE aa.name='Búsqueda binaria — Estructuras de Datos — Salón 3' AND aa.course=c.id);

INSERT INTO oy1n_aiassignment (course,teacher_id,name,intro,introformat,description,type,solution,grade,maxattempts,timecreated,timemodified)
SELECT c.id,(SELECT id FROM oy1n_user WHERE username='maestro02' LIMIT 1),
'Bubble Sort — Algoritmos — Salón 4','Bubble Sort',1,'Tarea de Herman','programming','def bubble_sort(arr):\\n    n=len(arr)\\n    for i in range(n):\\n        for j in range(n-i-1):\\n            if arr[j]>arr[j+1]: arr[j],arr[j+1]=arr[j+1],arr[j]\\n    return arr\\nprint(bubble_sort([5,3,8,1,9]))',100,3,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM oy1n_course c
WHERE c.shortname='salon04'
AND NOT EXISTS (SELECT 1 FROM oy1n_aiassignment aa WHERE aa.name='Bubble Sort — Algoritmos — Salón 4' AND aa.course=c.id);

INSERT INTO oy1n_aiassignment (course,teacher_id,name,intro,introformat,description,type,solution,grade,maxattempts,timecreated,timemodified)
SELECT c.id,(SELECT id FROM oy1n_user WHERE username='maestro02' LIMIT 1),
'Búsqueda binaria — Algoritmos — Salón 4','Búsqueda binaria',1,'Tarea de Herman','programming','def binary_search(arr,target):\\n    l,r=0,len(arr)-1\\n    while l<=r:\\n        mid=(l+r)//2\\n        if arr[mid]==target: return mid\\n        elif arr[mid]<target: l=mid+1\\n        else: r=mid-1\\n    return -1\\nprint(binary_search([1,3,5,7,9],7))',100,3,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM oy1n_course c
WHERE c.shortname='salon04'
AND NOT EXISTS (SELECT 1 FROM oy1n_aiassignment aa WHERE aa.name='Búsqueda binaria — Algoritmos — Salón 4' AND aa.course=c.id);

-- Geovany (maestro03)
INSERT INTO oy1n_aiassignment (course,teacher_id,name,intro,introformat,description,type,solution,grade,maxattempts,timecreated,timemodified)
SELECT c.id,(SELECT id FROM oy1n_user WHERE username='maestro03' LIMIT 1),
'Consulta SQL con JOIN — Bases de Datos — Salón 5','Consulta SQL con JOIN',1,'Tarea de Geovany','programming','SELECT e.nombre, e.apellido, c.calificacion FROM estudiantes e INNER JOIN calificaciones c ON e.id=c.estudiante_id WHERE c.calificacion>=70 ORDER BY c.calificacion DESC;',100,3,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM oy1n_course c
WHERE c.shortname='salon05'
AND NOT EXISTS (SELECT 1 FROM oy1n_aiassignment aa WHERE aa.name='Consulta SQL con JOIN — Bases de Datos — Salón 5' AND aa.course=c.id);

INSERT INTO oy1n_aiassignment (course,teacher_id,name,intro,introformat,description,type,solution,grade,maxattempts,timecreated,timemodified)
SELECT c.id,(SELECT id FROM oy1n_user WHERE username='maestro03' LIMIT 1),
'Diagrama de clases UML — Bases de Datos — Salón 5','Diagrama de clases UML',1,'Tarea de Geovany','programming','Un sistema de biblioteca tiene las clases: Libro, Usuario, Prestamo y Bibliotecario con sus relaciones.',100,3,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM oy1n_course c
WHERE c.shortname='salon05'
AND NOT EXISTS (SELECT 1 FROM oy1n_aiassignment aa WHERE aa.name='Diagrama de clases UML — Bases de Datos — Salón 5' AND aa.course=c.id);

INSERT INTO oy1n_aiassignment (course,teacher_id,name,intro,introformat,description,type,solution,grade,maxattempts,timecreated,timemodified)
SELECT c.id,(SELECT id FROM oy1n_user WHERE username='maestro03' LIMIT 1),
'Consulta SQL con JOIN — Ingeniería de Software — Salón 6','Consulta SQL con JOIN',1,'Tarea de Geovany','programming','SELECT e.nombre, e.apellido, c.calificacion FROM estudiantes e INNER JOIN calificaciones c ON e.id=c.estudiante_id WHERE c.calificacion>=70 ORDER BY c.calificacion DESC;',100,3,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM oy1n_course c
WHERE c.shortname='salon06'
AND NOT EXISTS (SELECT 1 FROM oy1n_aiassignment aa WHERE aa.name='Consulta SQL con JOIN — Ingeniería de Software — Salón 6' AND aa.course=c.id);

INSERT INTO oy1n_aiassignment (course,teacher_id,name,intro,introformat,description,type,solution,grade,maxattempts,timecreated,timemodified)
SELECT c.id,(SELECT id FROM oy1n_user WHERE username='maestro03' LIMIT 1),
'Diagrama de clases UML — Ingeniería de Software — Salón 6','Diagrama de clases UML',1,'Tarea de Geovany','programming','Un sistema de biblioteca tiene las clases: Libro, Usuario, Prestamo y Bibliotecario con sus relaciones.',100,3,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM oy1n_course c
WHERE c.shortname='salon06'
AND NOT EXISTS (SELECT 1 FROM oy1n_aiassignment aa WHERE aa.name='Diagrama de clases UML — Ingeniería de Software — Salón 6' AND aa.course=c.id);

-- ══════════════════════════════════════════════════════════════
-- PASO 10: course_modules (actividades visibles en el curso)
-- Requiere que exista el módulo aiassignment en oy1n_modules
-- ══════════════════════════════════════════════════════════════
INSERT INTO oy1n_course_modules (course,module,instance,section,added)
SELECT c.id,m.id,a.id,cs.id,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_modules m ON m.name='aiassignment'
JOIN oy1n_course_sections cs ON cs.course=c.id AND cs.section=1
WHERE c.shortname='salon01' AND a.name='Factorial recursivo — Programación I — Salón 1'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_course_modules cm
  WHERE cm.course=c.id AND cm.module=m.id AND cm.instance=a.id
);

INSERT INTO oy1n_course_modules (course,module,instance,section,added)
SELECT c.id,m.id,a.id,cs.id,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_modules m ON m.name='aiassignment'
JOIN oy1n_course_sections cs ON cs.course=c.id AND cs.section=1
WHERE c.shortname='salon01' AND a.name='Serie de Fibonacci — Programación I — Salón 1'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_course_modules cm
  WHERE cm.course=c.id AND cm.module=m.id AND cm.instance=a.id
);

INSERT INTO oy1n_course_modules (course,module,instance,section,added)
SELECT c.id,m.id,a.id,cs.id,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_modules m ON m.name='aiassignment'
JOIN oy1n_course_sections cs ON cs.course=c.id AND cs.section=1
WHERE c.shortname='salon02' AND a.name='Factorial recursivo — Programación II — Salón 2'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_course_modules cm
  WHERE cm.course=c.id AND cm.module=m.id AND cm.instance=a.id
);

INSERT INTO oy1n_course_modules (course,module,instance,section,added)
SELECT c.id,m.id,a.id,cs.id,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_modules m ON m.name='aiassignment'
JOIN oy1n_course_sections cs ON cs.course=c.id AND cs.section=1
WHERE c.shortname='salon02' AND a.name='Serie de Fibonacci — Programación II — Salón 2'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_course_modules cm
  WHERE cm.course=c.id AND cm.module=m.id AND cm.instance=a.id
);

INSERT INTO oy1n_course_modules (course,module,instance,section,added)
SELECT c.id,m.id,a.id,cs.id,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_modules m ON m.name='aiassignment'
JOIN oy1n_course_sections cs ON cs.course=c.id AND cs.section=1
WHERE c.shortname='salon03' AND a.name='Bubble Sort — Estructuras de Datos — Salón 3'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_course_modules cm
  WHERE cm.course=c.id AND cm.module=m.id AND cm.instance=a.id
);

INSERT INTO oy1n_course_modules (course,module,instance,section,added)
SELECT c.id,m.id,a.id,cs.id,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_modules m ON m.name='aiassignment'
JOIN oy1n_course_sections cs ON cs.course=c.id AND cs.section=1
WHERE c.shortname='salon03' AND a.name='Búsqueda binaria — Estructuras de Datos — Salón 3'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_course_modules cm
  WHERE cm.course=c.id AND cm.module=m.id AND cm.instance=a.id
);

INSERT INTO oy1n_course_modules (course,module,instance,section,added)
SELECT c.id,m.id,a.id,cs.id,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_modules m ON m.name='aiassignment'
JOIN oy1n_course_sections cs ON cs.course=c.id AND cs.section=1
WHERE c.shortname='salon04' AND a.name='Bubble Sort — Algoritmos — Salón 4'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_course_modules cm
  WHERE cm.course=c.id AND cm.module=m.id AND cm.instance=a.id
);

INSERT INTO oy1n_course_modules (course,module,instance,section,added)
SELECT c.id,m.id,a.id,cs.id,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_modules m ON m.name='aiassignment'
JOIN oy1n_course_sections cs ON cs.course=c.id AND cs.section=1
WHERE c.shortname='salon04' AND a.name='Búsqueda binaria — Algoritmos — Salón 4'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_course_modules cm
  WHERE cm.course=c.id AND cm.module=m.id AND cm.instance=a.id
);

INSERT INTO oy1n_course_modules (course,module,instance,section,added)
SELECT c.id,m.id,a.id,cs.id,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_modules m ON m.name='aiassignment'
JOIN oy1n_course_sections cs ON cs.course=c.id AND cs.section=1
WHERE c.shortname='salon05' AND a.name='Consulta SQL con JOIN — Bases de Datos — Salón 5'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_course_modules cm
  WHERE cm.course=c.id AND cm.module=m.id AND cm.instance=a.id
);

INSERT INTO oy1n_course_modules (course,module,instance,section,added)
SELECT c.id,m.id,a.id,cs.id,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_modules m ON m.name='aiassignment'
JOIN oy1n_course_sections cs ON cs.course=c.id AND cs.section=1
WHERE c.shortname='salon05' AND a.name='Diagrama de clases UML — Bases de Datos — Salón 5'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_course_modules cm
  WHERE cm.course=c.id AND cm.module=m.id AND cm.instance=a.id
);

INSERT INTO oy1n_course_modules (course,module,instance,section,added)
SELECT c.id,m.id,a.id,cs.id,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_modules m ON m.name='aiassignment'
JOIN oy1n_course_sections cs ON cs.course=c.id AND cs.section=1
WHERE c.shortname='salon06' AND a.name='Consulta SQL con JOIN — Ingeniería de Software — Salón 6'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_course_modules cm
  WHERE cm.course=c.id AND cm.module=m.id AND cm.instance=a.id
);

INSERT INTO oy1n_course_modules (course,module,instance,section,added)
SELECT c.id,m.id,a.id,cs.id,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_modules m ON m.name='aiassignment'
JOIN oy1n_course_sections cs ON cs.course=c.id AND cs.section=1
WHERE c.shortname='salon06' AND a.name='Diagrama de clases UML — Ingeniería de Software — Salón 6'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_course_modules cm
  WHERE cm.course=c.id AND cm.module=m.id AND cm.instance=a.id
);

-- ══════════════════════════════════════════════════════════════
-- PASO 11: Contextos de módulo (CONTEXT_MODULE = 70)
-- ══════════════════════════════════════════════════════════════
INSERT INTO oy1n_context (contextlevel,instanceid,depth,path,locked)
SELECT 70,cm.id,0,'',0
FROM oy1n_course_modules cm
JOIN oy1n_modules m ON m.id=cm.module AND m.name='aiassignment'
JOIN oy1n_course c ON c.id=cm.course
WHERE c.shortname IN ('salon01','salon02','salon03','salon04','salon05','salon06')
AND NOT EXISTS (SELECT 1 FROM oy1n_context ctx WHERE ctx.contextlevel=70 AND ctx.instanceid=cm.id);

UPDATE oy1n_context modctx
INNER JOIN oy1n_course_modules cm ON modctx.instanceid=cm.id AND modctx.contextlevel=70
INNER JOIN oy1n_course c ON c.id=cm.course
INNER JOIN oy1n_context crsctx ON crsctx.contextlevel=50 AND crsctx.instanceid=c.id
SET modctx.path=CONCAT(crsctx.path,'/',modctx.id), modctx.depth=crsctx.depth+1
WHERE c.shortname IN ('salon01','salon02','salon03','salon04','salon05','salon06')
AND (modctx.path IS NULL OR modctx.path='');

-- Actualizar sequence de sección 1 con los cm ids
UPDATE oy1n_course_sections cs
INNER JOIN oy1n_course c ON cs.course=c.id
SET cs.sequence = (
  SELECT GROUP_CONCAT(cm.id ORDER BY cm.id SEPARATOR ',')
  FROM oy1n_course_modules cm
  JOIN oy1n_modules m ON m.id=cm.module AND m.name='aiassignment'
  WHERE cm.course=c.id AND cm.section=cs.id
)
WHERE c.shortname='salon01' AND cs.section=1;

UPDATE oy1n_course_sections cs
INNER JOIN oy1n_course c ON cs.course=c.id
SET cs.sequence = (
  SELECT GROUP_CONCAT(cm.id ORDER BY cm.id SEPARATOR ',')
  FROM oy1n_course_modules cm
  JOIN oy1n_modules m ON m.id=cm.module AND m.name='aiassignment'
  WHERE cm.course=c.id AND cm.section=cs.id
)
WHERE c.shortname='salon02' AND cs.section=1;

UPDATE oy1n_course_sections cs
INNER JOIN oy1n_course c ON cs.course=c.id
SET cs.sequence = (
  SELECT GROUP_CONCAT(cm.id ORDER BY cm.id SEPARATOR ',')
  FROM oy1n_course_modules cm
  JOIN oy1n_modules m ON m.id=cm.module AND m.name='aiassignment'
  WHERE cm.course=c.id AND cm.section=cs.id
)
WHERE c.shortname='salon03' AND cs.section=1;

UPDATE oy1n_course_sections cs
INNER JOIN oy1n_course c ON cs.course=c.id
SET cs.sequence = (
  SELECT GROUP_CONCAT(cm.id ORDER BY cm.id SEPARATOR ',')
  FROM oy1n_course_modules cm
  JOIN oy1n_modules m ON m.id=cm.module AND m.name='aiassignment'
  WHERE cm.course=c.id AND cm.section=cs.id
)
WHERE c.shortname='salon04' AND cs.section=1;

UPDATE oy1n_course_sections cs
INNER JOIN oy1n_course c ON cs.course=c.id
SET cs.sequence = (
  SELECT GROUP_CONCAT(cm.id ORDER BY cm.id SEPARATOR ',')
  FROM oy1n_course_modules cm
  JOIN oy1n_modules m ON m.id=cm.module AND m.name='aiassignment'
  WHERE cm.course=c.id AND cm.section=cs.id
)
WHERE c.shortname='salon05' AND cs.section=1;

UPDATE oy1n_course_sections cs
INNER JOIN oy1n_course c ON cs.course=c.id
SET cs.sequence = (
  SELECT GROUP_CONCAT(cm.id ORDER BY cm.id SEPARATOR ',')
  FROM oy1n_course_modules cm
  JOIN oy1n_modules m ON m.id=cm.module AND m.name='aiassignment'
  WHERE cm.course=c.id AND cm.section=cs.id
)
WHERE c.shortname='salon06' AND cs.section=1;

-- ══════════════════════════════════════════════════════════════
-- PASO 12: Limpiar envíos previos (re-ejecutable)
-- ══════════════════════════════════════════════════════════════
DELETE ev FROM oy1n_aiassignment_evaluations ev
INNER JOIN oy1n_aiassignment_submissions s ON ev.submission=s.id
INNER JOIN oy1n_user u ON s.userid=u.id
WHERE u.username LIKE 'al%_s0%';

DELETE s FROM oy1n_aiassignment_submissions s
INNER JOIN oy1n_user u ON s.userid=u.id
WHERE u.username LIKE 'al%_s0%';

-- ══════════════════════════════════════════════════════════════
-- PASO 13: Envíos (300 total, idempotente tras limpieza)
-- ══════════════════════════════════════════════════════════════
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_1(num):\\n    if num<=1: return 1\\n    return num*calc_fact_1(num-1)\\nprint(calc_fact_1(5))','evaluated',71.00,'PLAGIO: Programación I — Salón 1 alumno 1',1,UNIX_TIMESTAMP()-170281,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al01_salon01'
WHERE c.shortname='salon01' AND a.name='Factorial recursivo — Programación I — Salón 1'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_2(num):\\n    if num<=1: return 1\\n    return num*calc_fact_2(num-1)\\nprint(calc_fact_2(5))','evaluated',72.00,'PLAGIO: Programación I — Salón 1 alumno 2',1,UNIX_TIMESTAMP()-393865,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al02_salon01'
WHERE c.shortname='salon01' AND a.name='Factorial recursivo — Programación I — Salón 1'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_3(n):\\n    r=1\\n    while n>1:\\n        r*=n\\n        n-=1\\n    return r\\nprint(fact_iter_3(5))','evaluated',73.00,'SOSPECHOSO: Programación I — Salón 1 alumno 3',1,UNIX_TIMESTAMP()-361,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al03_salon01'
WHERE c.shortname='salon01' AND a.name='Factorial recursivo — Programación I — Salón 1'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_4(n):\\n    if n<=1: return 1\\n    return n*factorial_4(n-1)\\nprint(factorial_4(5))','evaluated',74.00,'ORIGINAL: Programación I — Salón 1 alumno 4',1,UNIX_TIMESTAMP()-105738,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al04_salon01'
WHERE c.shortname='salon01' AND a.name='Factorial recursivo — Programación I — Salón 1'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_5(n):\\n    if n<=1: return 1\\n    return n*factorial_5(n-1)\\nprint(factorial_5(5))','evaluated',75.00,'ORIGINAL: Programación I — Salón 1 alumno 5',1,UNIX_TIMESTAMP()-869932,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al05_salon01'
WHERE c.shortname='salon01' AND a.name='Factorial recursivo — Programación I — Salón 1'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_6(num):\\n    if num<=1: return 1\\n    return num*calc_fact_6(num-1)\\nprint(calc_fact_6(5))','evaluated',76.00,'PLAGIO: Programación I — Salón 1 alumno 6',1,UNIX_TIMESTAMP()-519195,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al06_salon01'
WHERE c.shortname='salon01' AND a.name='Factorial recursivo — Programación I — Salón 1'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_7(num):\\n    if num<=1: return 1\\n    return num*calc_fact_7(num-1)\\nprint(calc_fact_7(5))','evaluated',77.00,'PLAGIO: Programación I — Salón 1 alumno 7',1,UNIX_TIMESTAMP()-407624,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al07_salon01'
WHERE c.shortname='salon01' AND a.name='Factorial recursivo — Programación I — Salón 1'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_8(n):\\n    r=1\\n    while n>1:\\n        r*=n\\n        n-=1\\n    return r\\nprint(fact_iter_8(5))','evaluated',78.00,'SOSPECHOSO: Programación I — Salón 1 alumno 8',1,UNIX_TIMESTAMP()-760334,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al08_salon01'
WHERE c.shortname='salon01' AND a.name='Factorial recursivo — Programación I — Salón 1'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_9(n):\\n    if n<=1: return 1\\n    return n*factorial_9(n-1)\\nprint(factorial_9(5))','evaluated',79.00,'ORIGINAL: Programación I — Salón 1 alumno 9',1,UNIX_TIMESTAMP()-330839,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al09_salon01'
WHERE c.shortname='salon01' AND a.name='Factorial recursivo — Programación I — Salón 1'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_10(n):\\n    if n<=1: return 1\\n    return n*factorial_10(n-1)\\nprint(factorial_10(5))','evaluated',80.00,'ORIGINAL: Programación I — Salón 1 alumno 10',1,UNIX_TIMESTAMP()-43498,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al10_salon01'
WHERE c.shortname='salon01' AND a.name='Factorial recursivo — Programación I — Salón 1'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_11(num):\\n    if num<=1: return 1\\n    return num*calc_fact_11(num-1)\\nprint(calc_fact_11(5))','evaluated',81.00,'PLAGIO: Programación I — Salón 1 alumno 11',1,UNIX_TIMESTAMP()-686253,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al11_salon01'
WHERE c.shortname='salon01' AND a.name='Factorial recursivo — Programación I — Salón 1'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_12(num):\\n    if num<=1: return 1\\n    return num*calc_fact_12(num-1)\\nprint(calc_fact_12(5))','evaluated',82.00,'PLAGIO: Programación I — Salón 1 alumno 12',1,UNIX_TIMESTAMP()-569422,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al12_salon01'
WHERE c.shortname='salon01' AND a.name='Factorial recursivo — Programación I — Salón 1'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_13(n):\\n    r=1\\n    while n>1:\\n        r*=n\\n        n-=1\\n    return r\\nprint(fact_iter_13(5))','evaluated',83.00,'SOSPECHOSO: Programación I — Salón 1 alumno 13',1,UNIX_TIMESTAMP()-769379,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al13_salon01'
WHERE c.shortname='salon01' AND a.name='Factorial recursivo — Programación I — Salón 1'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_14(n):\\n    if n<=1: return 1\\n    return n*factorial_14(n-1)\\nprint(factorial_14(5))','evaluated',84.00,'ORIGINAL: Programación I — Salón 1 alumno 14',1,UNIX_TIMESTAMP()-1054240,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al14_salon01'
WHERE c.shortname='salon01' AND a.name='Factorial recursivo — Programación I — Salón 1'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_15(n):\\n    if n<=1: return 1\\n    return n*factorial_15(n-1)\\nprint(factorial_15(5))','evaluated',85.00,'ORIGINAL: Programación I — Salón 1 alumno 15',1,UNIX_TIMESTAMP()-1019191,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al15_salon01'
WHERE c.shortname='salon01' AND a.name='Factorial recursivo — Programación I — Salón 1'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_16(num):\\n    if num<=1: return 1\\n    return num*calc_fact_16(num-1)\\nprint(calc_fact_16(5))','evaluated',86.00,'PLAGIO: Programación I — Salón 1 alumno 16',1,UNIX_TIMESTAMP()-454214,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al16_salon01'
WHERE c.shortname='salon01' AND a.name='Factorial recursivo — Programación I — Salón 1'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_17(num):\\n    if num<=1: return 1\\n    return num*calc_fact_17(num-1)\\nprint(calc_fact_17(5))','evaluated',87.00,'PLAGIO: Programación I — Salón 1 alumno 17',1,UNIX_TIMESTAMP()-1041720,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al17_salon01'
WHERE c.shortname='salon01' AND a.name='Factorial recursivo — Programación I — Salón 1'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_18(n):\\n    r=1\\n    while n>1:\\n        r*=n\\n        n-=1\\n    return r\\nprint(fact_iter_18(5))','evaluated',88.00,'SOSPECHOSO: Programación I — Salón 1 alumno 18',1,UNIX_TIMESTAMP()-1088090,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al18_salon01'
WHERE c.shortname='salon01' AND a.name='Factorial recursivo — Programación I — Salón 1'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_19(n):\\n    if n<=1: return 1\\n    return n*factorial_19(n-1)\\nprint(factorial_19(5))','evaluated',89.00,'ORIGINAL: Programación I — Salón 1 alumno 19',1,UNIX_TIMESTAMP()-942446,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al19_salon01'
WHERE c.shortname='salon01' AND a.name='Factorial recursivo — Programación I — Salón 1'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_20(n):\\n    if n<=1: return 1\\n    return n*factorial_20(n-1)\\nprint(factorial_20(5))','evaluated',90.00,'ORIGINAL: Programación I — Salón 1 alumno 20',1,UNIX_TIMESTAMP()-725134,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al20_salon01'
WHERE c.shortname='salon01' AND a.name='Factorial recursivo — Programación I — Salón 1'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_21(num):\\n    if num<=1: return 1\\n    return num*calc_fact_21(num-1)\\nprint(calc_fact_21(5))','evaluated',91.00,'PLAGIO: Programación I — Salón 1 alumno 21',1,UNIX_TIMESTAMP()-457163,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al21_salon01'
WHERE c.shortname='salon01' AND a.name='Factorial recursivo — Programación I — Salón 1'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_22(num):\\n    if num<=1: return 1\\n    return num*calc_fact_22(num-1)\\nprint(calc_fact_22(5))','evaluated',92.00,'PLAGIO: Programación I — Salón 1 alumno 22',1,UNIX_TIMESTAMP()-839389,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al22_salon01'
WHERE c.shortname='salon01' AND a.name='Factorial recursivo — Programación I — Salón 1'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_23(n):\\n    r=1\\n    while n>1:\\n        r*=n\\n        n-=1\\n    return r\\nprint(fact_iter_23(5))','evaluated',93.00,'SOSPECHOSO: Programación I — Salón 1 alumno 23',1,UNIX_TIMESTAMP()-802291,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al23_salon01'
WHERE c.shortname='salon01' AND a.name='Factorial recursivo — Programación I — Salón 1'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_24(n):\\n    if n<=1: return 1\\n    return n*factorial_24(n-1)\\nprint(factorial_24(5))','evaluated',94.00,'ORIGINAL: Programación I — Salón 1 alumno 24',1,UNIX_TIMESTAMP()-935937,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al24_salon01'
WHERE c.shortname='salon01' AND a.name='Factorial recursivo — Programación I — Salón 1'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_25(n):\\n    if n<=1: return 1\\n    return n*factorial_25(n-1)\\nprint(factorial_25(5))','evaluated',70.00,'ORIGINAL: Programación I — Salón 1 alumno 25',1,UNIX_TIMESTAMP()-1161536,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al25_salon01'
WHERE c.shortname='salon01' AND a.name='Factorial recursivo — Programación I — Salón 1'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def serie_1(num):\\n    x,y=0,1\\n    for _ in range(num):\\n        print(x)\\n        x,y=y,x+y\\nserie_1(10)','evaluated',71.00,'PLAGIO: Programación I — Salón 1 alumno 1',1,UNIX_TIMESTAMP()-1187257,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al01_salon01'
WHERE c.shortname='salon01' AND a.name='Serie de Fibonacci — Programación I — Salón 1'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def serie_2(num):\\n    x,y=0,1\\n    for _ in range(num):\\n        print(x)\\n        x,y=y,x+y\\nserie_2(10)','evaluated',72.00,'PLAGIO: Programación I — Salón 1 alumno 2',1,UNIX_TIMESTAMP()-1055480,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al02_salon01'
WHERE c.shortname='salon01' AND a.name='Serie de Fibonacci — Programación I — Salón 1'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fib_rec_3(n):\\n    if n<=1: return n\\n    return fib_rec_3(n-1)+fib_rec_3(n-2)\\nfor i in range(10): print(fib_rec_3(i))','evaluated',73.00,'SOSPECHOSO: Programación I — Salón 1 alumno 3',1,UNIX_TIMESTAMP()-1068209,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al03_salon01'
WHERE c.shortname='salon01' AND a.name='Serie de Fibonacci — Programación I — Salón 1'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fib_4(n):\\n    a,b=0,1\\n    for _ in range(n):\\n        print(a)\\n        a,b=b,a+b\\nfib_4(10)','evaluated',74.00,'ORIGINAL: Programación I — Salón 1 alumno 4',1,UNIX_TIMESTAMP()-667857,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al04_salon01'
WHERE c.shortname='salon01' AND a.name='Serie de Fibonacci — Programación I — Salón 1'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fib_5(n):\\n    a,b=0,1\\n    for _ in range(n):\\n        print(a)\\n        a,b=b,a+b\\nfib_5(10)','evaluated',75.00,'ORIGINAL: Programación I — Salón 1 alumno 5',1,UNIX_TIMESTAMP()-871881,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al05_salon01'
WHERE c.shortname='salon01' AND a.name='Serie de Fibonacci — Programación I — Salón 1'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def serie_6(num):\\n    x,y=0,1\\n    for _ in range(num):\\n        print(x)\\n        x,y=y,x+y\\nserie_6(10)','evaluated',76.00,'PLAGIO: Programación I — Salón 1 alumno 6',1,UNIX_TIMESTAMP()-983807,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al06_salon01'
WHERE c.shortname='salon01' AND a.name='Serie de Fibonacci — Programación I — Salón 1'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def serie_7(num):\\n    x,y=0,1\\n    for _ in range(num):\\n        print(x)\\n        x,y=y,x+y\\nserie_7(10)','evaluated',77.00,'PLAGIO: Programación I — Salón 1 alumno 7',1,UNIX_TIMESTAMP()-400206,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al07_salon01'
WHERE c.shortname='salon01' AND a.name='Serie de Fibonacci — Programación I — Salón 1'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fib_rec_8(n):\\n    if n<=1: return n\\n    return fib_rec_8(n-1)+fib_rec_8(n-2)\\nfor i in range(10): print(fib_rec_8(i))','evaluated',78.00,'SOSPECHOSO: Programación I — Salón 1 alumno 8',1,UNIX_TIMESTAMP()-948278,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al08_salon01'
WHERE c.shortname='salon01' AND a.name='Serie de Fibonacci — Programación I — Salón 1'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fib_9(n):\\n    a,b=0,1\\n    for _ in range(n):\\n        print(a)\\n        a,b=b,a+b\\nfib_9(10)','evaluated',79.00,'ORIGINAL: Programación I — Salón 1 alumno 9',1,UNIX_TIMESTAMP()-1051866,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al09_salon01'
WHERE c.shortname='salon01' AND a.name='Serie de Fibonacci — Programación I — Salón 1'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fib_10(n):\\n    a,b=0,1\\n    for _ in range(n):\\n        print(a)\\n        a,b=b,a+b\\nfib_10(10)','evaluated',80.00,'ORIGINAL: Programación I — Salón 1 alumno 10',1,UNIX_TIMESTAMP()-88926,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al10_salon01'
WHERE c.shortname='salon01' AND a.name='Serie de Fibonacci — Programación I — Salón 1'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def serie_11(num):\\n    x,y=0,1\\n    for _ in range(num):\\n        print(x)\\n        x,y=y,x+y\\nserie_11(10)','evaluated',81.00,'PLAGIO: Programación I — Salón 1 alumno 11',1,UNIX_TIMESTAMP()-11523,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al11_salon01'
WHERE c.shortname='salon01' AND a.name='Serie de Fibonacci — Programación I — Salón 1'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def serie_12(num):\\n    x,y=0,1\\n    for _ in range(num):\\n        print(x)\\n        x,y=y,x+y\\nserie_12(10)','evaluated',82.00,'PLAGIO: Programación I — Salón 1 alumno 12',1,UNIX_TIMESTAMP()-823756,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al12_salon01'
WHERE c.shortname='salon01' AND a.name='Serie de Fibonacci — Programación I — Salón 1'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fib_rec_13(n):\\n    if n<=1: return n\\n    return fib_rec_13(n-1)+fib_rec_13(n-2)\\nfor i in range(10): print(fib_rec_13(i))','evaluated',83.00,'SOSPECHOSO: Programación I — Salón 1 alumno 13',1,UNIX_TIMESTAMP()-1069173,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al13_salon01'
WHERE c.shortname='salon01' AND a.name='Serie de Fibonacci — Programación I — Salón 1'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fib_14(n):\\n    a,b=0,1\\n    for _ in range(n):\\n        print(a)\\n        a,b=b,a+b\\nfib_14(10)','evaluated',84.00,'ORIGINAL: Programación I — Salón 1 alumno 14',1,UNIX_TIMESTAMP()-515342,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al14_salon01'
WHERE c.shortname='salon01' AND a.name='Serie de Fibonacci — Programación I — Salón 1'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fib_15(n):\\n    a,b=0,1\\n    for _ in range(n):\\n        print(a)\\n        a,b=b,a+b\\nfib_15(10)','evaluated',85.00,'ORIGINAL: Programación I — Salón 1 alumno 15',1,UNIX_TIMESTAMP()-660995,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al15_salon01'
WHERE c.shortname='salon01' AND a.name='Serie de Fibonacci — Programación I — Salón 1'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def serie_16(num):\\n    x,y=0,1\\n    for _ in range(num):\\n        print(x)\\n        x,y=y,x+y\\nserie_16(10)','evaluated',86.00,'PLAGIO: Programación I — Salón 1 alumno 16',1,UNIX_TIMESTAMP()-720151,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al16_salon01'
WHERE c.shortname='salon01' AND a.name='Serie de Fibonacci — Programación I — Salón 1'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def serie_17(num):\\n    x,y=0,1\\n    for _ in range(num):\\n        print(x)\\n        x,y=y,x+y\\nserie_17(10)','evaluated',87.00,'PLAGIO: Programación I — Salón 1 alumno 17',1,UNIX_TIMESTAMP()-203199,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al17_salon01'
WHERE c.shortname='salon01' AND a.name='Serie de Fibonacci — Programación I — Salón 1'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fib_rec_18(n):\\n    if n<=1: return n\\n    return fib_rec_18(n-1)+fib_rec_18(n-2)\\nfor i in range(10): print(fib_rec_18(i))','evaluated',88.00,'SOSPECHOSO: Programación I — Salón 1 alumno 18',1,UNIX_TIMESTAMP()-905331,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al18_salon01'
WHERE c.shortname='salon01' AND a.name='Serie de Fibonacci — Programación I — Salón 1'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fib_19(n):\\n    a,b=0,1\\n    for _ in range(n):\\n        print(a)\\n        a,b=b,a+b\\nfib_19(10)','evaluated',89.00,'ORIGINAL: Programación I — Salón 1 alumno 19',1,UNIX_TIMESTAMP()-349091,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al19_salon01'
WHERE c.shortname='salon01' AND a.name='Serie de Fibonacci — Programación I — Salón 1'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fib_20(n):\\n    a,b=0,1\\n    for _ in range(n):\\n        print(a)\\n        a,b=b,a+b\\nfib_20(10)','evaluated',90.00,'ORIGINAL: Programación I — Salón 1 alumno 20',1,UNIX_TIMESTAMP()-129614,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al20_salon01'
WHERE c.shortname='salon01' AND a.name='Serie de Fibonacci — Programación I — Salón 1'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def serie_21(num):\\n    x,y=0,1\\n    for _ in range(num):\\n        print(x)\\n        x,y=y,x+y\\nserie_21(10)','evaluated',91.00,'PLAGIO: Programación I — Salón 1 alumno 21',1,UNIX_TIMESTAMP()-746355,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al21_salon01'
WHERE c.shortname='salon01' AND a.name='Serie de Fibonacci — Programación I — Salón 1'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def serie_22(num):\\n    x,y=0,1\\n    for _ in range(num):\\n        print(x)\\n        x,y=y,x+y\\nserie_22(10)','evaluated',92.00,'PLAGIO: Programación I — Salón 1 alumno 22',1,UNIX_TIMESTAMP()-992641,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al22_salon01'
WHERE c.shortname='salon01' AND a.name='Serie de Fibonacci — Programación I — Salón 1'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fib_rec_23(n):\\n    if n<=1: return n\\n    return fib_rec_23(n-1)+fib_rec_23(n-2)\\nfor i in range(10): print(fib_rec_23(i))','evaluated',93.00,'SOSPECHOSO: Programación I — Salón 1 alumno 23',1,UNIX_TIMESTAMP()-47532,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al23_salon01'
WHERE c.shortname='salon01' AND a.name='Serie de Fibonacci — Programación I — Salón 1'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fib_24(n):\\n    a,b=0,1\\n    for _ in range(n):\\n        print(a)\\n        a,b=b,a+b\\nfib_24(10)','evaluated',94.00,'ORIGINAL: Programación I — Salón 1 alumno 24',1,UNIX_TIMESTAMP()-529247,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al24_salon01'
WHERE c.shortname='salon01' AND a.name='Serie de Fibonacci — Programación I — Salón 1'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fib_25(n):\\n    a,b=0,1\\n    for _ in range(n):\\n        print(a)\\n        a,b=b,a+b\\nfib_25(10)','evaluated',70.00,'ORIGINAL: Programación I — Salón 1 alumno 25',1,UNIX_TIMESTAMP()-977179,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al25_salon01'
WHERE c.shortname='salon01' AND a.name='Serie de Fibonacci — Programación I — Salón 1'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_1(num):\\n    if num<=1: return 1\\n    return num*calc_fact_1(num-1)\\nprint(calc_fact_1(5))','evaluated',71.00,'PLAGIO: Programación II — Salón 2 alumno 1',1,UNIX_TIMESTAMP()-831028,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al01_salon02'
WHERE c.shortname='salon02' AND a.name='Factorial recursivo — Programación II — Salón 2'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_2(num):\\n    if num<=1: return 1\\n    return num*calc_fact_2(num-1)\\nprint(calc_fact_2(5))','evaluated',72.00,'PLAGIO: Programación II — Salón 2 alumno 2',1,UNIX_TIMESTAMP()-48878,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al02_salon02'
WHERE c.shortname='salon02' AND a.name='Factorial recursivo — Programación II — Salón 2'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_3(n):\\n    r=1\\n    while n>1:\\n        r*=n\\n        n-=1\\n    return r\\nprint(fact_iter_3(5))','evaluated',73.00,'SOSPECHOSO: Programación II — Salón 2 alumno 3',1,UNIX_TIMESTAMP()-874622,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al03_salon02'
WHERE c.shortname='salon02' AND a.name='Factorial recursivo — Programación II — Salón 2'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_4(n):\\n    if n<=1: return 1\\n    return n*factorial_4(n-1)\\nprint(factorial_4(5))','evaluated',74.00,'ORIGINAL: Programación II — Salón 2 alumno 4',1,UNIX_TIMESTAMP()-1122810,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al04_salon02'
WHERE c.shortname='salon02' AND a.name='Factorial recursivo — Programación II — Salón 2'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_5(n):\\n    if n<=1: return 1\\n    return n*factorial_5(n-1)\\nprint(factorial_5(5))','evaluated',75.00,'ORIGINAL: Programación II — Salón 2 alumno 5',1,UNIX_TIMESTAMP()-463585,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al05_salon02'
WHERE c.shortname='salon02' AND a.name='Factorial recursivo — Programación II — Salón 2'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_6(num):\\n    if num<=1: return 1\\n    return num*calc_fact_6(num-1)\\nprint(calc_fact_6(5))','evaluated',76.00,'PLAGIO: Programación II — Salón 2 alumno 6',1,UNIX_TIMESTAMP()-1085593,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al06_salon02'
WHERE c.shortname='salon02' AND a.name='Factorial recursivo — Programación II — Salón 2'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_7(num):\\n    if num<=1: return 1\\n    return num*calc_fact_7(num-1)\\nprint(calc_fact_7(5))','evaluated',77.00,'PLAGIO: Programación II — Salón 2 alumno 7',1,UNIX_TIMESTAMP()-921174,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al07_salon02'
WHERE c.shortname='salon02' AND a.name='Factorial recursivo — Programación II — Salón 2'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_8(n):\\n    r=1\\n    while n>1:\\n        r*=n\\n        n-=1\\n    return r\\nprint(fact_iter_8(5))','evaluated',78.00,'SOSPECHOSO: Programación II — Salón 2 alumno 8',1,UNIX_TIMESTAMP()-315253,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al08_salon02'
WHERE c.shortname='salon02' AND a.name='Factorial recursivo — Programación II — Salón 2'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_9(n):\\n    if n<=1: return 1\\n    return n*factorial_9(n-1)\\nprint(factorial_9(5))','evaluated',79.00,'ORIGINAL: Programación II — Salón 2 alumno 9',1,UNIX_TIMESTAMP()-862726,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al09_salon02'
WHERE c.shortname='salon02' AND a.name='Factorial recursivo — Programación II — Salón 2'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_10(n):\\n    if n<=1: return 1\\n    return n*factorial_10(n-1)\\nprint(factorial_10(5))','evaluated',80.00,'ORIGINAL: Programación II — Salón 2 alumno 10',1,UNIX_TIMESTAMP()-193059,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al10_salon02'
WHERE c.shortname='salon02' AND a.name='Factorial recursivo — Programación II — Salón 2'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_11(num):\\n    if num<=1: return 1\\n    return num*calc_fact_11(num-1)\\nprint(calc_fact_11(5))','evaluated',81.00,'PLAGIO: Programación II — Salón 2 alumno 11',1,UNIX_TIMESTAMP()-407466,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al11_salon02'
WHERE c.shortname='salon02' AND a.name='Factorial recursivo — Programación II — Salón 2'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_12(num):\\n    if num<=1: return 1\\n    return num*calc_fact_12(num-1)\\nprint(calc_fact_12(5))','evaluated',82.00,'PLAGIO: Programación II — Salón 2 alumno 12',1,UNIX_TIMESTAMP()-970522,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al12_salon02'
WHERE c.shortname='salon02' AND a.name='Factorial recursivo — Programación II — Salón 2'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_13(n):\\n    r=1\\n    while n>1:\\n        r*=n\\n        n-=1\\n    return r\\nprint(fact_iter_13(5))','evaluated',83.00,'SOSPECHOSO: Programación II — Salón 2 alumno 13',1,UNIX_TIMESTAMP()-458392,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al13_salon02'
WHERE c.shortname='salon02' AND a.name='Factorial recursivo — Programación II — Salón 2'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_14(n):\\n    if n<=1: return 1\\n    return n*factorial_14(n-1)\\nprint(factorial_14(5))','evaluated',84.00,'ORIGINAL: Programación II — Salón 2 alumno 14',1,UNIX_TIMESTAMP()-264941,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al14_salon02'
WHERE c.shortname='salon02' AND a.name='Factorial recursivo — Programación II — Salón 2'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_15(n):\\n    if n<=1: return 1\\n    return n*factorial_15(n-1)\\nprint(factorial_15(5))','evaluated',85.00,'ORIGINAL: Programación II — Salón 2 alumno 15',1,UNIX_TIMESTAMP()-890186,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al15_salon02'
WHERE c.shortname='salon02' AND a.name='Factorial recursivo — Programación II — Salón 2'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_16(num):\\n    if num<=1: return 1\\n    return num*calc_fact_16(num-1)\\nprint(calc_fact_16(5))','evaluated',86.00,'PLAGIO: Programación II — Salón 2 alumno 16',1,UNIX_TIMESTAMP()-130790,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al16_salon02'
WHERE c.shortname='salon02' AND a.name='Factorial recursivo — Programación II — Salón 2'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_17(num):\\n    if num<=1: return 1\\n    return num*calc_fact_17(num-1)\\nprint(calc_fact_17(5))','evaluated',87.00,'PLAGIO: Programación II — Salón 2 alumno 17',1,UNIX_TIMESTAMP()-883155,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al17_salon02'
WHERE c.shortname='salon02' AND a.name='Factorial recursivo — Programación II — Salón 2'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_18(n):\\n    r=1\\n    while n>1:\\n        r*=n\\n        n-=1\\n    return r\\nprint(fact_iter_18(5))','evaluated',88.00,'SOSPECHOSO: Programación II — Salón 2 alumno 18',1,UNIX_TIMESTAMP()-360351,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al18_salon02'
WHERE c.shortname='salon02' AND a.name='Factorial recursivo — Programación II — Salón 2'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_19(n):\\n    if n<=1: return 1\\n    return n*factorial_19(n-1)\\nprint(factorial_19(5))','evaluated',89.00,'ORIGINAL: Programación II — Salón 2 alumno 19',1,UNIX_TIMESTAMP()-368366,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al19_salon02'
WHERE c.shortname='salon02' AND a.name='Factorial recursivo — Programación II — Salón 2'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_20(n):\\n    if n<=1: return 1\\n    return n*factorial_20(n-1)\\nprint(factorial_20(5))','evaluated',90.00,'ORIGINAL: Programación II — Salón 2 alumno 20',1,UNIX_TIMESTAMP()-273553,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al20_salon02'
WHERE c.shortname='salon02' AND a.name='Factorial recursivo — Programación II — Salón 2'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_21(num):\\n    if num<=1: return 1\\n    return num*calc_fact_21(num-1)\\nprint(calc_fact_21(5))','evaluated',91.00,'PLAGIO: Programación II — Salón 2 alumno 21',1,UNIX_TIMESTAMP()-974987,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al21_salon02'
WHERE c.shortname='salon02' AND a.name='Factorial recursivo — Programación II — Salón 2'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_22(num):\\n    if num<=1: return 1\\n    return num*calc_fact_22(num-1)\\nprint(calc_fact_22(5))','evaluated',92.00,'PLAGIO: Programación II — Salón 2 alumno 22',1,UNIX_TIMESTAMP()-969734,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al22_salon02'
WHERE c.shortname='salon02' AND a.name='Factorial recursivo — Programación II — Salón 2'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_23(n):\\n    r=1\\n    while n>1:\\n        r*=n\\n        n-=1\\n    return r\\nprint(fact_iter_23(5))','evaluated',93.00,'SOSPECHOSO: Programación II — Salón 2 alumno 23',1,UNIX_TIMESTAMP()-164683,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al23_salon02'
WHERE c.shortname='salon02' AND a.name='Factorial recursivo — Programación II — Salón 2'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_24(n):\\n    if n<=1: return 1\\n    return n*factorial_24(n-1)\\nprint(factorial_24(5))','evaluated',94.00,'ORIGINAL: Programación II — Salón 2 alumno 24',1,UNIX_TIMESTAMP()-1014745,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al24_salon02'
WHERE c.shortname='salon02' AND a.name='Factorial recursivo — Programación II — Salón 2'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_25(n):\\n    if n<=1: return 1\\n    return n*factorial_25(n-1)\\nprint(factorial_25(5))','evaluated',70.00,'ORIGINAL: Programación II — Salón 2 alumno 25',1,UNIX_TIMESTAMP()-430069,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al25_salon02'
WHERE c.shortname='salon02' AND a.name='Factorial recursivo — Programación II — Salón 2'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def serie_1(num):\\n    x,y=0,1\\n    for _ in range(num):\\n        print(x)\\n        x,y=y,x+y\\nserie_1(10)','evaluated',71.00,'PLAGIO: Programación II — Salón 2 alumno 1',1,UNIX_TIMESTAMP()-516933,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al01_salon02'
WHERE c.shortname='salon02' AND a.name='Serie de Fibonacci — Programación II — Salón 2'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def serie_2(num):\\n    x,y=0,1\\n    for _ in range(num):\\n        print(x)\\n        x,y=y,x+y\\nserie_2(10)','evaluated',72.00,'PLAGIO: Programación II — Salón 2 alumno 2',1,UNIX_TIMESTAMP()-560051,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al02_salon02'
WHERE c.shortname='salon02' AND a.name='Serie de Fibonacci — Programación II — Salón 2'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fib_rec_3(n):\\n    if n<=1: return n\\n    return fib_rec_3(n-1)+fib_rec_3(n-2)\\nfor i in range(10): print(fib_rec_3(i))','evaluated',73.00,'SOSPECHOSO: Programación II — Salón 2 alumno 3',1,UNIX_TIMESTAMP()-115498,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al03_salon02'
WHERE c.shortname='salon02' AND a.name='Serie de Fibonacci — Programación II — Salón 2'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fib_4(n):\\n    a,b=0,1\\n    for _ in range(n):\\n        print(a)\\n        a,b=b,a+b\\nfib_4(10)','evaluated',74.00,'ORIGINAL: Programación II — Salón 2 alumno 4',1,UNIX_TIMESTAMP()-12717,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al04_salon02'
WHERE c.shortname='salon02' AND a.name='Serie de Fibonacci — Programación II — Salón 2'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fib_5(n):\\n    a,b=0,1\\n    for _ in range(n):\\n        print(a)\\n        a,b=b,a+b\\nfib_5(10)','evaluated',75.00,'ORIGINAL: Programación II — Salón 2 alumno 5',1,UNIX_TIMESTAMP()-336100,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al05_salon02'
WHERE c.shortname='salon02' AND a.name='Serie de Fibonacci — Programación II — Salón 2'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def serie_6(num):\\n    x,y=0,1\\n    for _ in range(num):\\n        print(x)\\n        x,y=y,x+y\\nserie_6(10)','evaluated',76.00,'PLAGIO: Programación II — Salón 2 alumno 6',1,UNIX_TIMESTAMP()-588816,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al06_salon02'
WHERE c.shortname='salon02' AND a.name='Serie de Fibonacci — Programación II — Salón 2'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def serie_7(num):\\n    x,y=0,1\\n    for _ in range(num):\\n        print(x)\\n        x,y=y,x+y\\nserie_7(10)','evaluated',77.00,'PLAGIO: Programación II — Salón 2 alumno 7',1,UNIX_TIMESTAMP()-144853,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al07_salon02'
WHERE c.shortname='salon02' AND a.name='Serie de Fibonacci — Programación II — Salón 2'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fib_rec_8(n):\\n    if n<=1: return n\\n    return fib_rec_8(n-1)+fib_rec_8(n-2)\\nfor i in range(10): print(fib_rec_8(i))','evaluated',78.00,'SOSPECHOSO: Programación II — Salón 2 alumno 8',1,UNIX_TIMESTAMP()-771371,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al08_salon02'
WHERE c.shortname='salon02' AND a.name='Serie de Fibonacci — Programación II — Salón 2'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fib_9(n):\\n    a,b=0,1\\n    for _ in range(n):\\n        print(a)\\n        a,b=b,a+b\\nfib_9(10)','evaluated',79.00,'ORIGINAL: Programación II — Salón 2 alumno 9',1,UNIX_TIMESTAMP()-851066,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al09_salon02'
WHERE c.shortname='salon02' AND a.name='Serie de Fibonacci — Programación II — Salón 2'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fib_10(n):\\n    a,b=0,1\\n    for _ in range(n):\\n        print(a)\\n        a,b=b,a+b\\nfib_10(10)','evaluated',80.00,'ORIGINAL: Programación II — Salón 2 alumno 10',1,UNIX_TIMESTAMP()-497619,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al10_salon02'
WHERE c.shortname='salon02' AND a.name='Serie de Fibonacci — Programación II — Salón 2'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def serie_11(num):\\n    x,y=0,1\\n    for _ in range(num):\\n        print(x)\\n        x,y=y,x+y\\nserie_11(10)','evaluated',81.00,'PLAGIO: Programación II — Salón 2 alumno 11',1,UNIX_TIMESTAMP()-722163,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al11_salon02'
WHERE c.shortname='salon02' AND a.name='Serie de Fibonacci — Programación II — Salón 2'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def serie_12(num):\\n    x,y=0,1\\n    for _ in range(num):\\n        print(x)\\n        x,y=y,x+y\\nserie_12(10)','evaluated',82.00,'PLAGIO: Programación II — Salón 2 alumno 12',1,UNIX_TIMESTAMP()-207246,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al12_salon02'
WHERE c.shortname='salon02' AND a.name='Serie de Fibonacci — Programación II — Salón 2'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fib_rec_13(n):\\n    if n<=1: return n\\n    return fib_rec_13(n-1)+fib_rec_13(n-2)\\nfor i in range(10): print(fib_rec_13(i))','evaluated',83.00,'SOSPECHOSO: Programación II — Salón 2 alumno 13',1,UNIX_TIMESTAMP()-936092,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al13_salon02'
WHERE c.shortname='salon02' AND a.name='Serie de Fibonacci — Programación II — Salón 2'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fib_14(n):\\n    a,b=0,1\\n    for _ in range(n):\\n        print(a)\\n        a,b=b,a+b\\nfib_14(10)','evaluated',84.00,'ORIGINAL: Programación II — Salón 2 alumno 14',1,UNIX_TIMESTAMP()-462385,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al14_salon02'
WHERE c.shortname='salon02' AND a.name='Serie de Fibonacci — Programación II — Salón 2'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fib_15(n):\\n    a,b=0,1\\n    for _ in range(n):\\n        print(a)\\n        a,b=b,a+b\\nfib_15(10)','evaluated',85.00,'ORIGINAL: Programación II — Salón 2 alumno 15',1,UNIX_TIMESTAMP()-553468,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al15_salon02'
WHERE c.shortname='salon02' AND a.name='Serie de Fibonacci — Programación II — Salón 2'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def serie_16(num):\\n    x,y=0,1\\n    for _ in range(num):\\n        print(x)\\n        x,y=y,x+y\\nserie_16(10)','evaluated',86.00,'PLAGIO: Programación II — Salón 2 alumno 16',1,UNIX_TIMESTAMP()-875313,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al16_salon02'
WHERE c.shortname='salon02' AND a.name='Serie de Fibonacci — Programación II — Salón 2'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def serie_17(num):\\n    x,y=0,1\\n    for _ in range(num):\\n        print(x)\\n        x,y=y,x+y\\nserie_17(10)','evaluated',87.00,'PLAGIO: Programación II — Salón 2 alumno 17',1,UNIX_TIMESTAMP()-1116382,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al17_salon02'
WHERE c.shortname='salon02' AND a.name='Serie de Fibonacci — Programación II — Salón 2'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fib_rec_18(n):\\n    if n<=1: return n\\n    return fib_rec_18(n-1)+fib_rec_18(n-2)\\nfor i in range(10): print(fib_rec_18(i))','evaluated',88.00,'SOSPECHOSO: Programación II — Salón 2 alumno 18',1,UNIX_TIMESTAMP()-175953,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al18_salon02'
WHERE c.shortname='salon02' AND a.name='Serie de Fibonacci — Programación II — Salón 2'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fib_19(n):\\n    a,b=0,1\\n    for _ in range(n):\\n        print(a)\\n        a,b=b,a+b\\nfib_19(10)','evaluated',89.00,'ORIGINAL: Programación II — Salón 2 alumno 19',1,UNIX_TIMESTAMP()-541218,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al19_salon02'
WHERE c.shortname='salon02' AND a.name='Serie de Fibonacci — Programación II — Salón 2'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fib_20(n):\\n    a,b=0,1\\n    for _ in range(n):\\n        print(a)\\n        a,b=b,a+b\\nfib_20(10)','evaluated',90.00,'ORIGINAL: Programación II — Salón 2 alumno 20',1,UNIX_TIMESTAMP()-299477,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al20_salon02'
WHERE c.shortname='salon02' AND a.name='Serie de Fibonacci — Programación II — Salón 2'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def serie_21(num):\\n    x,y=0,1\\n    for _ in range(num):\\n        print(x)\\n        x,y=y,x+y\\nserie_21(10)','evaluated',91.00,'PLAGIO: Programación II — Salón 2 alumno 21',1,UNIX_TIMESTAMP()-339297,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al21_salon02'
WHERE c.shortname='salon02' AND a.name='Serie de Fibonacci — Programación II — Salón 2'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def serie_22(num):\\n    x,y=0,1\\n    for _ in range(num):\\n        print(x)\\n        x,y=y,x+y\\nserie_22(10)','evaluated',92.00,'PLAGIO: Programación II — Salón 2 alumno 22',1,UNIX_TIMESTAMP()-258670,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al22_salon02'
WHERE c.shortname='salon02' AND a.name='Serie de Fibonacci — Programación II — Salón 2'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fib_rec_23(n):\\n    if n<=1: return n\\n    return fib_rec_23(n-1)+fib_rec_23(n-2)\\nfor i in range(10): print(fib_rec_23(i))','evaluated',93.00,'SOSPECHOSO: Programación II — Salón 2 alumno 23',1,UNIX_TIMESTAMP()-507282,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al23_salon02'
WHERE c.shortname='salon02' AND a.name='Serie de Fibonacci — Programación II — Salón 2'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fib_24(n):\\n    a,b=0,1\\n    for _ in range(n):\\n        print(a)\\n        a,b=b,a+b\\nfib_24(10)','evaluated',94.00,'ORIGINAL: Programación II — Salón 2 alumno 24',1,UNIX_TIMESTAMP()-641091,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al24_salon02'
WHERE c.shortname='salon02' AND a.name='Serie de Fibonacci — Programación II — Salón 2'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fib_25(n):\\n    a,b=0,1\\n    for _ in range(n):\\n        print(a)\\n        a,b=b,a+b\\nfib_25(10)','evaluated',70.00,'ORIGINAL: Programación II — Salón 2 alumno 25',1,UNIX_TIMESTAMP()-652203,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al25_salon02'
WHERE c.shortname='salon02' AND a.name='Serie de Fibonacci — Programación II — Salón 2'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_1(lista):\\n    tam=len(lista)\\n    for i in range(tam):\\n        for j in range(tam-i-1):\\n            if lista[j]>lista[j+1]: lista[j],lista[j+1]=lista[j+1],lista[j]\\n    return lista\\nprint(ordenar_1([5,3,8,1]))','evaluated',71.00,'PLAGIO: Estructuras de Datos — Salón 3 alumno 1',1,UNIX_TIMESTAMP()-346128,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al01_salon03'
WHERE c.shortname='salon03' AND a.name='Bubble Sort — Estructuras de Datos — Salón 3'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_2(lista):\\n    tam=len(lista)\\n    for i in range(tam):\\n        for j in range(tam-i-1):\\n            if lista[j]>lista[j+1]: lista[j],lista[j+1]=lista[j+1],lista[j]\\n    return lista\\nprint(ordenar_2([5,3,8,1]))','evaluated',72.00,'PLAGIO: Estructuras de Datos — Salón 3 alumno 2',1,UNIX_TIMESTAMP()-322782,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al02_salon03'
WHERE c.shortname='salon03' AND a.name='Bubble Sort — Estructuras de Datos — Salón 3'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_opt_3(arr):\\n    n=len(arr)\\n    for i in range(n):\\n        sw=False\\n        for j in range(n-i-1):\\n            if arr[j]>arr[j+1]: arr[j],arr[j+1]=arr[j+1],arr[j]; sw=True\\n        if not sw: break\\n    return arr\\nprint(bubble_opt_3([5,3,8,1]))','evaluated',73.00,'SOSPECHOSO: Estructuras de Datos — Salón 3 alumno 3',1,UNIX_TIMESTAMP()-485057,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al03_salon03'
WHERE c.shortname='salon03' AND a.name='Bubble Sort — Estructuras de Datos — Salón 3'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_4(arr):\\n    n=len(arr)\\n    for i in range(n):\\n        for j in range(n-i-1):\\n            if arr[j]>arr[j+1]: arr[j],arr[j+1]=arr[j+1],arr[j]\\n    return arr\\nprint(bubble_sort_4([5,3,8,1]))','evaluated',74.00,'ORIGINAL: Estructuras de Datos — Salón 3 alumno 4',1,UNIX_TIMESTAMP()-1012161,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al04_salon03'
WHERE c.shortname='salon03' AND a.name='Bubble Sort — Estructuras de Datos — Salón 3'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_5(arr):\\n    n=len(arr)\\n    for i in range(n):\\n        for j in range(n-i-1):\\n            if arr[j]>arr[j+1]: arr[j],arr[j+1]=arr[j+1],arr[j]\\n    return arr\\nprint(bubble_sort_5([5,3,8,1]))','evaluated',75.00,'ORIGINAL: Estructuras de Datos — Salón 3 alumno 5',1,UNIX_TIMESTAMP()-922928,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al05_salon03'
WHERE c.shortname='salon03' AND a.name='Bubble Sort — Estructuras de Datos — Salón 3'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_6(lista):\\n    tam=len(lista)\\n    for i in range(tam):\\n        for j in range(tam-i-1):\\n            if lista[j]>lista[j+1]: lista[j],lista[j+1]=lista[j+1],lista[j]\\n    return lista\\nprint(ordenar_6([5,3,8,1]))','evaluated',76.00,'PLAGIO: Estructuras de Datos — Salón 3 alumno 6',1,UNIX_TIMESTAMP()-696614,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al06_salon03'
WHERE c.shortname='salon03' AND a.name='Bubble Sort — Estructuras de Datos — Salón 3'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_7(lista):\\n    tam=len(lista)\\n    for i in range(tam):\\n        for j in range(tam-i-1):\\n            if lista[j]>lista[j+1]: lista[j],lista[j+1]=lista[j+1],lista[j]\\n    return lista\\nprint(ordenar_7([5,3,8,1]))','evaluated',77.00,'PLAGIO: Estructuras de Datos — Salón 3 alumno 7',1,UNIX_TIMESTAMP()-1157282,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al07_salon03'
WHERE c.shortname='salon03' AND a.name='Bubble Sort — Estructuras de Datos — Salón 3'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_opt_8(arr):\\n    n=len(arr)\\n    for i in range(n):\\n        sw=False\\n        for j in range(n-i-1):\\n            if arr[j]>arr[j+1]: arr[j],arr[j+1]=arr[j+1],arr[j]; sw=True\\n        if not sw: break\\n    return arr\\nprint(bubble_opt_8([5,3,8,1]))','evaluated',78.00,'SOSPECHOSO: Estructuras de Datos — Salón 3 alumno 8',1,UNIX_TIMESTAMP()-1067807,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al08_salon03'
WHERE c.shortname='salon03' AND a.name='Bubble Sort — Estructuras de Datos — Salón 3'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_9(arr):\\n    n=len(arr)\\n    for i in range(n):\\n        for j in range(n-i-1):\\n            if arr[j]>arr[j+1]: arr[j],arr[j+1]=arr[j+1],arr[j]\\n    return arr\\nprint(bubble_sort_9([5,3,8,1]))','evaluated',79.00,'ORIGINAL: Estructuras de Datos — Salón 3 alumno 9',1,UNIX_TIMESTAMP()-310318,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al09_salon03'
WHERE c.shortname='salon03' AND a.name='Bubble Sort — Estructuras de Datos — Salón 3'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_10(arr):\\n    n=len(arr)\\n    for i in range(n):\\n        for j in range(n-i-1):\\n            if arr[j]>arr[j+1]: arr[j],arr[j+1]=arr[j+1],arr[j]\\n    return arr\\nprint(bubble_sort_10([5,3,8,1]))','evaluated',80.00,'ORIGINAL: Estructuras de Datos — Salón 3 alumno 10',1,UNIX_TIMESTAMP()-773851,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al10_salon03'
WHERE c.shortname='salon03' AND a.name='Bubble Sort — Estructuras de Datos — Salón 3'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_11(lista):\\n    tam=len(lista)\\n    for i in range(tam):\\n        for j in range(tam-i-1):\\n            if lista[j]>lista[j+1]: lista[j],lista[j+1]=lista[j+1],lista[j]\\n    return lista\\nprint(ordenar_11([5,3,8,1]))','evaluated',81.00,'PLAGIO: Estructuras de Datos — Salón 3 alumno 11',1,UNIX_TIMESTAMP()-349033,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al11_salon03'
WHERE c.shortname='salon03' AND a.name='Bubble Sort — Estructuras de Datos — Salón 3'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_12(lista):\\n    tam=len(lista)\\n    for i in range(tam):\\n        for j in range(tam-i-1):\\n            if lista[j]>lista[j+1]: lista[j],lista[j+1]=lista[j+1],lista[j]\\n    return lista\\nprint(ordenar_12([5,3,8,1]))','evaluated',82.00,'PLAGIO: Estructuras de Datos — Salón 3 alumno 12',1,UNIX_TIMESTAMP()-1200104,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al12_salon03'
WHERE c.shortname='salon03' AND a.name='Bubble Sort — Estructuras de Datos — Salón 3'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_opt_13(arr):\\n    n=len(arr)\\n    for i in range(n):\\n        sw=False\\n        for j in range(n-i-1):\\n            if arr[j]>arr[j+1]: arr[j],arr[j+1]=arr[j+1],arr[j]; sw=True\\n        if not sw: break\\n    return arr\\nprint(bubble_opt_13([5,3,8,1]))','evaluated',83.00,'SOSPECHOSO: Estructuras de Datos — Salón 3 alumno 13',1,UNIX_TIMESTAMP()-831704,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al13_salon03'
WHERE c.shortname='salon03' AND a.name='Bubble Sort — Estructuras de Datos — Salón 3'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_14(arr):\\n    n=len(arr)\\n    for i in range(n):\\n        for j in range(n-i-1):\\n            if arr[j]>arr[j+1]: arr[j],arr[j+1]=arr[j+1],arr[j]\\n    return arr\\nprint(bubble_sort_14([5,3,8,1]))','evaluated',84.00,'ORIGINAL: Estructuras de Datos — Salón 3 alumno 14',1,UNIX_TIMESTAMP()-874128,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al14_salon03'
WHERE c.shortname='salon03' AND a.name='Bubble Sort — Estructuras de Datos — Salón 3'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_15(arr):\\n    n=len(arr)\\n    for i in range(n):\\n        for j in range(n-i-1):\\n            if arr[j]>arr[j+1]: arr[j],arr[j+1]=arr[j+1],arr[j]\\n    return arr\\nprint(bubble_sort_15([5,3,8,1]))','evaluated',85.00,'ORIGINAL: Estructuras de Datos — Salón 3 alumno 15',1,UNIX_TIMESTAMP()-1166541,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al15_salon03'
WHERE c.shortname='salon03' AND a.name='Bubble Sort — Estructuras de Datos — Salón 3'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_16(lista):\\n    tam=len(lista)\\n    for i in range(tam):\\n        for j in range(tam-i-1):\\n            if lista[j]>lista[j+1]: lista[j],lista[j+1]=lista[j+1],lista[j]\\n    return lista\\nprint(ordenar_16([5,3,8,1]))','evaluated',86.00,'PLAGIO: Estructuras de Datos — Salón 3 alumno 16',1,UNIX_TIMESTAMP()-501214,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al16_salon03'
WHERE c.shortname='salon03' AND a.name='Bubble Sort — Estructuras de Datos — Salón 3'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_17(lista):\\n    tam=len(lista)\\n    for i in range(tam):\\n        for j in range(tam-i-1):\\n            if lista[j]>lista[j+1]: lista[j],lista[j+1]=lista[j+1],lista[j]\\n    return lista\\nprint(ordenar_17([5,3,8,1]))','evaluated',87.00,'PLAGIO: Estructuras de Datos — Salón 3 alumno 17',1,UNIX_TIMESTAMP()-1029525,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al17_salon03'
WHERE c.shortname='salon03' AND a.name='Bubble Sort — Estructuras de Datos — Salón 3'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_opt_18(arr):\\n    n=len(arr)\\n    for i in range(n):\\n        sw=False\\n        for j in range(n-i-1):\\n            if arr[j]>arr[j+1]: arr[j],arr[j+1]=arr[j+1],arr[j]; sw=True\\n        if not sw: break\\n    return arr\\nprint(bubble_opt_18([5,3,8,1]))','evaluated',88.00,'SOSPECHOSO: Estructuras de Datos — Salón 3 alumno 18',1,UNIX_TIMESTAMP()-1109245,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al18_salon03'
WHERE c.shortname='salon03' AND a.name='Bubble Sort — Estructuras de Datos — Salón 3'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_19(arr):\\n    n=len(arr)\\n    for i in range(n):\\n        for j in range(n-i-1):\\n            if arr[j]>arr[j+1]: arr[j],arr[j+1]=arr[j+1],arr[j]\\n    return arr\\nprint(bubble_sort_19([5,3,8,1]))','evaluated',89.00,'ORIGINAL: Estructuras de Datos — Salón 3 alumno 19',1,UNIX_TIMESTAMP()-1106784,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al19_salon03'
WHERE c.shortname='salon03' AND a.name='Bubble Sort — Estructuras de Datos — Salón 3'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_20(arr):\\n    n=len(arr)\\n    for i in range(n):\\n        for j in range(n-i-1):\\n            if arr[j]>arr[j+1]: arr[j],arr[j+1]=arr[j+1],arr[j]\\n    return arr\\nprint(bubble_sort_20([5,3,8,1]))','evaluated',90.00,'ORIGINAL: Estructuras de Datos — Salón 3 alumno 20',1,UNIX_TIMESTAMP()-1020052,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al20_salon03'
WHERE c.shortname='salon03' AND a.name='Bubble Sort — Estructuras de Datos — Salón 3'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_21(lista):\\n    tam=len(lista)\\n    for i in range(tam):\\n        for j in range(tam-i-1):\\n            if lista[j]>lista[j+1]: lista[j],lista[j+1]=lista[j+1],lista[j]\\n    return lista\\nprint(ordenar_21([5,3,8,1]))','evaluated',91.00,'PLAGIO: Estructuras de Datos — Salón 3 alumno 21',1,UNIX_TIMESTAMP()-968792,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al21_salon03'
WHERE c.shortname='salon03' AND a.name='Bubble Sort — Estructuras de Datos — Salón 3'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_22(lista):\\n    tam=len(lista)\\n    for i in range(tam):\\n        for j in range(tam-i-1):\\n            if lista[j]>lista[j+1]: lista[j],lista[j+1]=lista[j+1],lista[j]\\n    return lista\\nprint(ordenar_22([5,3,8,1]))','evaluated',92.00,'PLAGIO: Estructuras de Datos — Salón 3 alumno 22',1,UNIX_TIMESTAMP()-949710,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al22_salon03'
WHERE c.shortname='salon03' AND a.name='Bubble Sort — Estructuras de Datos — Salón 3'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_opt_23(arr):\\n    n=len(arr)\\n    for i in range(n):\\n        sw=False\\n        for j in range(n-i-1):\\n            if arr[j]>arr[j+1]: arr[j],arr[j+1]=arr[j+1],arr[j]; sw=True\\n        if not sw: break\\n    return arr\\nprint(bubble_opt_23([5,3,8,1]))','evaluated',93.00,'SOSPECHOSO: Estructuras de Datos — Salón 3 alumno 23',1,UNIX_TIMESTAMP()-195164,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al23_salon03'
WHERE c.shortname='salon03' AND a.name='Bubble Sort — Estructuras de Datos — Salón 3'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_24(arr):\\n    n=len(arr)\\n    for i in range(n):\\n        for j in range(n-i-1):\\n            if arr[j]>arr[j+1]: arr[j],arr[j+1]=arr[j+1],arr[j]\\n    return arr\\nprint(bubble_sort_24([5,3,8,1]))','evaluated',94.00,'ORIGINAL: Estructuras de Datos — Salón 3 alumno 24',1,UNIX_TIMESTAMP()-327098,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al24_salon03'
WHERE c.shortname='salon03' AND a.name='Bubble Sort — Estructuras de Datos — Salón 3'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_25(arr):\\n    n=len(arr)\\n    for i in range(n):\\n        for j in range(n-i-1):\\n            if arr[j]>arr[j+1]: arr[j],arr[j+1]=arr[j+1],arr[j]\\n    return arr\\nprint(bubble_sort_25([5,3,8,1]))','evaluated',70.00,'ORIGINAL: Estructuras de Datos — Salón 3 alumno 25',1,UNIX_TIMESTAMP()-339414,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al25_salon03'
WHERE c.shortname='salon03' AND a.name='Bubble Sort — Estructuras de Datos — Salón 3'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def buscar_1(lista,valor):\\n    ini,fin=0,len(lista)-1\\n    while ini<=fin:\\n        medio=(ini+fin)//2\\n        if lista[medio]==valor: return medio\\n        elif lista[medio]<valor: ini=medio+1\\n        else: fin=medio-1\\n    return -1\\nprint(buscar_1([1,3,5,7,9],7))','evaluated',71.00,'PLAGIO: Estructuras de Datos — Salón 3 alumno 1',1,UNIX_TIMESTAMP()-145869,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al01_salon03'
WHERE c.shortname='salon03' AND a.name='Búsqueda binaria — Estructuras de Datos — Salón 3'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def buscar_2(lista,valor):\\n    ini,fin=0,len(lista)-1\\n    while ini<=fin:\\n        medio=(ini+fin)//2\\n        if lista[medio]==valor: return medio\\n        elif lista[medio]<valor: ini=medio+1\\n        else: fin=medio-1\\n    return -1\\nprint(buscar_2([1,3,5,7,9],7))','evaluated',72.00,'PLAGIO: Estructuras de Datos — Salón 3 alumno 2',1,UNIX_TIMESTAMP()-974818,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al02_salon03'
WHERE c.shortname='salon03' AND a.name='Búsqueda binaria — Estructuras de Datos — Salón 3'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bin_rec_3(arr,t,l=0,r=None):\\n    if r is None: r=len(arr)-1\\n    if l>r: return -1\\n    mid=(l+r)//2\\n    if arr[mid]==t: return mid\\n    if arr[mid]<t: return bin_rec_3(arr,t,mid+1,r)\\n    return bin_rec_3(arr,t,l,mid-1)\\nprint(bin_rec_3([1,3,5,7,9],7))','evaluated',73.00,'SOSPECHOSO: Estructuras de Datos — Salón 3 alumno 3',1,UNIX_TIMESTAMP()-260916,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al03_salon03'
WHERE c.shortname='salon03' AND a.name='Búsqueda binaria — Estructuras de Datos — Salón 3'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def binary_search_4(arr,target):\\n    l,r=0,len(arr)-1\\n    while l<=r:\\n        mid=(l+r)//2\\n        if arr[mid]==target: return mid\\n        elif arr[mid]<target: l=mid+1\\n        else: r=mid-1\\n    return -1\\nprint(binary_search_4([1,3,5,7,9],7))','evaluated',74.00,'ORIGINAL: Estructuras de Datos — Salón 3 alumno 4',1,UNIX_TIMESTAMP()-213731,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al04_salon03'
WHERE c.shortname='salon03' AND a.name='Búsqueda binaria — Estructuras de Datos — Salón 3'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def binary_search_5(arr,target):\\n    l,r=0,len(arr)-1\\n    while l<=r:\\n        mid=(l+r)//2\\n        if arr[mid]==target: return mid\\n        elif arr[mid]<target: l=mid+1\\n        else: r=mid-1\\n    return -1\\nprint(binary_search_5([1,3,5,7,9],7))','evaluated',75.00,'ORIGINAL: Estructuras de Datos — Salón 3 alumno 5',1,UNIX_TIMESTAMP()-888953,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al05_salon03'
WHERE c.shortname='salon03' AND a.name='Búsqueda binaria — Estructuras de Datos — Salón 3'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def buscar_6(lista,valor):\\n    ini,fin=0,len(lista)-1\\n    while ini<=fin:\\n        medio=(ini+fin)//2\\n        if lista[medio]==valor: return medio\\n        elif lista[medio]<valor: ini=medio+1\\n        else: fin=medio-1\\n    return -1\\nprint(buscar_6([1,3,5,7,9],7))','evaluated',76.00,'PLAGIO: Estructuras de Datos — Salón 3 alumno 6',1,UNIX_TIMESTAMP()-235541,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al06_salon03'
WHERE c.shortname='salon03' AND a.name='Búsqueda binaria — Estructuras de Datos — Salón 3'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def buscar_7(lista,valor):\\n    ini,fin=0,len(lista)-1\\n    while ini<=fin:\\n        medio=(ini+fin)//2\\n        if lista[medio]==valor: return medio\\n        elif lista[medio]<valor: ini=medio+1\\n        else: fin=medio-1\\n    return -1\\nprint(buscar_7([1,3,5,7,9],7))','evaluated',77.00,'PLAGIO: Estructuras de Datos — Salón 3 alumno 7',1,UNIX_TIMESTAMP()-1199953,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al07_salon03'
WHERE c.shortname='salon03' AND a.name='Búsqueda binaria — Estructuras de Datos — Salón 3'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bin_rec_8(arr,t,l=0,r=None):\\n    if r is None: r=len(arr)-1\\n    if l>r: return -1\\n    mid=(l+r)//2\\n    if arr[mid]==t: return mid\\n    if arr[mid]<t: return bin_rec_8(arr,t,mid+1,r)\\n    return bin_rec_8(arr,t,l,mid-1)\\nprint(bin_rec_8([1,3,5,7,9],7))','evaluated',78.00,'SOSPECHOSO: Estructuras de Datos — Salón 3 alumno 8',1,UNIX_TIMESTAMP()-80732,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al08_salon03'
WHERE c.shortname='salon03' AND a.name='Búsqueda binaria — Estructuras de Datos — Salón 3'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def binary_search_9(arr,target):\\n    l,r=0,len(arr)-1\\n    while l<=r:\\n        mid=(l+r)//2\\n        if arr[mid]==target: return mid\\n        elif arr[mid]<target: l=mid+1\\n        else: r=mid-1\\n    return -1\\nprint(binary_search_9([1,3,5,7,9],7))','evaluated',79.00,'ORIGINAL: Estructuras de Datos — Salón 3 alumno 9',1,UNIX_TIMESTAMP()-734182,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al09_salon03'
WHERE c.shortname='salon03' AND a.name='Búsqueda binaria — Estructuras de Datos — Salón 3'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def binary_search_10(arr,target):\\n    l,r=0,len(arr)-1\\n    while l<=r:\\n        mid=(l+r)//2\\n        if arr[mid]==target: return mid\\n        elif arr[mid]<target: l=mid+1\\n        else: r=mid-1\\n    return -1\\nprint(binary_search_10([1,3,5,7,9],7))','evaluated',80.00,'ORIGINAL: Estructuras de Datos — Salón 3 alumno 10',1,UNIX_TIMESTAMP()-865689,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al10_salon03'
WHERE c.shortname='salon03' AND a.name='Búsqueda binaria — Estructuras de Datos — Salón 3'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def buscar_11(lista,valor):\\n    ini,fin=0,len(lista)-1\\n    while ini<=fin:\\n        medio=(ini+fin)//2\\n        if lista[medio]==valor: return medio\\n        elif lista[medio]<valor: ini=medio+1\\n        else: fin=medio-1\\n    return -1\\nprint(buscar_11([1,3,5,7,9],7))','evaluated',81.00,'PLAGIO: Estructuras de Datos — Salón 3 alumno 11',1,UNIX_TIMESTAMP()-616634,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al11_salon03'
WHERE c.shortname='salon03' AND a.name='Búsqueda binaria — Estructuras de Datos — Salón 3'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def buscar_12(lista,valor):\\n    ini,fin=0,len(lista)-1\\n    while ini<=fin:\\n        medio=(ini+fin)//2\\n        if lista[medio]==valor: return medio\\n        elif lista[medio]<valor: ini=medio+1\\n        else: fin=medio-1\\n    return -1\\nprint(buscar_12([1,3,5,7,9],7))','evaluated',82.00,'PLAGIO: Estructuras de Datos — Salón 3 alumno 12',1,UNIX_TIMESTAMP()-594726,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al12_salon03'
WHERE c.shortname='salon03' AND a.name='Búsqueda binaria — Estructuras de Datos — Salón 3'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bin_rec_13(arr,t,l=0,r=None):\\n    if r is None: r=len(arr)-1\\n    if l>r: return -1\\n    mid=(l+r)//2\\n    if arr[mid]==t: return mid\\n    if arr[mid]<t: return bin_rec_13(arr,t,mid+1,r)\\n    return bin_rec_13(arr,t,l,mid-1)\\nprint(bin_rec_13([1,3,5,7,9],7))','evaluated',83.00,'SOSPECHOSO: Estructuras de Datos — Salón 3 alumno 13',1,UNIX_TIMESTAMP()-1200194,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al13_salon03'
WHERE c.shortname='salon03' AND a.name='Búsqueda binaria — Estructuras de Datos — Salón 3'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def binary_search_14(arr,target):\\n    l,r=0,len(arr)-1\\n    while l<=r:\\n        mid=(l+r)//2\\n        if arr[mid]==target: return mid\\n        elif arr[mid]<target: l=mid+1\\n        else: r=mid-1\\n    return -1\\nprint(binary_search_14([1,3,5,7,9],7))','evaluated',84.00,'ORIGINAL: Estructuras de Datos — Salón 3 alumno 14',1,UNIX_TIMESTAMP()-338496,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al14_salon03'
WHERE c.shortname='salon03' AND a.name='Búsqueda binaria — Estructuras de Datos — Salón 3'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def binary_search_15(arr,target):\\n    l,r=0,len(arr)-1\\n    while l<=r:\\n        mid=(l+r)//2\\n        if arr[mid]==target: return mid\\n        elif arr[mid]<target: l=mid+1\\n        else: r=mid-1\\n    return -1\\nprint(binary_search_15([1,3,5,7,9],7))','evaluated',85.00,'ORIGINAL: Estructuras de Datos — Salón 3 alumno 15',1,UNIX_TIMESTAMP()-91334,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al15_salon03'
WHERE c.shortname='salon03' AND a.name='Búsqueda binaria — Estructuras de Datos — Salón 3'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def buscar_16(lista,valor):\\n    ini,fin=0,len(lista)-1\\n    while ini<=fin:\\n        medio=(ini+fin)//2\\n        if lista[medio]==valor: return medio\\n        elif lista[medio]<valor: ini=medio+1\\n        else: fin=medio-1\\n    return -1\\nprint(buscar_16([1,3,5,7,9],7))','evaluated',86.00,'PLAGIO: Estructuras de Datos — Salón 3 alumno 16',1,UNIX_TIMESTAMP()-94015,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al16_salon03'
WHERE c.shortname='salon03' AND a.name='Búsqueda binaria — Estructuras de Datos — Salón 3'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def buscar_17(lista,valor):\\n    ini,fin=0,len(lista)-1\\n    while ini<=fin:\\n        medio=(ini+fin)//2\\n        if lista[medio]==valor: return medio\\n        elif lista[medio]<valor: ini=medio+1\\n        else: fin=medio-1\\n    return -1\\nprint(buscar_17([1,3,5,7,9],7))','evaluated',87.00,'PLAGIO: Estructuras de Datos — Salón 3 alumno 17',1,UNIX_TIMESTAMP()-151477,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al17_salon03'
WHERE c.shortname='salon03' AND a.name='Búsqueda binaria — Estructuras de Datos — Salón 3'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bin_rec_18(arr,t,l=0,r=None):\\n    if r is None: r=len(arr)-1\\n    if l>r: return -1\\n    mid=(l+r)//2\\n    if arr[mid]==t: return mid\\n    if arr[mid]<t: return bin_rec_18(arr,t,mid+1,r)\\n    return bin_rec_18(arr,t,l,mid-1)\\nprint(bin_rec_18([1,3,5,7,9],7))','evaluated',88.00,'SOSPECHOSO: Estructuras de Datos — Salón 3 alumno 18',1,UNIX_TIMESTAMP()-440217,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al18_salon03'
WHERE c.shortname='salon03' AND a.name='Búsqueda binaria — Estructuras de Datos — Salón 3'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def binary_search_19(arr,target):\\n    l,r=0,len(arr)-1\\n    while l<=r:\\n        mid=(l+r)//2\\n        if arr[mid]==target: return mid\\n        elif arr[mid]<target: l=mid+1\\n        else: r=mid-1\\n    return -1\\nprint(binary_search_19([1,3,5,7,9],7))','evaluated',89.00,'ORIGINAL: Estructuras de Datos — Salón 3 alumno 19',1,UNIX_TIMESTAMP()-620598,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al19_salon03'
WHERE c.shortname='salon03' AND a.name='Búsqueda binaria — Estructuras de Datos — Salón 3'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def binary_search_20(arr,target):\\n    l,r=0,len(arr)-1\\n    while l<=r:\\n        mid=(l+r)//2\\n        if arr[mid]==target: return mid\\n        elif arr[mid]<target: l=mid+1\\n        else: r=mid-1\\n    return -1\\nprint(binary_search_20([1,3,5,7,9],7))','evaluated',90.00,'ORIGINAL: Estructuras de Datos — Salón 3 alumno 20',1,UNIX_TIMESTAMP()-730166,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al20_salon03'
WHERE c.shortname='salon03' AND a.name='Búsqueda binaria — Estructuras de Datos — Salón 3'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def buscar_21(lista,valor):\\n    ini,fin=0,len(lista)-1\\n    while ini<=fin:\\n        medio=(ini+fin)//2\\n        if lista[medio]==valor: return medio\\n        elif lista[medio]<valor: ini=medio+1\\n        else: fin=medio-1\\n    return -1\\nprint(buscar_21([1,3,5,7,9],7))','evaluated',91.00,'PLAGIO: Estructuras de Datos — Salón 3 alumno 21',1,UNIX_TIMESTAMP()-800472,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al21_salon03'
WHERE c.shortname='salon03' AND a.name='Búsqueda binaria — Estructuras de Datos — Salón 3'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def buscar_22(lista,valor):\\n    ini,fin=0,len(lista)-1\\n    while ini<=fin:\\n        medio=(ini+fin)//2\\n        if lista[medio]==valor: return medio\\n        elif lista[medio]<valor: ini=medio+1\\n        else: fin=medio-1\\n    return -1\\nprint(buscar_22([1,3,5,7,9],7))','evaluated',92.00,'PLAGIO: Estructuras de Datos — Salón 3 alumno 22',1,UNIX_TIMESTAMP()-218489,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al22_salon03'
WHERE c.shortname='salon03' AND a.name='Búsqueda binaria — Estructuras de Datos — Salón 3'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bin_rec_23(arr,t,l=0,r=None):\\n    if r is None: r=len(arr)-1\\n    if l>r: return -1\\n    mid=(l+r)//2\\n    if arr[mid]==t: return mid\\n    if arr[mid]<t: return bin_rec_23(arr,t,mid+1,r)\\n    return bin_rec_23(arr,t,l,mid-1)\\nprint(bin_rec_23([1,3,5,7,9],7))','evaluated',93.00,'SOSPECHOSO: Estructuras de Datos — Salón 3 alumno 23',1,UNIX_TIMESTAMP()-150072,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al23_salon03'
WHERE c.shortname='salon03' AND a.name='Búsqueda binaria — Estructuras de Datos — Salón 3'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def binary_search_24(arr,target):\\n    l,r=0,len(arr)-1\\n    while l<=r:\\n        mid=(l+r)//2\\n        if arr[mid]==target: return mid\\n        elif arr[mid]<target: l=mid+1\\n        else: r=mid-1\\n    return -1\\nprint(binary_search_24([1,3,5,7,9],7))','evaluated',94.00,'ORIGINAL: Estructuras de Datos — Salón 3 alumno 24',1,UNIX_TIMESTAMP()-314656,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al24_salon03'
WHERE c.shortname='salon03' AND a.name='Búsqueda binaria — Estructuras de Datos — Salón 3'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def binary_search_25(arr,target):\\n    l,r=0,len(arr)-1\\n    while l<=r:\\n        mid=(l+r)//2\\n        if arr[mid]==target: return mid\\n        elif arr[mid]<target: l=mid+1\\n        else: r=mid-1\\n    return -1\\nprint(binary_search_25([1,3,5,7,9],7))','evaluated',70.00,'ORIGINAL: Estructuras de Datos — Salón 3 alumno 25',1,UNIX_TIMESTAMP()-368089,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al25_salon03'
WHERE c.shortname='salon03' AND a.name='Búsqueda binaria — Estructuras de Datos — Salón 3'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_1(lista):\\n    tam=len(lista)\\n    for i in range(tam):\\n        for j in range(tam-i-1):\\n            if lista[j]>lista[j+1]: lista[j],lista[j+1]=lista[j+1],lista[j]\\n    return lista\\nprint(ordenar_1([5,3,8,1]))','evaluated',71.00,'PLAGIO: Algoritmos — Salón 4 alumno 1',1,UNIX_TIMESTAMP()-447310,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al01_salon04'
WHERE c.shortname='salon04' AND a.name='Bubble Sort — Algoritmos — Salón 4'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_2(lista):\\n    tam=len(lista)\\n    for i in range(tam):\\n        for j in range(tam-i-1):\\n            if lista[j]>lista[j+1]: lista[j],lista[j+1]=lista[j+1],lista[j]\\n    return lista\\nprint(ordenar_2([5,3,8,1]))','evaluated',72.00,'PLAGIO: Algoritmos — Salón 4 alumno 2',1,UNIX_TIMESTAMP()-518861,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al02_salon04'
WHERE c.shortname='salon04' AND a.name='Bubble Sort — Algoritmos — Salón 4'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_opt_3(arr):\\n    n=len(arr)\\n    for i in range(n):\\n        sw=False\\n        for j in range(n-i-1):\\n            if arr[j]>arr[j+1]: arr[j],arr[j+1]=arr[j+1],arr[j]; sw=True\\n        if not sw: break\\n    return arr\\nprint(bubble_opt_3([5,3,8,1]))','evaluated',73.00,'SOSPECHOSO: Algoritmos — Salón 4 alumno 3',1,UNIX_TIMESTAMP()-93644,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al03_salon04'
WHERE c.shortname='salon04' AND a.name='Bubble Sort — Algoritmos — Salón 4'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_4(arr):\\n    n=len(arr)\\n    for i in range(n):\\n        for j in range(n-i-1):\\n            if arr[j]>arr[j+1]: arr[j],arr[j+1]=arr[j+1],arr[j]\\n    return arr\\nprint(bubble_sort_4([5,3,8,1]))','evaluated',74.00,'ORIGINAL: Algoritmos — Salón 4 alumno 4',1,UNIX_TIMESTAMP()-346583,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al04_salon04'
WHERE c.shortname='salon04' AND a.name='Bubble Sort — Algoritmos — Salón 4'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_5(arr):\\n    n=len(arr)\\n    for i in range(n):\\n        for j in range(n-i-1):\\n            if arr[j]>arr[j+1]: arr[j],arr[j+1]=arr[j+1],arr[j]\\n    return arr\\nprint(bubble_sort_5([5,3,8,1]))','evaluated',75.00,'ORIGINAL: Algoritmos — Salón 4 alumno 5',1,UNIX_TIMESTAMP()-19992,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al05_salon04'
WHERE c.shortname='salon04' AND a.name='Bubble Sort — Algoritmos — Salón 4'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_6(lista):\\n    tam=len(lista)\\n    for i in range(tam):\\n        for j in range(tam-i-1):\\n            if lista[j]>lista[j+1]: lista[j],lista[j+1]=lista[j+1],lista[j]\\n    return lista\\nprint(ordenar_6([5,3,8,1]))','evaluated',76.00,'PLAGIO: Algoritmos — Salón 4 alumno 6',1,UNIX_TIMESTAMP()-46967,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al06_salon04'
WHERE c.shortname='salon04' AND a.name='Bubble Sort — Algoritmos — Salón 4'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_7(lista):\\n    tam=len(lista)\\n    for i in range(tam):\\n        for j in range(tam-i-1):\\n            if lista[j]>lista[j+1]: lista[j],lista[j+1]=lista[j+1],lista[j]\\n    return lista\\nprint(ordenar_7([5,3,8,1]))','evaluated',77.00,'PLAGIO: Algoritmos — Salón 4 alumno 7',1,UNIX_TIMESTAMP()-1078568,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al07_salon04'
WHERE c.shortname='salon04' AND a.name='Bubble Sort — Algoritmos — Salón 4'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_opt_8(arr):\\n    n=len(arr)\\n    for i in range(n):\\n        sw=False\\n        for j in range(n-i-1):\\n            if arr[j]>arr[j+1]: arr[j],arr[j+1]=arr[j+1],arr[j]; sw=True\\n        if not sw: break\\n    return arr\\nprint(bubble_opt_8([5,3,8,1]))','evaluated',78.00,'SOSPECHOSO: Algoritmos — Salón 4 alumno 8',1,UNIX_TIMESTAMP()-281179,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al08_salon04'
WHERE c.shortname='salon04' AND a.name='Bubble Sort — Algoritmos — Salón 4'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_9(arr):\\n    n=len(arr)\\n    for i in range(n):\\n        for j in range(n-i-1):\\n            if arr[j]>arr[j+1]: arr[j],arr[j+1]=arr[j+1],arr[j]\\n    return arr\\nprint(bubble_sort_9([5,3,8,1]))','evaluated',79.00,'ORIGINAL: Algoritmos — Salón 4 alumno 9',1,UNIX_TIMESTAMP()-896167,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al09_salon04'
WHERE c.shortname='salon04' AND a.name='Bubble Sort — Algoritmos — Salón 4'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_10(arr):\\n    n=len(arr)\\n    for i in range(n):\\n        for j in range(n-i-1):\\n            if arr[j]>arr[j+1]: arr[j],arr[j+1]=arr[j+1],arr[j]\\n    return arr\\nprint(bubble_sort_10([5,3,8,1]))','evaluated',80.00,'ORIGINAL: Algoritmos — Salón 4 alumno 10',1,UNIX_TIMESTAMP()-729578,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al10_salon04'
WHERE c.shortname='salon04' AND a.name='Bubble Sort — Algoritmos — Salón 4'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_11(lista):\\n    tam=len(lista)\\n    for i in range(tam):\\n        for j in range(tam-i-1):\\n            if lista[j]>lista[j+1]: lista[j],lista[j+1]=lista[j+1],lista[j]\\n    return lista\\nprint(ordenar_11([5,3,8,1]))','evaluated',81.00,'PLAGIO: Algoritmos — Salón 4 alumno 11',1,UNIX_TIMESTAMP()-1031037,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al11_salon04'
WHERE c.shortname='salon04' AND a.name='Bubble Sort — Algoritmos — Salón 4'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_12(lista):\\n    tam=len(lista)\\n    for i in range(tam):\\n        for j in range(tam-i-1):\\n            if lista[j]>lista[j+1]: lista[j],lista[j+1]=lista[j+1],lista[j]\\n    return lista\\nprint(ordenar_12([5,3,8,1]))','evaluated',82.00,'PLAGIO: Algoritmos — Salón 4 alumno 12',1,UNIX_TIMESTAMP()-348857,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al12_salon04'
WHERE c.shortname='salon04' AND a.name='Bubble Sort — Algoritmos — Salón 4'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_opt_13(arr):\\n    n=len(arr)\\n    for i in range(n):\\n        sw=False\\n        for j in range(n-i-1):\\n            if arr[j]>arr[j+1]: arr[j],arr[j+1]=arr[j+1],arr[j]; sw=True\\n        if not sw: break\\n    return arr\\nprint(bubble_opt_13([5,3,8,1]))','evaluated',83.00,'SOSPECHOSO: Algoritmos — Salón 4 alumno 13',1,UNIX_TIMESTAMP()-155368,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al13_salon04'
WHERE c.shortname='salon04' AND a.name='Bubble Sort — Algoritmos — Salón 4'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_14(arr):\\n    n=len(arr)\\n    for i in range(n):\\n        for j in range(n-i-1):\\n            if arr[j]>arr[j+1]: arr[j],arr[j+1]=arr[j+1],arr[j]\\n    return arr\\nprint(bubble_sort_14([5,3,8,1]))','evaluated',84.00,'ORIGINAL: Algoritmos — Salón 4 alumno 14',1,UNIX_TIMESTAMP()-851703,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al14_salon04'
WHERE c.shortname='salon04' AND a.name='Bubble Sort — Algoritmos — Salón 4'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_15(arr):\\n    n=len(arr)\\n    for i in range(n):\\n        for j in range(n-i-1):\\n            if arr[j]>arr[j+1]: arr[j],arr[j+1]=arr[j+1],arr[j]\\n    return arr\\nprint(bubble_sort_15([5,3,8,1]))','evaluated',85.00,'ORIGINAL: Algoritmos — Salón 4 alumno 15',1,UNIX_TIMESTAMP()-540557,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al15_salon04'
WHERE c.shortname='salon04' AND a.name='Bubble Sort — Algoritmos — Salón 4'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_16(lista):\\n    tam=len(lista)\\n    for i in range(tam):\\n        for j in range(tam-i-1):\\n            if lista[j]>lista[j+1]: lista[j],lista[j+1]=lista[j+1],lista[j]\\n    return lista\\nprint(ordenar_16([5,3,8,1]))','evaluated',86.00,'PLAGIO: Algoritmos — Salón 4 alumno 16',1,UNIX_TIMESTAMP()-156189,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al16_salon04'
WHERE c.shortname='salon04' AND a.name='Bubble Sort — Algoritmos — Salón 4'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_17(lista):\\n    tam=len(lista)\\n    for i in range(tam):\\n        for j in range(tam-i-1):\\n            if lista[j]>lista[j+1]: lista[j],lista[j+1]=lista[j+1],lista[j]\\n    return lista\\nprint(ordenar_17([5,3,8,1]))','evaluated',87.00,'PLAGIO: Algoritmos — Salón 4 alumno 17',1,UNIX_TIMESTAMP()-592634,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al17_salon04'
WHERE c.shortname='salon04' AND a.name='Bubble Sort — Algoritmos — Salón 4'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_opt_18(arr):\\n    n=len(arr)\\n    for i in range(n):\\n        sw=False\\n        for j in range(n-i-1):\\n            if arr[j]>arr[j+1]: arr[j],arr[j+1]=arr[j+1],arr[j]; sw=True\\n        if not sw: break\\n    return arr\\nprint(bubble_opt_18([5,3,8,1]))','evaluated',88.00,'SOSPECHOSO: Algoritmos — Salón 4 alumno 18',1,UNIX_TIMESTAMP()-630352,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al18_salon04'
WHERE c.shortname='salon04' AND a.name='Bubble Sort — Algoritmos — Salón 4'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_19(arr):\\n    n=len(arr)\\n    for i in range(n):\\n        for j in range(n-i-1):\\n            if arr[j]>arr[j+1]: arr[j],arr[j+1]=arr[j+1],arr[j]\\n    return arr\\nprint(bubble_sort_19([5,3,8,1]))','evaluated',89.00,'ORIGINAL: Algoritmos — Salón 4 alumno 19',1,UNIX_TIMESTAMP()-1005953,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al19_salon04'
WHERE c.shortname='salon04' AND a.name='Bubble Sort — Algoritmos — Salón 4'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_20(arr):\\n    n=len(arr)\\n    for i in range(n):\\n        for j in range(n-i-1):\\n            if arr[j]>arr[j+1]: arr[j],arr[j+1]=arr[j+1],arr[j]\\n    return arr\\nprint(bubble_sort_20([5,3,8,1]))','evaluated',90.00,'ORIGINAL: Algoritmos — Salón 4 alumno 20',1,UNIX_TIMESTAMP()-657454,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al20_salon04'
WHERE c.shortname='salon04' AND a.name='Bubble Sort — Algoritmos — Salón 4'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_21(lista):\\n    tam=len(lista)\\n    for i in range(tam):\\n        for j in range(tam-i-1):\\n            if lista[j]>lista[j+1]: lista[j],lista[j+1]=lista[j+1],lista[j]\\n    return lista\\nprint(ordenar_21([5,3,8,1]))','evaluated',91.00,'PLAGIO: Algoritmos — Salón 4 alumno 21',1,UNIX_TIMESTAMP()-510492,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al21_salon04'
WHERE c.shortname='salon04' AND a.name='Bubble Sort — Algoritmos — Salón 4'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_22(lista):\\n    tam=len(lista)\\n    for i in range(tam):\\n        for j in range(tam-i-1):\\n            if lista[j]>lista[j+1]: lista[j],lista[j+1]=lista[j+1],lista[j]\\n    return lista\\nprint(ordenar_22([5,3,8,1]))','evaluated',92.00,'PLAGIO: Algoritmos — Salón 4 alumno 22',1,UNIX_TIMESTAMP()-347367,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al22_salon04'
WHERE c.shortname='salon04' AND a.name='Bubble Sort — Algoritmos — Salón 4'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_opt_23(arr):\\n    n=len(arr)\\n    for i in range(n):\\n        sw=False\\n        for j in range(n-i-1):\\n            if arr[j]>arr[j+1]: arr[j],arr[j+1]=arr[j+1],arr[j]; sw=True\\n        if not sw: break\\n    return arr\\nprint(bubble_opt_23([5,3,8,1]))','evaluated',93.00,'SOSPECHOSO: Algoritmos — Salón 4 alumno 23',1,UNIX_TIMESTAMP()-706917,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al23_salon04'
WHERE c.shortname='salon04' AND a.name='Bubble Sort — Algoritmos — Salón 4'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_24(arr):\\n    n=len(arr)\\n    for i in range(n):\\n        for j in range(n-i-1):\\n            if arr[j]>arr[j+1]: arr[j],arr[j+1]=arr[j+1],arr[j]\\n    return arr\\nprint(bubble_sort_24([5,3,8,1]))','evaluated',94.00,'ORIGINAL: Algoritmos — Salón 4 alumno 24',1,UNIX_TIMESTAMP()-1117012,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al24_salon04'
WHERE c.shortname='salon04' AND a.name='Bubble Sort — Algoritmos — Salón 4'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_25(arr):\\n    n=len(arr)\\n    for i in range(n):\\n        for j in range(n-i-1):\\n            if arr[j]>arr[j+1]: arr[j],arr[j+1]=arr[j+1],arr[j]\\n    return arr\\nprint(bubble_sort_25([5,3,8,1]))','evaluated',70.00,'ORIGINAL: Algoritmos — Salón 4 alumno 25',1,UNIX_TIMESTAMP()-794663,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al25_salon04'
WHERE c.shortname='salon04' AND a.name='Bubble Sort — Algoritmos — Salón 4'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def buscar_1(lista,valor):\\n    ini,fin=0,len(lista)-1\\n    while ini<=fin:\\n        medio=(ini+fin)//2\\n        if lista[medio]==valor: return medio\\n        elif lista[medio]<valor: ini=medio+1\\n        else: fin=medio-1\\n    return -1\\nprint(buscar_1([1,3,5,7,9],7))','evaluated',71.00,'PLAGIO: Algoritmos — Salón 4 alumno 1',1,UNIX_TIMESTAMP()-511454,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al01_salon04'
WHERE c.shortname='salon04' AND a.name='Búsqueda binaria — Algoritmos — Salón 4'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def buscar_2(lista,valor):\\n    ini,fin=0,len(lista)-1\\n    while ini<=fin:\\n        medio=(ini+fin)//2\\n        if lista[medio]==valor: return medio\\n        elif lista[medio]<valor: ini=medio+1\\n        else: fin=medio-1\\n    return -1\\nprint(buscar_2([1,3,5,7,9],7))','evaluated',72.00,'PLAGIO: Algoritmos — Salón 4 alumno 2',1,UNIX_TIMESTAMP()-1092755,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al02_salon04'
WHERE c.shortname='salon04' AND a.name='Búsqueda binaria — Algoritmos — Salón 4'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bin_rec_3(arr,t,l=0,r=None):\\n    if r is None: r=len(arr)-1\\n    if l>r: return -1\\n    mid=(l+r)//2\\n    if arr[mid]==t: return mid\\n    if arr[mid]<t: return bin_rec_3(arr,t,mid+1,r)\\n    return bin_rec_3(arr,t,l,mid-1)\\nprint(bin_rec_3([1,3,5,7,9],7))','evaluated',73.00,'SOSPECHOSO: Algoritmos — Salón 4 alumno 3',1,UNIX_TIMESTAMP()-540127,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al03_salon04'
WHERE c.shortname='salon04' AND a.name='Búsqueda binaria — Algoritmos — Salón 4'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def binary_search_4(arr,target):\\n    l,r=0,len(arr)-1\\n    while l<=r:\\n        mid=(l+r)//2\\n        if arr[mid]==target: return mid\\n        elif arr[mid]<target: l=mid+1\\n        else: r=mid-1\\n    return -1\\nprint(binary_search_4([1,3,5,7,9],7))','evaluated',74.00,'ORIGINAL: Algoritmos — Salón 4 alumno 4',1,UNIX_TIMESTAMP()-943616,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al04_salon04'
WHERE c.shortname='salon04' AND a.name='Búsqueda binaria — Algoritmos — Salón 4'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def binary_search_5(arr,target):\\n    l,r=0,len(arr)-1\\n    while l<=r:\\n        mid=(l+r)//2\\n        if arr[mid]==target: return mid\\n        elif arr[mid]<target: l=mid+1\\n        else: r=mid-1\\n    return -1\\nprint(binary_search_5([1,3,5,7,9],7))','evaluated',75.00,'ORIGINAL: Algoritmos — Salón 4 alumno 5',1,UNIX_TIMESTAMP()-362030,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al05_salon04'
WHERE c.shortname='salon04' AND a.name='Búsqueda binaria — Algoritmos — Salón 4'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def buscar_6(lista,valor):\\n    ini,fin=0,len(lista)-1\\n    while ini<=fin:\\n        medio=(ini+fin)//2\\n        if lista[medio]==valor: return medio\\n        elif lista[medio]<valor: ini=medio+1\\n        else: fin=medio-1\\n    return -1\\nprint(buscar_6([1,3,5,7,9],7))','evaluated',76.00,'PLAGIO: Algoritmos — Salón 4 alumno 6',1,UNIX_TIMESTAMP()-484102,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al06_salon04'
WHERE c.shortname='salon04' AND a.name='Búsqueda binaria — Algoritmos — Salón 4'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def buscar_7(lista,valor):\\n    ini,fin=0,len(lista)-1\\n    while ini<=fin:\\n        medio=(ini+fin)//2\\n        if lista[medio]==valor: return medio\\n        elif lista[medio]<valor: ini=medio+1\\n        else: fin=medio-1\\n    return -1\\nprint(buscar_7([1,3,5,7,9],7))','evaluated',77.00,'PLAGIO: Algoritmos — Salón 4 alumno 7',1,UNIX_TIMESTAMP()-140264,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al07_salon04'
WHERE c.shortname='salon04' AND a.name='Búsqueda binaria — Algoritmos — Salón 4'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bin_rec_8(arr,t,l=0,r=None):\\n    if r is None: r=len(arr)-1\\n    if l>r: return -1\\n    mid=(l+r)//2\\n    if arr[mid]==t: return mid\\n    if arr[mid]<t: return bin_rec_8(arr,t,mid+1,r)\\n    return bin_rec_8(arr,t,l,mid-1)\\nprint(bin_rec_8([1,3,5,7,9],7))','evaluated',78.00,'SOSPECHOSO: Algoritmos — Salón 4 alumno 8',1,UNIX_TIMESTAMP()-281485,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al08_salon04'
WHERE c.shortname='salon04' AND a.name='Búsqueda binaria — Algoritmos — Salón 4'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def binary_search_9(arr,target):\\n    l,r=0,len(arr)-1\\n    while l<=r:\\n        mid=(l+r)//2\\n        if arr[mid]==target: return mid\\n        elif arr[mid]<target: l=mid+1\\n        else: r=mid-1\\n    return -1\\nprint(binary_search_9([1,3,5,7,9],7))','evaluated',79.00,'ORIGINAL: Algoritmos — Salón 4 alumno 9',1,UNIX_TIMESTAMP()-757450,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al09_salon04'
WHERE c.shortname='salon04' AND a.name='Búsqueda binaria — Algoritmos — Salón 4'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def binary_search_10(arr,target):\\n    l,r=0,len(arr)-1\\n    while l<=r:\\n        mid=(l+r)//2\\n        if arr[mid]==target: return mid\\n        elif arr[mid]<target: l=mid+1\\n        else: r=mid-1\\n    return -1\\nprint(binary_search_10([1,3,5,7,9],7))','evaluated',80.00,'ORIGINAL: Algoritmos — Salón 4 alumno 10',1,UNIX_TIMESTAMP()-1153669,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al10_salon04'
WHERE c.shortname='salon04' AND a.name='Búsqueda binaria — Algoritmos — Salón 4'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def buscar_11(lista,valor):\\n    ini,fin=0,len(lista)-1\\n    while ini<=fin:\\n        medio=(ini+fin)//2\\n        if lista[medio]==valor: return medio\\n        elif lista[medio]<valor: ini=medio+1\\n        else: fin=medio-1\\n    return -1\\nprint(buscar_11([1,3,5,7,9],7))','evaluated',81.00,'PLAGIO: Algoritmos — Salón 4 alumno 11',1,UNIX_TIMESTAMP()-1159603,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al11_salon04'
WHERE c.shortname='salon04' AND a.name='Búsqueda binaria — Algoritmos — Salón 4'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def buscar_12(lista,valor):\\n    ini,fin=0,len(lista)-1\\n    while ini<=fin:\\n        medio=(ini+fin)//2\\n        if lista[medio]==valor: return medio\\n        elif lista[medio]<valor: ini=medio+1\\n        else: fin=medio-1\\n    return -1\\nprint(buscar_12([1,3,5,7,9],7))','evaluated',82.00,'PLAGIO: Algoritmos — Salón 4 alumno 12',1,UNIX_TIMESTAMP()-518416,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al12_salon04'
WHERE c.shortname='salon04' AND a.name='Búsqueda binaria — Algoritmos — Salón 4'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bin_rec_13(arr,t,l=0,r=None):\\n    if r is None: r=len(arr)-1\\n    if l>r: return -1\\n    mid=(l+r)//2\\n    if arr[mid]==t: return mid\\n    if arr[mid]<t: return bin_rec_13(arr,t,mid+1,r)\\n    return bin_rec_13(arr,t,l,mid-1)\\nprint(bin_rec_13([1,3,5,7,9],7))','evaluated',83.00,'SOSPECHOSO: Algoritmos — Salón 4 alumno 13',1,UNIX_TIMESTAMP()-905780,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al13_salon04'
WHERE c.shortname='salon04' AND a.name='Búsqueda binaria — Algoritmos — Salón 4'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def binary_search_14(arr,target):\\n    l,r=0,len(arr)-1\\n    while l<=r:\\n        mid=(l+r)//2\\n        if arr[mid]==target: return mid\\n        elif arr[mid]<target: l=mid+1\\n        else: r=mid-1\\n    return -1\\nprint(binary_search_14([1,3,5,7,9],7))','evaluated',84.00,'ORIGINAL: Algoritmos — Salón 4 alumno 14',1,UNIX_TIMESTAMP()-4083,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al14_salon04'
WHERE c.shortname='salon04' AND a.name='Búsqueda binaria — Algoritmos — Salón 4'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def binary_search_15(arr,target):\\n    l,r=0,len(arr)-1\\n    while l<=r:\\n        mid=(l+r)//2\\n        if arr[mid]==target: return mid\\n        elif arr[mid]<target: l=mid+1\\n        else: r=mid-1\\n    return -1\\nprint(binary_search_15([1,3,5,7,9],7))','evaluated',85.00,'ORIGINAL: Algoritmos — Salón 4 alumno 15',1,UNIX_TIMESTAMP()-267376,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al15_salon04'
WHERE c.shortname='salon04' AND a.name='Búsqueda binaria — Algoritmos — Salón 4'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def buscar_16(lista,valor):\\n    ini,fin=0,len(lista)-1\\n    while ini<=fin:\\n        medio=(ini+fin)//2\\n        if lista[medio]==valor: return medio\\n        elif lista[medio]<valor: ini=medio+1\\n        else: fin=medio-1\\n    return -1\\nprint(buscar_16([1,3,5,7,9],7))','evaluated',86.00,'PLAGIO: Algoritmos — Salón 4 alumno 16',1,UNIX_TIMESTAMP()-1171707,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al16_salon04'
WHERE c.shortname='salon04' AND a.name='Búsqueda binaria — Algoritmos — Salón 4'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def buscar_17(lista,valor):\\n    ini,fin=0,len(lista)-1\\n    while ini<=fin:\\n        medio=(ini+fin)//2\\n        if lista[medio]==valor: return medio\\n        elif lista[medio]<valor: ini=medio+1\\n        else: fin=medio-1\\n    return -1\\nprint(buscar_17([1,3,5,7,9],7))','evaluated',87.00,'PLAGIO: Algoritmos — Salón 4 alumno 17',1,UNIX_TIMESTAMP()-6102,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al17_salon04'
WHERE c.shortname='salon04' AND a.name='Búsqueda binaria — Algoritmos — Salón 4'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bin_rec_18(arr,t,l=0,r=None):\\n    if r is None: r=len(arr)-1\\n    if l>r: return -1\\n    mid=(l+r)//2\\n    if arr[mid]==t: return mid\\n    if arr[mid]<t: return bin_rec_18(arr,t,mid+1,r)\\n    return bin_rec_18(arr,t,l,mid-1)\\nprint(bin_rec_18([1,3,5,7,9],7))','evaluated',88.00,'SOSPECHOSO: Algoritmos — Salón 4 alumno 18',1,UNIX_TIMESTAMP()-424698,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al18_salon04'
WHERE c.shortname='salon04' AND a.name='Búsqueda binaria — Algoritmos — Salón 4'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def binary_search_19(arr,target):\\n    l,r=0,len(arr)-1\\n    while l<=r:\\n        mid=(l+r)//2\\n        if arr[mid]==target: return mid\\n        elif arr[mid]<target: l=mid+1\\n        else: r=mid-1\\n    return -1\\nprint(binary_search_19([1,3,5,7,9],7))','evaluated',89.00,'ORIGINAL: Algoritmos — Salón 4 alumno 19',1,UNIX_TIMESTAMP()-680525,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al19_salon04'
WHERE c.shortname='salon04' AND a.name='Búsqueda binaria — Algoritmos — Salón 4'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def binary_search_20(arr,target):\\n    l,r=0,len(arr)-1\\n    while l<=r:\\n        mid=(l+r)//2\\n        if arr[mid]==target: return mid\\n        elif arr[mid]<target: l=mid+1\\n        else: r=mid-1\\n    return -1\\nprint(binary_search_20([1,3,5,7,9],7))','evaluated',90.00,'ORIGINAL: Algoritmos — Salón 4 alumno 20',1,UNIX_TIMESTAMP()-1198893,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al20_salon04'
WHERE c.shortname='salon04' AND a.name='Búsqueda binaria — Algoritmos — Salón 4'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def buscar_21(lista,valor):\\n    ini,fin=0,len(lista)-1\\n    while ini<=fin:\\n        medio=(ini+fin)//2\\n        if lista[medio]==valor: return medio\\n        elif lista[medio]<valor: ini=medio+1\\n        else: fin=medio-1\\n    return -1\\nprint(buscar_21([1,3,5,7,9],7))','evaluated',91.00,'PLAGIO: Algoritmos — Salón 4 alumno 21',1,UNIX_TIMESTAMP()-927353,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al21_salon04'
WHERE c.shortname='salon04' AND a.name='Búsqueda binaria — Algoritmos — Salón 4'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def buscar_22(lista,valor):\\n    ini,fin=0,len(lista)-1\\n    while ini<=fin:\\n        medio=(ini+fin)//2\\n        if lista[medio]==valor: return medio\\n        elif lista[medio]<valor: ini=medio+1\\n        else: fin=medio-1\\n    return -1\\nprint(buscar_22([1,3,5,7,9],7))','evaluated',92.00,'PLAGIO: Algoritmos — Salón 4 alumno 22',1,UNIX_TIMESTAMP()-316162,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al22_salon04'
WHERE c.shortname='salon04' AND a.name='Búsqueda binaria — Algoritmos — Salón 4'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bin_rec_23(arr,t,l=0,r=None):\\n    if r is None: r=len(arr)-1\\n    if l>r: return -1\\n    mid=(l+r)//2\\n    if arr[mid]==t: return mid\\n    if arr[mid]<t: return bin_rec_23(arr,t,mid+1,r)\\n    return bin_rec_23(arr,t,l,mid-1)\\nprint(bin_rec_23([1,3,5,7,9],7))','evaluated',93.00,'SOSPECHOSO: Algoritmos — Salón 4 alumno 23',1,UNIX_TIMESTAMP()-1037410,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al23_salon04'
WHERE c.shortname='salon04' AND a.name='Búsqueda binaria — Algoritmos — Salón 4'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def binary_search_24(arr,target):\\n    l,r=0,len(arr)-1\\n    while l<=r:\\n        mid=(l+r)//2\\n        if arr[mid]==target: return mid\\n        elif arr[mid]<target: l=mid+1\\n        else: r=mid-1\\n    return -1\\nprint(binary_search_24([1,3,5,7,9],7))','evaluated',94.00,'ORIGINAL: Algoritmos — Salón 4 alumno 24',1,UNIX_TIMESTAMP()-116951,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al24_salon04'
WHERE c.shortname='salon04' AND a.name='Búsqueda binaria — Algoritmos — Salón 4'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def binary_search_25(arr,target):\\n    l,r=0,len(arr)-1\\n    while l<=r:\\n        mid=(l+r)//2\\n        if arr[mid]==target: return mid\\n        elif arr[mid]<target: l=mid+1\\n        else: r=mid-1\\n    return -1\\nprint(binary_search_25([1,3,5,7,9],7))','evaluated',70.00,'ORIGINAL: Algoritmos — Salón 4 alumno 25',1,UNIX_TIMESTAMP()-894470,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al25_salon04'
WHERE c.shortname='salon04' AND a.name='Búsqueda binaria — Algoritmos — Salón 4'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'SELECT est.nombre, est.apellido, cal.calificacion FROM estudiantes est JOIN calificaciones cal ON est.id=cal.estudiante_id WHERE cal.calificacion>=70 ORDER BY cal.calificacion DESC; -- p1','evaluated',71.00,'PLAGIO: Bases de Datos — Salón 5 alumno 1',1,UNIX_TIMESTAMP()-1145502,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al01_salon05'
WHERE c.shortname='salon05' AND a.name='Consulta SQL con JOIN — Bases de Datos — Salón 5'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'SELECT est.nombre, est.apellido, cal.calificacion FROM estudiantes est JOIN calificaciones cal ON est.id=cal.estudiante_id WHERE cal.calificacion>=70 ORDER BY cal.calificacion DESC; -- p2','evaluated',72.00,'PLAGIO: Bases de Datos — Salón 5 alumno 2',1,UNIX_TIMESTAMP()-349848,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al02_salon05'
WHERE c.shortname='salon05' AND a.name='Consulta SQL con JOIN — Bases de Datos — Salón 5'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'SELECT e.nombre, e.apellido, c.calificacion FROM calificaciones c INNER JOIN estudiantes e ON c.estudiante_id=e.id WHERE c.calificacion>=70 ORDER BY 3 DESC; -- s3','evaluated',73.00,'SOSPECHOSO: Bases de Datos — Salón 5 alumno 3',1,UNIX_TIMESTAMP()-472698,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al03_salon05'
WHERE c.shortname='salon05' AND a.name='Consulta SQL con JOIN — Bases de Datos — Salón 5'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'SELECT e.nombre, e.apellido, c.calificacion FROM estudiantes e INNER JOIN calificaciones c ON e.id=c.estudiante_id WHERE c.calificacion>=70 ORDER BY c.calificacion DESC; -- v4','evaluated',74.00,'ORIGINAL: Bases de Datos — Salón 5 alumno 4',1,UNIX_TIMESTAMP()-548438,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al04_salon05'
WHERE c.shortname='salon05' AND a.name='Consulta SQL con JOIN — Bases de Datos — Salón 5'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'SELECT e.nombre, e.apellido, c.calificacion FROM estudiantes e INNER JOIN calificaciones c ON e.id=c.estudiante_id WHERE c.calificacion>=70 ORDER BY c.calificacion DESC; -- v5','evaluated',75.00,'ORIGINAL: Bases de Datos — Salón 5 alumno 5',1,UNIX_TIMESTAMP()-1147435,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al05_salon05'
WHERE c.shortname='salon05' AND a.name='Consulta SQL con JOIN — Bases de Datos — Salón 5'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'SELECT est.nombre, est.apellido, cal.calificacion FROM estudiantes est JOIN calificaciones cal ON est.id=cal.estudiante_id WHERE cal.calificacion>=70 ORDER BY cal.calificacion DESC; -- p6','evaluated',76.00,'PLAGIO: Bases de Datos — Salón 5 alumno 6',1,UNIX_TIMESTAMP()-384824,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al06_salon05'
WHERE c.shortname='salon05' AND a.name='Consulta SQL con JOIN — Bases de Datos — Salón 5'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'SELECT est.nombre, est.apellido, cal.calificacion FROM estudiantes est JOIN calificaciones cal ON est.id=cal.estudiante_id WHERE cal.calificacion>=70 ORDER BY cal.calificacion DESC; -- p7','evaluated',77.00,'PLAGIO: Bases de Datos — Salón 5 alumno 7',1,UNIX_TIMESTAMP()-864775,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al07_salon05'
WHERE c.shortname='salon05' AND a.name='Consulta SQL con JOIN — Bases de Datos — Salón 5'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'SELECT e.nombre, e.apellido, c.calificacion FROM calificaciones c INNER JOIN estudiantes e ON c.estudiante_id=e.id WHERE c.calificacion>=70 ORDER BY 3 DESC; -- s8','evaluated',78.00,'SOSPECHOSO: Bases de Datos — Salón 5 alumno 8',1,UNIX_TIMESTAMP()-870226,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al08_salon05'
WHERE c.shortname='salon05' AND a.name='Consulta SQL con JOIN — Bases de Datos — Salón 5'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'SELECT e.nombre, e.apellido, c.calificacion FROM estudiantes e INNER JOIN calificaciones c ON e.id=c.estudiante_id WHERE c.calificacion>=70 ORDER BY c.calificacion DESC; -- v9','evaluated',79.00,'ORIGINAL: Bases de Datos — Salón 5 alumno 9',1,UNIX_TIMESTAMP()-620464,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al09_salon05'
WHERE c.shortname='salon05' AND a.name='Consulta SQL con JOIN — Bases de Datos — Salón 5'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'SELECT e.nombre, e.apellido, c.calificacion FROM estudiantes e INNER JOIN calificaciones c ON e.id=c.estudiante_id WHERE c.calificacion>=70 ORDER BY c.calificacion DESC; -- v10','evaluated',80.00,'ORIGINAL: Bases de Datos — Salón 5 alumno 10',1,UNIX_TIMESTAMP()-524199,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al10_salon05'
WHERE c.shortname='salon05' AND a.name='Consulta SQL con JOIN — Bases de Datos — Salón 5'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'SELECT est.nombre, est.apellido, cal.calificacion FROM estudiantes est JOIN calificaciones cal ON est.id=cal.estudiante_id WHERE cal.calificacion>=70 ORDER BY cal.calificacion DESC; -- p11','evaluated',81.00,'PLAGIO: Bases de Datos — Salón 5 alumno 11',1,UNIX_TIMESTAMP()-1202398,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al11_salon05'
WHERE c.shortname='salon05' AND a.name='Consulta SQL con JOIN — Bases de Datos — Salón 5'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'SELECT est.nombre, est.apellido, cal.calificacion FROM estudiantes est JOIN calificaciones cal ON est.id=cal.estudiante_id WHERE cal.calificacion>=70 ORDER BY cal.calificacion DESC; -- p12','evaluated',82.00,'PLAGIO: Bases de Datos — Salón 5 alumno 12',1,UNIX_TIMESTAMP()-1067525,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al12_salon05'
WHERE c.shortname='salon05' AND a.name='Consulta SQL con JOIN — Bases de Datos — Salón 5'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'SELECT e.nombre, e.apellido, c.calificacion FROM calificaciones c INNER JOIN estudiantes e ON c.estudiante_id=e.id WHERE c.calificacion>=70 ORDER BY 3 DESC; -- s13','evaluated',83.00,'SOSPECHOSO: Bases de Datos — Salón 5 alumno 13',1,UNIX_TIMESTAMP()-549084,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al13_salon05'
WHERE c.shortname='salon05' AND a.name='Consulta SQL con JOIN — Bases de Datos — Salón 5'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'SELECT e.nombre, e.apellido, c.calificacion FROM estudiantes e INNER JOIN calificaciones c ON e.id=c.estudiante_id WHERE c.calificacion>=70 ORDER BY c.calificacion DESC; -- v14','evaluated',84.00,'ORIGINAL: Bases de Datos — Salón 5 alumno 14',1,UNIX_TIMESTAMP()-792114,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al14_salon05'
WHERE c.shortname='salon05' AND a.name='Consulta SQL con JOIN — Bases de Datos — Salón 5'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'SELECT e.nombre, e.apellido, c.calificacion FROM estudiantes e INNER JOIN calificaciones c ON e.id=c.estudiante_id WHERE c.calificacion>=70 ORDER BY c.calificacion DESC; -- v15','evaluated',85.00,'ORIGINAL: Bases de Datos — Salón 5 alumno 15',1,UNIX_TIMESTAMP()-672162,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al15_salon05'
WHERE c.shortname='salon05' AND a.name='Consulta SQL con JOIN — Bases de Datos — Salón 5'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'SELECT est.nombre, est.apellido, cal.calificacion FROM estudiantes est JOIN calificaciones cal ON est.id=cal.estudiante_id WHERE cal.calificacion>=70 ORDER BY cal.calificacion DESC; -- p16','evaluated',86.00,'PLAGIO: Bases de Datos — Salón 5 alumno 16',1,UNIX_TIMESTAMP()-795361,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al16_salon05'
WHERE c.shortname='salon05' AND a.name='Consulta SQL con JOIN — Bases de Datos — Salón 5'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'SELECT est.nombre, est.apellido, cal.calificacion FROM estudiantes est JOIN calificaciones cal ON est.id=cal.estudiante_id WHERE cal.calificacion>=70 ORDER BY cal.calificacion DESC; -- p17','evaluated',87.00,'PLAGIO: Bases de Datos — Salón 5 alumno 17',1,UNIX_TIMESTAMP()-607428,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al17_salon05'
WHERE c.shortname='salon05' AND a.name='Consulta SQL con JOIN — Bases de Datos — Salón 5'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'SELECT e.nombre, e.apellido, c.calificacion FROM calificaciones c INNER JOIN estudiantes e ON c.estudiante_id=e.id WHERE c.calificacion>=70 ORDER BY 3 DESC; -- s18','evaluated',88.00,'SOSPECHOSO: Bases de Datos — Salón 5 alumno 18',1,UNIX_TIMESTAMP()-538109,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al18_salon05'
WHERE c.shortname='salon05' AND a.name='Consulta SQL con JOIN — Bases de Datos — Salón 5'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'SELECT e.nombre, e.apellido, c.calificacion FROM estudiantes e INNER JOIN calificaciones c ON e.id=c.estudiante_id WHERE c.calificacion>=70 ORDER BY c.calificacion DESC; -- v19','evaluated',89.00,'ORIGINAL: Bases de Datos — Salón 5 alumno 19',1,UNIX_TIMESTAMP()-224902,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al19_salon05'
WHERE c.shortname='salon05' AND a.name='Consulta SQL con JOIN — Bases de Datos — Salón 5'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'SELECT e.nombre, e.apellido, c.calificacion FROM estudiantes e INNER JOIN calificaciones c ON e.id=c.estudiante_id WHERE c.calificacion>=70 ORDER BY c.calificacion DESC; -- v20','evaluated',90.00,'ORIGINAL: Bases de Datos — Salón 5 alumno 20',1,UNIX_TIMESTAMP()-155104,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al20_salon05'
WHERE c.shortname='salon05' AND a.name='Consulta SQL con JOIN — Bases de Datos — Salón 5'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'SELECT est.nombre, est.apellido, cal.calificacion FROM estudiantes est JOIN calificaciones cal ON est.id=cal.estudiante_id WHERE cal.calificacion>=70 ORDER BY cal.calificacion DESC; -- p21','evaluated',91.00,'PLAGIO: Bases de Datos — Salón 5 alumno 21',1,UNIX_TIMESTAMP()-732214,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al21_salon05'
WHERE c.shortname='salon05' AND a.name='Consulta SQL con JOIN — Bases de Datos — Salón 5'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'SELECT est.nombre, est.apellido, cal.calificacion FROM estudiantes est JOIN calificaciones cal ON est.id=cal.estudiante_id WHERE cal.calificacion>=70 ORDER BY cal.calificacion DESC; -- p22','evaluated',92.00,'PLAGIO: Bases de Datos — Salón 5 alumno 22',1,UNIX_TIMESTAMP()-619414,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al22_salon05'
WHERE c.shortname='salon05' AND a.name='Consulta SQL con JOIN — Bases de Datos — Salón 5'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'SELECT e.nombre, e.apellido, c.calificacion FROM calificaciones c INNER JOIN estudiantes e ON c.estudiante_id=e.id WHERE c.calificacion>=70 ORDER BY 3 DESC; -- s23','evaluated',93.00,'SOSPECHOSO: Bases de Datos — Salón 5 alumno 23',1,UNIX_TIMESTAMP()-166222,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al23_salon05'
WHERE c.shortname='salon05' AND a.name='Consulta SQL con JOIN — Bases de Datos — Salón 5'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'SELECT e.nombre, e.apellido, c.calificacion FROM estudiantes e INNER JOIN calificaciones c ON e.id=c.estudiante_id WHERE c.calificacion>=70 ORDER BY c.calificacion DESC; -- v24','evaluated',94.00,'ORIGINAL: Bases de Datos — Salón 5 alumno 24',1,UNIX_TIMESTAMP()-423988,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al24_salon05'
WHERE c.shortname='salon05' AND a.name='Consulta SQL con JOIN — Bases de Datos — Salón 5'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'SELECT e.nombre, e.apellido, c.calificacion FROM estudiantes e INNER JOIN calificaciones c ON e.id=c.estudiante_id WHERE c.calificacion>=70 ORDER BY c.calificacion DESC; -- v25','evaluated',70.00,'ORIGINAL: Bases de Datos — Salón 5 alumno 25',1,UNIX_TIMESTAMP()-1202389,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al25_salon05'
WHERE c.shortname='salon05' AND a.name='Consulta SQL con JOIN — Bases de Datos — Salón 5'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'Diagrama biblioteca: Libro, Usuario, Prestamo, Bibliotecario. Copia 1.','evaluated',71.00,'PLAGIO: Bases de Datos — Salón 5 alumno 1',1,UNIX_TIMESTAMP()-145227,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al01_salon05'
WHERE c.shortname='salon05' AND a.name='Diagrama de clases UML — Bases de Datos — Salón 5'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'Diagrama biblioteca: Libro, Usuario, Prestamo, Bibliotecario. Copia 2.','evaluated',72.00,'PLAGIO: Bases de Datos — Salón 5 alumno 2',1,UNIX_TIMESTAMP()-1056517,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al02_salon05'
WHERE c.shortname='salon05' AND a.name='Diagrama de clases UML — Bases de Datos — Salón 5'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'Biblioteca modela libros, usuarios y prestamos con fechas. Ref 3.','evaluated',73.00,'SOSPECHOSO: Bases de Datos — Salón 5 alumno 3',1,UNIX_TIMESTAMP()-920629,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al03_salon05'
WHERE c.shortname='salon05' AND a.name='Diagrama de clases UML — Bases de Datos — Salón 5'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'El sistema de biblioteca incluye Libro, Usuario, Prestamo y Bibliotecario. Version 4.','evaluated',74.00,'ORIGINAL: Bases de Datos — Salón 5 alumno 4',1,UNIX_TIMESTAMP()-711342,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al04_salon05'
WHERE c.shortname='salon05' AND a.name='Diagrama de clases UML — Bases de Datos — Salón 5'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'El sistema de biblioteca incluye Libro, Usuario, Prestamo y Bibliotecario. Version 5.','evaluated',75.00,'ORIGINAL: Bases de Datos — Salón 5 alumno 5',1,UNIX_TIMESTAMP()-939978,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al05_salon05'
WHERE c.shortname='salon05' AND a.name='Diagrama de clases UML — Bases de Datos — Salón 5'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'Diagrama biblioteca: Libro, Usuario, Prestamo, Bibliotecario. Copia 6.','evaluated',76.00,'PLAGIO: Bases de Datos — Salón 5 alumno 6',1,UNIX_TIMESTAMP()-949940,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al06_salon05'
WHERE c.shortname='salon05' AND a.name='Diagrama de clases UML — Bases de Datos — Salón 5'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'Diagrama biblioteca: Libro, Usuario, Prestamo, Bibliotecario. Copia 7.','evaluated',77.00,'PLAGIO: Bases de Datos — Salón 5 alumno 7',1,UNIX_TIMESTAMP()-843470,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al07_salon05'
WHERE c.shortname='salon05' AND a.name='Diagrama de clases UML — Bases de Datos — Salón 5'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'Biblioteca modela libros, usuarios y prestamos con fechas. Ref 8.','evaluated',78.00,'SOSPECHOSO: Bases de Datos — Salón 5 alumno 8',1,UNIX_TIMESTAMP()-1168526,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al08_salon05'
WHERE c.shortname='salon05' AND a.name='Diagrama de clases UML — Bases de Datos — Salón 5'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'El sistema de biblioteca incluye Libro, Usuario, Prestamo y Bibliotecario. Version 9.','evaluated',79.00,'ORIGINAL: Bases de Datos — Salón 5 alumno 9',1,UNIX_TIMESTAMP()-1101686,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al09_salon05'
WHERE c.shortname='salon05' AND a.name='Diagrama de clases UML — Bases de Datos — Salón 5'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'El sistema de biblioteca incluye Libro, Usuario, Prestamo y Bibliotecario. Version 10.','evaluated',80.00,'ORIGINAL: Bases de Datos — Salón 5 alumno 10',1,UNIX_TIMESTAMP()-1022797,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al10_salon05'
WHERE c.shortname='salon05' AND a.name='Diagrama de clases UML — Bases de Datos — Salón 5'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'Diagrama biblioteca: Libro, Usuario, Prestamo, Bibliotecario. Copia 11.','evaluated',81.00,'PLAGIO: Bases de Datos — Salón 5 alumno 11',1,UNIX_TIMESTAMP()-612022,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al11_salon05'
WHERE c.shortname='salon05' AND a.name='Diagrama de clases UML — Bases de Datos — Salón 5'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'Diagrama biblioteca: Libro, Usuario, Prestamo, Bibliotecario. Copia 12.','evaluated',82.00,'PLAGIO: Bases de Datos — Salón 5 alumno 12',1,UNIX_TIMESTAMP()-114951,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al12_salon05'
WHERE c.shortname='salon05' AND a.name='Diagrama de clases UML — Bases de Datos — Salón 5'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'Biblioteca modela libros, usuarios y prestamos con fechas. Ref 13.','evaluated',83.00,'SOSPECHOSO: Bases de Datos — Salón 5 alumno 13',1,UNIX_TIMESTAMP()-1011986,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al13_salon05'
WHERE c.shortname='salon05' AND a.name='Diagrama de clases UML — Bases de Datos — Salón 5'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'El sistema de biblioteca incluye Libro, Usuario, Prestamo y Bibliotecario. Version 14.','evaluated',84.00,'ORIGINAL: Bases de Datos — Salón 5 alumno 14',1,UNIX_TIMESTAMP()-204059,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al14_salon05'
WHERE c.shortname='salon05' AND a.name='Diagrama de clases UML — Bases de Datos — Salón 5'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'El sistema de biblioteca incluye Libro, Usuario, Prestamo y Bibliotecario. Version 15.','evaluated',85.00,'ORIGINAL: Bases de Datos — Salón 5 alumno 15',1,UNIX_TIMESTAMP()-1017514,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al15_salon05'
WHERE c.shortname='salon05' AND a.name='Diagrama de clases UML — Bases de Datos — Salón 5'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'Diagrama biblioteca: Libro, Usuario, Prestamo, Bibliotecario. Copia 16.','evaluated',86.00,'PLAGIO: Bases de Datos — Salón 5 alumno 16',1,UNIX_TIMESTAMP()-258208,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al16_salon05'
WHERE c.shortname='salon05' AND a.name='Diagrama de clases UML — Bases de Datos — Salón 5'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'Diagrama biblioteca: Libro, Usuario, Prestamo, Bibliotecario. Copia 17.','evaluated',87.00,'PLAGIO: Bases de Datos — Salón 5 alumno 17',1,UNIX_TIMESTAMP()-455289,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al17_salon05'
WHERE c.shortname='salon05' AND a.name='Diagrama de clases UML — Bases de Datos — Salón 5'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'Biblioteca modela libros, usuarios y prestamos con fechas. Ref 18.','evaluated',88.00,'SOSPECHOSO: Bases de Datos — Salón 5 alumno 18',1,UNIX_TIMESTAMP()-1033962,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al18_salon05'
WHERE c.shortname='salon05' AND a.name='Diagrama de clases UML — Bases de Datos — Salón 5'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'El sistema de biblioteca incluye Libro, Usuario, Prestamo y Bibliotecario. Version 19.','evaluated',89.00,'ORIGINAL: Bases de Datos — Salón 5 alumno 19',1,UNIX_TIMESTAMP()-1085766,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al19_salon05'
WHERE c.shortname='salon05' AND a.name='Diagrama de clases UML — Bases de Datos — Salón 5'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'El sistema de biblioteca incluye Libro, Usuario, Prestamo y Bibliotecario. Version 20.','evaluated',90.00,'ORIGINAL: Bases de Datos — Salón 5 alumno 20',1,UNIX_TIMESTAMP()-10436,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al20_salon05'
WHERE c.shortname='salon05' AND a.name='Diagrama de clases UML — Bases de Datos — Salón 5'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'Diagrama biblioteca: Libro, Usuario, Prestamo, Bibliotecario. Copia 21.','evaluated',91.00,'PLAGIO: Bases de Datos — Salón 5 alumno 21',1,UNIX_TIMESTAMP()-396293,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al21_salon05'
WHERE c.shortname='salon05' AND a.name='Diagrama de clases UML — Bases de Datos — Salón 5'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'Diagrama biblioteca: Libro, Usuario, Prestamo, Bibliotecario. Copia 22.','evaluated',92.00,'PLAGIO: Bases de Datos — Salón 5 alumno 22',1,UNIX_TIMESTAMP()-423032,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al22_salon05'
WHERE c.shortname='salon05' AND a.name='Diagrama de clases UML — Bases de Datos — Salón 5'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'Biblioteca modela libros, usuarios y prestamos con fechas. Ref 23.','evaluated',93.00,'SOSPECHOSO: Bases de Datos — Salón 5 alumno 23',1,UNIX_TIMESTAMP()-312466,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al23_salon05'
WHERE c.shortname='salon05' AND a.name='Diagrama de clases UML — Bases de Datos — Salón 5'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'El sistema de biblioteca incluye Libro, Usuario, Prestamo y Bibliotecario. Version 24.','evaluated',94.00,'ORIGINAL: Bases de Datos — Salón 5 alumno 24',1,UNIX_TIMESTAMP()-400950,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al24_salon05'
WHERE c.shortname='salon05' AND a.name='Diagrama de clases UML — Bases de Datos — Salón 5'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'El sistema de biblioteca incluye Libro, Usuario, Prestamo y Bibliotecario. Version 25.','evaluated',70.00,'ORIGINAL: Bases de Datos — Salón 5 alumno 25',1,UNIX_TIMESTAMP()-365827,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al25_salon05'
WHERE c.shortname='salon05' AND a.name='Diagrama de clases UML — Bases de Datos — Salón 5'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'SELECT est.nombre, est.apellido, cal.calificacion FROM estudiantes est JOIN calificaciones cal ON est.id=cal.estudiante_id WHERE cal.calificacion>=70 ORDER BY cal.calificacion DESC; -- p1','evaluated',71.00,'PLAGIO: Ingeniería de Software — Salón 6 alumno 1',1,UNIX_TIMESTAMP()-630374,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al01_salon06'
WHERE c.shortname='salon06' AND a.name='Consulta SQL con JOIN — Ingeniería de Software — Salón 6'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'SELECT est.nombre, est.apellido, cal.calificacion FROM estudiantes est JOIN calificaciones cal ON est.id=cal.estudiante_id WHERE cal.calificacion>=70 ORDER BY cal.calificacion DESC; -- p2','evaluated',72.00,'PLAGIO: Ingeniería de Software — Salón 6 alumno 2',1,UNIX_TIMESTAMP()-192052,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al02_salon06'
WHERE c.shortname='salon06' AND a.name='Consulta SQL con JOIN — Ingeniería de Software — Salón 6'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'SELECT e.nombre, e.apellido, c.calificacion FROM calificaciones c INNER JOIN estudiantes e ON c.estudiante_id=e.id WHERE c.calificacion>=70 ORDER BY 3 DESC; -- s3','evaluated',73.00,'SOSPECHOSO: Ingeniería de Software — Salón 6 alumno 3',1,UNIX_TIMESTAMP()-688967,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al03_salon06'
WHERE c.shortname='salon06' AND a.name='Consulta SQL con JOIN — Ingeniería de Software — Salón 6'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'SELECT e.nombre, e.apellido, c.calificacion FROM estudiantes e INNER JOIN calificaciones c ON e.id=c.estudiante_id WHERE c.calificacion>=70 ORDER BY c.calificacion DESC; -- v4','evaluated',74.00,'ORIGINAL: Ingeniería de Software — Salón 6 alumno 4',1,UNIX_TIMESTAMP()-737828,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al04_salon06'
WHERE c.shortname='salon06' AND a.name='Consulta SQL con JOIN — Ingeniería de Software — Salón 6'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'SELECT e.nombre, e.apellido, c.calificacion FROM estudiantes e INNER JOIN calificaciones c ON e.id=c.estudiante_id WHERE c.calificacion>=70 ORDER BY c.calificacion DESC; -- v5','evaluated',75.00,'ORIGINAL: Ingeniería de Software — Salón 6 alumno 5',1,UNIX_TIMESTAMP()-720598,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al05_salon06'
WHERE c.shortname='salon06' AND a.name='Consulta SQL con JOIN — Ingeniería de Software — Salón 6'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'SELECT est.nombre, est.apellido, cal.calificacion FROM estudiantes est JOIN calificaciones cal ON est.id=cal.estudiante_id WHERE cal.calificacion>=70 ORDER BY cal.calificacion DESC; -- p6','evaluated',76.00,'PLAGIO: Ingeniería de Software — Salón 6 alumno 6',1,UNIX_TIMESTAMP()-215181,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al06_salon06'
WHERE c.shortname='salon06' AND a.name='Consulta SQL con JOIN — Ingeniería de Software — Salón 6'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'SELECT est.nombre, est.apellido, cal.calificacion FROM estudiantes est JOIN calificaciones cal ON est.id=cal.estudiante_id WHERE cal.calificacion>=70 ORDER BY cal.calificacion DESC; -- p7','evaluated',77.00,'PLAGIO: Ingeniería de Software — Salón 6 alumno 7',1,UNIX_TIMESTAMP()-1206326,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al07_salon06'
WHERE c.shortname='salon06' AND a.name='Consulta SQL con JOIN — Ingeniería de Software — Salón 6'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'SELECT e.nombre, e.apellido, c.calificacion FROM calificaciones c INNER JOIN estudiantes e ON c.estudiante_id=e.id WHERE c.calificacion>=70 ORDER BY 3 DESC; -- s8','evaluated',78.00,'SOSPECHOSO: Ingeniería de Software — Salón 6 alumno 8',1,UNIX_TIMESTAMP()-1115576,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al08_salon06'
WHERE c.shortname='salon06' AND a.name='Consulta SQL con JOIN — Ingeniería de Software — Salón 6'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'SELECT e.nombre, e.apellido, c.calificacion FROM estudiantes e INNER JOIN calificaciones c ON e.id=c.estudiante_id WHERE c.calificacion>=70 ORDER BY c.calificacion DESC; -- v9','evaluated',79.00,'ORIGINAL: Ingeniería de Software — Salón 6 alumno 9',1,UNIX_TIMESTAMP()-813538,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al09_salon06'
WHERE c.shortname='salon06' AND a.name='Consulta SQL con JOIN — Ingeniería de Software — Salón 6'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'SELECT e.nombre, e.apellido, c.calificacion FROM estudiantes e INNER JOIN calificaciones c ON e.id=c.estudiante_id WHERE c.calificacion>=70 ORDER BY c.calificacion DESC; -- v10','evaluated',80.00,'ORIGINAL: Ingeniería de Software — Salón 6 alumno 10',1,UNIX_TIMESTAMP()-984493,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al10_salon06'
WHERE c.shortname='salon06' AND a.name='Consulta SQL con JOIN — Ingeniería de Software — Salón 6'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'SELECT est.nombre, est.apellido, cal.calificacion FROM estudiantes est JOIN calificaciones cal ON est.id=cal.estudiante_id WHERE cal.calificacion>=70 ORDER BY cal.calificacion DESC; -- p11','evaluated',81.00,'PLAGIO: Ingeniería de Software — Salón 6 alumno 11',1,UNIX_TIMESTAMP()-351592,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al11_salon06'
WHERE c.shortname='salon06' AND a.name='Consulta SQL con JOIN — Ingeniería de Software — Salón 6'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'SELECT est.nombre, est.apellido, cal.calificacion FROM estudiantes est JOIN calificaciones cal ON est.id=cal.estudiante_id WHERE cal.calificacion>=70 ORDER BY cal.calificacion DESC; -- p12','evaluated',82.00,'PLAGIO: Ingeniería de Software — Salón 6 alumno 12',1,UNIX_TIMESTAMP()-39467,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al12_salon06'
WHERE c.shortname='salon06' AND a.name='Consulta SQL con JOIN — Ingeniería de Software — Salón 6'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'SELECT e.nombre, e.apellido, c.calificacion FROM calificaciones c INNER JOIN estudiantes e ON c.estudiante_id=e.id WHERE c.calificacion>=70 ORDER BY 3 DESC; -- s13','evaluated',83.00,'SOSPECHOSO: Ingeniería de Software — Salón 6 alumno 13',1,UNIX_TIMESTAMP()-1195597,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al13_salon06'
WHERE c.shortname='salon06' AND a.name='Consulta SQL con JOIN — Ingeniería de Software — Salón 6'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'SELECT e.nombre, e.apellido, c.calificacion FROM estudiantes e INNER JOIN calificaciones c ON e.id=c.estudiante_id WHERE c.calificacion>=70 ORDER BY c.calificacion DESC; -- v14','evaluated',84.00,'ORIGINAL: Ingeniería de Software — Salón 6 alumno 14',1,UNIX_TIMESTAMP()-945228,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al14_salon06'
WHERE c.shortname='salon06' AND a.name='Consulta SQL con JOIN — Ingeniería de Software — Salón 6'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'SELECT e.nombre, e.apellido, c.calificacion FROM estudiantes e INNER JOIN calificaciones c ON e.id=c.estudiante_id WHERE c.calificacion>=70 ORDER BY c.calificacion DESC; -- v15','evaluated',85.00,'ORIGINAL: Ingeniería de Software — Salón 6 alumno 15',1,UNIX_TIMESTAMP()-1126285,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al15_salon06'
WHERE c.shortname='salon06' AND a.name='Consulta SQL con JOIN — Ingeniería de Software — Salón 6'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'SELECT est.nombre, est.apellido, cal.calificacion FROM estudiantes est JOIN calificaciones cal ON est.id=cal.estudiante_id WHERE cal.calificacion>=70 ORDER BY cal.calificacion DESC; -- p16','evaluated',86.00,'PLAGIO: Ingeniería de Software — Salón 6 alumno 16',1,UNIX_TIMESTAMP()-1194778,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al16_salon06'
WHERE c.shortname='salon06' AND a.name='Consulta SQL con JOIN — Ingeniería de Software — Salón 6'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'SELECT est.nombre, est.apellido, cal.calificacion FROM estudiantes est JOIN calificaciones cal ON est.id=cal.estudiante_id WHERE cal.calificacion>=70 ORDER BY cal.calificacion DESC; -- p17','evaluated',87.00,'PLAGIO: Ingeniería de Software — Salón 6 alumno 17',1,UNIX_TIMESTAMP()-1209339,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al17_salon06'
WHERE c.shortname='salon06' AND a.name='Consulta SQL con JOIN — Ingeniería de Software — Salón 6'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'SELECT e.nombre, e.apellido, c.calificacion FROM calificaciones c INNER JOIN estudiantes e ON c.estudiante_id=e.id WHERE c.calificacion>=70 ORDER BY 3 DESC; -- s18','evaluated',88.00,'SOSPECHOSO: Ingeniería de Software — Salón 6 alumno 18',1,UNIX_TIMESTAMP()-46922,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al18_salon06'
WHERE c.shortname='salon06' AND a.name='Consulta SQL con JOIN — Ingeniería de Software — Salón 6'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'SELECT e.nombre, e.apellido, c.calificacion FROM estudiantes e INNER JOIN calificaciones c ON e.id=c.estudiante_id WHERE c.calificacion>=70 ORDER BY c.calificacion DESC; -- v19','evaluated',89.00,'ORIGINAL: Ingeniería de Software — Salón 6 alumno 19',1,UNIX_TIMESTAMP()-534941,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al19_salon06'
WHERE c.shortname='salon06' AND a.name='Consulta SQL con JOIN — Ingeniería de Software — Salón 6'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'SELECT e.nombre, e.apellido, c.calificacion FROM estudiantes e INNER JOIN calificaciones c ON e.id=c.estudiante_id WHERE c.calificacion>=70 ORDER BY c.calificacion DESC; -- v20','evaluated',90.00,'ORIGINAL: Ingeniería de Software — Salón 6 alumno 20',1,UNIX_TIMESTAMP()-1170425,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al20_salon06'
WHERE c.shortname='salon06' AND a.name='Consulta SQL con JOIN — Ingeniería de Software — Salón 6'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'SELECT est.nombre, est.apellido, cal.calificacion FROM estudiantes est JOIN calificaciones cal ON est.id=cal.estudiante_id WHERE cal.calificacion>=70 ORDER BY cal.calificacion DESC; -- p21','evaluated',91.00,'PLAGIO: Ingeniería de Software — Salón 6 alumno 21',1,UNIX_TIMESTAMP()-1042811,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al21_salon06'
WHERE c.shortname='salon06' AND a.name='Consulta SQL con JOIN — Ingeniería de Software — Salón 6'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'SELECT est.nombre, est.apellido, cal.calificacion FROM estudiantes est JOIN calificaciones cal ON est.id=cal.estudiante_id WHERE cal.calificacion>=70 ORDER BY cal.calificacion DESC; -- p22','evaluated',92.00,'PLAGIO: Ingeniería de Software — Salón 6 alumno 22',1,UNIX_TIMESTAMP()-324673,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al22_salon06'
WHERE c.shortname='salon06' AND a.name='Consulta SQL con JOIN — Ingeniería de Software — Salón 6'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'SELECT e.nombre, e.apellido, c.calificacion FROM calificaciones c INNER JOIN estudiantes e ON c.estudiante_id=e.id WHERE c.calificacion>=70 ORDER BY 3 DESC; -- s23','evaluated',93.00,'SOSPECHOSO: Ingeniería de Software — Salón 6 alumno 23',1,UNIX_TIMESTAMP()-750064,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al23_salon06'
WHERE c.shortname='salon06' AND a.name='Consulta SQL con JOIN — Ingeniería de Software — Salón 6'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'SELECT e.nombre, e.apellido, c.calificacion FROM estudiantes e INNER JOIN calificaciones c ON e.id=c.estudiante_id WHERE c.calificacion>=70 ORDER BY c.calificacion DESC; -- v24','evaluated',94.00,'ORIGINAL: Ingeniería de Software — Salón 6 alumno 24',1,UNIX_TIMESTAMP()-773183,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al24_salon06'
WHERE c.shortname='salon06' AND a.name='Consulta SQL con JOIN — Ingeniería de Software — Salón 6'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'SELECT e.nombre, e.apellido, c.calificacion FROM estudiantes e INNER JOIN calificaciones c ON e.id=c.estudiante_id WHERE c.calificacion>=70 ORDER BY c.calificacion DESC; -- v25','evaluated',70.00,'ORIGINAL: Ingeniería de Software — Salón 6 alumno 25',1,UNIX_TIMESTAMP()-1114163,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al25_salon06'
WHERE c.shortname='salon06' AND a.name='Consulta SQL con JOIN — Ingeniería de Software — Salón 6'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'Diagrama biblioteca: Libro, Usuario, Prestamo, Bibliotecario. Copia 1.','evaluated',71.00,'PLAGIO: Ingeniería de Software — Salón 6 alumno 1',1,UNIX_TIMESTAMP()-1086817,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al01_salon06'
WHERE c.shortname='salon06' AND a.name='Diagrama de clases UML — Ingeniería de Software — Salón 6'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'Diagrama biblioteca: Libro, Usuario, Prestamo, Bibliotecario. Copia 2.','evaluated',72.00,'PLAGIO: Ingeniería de Software — Salón 6 alumno 2',1,UNIX_TIMESTAMP()-319439,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al02_salon06'
WHERE c.shortname='salon06' AND a.name='Diagrama de clases UML — Ingeniería de Software — Salón 6'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'Biblioteca modela libros, usuarios y prestamos con fechas. Ref 3.','evaluated',73.00,'SOSPECHOSO: Ingeniería de Software — Salón 6 alumno 3',1,UNIX_TIMESTAMP()-166020,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al03_salon06'
WHERE c.shortname='salon06' AND a.name='Diagrama de clases UML — Ingeniería de Software — Salón 6'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'El sistema de biblioteca incluye Libro, Usuario, Prestamo y Bibliotecario. Version 4.','evaluated',74.00,'ORIGINAL: Ingeniería de Software — Salón 6 alumno 4',1,UNIX_TIMESTAMP()-452933,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al04_salon06'
WHERE c.shortname='salon06' AND a.name='Diagrama de clases UML — Ingeniería de Software — Salón 6'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'El sistema de biblioteca incluye Libro, Usuario, Prestamo y Bibliotecario. Version 5.','evaluated',75.00,'ORIGINAL: Ingeniería de Software — Salón 6 alumno 5',1,UNIX_TIMESTAMP()-417275,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al05_salon06'
WHERE c.shortname='salon06' AND a.name='Diagrama de clases UML — Ingeniería de Software — Salón 6'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'Diagrama biblioteca: Libro, Usuario, Prestamo, Bibliotecario. Copia 6.','evaluated',76.00,'PLAGIO: Ingeniería de Software — Salón 6 alumno 6',1,UNIX_TIMESTAMP()-1160024,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al06_salon06'
WHERE c.shortname='salon06' AND a.name='Diagrama de clases UML — Ingeniería de Software — Salón 6'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'Diagrama biblioteca: Libro, Usuario, Prestamo, Bibliotecario. Copia 7.','evaluated',77.00,'PLAGIO: Ingeniería de Software — Salón 6 alumno 7',1,UNIX_TIMESTAMP()-423251,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al07_salon06'
WHERE c.shortname='salon06' AND a.name='Diagrama de clases UML — Ingeniería de Software — Salón 6'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'Biblioteca modela libros, usuarios y prestamos con fechas. Ref 8.','evaluated',78.00,'SOSPECHOSO: Ingeniería de Software — Salón 6 alumno 8',1,UNIX_TIMESTAMP()-1152546,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al08_salon06'
WHERE c.shortname='salon06' AND a.name='Diagrama de clases UML — Ingeniería de Software — Salón 6'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'El sistema de biblioteca incluye Libro, Usuario, Prestamo y Bibliotecario. Version 9.','evaluated',79.00,'ORIGINAL: Ingeniería de Software — Salón 6 alumno 9',1,UNIX_TIMESTAMP()-409328,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al09_salon06'
WHERE c.shortname='salon06' AND a.name='Diagrama de clases UML — Ingeniería de Software — Salón 6'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'El sistema de biblioteca incluye Libro, Usuario, Prestamo y Bibliotecario. Version 10.','evaluated',80.00,'ORIGINAL: Ingeniería de Software — Salón 6 alumno 10',1,UNIX_TIMESTAMP()-605534,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al10_salon06'
WHERE c.shortname='salon06' AND a.name='Diagrama de clases UML — Ingeniería de Software — Salón 6'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'Diagrama biblioteca: Libro, Usuario, Prestamo, Bibliotecario. Copia 11.','evaluated',81.00,'PLAGIO: Ingeniería de Software — Salón 6 alumno 11',1,UNIX_TIMESTAMP()-838388,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al11_salon06'
WHERE c.shortname='salon06' AND a.name='Diagrama de clases UML — Ingeniería de Software — Salón 6'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'Diagrama biblioteca: Libro, Usuario, Prestamo, Bibliotecario. Copia 12.','evaluated',82.00,'PLAGIO: Ingeniería de Software — Salón 6 alumno 12',1,UNIX_TIMESTAMP()-910293,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al12_salon06'
WHERE c.shortname='salon06' AND a.name='Diagrama de clases UML — Ingeniería de Software — Salón 6'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'Biblioteca modela libros, usuarios y prestamos con fechas. Ref 13.','evaluated',83.00,'SOSPECHOSO: Ingeniería de Software — Salón 6 alumno 13',1,UNIX_TIMESTAMP()-648253,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al13_salon06'
WHERE c.shortname='salon06' AND a.name='Diagrama de clases UML — Ingeniería de Software — Salón 6'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'El sistema de biblioteca incluye Libro, Usuario, Prestamo y Bibliotecario. Version 14.','evaluated',84.00,'ORIGINAL: Ingeniería de Software — Salón 6 alumno 14',1,UNIX_TIMESTAMP()-652723,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al14_salon06'
WHERE c.shortname='salon06' AND a.name='Diagrama de clases UML — Ingeniería de Software — Salón 6'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'El sistema de biblioteca incluye Libro, Usuario, Prestamo y Bibliotecario. Version 15.','evaluated',85.00,'ORIGINAL: Ingeniería de Software — Salón 6 alumno 15',1,UNIX_TIMESTAMP()-377326,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al15_salon06'
WHERE c.shortname='salon06' AND a.name='Diagrama de clases UML — Ingeniería de Software — Salón 6'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'Diagrama biblioteca: Libro, Usuario, Prestamo, Bibliotecario. Copia 16.','evaluated',86.00,'PLAGIO: Ingeniería de Software — Salón 6 alumno 16',1,UNIX_TIMESTAMP()-904785,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al16_salon06'
WHERE c.shortname='salon06' AND a.name='Diagrama de clases UML — Ingeniería de Software — Salón 6'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'Diagrama biblioteca: Libro, Usuario, Prestamo, Bibliotecario. Copia 17.','evaluated',87.00,'PLAGIO: Ingeniería de Software — Salón 6 alumno 17',1,UNIX_TIMESTAMP()-739016,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al17_salon06'
WHERE c.shortname='salon06' AND a.name='Diagrama de clases UML — Ingeniería de Software — Salón 6'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'Biblioteca modela libros, usuarios y prestamos con fechas. Ref 18.','evaluated',88.00,'SOSPECHOSO: Ingeniería de Software — Salón 6 alumno 18',1,UNIX_TIMESTAMP()-708964,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al18_salon06'
WHERE c.shortname='salon06' AND a.name='Diagrama de clases UML — Ingeniería de Software — Salón 6'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'El sistema de biblioteca incluye Libro, Usuario, Prestamo y Bibliotecario. Version 19.','evaluated',89.00,'ORIGINAL: Ingeniería de Software — Salón 6 alumno 19',1,UNIX_TIMESTAMP()-1202943,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al19_salon06'
WHERE c.shortname='salon06' AND a.name='Diagrama de clases UML — Ingeniería de Software — Salón 6'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'El sistema de biblioteca incluye Libro, Usuario, Prestamo y Bibliotecario. Version 20.','evaluated',90.00,'ORIGINAL: Ingeniería de Software — Salón 6 alumno 20',1,UNIX_TIMESTAMP()-589279,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al20_salon06'
WHERE c.shortname='salon06' AND a.name='Diagrama de clases UML — Ingeniería de Software — Salón 6'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'Diagrama biblioteca: Libro, Usuario, Prestamo, Bibliotecario. Copia 21.','evaluated',91.00,'PLAGIO: Ingeniería de Software — Salón 6 alumno 21',1,UNIX_TIMESTAMP()-604184,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al21_salon06'
WHERE c.shortname='salon06' AND a.name='Diagrama de clases UML — Ingeniería de Software — Salón 6'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'Diagrama biblioteca: Libro, Usuario, Prestamo, Bibliotecario. Copia 22.','evaluated',92.00,'PLAGIO: Ingeniería de Software — Salón 6 alumno 22',1,UNIX_TIMESTAMP()-489069,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al22_salon06'
WHERE c.shortname='salon06' AND a.name='Diagrama de clases UML — Ingeniería de Software — Salón 6'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'Biblioteca modela libros, usuarios y prestamos con fechas. Ref 23.','evaluated',93.00,'SOSPECHOSO: Ingeniería de Software — Salón 6 alumno 23',1,UNIX_TIMESTAMP()-136509,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al23_salon06'
WHERE c.shortname='salon06' AND a.name='Diagrama de clases UML — Ingeniería de Software — Salón 6'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'El sistema de biblioteca incluye Libro, Usuario, Prestamo y Bibliotecario. Version 24.','evaluated',94.00,'ORIGINAL: Ingeniería de Software — Salón 6 alumno 24',1,UNIX_TIMESTAMP()-399226,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al24_salon06'
WHERE c.shortname='salon06' AND a.name='Diagrama de clases UML — Ingeniería de Software — Salón 6'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'El sistema de biblioteca incluye Libro, Usuario, Prestamo y Bibliotecario. Version 25.','evaluated',70.00,'ORIGINAL: Ingeniería de Software — Salón 6 alumno 25',1,UNIX_TIMESTAMP()-226914,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a
JOIN oy1n_course c ON a.course=c.id
JOIN oy1n_user u ON u.username='al25_salon06'
WHERE c.shortname='salon06' AND a.name='Diagrama de clases UML — Ingeniería de Software — Salón 6'
AND NOT EXISTS (
  SELECT 1 FROM oy1n_aiassignment_submissions sx
  WHERE sx.assignment=a.id AND sx.userid=u.id
);

-- ══════════════════════════════════════════════════════════════
-- PASO 14: Evaluaciones con similitud de plagio
-- ══════════════════════════════════════════════════════════════
INSERT INTO oy1n_aiassignment_evaluations (submission,similarity_score,ai_feedback,ai_analysis,timecreated)
SELECT s.id,
  CASE
    WHEN MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),5) IN (1,2) THEN 75+MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),20)
    WHEN MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),5)=3        THEN 45+MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),25)
    ELSE 5+MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),18)
  END,
  s.feedback,'{}',UNIX_TIMESTAMP()
FROM oy1n_aiassignment_submissions s
JOIN oy1n_user u ON s.userid=u.id
JOIN oy1n_aiassignment a ON s.assignment=a.id
WHERE a.name='Factorial recursivo — Programación I — Salón 1' AND u.username LIKE 'al%_salon01'
AND NOT EXISTS (SELECT 1 FROM oy1n_aiassignment_evaluations e WHERE e.submission=s.id);

INSERT INTO oy1n_aiassignment_evaluations (submission,similarity_score,ai_feedback,ai_analysis,timecreated)
SELECT s.id,
  CASE
    WHEN MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),5) IN (1,2) THEN 75+MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),20)
    WHEN MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),5)=3        THEN 45+MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),25)
    ELSE 5+MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),18)
  END,
  s.feedback,'{}',UNIX_TIMESTAMP()
FROM oy1n_aiassignment_submissions s
JOIN oy1n_user u ON s.userid=u.id
JOIN oy1n_aiassignment a ON s.assignment=a.id
WHERE a.name='Serie de Fibonacci — Programación I — Salón 1' AND u.username LIKE 'al%_salon01'
AND NOT EXISTS (SELECT 1 FROM oy1n_aiassignment_evaluations e WHERE e.submission=s.id);

INSERT INTO oy1n_aiassignment_evaluations (submission,similarity_score,ai_feedback,ai_analysis,timecreated)
SELECT s.id,
  CASE
    WHEN MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),5) IN (1,2) THEN 75+MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),20)
    WHEN MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),5)=3        THEN 45+MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),25)
    ELSE 5+MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),18)
  END,
  s.feedback,'{}',UNIX_TIMESTAMP()
FROM oy1n_aiassignment_submissions s
JOIN oy1n_user u ON s.userid=u.id
JOIN oy1n_aiassignment a ON s.assignment=a.id
WHERE a.name='Factorial recursivo — Programación II — Salón 2' AND u.username LIKE 'al%_salon02'
AND NOT EXISTS (SELECT 1 FROM oy1n_aiassignment_evaluations e WHERE e.submission=s.id);

INSERT INTO oy1n_aiassignment_evaluations (submission,similarity_score,ai_feedback,ai_analysis,timecreated)
SELECT s.id,
  CASE
    WHEN MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),5) IN (1,2) THEN 75+MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),20)
    WHEN MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),5)=3        THEN 45+MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),25)
    ELSE 5+MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),18)
  END,
  s.feedback,'{}',UNIX_TIMESTAMP()
FROM oy1n_aiassignment_submissions s
JOIN oy1n_user u ON s.userid=u.id
JOIN oy1n_aiassignment a ON s.assignment=a.id
WHERE a.name='Serie de Fibonacci — Programación II — Salón 2' AND u.username LIKE 'al%_salon02'
AND NOT EXISTS (SELECT 1 FROM oy1n_aiassignment_evaluations e WHERE e.submission=s.id);

INSERT INTO oy1n_aiassignment_evaluations (submission,similarity_score,ai_feedback,ai_analysis,timecreated)
SELECT s.id,
  CASE
    WHEN MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),5) IN (1,2) THEN 75+MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),20)
    WHEN MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),5)=3        THEN 45+MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),25)
    ELSE 5+MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),18)
  END,
  s.feedback,'{}',UNIX_TIMESTAMP()
FROM oy1n_aiassignment_submissions s
JOIN oy1n_user u ON s.userid=u.id
JOIN oy1n_aiassignment a ON s.assignment=a.id
WHERE a.name='Bubble Sort — Estructuras de Datos — Salón 3' AND u.username LIKE 'al%_salon03'
AND NOT EXISTS (SELECT 1 FROM oy1n_aiassignment_evaluations e WHERE e.submission=s.id);

INSERT INTO oy1n_aiassignment_evaluations (submission,similarity_score,ai_feedback,ai_analysis,timecreated)
SELECT s.id,
  CASE
    WHEN MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),5) IN (1,2) THEN 75+MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),20)
    WHEN MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),5)=3        THEN 45+MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),25)
    ELSE 5+MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),18)
  END,
  s.feedback,'{}',UNIX_TIMESTAMP()
FROM oy1n_aiassignment_submissions s
JOIN oy1n_user u ON s.userid=u.id
JOIN oy1n_aiassignment a ON s.assignment=a.id
WHERE a.name='Búsqueda binaria — Estructuras de Datos — Salón 3' AND u.username LIKE 'al%_salon03'
AND NOT EXISTS (SELECT 1 FROM oy1n_aiassignment_evaluations e WHERE e.submission=s.id);

INSERT INTO oy1n_aiassignment_evaluations (submission,similarity_score,ai_feedback,ai_analysis,timecreated)
SELECT s.id,
  CASE
    WHEN MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),5) IN (1,2) THEN 75+MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),20)
    WHEN MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),5)=3        THEN 45+MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),25)
    ELSE 5+MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),18)
  END,
  s.feedback,'{}',UNIX_TIMESTAMP()
FROM oy1n_aiassignment_submissions s
JOIN oy1n_user u ON s.userid=u.id
JOIN oy1n_aiassignment a ON s.assignment=a.id
WHERE a.name='Bubble Sort — Algoritmos — Salón 4' AND u.username LIKE 'al%_salon04'
AND NOT EXISTS (SELECT 1 FROM oy1n_aiassignment_evaluations e WHERE e.submission=s.id);

INSERT INTO oy1n_aiassignment_evaluations (submission,similarity_score,ai_feedback,ai_analysis,timecreated)
SELECT s.id,
  CASE
    WHEN MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),5) IN (1,2) THEN 75+MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),20)
    WHEN MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),5)=3        THEN 45+MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),25)
    ELSE 5+MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),18)
  END,
  s.feedback,'{}',UNIX_TIMESTAMP()
FROM oy1n_aiassignment_submissions s
JOIN oy1n_user u ON s.userid=u.id
JOIN oy1n_aiassignment a ON s.assignment=a.id
WHERE a.name='Búsqueda binaria — Algoritmos — Salón 4' AND u.username LIKE 'al%_salon04'
AND NOT EXISTS (SELECT 1 FROM oy1n_aiassignment_evaluations e WHERE e.submission=s.id);

INSERT INTO oy1n_aiassignment_evaluations (submission,similarity_score,ai_feedback,ai_analysis,timecreated)
SELECT s.id,
  CASE
    WHEN MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),5) IN (1,2) THEN 75+MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),20)
    WHEN MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),5)=3        THEN 45+MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),25)
    ELSE 5+MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),18)
  END,
  s.feedback,'{}',UNIX_TIMESTAMP()
FROM oy1n_aiassignment_submissions s
JOIN oy1n_user u ON s.userid=u.id
JOIN oy1n_aiassignment a ON s.assignment=a.id
WHERE a.name='Consulta SQL con JOIN — Bases de Datos — Salón 5' AND u.username LIKE 'al%_salon05'
AND NOT EXISTS (SELECT 1 FROM oy1n_aiassignment_evaluations e WHERE e.submission=s.id);

INSERT INTO oy1n_aiassignment_evaluations (submission,similarity_score,ai_feedback,ai_analysis,timecreated)
SELECT s.id,
  CASE
    WHEN MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),5) IN (1,2) THEN 75+MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),20)
    WHEN MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),5)=3        THEN 45+MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),25)
    ELSE 5+MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),18)
  END,
  s.feedback,'{}',UNIX_TIMESTAMP()
FROM oy1n_aiassignment_submissions s
JOIN oy1n_user u ON s.userid=u.id
JOIN oy1n_aiassignment a ON s.assignment=a.id
WHERE a.name='Diagrama de clases UML — Bases de Datos — Salón 5' AND u.username LIKE 'al%_salon05'
AND NOT EXISTS (SELECT 1 FROM oy1n_aiassignment_evaluations e WHERE e.submission=s.id);

INSERT INTO oy1n_aiassignment_evaluations (submission,similarity_score,ai_feedback,ai_analysis,timecreated)
SELECT s.id,
  CASE
    WHEN MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),5) IN (1,2) THEN 75+MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),20)
    WHEN MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),5)=3        THEN 45+MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),25)
    ELSE 5+MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),18)
  END,
  s.feedback,'{}',UNIX_TIMESTAMP()
FROM oy1n_aiassignment_submissions s
JOIN oy1n_user u ON s.userid=u.id
JOIN oy1n_aiassignment a ON s.assignment=a.id
WHERE a.name='Consulta SQL con JOIN — Ingeniería de Software — Salón 6' AND u.username LIKE 'al%_salon06'
AND NOT EXISTS (SELECT 1 FROM oy1n_aiassignment_evaluations e WHERE e.submission=s.id);

INSERT INTO oy1n_aiassignment_evaluations (submission,similarity_score,ai_feedback,ai_analysis,timecreated)
SELECT s.id,
  CASE
    WHEN MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),5) IN (1,2) THEN 75+MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),20)
    WHEN MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),5)=3        THEN 45+MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),25)
    ELSE 5+MOD(CAST(SUBSTRING(u.username,4,2) AS UNSIGNED),18)
  END,
  s.feedback,'{}',UNIX_TIMESTAMP()
FROM oy1n_aiassignment_submissions s
JOIN oy1n_user u ON s.userid=u.id
JOIN oy1n_aiassignment a ON s.assignment=a.id
WHERE a.name='Diagrama de clases UML — Ingeniería de Software — Salón 6' AND u.username LIKE 'al%_salon06'
AND NOT EXISTS (SELECT 1 FROM oy1n_aiassignment_evaluations e WHERE e.submission=s.id);

SET FOREIGN_KEY_CHECKS = 1;

-- ══════════════════════════════════════════════════════════════
-- VERIFICACIÓN FINAL
-- ══════════════════════════════════════════════════════════════
SELECT 'MAESTROS' AS tipo, COUNT(*) AS total FROM oy1n_user WHERE username IN ('maestro01','maestro02','maestro03')
UNION ALL
SELECT 'ALUMNOS', COUNT(*) FROM oy1n_user WHERE username LIKE 'al%_s0%'
UNION ALL
SELECT 'CURSOS', COUNT(*) FROM oy1n_course WHERE shortname IN ('salon01','salon02','salon03','salon04','salon05','salon06')
UNION ALL
SELECT 'CONTEXTOS_CURSO', COUNT(*) FROM oy1n_context ctx
  JOIN oy1n_course c ON ctx.contextlevel=50 AND ctx.instanceid=c.id
  WHERE c.shortname IN ('salon01','salon02','salon03','salon04','salon05','salon06')
UNION ALL
SELECT 'MODULOS_CM', COUNT(*) FROM oy1n_course_modules cm
  INNER JOIN oy1n_modules m ON m.id=cm.module AND m.name='aiassignment'
  JOIN oy1n_course c ON c.id=cm.course
  WHERE c.shortname IN ('salon01','salon02','salon03','salon04','salon05','salon06')
UNION ALL
SELECT 'TAREAS', COUNT(*) FROM oy1n_aiassignment a
  JOIN oy1n_course c ON a.course=c.id WHERE c.shortname IN ('salon01','salon02','salon03','salon04','salon05','salon06')
UNION ALL
SELECT 'ENVIOS', COUNT(*) FROM oy1n_aiassignment_submissions s
  JOIN oy1n_user u ON s.userid=u.id WHERE u.username LIKE 'al%_s0%'
UNION ALL
SELECT 'EVALUACIONES', COUNT(*) FROM oy1n_aiassignment_evaluations e
  JOIN oy1n_aiassignment_submissions s ON e.submission=s.id
  JOIN oy1n_user u ON s.userid=u.id WHERE u.username LIKE 'al%_s0%';

SELECT c.shortname AS salon,
  COUNT(DISTINCT s.userid) AS alumnos,
  COUNT(s.id) AS envios,
  SUM(CASE WHEN e.similarity_score>=75 THEN 1 ELSE 0 END) AS plagio_alto,
  SUM(CASE WHEN e.similarity_score>=50 AND e.similarity_score<75 THEN 1 ELSE 0 END) AS sospechoso,
  SUM(CASE WHEN e.similarity_score<50 THEN 1 ELSE 0 END) AS original,
  ROUND(AVG(s.score),1) AS promedio
FROM oy1n_course c
JOIN oy1n_aiassignment a ON a.course=c.id
JOIN oy1n_aiassignment_submissions s ON s.assignment=a.id
JOIN oy1n_user u ON s.userid=u.id
LEFT JOIN oy1n_aiassignment_evaluations e ON e.submission=s.id
WHERE c.shortname IN ('salon01','salon02','salon03','salon04','salon05','salon06') AND u.username LIKE 'al%_s0%'
GROUP BY c.shortname
ORDER BY c.shortname;
