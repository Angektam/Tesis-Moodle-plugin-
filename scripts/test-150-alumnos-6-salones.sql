-- ============================================================
-- TEST MASIVO: 150 alumnos × 6 salones × 3 maestros
-- Generado por generar-150-alumnos.js
-- Prefijo: oy1n_ (Hostinger)
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
-- PASO 2: Crear 6 cursos (salones)
-- ══════════════════════════════════════════════════════════════
INSERT INTO oy1n_course (category,fullname,shortname,summary,format,startdate,timecreated,timemodified)
SELECT 1,'Programación I — Salón 1','salon01','Curso de prueba salón 1','topics',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM oy1n_course WHERE shortname='salon01');

INSERT INTO oy1n_course (category,fullname,shortname,summary,format,startdate,timecreated,timemodified)
SELECT 1,'Programación II — Salón 2','salon02','Curso de prueba salón 2','topics',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM oy1n_course WHERE shortname='salon02');

INSERT INTO oy1n_course (category,fullname,shortname,summary,format,startdate,timecreated,timemodified)
SELECT 1,'Estructuras de Datos — Salón 3','salon03','Curso de prueba salón 3','topics',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM oy1n_course WHERE shortname='salon03');

INSERT INTO oy1n_course (category,fullname,shortname,summary,format,startdate,timecreated,timemodified)
SELECT 1,'Algoritmos — Salón 4','salon04','Curso de prueba salón 4','topics',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM oy1n_course WHERE shortname='salon04');

INSERT INTO oy1n_course (category,fullname,shortname,summary,format,startdate,timecreated,timemodified)
SELECT 1,'Bases de Datos — Salón 5','salon05','Curso de prueba salón 5','topics',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM oy1n_course WHERE shortname='salon05');

INSERT INTO oy1n_course (category,fullname,shortname,summary,format,startdate,timecreated,timemodified)
SELECT 1,'Ingeniería de Software — Salón 6','salon06','Curso de prueba salón 6','topics',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM oy1n_course WHERE shortname='salon06');

-- ══════════════════════════════════════════════════════════════
-- PASO 3: Métodos de inscripción
-- ══════════════════════════════════════════════════════════════
INSERT INTO oy1n_enrol (enrol,status,courseid,sortorder,timecreated,timemodified)
SELECT 'manual',0,c.id,0,UNIX_TIMESTAMP(),UNIX_TIMESTAMP() FROM oy1n_course c
WHERE c.shortname='salon01' AND NOT EXISTS (SELECT 1 FROM oy1n_enrol e WHERE e.courseid=c.id AND e.enrol='manual');

INSERT INTO oy1n_enrol (enrol,status,courseid,sortorder,timecreated,timemodified)
SELECT 'manual',0,c.id,0,UNIX_TIMESTAMP(),UNIX_TIMESTAMP() FROM oy1n_course c
WHERE c.shortname='salon02' AND NOT EXISTS (SELECT 1 FROM oy1n_enrol e WHERE e.courseid=c.id AND e.enrol='manual');

INSERT INTO oy1n_enrol (enrol,status,courseid,sortorder,timecreated,timemodified)
SELECT 'manual',0,c.id,0,UNIX_TIMESTAMP(),UNIX_TIMESTAMP() FROM oy1n_course c
WHERE c.shortname='salon03' AND NOT EXISTS (SELECT 1 FROM oy1n_enrol e WHERE e.courseid=c.id AND e.enrol='manual');

INSERT INTO oy1n_enrol (enrol,status,courseid,sortorder,timecreated,timemodified)
SELECT 'manual',0,c.id,0,UNIX_TIMESTAMP(),UNIX_TIMESTAMP() FROM oy1n_course c
WHERE c.shortname='salon04' AND NOT EXISTS (SELECT 1 FROM oy1n_enrol e WHERE e.courseid=c.id AND e.enrol='manual');

INSERT INTO oy1n_enrol (enrol,status,courseid,sortorder,timecreated,timemodified)
SELECT 'manual',0,c.id,0,UNIX_TIMESTAMP(),UNIX_TIMESTAMP() FROM oy1n_course c
WHERE c.shortname='salon05' AND NOT EXISTS (SELECT 1 FROM oy1n_enrol e WHERE e.courseid=c.id AND e.enrol='manual');

INSERT INTO oy1n_enrol (enrol,status,courseid,sortorder,timecreated,timemodified)
SELECT 'manual',0,c.id,0,UNIX_TIMESTAMP(),UNIX_TIMESTAMP() FROM oy1n_course c
WHERE c.shortname='salon06' AND NOT EXISTS (SELECT 1 FROM oy1n_enrol e WHERE e.courseid=c.id AND e.enrol='manual');

-- ══════════════════════════════════════════════════════════════
-- PASO 4: Inscribir maestros a sus salones (2 salones por maestro)
-- ══════════════════════════════════════════════════════════════
INSERT INTO oy1n_user_enrolments (enrolid,userid,modifierid,timestart,timeend,status,timecreated,timemodified)
SELECT e.id,u.id,2,UNIX_TIMESTAMP(),0,0,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM oy1n_user u JOIN oy1n_enrol e ON e.courseid=(SELECT id FROM oy1n_course WHERE shortname='salon01' LIMIT 1) AND e.enrol='manual'
LEFT JOIN oy1n_user_enrolments ue ON ue.enrolid=e.id AND ue.userid=u.id
WHERE u.username='maestro01' AND ue.userid IS NULL;
INSERT INTO oy1n_role_assignments (roleid,contextid,userid,timemodified,modifierid,component,itemid)
SELECT r.id,ctx.id,u.id,UNIX_TIMESTAMP(),2,'',0
FROM oy1n_user u JOIN oy1n_role r ON r.shortname='editingteacher'
JOIN oy1n_context ctx ON ctx.contextlevel=50 AND ctx.instanceid=(SELECT id FROM oy1n_course WHERE shortname='salon01' LIMIT 1)
LEFT JOIN oy1n_role_assignments ra ON ra.roleid=r.id AND ra.contextid=ctx.id AND ra.userid=u.id
WHERE u.username='maestro01' AND ra.userid IS NULL;

INSERT INTO oy1n_user_enrolments (enrolid,userid,modifierid,timestart,timeend,status,timecreated,timemodified)
SELECT e.id,u.id,2,UNIX_TIMESTAMP(),0,0,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM oy1n_user u JOIN oy1n_enrol e ON e.courseid=(SELECT id FROM oy1n_course WHERE shortname='salon02' LIMIT 1) AND e.enrol='manual'
LEFT JOIN oy1n_user_enrolments ue ON ue.enrolid=e.id AND ue.userid=u.id
WHERE u.username='maestro01' AND ue.userid IS NULL;
INSERT INTO oy1n_role_assignments (roleid,contextid,userid,timemodified,modifierid,component,itemid)
SELECT r.id,ctx.id,u.id,UNIX_TIMESTAMP(),2,'',0
FROM oy1n_user u JOIN oy1n_role r ON r.shortname='editingteacher'
JOIN oy1n_context ctx ON ctx.contextlevel=50 AND ctx.instanceid=(SELECT id FROM oy1n_course WHERE shortname='salon02' LIMIT 1)
LEFT JOIN oy1n_role_assignments ra ON ra.roleid=r.id AND ra.contextid=ctx.id AND ra.userid=u.id
WHERE u.username='maestro01' AND ra.userid IS NULL;

INSERT INTO oy1n_user_enrolments (enrolid,userid,modifierid,timestart,timeend,status,timecreated,timemodified)
SELECT e.id,u.id,2,UNIX_TIMESTAMP(),0,0,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM oy1n_user u JOIN oy1n_enrol e ON e.courseid=(SELECT id FROM oy1n_course WHERE shortname='salon03' LIMIT 1) AND e.enrol='manual'
LEFT JOIN oy1n_user_enrolments ue ON ue.enrolid=e.id AND ue.userid=u.id
WHERE u.username='maestro02' AND ue.userid IS NULL;
INSERT INTO oy1n_role_assignments (roleid,contextid,userid,timemodified,modifierid,component,itemid)
SELECT r.id,ctx.id,u.id,UNIX_TIMESTAMP(),2,'',0
FROM oy1n_user u JOIN oy1n_role r ON r.shortname='editingteacher'
JOIN oy1n_context ctx ON ctx.contextlevel=50 AND ctx.instanceid=(SELECT id FROM oy1n_course WHERE shortname='salon03' LIMIT 1)
LEFT JOIN oy1n_role_assignments ra ON ra.roleid=r.id AND ra.contextid=ctx.id AND ra.userid=u.id
WHERE u.username='maestro02' AND ra.userid IS NULL;

INSERT INTO oy1n_user_enrolments (enrolid,userid,modifierid,timestart,timeend,status,timecreated,timemodified)
SELECT e.id,u.id,2,UNIX_TIMESTAMP(),0,0,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM oy1n_user u JOIN oy1n_enrol e ON e.courseid=(SELECT id FROM oy1n_course WHERE shortname='salon04' LIMIT 1) AND e.enrol='manual'
LEFT JOIN oy1n_user_enrolments ue ON ue.enrolid=e.id AND ue.userid=u.id
WHERE u.username='maestro02' AND ue.userid IS NULL;
INSERT INTO oy1n_role_assignments (roleid,contextid,userid,timemodified,modifierid,component,itemid)
SELECT r.id,ctx.id,u.id,UNIX_TIMESTAMP(),2,'',0
FROM oy1n_user u JOIN oy1n_role r ON r.shortname='editingteacher'
JOIN oy1n_context ctx ON ctx.contextlevel=50 AND ctx.instanceid=(SELECT id FROM oy1n_course WHERE shortname='salon04' LIMIT 1)
LEFT JOIN oy1n_role_assignments ra ON ra.roleid=r.id AND ra.contextid=ctx.id AND ra.userid=u.id
WHERE u.username='maestro02' AND ra.userid IS NULL;

INSERT INTO oy1n_user_enrolments (enrolid,userid,modifierid,timestart,timeend,status,timecreated,timemodified)
SELECT e.id,u.id,2,UNIX_TIMESTAMP(),0,0,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM oy1n_user u JOIN oy1n_enrol e ON e.courseid=(SELECT id FROM oy1n_course WHERE shortname='salon05' LIMIT 1) AND e.enrol='manual'
LEFT JOIN oy1n_user_enrolments ue ON ue.enrolid=e.id AND ue.userid=u.id
WHERE u.username='maestro03' AND ue.userid IS NULL;
INSERT INTO oy1n_role_assignments (roleid,contextid,userid,timemodified,modifierid,component,itemid)
SELECT r.id,ctx.id,u.id,UNIX_TIMESTAMP(),2,'',0
FROM oy1n_user u JOIN oy1n_role r ON r.shortname='editingteacher'
JOIN oy1n_context ctx ON ctx.contextlevel=50 AND ctx.instanceid=(SELECT id FROM oy1n_course WHERE shortname='salon05' LIMIT 1)
LEFT JOIN oy1n_role_assignments ra ON ra.roleid=r.id AND ra.contextid=ctx.id AND ra.userid=u.id
WHERE u.username='maestro03' AND ra.userid IS NULL;

INSERT INTO oy1n_user_enrolments (enrolid,userid,modifierid,timestart,timeend,status,timecreated,timemodified)
SELECT e.id,u.id,2,UNIX_TIMESTAMP(),0,0,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM oy1n_user u JOIN oy1n_enrol e ON e.courseid=(SELECT id FROM oy1n_course WHERE shortname='salon06' LIMIT 1) AND e.enrol='manual'
LEFT JOIN oy1n_user_enrolments ue ON ue.enrolid=e.id AND ue.userid=u.id
WHERE u.username='maestro03' AND ue.userid IS NULL;
INSERT INTO oy1n_role_assignments (roleid,contextid,userid,timemodified,modifierid,component,itemid)
SELECT r.id,ctx.id,u.id,UNIX_TIMESTAMP(),2,'',0
FROM oy1n_user u JOIN oy1n_role r ON r.shortname='editingteacher'
JOIN oy1n_context ctx ON ctx.contextlevel=50 AND ctx.instanceid=(SELECT id FROM oy1n_course WHERE shortname='salon06' LIMIT 1)
LEFT JOIN oy1n_role_assignments ra ON ra.roleid=r.id AND ra.contextid=ctx.id AND ra.userid=u.id
WHERE u.username='maestro03' AND ra.userid IS NULL;

-- ══════════════════════════════════════════════════════════════
-- PASO 5: Crear 150 alumnos (25 por salón)
-- ══════════════════════════════════════════════════════════════
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al01_s01','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Carlos','García','al01_s01@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al01_s01');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al02_s01','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','María','López','al02_s01@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al02_s01');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al03_s01','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Pedro','Martínez','al03_s01@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al03_s01');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al04_s01','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Ana','Rodríguez','al04_s01@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al04_s01');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al05_s01','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Luis','Hernández','al05_s01@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al05_s01');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al06_s01','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Sofía','Jiménez','al06_s01@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al06_s01');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al07_s01','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Diego','Torres','al07_s01@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al07_s01');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al08_s01','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Valentina','Flores','al08_s01@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al08_s01');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al09_s01','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Andrés','Vargas','al09_s01@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al09_s01');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al10_s01','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Camila','Reyes','al10_s01@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al10_s01');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al11_s01','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Sebastián','Cruz','al11_s01@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al11_s01');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al12_s01','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Isabella','Morales','al12_s01@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al12_s01');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al13_s01','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Mateo','Ortiz','al13_s01@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al13_s01');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al14_s01','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Lucía','Mendoza','al14_s01@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al14_s01');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al15_s01','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Nicolás','Castillo','al15_s01@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al15_s01');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al16_s01','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Gabriela','Ramos','al16_s01@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al16_s01');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al17_s01','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Felipe','Gutiérrez','al17_s01@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al17_s01');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al18_s01','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Daniela','Sánchez','al18_s01@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al18_s01');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al19_s01','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Tomás','Ramírez','al19_s01@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al19_s01');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al20_s01','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Valeria','Núñez','al20_s01@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al20_s01');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al21_s01','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Emilio','Peña','al21_s01@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al21_s01');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al22_s01','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Renata','Aguilar','al22_s01@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al22_s01');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al23_s01','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Joaquín','Medina','al23_s01@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al23_s01');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al24_s01','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Mariana','Vega','al24_s01@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al24_s01');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al25_s01','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Rodrigo','Herrera','al25_s01@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al25_s01');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al01_s02','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Natalia','Ríos','al01_s02@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al01_s02');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al02_s02','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Alejandro','Mora','al02_s02@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al02_s02');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al03_s02','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Paula','Delgado','al03_s02@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al03_s02');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al04_s02','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Ignacio','Fuentes','al04_s02@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al04_s02');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al05_s02','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Catalina','Espinoza','al05_s02@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al05_s02');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al06_s02','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Fernando','Salazar','al06_s02@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al06_s02');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al07_s02','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Elena','Rojas','al07_s02@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al07_s02');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al08_s02','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Ricardo','Navarro','al08_s02@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al08_s02');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al09_s02','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Mónica','Guerrero','al09_s02@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al09_s02');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al10_s02','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Héctor','Campos','al10_s02@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al10_s02');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al11_s02','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Adriana','Molina','al11_s02@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al11_s02');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al12_s02','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Óscar','Domínguez','al12_s02@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al12_s02');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al13_s02','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Fernanda','Suárez','al13_s02@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al13_s02');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al14_s02','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Raúl','Romero','al14_s02@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al14_s02');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al15_s02','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Lorena','Díaz','al15_s02@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al15_s02');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al16_s02','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Arturo','Acosta','al16_s02@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al16_s02');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al17_s02','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Claudia','Bravo','al17_s02@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al17_s02');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al18_s02','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Enrique','Cabrera','al18_s02@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al18_s02');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al19_s02','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Patricia','Calderón','al19_s02@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al19_s02');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al20_s02','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Gerardo','Carrillo','al20_s02@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al20_s02');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al21_s02','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Verónica','Cervantes','al21_s02@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al21_s02');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al22_s02','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Alberto','Contreras','al22_s02@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al22_s02');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al23_s02','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Silvia','Córdoba','al23_s02@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al23_s02');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al24_s02','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Javier','Cortés','al24_s02@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al24_s02');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al25_s02','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Teresa','Duarte','al25_s02@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al25_s02');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al01_s03','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Manuel','García','al01_s03@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al01_s03');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al02_s03','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Rosa','López','al02_s03@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al02_s03');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al03_s03','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Francisco','Martínez','al03_s03@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al03_s03');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al04_s03','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Carmen','Rodríguez','al04_s03@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al04_s03');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al05_s03','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Eduardo','Hernández','al05_s03@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al05_s03');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al06_s03','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Alicia','Jiménez','al06_s03@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al06_s03');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al07_s03','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Roberto','Torres','al07_s03@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al07_s03');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al08_s03','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Beatriz','Flores','al08_s03@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al08_s03');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al09_s03','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Alfredo','Vargas','al09_s03@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al09_s03');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al10_s03','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Gloria','Reyes','al10_s03@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al10_s03');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al11_s03','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Gustavo','Cruz','al11_s03@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al11_s03');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al12_s03','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Irene','Morales','al12_s03@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al12_s03');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al13_s03','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Sergio','Ortiz','al13_s03@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al13_s03');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al14_s03','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Pilar','Mendoza','al14_s03@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al14_s03');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al15_s03','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Ramón','Castillo','al15_s03@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al15_s03');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al16_s03','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Cristina','Ramos','al16_s03@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al16_s03');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al17_s03','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Víctor','Gutiérrez','al17_s03@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al17_s03');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al18_s03','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Laura','Sánchez','al18_s03@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al18_s03');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al19_s03','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Ernesto','Ramírez','al19_s03@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al19_s03');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al20_s03','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Sandra','Núñez','al20_s03@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al20_s03');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al21_s03','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Armando','Peña','al21_s03@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al21_s03');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al22_s03','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Leticia','Aguilar','al22_s03@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al22_s03');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al23_s03','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Rubén','Medina','al23_s03@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al23_s03');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al24_s03','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Norma','Vega','al24_s03@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al24_s03');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al25_s03','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Ángel','Herrera','al25_s03@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al25_s03');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al01_s04','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Estela','Ríos','al01_s04@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al01_s04');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al02_s04','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','César','Mora','al02_s04@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al02_s04');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al03_s04','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Yolanda','Delgado','al03_s04@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al03_s04');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al04_s04','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Hugo','Fuentes','al04_s04@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al04_s04');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al05_s04','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Martha','Espinoza','al05_s04@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al05_s04');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al06_s04','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Iván','Salazar','al06_s04@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al06_s04');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al07_s04','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Rocío','Rojas','al07_s04@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al07_s04');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al08_s04','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Julio','Navarro','al08_s04@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al08_s04');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al09_s04','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Graciela','Guerrero','al09_s04@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al09_s04');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al10_s04','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Miguel','Campos','al10_s04@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al10_s04');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al11_s04','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Elisa','Molina','al11_s04@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al11_s04');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al12_s04','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Rafael','Domínguez','al12_s04@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al12_s04');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al13_s04','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Josefina','Suárez','al13_s04@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al13_s04');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al14_s04','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Guillermo','Romero','al14_s04@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al14_s04');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al15_s04','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Esperanza','Díaz','al15_s04@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al15_s04');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al16_s04','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Martín','Acosta','al16_s04@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al16_s04');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al17_s04','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Olivia','Bravo','al17_s04@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al17_s04');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al18_s04','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Esteban','Cabrera','al18_s04@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al18_s04');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al19_s04','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Jimena','Calderón','al19_s04@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al19_s04');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al20_s04','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Damián','Carrillo','al20_s04@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al20_s04');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al21_s04','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Abril','Cervantes','al21_s04@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al21_s04');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al22_s04','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Maximiliano','Contreras','al22_s04@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al22_s04');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al23_s04','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Florencia','Córdoba','al23_s04@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al23_s04');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al24_s04','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Santiago','Cortés','al24_s04@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al24_s04');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al25_s04','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Agustina','Duarte','al25_s04@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al25_s04');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al01_s05','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Carlos','García','al01_s05@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al01_s05');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al02_s05','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','María','López','al02_s05@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al02_s05');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al03_s05','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Pedro','Martínez','al03_s05@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al03_s05');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al04_s05','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Ana','Rodríguez','al04_s05@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al04_s05');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al05_s05','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Luis','Hernández','al05_s05@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al05_s05');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al06_s05','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Sofía','Jiménez','al06_s05@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al06_s05');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al07_s05','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Diego','Torres','al07_s05@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al07_s05');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al08_s05','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Valentina','Flores','al08_s05@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al08_s05');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al09_s05','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Andrés','Vargas','al09_s05@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al09_s05');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al10_s05','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Camila','Reyes','al10_s05@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al10_s05');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al11_s05','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Sebastián','Cruz','al11_s05@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al11_s05');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al12_s05','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Isabella','Morales','al12_s05@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al12_s05');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al13_s05','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Mateo','Ortiz','al13_s05@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al13_s05');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al14_s05','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Lucía','Mendoza','al14_s05@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al14_s05');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al15_s05','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Nicolás','Castillo','al15_s05@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al15_s05');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al16_s05','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Gabriela','Ramos','al16_s05@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al16_s05');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al17_s05','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Felipe','Gutiérrez','al17_s05@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al17_s05');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al18_s05','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Daniela','Sánchez','al18_s05@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al18_s05');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al19_s05','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Tomás','Ramírez','al19_s05@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al19_s05');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al20_s05','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Valeria','Núñez','al20_s05@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al20_s05');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al21_s05','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Emilio','Peña','al21_s05@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al21_s05');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al22_s05','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Renata','Aguilar','al22_s05@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al22_s05');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al23_s05','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Joaquín','Medina','al23_s05@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al23_s05');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al24_s05','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Mariana','Vega','al24_s05@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al24_s05');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al25_s05','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Rodrigo','Herrera','al25_s05@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al25_s05');

INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al01_s06','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Natalia','Ríos','al01_s06@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al01_s06');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al02_s06','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Alejandro','Mora','al02_s06@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al02_s06');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al03_s06','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Paula','Delgado','al03_s06@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al03_s06');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al04_s06','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Ignacio','Fuentes','al04_s06@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al04_s06');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al05_s06','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Catalina','Espinoza','al05_s06@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al05_s06');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al06_s06','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Fernando','Salazar','al06_s06@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al06_s06');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al07_s06','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Elena','Rojas','al07_s06@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al07_s06');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al08_s06','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Ricardo','Navarro','al08_s06@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al08_s06');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al09_s06','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Mónica','Guerrero','al09_s06@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al09_s06');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al10_s06','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Héctor','Campos','al10_s06@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al10_s06');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al11_s06','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Adriana','Molina','al11_s06@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al11_s06');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al12_s06','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Óscar','Domínguez','al12_s06@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al12_s06');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al13_s06','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Fernanda','Suárez','al13_s06@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al13_s06');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al14_s06','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Raúl','Romero','al14_s06@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al14_s06');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al15_s06','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Lorena','Díaz','al15_s06@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al15_s06');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al16_s06','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Arturo','Acosta','al16_s06@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al16_s06');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al17_s06','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Claudia','Bravo','al17_s06@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al17_s06');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al18_s06','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Enrique','Cabrera','al18_s06@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al18_s06');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al19_s06','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Patricia','Calderón','al19_s06@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al19_s06');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al20_s06','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Gerardo','Carrillo','al20_s06@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al20_s06');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al21_s06','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Verónica','Cervantes','al21_s06@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al21_s06');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al22_s06','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Alberto','Contreras','al22_s06@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al22_s06');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al23_s06','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Silvia','Córdoba','al23_s06@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al23_s06');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al24_s06','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Javier','Cortés','al24_s06@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al24_s06');
INSERT INTO oy1n_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'al25_s06','$2y$12$Rq2H7sSZ/5ynE/747cAxieCBTav0F7vuiKgLNxV2C7nlpzTMZLJ8u','Teresa','Duarte','al25_s06@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM oy1n_user WHERE username='al25_s06');

-- ══════════════════════════════════════════════════════════════
-- PASO 6: Inscribir alumnos a sus salones
-- ══════════════════════════════════════════════════════════════
INSERT INTO oy1n_user_enrolments (enrolid,userid,modifierid,timestart,timeend,status,timecreated,timemodified)
SELECT e.id,u.id,2,UNIX_TIMESTAMP(),0,0,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM oy1n_user u JOIN oy1n_enrol e ON e.courseid=(SELECT id FROM oy1n_course WHERE shortname='salon01' LIMIT 1) AND e.enrol='manual'
LEFT JOIN oy1n_user_enrolments ue ON ue.enrolid=e.id AND ue.userid=u.id
WHERE u.username IN ('al01_s01','al02_s01','al03_s01','al04_s01','al05_s01','al06_s01','al07_s01','al08_s01','al09_s01','al10_s01','al11_s01','al12_s01','al13_s01','al14_s01','al15_s01','al16_s01','al17_s01','al18_s01','al19_s01','al20_s01','al21_s01','al22_s01','al23_s01','al24_s01','al25_s01') AND ue.userid IS NULL;
INSERT INTO oy1n_role_assignments (roleid,contextid,userid,timemodified,modifierid,component,itemid)
SELECT r.id,ctx.id,u.id,UNIX_TIMESTAMP(),2,'',0
FROM oy1n_user u JOIN oy1n_role r ON r.shortname='student'
JOIN oy1n_context ctx ON ctx.contextlevel=50 AND ctx.instanceid=(SELECT id FROM oy1n_course WHERE shortname='salon01' LIMIT 1)
LEFT JOIN oy1n_role_assignments ra ON ra.roleid=r.id AND ra.contextid=ctx.id AND ra.userid=u.id
WHERE u.username IN ('al01_s01','al02_s01','al03_s01','al04_s01','al05_s01','al06_s01','al07_s01','al08_s01','al09_s01','al10_s01','al11_s01','al12_s01','al13_s01','al14_s01','al15_s01','al16_s01','al17_s01','al18_s01','al19_s01','al20_s01','al21_s01','al22_s01','al23_s01','al24_s01','al25_s01') AND ra.userid IS NULL;

INSERT INTO oy1n_user_enrolments (enrolid,userid,modifierid,timestart,timeend,status,timecreated,timemodified)
SELECT e.id,u.id,2,UNIX_TIMESTAMP(),0,0,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM oy1n_user u JOIN oy1n_enrol e ON e.courseid=(SELECT id FROM oy1n_course WHERE shortname='salon02' LIMIT 1) AND e.enrol='manual'
LEFT JOIN oy1n_user_enrolments ue ON ue.enrolid=e.id AND ue.userid=u.id
WHERE u.username IN ('al01_s02','al02_s02','al03_s02','al04_s02','al05_s02','al06_s02','al07_s02','al08_s02','al09_s02','al10_s02','al11_s02','al12_s02','al13_s02','al14_s02','al15_s02','al16_s02','al17_s02','al18_s02','al19_s02','al20_s02','al21_s02','al22_s02','al23_s02','al24_s02','al25_s02') AND ue.userid IS NULL;
INSERT INTO oy1n_role_assignments (roleid,contextid,userid,timemodified,modifierid,component,itemid)
SELECT r.id,ctx.id,u.id,UNIX_TIMESTAMP(),2,'',0
FROM oy1n_user u JOIN oy1n_role r ON r.shortname='student'
JOIN oy1n_context ctx ON ctx.contextlevel=50 AND ctx.instanceid=(SELECT id FROM oy1n_course WHERE shortname='salon02' LIMIT 1)
LEFT JOIN oy1n_role_assignments ra ON ra.roleid=r.id AND ra.contextid=ctx.id AND ra.userid=u.id
WHERE u.username IN ('al01_s02','al02_s02','al03_s02','al04_s02','al05_s02','al06_s02','al07_s02','al08_s02','al09_s02','al10_s02','al11_s02','al12_s02','al13_s02','al14_s02','al15_s02','al16_s02','al17_s02','al18_s02','al19_s02','al20_s02','al21_s02','al22_s02','al23_s02','al24_s02','al25_s02') AND ra.userid IS NULL;

INSERT INTO oy1n_user_enrolments (enrolid,userid,modifierid,timestart,timeend,status,timecreated,timemodified)
SELECT e.id,u.id,2,UNIX_TIMESTAMP(),0,0,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM oy1n_user u JOIN oy1n_enrol e ON e.courseid=(SELECT id FROM oy1n_course WHERE shortname='salon03' LIMIT 1) AND e.enrol='manual'
LEFT JOIN oy1n_user_enrolments ue ON ue.enrolid=e.id AND ue.userid=u.id
WHERE u.username IN ('al01_s03','al02_s03','al03_s03','al04_s03','al05_s03','al06_s03','al07_s03','al08_s03','al09_s03','al10_s03','al11_s03','al12_s03','al13_s03','al14_s03','al15_s03','al16_s03','al17_s03','al18_s03','al19_s03','al20_s03','al21_s03','al22_s03','al23_s03','al24_s03','al25_s03') AND ue.userid IS NULL;
INSERT INTO oy1n_role_assignments (roleid,contextid,userid,timemodified,modifierid,component,itemid)
SELECT r.id,ctx.id,u.id,UNIX_TIMESTAMP(),2,'',0
FROM oy1n_user u JOIN oy1n_role r ON r.shortname='student'
JOIN oy1n_context ctx ON ctx.contextlevel=50 AND ctx.instanceid=(SELECT id FROM oy1n_course WHERE shortname='salon03' LIMIT 1)
LEFT JOIN oy1n_role_assignments ra ON ra.roleid=r.id AND ra.contextid=ctx.id AND ra.userid=u.id
WHERE u.username IN ('al01_s03','al02_s03','al03_s03','al04_s03','al05_s03','al06_s03','al07_s03','al08_s03','al09_s03','al10_s03','al11_s03','al12_s03','al13_s03','al14_s03','al15_s03','al16_s03','al17_s03','al18_s03','al19_s03','al20_s03','al21_s03','al22_s03','al23_s03','al24_s03','al25_s03') AND ra.userid IS NULL;

INSERT INTO oy1n_user_enrolments (enrolid,userid,modifierid,timestart,timeend,status,timecreated,timemodified)
SELECT e.id,u.id,2,UNIX_TIMESTAMP(),0,0,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM oy1n_user u JOIN oy1n_enrol e ON e.courseid=(SELECT id FROM oy1n_course WHERE shortname='salon04' LIMIT 1) AND e.enrol='manual'
LEFT JOIN oy1n_user_enrolments ue ON ue.enrolid=e.id AND ue.userid=u.id
WHERE u.username IN ('al01_s04','al02_s04','al03_s04','al04_s04','al05_s04','al06_s04','al07_s04','al08_s04','al09_s04','al10_s04','al11_s04','al12_s04','al13_s04','al14_s04','al15_s04','al16_s04','al17_s04','al18_s04','al19_s04','al20_s04','al21_s04','al22_s04','al23_s04','al24_s04','al25_s04') AND ue.userid IS NULL;
INSERT INTO oy1n_role_assignments (roleid,contextid,userid,timemodified,modifierid,component,itemid)
SELECT r.id,ctx.id,u.id,UNIX_TIMESTAMP(),2,'',0
FROM oy1n_user u JOIN oy1n_role r ON r.shortname='student'
JOIN oy1n_context ctx ON ctx.contextlevel=50 AND ctx.instanceid=(SELECT id FROM oy1n_course WHERE shortname='salon04' LIMIT 1)
LEFT JOIN oy1n_role_assignments ra ON ra.roleid=r.id AND ra.contextid=ctx.id AND ra.userid=u.id
WHERE u.username IN ('al01_s04','al02_s04','al03_s04','al04_s04','al05_s04','al06_s04','al07_s04','al08_s04','al09_s04','al10_s04','al11_s04','al12_s04','al13_s04','al14_s04','al15_s04','al16_s04','al17_s04','al18_s04','al19_s04','al20_s04','al21_s04','al22_s04','al23_s04','al24_s04','al25_s04') AND ra.userid IS NULL;

INSERT INTO oy1n_user_enrolments (enrolid,userid,modifierid,timestart,timeend,status,timecreated,timemodified)
SELECT e.id,u.id,2,UNIX_TIMESTAMP(),0,0,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM oy1n_user u JOIN oy1n_enrol e ON e.courseid=(SELECT id FROM oy1n_course WHERE shortname='salon05' LIMIT 1) AND e.enrol='manual'
LEFT JOIN oy1n_user_enrolments ue ON ue.enrolid=e.id AND ue.userid=u.id
WHERE u.username IN ('al01_s05','al02_s05','al03_s05','al04_s05','al05_s05','al06_s05','al07_s05','al08_s05','al09_s05','al10_s05','al11_s05','al12_s05','al13_s05','al14_s05','al15_s05','al16_s05','al17_s05','al18_s05','al19_s05','al20_s05','al21_s05','al22_s05','al23_s05','al24_s05','al25_s05') AND ue.userid IS NULL;
INSERT INTO oy1n_role_assignments (roleid,contextid,userid,timemodified,modifierid,component,itemid)
SELECT r.id,ctx.id,u.id,UNIX_TIMESTAMP(),2,'',0
FROM oy1n_user u JOIN oy1n_role r ON r.shortname='student'
JOIN oy1n_context ctx ON ctx.contextlevel=50 AND ctx.instanceid=(SELECT id FROM oy1n_course WHERE shortname='salon05' LIMIT 1)
LEFT JOIN oy1n_role_assignments ra ON ra.roleid=r.id AND ra.contextid=ctx.id AND ra.userid=u.id
WHERE u.username IN ('al01_s05','al02_s05','al03_s05','al04_s05','al05_s05','al06_s05','al07_s05','al08_s05','al09_s05','al10_s05','al11_s05','al12_s05','al13_s05','al14_s05','al15_s05','al16_s05','al17_s05','al18_s05','al19_s05','al20_s05','al21_s05','al22_s05','al23_s05','al24_s05','al25_s05') AND ra.userid IS NULL;

INSERT INTO oy1n_user_enrolments (enrolid,userid,modifierid,timestart,timeend,status,timecreated,timemodified)
SELECT e.id,u.id,2,UNIX_TIMESTAMP(),0,0,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM oy1n_user u JOIN oy1n_enrol e ON e.courseid=(SELECT id FROM oy1n_course WHERE shortname='salon06' LIMIT 1) AND e.enrol='manual'
LEFT JOIN oy1n_user_enrolments ue ON ue.enrolid=e.id AND ue.userid=u.id
WHERE u.username IN ('al01_s06','al02_s06','al03_s06','al04_s06','al05_s06','al06_s06','al07_s06','al08_s06','al09_s06','al10_s06','al11_s06','al12_s06','al13_s06','al14_s06','al15_s06','al16_s06','al17_s06','al18_s06','al19_s06','al20_s06','al21_s06','al22_s06','al23_s06','al24_s06','al25_s06') AND ue.userid IS NULL;
INSERT INTO oy1n_role_assignments (roleid,contextid,userid,timemodified,modifierid,component,itemid)
SELECT r.id,ctx.id,u.id,UNIX_TIMESTAMP(),2,'',0
FROM oy1n_user u JOIN oy1n_role r ON r.shortname='student'
JOIN oy1n_context ctx ON ctx.contextlevel=50 AND ctx.instanceid=(SELECT id FROM oy1n_course WHERE shortname='salon06' LIMIT 1)
LEFT JOIN oy1n_role_assignments ra ON ra.roleid=r.id AND ra.contextid=ctx.id AND ra.userid=u.id
WHERE u.username IN ('al01_s06','al02_s06','al03_s06','al04_s06','al05_s06','al06_s06','al07_s06','al08_s06','al09_s06','al10_s06','al11_s06','al12_s06','al13_s06','al14_s06','al15_s06','al16_s06','al17_s06','al18_s06','al19_s06','al20_s06','al21_s06','al22_s06','al23_s06','al24_s06','al25_s06') AND ra.userid IS NULL;

-- ══════════════════════════════════════════════════════════════
-- PASO 7: Crear 2 tareas por salón (12 tareas total)
-- ══════════════════════════════════════════════════════════════
INSERT INTO oy1n_aiassignment (course,teacher_id,name,intro,introformat,description,type,solution,grade,maxattempts,timecreated,timemodified)
SELECT c.id,(SELECT id FROM oy1n_user WHERE username='maestro01' LIMIT 1),
'Factorial recursivo — Salón 1','Implementa el algoritmo en Python',0,'Tarea de programación salón 1','programming','def factorial(n):\n    if n<=1: return 1\n    return n*factorial(n-1)',100,0,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM oy1n_course c WHERE c.shortname='salon01'
AND NOT EXISTS (SELECT 1 FROM oy1n_aiassignment WHERE name='Factorial recursivo — Salón 1' AND course=c.id);

INSERT INTO oy1n_aiassignment (course,teacher_id,name,intro,introformat,description,type,solution,grade,maxattempts,timecreated,timemodified)
SELECT c.id,(SELECT id FROM oy1n_user WHERE username='maestro01' LIMIT 1),
'Algoritmo de ordenamiento — Salón 1','Implementa el algoritmo en Python',0,'Tarea de programación salón 1','programming','def bubble_sort(arr):\n    n=len(arr)\n    for i in range(n):\n        for j in range(n-i-1):\n            if arr[j]>arr[j+1]: arr[j],arr[j+1]=arr[j+1],arr[j]\n    return arr',100,0,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM oy1n_course c WHERE c.shortname='salon01'
AND NOT EXISTS (SELECT 1 FROM oy1n_aiassignment WHERE name='Algoritmo de ordenamiento — Salón 1' AND course=c.id);

INSERT INTO oy1n_aiassignment (course,teacher_id,name,intro,introformat,description,type,solution,grade,maxattempts,timecreated,timemodified)
SELECT c.id,(SELECT id FROM oy1n_user WHERE username='maestro01' LIMIT 1),
'Factorial recursivo — Salón 2','Implementa el algoritmo en Python',0,'Tarea de programación salón 2','programming','def factorial(n):\n    if n<=1: return 1\n    return n*factorial(n-1)',100,0,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM oy1n_course c WHERE c.shortname='salon02'
AND NOT EXISTS (SELECT 1 FROM oy1n_aiassignment WHERE name='Factorial recursivo — Salón 2' AND course=c.id);

INSERT INTO oy1n_aiassignment (course,teacher_id,name,intro,introformat,description,type,solution,grade,maxattempts,timecreated,timemodified)
SELECT c.id,(SELECT id FROM oy1n_user WHERE username='maestro01' LIMIT 1),
'Algoritmo de ordenamiento — Salón 2','Implementa el algoritmo en Python',0,'Tarea de programación salón 2','programming','def bubble_sort(arr):\n    n=len(arr)\n    for i in range(n):\n        for j in range(n-i-1):\n            if arr[j]>arr[j+1]: arr[j],arr[j+1]=arr[j+1],arr[j]\n    return arr',100,0,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM oy1n_course c WHERE c.shortname='salon02'
AND NOT EXISTS (SELECT 1 FROM oy1n_aiassignment WHERE name='Algoritmo de ordenamiento — Salón 2' AND course=c.id);

INSERT INTO oy1n_aiassignment (course,teacher_id,name,intro,introformat,description,type,solution,grade,maxattempts,timecreated,timemodified)
SELECT c.id,(SELECT id FROM oy1n_user WHERE username='maestro02' LIMIT 1),
'Factorial recursivo — Salón 3','Implementa el algoritmo en Python',0,'Tarea de programación salón 3','programming','def factorial(n):\n    if n<=1: return 1\n    return n*factorial(n-1)',100,0,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM oy1n_course c WHERE c.shortname='salon03'
AND NOT EXISTS (SELECT 1 FROM oy1n_aiassignment WHERE name='Factorial recursivo — Salón 3' AND course=c.id);

INSERT INTO oy1n_aiassignment (course,teacher_id,name,intro,introformat,description,type,solution,grade,maxattempts,timecreated,timemodified)
SELECT c.id,(SELECT id FROM oy1n_user WHERE username='maestro02' LIMIT 1),
'Algoritmo de ordenamiento — Salón 3','Implementa el algoritmo en Python',0,'Tarea de programación salón 3','programming','def bubble_sort(arr):\n    n=len(arr)\n    for i in range(n):\n        for j in range(n-i-1):\n            if arr[j]>arr[j+1]: arr[j],arr[j+1]=arr[j+1],arr[j]\n    return arr',100,0,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM oy1n_course c WHERE c.shortname='salon03'
AND NOT EXISTS (SELECT 1 FROM oy1n_aiassignment WHERE name='Algoritmo de ordenamiento — Salón 3' AND course=c.id);

INSERT INTO oy1n_aiassignment (course,teacher_id,name,intro,introformat,description,type,solution,grade,maxattempts,timecreated,timemodified)
SELECT c.id,(SELECT id FROM oy1n_user WHERE username='maestro02' LIMIT 1),
'Factorial recursivo — Salón 4','Implementa el algoritmo en Python',0,'Tarea de programación salón 4','programming','def factorial(n):\n    if n<=1: return 1\n    return n*factorial(n-1)',100,0,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM oy1n_course c WHERE c.shortname='salon04'
AND NOT EXISTS (SELECT 1 FROM oy1n_aiassignment WHERE name='Factorial recursivo — Salón 4' AND course=c.id);

INSERT INTO oy1n_aiassignment (course,teacher_id,name,intro,introformat,description,type,solution,grade,maxattempts,timecreated,timemodified)
SELECT c.id,(SELECT id FROM oy1n_user WHERE username='maestro02' LIMIT 1),
'Algoritmo de ordenamiento — Salón 4','Implementa el algoritmo en Python',0,'Tarea de programación salón 4','programming','def bubble_sort(arr):\n    n=len(arr)\n    for i in range(n):\n        for j in range(n-i-1):\n            if arr[j]>arr[j+1]: arr[j],arr[j+1]=arr[j+1],arr[j]\n    return arr',100,0,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM oy1n_course c WHERE c.shortname='salon04'
AND NOT EXISTS (SELECT 1 FROM oy1n_aiassignment WHERE name='Algoritmo de ordenamiento — Salón 4' AND course=c.id);

INSERT INTO oy1n_aiassignment (course,teacher_id,name,intro,introformat,description,type,solution,grade,maxattempts,timecreated,timemodified)
SELECT c.id,(SELECT id FROM oy1n_user WHERE username='maestro03' LIMIT 1),
'Factorial recursivo — Salón 5','Implementa el algoritmo en Python',0,'Tarea de programación salón 5','programming','def factorial(n):\n    if n<=1: return 1\n    return n*factorial(n-1)',100,0,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM oy1n_course c WHERE c.shortname='salon05'
AND NOT EXISTS (SELECT 1 FROM oy1n_aiassignment WHERE name='Factorial recursivo — Salón 5' AND course=c.id);

INSERT INTO oy1n_aiassignment (course,teacher_id,name,intro,introformat,description,type,solution,grade,maxattempts,timecreated,timemodified)
SELECT c.id,(SELECT id FROM oy1n_user WHERE username='maestro03' LIMIT 1),
'Algoritmo de ordenamiento — Salón 5','Implementa el algoritmo en Python',0,'Tarea de programación salón 5','programming','def bubble_sort(arr):\n    n=len(arr)\n    for i in range(n):\n        for j in range(n-i-1):\n            if arr[j]>arr[j+1]: arr[j],arr[j+1]=arr[j+1],arr[j]\n    return arr',100,0,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM oy1n_course c WHERE c.shortname='salon05'
AND NOT EXISTS (SELECT 1 FROM oy1n_aiassignment WHERE name='Algoritmo de ordenamiento — Salón 5' AND course=c.id);

INSERT INTO oy1n_aiassignment (course,teacher_id,name,intro,introformat,description,type,solution,grade,maxattempts,timecreated,timemodified)
SELECT c.id,(SELECT id FROM oy1n_user WHERE username='maestro03' LIMIT 1),
'Factorial recursivo — Salón 6','Implementa el algoritmo en Python',0,'Tarea de programación salón 6','programming','def factorial(n):\n    if n<=1: return 1\n    return n*factorial(n-1)',100,0,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM oy1n_course c WHERE c.shortname='salon06'
AND NOT EXISTS (SELECT 1 FROM oy1n_aiassignment WHERE name='Factorial recursivo — Salón 6' AND course=c.id);

INSERT INTO oy1n_aiassignment (course,teacher_id,name,intro,introformat,description,type,solution,grade,maxattempts,timecreated,timemodified)
SELECT c.id,(SELECT id FROM oy1n_user WHERE username='maestro03' LIMIT 1),
'Algoritmo de ordenamiento — Salón 6','Implementa el algoritmo en Python',0,'Tarea de programación salón 6','programming','def bubble_sort(arr):\n    n=len(arr)\n    for i in range(n):\n        for j in range(n-i-1):\n            if arr[j]>arr[j+1]: arr[j],arr[j+1]=arr[j+1],arr[j]\n    return arr',100,0,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()
FROM oy1n_course c WHERE c.shortname='salon06'
AND NOT EXISTS (SELECT 1 FROM oy1n_aiassignment WHERE name='Algoritmo de ordenamiento — Salón 6' AND course=c.id);

-- ══════════════════════════════════════════════════════════════
-- PASO 8: Limpiar envíos previos de estos alumnos
-- ══════════════════════════════════════════════════════════════
DELETE ev FROM oy1n_aiassignment_evaluations ev
INNER JOIN oy1n_aiassignment_submissions s ON ev.submission=s.id
INNER JOIN oy1n_user u ON s.userid=u.id
WHERE u.username LIKE 'al%_s0%';

DELETE s FROM oy1n_aiassignment_submissions s
INNER JOIN oy1n_user u ON s.userid=u.id
WHERE u.username LIKE 'al%_s0%';

-- ══════════════════════════════════════════════════════════════
-- PASO 9: Insertar envíos (300 total — 2 por alumno)
-- ══════════════════════════════════════════════════════════════
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_0(n):
    if n <= 1:
        return 1
    return n * factorial_0(n - 1)

print(factorial_0(5))','evaluated',70.00,'ORIGINAL: salón 1 alumno 1',1,UNIX_TIMESTAMP()-1117938,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al01_s01'
WHERE c.shortname='salon01' AND a.name='Factorial recursivo — Salón 1';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_1(num):
    if num <= 1:
        return 1
    return num * calc_fact_1(num - 1)

print(calc_fact_1(5))','evaluated',71.00,'PLAGIO: salón 1 alumno 2',1,UNIX_TIMESTAMP()-861953,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al02_s01'
WHERE c.shortname='salon01' AND a.name='Factorial recursivo — Salón 1';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_2(num):
    if num <= 1:
        return 1
    return num * calc_fact_2(num - 1)

print(calc_fact_2(5))','evaluated',72.00,'PLAGIO: salón 1 alumno 3',1,UNIX_TIMESTAMP()-754527,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al03_s01'
WHERE c.shortname='salon01' AND a.name='Factorial recursivo — Salón 1';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_3(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_3(5))','evaluated',73.00,'SOSPECHOSO: salón 1 alumno 4',1,UNIX_TIMESTAMP()-1013273,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al04_s01'
WHERE c.shortname='salon01' AND a.name='Factorial recursivo — Salón 1';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_4(n):
    if n <= 1:
        return 1
    return n * factorial_4(n - 1)

print(factorial_4(5))','evaluated',74.00,'ORIGINAL: salón 1 alumno 5',1,UNIX_TIMESTAMP()-1142678,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al05_s01'
WHERE c.shortname='salon01' AND a.name='Factorial recursivo — Salón 1';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_5(n):
    if n <= 1:
        return 1
    return n * factorial_5(n - 1)

print(factorial_5(5))','evaluated',75.00,'ORIGINAL: salón 1 alumno 6',1,UNIX_TIMESTAMP()-434593,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al06_s01'
WHERE c.shortname='salon01' AND a.name='Factorial recursivo — Salón 1';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_6(num):
    if num <= 1:
        return 1
    return num * calc_fact_6(num - 1)

print(calc_fact_6(5))','evaluated',76.00,'PLAGIO: salón 1 alumno 7',1,UNIX_TIMESTAMP()-61131,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al07_s01'
WHERE c.shortname='salon01' AND a.name='Factorial recursivo — Salón 1';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_7(num):
    if num <= 1:
        return 1
    return num * calc_fact_7(num - 1)

print(calc_fact_7(5))','evaluated',77.00,'PLAGIO: salón 1 alumno 8',1,UNIX_TIMESTAMP()-545512,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al08_s01'
WHERE c.shortname='salon01' AND a.name='Factorial recursivo — Salón 1';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_8(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_8(5))','evaluated',78.00,'SOSPECHOSO: salón 1 alumno 9',1,UNIX_TIMESTAMP()-1084211,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al09_s01'
WHERE c.shortname='salon01' AND a.name='Factorial recursivo — Salón 1';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_9(n):
    if n <= 1:
        return 1
    return n * factorial_9(n - 1)

print(factorial_9(5))','evaluated',79.00,'ORIGINAL: salón 1 alumno 10',1,UNIX_TIMESTAMP()-1036660,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al10_s01'
WHERE c.shortname='salon01' AND a.name='Factorial recursivo — Salón 1';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_10(n):
    if n <= 1:
        return 1
    return n * factorial_10(n - 1)

print(factorial_10(5))','evaluated',80.00,'ORIGINAL: salón 1 alumno 11',1,UNIX_TIMESTAMP()-290110,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al11_s01'
WHERE c.shortname='salon01' AND a.name='Factorial recursivo — Salón 1';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_11(num):
    if num <= 1:
        return 1
    return num * calc_fact_11(num - 1)

print(calc_fact_11(5))','evaluated',81.00,'PLAGIO: salón 1 alumno 12',1,UNIX_TIMESTAMP()-922832,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al12_s01'
WHERE c.shortname='salon01' AND a.name='Factorial recursivo — Salón 1';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_12(num):
    if num <= 1:
        return 1
    return num * calc_fact_12(num - 1)

print(calc_fact_12(5))','evaluated',82.00,'PLAGIO: salón 1 alumno 13',1,UNIX_TIMESTAMP()-412067,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al13_s01'
WHERE c.shortname='salon01' AND a.name='Factorial recursivo — Salón 1';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_13(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_13(5))','evaluated',83.00,'SOSPECHOSO: salón 1 alumno 14',1,UNIX_TIMESTAMP()-389109,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al14_s01'
WHERE c.shortname='salon01' AND a.name='Factorial recursivo — Salón 1';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_14(n):
    if n <= 1:
        return 1
    return n * factorial_14(n - 1)

print(factorial_14(5))','evaluated',84.00,'ORIGINAL: salón 1 alumno 15',1,UNIX_TIMESTAMP()-752150,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al15_s01'
WHERE c.shortname='salon01' AND a.name='Factorial recursivo — Salón 1';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_15(n):
    if n <= 1:
        return 1
    return n * factorial_15(n - 1)

print(factorial_15(5))','evaluated',85.00,'ORIGINAL: salón 1 alumno 16',1,UNIX_TIMESTAMP()-1172881,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al16_s01'
WHERE c.shortname='salon01' AND a.name='Factorial recursivo — Salón 1';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_16(num):
    if num <= 1:
        return 1
    return num * calc_fact_16(num - 1)

print(calc_fact_16(5))','evaluated',86.00,'PLAGIO: salón 1 alumno 17',1,UNIX_TIMESTAMP()-646088,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al17_s01'
WHERE c.shortname='salon01' AND a.name='Factorial recursivo — Salón 1';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_17(num):
    if num <= 1:
        return 1
    return num * calc_fact_17(num - 1)

print(calc_fact_17(5))','evaluated',87.00,'PLAGIO: salón 1 alumno 18',1,UNIX_TIMESTAMP()-892176,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al18_s01'
WHERE c.shortname='salon01' AND a.name='Factorial recursivo — Salón 1';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_18(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_18(5))','evaluated',88.00,'SOSPECHOSO: salón 1 alumno 19',1,UNIX_TIMESTAMP()-1162787,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al19_s01'
WHERE c.shortname='salon01' AND a.name='Factorial recursivo — Salón 1';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_19(n):
    if n <= 1:
        return 1
    return n * factorial_19(n - 1)

print(factorial_19(5))','evaluated',89.00,'ORIGINAL: salón 1 alumno 20',1,UNIX_TIMESTAMP()-579933,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al20_s01'
WHERE c.shortname='salon01' AND a.name='Factorial recursivo — Salón 1';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_20(n):
    if n <= 1:
        return 1
    return n * factorial_20(n - 1)

print(factorial_20(5))','evaluated',90.00,'ORIGINAL: salón 1 alumno 21',1,UNIX_TIMESTAMP()-152191,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al21_s01'
WHERE c.shortname='salon01' AND a.name='Factorial recursivo — Salón 1';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_21(num):
    if num <= 1:
        return 1
    return num * calc_fact_21(num - 1)

print(calc_fact_21(5))','evaluated',91.00,'PLAGIO: salón 1 alumno 22',1,UNIX_TIMESTAMP()-402881,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al22_s01'
WHERE c.shortname='salon01' AND a.name='Factorial recursivo — Salón 1';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_22(num):
    if num <= 1:
        return 1
    return num * calc_fact_22(num - 1)

print(calc_fact_22(5))','evaluated',92.00,'PLAGIO: salón 1 alumno 23',1,UNIX_TIMESTAMP()-795708,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al23_s01'
WHERE c.shortname='salon01' AND a.name='Factorial recursivo — Salón 1';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_23(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_23(5))','evaluated',93.00,'SOSPECHOSO: salón 1 alumno 24',1,UNIX_TIMESTAMP()-536327,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al24_s01'
WHERE c.shortname='salon01' AND a.name='Factorial recursivo — Salón 1';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_24(n):
    if n <= 1:
        return 1
    return n * factorial_24(n - 1)

print(factorial_24(5))','evaluated',94.00,'ORIGINAL: salón 1 alumno 25',1,UNIX_TIMESTAMP()-862970,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al25_s01'
WHERE c.shortname='salon01' AND a.name='Factorial recursivo — Salón 1';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_0(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_0([5,3,8,1,9]))','evaluated',70.00,'ORIGINAL: salón 1 alumno 1',1,UNIX_TIMESTAMP()-831298,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al01_s01'
WHERE c.shortname='salon01' AND a.name='Algoritmo de ordenamiento — Salón 1';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_1(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_1([5,3,8,1,9]))','evaluated',71.00,'PLAGIO: salón 1 alumno 2',1,UNIX_TIMESTAMP()-550653,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al02_s01'
WHERE c.shortname='salon01' AND a.name='Algoritmo de ordenamiento — Salón 1';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_2(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_2([5,3,8,1,9]))','evaluated',72.00,'PLAGIO: salón 1 alumno 3',1,UNIX_TIMESTAMP()-161114,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al03_s01'
WHERE c.shortname='salon01' AND a.name='Algoritmo de ordenamiento — Salón 1';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_3(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_3(5))','evaluated',73.00,'SOSPECHOSO: salón 1 alumno 4',1,UNIX_TIMESTAMP()-988531,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al04_s01'
WHERE c.shortname='salon01' AND a.name='Algoritmo de ordenamiento — Salón 1';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_4(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_4([5,3,8,1,9]))','evaluated',74.00,'ORIGINAL: salón 1 alumno 5',1,UNIX_TIMESTAMP()-1166538,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al05_s01'
WHERE c.shortname='salon01' AND a.name='Algoritmo de ordenamiento — Salón 1';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_5(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_5([5,3,8,1,9]))','evaluated',75.00,'ORIGINAL: salón 1 alumno 6',1,UNIX_TIMESTAMP()-586670,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al06_s01'
WHERE c.shortname='salon01' AND a.name='Algoritmo de ordenamiento — Salón 1';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_6(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_6([5,3,8,1,9]))','evaluated',76.00,'PLAGIO: salón 1 alumno 7',1,UNIX_TIMESTAMP()-640725,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al07_s01'
WHERE c.shortname='salon01' AND a.name='Algoritmo de ordenamiento — Salón 1';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_7(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_7([5,3,8,1,9]))','evaluated',77.00,'PLAGIO: salón 1 alumno 8',1,UNIX_TIMESTAMP()-303323,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al08_s01'
WHERE c.shortname='salon01' AND a.name='Algoritmo de ordenamiento — Salón 1';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_8(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_8(5))','evaluated',78.00,'SOSPECHOSO: salón 1 alumno 9',1,UNIX_TIMESTAMP()-74237,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al09_s01'
WHERE c.shortname='salon01' AND a.name='Algoritmo de ordenamiento — Salón 1';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_9(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_9([5,3,8,1,9]))','evaluated',79.00,'ORIGINAL: salón 1 alumno 10',1,UNIX_TIMESTAMP()-847293,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al10_s01'
WHERE c.shortname='salon01' AND a.name='Algoritmo de ordenamiento — Salón 1';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_10(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_10([5,3,8,1,9]))','evaluated',80.00,'ORIGINAL: salón 1 alumno 11',1,UNIX_TIMESTAMP()-157952,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al11_s01'
WHERE c.shortname='salon01' AND a.name='Algoritmo de ordenamiento — Salón 1';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_11(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_11([5,3,8,1,9]))','evaluated',81.00,'PLAGIO: salón 1 alumno 12',1,UNIX_TIMESTAMP()-622111,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al12_s01'
WHERE c.shortname='salon01' AND a.name='Algoritmo de ordenamiento — Salón 1';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_12(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_12([5,3,8,1,9]))','evaluated',82.00,'PLAGIO: salón 1 alumno 13',1,UNIX_TIMESTAMP()-668841,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al13_s01'
WHERE c.shortname='salon01' AND a.name='Algoritmo de ordenamiento — Salón 1';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_13(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_13(5))','evaluated',83.00,'SOSPECHOSO: salón 1 alumno 14',1,UNIX_TIMESTAMP()-813868,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al14_s01'
WHERE c.shortname='salon01' AND a.name='Algoritmo de ordenamiento — Salón 1';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_14(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_14([5,3,8,1,9]))','evaluated',84.00,'ORIGINAL: salón 1 alumno 15',1,UNIX_TIMESTAMP()-279107,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al15_s01'
WHERE c.shortname='salon01' AND a.name='Algoritmo de ordenamiento — Salón 1';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_15(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_15([5,3,8,1,9]))','evaluated',85.00,'ORIGINAL: salón 1 alumno 16',1,UNIX_TIMESTAMP()-817062,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al16_s01'
WHERE c.shortname='salon01' AND a.name='Algoritmo de ordenamiento — Salón 1';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_16(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_16([5,3,8,1,9]))','evaluated',86.00,'PLAGIO: salón 1 alumno 17',1,UNIX_TIMESTAMP()-628396,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al17_s01'
WHERE c.shortname='salon01' AND a.name='Algoritmo de ordenamiento — Salón 1';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_17(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_17([5,3,8,1,9]))','evaluated',87.00,'PLAGIO: salón 1 alumno 18',1,UNIX_TIMESTAMP()-859231,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al18_s01'
WHERE c.shortname='salon01' AND a.name='Algoritmo de ordenamiento — Salón 1';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_18(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_18(5))','evaluated',88.00,'SOSPECHOSO: salón 1 alumno 19',1,UNIX_TIMESTAMP()-1067023,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al19_s01'
WHERE c.shortname='salon01' AND a.name='Algoritmo de ordenamiento — Salón 1';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_19(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_19([5,3,8,1,9]))','evaluated',89.00,'ORIGINAL: salón 1 alumno 20',1,UNIX_TIMESTAMP()-134535,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al20_s01'
WHERE c.shortname='salon01' AND a.name='Algoritmo de ordenamiento — Salón 1';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_20(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_20([5,3,8,1,9]))','evaluated',90.00,'ORIGINAL: salón 1 alumno 21',1,UNIX_TIMESTAMP()-430396,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al21_s01'
WHERE c.shortname='salon01' AND a.name='Algoritmo de ordenamiento — Salón 1';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_21(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_21([5,3,8,1,9]))','evaluated',91.00,'PLAGIO: salón 1 alumno 22',1,UNIX_TIMESTAMP()-1167928,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al22_s01'
WHERE c.shortname='salon01' AND a.name='Algoritmo de ordenamiento — Salón 1';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_22(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_22([5,3,8,1,9]))','evaluated',92.00,'PLAGIO: salón 1 alumno 23',1,UNIX_TIMESTAMP()-1130297,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al23_s01'
WHERE c.shortname='salon01' AND a.name='Algoritmo de ordenamiento — Salón 1';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_23(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_23(5))','evaluated',93.00,'SOSPECHOSO: salón 1 alumno 24',1,UNIX_TIMESTAMP()-53424,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al24_s01'
WHERE c.shortname='salon01' AND a.name='Algoritmo de ordenamiento — Salón 1';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_24(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_24([5,3,8,1,9]))','evaluated',94.00,'ORIGINAL: salón 1 alumno 25',1,UNIX_TIMESTAMP()-1071023,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al25_s01'
WHERE c.shortname='salon01' AND a.name='Algoritmo de ordenamiento — Salón 1';

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_25(n):
    if n <= 1:
        return 1
    return n * factorial_25(n - 1)

print(factorial_25(5))','evaluated',70.00,'ORIGINAL: salón 2 alumno 1',1,UNIX_TIMESTAMP()-824499,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al01_s02'
WHERE c.shortname='salon02' AND a.name='Factorial recursivo — Salón 2';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_26(num):
    if num <= 1:
        return 1
    return num * calc_fact_26(num - 1)

print(calc_fact_26(5))','evaluated',71.00,'PLAGIO: salón 2 alumno 2',1,UNIX_TIMESTAMP()-1148003,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al02_s02'
WHERE c.shortname='salon02' AND a.name='Factorial recursivo — Salón 2';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_27(num):
    if num <= 1:
        return 1
    return num * calc_fact_27(num - 1)

print(calc_fact_27(5))','evaluated',72.00,'PLAGIO: salón 2 alumno 3',1,UNIX_TIMESTAMP()-164831,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al03_s02'
WHERE c.shortname='salon02' AND a.name='Factorial recursivo — Salón 2';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_28(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_28(5))','evaluated',73.00,'SOSPECHOSO: salón 2 alumno 4',1,UNIX_TIMESTAMP()-426173,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al04_s02'
WHERE c.shortname='salon02' AND a.name='Factorial recursivo — Salón 2';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_29(n):
    if n <= 1:
        return 1
    return n * factorial_29(n - 1)

print(factorial_29(5))','evaluated',74.00,'ORIGINAL: salón 2 alumno 5',1,UNIX_TIMESTAMP()-130077,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al05_s02'
WHERE c.shortname='salon02' AND a.name='Factorial recursivo — Salón 2';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_30(n):
    if n <= 1:
        return 1
    return n * factorial_30(n - 1)

print(factorial_30(5))','evaluated',75.00,'ORIGINAL: salón 2 alumno 6',1,UNIX_TIMESTAMP()-842632,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al06_s02'
WHERE c.shortname='salon02' AND a.name='Factorial recursivo — Salón 2';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_31(num):
    if num <= 1:
        return 1
    return num * calc_fact_31(num - 1)

print(calc_fact_31(5))','evaluated',76.00,'PLAGIO: salón 2 alumno 7',1,UNIX_TIMESTAMP()-1066236,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al07_s02'
WHERE c.shortname='salon02' AND a.name='Factorial recursivo — Salón 2';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_32(num):
    if num <= 1:
        return 1
    return num * calc_fact_32(num - 1)

print(calc_fact_32(5))','evaluated',77.00,'PLAGIO: salón 2 alumno 8',1,UNIX_TIMESTAMP()-866420,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al08_s02'
WHERE c.shortname='salon02' AND a.name='Factorial recursivo — Salón 2';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_33(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_33(5))','evaluated',78.00,'SOSPECHOSO: salón 2 alumno 9',1,UNIX_TIMESTAMP()-1084484,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al09_s02'
WHERE c.shortname='salon02' AND a.name='Factorial recursivo — Salón 2';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_34(n):
    if n <= 1:
        return 1
    return n * factorial_34(n - 1)

print(factorial_34(5))','evaluated',79.00,'ORIGINAL: salón 2 alumno 10',1,UNIX_TIMESTAMP()-860090,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al10_s02'
WHERE c.shortname='salon02' AND a.name='Factorial recursivo — Salón 2';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_35(n):
    if n <= 1:
        return 1
    return n * factorial_35(n - 1)

print(factorial_35(5))','evaluated',80.00,'ORIGINAL: salón 2 alumno 11',1,UNIX_TIMESTAMP()-411842,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al11_s02'
WHERE c.shortname='salon02' AND a.name='Factorial recursivo — Salón 2';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_36(num):
    if num <= 1:
        return 1
    return num * calc_fact_36(num - 1)

print(calc_fact_36(5))','evaluated',81.00,'PLAGIO: salón 2 alumno 12',1,UNIX_TIMESTAMP()-150412,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al12_s02'
WHERE c.shortname='salon02' AND a.name='Factorial recursivo — Salón 2';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_37(num):
    if num <= 1:
        return 1
    return num * calc_fact_37(num - 1)

print(calc_fact_37(5))','evaluated',82.00,'PLAGIO: salón 2 alumno 13',1,UNIX_TIMESTAMP()-980431,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al13_s02'
WHERE c.shortname='salon02' AND a.name='Factorial recursivo — Salón 2';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_38(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_38(5))','evaluated',83.00,'SOSPECHOSO: salón 2 alumno 14',1,UNIX_TIMESTAMP()-720044,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al14_s02'
WHERE c.shortname='salon02' AND a.name='Factorial recursivo — Salón 2';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_39(n):
    if n <= 1:
        return 1
    return n * factorial_39(n - 1)

print(factorial_39(5))','evaluated',84.00,'ORIGINAL: salón 2 alumno 15',1,UNIX_TIMESTAMP()-521083,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al15_s02'
WHERE c.shortname='salon02' AND a.name='Factorial recursivo — Salón 2';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_40(n):
    if n <= 1:
        return 1
    return n * factorial_40(n - 1)

print(factorial_40(5))','evaluated',85.00,'ORIGINAL: salón 2 alumno 16',1,UNIX_TIMESTAMP()-1114448,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al16_s02'
WHERE c.shortname='salon02' AND a.name='Factorial recursivo — Salón 2';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_41(num):
    if num <= 1:
        return 1
    return num * calc_fact_41(num - 1)

print(calc_fact_41(5))','evaluated',86.00,'PLAGIO: salón 2 alumno 17',1,UNIX_TIMESTAMP()-378665,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al17_s02'
WHERE c.shortname='salon02' AND a.name='Factorial recursivo — Salón 2';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_42(num):
    if num <= 1:
        return 1
    return num * calc_fact_42(num - 1)

print(calc_fact_42(5))','evaluated',87.00,'PLAGIO: salón 2 alumno 18',1,UNIX_TIMESTAMP()-607062,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al18_s02'
WHERE c.shortname='salon02' AND a.name='Factorial recursivo — Salón 2';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_43(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_43(5))','evaluated',88.00,'SOSPECHOSO: salón 2 alumno 19',1,UNIX_TIMESTAMP()-785131,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al19_s02'
WHERE c.shortname='salon02' AND a.name='Factorial recursivo — Salón 2';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_44(n):
    if n <= 1:
        return 1
    return n * factorial_44(n - 1)

print(factorial_44(5))','evaluated',89.00,'ORIGINAL: salón 2 alumno 20',1,UNIX_TIMESTAMP()-328745,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al20_s02'
WHERE c.shortname='salon02' AND a.name='Factorial recursivo — Salón 2';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_45(n):
    if n <= 1:
        return 1
    return n * factorial_45(n - 1)

print(factorial_45(5))','evaluated',90.00,'ORIGINAL: salón 2 alumno 21',1,UNIX_TIMESTAMP()-1172469,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al21_s02'
WHERE c.shortname='salon02' AND a.name='Factorial recursivo — Salón 2';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_46(num):
    if num <= 1:
        return 1
    return num * calc_fact_46(num - 1)

print(calc_fact_46(5))','evaluated',91.00,'PLAGIO: salón 2 alumno 22',1,UNIX_TIMESTAMP()-698746,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al22_s02'
WHERE c.shortname='salon02' AND a.name='Factorial recursivo — Salón 2';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_47(num):
    if num <= 1:
        return 1
    return num * calc_fact_47(num - 1)

print(calc_fact_47(5))','evaluated',92.00,'PLAGIO: salón 2 alumno 23',1,UNIX_TIMESTAMP()-1051467,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al23_s02'
WHERE c.shortname='salon02' AND a.name='Factorial recursivo — Salón 2';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_48(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_48(5))','evaluated',93.00,'SOSPECHOSO: salón 2 alumno 24',1,UNIX_TIMESTAMP()-382379,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al24_s02'
WHERE c.shortname='salon02' AND a.name='Factorial recursivo — Salón 2';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_49(n):
    if n <= 1:
        return 1
    return n * factorial_49(n - 1)

print(factorial_49(5))','evaluated',94.00,'ORIGINAL: salón 2 alumno 25',1,UNIX_TIMESTAMP()-81701,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al25_s02'
WHERE c.shortname='salon02' AND a.name='Factorial recursivo — Salón 2';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_25(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_25([5,3,8,1,9]))','evaluated',70.00,'ORIGINAL: salón 2 alumno 1',1,UNIX_TIMESTAMP()-331135,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al01_s02'
WHERE c.shortname='salon02' AND a.name='Algoritmo de ordenamiento — Salón 2';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_26(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_26([5,3,8,1,9]))','evaluated',71.00,'PLAGIO: salón 2 alumno 2',1,UNIX_TIMESTAMP()-195992,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al02_s02'
WHERE c.shortname='salon02' AND a.name='Algoritmo de ordenamiento — Salón 2';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_27(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_27([5,3,8,1,9]))','evaluated',72.00,'PLAGIO: salón 2 alumno 3',1,UNIX_TIMESTAMP()-295715,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al03_s02'
WHERE c.shortname='salon02' AND a.name='Algoritmo de ordenamiento — Salón 2';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_28(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_28(5))','evaluated',73.00,'SOSPECHOSO: salón 2 alumno 4',1,UNIX_TIMESTAMP()-993179,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al04_s02'
WHERE c.shortname='salon02' AND a.name='Algoritmo de ordenamiento — Salón 2';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_29(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_29([5,3,8,1,9]))','evaluated',74.00,'ORIGINAL: salón 2 alumno 5',1,UNIX_TIMESTAMP()-247267,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al05_s02'
WHERE c.shortname='salon02' AND a.name='Algoritmo de ordenamiento — Salón 2';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_30(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_30([5,3,8,1,9]))','evaluated',75.00,'ORIGINAL: salón 2 alumno 6',1,UNIX_TIMESTAMP()-94294,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al06_s02'
WHERE c.shortname='salon02' AND a.name='Algoritmo de ordenamiento — Salón 2';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_31(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_31([5,3,8,1,9]))','evaluated',76.00,'PLAGIO: salón 2 alumno 7',1,UNIX_TIMESTAMP()-694908,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al07_s02'
WHERE c.shortname='salon02' AND a.name='Algoritmo de ordenamiento — Salón 2';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_32(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_32([5,3,8,1,9]))','evaluated',77.00,'PLAGIO: salón 2 alumno 8',1,UNIX_TIMESTAMP()-3619,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al08_s02'
WHERE c.shortname='salon02' AND a.name='Algoritmo de ordenamiento — Salón 2';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_33(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_33(5))','evaluated',78.00,'SOSPECHOSO: salón 2 alumno 9',1,UNIX_TIMESTAMP()-292318,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al09_s02'
WHERE c.shortname='salon02' AND a.name='Algoritmo de ordenamiento — Salón 2';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_34(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_34([5,3,8,1,9]))','evaluated',79.00,'ORIGINAL: salón 2 alumno 10',1,UNIX_TIMESTAMP()-577872,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al10_s02'
WHERE c.shortname='salon02' AND a.name='Algoritmo de ordenamiento — Salón 2';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_35(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_35([5,3,8,1,9]))','evaluated',80.00,'ORIGINAL: salón 2 alumno 11',1,UNIX_TIMESTAMP()-3119,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al11_s02'
WHERE c.shortname='salon02' AND a.name='Algoritmo de ordenamiento — Salón 2';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_36(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_36([5,3,8,1,9]))','evaluated',81.00,'PLAGIO: salón 2 alumno 12',1,UNIX_TIMESTAMP()-731825,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al12_s02'
WHERE c.shortname='salon02' AND a.name='Algoritmo de ordenamiento — Salón 2';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_37(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_37([5,3,8,1,9]))','evaluated',82.00,'PLAGIO: salón 2 alumno 13',1,UNIX_TIMESTAMP()-1149342,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al13_s02'
WHERE c.shortname='salon02' AND a.name='Algoritmo de ordenamiento — Salón 2';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_38(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_38(5))','evaluated',83.00,'SOSPECHOSO: salón 2 alumno 14',1,UNIX_TIMESTAMP()-923824,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al14_s02'
WHERE c.shortname='salon02' AND a.name='Algoritmo de ordenamiento — Salón 2';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_39(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_39([5,3,8,1,9]))','evaluated',84.00,'ORIGINAL: salón 2 alumno 15',1,UNIX_TIMESTAMP()-135461,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al15_s02'
WHERE c.shortname='salon02' AND a.name='Algoritmo de ordenamiento — Salón 2';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_40(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_40([5,3,8,1,9]))','evaluated',85.00,'ORIGINAL: salón 2 alumno 16',1,UNIX_TIMESTAMP()-498931,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al16_s02'
WHERE c.shortname='salon02' AND a.name='Algoritmo de ordenamiento — Salón 2';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_41(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_41([5,3,8,1,9]))','evaluated',86.00,'PLAGIO: salón 2 alumno 17',1,UNIX_TIMESTAMP()-960400,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al17_s02'
WHERE c.shortname='salon02' AND a.name='Algoritmo de ordenamiento — Salón 2';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_42(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_42([5,3,8,1,9]))','evaluated',87.00,'PLAGIO: salón 2 alumno 18',1,UNIX_TIMESTAMP()-1091616,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al18_s02'
WHERE c.shortname='salon02' AND a.name='Algoritmo de ordenamiento — Salón 2';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_43(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_43(5))','evaluated',88.00,'SOSPECHOSO: salón 2 alumno 19',1,UNIX_TIMESTAMP()-431199,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al19_s02'
WHERE c.shortname='salon02' AND a.name='Algoritmo de ordenamiento — Salón 2';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_44(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_44([5,3,8,1,9]))','evaluated',89.00,'ORIGINAL: salón 2 alumno 20',1,UNIX_TIMESTAMP()-827754,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al20_s02'
WHERE c.shortname='salon02' AND a.name='Algoritmo de ordenamiento — Salón 2';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_45(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_45([5,3,8,1,9]))','evaluated',90.00,'ORIGINAL: salón 2 alumno 21',1,UNIX_TIMESTAMP()-1194646,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al21_s02'
WHERE c.shortname='salon02' AND a.name='Algoritmo de ordenamiento — Salón 2';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_46(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_46([5,3,8,1,9]))','evaluated',91.00,'PLAGIO: salón 2 alumno 22',1,UNIX_TIMESTAMP()-793625,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al22_s02'
WHERE c.shortname='salon02' AND a.name='Algoritmo de ordenamiento — Salón 2';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_47(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_47([5,3,8,1,9]))','evaluated',92.00,'PLAGIO: salón 2 alumno 23',1,UNIX_TIMESTAMP()-365742,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al23_s02'
WHERE c.shortname='salon02' AND a.name='Algoritmo de ordenamiento — Salón 2';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_48(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_48(5))','evaluated',93.00,'SOSPECHOSO: salón 2 alumno 24',1,UNIX_TIMESTAMP()-111559,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al24_s02'
WHERE c.shortname='salon02' AND a.name='Algoritmo de ordenamiento — Salón 2';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_49(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_49([5,3,8,1,9]))','evaluated',94.00,'ORIGINAL: salón 2 alumno 25',1,UNIX_TIMESTAMP()-1062622,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al25_s02'
WHERE c.shortname='salon02' AND a.name='Algoritmo de ordenamiento — Salón 2';

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_50(n):
    if n <= 1:
        return 1
    return n * factorial_50(n - 1)

print(factorial_50(5))','evaluated',70.00,'ORIGINAL: salón 3 alumno 1',1,UNIX_TIMESTAMP()-688423,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al01_s03'
WHERE c.shortname='salon03' AND a.name='Factorial recursivo — Salón 3';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_51(num):
    if num <= 1:
        return 1
    return num * calc_fact_51(num - 1)

print(calc_fact_51(5))','evaluated',71.00,'PLAGIO: salón 3 alumno 2',1,UNIX_TIMESTAMP()-695851,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al02_s03'
WHERE c.shortname='salon03' AND a.name='Factorial recursivo — Salón 3';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_52(num):
    if num <= 1:
        return 1
    return num * calc_fact_52(num - 1)

print(calc_fact_52(5))','evaluated',72.00,'PLAGIO: salón 3 alumno 3',1,UNIX_TIMESTAMP()-881148,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al03_s03'
WHERE c.shortname='salon03' AND a.name='Factorial recursivo — Salón 3';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_53(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_53(5))','evaluated',73.00,'SOSPECHOSO: salón 3 alumno 4',1,UNIX_TIMESTAMP()-120283,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al04_s03'
WHERE c.shortname='salon03' AND a.name='Factorial recursivo — Salón 3';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_54(n):
    if n <= 1:
        return 1
    return n * factorial_54(n - 1)

print(factorial_54(5))','evaluated',74.00,'ORIGINAL: salón 3 alumno 5',1,UNIX_TIMESTAMP()-1007366,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al05_s03'
WHERE c.shortname='salon03' AND a.name='Factorial recursivo — Salón 3';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_55(n):
    if n <= 1:
        return 1
    return n * factorial_55(n - 1)

print(factorial_55(5))','evaluated',75.00,'ORIGINAL: salón 3 alumno 6',1,UNIX_TIMESTAMP()-677186,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al06_s03'
WHERE c.shortname='salon03' AND a.name='Factorial recursivo — Salón 3';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_56(num):
    if num <= 1:
        return 1
    return num * calc_fact_56(num - 1)

print(calc_fact_56(5))','evaluated',76.00,'PLAGIO: salón 3 alumno 7',1,UNIX_TIMESTAMP()-768426,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al07_s03'
WHERE c.shortname='salon03' AND a.name='Factorial recursivo — Salón 3';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_57(num):
    if num <= 1:
        return 1
    return num * calc_fact_57(num - 1)

print(calc_fact_57(5))','evaluated',77.00,'PLAGIO: salón 3 alumno 8',1,UNIX_TIMESTAMP()-790807,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al08_s03'
WHERE c.shortname='salon03' AND a.name='Factorial recursivo — Salón 3';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_58(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_58(5))','evaluated',78.00,'SOSPECHOSO: salón 3 alumno 9',1,UNIX_TIMESTAMP()-1056212,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al09_s03'
WHERE c.shortname='salon03' AND a.name='Factorial recursivo — Salón 3';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_59(n):
    if n <= 1:
        return 1
    return n * factorial_59(n - 1)

print(factorial_59(5))','evaluated',79.00,'ORIGINAL: salón 3 alumno 10',1,UNIX_TIMESTAMP()-321383,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al10_s03'
WHERE c.shortname='salon03' AND a.name='Factorial recursivo — Salón 3';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_60(n):
    if n <= 1:
        return 1
    return n * factorial_60(n - 1)

print(factorial_60(5))','evaluated',80.00,'ORIGINAL: salón 3 alumno 11',1,UNIX_TIMESTAMP()-13237,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al11_s03'
WHERE c.shortname='salon03' AND a.name='Factorial recursivo — Salón 3';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_61(num):
    if num <= 1:
        return 1
    return num * calc_fact_61(num - 1)

print(calc_fact_61(5))','evaluated',81.00,'PLAGIO: salón 3 alumno 12',1,UNIX_TIMESTAMP()-748172,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al12_s03'
WHERE c.shortname='salon03' AND a.name='Factorial recursivo — Salón 3';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_62(num):
    if num <= 1:
        return 1
    return num * calc_fact_62(num - 1)

print(calc_fact_62(5))','evaluated',82.00,'PLAGIO: salón 3 alumno 13',1,UNIX_TIMESTAMP()-780469,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al13_s03'
WHERE c.shortname='salon03' AND a.name='Factorial recursivo — Salón 3';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_63(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_63(5))','evaluated',83.00,'SOSPECHOSO: salón 3 alumno 14',1,UNIX_TIMESTAMP()-692137,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al14_s03'
WHERE c.shortname='salon03' AND a.name='Factorial recursivo — Salón 3';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_64(n):
    if n <= 1:
        return 1
    return n * factorial_64(n - 1)

print(factorial_64(5))','evaluated',84.00,'ORIGINAL: salón 3 alumno 15',1,UNIX_TIMESTAMP()-157444,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al15_s03'
WHERE c.shortname='salon03' AND a.name='Factorial recursivo — Salón 3';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_65(n):
    if n <= 1:
        return 1
    return n * factorial_65(n - 1)

print(factorial_65(5))','evaluated',85.00,'ORIGINAL: salón 3 alumno 16',1,UNIX_TIMESTAMP()-860470,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al16_s03'
WHERE c.shortname='salon03' AND a.name='Factorial recursivo — Salón 3';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_66(num):
    if num <= 1:
        return 1
    return num * calc_fact_66(num - 1)

print(calc_fact_66(5))','evaluated',86.00,'PLAGIO: salón 3 alumno 17',1,UNIX_TIMESTAMP()-509503,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al17_s03'
WHERE c.shortname='salon03' AND a.name='Factorial recursivo — Salón 3';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_67(num):
    if num <= 1:
        return 1
    return num * calc_fact_67(num - 1)

print(calc_fact_67(5))','evaluated',87.00,'PLAGIO: salón 3 alumno 18',1,UNIX_TIMESTAMP()-941772,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al18_s03'
WHERE c.shortname='salon03' AND a.name='Factorial recursivo — Salón 3';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_68(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_68(5))','evaluated',88.00,'SOSPECHOSO: salón 3 alumno 19',1,UNIX_TIMESTAMP()-784873,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al19_s03'
WHERE c.shortname='salon03' AND a.name='Factorial recursivo — Salón 3';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_69(n):
    if n <= 1:
        return 1
    return n * factorial_69(n - 1)

print(factorial_69(5))','evaluated',89.00,'ORIGINAL: salón 3 alumno 20',1,UNIX_TIMESTAMP()-725379,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al20_s03'
WHERE c.shortname='salon03' AND a.name='Factorial recursivo — Salón 3';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_70(n):
    if n <= 1:
        return 1
    return n * factorial_70(n - 1)

print(factorial_70(5))','evaluated',90.00,'ORIGINAL: salón 3 alumno 21',1,UNIX_TIMESTAMP()-518482,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al21_s03'
WHERE c.shortname='salon03' AND a.name='Factorial recursivo — Salón 3';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_71(num):
    if num <= 1:
        return 1
    return num * calc_fact_71(num - 1)

print(calc_fact_71(5))','evaluated',91.00,'PLAGIO: salón 3 alumno 22',1,UNIX_TIMESTAMP()-788465,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al22_s03'
WHERE c.shortname='salon03' AND a.name='Factorial recursivo — Salón 3';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_72(num):
    if num <= 1:
        return 1
    return num * calc_fact_72(num - 1)

print(calc_fact_72(5))','evaluated',92.00,'PLAGIO: salón 3 alumno 23',1,UNIX_TIMESTAMP()-271849,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al23_s03'
WHERE c.shortname='salon03' AND a.name='Factorial recursivo — Salón 3';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_73(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_73(5))','evaluated',93.00,'SOSPECHOSO: salón 3 alumno 24',1,UNIX_TIMESTAMP()-295999,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al24_s03'
WHERE c.shortname='salon03' AND a.name='Factorial recursivo — Salón 3';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_74(n):
    if n <= 1:
        return 1
    return n * factorial_74(n - 1)

print(factorial_74(5))','evaluated',94.00,'ORIGINAL: salón 3 alumno 25',1,UNIX_TIMESTAMP()-819669,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al25_s03'
WHERE c.shortname='salon03' AND a.name='Factorial recursivo — Salón 3';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_50(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_50([5,3,8,1,9]))','evaluated',70.00,'ORIGINAL: salón 3 alumno 1',1,UNIX_TIMESTAMP()-326856,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al01_s03'
WHERE c.shortname='salon03' AND a.name='Algoritmo de ordenamiento — Salón 3';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_51(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_51([5,3,8,1,9]))','evaluated',71.00,'PLAGIO: salón 3 alumno 2',1,UNIX_TIMESTAMP()-111424,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al02_s03'
WHERE c.shortname='salon03' AND a.name='Algoritmo de ordenamiento — Salón 3';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_52(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_52([5,3,8,1,9]))','evaluated',72.00,'PLAGIO: salón 3 alumno 3',1,UNIX_TIMESTAMP()-928581,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al03_s03'
WHERE c.shortname='salon03' AND a.name='Algoritmo de ordenamiento — Salón 3';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_53(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_53(5))','evaluated',73.00,'SOSPECHOSO: salón 3 alumno 4',1,UNIX_TIMESTAMP()-797529,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al04_s03'
WHERE c.shortname='salon03' AND a.name='Algoritmo de ordenamiento — Salón 3';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_54(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_54([5,3,8,1,9]))','evaluated',74.00,'ORIGINAL: salón 3 alumno 5',1,UNIX_TIMESTAMP()-49075,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al05_s03'
WHERE c.shortname='salon03' AND a.name='Algoritmo de ordenamiento — Salón 3';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_55(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_55([5,3,8,1,9]))','evaluated',75.00,'ORIGINAL: salón 3 alumno 6',1,UNIX_TIMESTAMP()-1079447,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al06_s03'
WHERE c.shortname='salon03' AND a.name='Algoritmo de ordenamiento — Salón 3';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_56(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_56([5,3,8,1,9]))','evaluated',76.00,'PLAGIO: salón 3 alumno 7',1,UNIX_TIMESTAMP()-511800,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al07_s03'
WHERE c.shortname='salon03' AND a.name='Algoritmo de ordenamiento — Salón 3';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_57(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_57([5,3,8,1,9]))','evaluated',77.00,'PLAGIO: salón 3 alumno 8',1,UNIX_TIMESTAMP()-63048,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al08_s03'
WHERE c.shortname='salon03' AND a.name='Algoritmo de ordenamiento — Salón 3';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_58(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_58(5))','evaluated',78.00,'SOSPECHOSO: salón 3 alumno 9',1,UNIX_TIMESTAMP()-225782,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al09_s03'
WHERE c.shortname='salon03' AND a.name='Algoritmo de ordenamiento — Salón 3';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_59(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_59([5,3,8,1,9]))','evaluated',79.00,'ORIGINAL: salón 3 alumno 10',1,UNIX_TIMESTAMP()-373850,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al10_s03'
WHERE c.shortname='salon03' AND a.name='Algoritmo de ordenamiento — Salón 3';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_60(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_60([5,3,8,1,9]))','evaluated',80.00,'ORIGINAL: salón 3 alumno 11',1,UNIX_TIMESTAMP()-356304,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al11_s03'
WHERE c.shortname='salon03' AND a.name='Algoritmo de ordenamiento — Salón 3';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_61(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_61([5,3,8,1,9]))','evaluated',81.00,'PLAGIO: salón 3 alumno 12',1,UNIX_TIMESTAMP()-366399,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al12_s03'
WHERE c.shortname='salon03' AND a.name='Algoritmo de ordenamiento — Salón 3';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_62(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_62([5,3,8,1,9]))','evaluated',82.00,'PLAGIO: salón 3 alumno 13',1,UNIX_TIMESTAMP()-299825,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al13_s03'
WHERE c.shortname='salon03' AND a.name='Algoritmo de ordenamiento — Salón 3';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_63(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_63(5))','evaluated',83.00,'SOSPECHOSO: salón 3 alumno 14',1,UNIX_TIMESTAMP()-598014,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al14_s03'
WHERE c.shortname='salon03' AND a.name='Algoritmo de ordenamiento — Salón 3';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_64(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_64([5,3,8,1,9]))','evaluated',84.00,'ORIGINAL: salón 3 alumno 15',1,UNIX_TIMESTAMP()-960642,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al15_s03'
WHERE c.shortname='salon03' AND a.name='Algoritmo de ordenamiento — Salón 3';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_65(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_65([5,3,8,1,9]))','evaluated',85.00,'ORIGINAL: salón 3 alumno 16',1,UNIX_TIMESTAMP()-748847,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al16_s03'
WHERE c.shortname='salon03' AND a.name='Algoritmo de ordenamiento — Salón 3';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_66(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_66([5,3,8,1,9]))','evaluated',86.00,'PLAGIO: salón 3 alumno 17',1,UNIX_TIMESTAMP()-638938,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al17_s03'
WHERE c.shortname='salon03' AND a.name='Algoritmo de ordenamiento — Salón 3';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_67(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_67([5,3,8,1,9]))','evaluated',87.00,'PLAGIO: salón 3 alumno 18',1,UNIX_TIMESTAMP()-877987,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al18_s03'
WHERE c.shortname='salon03' AND a.name='Algoritmo de ordenamiento — Salón 3';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_68(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_68(5))','evaluated',88.00,'SOSPECHOSO: salón 3 alumno 19',1,UNIX_TIMESTAMP()-626055,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al19_s03'
WHERE c.shortname='salon03' AND a.name='Algoritmo de ordenamiento — Salón 3';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_69(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_69([5,3,8,1,9]))','evaluated',89.00,'ORIGINAL: salón 3 alumno 20',1,UNIX_TIMESTAMP()-878522,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al20_s03'
WHERE c.shortname='salon03' AND a.name='Algoritmo de ordenamiento — Salón 3';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_70(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_70([5,3,8,1,9]))','evaluated',90.00,'ORIGINAL: salón 3 alumno 21',1,UNIX_TIMESTAMP()-461642,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al21_s03'
WHERE c.shortname='salon03' AND a.name='Algoritmo de ordenamiento — Salón 3';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_71(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_71([5,3,8,1,9]))','evaluated',91.00,'PLAGIO: salón 3 alumno 22',1,UNIX_TIMESTAMP()-1133834,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al22_s03'
WHERE c.shortname='salon03' AND a.name='Algoritmo de ordenamiento — Salón 3';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_72(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_72([5,3,8,1,9]))','evaluated',92.00,'PLAGIO: salón 3 alumno 23',1,UNIX_TIMESTAMP()-869488,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al23_s03'
WHERE c.shortname='salon03' AND a.name='Algoritmo de ordenamiento — Salón 3';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_73(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_73(5))','evaluated',93.00,'SOSPECHOSO: salón 3 alumno 24',1,UNIX_TIMESTAMP()-576604,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al24_s03'
WHERE c.shortname='salon03' AND a.name='Algoritmo de ordenamiento — Salón 3';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_74(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_74([5,3,8,1,9]))','evaluated',94.00,'ORIGINAL: salón 3 alumno 25',1,UNIX_TIMESTAMP()-564761,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al25_s03'
WHERE c.shortname='salon03' AND a.name='Algoritmo de ordenamiento — Salón 3';

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_75(n):
    if n <= 1:
        return 1
    return n * factorial_75(n - 1)

print(factorial_75(5))','evaluated',70.00,'ORIGINAL: salón 4 alumno 1',1,UNIX_TIMESTAMP()-175806,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al01_s04'
WHERE c.shortname='salon04' AND a.name='Factorial recursivo — Salón 4';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_76(num):
    if num <= 1:
        return 1
    return num * calc_fact_76(num - 1)

print(calc_fact_76(5))','evaluated',71.00,'PLAGIO: salón 4 alumno 2',1,UNIX_TIMESTAMP()-1068376,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al02_s04'
WHERE c.shortname='salon04' AND a.name='Factorial recursivo — Salón 4';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_77(num):
    if num <= 1:
        return 1
    return num * calc_fact_77(num - 1)

print(calc_fact_77(5))','evaluated',72.00,'PLAGIO: salón 4 alumno 3',1,UNIX_TIMESTAMP()-527955,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al03_s04'
WHERE c.shortname='salon04' AND a.name='Factorial recursivo — Salón 4';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_78(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_78(5))','evaluated',73.00,'SOSPECHOSO: salón 4 alumno 4',1,UNIX_TIMESTAMP()-833954,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al04_s04'
WHERE c.shortname='salon04' AND a.name='Factorial recursivo — Salón 4';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_79(n):
    if n <= 1:
        return 1
    return n * factorial_79(n - 1)

print(factorial_79(5))','evaluated',74.00,'ORIGINAL: salón 4 alumno 5',1,UNIX_TIMESTAMP()-807474,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al05_s04'
WHERE c.shortname='salon04' AND a.name='Factorial recursivo — Salón 4';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_80(n):
    if n <= 1:
        return 1
    return n * factorial_80(n - 1)

print(factorial_80(5))','evaluated',75.00,'ORIGINAL: salón 4 alumno 6',1,UNIX_TIMESTAMP()-109571,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al06_s04'
WHERE c.shortname='salon04' AND a.name='Factorial recursivo — Salón 4';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_81(num):
    if num <= 1:
        return 1
    return num * calc_fact_81(num - 1)

print(calc_fact_81(5))','evaluated',76.00,'PLAGIO: salón 4 alumno 7',1,UNIX_TIMESTAMP()-885127,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al07_s04'
WHERE c.shortname='salon04' AND a.name='Factorial recursivo — Salón 4';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_82(num):
    if num <= 1:
        return 1
    return num * calc_fact_82(num - 1)

print(calc_fact_82(5))','evaluated',77.00,'PLAGIO: salón 4 alumno 8',1,UNIX_TIMESTAMP()-809248,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al08_s04'
WHERE c.shortname='salon04' AND a.name='Factorial recursivo — Salón 4';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_83(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_83(5))','evaluated',78.00,'SOSPECHOSO: salón 4 alumno 9',1,UNIX_TIMESTAMP()-40726,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al09_s04'
WHERE c.shortname='salon04' AND a.name='Factorial recursivo — Salón 4';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_84(n):
    if n <= 1:
        return 1
    return n * factorial_84(n - 1)

print(factorial_84(5))','evaluated',79.00,'ORIGINAL: salón 4 alumno 10',1,UNIX_TIMESTAMP()-84094,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al10_s04'
WHERE c.shortname='salon04' AND a.name='Factorial recursivo — Salón 4';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_85(n):
    if n <= 1:
        return 1
    return n * factorial_85(n - 1)

print(factorial_85(5))','evaluated',80.00,'ORIGINAL: salón 4 alumno 11',1,UNIX_TIMESTAMP()-165972,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al11_s04'
WHERE c.shortname='salon04' AND a.name='Factorial recursivo — Salón 4';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_86(num):
    if num <= 1:
        return 1
    return num * calc_fact_86(num - 1)

print(calc_fact_86(5))','evaluated',81.00,'PLAGIO: salón 4 alumno 12',1,UNIX_TIMESTAMP()-581062,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al12_s04'
WHERE c.shortname='salon04' AND a.name='Factorial recursivo — Salón 4';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_87(num):
    if num <= 1:
        return 1
    return num * calc_fact_87(num - 1)

print(calc_fact_87(5))','evaluated',82.00,'PLAGIO: salón 4 alumno 13',1,UNIX_TIMESTAMP()-862348,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al13_s04'
WHERE c.shortname='salon04' AND a.name='Factorial recursivo — Salón 4';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_88(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_88(5))','evaluated',83.00,'SOSPECHOSO: salón 4 alumno 14',1,UNIX_TIMESTAMP()-481837,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al14_s04'
WHERE c.shortname='salon04' AND a.name='Factorial recursivo — Salón 4';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_89(n):
    if n <= 1:
        return 1
    return n * factorial_89(n - 1)

print(factorial_89(5))','evaluated',84.00,'ORIGINAL: salón 4 alumno 15',1,UNIX_TIMESTAMP()-70086,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al15_s04'
WHERE c.shortname='salon04' AND a.name='Factorial recursivo — Salón 4';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_90(n):
    if n <= 1:
        return 1
    return n * factorial_90(n - 1)

print(factorial_90(5))','evaluated',85.00,'ORIGINAL: salón 4 alumno 16',1,UNIX_TIMESTAMP()-254708,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al16_s04'
WHERE c.shortname='salon04' AND a.name='Factorial recursivo — Salón 4';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_91(num):
    if num <= 1:
        return 1
    return num * calc_fact_91(num - 1)

print(calc_fact_91(5))','evaluated',86.00,'PLAGIO: salón 4 alumno 17',1,UNIX_TIMESTAMP()-697644,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al17_s04'
WHERE c.shortname='salon04' AND a.name='Factorial recursivo — Salón 4';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_92(num):
    if num <= 1:
        return 1
    return num * calc_fact_92(num - 1)

print(calc_fact_92(5))','evaluated',87.00,'PLAGIO: salón 4 alumno 18',1,UNIX_TIMESTAMP()-60311,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al18_s04'
WHERE c.shortname='salon04' AND a.name='Factorial recursivo — Salón 4';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_93(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_93(5))','evaluated',88.00,'SOSPECHOSO: salón 4 alumno 19',1,UNIX_TIMESTAMP()-261763,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al19_s04'
WHERE c.shortname='salon04' AND a.name='Factorial recursivo — Salón 4';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_94(n):
    if n <= 1:
        return 1
    return n * factorial_94(n - 1)

print(factorial_94(5))','evaluated',89.00,'ORIGINAL: salón 4 alumno 20',1,UNIX_TIMESTAMP()-658036,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al20_s04'
WHERE c.shortname='salon04' AND a.name='Factorial recursivo — Salón 4';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_95(n):
    if n <= 1:
        return 1
    return n * factorial_95(n - 1)

print(factorial_95(5))','evaluated',90.00,'ORIGINAL: salón 4 alumno 21',1,UNIX_TIMESTAMP()-161533,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al21_s04'
WHERE c.shortname='salon04' AND a.name='Factorial recursivo — Salón 4';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_96(num):
    if num <= 1:
        return 1
    return num * calc_fact_96(num - 1)

print(calc_fact_96(5))','evaluated',91.00,'PLAGIO: salón 4 alumno 22',1,UNIX_TIMESTAMP()-1205505,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al22_s04'
WHERE c.shortname='salon04' AND a.name='Factorial recursivo — Salón 4';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_97(num):
    if num <= 1:
        return 1
    return num * calc_fact_97(num - 1)

print(calc_fact_97(5))','evaluated',92.00,'PLAGIO: salón 4 alumno 23',1,UNIX_TIMESTAMP()-658472,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al23_s04'
WHERE c.shortname='salon04' AND a.name='Factorial recursivo — Salón 4';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_98(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_98(5))','evaluated',93.00,'SOSPECHOSO: salón 4 alumno 24',1,UNIX_TIMESTAMP()-859968,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al24_s04'
WHERE c.shortname='salon04' AND a.name='Factorial recursivo — Salón 4';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_99(n):
    if n <= 1:
        return 1
    return n * factorial_99(n - 1)

print(factorial_99(5))','evaluated',94.00,'ORIGINAL: salón 4 alumno 25',1,UNIX_TIMESTAMP()-960137,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al25_s04'
WHERE c.shortname='salon04' AND a.name='Factorial recursivo — Salón 4';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_75(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_75([5,3,8,1,9]))','evaluated',70.00,'ORIGINAL: salón 4 alumno 1',1,UNIX_TIMESTAMP()-1065017,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al01_s04'
WHERE c.shortname='salon04' AND a.name='Algoritmo de ordenamiento — Salón 4';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_76(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_76([5,3,8,1,9]))','evaluated',71.00,'PLAGIO: salón 4 alumno 2',1,UNIX_TIMESTAMP()-200947,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al02_s04'
WHERE c.shortname='salon04' AND a.name='Algoritmo de ordenamiento — Salón 4';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_77(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_77([5,3,8,1,9]))','evaluated',72.00,'PLAGIO: salón 4 alumno 3',1,UNIX_TIMESTAMP()-583645,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al03_s04'
WHERE c.shortname='salon04' AND a.name='Algoritmo de ordenamiento — Salón 4';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_78(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_78(5))','evaluated',73.00,'SOSPECHOSO: salón 4 alumno 4',1,UNIX_TIMESTAMP()-682222,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al04_s04'
WHERE c.shortname='salon04' AND a.name='Algoritmo de ordenamiento — Salón 4';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_79(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_79([5,3,8,1,9]))','evaluated',74.00,'ORIGINAL: salón 4 alumno 5',1,UNIX_TIMESTAMP()-402427,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al05_s04'
WHERE c.shortname='salon04' AND a.name='Algoritmo de ordenamiento — Salón 4';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_80(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_80([5,3,8,1,9]))','evaluated',75.00,'ORIGINAL: salón 4 alumno 6',1,UNIX_TIMESTAMP()-413949,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al06_s04'
WHERE c.shortname='salon04' AND a.name='Algoritmo de ordenamiento — Salón 4';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_81(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_81([5,3,8,1,9]))','evaluated',76.00,'PLAGIO: salón 4 alumno 7',1,UNIX_TIMESTAMP()-436251,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al07_s04'
WHERE c.shortname='salon04' AND a.name='Algoritmo de ordenamiento — Salón 4';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_82(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_82([5,3,8,1,9]))','evaluated',77.00,'PLAGIO: salón 4 alumno 8',1,UNIX_TIMESTAMP()-763571,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al08_s04'
WHERE c.shortname='salon04' AND a.name='Algoritmo de ordenamiento — Salón 4';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_83(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_83(5))','evaluated',78.00,'SOSPECHOSO: salón 4 alumno 9',1,UNIX_TIMESTAMP()-857486,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al09_s04'
WHERE c.shortname='salon04' AND a.name='Algoritmo de ordenamiento — Salón 4';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_84(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_84([5,3,8,1,9]))','evaluated',79.00,'ORIGINAL: salón 4 alumno 10',1,UNIX_TIMESTAMP()-361615,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al10_s04'
WHERE c.shortname='salon04' AND a.name='Algoritmo de ordenamiento — Salón 4';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_85(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_85([5,3,8,1,9]))','evaluated',80.00,'ORIGINAL: salón 4 alumno 11',1,UNIX_TIMESTAMP()-454549,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al11_s04'
WHERE c.shortname='salon04' AND a.name='Algoritmo de ordenamiento — Salón 4';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_86(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_86([5,3,8,1,9]))','evaluated',81.00,'PLAGIO: salón 4 alumno 12',1,UNIX_TIMESTAMP()-518052,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al12_s04'
WHERE c.shortname='salon04' AND a.name='Algoritmo de ordenamiento — Salón 4';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_87(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_87([5,3,8,1,9]))','evaluated',82.00,'PLAGIO: salón 4 alumno 13',1,UNIX_TIMESTAMP()-788295,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al13_s04'
WHERE c.shortname='salon04' AND a.name='Algoritmo de ordenamiento — Salón 4';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_88(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_88(5))','evaluated',83.00,'SOSPECHOSO: salón 4 alumno 14',1,UNIX_TIMESTAMP()-595739,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al14_s04'
WHERE c.shortname='salon04' AND a.name='Algoritmo de ordenamiento — Salón 4';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_89(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_89([5,3,8,1,9]))','evaluated',84.00,'ORIGINAL: salón 4 alumno 15',1,UNIX_TIMESTAMP()-537842,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al15_s04'
WHERE c.shortname='salon04' AND a.name='Algoritmo de ordenamiento — Salón 4';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_90(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_90([5,3,8,1,9]))','evaluated',85.00,'ORIGINAL: salón 4 alumno 16',1,UNIX_TIMESTAMP()-152480,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al16_s04'
WHERE c.shortname='salon04' AND a.name='Algoritmo de ordenamiento — Salón 4';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_91(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_91([5,3,8,1,9]))','evaluated',86.00,'PLAGIO: salón 4 alumno 17',1,UNIX_TIMESTAMP()-157596,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al17_s04'
WHERE c.shortname='salon04' AND a.name='Algoritmo de ordenamiento — Salón 4';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_92(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_92([5,3,8,1,9]))','evaluated',87.00,'PLAGIO: salón 4 alumno 18',1,UNIX_TIMESTAMP()-1117597,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al18_s04'
WHERE c.shortname='salon04' AND a.name='Algoritmo de ordenamiento — Salón 4';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_93(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_93(5))','evaluated',88.00,'SOSPECHOSO: salón 4 alumno 19',1,UNIX_TIMESTAMP()-895090,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al19_s04'
WHERE c.shortname='salon04' AND a.name='Algoritmo de ordenamiento — Salón 4';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_94(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_94([5,3,8,1,9]))','evaluated',89.00,'ORIGINAL: salón 4 alumno 20',1,UNIX_TIMESTAMP()-905007,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al20_s04'
WHERE c.shortname='salon04' AND a.name='Algoritmo de ordenamiento — Salón 4';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_95(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_95([5,3,8,1,9]))','evaluated',90.00,'ORIGINAL: salón 4 alumno 21',1,UNIX_TIMESTAMP()-641439,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al21_s04'
WHERE c.shortname='salon04' AND a.name='Algoritmo de ordenamiento — Salón 4';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_96(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_96([5,3,8,1,9]))','evaluated',91.00,'PLAGIO: salón 4 alumno 22',1,UNIX_TIMESTAMP()-700399,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al22_s04'
WHERE c.shortname='salon04' AND a.name='Algoritmo de ordenamiento — Salón 4';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_97(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_97([5,3,8,1,9]))','evaluated',92.00,'PLAGIO: salón 4 alumno 23',1,UNIX_TIMESTAMP()-737156,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al23_s04'
WHERE c.shortname='salon04' AND a.name='Algoritmo de ordenamiento — Salón 4';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_98(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_98(5))','evaluated',93.00,'SOSPECHOSO: salón 4 alumno 24',1,UNIX_TIMESTAMP()-925878,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al24_s04'
WHERE c.shortname='salon04' AND a.name='Algoritmo de ordenamiento — Salón 4';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_99(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_99([5,3,8,1,9]))','evaluated',94.00,'ORIGINAL: salón 4 alumno 25',1,UNIX_TIMESTAMP()-267379,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al25_s04'
WHERE c.shortname='salon04' AND a.name='Algoritmo de ordenamiento — Salón 4';

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_100(n):
    if n <= 1:
        return 1
    return n * factorial_100(n - 1)

print(factorial_100(5))','evaluated',70.00,'ORIGINAL: salón 5 alumno 1',1,UNIX_TIMESTAMP()-862167,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al01_s05'
WHERE c.shortname='salon05' AND a.name='Factorial recursivo — Salón 5';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_101(num):
    if num <= 1:
        return 1
    return num * calc_fact_101(num - 1)

print(calc_fact_101(5))','evaluated',71.00,'PLAGIO: salón 5 alumno 2',1,UNIX_TIMESTAMP()-731018,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al02_s05'
WHERE c.shortname='salon05' AND a.name='Factorial recursivo — Salón 5';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_102(num):
    if num <= 1:
        return 1
    return num * calc_fact_102(num - 1)

print(calc_fact_102(5))','evaluated',72.00,'PLAGIO: salón 5 alumno 3',1,UNIX_TIMESTAMP()-701190,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al03_s05'
WHERE c.shortname='salon05' AND a.name='Factorial recursivo — Salón 5';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_103(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_103(5))','evaluated',73.00,'SOSPECHOSO: salón 5 alumno 4',1,UNIX_TIMESTAMP()-529693,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al04_s05'
WHERE c.shortname='salon05' AND a.name='Factorial recursivo — Salón 5';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_104(n):
    if n <= 1:
        return 1
    return n * factorial_104(n - 1)

print(factorial_104(5))','evaluated',74.00,'ORIGINAL: salón 5 alumno 5',1,UNIX_TIMESTAMP()-589417,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al05_s05'
WHERE c.shortname='salon05' AND a.name='Factorial recursivo — Salón 5';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_105(n):
    if n <= 1:
        return 1
    return n * factorial_105(n - 1)

print(factorial_105(5))','evaluated',75.00,'ORIGINAL: salón 5 alumno 6',1,UNIX_TIMESTAMP()-938411,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al06_s05'
WHERE c.shortname='salon05' AND a.name='Factorial recursivo — Salón 5';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_106(num):
    if num <= 1:
        return 1
    return num * calc_fact_106(num - 1)

print(calc_fact_106(5))','evaluated',76.00,'PLAGIO: salón 5 alumno 7',1,UNIX_TIMESTAMP()-994470,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al07_s05'
WHERE c.shortname='salon05' AND a.name='Factorial recursivo — Salón 5';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_107(num):
    if num <= 1:
        return 1
    return num * calc_fact_107(num - 1)

print(calc_fact_107(5))','evaluated',77.00,'PLAGIO: salón 5 alumno 8',1,UNIX_TIMESTAMP()-181434,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al08_s05'
WHERE c.shortname='salon05' AND a.name='Factorial recursivo — Salón 5';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_108(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_108(5))','evaluated',78.00,'SOSPECHOSO: salón 5 alumno 9',1,UNIX_TIMESTAMP()-550545,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al09_s05'
WHERE c.shortname='salon05' AND a.name='Factorial recursivo — Salón 5';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_109(n):
    if n <= 1:
        return 1
    return n * factorial_109(n - 1)

print(factorial_109(5))','evaluated',79.00,'ORIGINAL: salón 5 alumno 10',1,UNIX_TIMESTAMP()-176418,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al10_s05'
WHERE c.shortname='salon05' AND a.name='Factorial recursivo — Salón 5';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_110(n):
    if n <= 1:
        return 1
    return n * factorial_110(n - 1)

print(factorial_110(5))','evaluated',80.00,'ORIGINAL: salón 5 alumno 11',1,UNIX_TIMESTAMP()-737646,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al11_s05'
WHERE c.shortname='salon05' AND a.name='Factorial recursivo — Salón 5';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_111(num):
    if num <= 1:
        return 1
    return num * calc_fact_111(num - 1)

print(calc_fact_111(5))','evaluated',81.00,'PLAGIO: salón 5 alumno 12',1,UNIX_TIMESTAMP()-786700,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al12_s05'
WHERE c.shortname='salon05' AND a.name='Factorial recursivo — Salón 5';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_112(num):
    if num <= 1:
        return 1
    return num * calc_fact_112(num - 1)

print(calc_fact_112(5))','evaluated',82.00,'PLAGIO: salón 5 alumno 13',1,UNIX_TIMESTAMP()-806817,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al13_s05'
WHERE c.shortname='salon05' AND a.name='Factorial recursivo — Salón 5';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_113(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_113(5))','evaluated',83.00,'SOSPECHOSO: salón 5 alumno 14',1,UNIX_TIMESTAMP()-91020,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al14_s05'
WHERE c.shortname='salon05' AND a.name='Factorial recursivo — Salón 5';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_114(n):
    if n <= 1:
        return 1
    return n * factorial_114(n - 1)

print(factorial_114(5))','evaluated',84.00,'ORIGINAL: salón 5 alumno 15',1,UNIX_TIMESTAMP()-1173570,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al15_s05'
WHERE c.shortname='salon05' AND a.name='Factorial recursivo — Salón 5';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_115(n):
    if n <= 1:
        return 1
    return n * factorial_115(n - 1)

print(factorial_115(5))','evaluated',85.00,'ORIGINAL: salón 5 alumno 16',1,UNIX_TIMESTAMP()-939821,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al16_s05'
WHERE c.shortname='salon05' AND a.name='Factorial recursivo — Salón 5';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_116(num):
    if num <= 1:
        return 1
    return num * calc_fact_116(num - 1)

print(calc_fact_116(5))','evaluated',86.00,'PLAGIO: salón 5 alumno 17',1,UNIX_TIMESTAMP()-82125,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al17_s05'
WHERE c.shortname='salon05' AND a.name='Factorial recursivo — Salón 5';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_117(num):
    if num <= 1:
        return 1
    return num * calc_fact_117(num - 1)

print(calc_fact_117(5))','evaluated',87.00,'PLAGIO: salón 5 alumno 18',1,UNIX_TIMESTAMP()-792818,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al18_s05'
WHERE c.shortname='salon05' AND a.name='Factorial recursivo — Salón 5';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_118(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_118(5))','evaluated',88.00,'SOSPECHOSO: salón 5 alumno 19',1,UNIX_TIMESTAMP()-865030,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al19_s05'
WHERE c.shortname='salon05' AND a.name='Factorial recursivo — Salón 5';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_119(n):
    if n <= 1:
        return 1
    return n * factorial_119(n - 1)

print(factorial_119(5))','evaluated',89.00,'ORIGINAL: salón 5 alumno 20',1,UNIX_TIMESTAMP()-654408,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al20_s05'
WHERE c.shortname='salon05' AND a.name='Factorial recursivo — Salón 5';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_120(n):
    if n <= 1:
        return 1
    return n * factorial_120(n - 1)

print(factorial_120(5))','evaluated',90.00,'ORIGINAL: salón 5 alumno 21',1,UNIX_TIMESTAMP()-369401,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al21_s05'
WHERE c.shortname='salon05' AND a.name='Factorial recursivo — Salón 5';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_121(num):
    if num <= 1:
        return 1
    return num * calc_fact_121(num - 1)

print(calc_fact_121(5))','evaluated',91.00,'PLAGIO: salón 5 alumno 22',1,UNIX_TIMESTAMP()-943459,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al22_s05'
WHERE c.shortname='salon05' AND a.name='Factorial recursivo — Salón 5';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_122(num):
    if num <= 1:
        return 1
    return num * calc_fact_122(num - 1)

print(calc_fact_122(5))','evaluated',92.00,'PLAGIO: salón 5 alumno 23',1,UNIX_TIMESTAMP()-492811,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al23_s05'
WHERE c.shortname='salon05' AND a.name='Factorial recursivo — Salón 5';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_123(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_123(5))','evaluated',93.00,'SOSPECHOSO: salón 5 alumno 24',1,UNIX_TIMESTAMP()-1051597,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al24_s05'
WHERE c.shortname='salon05' AND a.name='Factorial recursivo — Salón 5';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_124(n):
    if n <= 1:
        return 1
    return n * factorial_124(n - 1)

print(factorial_124(5))','evaluated',94.00,'ORIGINAL: salón 5 alumno 25',1,UNIX_TIMESTAMP()-1082710,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al25_s05'
WHERE c.shortname='salon05' AND a.name='Factorial recursivo — Salón 5';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_100(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_100([5,3,8,1,9]))','evaluated',70.00,'ORIGINAL: salón 5 alumno 1',1,UNIX_TIMESTAMP()-322705,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al01_s05'
WHERE c.shortname='salon05' AND a.name='Algoritmo de ordenamiento — Salón 5';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_101(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_101([5,3,8,1,9]))','evaluated',71.00,'PLAGIO: salón 5 alumno 2',1,UNIX_TIMESTAMP()-930151,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al02_s05'
WHERE c.shortname='salon05' AND a.name='Algoritmo de ordenamiento — Salón 5';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_102(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_102([5,3,8,1,9]))','evaluated',72.00,'PLAGIO: salón 5 alumno 3',1,UNIX_TIMESTAMP()-270832,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al03_s05'
WHERE c.shortname='salon05' AND a.name='Algoritmo de ordenamiento — Salón 5';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_103(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_103(5))','evaluated',73.00,'SOSPECHOSO: salón 5 alumno 4',1,UNIX_TIMESTAMP()-960269,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al04_s05'
WHERE c.shortname='salon05' AND a.name='Algoritmo de ordenamiento — Salón 5';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_104(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_104([5,3,8,1,9]))','evaluated',74.00,'ORIGINAL: salón 5 alumno 5',1,UNIX_TIMESTAMP()-932876,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al05_s05'
WHERE c.shortname='salon05' AND a.name='Algoritmo de ordenamiento — Salón 5';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_105(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_105([5,3,8,1,9]))','evaluated',75.00,'ORIGINAL: salón 5 alumno 6',1,UNIX_TIMESTAMP()-689823,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al06_s05'
WHERE c.shortname='salon05' AND a.name='Algoritmo de ordenamiento — Salón 5';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_106(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_106([5,3,8,1,9]))','evaluated',76.00,'PLAGIO: salón 5 alumno 7',1,UNIX_TIMESTAMP()-668578,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al07_s05'
WHERE c.shortname='salon05' AND a.name='Algoritmo de ordenamiento — Salón 5';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_107(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_107([5,3,8,1,9]))','evaluated',77.00,'PLAGIO: salón 5 alumno 8',1,UNIX_TIMESTAMP()-822952,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al08_s05'
WHERE c.shortname='salon05' AND a.name='Algoritmo de ordenamiento — Salón 5';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_108(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_108(5))','evaluated',78.00,'SOSPECHOSO: salón 5 alumno 9',1,UNIX_TIMESTAMP()-844997,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al09_s05'
WHERE c.shortname='salon05' AND a.name='Algoritmo de ordenamiento — Salón 5';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_109(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_109([5,3,8,1,9]))','evaluated',79.00,'ORIGINAL: salón 5 alumno 10',1,UNIX_TIMESTAMP()-523659,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al10_s05'
WHERE c.shortname='salon05' AND a.name='Algoritmo de ordenamiento — Salón 5';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_110(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_110([5,3,8,1,9]))','evaluated',80.00,'ORIGINAL: salón 5 alumno 11',1,UNIX_TIMESTAMP()-638790,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al11_s05'
WHERE c.shortname='salon05' AND a.name='Algoritmo de ordenamiento — Salón 5';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_111(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_111([5,3,8,1,9]))','evaluated',81.00,'PLAGIO: salón 5 alumno 12',1,UNIX_TIMESTAMP()-846898,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al12_s05'
WHERE c.shortname='salon05' AND a.name='Algoritmo de ordenamiento — Salón 5';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_112(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_112([5,3,8,1,9]))','evaluated',82.00,'PLAGIO: salón 5 alumno 13',1,UNIX_TIMESTAMP()-686761,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al13_s05'
WHERE c.shortname='salon05' AND a.name='Algoritmo de ordenamiento — Salón 5';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_113(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_113(5))','evaluated',83.00,'SOSPECHOSO: salón 5 alumno 14',1,UNIX_TIMESTAMP()-27028,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al14_s05'
WHERE c.shortname='salon05' AND a.name='Algoritmo de ordenamiento — Salón 5';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_114(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_114([5,3,8,1,9]))','evaluated',84.00,'ORIGINAL: salón 5 alumno 15',1,UNIX_TIMESTAMP()-524556,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al15_s05'
WHERE c.shortname='salon05' AND a.name='Algoritmo de ordenamiento — Salón 5';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_115(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_115([5,3,8,1,9]))','evaluated',85.00,'ORIGINAL: salón 5 alumno 16',1,UNIX_TIMESTAMP()-1118632,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al16_s05'
WHERE c.shortname='salon05' AND a.name='Algoritmo de ordenamiento — Salón 5';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_116(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_116([5,3,8,1,9]))','evaluated',86.00,'PLAGIO: salón 5 alumno 17',1,UNIX_TIMESTAMP()-980162,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al17_s05'
WHERE c.shortname='salon05' AND a.name='Algoritmo de ordenamiento — Salón 5';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_117(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_117([5,3,8,1,9]))','evaluated',87.00,'PLAGIO: salón 5 alumno 18',1,UNIX_TIMESTAMP()-892908,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al18_s05'
WHERE c.shortname='salon05' AND a.name='Algoritmo de ordenamiento — Salón 5';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_118(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_118(5))','evaluated',88.00,'SOSPECHOSO: salón 5 alumno 19',1,UNIX_TIMESTAMP()-206754,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al19_s05'
WHERE c.shortname='salon05' AND a.name='Algoritmo de ordenamiento — Salón 5';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_119(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_119([5,3,8,1,9]))','evaluated',89.00,'ORIGINAL: salón 5 alumno 20',1,UNIX_TIMESTAMP()-383618,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al20_s05'
WHERE c.shortname='salon05' AND a.name='Algoritmo de ordenamiento — Salón 5';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_120(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_120([5,3,8,1,9]))','evaluated',90.00,'ORIGINAL: salón 5 alumno 21',1,UNIX_TIMESTAMP()-141080,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al21_s05'
WHERE c.shortname='salon05' AND a.name='Algoritmo de ordenamiento — Salón 5';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_121(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_121([5,3,8,1,9]))','evaluated',91.00,'PLAGIO: salón 5 alumno 22',1,UNIX_TIMESTAMP()-625235,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al22_s05'
WHERE c.shortname='salon05' AND a.name='Algoritmo de ordenamiento — Salón 5';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_122(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_122([5,3,8,1,9]))','evaluated',92.00,'PLAGIO: salón 5 alumno 23',1,UNIX_TIMESTAMP()-953163,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al23_s05'
WHERE c.shortname='salon05' AND a.name='Algoritmo de ordenamiento — Salón 5';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_123(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_123(5))','evaluated',93.00,'SOSPECHOSO: salón 5 alumno 24',1,UNIX_TIMESTAMP()-733514,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al24_s05'
WHERE c.shortname='salon05' AND a.name='Algoritmo de ordenamiento — Salón 5';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_124(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_124([5,3,8,1,9]))','evaluated',94.00,'ORIGINAL: salón 5 alumno 25',1,UNIX_TIMESTAMP()-304730,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al25_s05'
WHERE c.shortname='salon05' AND a.name='Algoritmo de ordenamiento — Salón 5';

INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_125(n):
    if n <= 1:
        return 1
    return n * factorial_125(n - 1)

print(factorial_125(5))','evaluated',70.00,'ORIGINAL: salón 6 alumno 1',1,UNIX_TIMESTAMP()-1056728,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al01_s06'
WHERE c.shortname='salon06' AND a.name='Factorial recursivo — Salón 6';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_126(num):
    if num <= 1:
        return 1
    return num * calc_fact_126(num - 1)

print(calc_fact_126(5))','evaluated',71.00,'PLAGIO: salón 6 alumno 2',1,UNIX_TIMESTAMP()-718039,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al02_s06'
WHERE c.shortname='salon06' AND a.name='Factorial recursivo — Salón 6';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_127(num):
    if num <= 1:
        return 1
    return num * calc_fact_127(num - 1)

print(calc_fact_127(5))','evaluated',72.00,'PLAGIO: salón 6 alumno 3',1,UNIX_TIMESTAMP()-775825,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al03_s06'
WHERE c.shortname='salon06' AND a.name='Factorial recursivo — Salón 6';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_128(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_128(5))','evaluated',73.00,'SOSPECHOSO: salón 6 alumno 4',1,UNIX_TIMESTAMP()-602580,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al04_s06'
WHERE c.shortname='salon06' AND a.name='Factorial recursivo — Salón 6';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_129(n):
    if n <= 1:
        return 1
    return n * factorial_129(n - 1)

print(factorial_129(5))','evaluated',74.00,'ORIGINAL: salón 6 alumno 5',1,UNIX_TIMESTAMP()-529750,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al05_s06'
WHERE c.shortname='salon06' AND a.name='Factorial recursivo — Salón 6';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_130(n):
    if n <= 1:
        return 1
    return n * factorial_130(n - 1)

print(factorial_130(5))','evaluated',75.00,'ORIGINAL: salón 6 alumno 6',1,UNIX_TIMESTAMP()-216652,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al06_s06'
WHERE c.shortname='salon06' AND a.name='Factorial recursivo — Salón 6';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_131(num):
    if num <= 1:
        return 1
    return num * calc_fact_131(num - 1)

print(calc_fact_131(5))','evaluated',76.00,'PLAGIO: salón 6 alumno 7',1,UNIX_TIMESTAMP()-1093265,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al07_s06'
WHERE c.shortname='salon06' AND a.name='Factorial recursivo — Salón 6';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_132(num):
    if num <= 1:
        return 1
    return num * calc_fact_132(num - 1)

print(calc_fact_132(5))','evaluated',77.00,'PLAGIO: salón 6 alumno 8',1,UNIX_TIMESTAMP()-559462,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al08_s06'
WHERE c.shortname='salon06' AND a.name='Factorial recursivo — Salón 6';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_133(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_133(5))','evaluated',78.00,'SOSPECHOSO: salón 6 alumno 9',1,UNIX_TIMESTAMP()-148064,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al09_s06'
WHERE c.shortname='salon06' AND a.name='Factorial recursivo — Salón 6';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_134(n):
    if n <= 1:
        return 1
    return n * factorial_134(n - 1)

print(factorial_134(5))','evaluated',79.00,'ORIGINAL: salón 6 alumno 10',1,UNIX_TIMESTAMP()-307197,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al10_s06'
WHERE c.shortname='salon06' AND a.name='Factorial recursivo — Salón 6';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_135(n):
    if n <= 1:
        return 1
    return n * factorial_135(n - 1)

print(factorial_135(5))','evaluated',80.00,'ORIGINAL: salón 6 alumno 11',1,UNIX_TIMESTAMP()-644659,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al11_s06'
WHERE c.shortname='salon06' AND a.name='Factorial recursivo — Salón 6';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_136(num):
    if num <= 1:
        return 1
    return num * calc_fact_136(num - 1)

print(calc_fact_136(5))','evaluated',81.00,'PLAGIO: salón 6 alumno 12',1,UNIX_TIMESTAMP()-128193,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al12_s06'
WHERE c.shortname='salon06' AND a.name='Factorial recursivo — Salón 6';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_137(num):
    if num <= 1:
        return 1
    return num * calc_fact_137(num - 1)

print(calc_fact_137(5))','evaluated',82.00,'PLAGIO: salón 6 alumno 13',1,UNIX_TIMESTAMP()-868843,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al13_s06'
WHERE c.shortname='salon06' AND a.name='Factorial recursivo — Salón 6';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_138(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_138(5))','evaluated',83.00,'SOSPECHOSO: salón 6 alumno 14',1,UNIX_TIMESTAMP()-652028,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al14_s06'
WHERE c.shortname='salon06' AND a.name='Factorial recursivo — Salón 6';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_139(n):
    if n <= 1:
        return 1
    return n * factorial_139(n - 1)

print(factorial_139(5))','evaluated',84.00,'ORIGINAL: salón 6 alumno 15',1,UNIX_TIMESTAMP()-841808,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al15_s06'
WHERE c.shortname='salon06' AND a.name='Factorial recursivo — Salón 6';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_140(n):
    if n <= 1:
        return 1
    return n * factorial_140(n - 1)

print(factorial_140(5))','evaluated',85.00,'ORIGINAL: salón 6 alumno 16',1,UNIX_TIMESTAMP()-304800,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al16_s06'
WHERE c.shortname='salon06' AND a.name='Factorial recursivo — Salón 6';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_141(num):
    if num <= 1:
        return 1
    return num * calc_fact_141(num - 1)

print(calc_fact_141(5))','evaluated',86.00,'PLAGIO: salón 6 alumno 17',1,UNIX_TIMESTAMP()-342383,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al17_s06'
WHERE c.shortname='salon06' AND a.name='Factorial recursivo — Salón 6';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_142(num):
    if num <= 1:
        return 1
    return num * calc_fact_142(num - 1)

print(calc_fact_142(5))','evaluated',87.00,'PLAGIO: salón 6 alumno 18',1,UNIX_TIMESTAMP()-381881,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al18_s06'
WHERE c.shortname='salon06' AND a.name='Factorial recursivo — Salón 6';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_143(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_143(5))','evaluated',88.00,'SOSPECHOSO: salón 6 alumno 19',1,UNIX_TIMESTAMP()-649209,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al19_s06'
WHERE c.shortname='salon06' AND a.name='Factorial recursivo — Salón 6';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_144(n):
    if n <= 1:
        return 1
    return n * factorial_144(n - 1)

print(factorial_144(5))','evaluated',89.00,'ORIGINAL: salón 6 alumno 20',1,UNIX_TIMESTAMP()-88495,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al20_s06'
WHERE c.shortname='salon06' AND a.name='Factorial recursivo — Salón 6';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_145(n):
    if n <= 1:
        return 1
    return n * factorial_145(n - 1)

print(factorial_145(5))','evaluated',90.00,'ORIGINAL: salón 6 alumno 21',1,UNIX_TIMESTAMP()-1111277,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al21_s06'
WHERE c.shortname='salon06' AND a.name='Factorial recursivo — Salón 6';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_146(num):
    if num <= 1:
        return 1
    return num * calc_fact_146(num - 1)

print(calc_fact_146(5))','evaluated',91.00,'PLAGIO: salón 6 alumno 22',1,UNIX_TIMESTAMP()-839907,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al22_s06'
WHERE c.shortname='salon06' AND a.name='Factorial recursivo — Salón 6';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def calc_fact_147(num):
    if num <= 1:
        return 1
    return num * calc_fact_147(num - 1)

print(calc_fact_147(5))','evaluated',92.00,'PLAGIO: salón 6 alumno 23',1,UNIX_TIMESTAMP()-417967,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al23_s06'
WHERE c.shortname='salon06' AND a.name='Factorial recursivo — Salón 6';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_148(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_148(5))','evaluated',93.00,'SOSPECHOSO: salón 6 alumno 24',1,UNIX_TIMESTAMP()-575905,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al24_s06'
WHERE c.shortname='salon06' AND a.name='Factorial recursivo — Salón 6';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def factorial_149(n):
    if n <= 1:
        return 1
    return n * factorial_149(n - 1)

print(factorial_149(5))','evaluated',94.00,'ORIGINAL: salón 6 alumno 25',1,UNIX_TIMESTAMP()-363611,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al25_s06'
WHERE c.shortname='salon06' AND a.name='Factorial recursivo — Salón 6';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_125(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_125([5,3,8,1,9]))','evaluated',70.00,'ORIGINAL: salón 6 alumno 1',1,UNIX_TIMESTAMP()-961985,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al01_s06'
WHERE c.shortname='salon06' AND a.name='Algoritmo de ordenamiento — Salón 6';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_126(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_126([5,3,8,1,9]))','evaluated',71.00,'PLAGIO: salón 6 alumno 2',1,UNIX_TIMESTAMP()-90669,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al02_s06'
WHERE c.shortname='salon06' AND a.name='Algoritmo de ordenamiento — Salón 6';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_127(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_127([5,3,8,1,9]))','evaluated',72.00,'PLAGIO: salón 6 alumno 3',1,UNIX_TIMESTAMP()-804498,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al03_s06'
WHERE c.shortname='salon06' AND a.name='Algoritmo de ordenamiento — Salón 6';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_128(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_128(5))','evaluated',73.00,'SOSPECHOSO: salón 6 alumno 4',1,UNIX_TIMESTAMP()-354136,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al04_s06'
WHERE c.shortname='salon06' AND a.name='Algoritmo de ordenamiento — Salón 6';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_129(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_129([5,3,8,1,9]))','evaluated',74.00,'ORIGINAL: salón 6 alumno 5',1,UNIX_TIMESTAMP()-108773,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al05_s06'
WHERE c.shortname='salon06' AND a.name='Algoritmo de ordenamiento — Salón 6';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_130(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_130([5,3,8,1,9]))','evaluated',75.00,'ORIGINAL: salón 6 alumno 6',1,UNIX_TIMESTAMP()-1080930,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al06_s06'
WHERE c.shortname='salon06' AND a.name='Algoritmo de ordenamiento — Salón 6';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_131(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_131([5,3,8,1,9]))','evaluated',76.00,'PLAGIO: salón 6 alumno 7',1,UNIX_TIMESTAMP()-195207,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al07_s06'
WHERE c.shortname='salon06' AND a.name='Algoritmo de ordenamiento — Salón 6';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_132(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_132([5,3,8,1,9]))','evaluated',77.00,'PLAGIO: salón 6 alumno 8',1,UNIX_TIMESTAMP()-1086115,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al08_s06'
WHERE c.shortname='salon06' AND a.name='Algoritmo de ordenamiento — Salón 6';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_133(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_133(5))','evaluated',78.00,'SOSPECHOSO: salón 6 alumno 9',1,UNIX_TIMESTAMP()-1160673,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al09_s06'
WHERE c.shortname='salon06' AND a.name='Algoritmo de ordenamiento — Salón 6';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_134(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_134([5,3,8,1,9]))','evaluated',79.00,'ORIGINAL: salón 6 alumno 10',1,UNIX_TIMESTAMP()-37394,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al10_s06'
WHERE c.shortname='salon06' AND a.name='Algoritmo de ordenamiento — Salón 6';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_135(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_135([5,3,8,1,9]))','evaluated',80.00,'ORIGINAL: salón 6 alumno 11',1,UNIX_TIMESTAMP()-129046,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al11_s06'
WHERE c.shortname='salon06' AND a.name='Algoritmo de ordenamiento — Salón 6';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_136(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_136([5,3,8,1,9]))','evaluated',81.00,'PLAGIO: salón 6 alumno 12',1,UNIX_TIMESTAMP()-1070114,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al12_s06'
WHERE c.shortname='salon06' AND a.name='Algoritmo de ordenamiento — Salón 6';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_137(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_137([5,3,8,1,9]))','evaluated',82.00,'PLAGIO: salón 6 alumno 13',1,UNIX_TIMESTAMP()-516785,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al13_s06'
WHERE c.shortname='salon06' AND a.name='Algoritmo de ordenamiento — Salón 6';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_138(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_138(5))','evaluated',83.00,'SOSPECHOSO: salón 6 alumno 14',1,UNIX_TIMESTAMP()-406187,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al14_s06'
WHERE c.shortname='salon06' AND a.name='Algoritmo de ordenamiento — Salón 6';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_139(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_139([5,3,8,1,9]))','evaluated',84.00,'ORIGINAL: salón 6 alumno 15',1,UNIX_TIMESTAMP()-371242,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al15_s06'
WHERE c.shortname='salon06' AND a.name='Algoritmo de ordenamiento — Salón 6';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_140(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_140([5,3,8,1,9]))','evaluated',85.00,'ORIGINAL: salón 6 alumno 16',1,UNIX_TIMESTAMP()-29099,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al16_s06'
WHERE c.shortname='salon06' AND a.name='Algoritmo de ordenamiento — Salón 6';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_141(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_141([5,3,8,1,9]))','evaluated',86.00,'PLAGIO: salón 6 alumno 17',1,UNIX_TIMESTAMP()-522994,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al17_s06'
WHERE c.shortname='salon06' AND a.name='Algoritmo de ordenamiento — Salón 6';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_142(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_142([5,3,8,1,9]))','evaluated',87.00,'PLAGIO: salón 6 alumno 18',1,UNIX_TIMESTAMP()-964680,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al18_s06'
WHERE c.shortname='salon06' AND a.name='Algoritmo de ordenamiento — Salón 6';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_143(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_143(5))','evaluated',88.00,'SOSPECHOSO: salón 6 alumno 19',1,UNIX_TIMESTAMP()-520556,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al19_s06'
WHERE c.shortname='salon06' AND a.name='Algoritmo de ordenamiento — Salón 6';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_144(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_144([5,3,8,1,9]))','evaluated',89.00,'ORIGINAL: salón 6 alumno 20',1,UNIX_TIMESTAMP()-529637,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al20_s06'
WHERE c.shortname='salon06' AND a.name='Algoritmo de ordenamiento — Salón 6';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_145(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_145([5,3,8,1,9]))','evaluated',90.00,'ORIGINAL: salón 6 alumno 21',1,UNIX_TIMESTAMP()-553000,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al21_s06'
WHERE c.shortname='salon06' AND a.name='Algoritmo de ordenamiento — Salón 6';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_146(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_146([5,3,8,1,9]))','evaluated',91.00,'PLAGIO: salón 6 alumno 22',1,UNIX_TIMESTAMP()-119152,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al22_s06'
WHERE c.shortname='salon06' AND a.name='Algoritmo de ordenamiento — Salón 6';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def ordenar_147(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(ordenar_147([5,3,8,1,9]))','evaluated',92.00,'PLAGIO: salón 6 alumno 23',1,UNIX_TIMESTAMP()-918911,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al23_s06'
WHERE c.shortname='salon06' AND a.name='Algoritmo de ordenamiento — Salón 6';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def fact_iter_148(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(fact_iter_148(5))','evaluated',93.00,'SOSPECHOSO: salón 6 alumno 24',1,UNIX_TIMESTAMP()-1150291,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al24_s06'
WHERE c.shortname='salon06' AND a.name='Algoritmo de ordenamiento — Salón 6';
INSERT INTO oy1n_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id,u.id,'def bubble_sort_149(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort_149([5,3,8,1,9]))','evaluated',94.00,'ORIGINAL: salón 6 alumno 25',1,UNIX_TIMESTAMP()-363552,UNIX_TIMESTAMP()
FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id JOIN oy1n_user u ON u.username='al25_s06'
WHERE c.shortname='salon06' AND a.name='Algoritmo de ordenamiento — Salón 6';

-- ══════════════════════════════════════════════════════════════
-- PASO 10: Insertar evaluaciones con scores de plagio
-- ══════════════════════════════════════════════════════════════
INSERT INTO oy1n_aiassignment_evaluations (submission,similarity_score,ai_feedback,ai_analysis,timecreated)
SELECT s.id,
  CASE
    WHEN MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),5) IN (1,2) THEN 75 + MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),20)
    WHEN MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),5) = 3     THEN 45 + MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),25)
    ELSE 5 + MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),18)
  END,
  s.feedback,'{}',UNIX_TIMESTAMP()
FROM oy1n_aiassignment_submissions s
JOIN oy1n_user u ON s.userid=u.id
JOIN oy1n_aiassignment a ON s.assignment=a.id
WHERE a.name='Factorial recursivo — Salón 1' AND u.username LIKE 'al%_s01'
AND NOT EXISTS (SELECT 1 FROM oy1n_aiassignment_evaluations e WHERE e.submission=s.id);

INSERT INTO oy1n_aiassignment_evaluations (submission,similarity_score,ai_feedback,ai_analysis,timecreated)
SELECT s.id,
  CASE
    WHEN MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),5) IN (1,2) THEN 75 + MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),20)
    WHEN MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),5) = 3     THEN 45 + MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),25)
    ELSE 5 + MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),18)
  END,
  s.feedback,'{}',UNIX_TIMESTAMP()
FROM oy1n_aiassignment_submissions s
JOIN oy1n_user u ON s.userid=u.id
JOIN oy1n_aiassignment a ON s.assignment=a.id
WHERE a.name='Algoritmo de ordenamiento — Salón 1' AND u.username LIKE 'al%_s01'
AND NOT EXISTS (SELECT 1 FROM oy1n_aiassignment_evaluations e WHERE e.submission=s.id);

INSERT INTO oy1n_aiassignment_evaluations (submission,similarity_score,ai_feedback,ai_analysis,timecreated)
SELECT s.id,
  CASE
    WHEN MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),5) IN (1,2) THEN 75 + MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),20)
    WHEN MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),5) = 3     THEN 45 + MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),25)
    ELSE 5 + MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),18)
  END,
  s.feedback,'{}',UNIX_TIMESTAMP()
FROM oy1n_aiassignment_submissions s
JOIN oy1n_user u ON s.userid=u.id
JOIN oy1n_aiassignment a ON s.assignment=a.id
WHERE a.name='Factorial recursivo — Salón 2' AND u.username LIKE 'al%_s02'
AND NOT EXISTS (SELECT 1 FROM oy1n_aiassignment_evaluations e WHERE e.submission=s.id);

INSERT INTO oy1n_aiassignment_evaluations (submission,similarity_score,ai_feedback,ai_analysis,timecreated)
SELECT s.id,
  CASE
    WHEN MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),5) IN (1,2) THEN 75 + MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),20)
    WHEN MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),5) = 3     THEN 45 + MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),25)
    ELSE 5 + MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),18)
  END,
  s.feedback,'{}',UNIX_TIMESTAMP()
FROM oy1n_aiassignment_submissions s
JOIN oy1n_user u ON s.userid=u.id
JOIN oy1n_aiassignment a ON s.assignment=a.id
WHERE a.name='Algoritmo de ordenamiento — Salón 2' AND u.username LIKE 'al%_s02'
AND NOT EXISTS (SELECT 1 FROM oy1n_aiassignment_evaluations e WHERE e.submission=s.id);

INSERT INTO oy1n_aiassignment_evaluations (submission,similarity_score,ai_feedback,ai_analysis,timecreated)
SELECT s.id,
  CASE
    WHEN MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),5) IN (1,2) THEN 75 + MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),20)
    WHEN MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),5) = 3     THEN 45 + MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),25)
    ELSE 5 + MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),18)
  END,
  s.feedback,'{}',UNIX_TIMESTAMP()
FROM oy1n_aiassignment_submissions s
JOIN oy1n_user u ON s.userid=u.id
JOIN oy1n_aiassignment a ON s.assignment=a.id
WHERE a.name='Factorial recursivo — Salón 3' AND u.username LIKE 'al%_s03'
AND NOT EXISTS (SELECT 1 FROM oy1n_aiassignment_evaluations e WHERE e.submission=s.id);

INSERT INTO oy1n_aiassignment_evaluations (submission,similarity_score,ai_feedback,ai_analysis,timecreated)
SELECT s.id,
  CASE
    WHEN MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),5) IN (1,2) THEN 75 + MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),20)
    WHEN MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),5) = 3     THEN 45 + MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),25)
    ELSE 5 + MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),18)
  END,
  s.feedback,'{}',UNIX_TIMESTAMP()
FROM oy1n_aiassignment_submissions s
JOIN oy1n_user u ON s.userid=u.id
JOIN oy1n_aiassignment a ON s.assignment=a.id
WHERE a.name='Algoritmo de ordenamiento — Salón 3' AND u.username LIKE 'al%_s03'
AND NOT EXISTS (SELECT 1 FROM oy1n_aiassignment_evaluations e WHERE e.submission=s.id);

INSERT INTO oy1n_aiassignment_evaluations (submission,similarity_score,ai_feedback,ai_analysis,timecreated)
SELECT s.id,
  CASE
    WHEN MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),5) IN (1,2) THEN 75 + MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),20)
    WHEN MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),5) = 3     THEN 45 + MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),25)
    ELSE 5 + MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),18)
  END,
  s.feedback,'{}',UNIX_TIMESTAMP()
FROM oy1n_aiassignment_submissions s
JOIN oy1n_user u ON s.userid=u.id
JOIN oy1n_aiassignment a ON s.assignment=a.id
WHERE a.name='Factorial recursivo — Salón 4' AND u.username LIKE 'al%_s04'
AND NOT EXISTS (SELECT 1 FROM oy1n_aiassignment_evaluations e WHERE e.submission=s.id);

INSERT INTO oy1n_aiassignment_evaluations (submission,similarity_score,ai_feedback,ai_analysis,timecreated)
SELECT s.id,
  CASE
    WHEN MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),5) IN (1,2) THEN 75 + MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),20)
    WHEN MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),5) = 3     THEN 45 + MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),25)
    ELSE 5 + MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),18)
  END,
  s.feedback,'{}',UNIX_TIMESTAMP()
FROM oy1n_aiassignment_submissions s
JOIN oy1n_user u ON s.userid=u.id
JOIN oy1n_aiassignment a ON s.assignment=a.id
WHERE a.name='Algoritmo de ordenamiento — Salón 4' AND u.username LIKE 'al%_s04'
AND NOT EXISTS (SELECT 1 FROM oy1n_aiassignment_evaluations e WHERE e.submission=s.id);

INSERT INTO oy1n_aiassignment_evaluations (submission,similarity_score,ai_feedback,ai_analysis,timecreated)
SELECT s.id,
  CASE
    WHEN MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),5) IN (1,2) THEN 75 + MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),20)
    WHEN MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),5) = 3     THEN 45 + MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),25)
    ELSE 5 + MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),18)
  END,
  s.feedback,'{}',UNIX_TIMESTAMP()
FROM oy1n_aiassignment_submissions s
JOIN oy1n_user u ON s.userid=u.id
JOIN oy1n_aiassignment a ON s.assignment=a.id
WHERE a.name='Factorial recursivo — Salón 5' AND u.username LIKE 'al%_s05'
AND NOT EXISTS (SELECT 1 FROM oy1n_aiassignment_evaluations e WHERE e.submission=s.id);

INSERT INTO oy1n_aiassignment_evaluations (submission,similarity_score,ai_feedback,ai_analysis,timecreated)
SELECT s.id,
  CASE
    WHEN MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),5) IN (1,2) THEN 75 + MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),20)
    WHEN MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),5) = 3     THEN 45 + MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),25)
    ELSE 5 + MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),18)
  END,
  s.feedback,'{}',UNIX_TIMESTAMP()
FROM oy1n_aiassignment_submissions s
JOIN oy1n_user u ON s.userid=u.id
JOIN oy1n_aiassignment a ON s.assignment=a.id
WHERE a.name='Algoritmo de ordenamiento — Salón 5' AND u.username LIKE 'al%_s05'
AND NOT EXISTS (SELECT 1 FROM oy1n_aiassignment_evaluations e WHERE e.submission=s.id);

INSERT INTO oy1n_aiassignment_evaluations (submission,similarity_score,ai_feedback,ai_analysis,timecreated)
SELECT s.id,
  CASE
    WHEN MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),5) IN (1,2) THEN 75 + MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),20)
    WHEN MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),5) = 3     THEN 45 + MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),25)
    ELSE 5 + MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),18)
  END,
  s.feedback,'{}',UNIX_TIMESTAMP()
FROM oy1n_aiassignment_submissions s
JOIN oy1n_user u ON s.userid=u.id
JOIN oy1n_aiassignment a ON s.assignment=a.id
WHERE a.name='Factorial recursivo — Salón 6' AND u.username LIKE 'al%_s06'
AND NOT EXISTS (SELECT 1 FROM oy1n_aiassignment_evaluations e WHERE e.submission=s.id);

INSERT INTO oy1n_aiassignment_evaluations (submission,similarity_score,ai_feedback,ai_analysis,timecreated)
SELECT s.id,
  CASE
    WHEN MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),5) IN (1,2) THEN 75 + MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),20)
    WHEN MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),5) = 3     THEN 45 + MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),25)
    ELSE 5 + MOD(CAST(SUBSTRING(u.username,3,2) AS UNSIGNED),18)
  END,
  s.feedback,'{}',UNIX_TIMESTAMP()
FROM oy1n_aiassignment_submissions s
JOIN oy1n_user u ON s.userid=u.id
JOIN oy1n_aiassignment a ON s.assignment=a.id
WHERE a.name='Algoritmo de ordenamiento — Salón 6' AND u.username LIKE 'al%_s06'
AND NOT EXISTS (SELECT 1 FROM oy1n_aiassignment_evaluations e WHERE e.submission=s.id);

SET FOREIGN_KEY_CHECKS = 1;

-- ══════════════════════════════════════════════════════════════
-- VERIFICACIÓN FINAL
-- ══════════════════════════════════════════════════════════════
SELECT 'MAESTROS' AS tipo, COUNT(*) AS total FROM oy1n_user WHERE username LIKE 'maestro0%'
UNION ALL
SELECT 'ALUMNOS', COUNT(*) FROM oy1n_user WHERE username LIKE 'al%_s0%'
UNION ALL
SELECT 'CURSOS', COUNT(*) FROM oy1n_course WHERE shortname LIKE 'salon0%'
UNION ALL
SELECT 'TAREAS', COUNT(*) FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id WHERE c.shortname LIKE 'salon0%'
UNION ALL
SELECT 'ENVIOS', COUNT(*) FROM oy1n_aiassignment_submissions s JOIN oy1n_user u ON s.userid=u.id WHERE u.username LIKE 'al%_s0%'
UNION ALL
SELECT 'EVALUACIONES', COUNT(*) FROM oy1n_aiassignment_evaluations e JOIN oy1n_aiassignment_submissions s ON e.submission=s.id JOIN oy1n_user u ON s.userid=u.id WHERE u.username LIKE 'al%_s0%';

-- Distribución de plagio por salón
SELECT
  c.shortname AS salon,
  COUNT(s.id) AS total_envios,
  SUM(CASE WHEN e.similarity_score >= 75 THEN 1 ELSE 0 END) AS plagio_alto,
  SUM(CASE WHEN e.similarity_score >= 50 AND e.similarity_score < 75 THEN 1 ELSE 0 END) AS sospechoso,
  SUM(CASE WHEN e.similarity_score < 50 THEN 1 ELSE 0 END) AS original,
  ROUND(AVG(s.score),1) AS promedio_calificacion
FROM oy1n_course c
JOIN oy1n_aiassignment a ON a.course=c.id
JOIN oy1n_aiassignment_submissions s ON s.assignment=a.id
JOIN oy1n_user u ON s.userid=u.id
LEFT JOIN oy1n_aiassignment_evaluations e ON e.submission=s.id
WHERE c.shortname LIKE 'salon0%' AND u.username LIKE 'al%_s0%'
GROUP BY c.shortname
ORDER BY c.shortname;
