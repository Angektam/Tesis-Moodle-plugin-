-- ============================================================
-- PRUEBA DE ESTRÉS: 100 alumnos × 3 tareas = 300 envíos
-- Generado automáticamente por generar-test-estres.js
-- Objetivo: conocer los límites del plugin bajo carga masiva
-- ============================================================
-- MÉTRICAS ESPERADAS:
--   100 usuarios (stress01-stress100)
--   3 tareas de programación
--   300 submissions totales
--   300 evaluaciones con scores de plagio
--   4950 comparaciones por tarea
--   14850 comparaciones totales
--   40% plagio directo, 20% sospechoso, 40% original
-- ============================================================

USE moodle;
SET FOREIGN_KEY_CHECKS = 0;

-- ── Método de inscripción ─────────────────────────────────────
INSERT INTO mdl_enrol (enrol, status, courseid, sortorder, timecreated, timemodified)
SELECT 'manual', 0, c.id, 0, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
FROM mdl_course c WHERE c.shortname = 'test'
  AND NOT EXISTS (SELECT 1 FROM mdl_enrol e WHERE e.courseid = c.id AND e.enrol = 'manual');

-- ── PASO 1: Crear 100 usuarios ─────────────────
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress001',MD5('Test1234!'),'Carlos','García','stress001@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress001');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress002',MD5('Test1234!'),'María','López','stress002@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress002');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress003',MD5('Test1234!'),'Pedro','Martínez','stress003@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress003');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress004',MD5('Test1234!'),'Ana','Rodríguez','stress004@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress004');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress005',MD5('Test1234!'),'Luis','Hernández','stress005@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress005');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress006',MD5('Test1234!'),'Sofía','Jiménez','stress006@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress006');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress007',MD5('Test1234!'),'Diego','Torres','stress007@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress007');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress008',MD5('Test1234!'),'Valentina','Flores','stress008@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress008');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress009',MD5('Test1234!'),'Andrés','Vargas','stress009@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress009');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress010',MD5('Test1234!'),'Camila','Reyes','stress010@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress010');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress011',MD5('Test1234!'),'Sebastián','Cruz','stress011@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress011');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress012',MD5('Test1234!'),'Isabella','Morales','stress012@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress012');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress013',MD5('Test1234!'),'Mateo','Ortiz','stress013@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress013');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress014',MD5('Test1234!'),'Lucía','Mendoza','stress014@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress014');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress015',MD5('Test1234!'),'Nicolás','Castillo','stress015@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress015');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress016',MD5('Test1234!'),'Gabriela','Ramos','stress016@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress016');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress017',MD5('Test1234!'),'Felipe','Gutiérrez','stress017@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress017');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress018',MD5('Test1234!'),'Daniela','Sánchez','stress018@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress018');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress019',MD5('Test1234!'),'Tomás','Ramírez','stress019@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress019');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress020',MD5('Test1234!'),'Valeria','Núñez','stress020@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress020');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress021',MD5('Test1234!'),'Emilio','Peña','stress021@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress021');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress022',MD5('Test1234!'),'Renata','Aguilar','stress022@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress022');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress023',MD5('Test1234!'),'Joaquín','Medina','stress023@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress023');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress024',MD5('Test1234!'),'Mariana','Vega','stress024@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress024');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress025',MD5('Test1234!'),'Rodrigo','Herrera','stress025@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress025');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress026',MD5('Test1234!'),'Natalia','Ríos','stress026@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress026');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress027',MD5('Test1234!'),'Alejandro','Mora','stress027@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress027');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress028',MD5('Test1234!'),'Paula','Delgado','stress028@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress028');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress029',MD5('Test1234!'),'Ignacio','Fuentes','stress029@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress029');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress030',MD5('Test1234!'),'Catalina','Espinoza','stress030@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress030');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress031',MD5('Test1234!'),'Fernando','Salazar','stress031@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress031');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress032',MD5('Test1234!'),'Elena','Rojas','stress032@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress032');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress033',MD5('Test1234!'),'Ricardo','Navarro','stress033@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress033');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress034',MD5('Test1234!'),'Mónica','Guerrero','stress034@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress034');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress035',MD5('Test1234!'),'Héctor','Campos','stress035@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress035');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress036',MD5('Test1234!'),'Adriana','Molina','stress036@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress036');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress037',MD5('Test1234!'),'Óscar','Domínguez','stress037@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress037');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress038',MD5('Test1234!'),'Fernanda','Suárez','stress038@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress038');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress039',MD5('Test1234!'),'Raúl','Romero','stress039@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress039');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress040',MD5('Test1234!'),'Lorena','Díaz','stress040@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress040');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress041',MD5('Test1234!'),'Arturo','Acosta','stress041@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress041');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress042',MD5('Test1234!'),'Claudia','Bravo','stress042@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress042');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress043',MD5('Test1234!'),'Enrique','Cabrera','stress043@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress043');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress044',MD5('Test1234!'),'Patricia','Calderón','stress044@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress044');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress045',MD5('Test1234!'),'Gerardo','Carrillo','stress045@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress045');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress046',MD5('Test1234!'),'Verónica','Cervantes','stress046@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress046');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress047',MD5('Test1234!'),'Alberto','Contreras','stress047@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress047');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress048',MD5('Test1234!'),'Silvia','Córdoba','stress048@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress048');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress049',MD5('Test1234!'),'Javier','Cortés','stress049@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress049');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress050',MD5('Test1234!'),'Teresa','Duarte','stress050@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress050');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress051',MD5('Test1234!'),'Manuel','Estrada','stress051@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress051');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress052',MD5('Test1234!'),'Rosa','Figueroa','stress052@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress052');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress053',MD5('Test1234!'),'Francisco','Franco','stress053@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress053');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress054',MD5('Test1234!'),'Carmen','Gallegos','stress054@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress054');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress055',MD5('Test1234!'),'Eduardo','Garrido','stress055@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress055');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress056',MD5('Test1234!'),'Alicia','Gil','stress056@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress056');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress057',MD5('Test1234!'),'Roberto','Gómez','stress057@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress057');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress058',MD5('Test1234!'),'Beatriz','González','stress058@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress058');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress059',MD5('Test1234!'),'Alfredo','Ibarra','stress059@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress059');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress060',MD5('Test1234!'),'Gloria','Juárez','stress060@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress060');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress061',MD5('Test1234!'),'Gustavo','León','stress061@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress061');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress062',MD5('Test1234!'),'Irene','Luna','stress062@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress062');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress063',MD5('Test1234!'),'Sergio','Maldonado','stress063@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress063');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress064',MD5('Test1234!'),'Pilar','Marin','stress064@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress064');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress065',MD5('Test1234!'),'Ramón','Mejía','stress065@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress065');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress066',MD5('Test1234!'),'Cristina','Miranda','stress066@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress066');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress067',MD5('Test1234!'),'Víctor','Montoya','stress067@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress067');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress068',MD5('Test1234!'),'Laura','Muñoz','stress068@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress068');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress069',MD5('Test1234!'),'Ernesto','Ochoa','stress069@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress069');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress070',MD5('Test1234!'),'Sandra','Orozco','stress070@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress070');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress071',MD5('Test1234!'),'Armando','Pacheco','stress071@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress071');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress072',MD5('Test1234!'),'Leticia','Padilla','stress072@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress072');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress073',MD5('Test1234!'),'Rubén','Paredes','stress073@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress073');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress074',MD5('Test1234!'),'Norma','Pedraza','stress074@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress074');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress075',MD5('Test1234!'),'Ángel','Peralta','stress075@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress075');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress076',MD5('Test1234!'),'Estela','Ponce','stress076@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress076');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress077',MD5('Test1234!'),'César','Quintero','stress077@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress077');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress078',MD5('Test1234!'),'Yolanda','Rivera','stress078@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress078');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress079',MD5('Test1234!'),'Hugo','Rosales','stress079@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress079');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress080',MD5('Test1234!'),'Martha','Rubio','stress080@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress080');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress081',MD5('Test1234!'),'Iván','Ruiz','stress081@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress081');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress082',MD5('Test1234!'),'Rocío','Salas','stress082@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress082');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress083',MD5('Test1234!'),'Julio','Sandoval','stress083@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress083');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress084',MD5('Test1234!'),'Graciela','Santos','stress084@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress084');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress085',MD5('Test1234!'),'Miguel','Soto','stress085@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress085');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress086',MD5('Test1234!'),'Elisa','Téllez','stress086@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress086');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress087',MD5('Test1234!'),'Rafael','Trejo','stress087@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress087');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress088',MD5('Test1234!'),'Josefina','Valdez','stress088@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress088');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress089',MD5('Test1234!'),'Guillermo','Valencia','stress089@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress089');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress090',MD5('Test1234!'),'Esperanza','Vázquez','stress090@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress090');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress091',MD5('Test1234!'),'Martín','Velasco','stress091@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress091');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress092',MD5('Test1234!'),'Olivia','Vera','stress092@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress092');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress093',MD5('Test1234!'),'Esteban','Villalobos','stress093@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress093');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress094',MD5('Test1234!'),'Jimena','Villanueva','stress094@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress094');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress095',MD5('Test1234!'),'Damián','Zamora','stress095@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress095');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress096',MD5('Test1234!'),'Abril','Zavala','stress096@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress096');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress097',MD5('Test1234!'),'Maximiliano','Zúñiga','stress097@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress097');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress098',MD5('Test1234!'),'Florencia','Arce','stress098@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress098');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress099',MD5('Test1234!'),'Santiago','Ávila','stress099@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress099');
INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'stress100',MD5('Test1234!'),'Agustina','Bautista','stress100@stress.test',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='stress100');

-- ── PASO 2: Inscribir al curso ─────────────────────────────
INSERT INTO mdl_user_enrolments (enrolid, userid, modifierid, timestart, timeend, status, timecreated, timemodified)
SELECT e.id, u.id, 2, UNIX_TIMESTAMP(), 0, 0, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
FROM mdl_user u
JOIN mdl_enrol e ON e.courseid = (SELECT id FROM mdl_course WHERE shortname='test' LIMIT 1) AND e.enrol='manual'
LEFT JOIN mdl_user_enrolments ue ON ue.enrolid=e.id AND ue.userid=u.id
WHERE u.username IN ('stress001','stress002','stress003','stress004','stress005','stress006','stress007','stress008','stress009','stress010','stress011','stress012','stress013','stress014','stress015','stress016','stress017','stress018','stress019','stress020','stress021','stress022','stress023','stress024','stress025','stress026','stress027','stress028','stress029','stress030','stress031','stress032','stress033','stress034','stress035','stress036','stress037','stress038','stress039','stress040','stress041','stress042','stress043','stress044','stress045','stress046','stress047','stress048','stress049','stress050') AND ue.userid IS NULL;

INSERT INTO mdl_user_enrolments (enrolid, userid, modifierid, timestart, timeend, status, timecreated, timemodified)
SELECT e.id, u.id, 2, UNIX_TIMESTAMP(), 0, 0, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
FROM mdl_user u
JOIN mdl_enrol e ON e.courseid = (SELECT id FROM mdl_course WHERE shortname='test' LIMIT 1) AND e.enrol='manual'
LEFT JOIN mdl_user_enrolments ue ON ue.enrolid=e.id AND ue.userid=u.id
WHERE u.username IN ('stress051','stress052','stress053','stress054','stress055','stress056','stress057','stress058','stress059','stress060','stress061','stress062','stress063','stress064','stress065','stress066','stress067','stress068','stress069','stress070','stress071','stress072','stress073','stress074','stress075','stress076','stress077','stress078','stress079','stress080','stress081','stress082','stress083','stress084','stress085','stress086','stress087','stress088','stress089','stress090','stress091','stress092','stress093','stress094','stress095','stress096','stress097','stress098','stress099','stress100') AND ue.userid IS NULL;

-- ── PASO 3: Asignar rol estudiante ─────────────────────────
INSERT INTO mdl_role_assignments (roleid, contextid, userid, timemodified, modifierid, component, itemid)
SELECT r.id, ctx.id, u.id, UNIX_TIMESTAMP(), 2, '', 0
FROM mdl_user u
JOIN mdl_role r ON r.shortname='student'
JOIN mdl_context ctx ON ctx.contextlevel=50 AND ctx.instanceid=(SELECT id FROM mdl_course WHERE shortname='test' LIMIT 1)
LEFT JOIN mdl_role_assignments ra ON ra.roleid=r.id AND ra.contextid=ctx.id AND ra.userid=u.id
WHERE u.username IN ('stress001','stress002','stress003','stress004','stress005','stress006','stress007','stress008','stress009','stress010','stress011','stress012','stress013','stress014','stress015','stress016','stress017','stress018','stress019','stress020','stress021','stress022','stress023','stress024','stress025','stress026','stress027','stress028','stress029','stress030','stress031','stress032','stress033','stress034','stress035','stress036','stress037','stress038','stress039','stress040','stress041','stress042','stress043','stress044','stress045','stress046','stress047','stress048','stress049','stress050') AND ra.userid IS NULL;

INSERT INTO mdl_role_assignments (roleid, contextid, userid, timemodified, modifierid, component, itemid)
SELECT r.id, ctx.id, u.id, UNIX_TIMESTAMP(), 2, '', 0
FROM mdl_user u
JOIN mdl_role r ON r.shortname='student'
JOIN mdl_context ctx ON ctx.contextlevel=50 AND ctx.instanceid=(SELECT id FROM mdl_course WHERE shortname='test' LIMIT 1)
LEFT JOIN mdl_role_assignments ra ON ra.roleid=r.id AND ra.contextid=ctx.id AND ra.userid=u.id
WHERE u.username IN ('stress051','stress052','stress053','stress054','stress055','stress056','stress057','stress058','stress059','stress060','stress061','stress062','stress063','stress064','stress065','stress066','stress067','stress068','stress069','stress070','stress071','stress072','stress073','stress074','stress075','stress076','stress077','stress078','stress079','stress080','stress081','stress082','stress083','stress084','stress085','stress086','stress087','stress088','stress089','stress090','stress091','stress092','stress093','stress094','stress095','stress096','stress097','stress098','stress099','stress100') AND ra.userid IS NULL;

-- ── PASO 4: Crear 3 tareas de estrés ──────────────────────
INSERT INTO mdl_aiassignment (course, teacher_id, name, intro, introformat, description, type, solution, grade, maxattempts, timecreated, timemodified)
SELECT c.id, 2, 'Stress Test: Factorial', 'Implementa factorial', 0, 'Implementa la función factorial en Python', 'programming',
'def factorial(n):\n    if n <= 1: return 1\n    return n * factorial(n-1)', 100, 0, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
FROM mdl_course c WHERE c.shortname='test'
AND NOT EXISTS (SELECT 1 FROM mdl_aiassignment WHERE name='Stress Test: Factorial' AND course=c.id);

INSERT INTO mdl_aiassignment (course, teacher_id, name, intro, introformat, description, type, solution, grade, maxattempts, timecreated, timemodified)
SELECT c.id, 2, 'Stress Test: Ordenamiento', 'Implementa un algoritmo de ordenamiento', 0, 'Implementa bubble sort u otro algoritmo', 'programming',
'def bubble_sort(arr):\n    n=len(arr)\n    for i in range(n):\n        for j in range(n-i-1):\n            if arr[j]>arr[j+1]: arr[j],arr[j+1]=arr[j+1],arr[j]\n    return arr', 100, 0, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
FROM mdl_course c WHERE c.shortname='test'
AND NOT EXISTS (SELECT 1 FROM mdl_aiassignment WHERE name='Stress Test: Ordenamiento' AND course=c.id);

INSERT INTO mdl_aiassignment (course, teacher_id, name, intro, introformat, description, type, solution, grade, maxattempts, timecreated, timemodified)
SELECT c.id, 2, 'Stress Test: Fibonacci', 'Implementa la serie de Fibonacci', 0, 'Genera los primeros N números de Fibonacci', 'programming',
'def fibonacci(n):\n    if n<=0: return 0\n    if n==1: return 1\n    return fibonacci(n-1)+fibonacci(n-2)', 100, 0, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
FROM mdl_course c WHERE c.shortname='test'
AND NOT EXISTS (SELECT 1 FROM mdl_aiassignment WHERE name='Stress Test: Fibonacci' AND course=c.id);

-- ── PASO 5: Limpiar envíos previos de stress ───────────────
DELETE ev FROM mdl_aiassignment_evaluations ev
INNER JOIN mdl_aiassignment_submissions s ON ev.submission = s.id
INNER JOIN mdl_user u ON s.userid = u.id
WHERE u.username LIKE 'stress%';

DELETE s FROM mdl_aiassignment_submissions s
INNER JOIN mdl_user u ON s.userid = u.id
WHERE u.username LIKE 'stress%';

-- ── PASO 6: Envíos para "Stress Test: Factorial" ────────────────────
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def factorial(n):\n    if n == 0 or n == 1:\n        return 1\n    return n * factorial(n - 1)\n\nprint(factorial(5))\nprint(factorial(10))', 'evaluated', 92.00, 'ORIGINAL_BASE: stress test alumno 001', 1, UNIX_TIMESTAMP()-98468, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress001'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fact(x):\n    # alumno 1\n    if x <= 1:\n        return 1\n    return x * fact(x - 1)\n\nresult = fact(5)\nprint(result)', 'evaluated', 81.00, 'PLAGIO: stress test alumno 002', 1, UNIX_TIMESTAMP()-60053, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress002'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def factorial(n):\n    aux_2 = 0\n    if n == 1 or n == 0:\n        return 1\n    result = n * factorial(n - 1)\n    return result\n\nprint(factorial(5))', 'evaluated', 82.00, 'PLAGIO: stress test alumno 003', 1, UNIX_TIMESTAMP()-234990, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress003'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def calc_fact_3(num):\n    if num == 0 or num == 1:\n        return 1\n    return num * calc_fact_3(num - 1)\n\nprint(calc_fact_3(5))', 'evaluated', 83.00, 'PLAGIO: stress test alumno 004', 1, UNIX_TIMESTAMP()-186196, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress004'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fact(x):\n    # alumno 4\n    if x <= 1:\n        return 1\n    return x * fact(x - 1)\n\nresult = fact(5)\nprint(result)', 'evaluated', 84.00, 'PLAGIO: stress test alumno 005', 1, UNIX_TIMESTAMP()-402, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress005'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def factorial(n):\n    aux_5 = 0\n    if n == 1 or n == 0:\n        return 1\n    result = n * factorial(n - 1)\n    return result\n\nprint(factorial(5))', 'evaluated', 85.00, 'PLAGIO: stress test alumno 006', 1, UNIX_TIMESTAMP()-339970, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress006'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def calc_fact_6(num):\n    if num == 0 or num == 1:\n        return 1\n    return num * calc_fact_6(num - 1)\n\nprint(calc_fact_6(5))', 'evaluated', 86.00, 'PLAGIO: stress test alumno 007', 1, UNIX_TIMESTAMP()-81166, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress007'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fact(x):\n    # alumno 7\n    if x <= 1:\n        return 1\n    return x * fact(x - 1)\n\nresult = fact(5)\nprint(result)', 'evaluated', 87.00, 'PLAGIO: stress test alumno 008', 1, UNIX_TIMESTAMP()-262829, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress008'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def factorial(n):\n    aux_8 = 0\n    if n == 1 or n == 0:\n        return 1\n    result = n * factorial(n - 1)\n    return result\n\nprint(factorial(5))', 'evaluated', 88.00, 'PLAGIO: stress test alumno 009', 1, UNIX_TIMESTAMP()-392591, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress009'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def calc_fact_9(num):\n    if num == 0 or num == 1:\n        return 1\n    return num * calc_fact_9(num - 1)\n\nprint(calc_fact_9(5))', 'evaluated', 89.00, 'PLAGIO: stress test alumno 010', 1, UNIX_TIMESTAMP()-108836, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress010'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fact(x):\n    # alumno 10\n    if x <= 1:\n        return 1\n    return x * fact(x - 1)\n\nresult = fact(5)\nprint(result)', 'evaluated', 90.00, 'PLAGIO: stress test alumno 011', 1, UNIX_TIMESTAMP()-377186, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress011'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def factorial(n):\n    aux_11 = 0\n    if n == 1 or n == 0:\n        return 1\n    result = n * factorial(n - 1)\n    return result\n\nprint(factorial(5))', 'evaluated', 91.00, 'PLAGIO: stress test alumno 012', 1, UNIX_TIMESTAMP()-163440, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress012'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def calc_fact_12(num):\n    if num == 0 or num == 1:\n        return 1\n    return num * calc_fact_12(num - 1)\n\nprint(calc_fact_12(5))', 'evaluated', 92.00, 'PLAGIO: stress test alumno 013', 1, UNIX_TIMESTAMP()-570888, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress013'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fact(x):\n    # alumno 13\n    if x <= 1:\n        return 1\n    return x * fact(x - 1)\n\nresult = fact(5)\nprint(result)', 'evaluated', 93.00, 'PLAGIO: stress test alumno 014', 1, UNIX_TIMESTAMP()-218087, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress014'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def factorial(n):\n    aux_14 = 0\n    if n == 1 or n == 0:\n        return 1\n    result = n * factorial(n - 1)\n    return result\n\nprint(factorial(5))', 'evaluated', 94.00, 'PLAGIO: stress test alumno 015', 1, UNIX_TIMESTAMP()-69114, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress015'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def calc_fact_15(num):\n    if num == 0 or num == 1:\n        return 1\n    return num * calc_fact_15(num - 1)\n\nprint(calc_fact_15(5))', 'evaluated', 80.00, 'PLAGIO: stress test alumno 016', 1, UNIX_TIMESTAMP()-359838, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress016'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fact(x):\n    # alumno 16\n    if x <= 1:\n        return 1\n    return x * fact(x - 1)\n\nresult = fact(5)\nprint(result)', 'evaluated', 81.00, 'PLAGIO: stress test alumno 017', 1, UNIX_TIMESTAMP()-26292, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress017'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def factorial(n):\n    aux_17 = 0\n    if n == 1 or n == 0:\n        return 1\n    result = n * factorial(n - 1)\n    return result\n\nprint(factorial(5))', 'evaluated', 82.00, 'PLAGIO: stress test alumno 018', 1, UNIX_TIMESTAMP()-186641, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress018'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def calc_fact_18(num):\n    if num == 0 or num == 1:\n        return 1\n    return num * calc_fact_18(num - 1)\n\nprint(calc_fact_18(5))', 'evaluated', 83.00, 'PLAGIO: stress test alumno 019', 1, UNIX_TIMESTAMP()-583200, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress019'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fact(x):\n    # alumno 19\n    if x <= 1:\n        return 1\n    return x * fact(x - 1)\n\nresult = fact(5)\nprint(result)', 'evaluated', 84.00, 'PLAGIO: stress test alumno 020', 1, UNIX_TIMESTAMP()-72579, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress020'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def factorial(n):\n    aux_20 = 0\n    if n == 1 or n == 0:\n        return 1\n    result = n * factorial(n - 1)\n    return result\n\nprint(factorial(5))', 'evaluated', 85.00, 'PLAGIO: stress test alumno 021', 1, UNIX_TIMESTAMP()-363981, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress021'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def calc_fact_21(num):\n    if num == 0 or num == 1:\n        return 1\n    return num * calc_fact_21(num - 1)\n\nprint(calc_fact_21(5))', 'evaluated', 86.00, 'PLAGIO: stress test alumno 022', 1, UNIX_TIMESTAMP()-33523, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress022'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fact(x):\n    # alumno 22\n    if x <= 1:\n        return 1\n    return x * fact(x - 1)\n\nresult = fact(5)\nprint(result)', 'evaluated', 87.00, 'PLAGIO: stress test alumno 023', 1, UNIX_TIMESTAMP()-165977, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress023'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def factorial(n):\n    aux_23 = 0\n    if n == 1 or n == 0:\n        return 1\n    result = n * factorial(n - 1)\n    return result\n\nprint(factorial(5))', 'evaluated', 88.00, 'PLAGIO: stress test alumno 024', 1, UNIX_TIMESTAMP()-96272, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress024'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def calc_fact_24(num):\n    if num == 0 or num == 1:\n        return 1\n    return num * calc_fact_24(num - 1)\n\nprint(calc_fact_24(5))', 'evaluated', 89.00, 'PLAGIO: stress test alumno 025', 1, UNIX_TIMESTAMP()-225288, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress025'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fact(x):\n    # alumno 25\n    if x <= 1:\n        return 1\n    return x * fact(x - 1)\n\nresult = fact(5)\nprint(result)', 'evaluated', 90.00, 'PLAGIO: stress test alumno 026', 1, UNIX_TIMESTAMP()-169637, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress026'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def factorial(n):\n    aux_26 = 0\n    if n == 1 or n == 0:\n        return 1\n    result = n * factorial(n - 1)\n    return result\n\nprint(factorial(5))', 'evaluated', 91.00, 'PLAGIO: stress test alumno 027', 1, UNIX_TIMESTAMP()-285309, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress027'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def calc_fact_27(num):\n    if num == 0 or num == 1:\n        return 1\n    return num * calc_fact_27(num - 1)\n\nprint(calc_fact_27(5))', 'evaluated', 92.00, 'PLAGIO: stress test alumno 028', 1, UNIX_TIMESTAMP()-56081, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress028'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fact(x):\n    # alumno 28\n    if x <= 1:\n        return 1\n    return x * fact(x - 1)\n\nresult = fact(5)\nprint(result)', 'evaluated', 93.00, 'PLAGIO: stress test alumno 029', 1, UNIX_TIMESTAMP()-116711, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress029'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def factorial(n):\n    aux_29 = 0\n    if n == 1 or n == 0:\n        return 1\n    result = n * factorial(n - 1)\n    return result\n\nprint(factorial(5))', 'evaluated', 94.00, 'PLAGIO: stress test alumno 030', 1, UNIX_TIMESTAMP()-99722, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress030'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def calc_fact_30(num):\n    if num == 0 or num == 1:\n        return 1\n    return num * calc_fact_30(num - 1)\n\nprint(calc_fact_30(5))', 'evaluated', 80.00, 'PLAGIO: stress test alumno 031', 1, UNIX_TIMESTAMP()-313081, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress031'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fact(x):\n    # alumno 31\n    if x <= 1:\n        return 1\n    return x * fact(x - 1)\n\nresult = fact(5)\nprint(result)', 'evaluated', 81.00, 'PLAGIO: stress test alumno 032', 1, UNIX_TIMESTAMP()-536740, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress032'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def factorial(n):\n    aux_32 = 0\n    if n == 1 or n == 0:\n        return 1\n    result = n * factorial(n - 1)\n    return result\n\nprint(factorial(5))', 'evaluated', 82.00, 'PLAGIO: stress test alumno 033', 1, UNIX_TIMESTAMP()-140251, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress033'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def calc_fact_33(num):\n    if num == 0 or num == 1:\n        return 1\n    return num * calc_fact_33(num - 1)\n\nprint(calc_fact_33(5))', 'evaluated', 83.00, 'PLAGIO: stress test alumno 034', 1, UNIX_TIMESTAMP()-182404, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress034'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fact(x):\n    # alumno 34\n    if x <= 1:\n        return 1\n    return x * fact(x - 1)\n\nresult = fact(5)\nprint(result)', 'evaluated', 84.00, 'PLAGIO: stress test alumno 035', 1, UNIX_TIMESTAMP()-345742, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress035'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def factorial(n):\n    aux_35 = 0\n    if n == 1 or n == 0:\n        return 1\n    result = n * factorial(n - 1)\n    return result\n\nprint(factorial(5))', 'evaluated', 85.00, 'PLAGIO: stress test alumno 036', 1, UNIX_TIMESTAMP()-488722, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress036'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def calc_fact_36(num):\n    if num == 0 or num == 1:\n        return 1\n    return num * calc_fact_36(num - 1)\n\nprint(calc_fact_36(5))', 'evaluated', 86.00, 'PLAGIO: stress test alumno 037', 1, UNIX_TIMESTAMP()-396031, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress037'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fact(x):\n    # alumno 37\n    if x <= 1:\n        return 1\n    return x * fact(x - 1)\n\nresult = fact(5)\nprint(result)', 'evaluated', 87.00, 'PLAGIO: stress test alumno 038', 1, UNIX_TIMESTAMP()-198191, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress038'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def factorial(n):\n    aux_38 = 0\n    if n == 1 or n == 0:\n        return 1\n    result = n * factorial(n - 1)\n    return result\n\nprint(factorial(5))', 'evaluated', 88.00, 'PLAGIO: stress test alumno 039', 1, UNIX_TIMESTAMP()-270624, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress039'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def calc_fact_39(num):\n    if num == 0 or num == 1:\n        return 1\n    return num * calc_fact_39(num - 1)\n\nprint(calc_fact_39(5))', 'evaluated', 89.00, 'PLAGIO: stress test alumno 040', 1, UNIX_TIMESTAMP()-333111, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress040'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def factorial_iter(n):\n    resultado = 1\n    while n > 1:\n        resultado *= n\n        n -= 1\n    return resultado\n\n# version 40\nprint(factorial_iter(5))', 'evaluated', 70.00, 'SOSPECHOSO: stress test alumno 041', 1, UNIX_TIMESTAMP()-418285, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress041'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def factorial(n):\n    resultado = 1\n    for i in range(1, n+1):\n        resultado = resultado * i\n    return resultado\n\n# v41\nprint(factorial(5))', 'evaluated', 71.00, 'SOSPECHOSO: stress test alumno 042', 1, UNIX_TIMESTAMP()-18914, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress042'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def factorial_iter(n):\n    resultado = 1\n    while n > 1:\n        resultado *= n\n        n -= 1\n    return resultado\n\n# version 42\nprint(factorial_iter(5))', 'evaluated', 72.00, 'SOSPECHOSO: stress test alumno 043', 1, UNIX_TIMESTAMP()-209674, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress043'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def factorial(n):\n    resultado = 1\n    for i in range(1, n+1):\n        resultado = resultado * i\n    return resultado\n\n# v43\nprint(factorial(5))', 'evaluated', 73.00, 'SOSPECHOSO: stress test alumno 044', 1, UNIX_TIMESTAMP()-568104, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress044'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def factorial_iter(n):\n    resultado = 1\n    while n > 1:\n        resultado *= n\n        n -= 1\n    return resultado\n\n# version 44\nprint(factorial_iter(5))', 'evaluated', 74.00, 'SOSPECHOSO: stress test alumno 045', 1, UNIX_TIMESTAMP()-301255, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress045'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def factorial(n):\n    resultado = 1\n    for i in range(1, n+1):\n        resultado = resultado * i\n    return resultado\n\n# v45\nprint(factorial(5))', 'evaluated', 75.00, 'SOSPECHOSO: stress test alumno 046', 1, UNIX_TIMESTAMP()-392910, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress046'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def factorial_iter(n):\n    resultado = 1\n    while n > 1:\n        resultado *= n\n        n -= 1\n    return resultado\n\n# version 46\nprint(factorial_iter(5))', 'evaluated', 76.00, 'SOSPECHOSO: stress test alumno 047', 1, UNIX_TIMESTAMP()-226220, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress047'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def factorial(n):\n    resultado = 1\n    for i in range(1, n+1):\n        resultado = resultado * i\n    return resultado\n\n# v47\nprint(factorial(5))', 'evaluated', 77.00, 'SOSPECHOSO: stress test alumno 048', 1, UNIX_TIMESTAMP()-457560, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress048'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def factorial_iter(n):\n    resultado = 1\n    while n > 1:\n        resultado *= n\n        n -= 1\n    return resultado\n\n# version 48\nprint(factorial_iter(5))', 'evaluated', 78.00, 'SOSPECHOSO: stress test alumno 049', 1, UNIX_TIMESTAMP()-539920, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress049'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def factorial(n):\n    resultado = 1\n    for i in range(1, n+1):\n        resultado = resultado * i\n    return resultado\n\n# v49\nprint(factorial(5))', 'evaluated', 79.00, 'SOSPECHOSO: stress test alumno 050', 1, UNIX_TIMESTAMP()-516722, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress050'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def factorial_iter(n):\n    resultado = 1\n    while n > 1:\n        resultado *= n\n        n -= 1\n    return resultado\n\n# version 50\nprint(factorial_iter(5))', 'evaluated', 70.00, 'SOSPECHOSO: stress test alumno 051', 1, UNIX_TIMESTAMP()-423597, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress051'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def factorial(n):\n    resultado = 1\n    for i in range(1, n+1):\n        resultado = resultado * i\n    return resultado\n\n# v51\nprint(factorial(5))', 'evaluated', 71.00, 'SOSPECHOSO: stress test alumno 052', 1, UNIX_TIMESTAMP()-543991, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress052'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def factorial_iter(n):\n    resultado = 1\n    while n > 1:\n        resultado *= n\n        n -= 1\n    return resultado\n\n# version 52\nprint(factorial_iter(5))', 'evaluated', 72.00, 'SOSPECHOSO: stress test alumno 053', 1, UNIX_TIMESTAMP()-190019, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress053'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def factorial(n):\n    resultado = 1\n    for i in range(1, n+1):\n        resultado = resultado * i\n    return resultado\n\n# v53\nprint(factorial(5))', 'evaluated', 73.00, 'SOSPECHOSO: stress test alumno 054', 1, UNIX_TIMESTAMP()-26893, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress054'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def factorial_iter(n):\n    resultado = 1\n    while n > 1:\n        resultado *= n\n        n -= 1\n    return resultado\n\n# version 54\nprint(factorial_iter(5))', 'evaluated', 74.00, 'SOSPECHOSO: stress test alumno 055', 1, UNIX_TIMESTAMP()-488552, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress055'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def factorial(n):\n    resultado = 1\n    for i in range(1, n+1):\n        resultado = resultado * i\n    return resultado\n\n# v55\nprint(factorial(5))', 'evaluated', 75.00, 'SOSPECHOSO: stress test alumno 056', 1, UNIX_TIMESTAMP()-347787, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress056'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def factorial_iter(n):\n    resultado = 1\n    while n > 1:\n        resultado *= n\n        n -= 1\n    return resultado\n\n# version 56\nprint(factorial_iter(5))', 'evaluated', 76.00, 'SOSPECHOSO: stress test alumno 057', 1, UNIX_TIMESTAMP()-159073, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress057'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def factorial(n):\n    resultado = 1\n    for i in range(1, n+1):\n        resultado = resultado * i\n    return resultado\n\n# v57\nprint(factorial(5))', 'evaluated', 77.00, 'SOSPECHOSO: stress test alumno 058', 1, UNIX_TIMESTAMP()-128555, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress058'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def factorial_iter(n):\n    resultado = 1\n    while n > 1:\n        resultado *= n\n        n -= 1\n    return resultado\n\n# version 58\nprint(factorial_iter(5))', 'evaluated', 78.00, 'SOSPECHOSO: stress test alumno 059', 1, UNIX_TIMESTAMP()-71402, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress059'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def factorial(n):\n    resultado = 1\n    for i in range(1, n+1):\n        resultado = resultado * i\n    return resultado\n\n# v59\nprint(factorial(5))', 'evaluated', 79.00, 'SOSPECHOSO: stress test alumno 060', 1, UNIX_TIMESTAMP()-513792, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress060'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'import math\n\ndef factorial_v60(n):\n    return math.prod(range(1, n+1)) if n > 0 else 1\n\nprint(factorial_v60(5))', 'evaluated', 85.00, 'ORIGINAL: stress test alumno 061', 1, UNIX_TIMESTAMP()-477339, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress061'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'cache_61 = {}\ndef factorial(n):\n    if n in cache_61: return cache_61[n]\n    if n <= 1: return 1\n    cache_61[n] = n * factorial(n-1)\n    return cache_61[n]\nprint(factorial(10))', 'evaluated', 86.00, 'ORIGINAL: stress test alumno 062', 1, UNIX_TIMESTAMP()-123301, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress062'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'from functools import reduce\ndef fact_62(n):\n    if n == 0: return 1\n    return reduce(lambda x,y: x*y, range(1,n+1))\nprint(fact_62(5))', 'evaluated', 87.00, 'ORIGINAL: stress test alumno 063', 1, UNIX_TIMESTAMP()-56637, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress063'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def factorial_stack_63(n):\n    stack = list(range(2, n+1))\n    result = 1\n    while stack: result *= stack.pop()\n    return result\nprint(factorial_stack_63(10))', 'evaluated', 88.00, 'ORIGINAL: stress test alumno 064', 1, UNIX_TIMESTAMP()-495087, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress064'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'import math\n\ndef factorial_v64(n):\n    return math.prod(range(1, n+1)) if n > 0 else 1\n\nprint(factorial_v64(5))', 'evaluated', 89.00, 'ORIGINAL: stress test alumno 065', 1, UNIX_TIMESTAMP()-32295, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress065'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'cache_65 = {}\ndef factorial(n):\n    if n in cache_65: return cache_65[n]\n    if n <= 1: return 1\n    cache_65[n] = n * factorial(n-1)\n    return cache_65[n]\nprint(factorial(10))', 'evaluated', 90.00, 'ORIGINAL: stress test alumno 066', 1, UNIX_TIMESTAMP()-350045, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress066'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'from functools import reduce\ndef fact_66(n):\n    if n == 0: return 1\n    return reduce(lambda x,y: x*y, range(1,n+1))\nprint(fact_66(5))', 'evaluated', 91.00, 'ORIGINAL: stress test alumno 067', 1, UNIX_TIMESTAMP()-601153, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress067'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def factorial_stack_67(n):\n    stack = list(range(2, n+1))\n    result = 1\n    while stack: result *= stack.pop()\n    return result\nprint(factorial_stack_67(10))', 'evaluated', 92.00, 'ORIGINAL: stress test alumno 068', 1, UNIX_TIMESTAMP()-250685, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress068'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'import math\n\ndef factorial_v68(n):\n    return math.prod(range(1, n+1)) if n > 0 else 1\n\nprint(factorial_v68(5))', 'evaluated', 93.00, 'ORIGINAL: stress test alumno 069', 1, UNIX_TIMESTAMP()-145434, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress069'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'cache_69 = {}\ndef factorial(n):\n    if n in cache_69: return cache_69[n]\n    if n <= 1: return 1\n    cache_69[n] = n * factorial(n-1)\n    return cache_69[n]\nprint(factorial(10))', 'evaluated', 94.00, 'ORIGINAL: stress test alumno 070', 1, UNIX_TIMESTAMP()-33116, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress070'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'from functools import reduce\ndef fact_70(n):\n    if n == 0: return 1\n    return reduce(lambda x,y: x*y, range(1,n+1))\nprint(fact_70(5))', 'evaluated', 95.00, 'ORIGINAL: stress test alumno 071', 1, UNIX_TIMESTAMP()-209659, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress071'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def factorial_stack_71(n):\n    stack = list(range(2, n+1))\n    result = 1\n    while stack: result *= stack.pop()\n    return result\nprint(factorial_stack_71(10))', 'evaluated', 96.00, 'ORIGINAL: stress test alumno 072', 1, UNIX_TIMESTAMP()-12130, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress072'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'import math\n\ndef factorial_v72(n):\n    return math.prod(range(1, n+1)) if n > 0 else 1\n\nprint(factorial_v72(5))', 'evaluated', 85.00, 'ORIGINAL: stress test alumno 073', 1, UNIX_TIMESTAMP()-280788, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress073'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'cache_73 = {}\ndef factorial(n):\n    if n in cache_73: return cache_73[n]\n    if n <= 1: return 1\n    cache_73[n] = n * factorial(n-1)\n    return cache_73[n]\nprint(factorial(10))', 'evaluated', 86.00, 'ORIGINAL: stress test alumno 074', 1, UNIX_TIMESTAMP()-545968, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress074'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'from functools import reduce\ndef fact_74(n):\n    if n == 0: return 1\n    return reduce(lambda x,y: x*y, range(1,n+1))\nprint(fact_74(5))', 'evaluated', 87.00, 'ORIGINAL: stress test alumno 075', 1, UNIX_TIMESTAMP()-223999, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress075'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def factorial_stack_75(n):\n    stack = list(range(2, n+1))\n    result = 1\n    while stack: result *= stack.pop()\n    return result\nprint(factorial_stack_75(10))', 'evaluated', 88.00, 'ORIGINAL: stress test alumno 076', 1, UNIX_TIMESTAMP()-429450, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress076'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'import math\n\ndef factorial_v76(n):\n    return math.prod(range(1, n+1)) if n > 0 else 1\n\nprint(factorial_v76(5))', 'evaluated', 89.00, 'ORIGINAL: stress test alumno 077', 1, UNIX_TIMESTAMP()-370363, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress077'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'cache_77 = {}\ndef factorial(n):\n    if n in cache_77: return cache_77[n]\n    if n <= 1: return 1\n    cache_77[n] = n * factorial(n-1)\n    return cache_77[n]\nprint(factorial(10))', 'evaluated', 90.00, 'ORIGINAL: stress test alumno 078', 1, UNIX_TIMESTAMP()-385233, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress078'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'from functools import reduce\ndef fact_78(n):\n    if n == 0: return 1\n    return reduce(lambda x,y: x*y, range(1,n+1))\nprint(fact_78(5))', 'evaluated', 91.00, 'ORIGINAL: stress test alumno 079', 1, UNIX_TIMESTAMP()-316438, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress079'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def factorial_stack_79(n):\n    stack = list(range(2, n+1))\n    result = 1\n    while stack: result *= stack.pop()\n    return result\nprint(factorial_stack_79(10))', 'evaluated', 92.00, 'ORIGINAL: stress test alumno 080', 1, UNIX_TIMESTAMP()-380679, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress080'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'import math\n\ndef factorial_v80(n):\n    return math.prod(range(1, n+1)) if n > 0 else 1\n\nprint(factorial_v80(5))', 'evaluated', 93.00, 'ORIGINAL: stress test alumno 081', 1, UNIX_TIMESTAMP()-130376, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress081'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'cache_81 = {}\ndef factorial(n):\n    if n in cache_81: return cache_81[n]\n    if n <= 1: return 1\n    cache_81[n] = n * factorial(n-1)\n    return cache_81[n]\nprint(factorial(10))', 'evaluated', 94.00, 'ORIGINAL: stress test alumno 082', 1, UNIX_TIMESTAMP()-213378, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress082'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'from functools import reduce\ndef fact_82(n):\n    if n == 0: return 1\n    return reduce(lambda x,y: x*y, range(1,n+1))\nprint(fact_82(5))', 'evaluated', 95.00, 'ORIGINAL: stress test alumno 083', 1, UNIX_TIMESTAMP()-431541, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress083'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def factorial_stack_83(n):\n    stack = list(range(2, n+1))\n    result = 1\n    while stack: result *= stack.pop()\n    return result\nprint(factorial_stack_83(10))', 'evaluated', 96.00, 'ORIGINAL: stress test alumno 084', 1, UNIX_TIMESTAMP()-48572, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress084'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'import math\n\ndef factorial_v84(n):\n    return math.prod(range(1, n+1)) if n > 0 else 1\n\nprint(factorial_v84(5))', 'evaluated', 85.00, 'ORIGINAL: stress test alumno 085', 1, UNIX_TIMESTAMP()-88504, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress085'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'cache_85 = {}\ndef factorial(n):\n    if n in cache_85: return cache_85[n]\n    if n <= 1: return 1\n    cache_85[n] = n * factorial(n-1)\n    return cache_85[n]\nprint(factorial(10))', 'evaluated', 86.00, 'ORIGINAL: stress test alumno 086', 1, UNIX_TIMESTAMP()-299214, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress086'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'from functools import reduce\ndef fact_86(n):\n    if n == 0: return 1\n    return reduce(lambda x,y: x*y, range(1,n+1))\nprint(fact_86(5))', 'evaluated', 87.00, 'ORIGINAL: stress test alumno 087', 1, UNIX_TIMESTAMP()-285683, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress087'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def factorial_stack_87(n):\n    stack = list(range(2, n+1))\n    result = 1\n    while stack: result *= stack.pop()\n    return result\nprint(factorial_stack_87(10))', 'evaluated', 88.00, 'ORIGINAL: stress test alumno 088', 1, UNIX_TIMESTAMP()-500192, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress088'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'import math\n\ndef factorial_v88(n):\n    return math.prod(range(1, n+1)) if n > 0 else 1\n\nprint(factorial_v88(5))', 'evaluated', 89.00, 'ORIGINAL: stress test alumno 089', 1, UNIX_TIMESTAMP()-43529, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress089'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'cache_89 = {}\ndef factorial(n):\n    if n in cache_89: return cache_89[n]\n    if n <= 1: return 1\n    cache_89[n] = n * factorial(n-1)\n    return cache_89[n]\nprint(factorial(10))', 'evaluated', 90.00, 'ORIGINAL: stress test alumno 090', 1, UNIX_TIMESTAMP()-408466, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress090'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'from functools import reduce\ndef fact_90(n):\n    if n == 0: return 1\n    return reduce(lambda x,y: x*y, range(1,n+1))\nprint(fact_90(5))', 'evaluated', 91.00, 'ORIGINAL: stress test alumno 091', 1, UNIX_TIMESTAMP()-600938, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress091'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def factorial_stack_91(n):\n    stack = list(range(2, n+1))\n    result = 1\n    while stack: result *= stack.pop()\n    return result\nprint(factorial_stack_91(10))', 'evaluated', 92.00, 'ORIGINAL: stress test alumno 092', 1, UNIX_TIMESTAMP()-501870, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress092'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'import math\n\ndef factorial_v92(n):\n    return math.prod(range(1, n+1)) if n > 0 else 1\n\nprint(factorial_v92(5))', 'evaluated', 93.00, 'ORIGINAL: stress test alumno 093', 1, UNIX_TIMESTAMP()-79780, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress093'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'cache_93 = {}\ndef factorial(n):\n    if n in cache_93: return cache_93[n]\n    if n <= 1: return 1\n    cache_93[n] = n * factorial(n-1)\n    return cache_93[n]\nprint(factorial(10))', 'evaluated', 94.00, 'ORIGINAL: stress test alumno 094', 1, UNIX_TIMESTAMP()-265562, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress094'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'from functools import reduce\ndef fact_94(n):\n    if n == 0: return 1\n    return reduce(lambda x,y: x*y, range(1,n+1))\nprint(fact_94(5))', 'evaluated', 95.00, 'ORIGINAL: stress test alumno 095', 1, UNIX_TIMESTAMP()-341030, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress095'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def factorial_stack_95(n):\n    stack = list(range(2, n+1))\n    result = 1\n    while stack: result *= stack.pop()\n    return result\nprint(factorial_stack_95(10))', 'evaluated', 96.00, 'ORIGINAL: stress test alumno 096', 1, UNIX_TIMESTAMP()-231536, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress096'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'import math\n\ndef factorial_v96(n):\n    return math.prod(range(1, n+1)) if n > 0 else 1\n\nprint(factorial_v96(5))', 'evaluated', 85.00, 'ORIGINAL: stress test alumno 097', 1, UNIX_TIMESTAMP()-519058, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress097'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'cache_97 = {}\ndef factorial(n):\n    if n in cache_97: return cache_97[n]\n    if n <= 1: return 1\n    cache_97[n] = n * factorial(n-1)\n    return cache_97[n]\nprint(factorial(10))', 'evaluated', 86.00, 'ORIGINAL: stress test alumno 098', 1, UNIX_TIMESTAMP()-311271, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress098'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'from functools import reduce\ndef fact_98(n):\n    if n == 0: return 1\n    return reduce(lambda x,y: x*y, range(1,n+1))\nprint(fact_98(5))', 'evaluated', 87.00, 'ORIGINAL: stress test alumno 099', 1, UNIX_TIMESTAMP()-548235, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress099'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def factorial_stack_99(n):\n    stack = list(range(2, n+1))\n    result = 1\n    while stack: result *= stack.pop()\n    return result\nprint(factorial_stack_99(10))', 'evaluated', 88.00, 'ORIGINAL: stress test alumno 100', 1, UNIX_TIMESTAMP()-111016, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress100'
WHERE c.shortname='test' AND a.name='Stress Test: Factorial';

-- ── PASO 6: Envíos para "Stress Test: Ordenamiento" ────────────────────
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def bubble_sort(arr):\n    n = len(arr)\n    for i in range(n):\n        for j in range(0, n-i-1):\n            if arr[j] > arr[j+1]:\n                arr[j], arr[j+1] = arr[j+1], arr[j]\n    return arr\n\nprint(bubble_sort([64,34,25,12,22,11,90]))', 'evaluated', 92.00, 'ORIGINAL_BASE: stress test alumno 001', 1, UNIX_TIMESTAMP()-223803, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress001'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def sort_burbuja(arr):\n    # alumno 1\n    n = len(arr)\n    for i in range(n):\n        for j in range(0, n-i-1):\n            if arr[j] > arr[j+1]:\n                temp = arr[j]\n                arr[j] = arr[j+1]\n                arr[j+1] = temp\n    return arr\nprint(sort_burbuja([9,1,5]))', 'evaluated', 81.00, 'PLAGIO: stress test alumno 002', 1, UNIX_TIMESTAMP()-506285, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress002'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def ordenar_2(lista):\n    tam = len(lista)\n    for i in range(tam):\n        for j in range(0, tam-i-1):\n            if lista[j] > lista[j+1]:\n                lista[j], lista[j+1] = lista[j+1], lista[j]\n    return lista\nprint(ordenar_2([5,3,8,1]))', 'evaluated', 82.00, 'PLAGIO: stress test alumno 003', 1, UNIX_TIMESTAMP()-271085, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress003'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def sort_burbuja(arr):\n    # alumno 3\n    n = len(arr)\n    for i in range(n):\n        for j in range(0, n-i-1):\n            if arr[j] > arr[j+1]:\n                temp = arr[j]\n                arr[j] = arr[j+1]\n                arr[j+1] = temp\n    return arr\nprint(sort_burbuja([9,1,5]))', 'evaluated', 83.00, 'PLAGIO: stress test alumno 004', 1, UNIX_TIMESTAMP()-479933, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress004'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def ordenar_4(lista):\n    tam = len(lista)\n    for i in range(tam):\n        for j in range(0, tam-i-1):\n            if lista[j] > lista[j+1]:\n                lista[j], lista[j+1] = lista[j+1], lista[j]\n    return lista\nprint(ordenar_4([5,3,8,1]))', 'evaluated', 84.00, 'PLAGIO: stress test alumno 005', 1, UNIX_TIMESTAMP()-293197, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress005'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def sort_burbuja(arr):\n    # alumno 5\n    n = len(arr)\n    for i in range(n):\n        for j in range(0, n-i-1):\n            if arr[j] > arr[j+1]:\n                temp = arr[j]\n                arr[j] = arr[j+1]\n                arr[j+1] = temp\n    return arr\nprint(sort_burbuja([9,1,5]))', 'evaluated', 85.00, 'PLAGIO: stress test alumno 006', 1, UNIX_TIMESTAMP()-3984, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress006'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def ordenar_6(lista):\n    tam = len(lista)\n    for i in range(tam):\n        for j in range(0, tam-i-1):\n            if lista[j] > lista[j+1]:\n                lista[j], lista[j+1] = lista[j+1], lista[j]\n    return lista\nprint(ordenar_6([5,3,8,1]))', 'evaluated', 86.00, 'PLAGIO: stress test alumno 007', 1, UNIX_TIMESTAMP()-598735, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress007'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def sort_burbuja(arr):\n    # alumno 7\n    n = len(arr)\n    for i in range(n):\n        for j in range(0, n-i-1):\n            if arr[j] > arr[j+1]:\n                temp = arr[j]\n                arr[j] = arr[j+1]\n                arr[j+1] = temp\n    return arr\nprint(sort_burbuja([9,1,5]))', 'evaluated', 87.00, 'PLAGIO: stress test alumno 008', 1, UNIX_TIMESTAMP()-284219, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress008'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def ordenar_8(lista):\n    tam = len(lista)\n    for i in range(tam):\n        for j in range(0, tam-i-1):\n            if lista[j] > lista[j+1]:\n                lista[j], lista[j+1] = lista[j+1], lista[j]\n    return lista\nprint(ordenar_8([5,3,8,1]))', 'evaluated', 88.00, 'PLAGIO: stress test alumno 009', 1, UNIX_TIMESTAMP()-200653, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress009'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def sort_burbuja(arr):\n    # alumno 9\n    n = len(arr)\n    for i in range(n):\n        for j in range(0, n-i-1):\n            if arr[j] > arr[j+1]:\n                temp = arr[j]\n                arr[j] = arr[j+1]\n                arr[j+1] = temp\n    return arr\nprint(sort_burbuja([9,1,5]))', 'evaluated', 89.00, 'PLAGIO: stress test alumno 010', 1, UNIX_TIMESTAMP()-327819, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress010'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def ordenar_10(lista):\n    tam = len(lista)\n    for i in range(tam):\n        for j in range(0, tam-i-1):\n            if lista[j] > lista[j+1]:\n                lista[j], lista[j+1] = lista[j+1], lista[j]\n    return lista\nprint(ordenar_10([5,3,8,1]))', 'evaluated', 90.00, 'PLAGIO: stress test alumno 011', 1, UNIX_TIMESTAMP()-127420, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress011'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def sort_burbuja(arr):\n    # alumno 11\n    n = len(arr)\n    for i in range(n):\n        for j in range(0, n-i-1):\n            if arr[j] > arr[j+1]:\n                temp = arr[j]\n                arr[j] = arr[j+1]\n                arr[j+1] = temp\n    return arr\nprint(sort_burbuja([9,1,5]))', 'evaluated', 91.00, 'PLAGIO: stress test alumno 012', 1, UNIX_TIMESTAMP()-238585, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress012'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def ordenar_12(lista):\n    tam = len(lista)\n    for i in range(tam):\n        for j in range(0, tam-i-1):\n            if lista[j] > lista[j+1]:\n                lista[j], lista[j+1] = lista[j+1], lista[j]\n    return lista\nprint(ordenar_12([5,3,8,1]))', 'evaluated', 92.00, 'PLAGIO: stress test alumno 013', 1, UNIX_TIMESTAMP()-477973, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress013'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def sort_burbuja(arr):\n    # alumno 13\n    n = len(arr)\n    for i in range(n):\n        for j in range(0, n-i-1):\n            if arr[j] > arr[j+1]:\n                temp = arr[j]\n                arr[j] = arr[j+1]\n                arr[j+1] = temp\n    return arr\nprint(sort_burbuja([9,1,5]))', 'evaluated', 93.00, 'PLAGIO: stress test alumno 014', 1, UNIX_TIMESTAMP()-315670, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress014'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def ordenar_14(lista):\n    tam = len(lista)\n    for i in range(tam):\n        for j in range(0, tam-i-1):\n            if lista[j] > lista[j+1]:\n                lista[j], lista[j+1] = lista[j+1], lista[j]\n    return lista\nprint(ordenar_14([5,3,8,1]))', 'evaluated', 94.00, 'PLAGIO: stress test alumno 015', 1, UNIX_TIMESTAMP()-454157, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress015'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def sort_burbuja(arr):\n    # alumno 15\n    n = len(arr)\n    for i in range(n):\n        for j in range(0, n-i-1):\n            if arr[j] > arr[j+1]:\n                temp = arr[j]\n                arr[j] = arr[j+1]\n                arr[j+1] = temp\n    return arr\nprint(sort_burbuja([9,1,5]))', 'evaluated', 80.00, 'PLAGIO: stress test alumno 016', 1, UNIX_TIMESTAMP()-493628, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress016'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def ordenar_16(lista):\n    tam = len(lista)\n    for i in range(tam):\n        for j in range(0, tam-i-1):\n            if lista[j] > lista[j+1]:\n                lista[j], lista[j+1] = lista[j+1], lista[j]\n    return lista\nprint(ordenar_16([5,3,8,1]))', 'evaluated', 81.00, 'PLAGIO: stress test alumno 017', 1, UNIX_TIMESTAMP()-347163, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress017'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def sort_burbuja(arr):\n    # alumno 17\n    n = len(arr)\n    for i in range(n):\n        for j in range(0, n-i-1):\n            if arr[j] > arr[j+1]:\n                temp = arr[j]\n                arr[j] = arr[j+1]\n                arr[j+1] = temp\n    return arr\nprint(sort_burbuja([9,1,5]))', 'evaluated', 82.00, 'PLAGIO: stress test alumno 018', 1, UNIX_TIMESTAMP()-278907, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress018'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def ordenar_18(lista):\n    tam = len(lista)\n    for i in range(tam):\n        for j in range(0, tam-i-1):\n            if lista[j] > lista[j+1]:\n                lista[j], lista[j+1] = lista[j+1], lista[j]\n    return lista\nprint(ordenar_18([5,3,8,1]))', 'evaluated', 83.00, 'PLAGIO: stress test alumno 019', 1, UNIX_TIMESTAMP()-567435, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress019'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def sort_burbuja(arr):\n    # alumno 19\n    n = len(arr)\n    for i in range(n):\n        for j in range(0, n-i-1):\n            if arr[j] > arr[j+1]:\n                temp = arr[j]\n                arr[j] = arr[j+1]\n                arr[j+1] = temp\n    return arr\nprint(sort_burbuja([9,1,5]))', 'evaluated', 84.00, 'PLAGIO: stress test alumno 020', 1, UNIX_TIMESTAMP()-357625, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress020'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def ordenar_20(lista):\n    tam = len(lista)\n    for i in range(tam):\n        for j in range(0, tam-i-1):\n            if lista[j] > lista[j+1]:\n                lista[j], lista[j+1] = lista[j+1], lista[j]\n    return lista\nprint(ordenar_20([5,3,8,1]))', 'evaluated', 85.00, 'PLAGIO: stress test alumno 021', 1, UNIX_TIMESTAMP()-514645, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress021'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def sort_burbuja(arr):\n    # alumno 21\n    n = len(arr)\n    for i in range(n):\n        for j in range(0, n-i-1):\n            if arr[j] > arr[j+1]:\n                temp = arr[j]\n                arr[j] = arr[j+1]\n                arr[j+1] = temp\n    return arr\nprint(sort_burbuja([9,1,5]))', 'evaluated', 86.00, 'PLAGIO: stress test alumno 022', 1, UNIX_TIMESTAMP()-399613, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress022'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def ordenar_22(lista):\n    tam = len(lista)\n    for i in range(tam):\n        for j in range(0, tam-i-1):\n            if lista[j] > lista[j+1]:\n                lista[j], lista[j+1] = lista[j+1], lista[j]\n    return lista\nprint(ordenar_22([5,3,8,1]))', 'evaluated', 87.00, 'PLAGIO: stress test alumno 023', 1, UNIX_TIMESTAMP()-369530, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress023'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def sort_burbuja(arr):\n    # alumno 23\n    n = len(arr)\n    for i in range(n):\n        for j in range(0, n-i-1):\n            if arr[j] > arr[j+1]:\n                temp = arr[j]\n                arr[j] = arr[j+1]\n                arr[j+1] = temp\n    return arr\nprint(sort_burbuja([9,1,5]))', 'evaluated', 88.00, 'PLAGIO: stress test alumno 024', 1, UNIX_TIMESTAMP()-461310, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress024'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def ordenar_24(lista):\n    tam = len(lista)\n    for i in range(tam):\n        for j in range(0, tam-i-1):\n            if lista[j] > lista[j+1]:\n                lista[j], lista[j+1] = lista[j+1], lista[j]\n    return lista\nprint(ordenar_24([5,3,8,1]))', 'evaluated', 89.00, 'PLAGIO: stress test alumno 025', 1, UNIX_TIMESTAMP()-337583, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress025'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def sort_burbuja(arr):\n    # alumno 25\n    n = len(arr)\n    for i in range(n):\n        for j in range(0, n-i-1):\n            if arr[j] > arr[j+1]:\n                temp = arr[j]\n                arr[j] = arr[j+1]\n                arr[j+1] = temp\n    return arr\nprint(sort_burbuja([9,1,5]))', 'evaluated', 90.00, 'PLAGIO: stress test alumno 026', 1, UNIX_TIMESTAMP()-356083, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress026'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def ordenar_26(lista):\n    tam = len(lista)\n    for i in range(tam):\n        for j in range(0, tam-i-1):\n            if lista[j] > lista[j+1]:\n                lista[j], lista[j+1] = lista[j+1], lista[j]\n    return lista\nprint(ordenar_26([5,3,8,1]))', 'evaluated', 91.00, 'PLAGIO: stress test alumno 027', 1, UNIX_TIMESTAMP()-240695, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress027'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def sort_burbuja(arr):\n    # alumno 27\n    n = len(arr)\n    for i in range(n):\n        for j in range(0, n-i-1):\n            if arr[j] > arr[j+1]:\n                temp = arr[j]\n                arr[j] = arr[j+1]\n                arr[j+1] = temp\n    return arr\nprint(sort_burbuja([9,1,5]))', 'evaluated', 92.00, 'PLAGIO: stress test alumno 028', 1, UNIX_TIMESTAMP()-601156, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress028'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def ordenar_28(lista):\n    tam = len(lista)\n    for i in range(tam):\n        for j in range(0, tam-i-1):\n            if lista[j] > lista[j+1]:\n                lista[j], lista[j+1] = lista[j+1], lista[j]\n    return lista\nprint(ordenar_28([5,3,8,1]))', 'evaluated', 93.00, 'PLAGIO: stress test alumno 029', 1, UNIX_TIMESTAMP()-560120, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress029'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def sort_burbuja(arr):\n    # alumno 29\n    n = len(arr)\n    for i in range(n):\n        for j in range(0, n-i-1):\n            if arr[j] > arr[j+1]:\n                temp = arr[j]\n                arr[j] = arr[j+1]\n                arr[j+1] = temp\n    return arr\nprint(sort_burbuja([9,1,5]))', 'evaluated', 94.00, 'PLAGIO: stress test alumno 030', 1, UNIX_TIMESTAMP()-33640, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress030'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def ordenar_30(lista):\n    tam = len(lista)\n    for i in range(tam):\n        for j in range(0, tam-i-1):\n            if lista[j] > lista[j+1]:\n                lista[j], lista[j+1] = lista[j+1], lista[j]\n    return lista\nprint(ordenar_30([5,3,8,1]))', 'evaluated', 80.00, 'PLAGIO: stress test alumno 031', 1, UNIX_TIMESTAMP()-335533, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress031'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def sort_burbuja(arr):\n    # alumno 31\n    n = len(arr)\n    for i in range(n):\n        for j in range(0, n-i-1):\n            if arr[j] > arr[j+1]:\n                temp = arr[j]\n                arr[j] = arr[j+1]\n                arr[j+1] = temp\n    return arr\nprint(sort_burbuja([9,1,5]))', 'evaluated', 81.00, 'PLAGIO: stress test alumno 032', 1, UNIX_TIMESTAMP()-199605, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress032'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def ordenar_32(lista):\n    tam = len(lista)\n    for i in range(tam):\n        for j in range(0, tam-i-1):\n            if lista[j] > lista[j+1]:\n                lista[j], lista[j+1] = lista[j+1], lista[j]\n    return lista\nprint(ordenar_32([5,3,8,1]))', 'evaluated', 82.00, 'PLAGIO: stress test alumno 033', 1, UNIX_TIMESTAMP()-279192, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress033'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def sort_burbuja(arr):\n    # alumno 33\n    n = len(arr)\n    for i in range(n):\n        for j in range(0, n-i-1):\n            if arr[j] > arr[j+1]:\n                temp = arr[j]\n                arr[j] = arr[j+1]\n                arr[j+1] = temp\n    return arr\nprint(sort_burbuja([9,1,5]))', 'evaluated', 83.00, 'PLAGIO: stress test alumno 034', 1, UNIX_TIMESTAMP()-88010, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress034'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def ordenar_34(lista):\n    tam = len(lista)\n    for i in range(tam):\n        for j in range(0, tam-i-1):\n            if lista[j] > lista[j+1]:\n                lista[j], lista[j+1] = lista[j+1], lista[j]\n    return lista\nprint(ordenar_34([5,3,8,1]))', 'evaluated', 84.00, 'PLAGIO: stress test alumno 035', 1, UNIX_TIMESTAMP()-465602, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress035'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def sort_burbuja(arr):\n    # alumno 35\n    n = len(arr)\n    for i in range(n):\n        for j in range(0, n-i-1):\n            if arr[j] > arr[j+1]:\n                temp = arr[j]\n                arr[j] = arr[j+1]\n                arr[j+1] = temp\n    return arr\nprint(sort_burbuja([9,1,5]))', 'evaluated', 85.00, 'PLAGIO: stress test alumno 036', 1, UNIX_TIMESTAMP()-135637, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress036'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def ordenar_36(lista):\n    tam = len(lista)\n    for i in range(tam):\n        for j in range(0, tam-i-1):\n            if lista[j] > lista[j+1]:\n                lista[j], lista[j+1] = lista[j+1], lista[j]\n    return lista\nprint(ordenar_36([5,3,8,1]))', 'evaluated', 86.00, 'PLAGIO: stress test alumno 037', 1, UNIX_TIMESTAMP()-59746, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress037'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def sort_burbuja(arr):\n    # alumno 37\n    n = len(arr)\n    for i in range(n):\n        for j in range(0, n-i-1):\n            if arr[j] > arr[j+1]:\n                temp = arr[j]\n                arr[j] = arr[j+1]\n                arr[j+1] = temp\n    return arr\nprint(sort_burbuja([9,1,5]))', 'evaluated', 87.00, 'PLAGIO: stress test alumno 038', 1, UNIX_TIMESTAMP()-487532, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress038'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def ordenar_38(lista):\n    tam = len(lista)\n    for i in range(tam):\n        for j in range(0, tam-i-1):\n            if lista[j] > lista[j+1]:\n                lista[j], lista[j+1] = lista[j+1], lista[j]\n    return lista\nprint(ordenar_38([5,3,8,1]))', 'evaluated', 88.00, 'PLAGIO: stress test alumno 039', 1, UNIX_TIMESTAMP()-453302, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress039'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def sort_burbuja(arr):\n    # alumno 39\n    n = len(arr)\n    for i in range(n):\n        for j in range(0, n-i-1):\n            if arr[j] > arr[j+1]:\n                temp = arr[j]\n                arr[j] = arr[j+1]\n                arr[j+1] = temp\n    return arr\nprint(sort_burbuja([9,1,5]))', 'evaluated', 89.00, 'PLAGIO: stress test alumno 040', 1, UNIX_TIMESTAMP()-33483, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress040'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def bubble_opt_40(arr):\n    n = len(arr)\n    for i in range(n):\n        swapped = False\n        for j in range(0, n-i-1):\n            if arr[j] > arr[j+1]:\n                arr[j], arr[j+1] = arr[j+1], arr[j]\n                swapped = True\n        if not swapped: break\n    return arr\nprint(bubble_opt_40([3,1,2]))', 'evaluated', 70.00, 'SOSPECHOSO: stress test alumno 041', 1, UNIX_TIMESTAMP()-282213, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress041'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def bubble_opt_41(arr):\n    n = len(arr)\n    for i in range(n):\n        swapped = False\n        for j in range(0, n-i-1):\n            if arr[j] > arr[j+1]:\n                arr[j], arr[j+1] = arr[j+1], arr[j]\n                swapped = True\n        if not swapped: break\n    return arr\nprint(bubble_opt_41([3,1,2]))', 'evaluated', 71.00, 'SOSPECHOSO: stress test alumno 042', 1, UNIX_TIMESTAMP()-599771, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress042'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def bubble_opt_42(arr):\n    n = len(arr)\n    for i in range(n):\n        swapped = False\n        for j in range(0, n-i-1):\n            if arr[j] > arr[j+1]:\n                arr[j], arr[j+1] = arr[j+1], arr[j]\n                swapped = True\n        if not swapped: break\n    return arr\nprint(bubble_opt_42([3,1,2]))', 'evaluated', 72.00, 'SOSPECHOSO: stress test alumno 043', 1, UNIX_TIMESTAMP()-355727, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress043'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def bubble_opt_43(arr):\n    n = len(arr)\n    for i in range(n):\n        swapped = False\n        for j in range(0, n-i-1):\n            if arr[j] > arr[j+1]:\n                arr[j], arr[j+1] = arr[j+1], arr[j]\n                swapped = True\n        if not swapped: break\n    return arr\nprint(bubble_opt_43([3,1,2]))', 'evaluated', 73.00, 'SOSPECHOSO: stress test alumno 044', 1, UNIX_TIMESTAMP()-527941, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress044'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def bubble_opt_44(arr):\n    n = len(arr)\n    for i in range(n):\n        swapped = False\n        for j in range(0, n-i-1):\n            if arr[j] > arr[j+1]:\n                arr[j], arr[j+1] = arr[j+1], arr[j]\n                swapped = True\n        if not swapped: break\n    return arr\nprint(bubble_opt_44([3,1,2]))', 'evaluated', 74.00, 'SOSPECHOSO: stress test alumno 045', 1, UNIX_TIMESTAMP()-589058, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress045'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def bubble_opt_45(arr):\n    n = len(arr)\n    for i in range(n):\n        swapped = False\n        for j in range(0, n-i-1):\n            if arr[j] > arr[j+1]:\n                arr[j], arr[j+1] = arr[j+1], arr[j]\n                swapped = True\n        if not swapped: break\n    return arr\nprint(bubble_opt_45([3,1,2]))', 'evaluated', 75.00, 'SOSPECHOSO: stress test alumno 046', 1, UNIX_TIMESTAMP()-310896, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress046'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def bubble_opt_46(arr):\n    n = len(arr)\n    for i in range(n):\n        swapped = False\n        for j in range(0, n-i-1):\n            if arr[j] > arr[j+1]:\n                arr[j], arr[j+1] = arr[j+1], arr[j]\n                swapped = True\n        if not swapped: break\n    return arr\nprint(bubble_opt_46([3,1,2]))', 'evaluated', 76.00, 'SOSPECHOSO: stress test alumno 047', 1, UNIX_TIMESTAMP()-90004, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress047'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def bubble_opt_47(arr):\n    n = len(arr)\n    for i in range(n):\n        swapped = False\n        for j in range(0, n-i-1):\n            if arr[j] > arr[j+1]:\n                arr[j], arr[j+1] = arr[j+1], arr[j]\n                swapped = True\n        if not swapped: break\n    return arr\nprint(bubble_opt_47([3,1,2]))', 'evaluated', 77.00, 'SOSPECHOSO: stress test alumno 048', 1, UNIX_TIMESTAMP()-321031, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress048'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def bubble_opt_48(arr):\n    n = len(arr)\n    for i in range(n):\n        swapped = False\n        for j in range(0, n-i-1):\n            if arr[j] > arr[j+1]:\n                arr[j], arr[j+1] = arr[j+1], arr[j]\n                swapped = True\n        if not swapped: break\n    return arr\nprint(bubble_opt_48([3,1,2]))', 'evaluated', 78.00, 'SOSPECHOSO: stress test alumno 049', 1, UNIX_TIMESTAMP()-354068, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress049'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def bubble_opt_49(arr):\n    n = len(arr)\n    for i in range(n):\n        swapped = False\n        for j in range(0, n-i-1):\n            if arr[j] > arr[j+1]:\n                arr[j], arr[j+1] = arr[j+1], arr[j]\n                swapped = True\n        if not swapped: break\n    return arr\nprint(bubble_opt_49([3,1,2]))', 'evaluated', 79.00, 'SOSPECHOSO: stress test alumno 050', 1, UNIX_TIMESTAMP()-148847, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress050'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def bubble_opt_50(arr):\n    n = len(arr)\n    for i in range(n):\n        swapped = False\n        for j in range(0, n-i-1):\n            if arr[j] > arr[j+1]:\n                arr[j], arr[j+1] = arr[j+1], arr[j]\n                swapped = True\n        if not swapped: break\n    return arr\nprint(bubble_opt_50([3,1,2]))', 'evaluated', 70.00, 'SOSPECHOSO: stress test alumno 051', 1, UNIX_TIMESTAMP()-12750, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress051'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def bubble_opt_51(arr):\n    n = len(arr)\n    for i in range(n):\n        swapped = False\n        for j in range(0, n-i-1):\n            if arr[j] > arr[j+1]:\n                arr[j], arr[j+1] = arr[j+1], arr[j]\n                swapped = True\n        if not swapped: break\n    return arr\nprint(bubble_opt_51([3,1,2]))', 'evaluated', 71.00, 'SOSPECHOSO: stress test alumno 052', 1, UNIX_TIMESTAMP()-131004, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress052'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def bubble_opt_52(arr):\n    n = len(arr)\n    for i in range(n):\n        swapped = False\n        for j in range(0, n-i-1):\n            if arr[j] > arr[j+1]:\n                arr[j], arr[j+1] = arr[j+1], arr[j]\n                swapped = True\n        if not swapped: break\n    return arr\nprint(bubble_opt_52([3,1,2]))', 'evaluated', 72.00, 'SOSPECHOSO: stress test alumno 053', 1, UNIX_TIMESTAMP()-46274, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress053'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def bubble_opt_53(arr):\n    n = len(arr)\n    for i in range(n):\n        swapped = False\n        for j in range(0, n-i-1):\n            if arr[j] > arr[j+1]:\n                arr[j], arr[j+1] = arr[j+1], arr[j]\n                swapped = True\n        if not swapped: break\n    return arr\nprint(bubble_opt_53([3,1,2]))', 'evaluated', 73.00, 'SOSPECHOSO: stress test alumno 054', 1, UNIX_TIMESTAMP()-164739, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress054'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def bubble_opt_54(arr):\n    n = len(arr)\n    for i in range(n):\n        swapped = False\n        for j in range(0, n-i-1):\n            if arr[j] > arr[j+1]:\n                arr[j], arr[j+1] = arr[j+1], arr[j]\n                swapped = True\n        if not swapped: break\n    return arr\nprint(bubble_opt_54([3,1,2]))', 'evaluated', 74.00, 'SOSPECHOSO: stress test alumno 055', 1, UNIX_TIMESTAMP()-536852, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress055'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def bubble_opt_55(arr):\n    n = len(arr)\n    for i in range(n):\n        swapped = False\n        for j in range(0, n-i-1):\n            if arr[j] > arr[j+1]:\n                arr[j], arr[j+1] = arr[j+1], arr[j]\n                swapped = True\n        if not swapped: break\n    return arr\nprint(bubble_opt_55([3,1,2]))', 'evaluated', 75.00, 'SOSPECHOSO: stress test alumno 056', 1, UNIX_TIMESTAMP()-276700, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress056'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def bubble_opt_56(arr):\n    n = len(arr)\n    for i in range(n):\n        swapped = False\n        for j in range(0, n-i-1):\n            if arr[j] > arr[j+1]:\n                arr[j], arr[j+1] = arr[j+1], arr[j]\n                swapped = True\n        if not swapped: break\n    return arr\nprint(bubble_opt_56([3,1,2]))', 'evaluated', 76.00, 'SOSPECHOSO: stress test alumno 057', 1, UNIX_TIMESTAMP()-338179, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress057'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def bubble_opt_57(arr):\n    n = len(arr)\n    for i in range(n):\n        swapped = False\n        for j in range(0, n-i-1):\n            if arr[j] > arr[j+1]:\n                arr[j], arr[j+1] = arr[j+1], arr[j]\n                swapped = True\n        if not swapped: break\n    return arr\nprint(bubble_opt_57([3,1,2]))', 'evaluated', 77.00, 'SOSPECHOSO: stress test alumno 058', 1, UNIX_TIMESTAMP()-349654, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress058'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def bubble_opt_58(arr):\n    n = len(arr)\n    for i in range(n):\n        swapped = False\n        for j in range(0, n-i-1):\n            if arr[j] > arr[j+1]:\n                arr[j], arr[j+1] = arr[j+1], arr[j]\n                swapped = True\n        if not swapped: break\n    return arr\nprint(bubble_opt_58([3,1,2]))', 'evaluated', 78.00, 'SOSPECHOSO: stress test alumno 059', 1, UNIX_TIMESTAMP()-186344, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress059'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def bubble_opt_59(arr):\n    n = len(arr)\n    for i in range(n):\n        swapped = False\n        for j in range(0, n-i-1):\n            if arr[j] > arr[j+1]:\n                arr[j], arr[j+1] = arr[j+1], arr[j]\n                swapped = True\n        if not swapped: break\n    return arr\nprint(bubble_opt_59([3,1,2]))', 'evaluated', 79.00, 'SOSPECHOSO: stress test alumno 060', 1, UNIX_TIMESTAMP()-62708, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress060'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def selection_sort_60(arr):\n    for i in range(len(arr)):\n        min_idx = i\n        for j in range(i+1, len(arr)):\n            if arr[j] < arr[min_idx]: min_idx = j\n        arr[i], arr[min_idx] = arr[min_idx], arr[i]\n    return arr\nprint(selection_sort_60([5,2,8]))', 'evaluated', 85.00, 'ORIGINAL: stress test alumno 061', 1, UNIX_TIMESTAMP()-284201, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress061'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def merge_sort_61(arr):\n    if len(arr) <= 1: return arr\n    mid = len(arr)//2\n    left = merge_sort_61(arr[:mid])\n    right = merge_sort_61(arr[mid:])\n    return merge(left, right)\ndef merge(l,r):\n    res=[]\n    i=j=0\n    while i<len(l) and j<len(r):\n        if l[i]<=r[j]: res.append(l[i]); i+=1\n        else: res.append(r[j]); j+=1\n    res.extend(l[i:]); res.extend(r[j:])\n    return res\nprint(merge_sort_61([5,2,8]))', 'evaluated', 86.00, 'ORIGINAL: stress test alumno 062', 1, UNIX_TIMESTAMP()-303066, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress062'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def quick_sort_62(arr):\n    if len(arr)<=1: return arr\n    pivot=arr[len(arr)//2]\n    left=[x for x in arr if x<pivot]\n    mid=[x for x in arr if x==pivot]\n    right=[x for x in arr if x>pivot]\n    return quick_sort_62(left)+mid+quick_sort_62(right)\nprint(quick_sort_62([5,2,8]))', 'evaluated', 87.00, 'ORIGINAL: stress test alumno 063', 1, UNIX_TIMESTAMP()-453309, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress063'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def selection_sort_63(arr):\n    for i in range(len(arr)):\n        min_idx = i\n        for j in range(i+1, len(arr)):\n            if arr[j] < arr[min_idx]: min_idx = j\n        arr[i], arr[min_idx] = arr[min_idx], arr[i]\n    return arr\nprint(selection_sort_63([5,2,8]))', 'evaluated', 88.00, 'ORIGINAL: stress test alumno 064', 1, UNIX_TIMESTAMP()-529532, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress064'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def merge_sort_64(arr):\n    if len(arr) <= 1: return arr\n    mid = len(arr)//2\n    left = merge_sort_64(arr[:mid])\n    right = merge_sort_64(arr[mid:])\n    return merge(left, right)\ndef merge(l,r):\n    res=[]\n    i=j=0\n    while i<len(l) and j<len(r):\n        if l[i]<=r[j]: res.append(l[i]); i+=1\n        else: res.append(r[j]); j+=1\n    res.extend(l[i:]); res.extend(r[j:])\n    return res\nprint(merge_sort_64([5,2,8]))', 'evaluated', 89.00, 'ORIGINAL: stress test alumno 065', 1, UNIX_TIMESTAMP()-267578, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress065'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def quick_sort_65(arr):\n    if len(arr)<=1: return arr\n    pivot=arr[len(arr)//2]\n    left=[x for x in arr if x<pivot]\n    mid=[x for x in arr if x==pivot]\n    right=[x for x in arr if x>pivot]\n    return quick_sort_65(left)+mid+quick_sort_65(right)\nprint(quick_sort_65([5,2,8]))', 'evaluated', 90.00, 'ORIGINAL: stress test alumno 066', 1, UNIX_TIMESTAMP()-20535, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress066'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def selection_sort_66(arr):\n    for i in range(len(arr)):\n        min_idx = i\n        for j in range(i+1, len(arr)):\n            if arr[j] < arr[min_idx]: min_idx = j\n        arr[i], arr[min_idx] = arr[min_idx], arr[i]\n    return arr\nprint(selection_sort_66([5,2,8]))', 'evaluated', 91.00, 'ORIGINAL: stress test alumno 067', 1, UNIX_TIMESTAMP()-414118, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress067'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def merge_sort_67(arr):\n    if len(arr) <= 1: return arr\n    mid = len(arr)//2\n    left = merge_sort_67(arr[:mid])\n    right = merge_sort_67(arr[mid:])\n    return merge(left, right)\ndef merge(l,r):\n    res=[]\n    i=j=0\n    while i<len(l) and j<len(r):\n        if l[i]<=r[j]: res.append(l[i]); i+=1\n        else: res.append(r[j]); j+=1\n    res.extend(l[i:]); res.extend(r[j:])\n    return res\nprint(merge_sort_67([5,2,8]))', 'evaluated', 92.00, 'ORIGINAL: stress test alumno 068', 1, UNIX_TIMESTAMP()-267974, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress068'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def quick_sort_68(arr):\n    if len(arr)<=1: return arr\n    pivot=arr[len(arr)//2]\n    left=[x for x in arr if x<pivot]\n    mid=[x for x in arr if x==pivot]\n    right=[x for x in arr if x>pivot]\n    return quick_sort_68(left)+mid+quick_sort_68(right)\nprint(quick_sort_68([5,2,8]))', 'evaluated', 93.00, 'ORIGINAL: stress test alumno 069', 1, UNIX_TIMESTAMP()-486362, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress069'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def selection_sort_69(arr):\n    for i in range(len(arr)):\n        min_idx = i\n        for j in range(i+1, len(arr)):\n            if arr[j] < arr[min_idx]: min_idx = j\n        arr[i], arr[min_idx] = arr[min_idx], arr[i]\n    return arr\nprint(selection_sort_69([5,2,8]))', 'evaluated', 94.00, 'ORIGINAL: stress test alumno 070', 1, UNIX_TIMESTAMP()-459875, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress070'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def merge_sort_70(arr):\n    if len(arr) <= 1: return arr\n    mid = len(arr)//2\n    left = merge_sort_70(arr[:mid])\n    right = merge_sort_70(arr[mid:])\n    return merge(left, right)\ndef merge(l,r):\n    res=[]\n    i=j=0\n    while i<len(l) and j<len(r):\n        if l[i]<=r[j]: res.append(l[i]); i+=1\n        else: res.append(r[j]); j+=1\n    res.extend(l[i:]); res.extend(r[j:])\n    return res\nprint(merge_sort_70([5,2,8]))', 'evaluated', 95.00, 'ORIGINAL: stress test alumno 071', 1, UNIX_TIMESTAMP()-524499, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress071'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def quick_sort_71(arr):\n    if len(arr)<=1: return arr\n    pivot=arr[len(arr)//2]\n    left=[x for x in arr if x<pivot]\n    mid=[x for x in arr if x==pivot]\n    right=[x for x in arr if x>pivot]\n    return quick_sort_71(left)+mid+quick_sort_71(right)\nprint(quick_sort_71([5,2,8]))', 'evaluated', 96.00, 'ORIGINAL: stress test alumno 072', 1, UNIX_TIMESTAMP()-487867, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress072'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def selection_sort_72(arr):\n    for i in range(len(arr)):\n        min_idx = i\n        for j in range(i+1, len(arr)):\n            if arr[j] < arr[min_idx]: min_idx = j\n        arr[i], arr[min_idx] = arr[min_idx], arr[i]\n    return arr\nprint(selection_sort_72([5,2,8]))', 'evaluated', 85.00, 'ORIGINAL: stress test alumno 073', 1, UNIX_TIMESTAMP()-73547, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress073'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def merge_sort_73(arr):\n    if len(arr) <= 1: return arr\n    mid = len(arr)//2\n    left = merge_sort_73(arr[:mid])\n    right = merge_sort_73(arr[mid:])\n    return merge(left, right)\ndef merge(l,r):\n    res=[]\n    i=j=0\n    while i<len(l) and j<len(r):\n        if l[i]<=r[j]: res.append(l[i]); i+=1\n        else: res.append(r[j]); j+=1\n    res.extend(l[i:]); res.extend(r[j:])\n    return res\nprint(merge_sort_73([5,2,8]))', 'evaluated', 86.00, 'ORIGINAL: stress test alumno 074', 1, UNIX_TIMESTAMP()-249098, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress074'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def quick_sort_74(arr):\n    if len(arr)<=1: return arr\n    pivot=arr[len(arr)//2]\n    left=[x for x in arr if x<pivot]\n    mid=[x for x in arr if x==pivot]\n    right=[x for x in arr if x>pivot]\n    return quick_sort_74(left)+mid+quick_sort_74(right)\nprint(quick_sort_74([5,2,8]))', 'evaluated', 87.00, 'ORIGINAL: stress test alumno 075', 1, UNIX_TIMESTAMP()-217182, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress075'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def selection_sort_75(arr):\n    for i in range(len(arr)):\n        min_idx = i\n        for j in range(i+1, len(arr)):\n            if arr[j] < arr[min_idx]: min_idx = j\n        arr[i], arr[min_idx] = arr[min_idx], arr[i]\n    return arr\nprint(selection_sort_75([5,2,8]))', 'evaluated', 88.00, 'ORIGINAL: stress test alumno 076', 1, UNIX_TIMESTAMP()-140060, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress076'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def merge_sort_76(arr):\n    if len(arr) <= 1: return arr\n    mid = len(arr)//2\n    left = merge_sort_76(arr[:mid])\n    right = merge_sort_76(arr[mid:])\n    return merge(left, right)\ndef merge(l,r):\n    res=[]\n    i=j=0\n    while i<len(l) and j<len(r):\n        if l[i]<=r[j]: res.append(l[i]); i+=1\n        else: res.append(r[j]); j+=1\n    res.extend(l[i:]); res.extend(r[j:])\n    return res\nprint(merge_sort_76([5,2,8]))', 'evaluated', 89.00, 'ORIGINAL: stress test alumno 077', 1, UNIX_TIMESTAMP()-177347, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress077'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def quick_sort_77(arr):\n    if len(arr)<=1: return arr\n    pivot=arr[len(arr)//2]\n    left=[x for x in arr if x<pivot]\n    mid=[x for x in arr if x==pivot]\n    right=[x for x in arr if x>pivot]\n    return quick_sort_77(left)+mid+quick_sort_77(right)\nprint(quick_sort_77([5,2,8]))', 'evaluated', 90.00, 'ORIGINAL: stress test alumno 078', 1, UNIX_TIMESTAMP()-82677, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress078'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def selection_sort_78(arr):\n    for i in range(len(arr)):\n        min_idx = i\n        for j in range(i+1, len(arr)):\n            if arr[j] < arr[min_idx]: min_idx = j\n        arr[i], arr[min_idx] = arr[min_idx], arr[i]\n    return arr\nprint(selection_sort_78([5,2,8]))', 'evaluated', 91.00, 'ORIGINAL: stress test alumno 079', 1, UNIX_TIMESTAMP()-308286, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress079'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def merge_sort_79(arr):\n    if len(arr) <= 1: return arr\n    mid = len(arr)//2\n    left = merge_sort_79(arr[:mid])\n    right = merge_sort_79(arr[mid:])\n    return merge(left, right)\ndef merge(l,r):\n    res=[]\n    i=j=0\n    while i<len(l) and j<len(r):\n        if l[i]<=r[j]: res.append(l[i]); i+=1\n        else: res.append(r[j]); j+=1\n    res.extend(l[i:]); res.extend(r[j:])\n    return res\nprint(merge_sort_79([5,2,8]))', 'evaluated', 92.00, 'ORIGINAL: stress test alumno 080', 1, UNIX_TIMESTAMP()-369391, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress080'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def quick_sort_80(arr):\n    if len(arr)<=1: return arr\n    pivot=arr[len(arr)//2]\n    left=[x for x in arr if x<pivot]\n    mid=[x for x in arr if x==pivot]\n    right=[x for x in arr if x>pivot]\n    return quick_sort_80(left)+mid+quick_sort_80(right)\nprint(quick_sort_80([5,2,8]))', 'evaluated', 93.00, 'ORIGINAL: stress test alumno 081', 1, UNIX_TIMESTAMP()-344218, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress081'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def selection_sort_81(arr):\n    for i in range(len(arr)):\n        min_idx = i\n        for j in range(i+1, len(arr)):\n            if arr[j] < arr[min_idx]: min_idx = j\n        arr[i], arr[min_idx] = arr[min_idx], arr[i]\n    return arr\nprint(selection_sort_81([5,2,8]))', 'evaluated', 94.00, 'ORIGINAL: stress test alumno 082', 1, UNIX_TIMESTAMP()-405084, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress082'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def merge_sort_82(arr):\n    if len(arr) <= 1: return arr\n    mid = len(arr)//2\n    left = merge_sort_82(arr[:mid])\n    right = merge_sort_82(arr[mid:])\n    return merge(left, right)\ndef merge(l,r):\n    res=[]\n    i=j=0\n    while i<len(l) and j<len(r):\n        if l[i]<=r[j]: res.append(l[i]); i+=1\n        else: res.append(r[j]); j+=1\n    res.extend(l[i:]); res.extend(r[j:])\n    return res\nprint(merge_sort_82([5,2,8]))', 'evaluated', 95.00, 'ORIGINAL: stress test alumno 083', 1, UNIX_TIMESTAMP()-73551, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress083'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def quick_sort_83(arr):\n    if len(arr)<=1: return arr\n    pivot=arr[len(arr)//2]\n    left=[x for x in arr if x<pivot]\n    mid=[x for x in arr if x==pivot]\n    right=[x for x in arr if x>pivot]\n    return quick_sort_83(left)+mid+quick_sort_83(right)\nprint(quick_sort_83([5,2,8]))', 'evaluated', 96.00, 'ORIGINAL: stress test alumno 084', 1, UNIX_TIMESTAMP()-377763, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress084'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def selection_sort_84(arr):\n    for i in range(len(arr)):\n        min_idx = i\n        for j in range(i+1, len(arr)):\n            if arr[j] < arr[min_idx]: min_idx = j\n        arr[i], arr[min_idx] = arr[min_idx], arr[i]\n    return arr\nprint(selection_sort_84([5,2,8]))', 'evaluated', 85.00, 'ORIGINAL: stress test alumno 085', 1, UNIX_TIMESTAMP()-433968, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress085'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def merge_sort_85(arr):\n    if len(arr) <= 1: return arr\n    mid = len(arr)//2\n    left = merge_sort_85(arr[:mid])\n    right = merge_sort_85(arr[mid:])\n    return merge(left, right)\ndef merge(l,r):\n    res=[]\n    i=j=0\n    while i<len(l) and j<len(r):\n        if l[i]<=r[j]: res.append(l[i]); i+=1\n        else: res.append(r[j]); j+=1\n    res.extend(l[i:]); res.extend(r[j:])\n    return res\nprint(merge_sort_85([5,2,8]))', 'evaluated', 86.00, 'ORIGINAL: stress test alumno 086', 1, UNIX_TIMESTAMP()-275470, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress086'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def quick_sort_86(arr):\n    if len(arr)<=1: return arr\n    pivot=arr[len(arr)//2]\n    left=[x for x in arr if x<pivot]\n    mid=[x for x in arr if x==pivot]\n    right=[x for x in arr if x>pivot]\n    return quick_sort_86(left)+mid+quick_sort_86(right)\nprint(quick_sort_86([5,2,8]))', 'evaluated', 87.00, 'ORIGINAL: stress test alumno 087', 1, UNIX_TIMESTAMP()-544488, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress087'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def selection_sort_87(arr):\n    for i in range(len(arr)):\n        min_idx = i\n        for j in range(i+1, len(arr)):\n            if arr[j] < arr[min_idx]: min_idx = j\n        arr[i], arr[min_idx] = arr[min_idx], arr[i]\n    return arr\nprint(selection_sort_87([5,2,8]))', 'evaluated', 88.00, 'ORIGINAL: stress test alumno 088', 1, UNIX_TIMESTAMP()-90220, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress088'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def merge_sort_88(arr):\n    if len(arr) <= 1: return arr\n    mid = len(arr)//2\n    left = merge_sort_88(arr[:mid])\n    right = merge_sort_88(arr[mid:])\n    return merge(left, right)\ndef merge(l,r):\n    res=[]\n    i=j=0\n    while i<len(l) and j<len(r):\n        if l[i]<=r[j]: res.append(l[i]); i+=1\n        else: res.append(r[j]); j+=1\n    res.extend(l[i:]); res.extend(r[j:])\n    return res\nprint(merge_sort_88([5,2,8]))', 'evaluated', 89.00, 'ORIGINAL: stress test alumno 089', 1, UNIX_TIMESTAMP()-102246, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress089'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def quick_sort_89(arr):\n    if len(arr)<=1: return arr\n    pivot=arr[len(arr)//2]\n    left=[x for x in arr if x<pivot]\n    mid=[x for x in arr if x==pivot]\n    right=[x for x in arr if x>pivot]\n    return quick_sort_89(left)+mid+quick_sort_89(right)\nprint(quick_sort_89([5,2,8]))', 'evaluated', 90.00, 'ORIGINAL: stress test alumno 090', 1, UNIX_TIMESTAMP()-34725, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress090'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def selection_sort_90(arr):\n    for i in range(len(arr)):\n        min_idx = i\n        for j in range(i+1, len(arr)):\n            if arr[j] < arr[min_idx]: min_idx = j\n        arr[i], arr[min_idx] = arr[min_idx], arr[i]\n    return arr\nprint(selection_sort_90([5,2,8]))', 'evaluated', 91.00, 'ORIGINAL: stress test alumno 091', 1, UNIX_TIMESTAMP()-540817, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress091'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def merge_sort_91(arr):\n    if len(arr) <= 1: return arr\n    mid = len(arr)//2\n    left = merge_sort_91(arr[:mid])\n    right = merge_sort_91(arr[mid:])\n    return merge(left, right)\ndef merge(l,r):\n    res=[]\n    i=j=0\n    while i<len(l) and j<len(r):\n        if l[i]<=r[j]: res.append(l[i]); i+=1\n        else: res.append(r[j]); j+=1\n    res.extend(l[i:]); res.extend(r[j:])\n    return res\nprint(merge_sort_91([5,2,8]))', 'evaluated', 92.00, 'ORIGINAL: stress test alumno 092', 1, UNIX_TIMESTAMP()-601092, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress092'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def quick_sort_92(arr):\n    if len(arr)<=1: return arr\n    pivot=arr[len(arr)//2]\n    left=[x for x in arr if x<pivot]\n    mid=[x for x in arr if x==pivot]\n    right=[x for x in arr if x>pivot]\n    return quick_sort_92(left)+mid+quick_sort_92(right)\nprint(quick_sort_92([5,2,8]))', 'evaluated', 93.00, 'ORIGINAL: stress test alumno 093', 1, UNIX_TIMESTAMP()-178388, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress093'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def selection_sort_93(arr):\n    for i in range(len(arr)):\n        min_idx = i\n        for j in range(i+1, len(arr)):\n            if arr[j] < arr[min_idx]: min_idx = j\n        arr[i], arr[min_idx] = arr[min_idx], arr[i]\n    return arr\nprint(selection_sort_93([5,2,8]))', 'evaluated', 94.00, 'ORIGINAL: stress test alumno 094', 1, UNIX_TIMESTAMP()-531929, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress094'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def merge_sort_94(arr):\n    if len(arr) <= 1: return arr\n    mid = len(arr)//2\n    left = merge_sort_94(arr[:mid])\n    right = merge_sort_94(arr[mid:])\n    return merge(left, right)\ndef merge(l,r):\n    res=[]\n    i=j=0\n    while i<len(l) and j<len(r):\n        if l[i]<=r[j]: res.append(l[i]); i+=1\n        else: res.append(r[j]); j+=1\n    res.extend(l[i:]); res.extend(r[j:])\n    return res\nprint(merge_sort_94([5,2,8]))', 'evaluated', 95.00, 'ORIGINAL: stress test alumno 095', 1, UNIX_TIMESTAMP()-412070, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress095'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def quick_sort_95(arr):\n    if len(arr)<=1: return arr\n    pivot=arr[len(arr)//2]\n    left=[x for x in arr if x<pivot]\n    mid=[x for x in arr if x==pivot]\n    right=[x for x in arr if x>pivot]\n    return quick_sort_95(left)+mid+quick_sort_95(right)\nprint(quick_sort_95([5,2,8]))', 'evaluated', 96.00, 'ORIGINAL: stress test alumno 096', 1, UNIX_TIMESTAMP()-153151, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress096'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def selection_sort_96(arr):\n    for i in range(len(arr)):\n        min_idx = i\n        for j in range(i+1, len(arr)):\n            if arr[j] < arr[min_idx]: min_idx = j\n        arr[i], arr[min_idx] = arr[min_idx], arr[i]\n    return arr\nprint(selection_sort_96([5,2,8]))', 'evaluated', 85.00, 'ORIGINAL: stress test alumno 097', 1, UNIX_TIMESTAMP()-445420, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress097'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def merge_sort_97(arr):\n    if len(arr) <= 1: return arr\n    mid = len(arr)//2\n    left = merge_sort_97(arr[:mid])\n    right = merge_sort_97(arr[mid:])\n    return merge(left, right)\ndef merge(l,r):\n    res=[]\n    i=j=0\n    while i<len(l) and j<len(r):\n        if l[i]<=r[j]: res.append(l[i]); i+=1\n        else: res.append(r[j]); j+=1\n    res.extend(l[i:]); res.extend(r[j:])\n    return res\nprint(merge_sort_97([5,2,8]))', 'evaluated', 86.00, 'ORIGINAL: stress test alumno 098', 1, UNIX_TIMESTAMP()-484580, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress098'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def quick_sort_98(arr):\n    if len(arr)<=1: return arr\n    pivot=arr[len(arr)//2]\n    left=[x for x in arr if x<pivot]\n    mid=[x for x in arr if x==pivot]\n    right=[x for x in arr if x>pivot]\n    return quick_sort_98(left)+mid+quick_sort_98(right)\nprint(quick_sort_98([5,2,8]))', 'evaluated', 87.00, 'ORIGINAL: stress test alumno 099', 1, UNIX_TIMESTAMP()-541147, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress099'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def selection_sort_99(arr):\n    for i in range(len(arr)):\n        min_idx = i\n        for j in range(i+1, len(arr)):\n            if arr[j] < arr[min_idx]: min_idx = j\n        arr[i], arr[min_idx] = arr[min_idx], arr[i]\n    return arr\nprint(selection_sort_99([5,2,8]))', 'evaluated', 88.00, 'ORIGINAL: stress test alumno 100', 1, UNIX_TIMESTAMP()-545565, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress100'
WHERE c.shortname='test' AND a.name='Stress Test: Ordenamiento';

-- ── PASO 6: Envíos para "Stress Test: Fibonacci" ────────────────────
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fibonacci(n):\n    if n <= 0: return 0\n    if n == 1: return 1\n    return fibonacci(n-1) + fibonacci(n-2)\n\nfor i in range(10): print(fibonacci(i))', 'evaluated', 92.00, 'ORIGINAL_BASE: stress test alumno 001', 1, UNIX_TIMESTAMP()-488643, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress001'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fibonacci(n):\n    # version 1\n    if n <= 0: return 0\n    elif n == 1: return 1\n    else: return fibonacci(n-1) + fibonacci(n-2)\nfor i in range(10): print(fibonacci(i))', 'evaluated', 81.00, 'PLAGIO: stress test alumno 002', 1, UNIX_TIMESTAMP()-380187, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress002'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_2(num):\n    if num <= 0: return 0\n    if num == 1: return 1\n    return fib_2(num-1) + fib_2(num-2)\nfor i in range(10): print(fib_2(i))', 'evaluated', 82.00, 'PLAGIO: stress test alumno 003', 1, UNIX_TIMESTAMP()-174574, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress003'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fibonacci(n):\n    # version 3\n    if n <= 0: return 0\n    elif n == 1: return 1\n    else: return fibonacci(n-1) + fibonacci(n-2)\nfor i in range(10): print(fibonacci(i))', 'evaluated', 83.00, 'PLAGIO: stress test alumno 004', 1, UNIX_TIMESTAMP()-89528, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress004'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_4(num):\n    if num <= 0: return 0\n    if num == 1: return 1\n    return fib_4(num-1) + fib_4(num-2)\nfor i in range(10): print(fib_4(i))', 'evaluated', 84.00, 'PLAGIO: stress test alumno 005', 1, UNIX_TIMESTAMP()-422745, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress005'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fibonacci(n):\n    # version 5\n    if n <= 0: return 0\n    elif n == 1: return 1\n    else: return fibonacci(n-1) + fibonacci(n-2)\nfor i in range(10): print(fibonacci(i))', 'evaluated', 85.00, 'PLAGIO: stress test alumno 006', 1, UNIX_TIMESTAMP()-225061, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress006'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_6(num):\n    if num <= 0: return 0\n    if num == 1: return 1\n    return fib_6(num-1) + fib_6(num-2)\nfor i in range(10): print(fib_6(i))', 'evaluated', 86.00, 'PLAGIO: stress test alumno 007', 1, UNIX_TIMESTAMP()-591955, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress007'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fibonacci(n):\n    # version 7\n    if n <= 0: return 0\n    elif n == 1: return 1\n    else: return fibonacci(n-1) + fibonacci(n-2)\nfor i in range(10): print(fibonacci(i))', 'evaluated', 87.00, 'PLAGIO: stress test alumno 008', 1, UNIX_TIMESTAMP()-176997, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress008'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_8(num):\n    if num <= 0: return 0\n    if num == 1: return 1\n    return fib_8(num-1) + fib_8(num-2)\nfor i in range(10): print(fib_8(i))', 'evaluated', 88.00, 'PLAGIO: stress test alumno 009', 1, UNIX_TIMESTAMP()-376755, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress009'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fibonacci(n):\n    # version 9\n    if n <= 0: return 0\n    elif n == 1: return 1\n    else: return fibonacci(n-1) + fibonacci(n-2)\nfor i in range(10): print(fibonacci(i))', 'evaluated', 89.00, 'PLAGIO: stress test alumno 010', 1, UNIX_TIMESTAMP()-103004, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress010'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_10(num):\n    if num <= 0: return 0\n    if num == 1: return 1\n    return fib_10(num-1) + fib_10(num-2)\nfor i in range(10): print(fib_10(i))', 'evaluated', 90.00, 'PLAGIO: stress test alumno 011', 1, UNIX_TIMESTAMP()-116368, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress011'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fibonacci(n):\n    # version 11\n    if n <= 0: return 0\n    elif n == 1: return 1\n    else: return fibonacci(n-1) + fibonacci(n-2)\nfor i in range(10): print(fibonacci(i))', 'evaluated', 91.00, 'PLAGIO: stress test alumno 012', 1, UNIX_TIMESTAMP()-32748, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress012'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_12(num):\n    if num <= 0: return 0\n    if num == 1: return 1\n    return fib_12(num-1) + fib_12(num-2)\nfor i in range(10): print(fib_12(i))', 'evaluated', 92.00, 'PLAGIO: stress test alumno 013', 1, UNIX_TIMESTAMP()-94892, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress013'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fibonacci(n):\n    # version 13\n    if n <= 0: return 0\n    elif n == 1: return 1\n    else: return fibonacci(n-1) + fibonacci(n-2)\nfor i in range(10): print(fibonacci(i))', 'evaluated', 93.00, 'PLAGIO: stress test alumno 014', 1, UNIX_TIMESTAMP()-337606, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress014'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_14(num):\n    if num <= 0: return 0\n    if num == 1: return 1\n    return fib_14(num-1) + fib_14(num-2)\nfor i in range(10): print(fib_14(i))', 'evaluated', 94.00, 'PLAGIO: stress test alumno 015', 1, UNIX_TIMESTAMP()-384155, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress015'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fibonacci(n):\n    # version 15\n    if n <= 0: return 0\n    elif n == 1: return 1\n    else: return fibonacci(n-1) + fibonacci(n-2)\nfor i in range(10): print(fibonacci(i))', 'evaluated', 80.00, 'PLAGIO: stress test alumno 016', 1, UNIX_TIMESTAMP()-466430, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress016'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_16(num):\n    if num <= 0: return 0\n    if num == 1: return 1\n    return fib_16(num-1) + fib_16(num-2)\nfor i in range(10): print(fib_16(i))', 'evaluated', 81.00, 'PLAGIO: stress test alumno 017', 1, UNIX_TIMESTAMP()-350335, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress017'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fibonacci(n):\n    # version 17\n    if n <= 0: return 0\n    elif n == 1: return 1\n    else: return fibonacci(n-1) + fibonacci(n-2)\nfor i in range(10): print(fibonacci(i))', 'evaluated', 82.00, 'PLAGIO: stress test alumno 018', 1, UNIX_TIMESTAMP()-423391, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress018'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_18(num):\n    if num <= 0: return 0\n    if num == 1: return 1\n    return fib_18(num-1) + fib_18(num-2)\nfor i in range(10): print(fib_18(i))', 'evaluated', 83.00, 'PLAGIO: stress test alumno 019', 1, UNIX_TIMESTAMP()-240382, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress019'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fibonacci(n):\n    # version 19\n    if n <= 0: return 0\n    elif n == 1: return 1\n    else: return fibonacci(n-1) + fibonacci(n-2)\nfor i in range(10): print(fibonacci(i))', 'evaluated', 84.00, 'PLAGIO: stress test alumno 020', 1, UNIX_TIMESTAMP()-461986, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress020'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_20(num):\n    if num <= 0: return 0\n    if num == 1: return 1\n    return fib_20(num-1) + fib_20(num-2)\nfor i in range(10): print(fib_20(i))', 'evaluated', 85.00, 'PLAGIO: stress test alumno 021', 1, UNIX_TIMESTAMP()-437427, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress021'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fibonacci(n):\n    # version 21\n    if n <= 0: return 0\n    elif n == 1: return 1\n    else: return fibonacci(n-1) + fibonacci(n-2)\nfor i in range(10): print(fibonacci(i))', 'evaluated', 86.00, 'PLAGIO: stress test alumno 022', 1, UNIX_TIMESTAMP()-505510, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress022'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_22(num):\n    if num <= 0: return 0\n    if num == 1: return 1\n    return fib_22(num-1) + fib_22(num-2)\nfor i in range(10): print(fib_22(i))', 'evaluated', 87.00, 'PLAGIO: stress test alumno 023', 1, UNIX_TIMESTAMP()-501435, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress023'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fibonacci(n):\n    # version 23\n    if n <= 0: return 0\n    elif n == 1: return 1\n    else: return fibonacci(n-1) + fibonacci(n-2)\nfor i in range(10): print(fibonacci(i))', 'evaluated', 88.00, 'PLAGIO: stress test alumno 024', 1, UNIX_TIMESTAMP()-368893, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress024'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_24(num):\n    if num <= 0: return 0\n    if num == 1: return 1\n    return fib_24(num-1) + fib_24(num-2)\nfor i in range(10): print(fib_24(i))', 'evaluated', 89.00, 'PLAGIO: stress test alumno 025', 1, UNIX_TIMESTAMP()-20757, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress025'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fibonacci(n):\n    # version 25\n    if n <= 0: return 0\n    elif n == 1: return 1\n    else: return fibonacci(n-1) + fibonacci(n-2)\nfor i in range(10): print(fibonacci(i))', 'evaluated', 90.00, 'PLAGIO: stress test alumno 026', 1, UNIX_TIMESTAMP()-7618, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress026'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_26(num):\n    if num <= 0: return 0\n    if num == 1: return 1\n    return fib_26(num-1) + fib_26(num-2)\nfor i in range(10): print(fib_26(i))', 'evaluated', 91.00, 'PLAGIO: stress test alumno 027', 1, UNIX_TIMESTAMP()-316673, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress027'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fibonacci(n):\n    # version 27\n    if n <= 0: return 0\n    elif n == 1: return 1\n    else: return fibonacci(n-1) + fibonacci(n-2)\nfor i in range(10): print(fibonacci(i))', 'evaluated', 92.00, 'PLAGIO: stress test alumno 028', 1, UNIX_TIMESTAMP()-323738, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress028'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_28(num):\n    if num <= 0: return 0\n    if num == 1: return 1\n    return fib_28(num-1) + fib_28(num-2)\nfor i in range(10): print(fib_28(i))', 'evaluated', 93.00, 'PLAGIO: stress test alumno 029', 1, UNIX_TIMESTAMP()-541624, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress029'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fibonacci(n):\n    # version 29\n    if n <= 0: return 0\n    elif n == 1: return 1\n    else: return fibonacci(n-1) + fibonacci(n-2)\nfor i in range(10): print(fibonacci(i))', 'evaluated', 94.00, 'PLAGIO: stress test alumno 030', 1, UNIX_TIMESTAMP()-223607, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress030'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_30(num):\n    if num <= 0: return 0\n    if num == 1: return 1\n    return fib_30(num-1) + fib_30(num-2)\nfor i in range(10): print(fib_30(i))', 'evaluated', 80.00, 'PLAGIO: stress test alumno 031', 1, UNIX_TIMESTAMP()-400111, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress031'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fibonacci(n):\n    # version 31\n    if n <= 0: return 0\n    elif n == 1: return 1\n    else: return fibonacci(n-1) + fibonacci(n-2)\nfor i in range(10): print(fibonacci(i))', 'evaluated', 81.00, 'PLAGIO: stress test alumno 032', 1, UNIX_TIMESTAMP()-390206, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress032'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_32(num):\n    if num <= 0: return 0\n    if num == 1: return 1\n    return fib_32(num-1) + fib_32(num-2)\nfor i in range(10): print(fib_32(i))', 'evaluated', 82.00, 'PLAGIO: stress test alumno 033', 1, UNIX_TIMESTAMP()-283387, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress033'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fibonacci(n):\n    # version 33\n    if n <= 0: return 0\n    elif n == 1: return 1\n    else: return fibonacci(n-1) + fibonacci(n-2)\nfor i in range(10): print(fibonacci(i))', 'evaluated', 83.00, 'PLAGIO: stress test alumno 034', 1, UNIX_TIMESTAMP()-143109, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress034'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_34(num):\n    if num <= 0: return 0\n    if num == 1: return 1\n    return fib_34(num-1) + fib_34(num-2)\nfor i in range(10): print(fib_34(i))', 'evaluated', 84.00, 'PLAGIO: stress test alumno 035', 1, UNIX_TIMESTAMP()-407008, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress035'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fibonacci(n):\n    # version 35\n    if n <= 0: return 0\n    elif n == 1: return 1\n    else: return fibonacci(n-1) + fibonacci(n-2)\nfor i in range(10): print(fibonacci(i))', 'evaluated', 85.00, 'PLAGIO: stress test alumno 036', 1, UNIX_TIMESTAMP()-252522, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress036'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_36(num):\n    if num <= 0: return 0\n    if num == 1: return 1\n    return fib_36(num-1) + fib_36(num-2)\nfor i in range(10): print(fib_36(i))', 'evaluated', 86.00, 'PLAGIO: stress test alumno 037', 1, UNIX_TIMESTAMP()-175592, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress037'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fibonacci(n):\n    # version 37\n    if n <= 0: return 0\n    elif n == 1: return 1\n    else: return fibonacci(n-1) + fibonacci(n-2)\nfor i in range(10): print(fibonacci(i))', 'evaluated', 87.00, 'PLAGIO: stress test alumno 038', 1, UNIX_TIMESTAMP()-543, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress038'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_38(num):\n    if num <= 0: return 0\n    if num == 1: return 1\n    return fib_38(num-1) + fib_38(num-2)\nfor i in range(10): print(fib_38(i))', 'evaluated', 88.00, 'PLAGIO: stress test alumno 039', 1, UNIX_TIMESTAMP()-376541, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress039'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fibonacci(n):\n    # version 39\n    if n <= 0: return 0\n    elif n == 1: return 1\n    else: return fibonacci(n-1) + fibonacci(n-2)\nfor i in range(10): print(fibonacci(i))', 'evaluated', 89.00, 'PLAGIO: stress test alumno 040', 1, UNIX_TIMESTAMP()-26548, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress040'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_iter_40(n):\n    a, b = 0, 1\n    for _ in range(n): a, b = b, a+b\n    return a\nfor i in range(10): print(fib_iter_40(i))', 'evaluated', 70.00, 'SOSPECHOSO: stress test alumno 041', 1, UNIX_TIMESTAMP()-387743, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress041'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_iter_41(n):\n    a, b = 0, 1\n    for _ in range(n): a, b = b, a+b\n    return a\nfor i in range(10): print(fib_iter_41(i))', 'evaluated', 71.00, 'SOSPECHOSO: stress test alumno 042', 1, UNIX_TIMESTAMP()-396994, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress042'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_iter_42(n):\n    a, b = 0, 1\n    for _ in range(n): a, b = b, a+b\n    return a\nfor i in range(10): print(fib_iter_42(i))', 'evaluated', 72.00, 'SOSPECHOSO: stress test alumno 043', 1, UNIX_TIMESTAMP()-265268, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress043'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_iter_43(n):\n    a, b = 0, 1\n    for _ in range(n): a, b = b, a+b\n    return a\nfor i in range(10): print(fib_iter_43(i))', 'evaluated', 73.00, 'SOSPECHOSO: stress test alumno 044', 1, UNIX_TIMESTAMP()-183612, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress044'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_iter_44(n):\n    a, b = 0, 1\n    for _ in range(n): a, b = b, a+b\n    return a\nfor i in range(10): print(fib_iter_44(i))', 'evaluated', 74.00, 'SOSPECHOSO: stress test alumno 045', 1, UNIX_TIMESTAMP()-208442, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress045'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_iter_45(n):\n    a, b = 0, 1\n    for _ in range(n): a, b = b, a+b\n    return a\nfor i in range(10): print(fib_iter_45(i))', 'evaluated', 75.00, 'SOSPECHOSO: stress test alumno 046', 1, UNIX_TIMESTAMP()-400945, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress046'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_iter_46(n):\n    a, b = 0, 1\n    for _ in range(n): a, b = b, a+b\n    return a\nfor i in range(10): print(fib_iter_46(i))', 'evaluated', 76.00, 'SOSPECHOSO: stress test alumno 047', 1, UNIX_TIMESTAMP()-254880, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress047'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_iter_47(n):\n    a, b = 0, 1\n    for _ in range(n): a, b = b, a+b\n    return a\nfor i in range(10): print(fib_iter_47(i))', 'evaluated', 77.00, 'SOSPECHOSO: stress test alumno 048', 1, UNIX_TIMESTAMP()-365921, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress048'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_iter_48(n):\n    a, b = 0, 1\n    for _ in range(n): a, b = b, a+b\n    return a\nfor i in range(10): print(fib_iter_48(i))', 'evaluated', 78.00, 'SOSPECHOSO: stress test alumno 049', 1, UNIX_TIMESTAMP()-530238, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress049'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_iter_49(n):\n    a, b = 0, 1\n    for _ in range(n): a, b = b, a+b\n    return a\nfor i in range(10): print(fib_iter_49(i))', 'evaluated', 79.00, 'SOSPECHOSO: stress test alumno 050', 1, UNIX_TIMESTAMP()-538993, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress050'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_iter_50(n):\n    a, b = 0, 1\n    for _ in range(n): a, b = b, a+b\n    return a\nfor i in range(10): print(fib_iter_50(i))', 'evaluated', 70.00, 'SOSPECHOSO: stress test alumno 051', 1, UNIX_TIMESTAMP()-127165, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress051'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_iter_51(n):\n    a, b = 0, 1\n    for _ in range(n): a, b = b, a+b\n    return a\nfor i in range(10): print(fib_iter_51(i))', 'evaluated', 71.00, 'SOSPECHOSO: stress test alumno 052', 1, UNIX_TIMESTAMP()-583630, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress052'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_iter_52(n):\n    a, b = 0, 1\n    for _ in range(n): a, b = b, a+b\n    return a\nfor i in range(10): print(fib_iter_52(i))', 'evaluated', 72.00, 'SOSPECHOSO: stress test alumno 053', 1, UNIX_TIMESTAMP()-394997, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress053'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_iter_53(n):\n    a, b = 0, 1\n    for _ in range(n): a, b = b, a+b\n    return a\nfor i in range(10): print(fib_iter_53(i))', 'evaluated', 73.00, 'SOSPECHOSO: stress test alumno 054', 1, UNIX_TIMESTAMP()-255441, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress054'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_iter_54(n):\n    a, b = 0, 1\n    for _ in range(n): a, b = b, a+b\n    return a\nfor i in range(10): print(fib_iter_54(i))', 'evaluated', 74.00, 'SOSPECHOSO: stress test alumno 055', 1, UNIX_TIMESTAMP()-452038, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress055'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_iter_55(n):\n    a, b = 0, 1\n    for _ in range(n): a, b = b, a+b\n    return a\nfor i in range(10): print(fib_iter_55(i))', 'evaluated', 75.00, 'SOSPECHOSO: stress test alumno 056', 1, UNIX_TIMESTAMP()-378118, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress056'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_iter_56(n):\n    a, b = 0, 1\n    for _ in range(n): a, b = b, a+b\n    return a\nfor i in range(10): print(fib_iter_56(i))', 'evaluated', 76.00, 'SOSPECHOSO: stress test alumno 057', 1, UNIX_TIMESTAMP()-155502, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress057'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_iter_57(n):\n    a, b = 0, 1\n    for _ in range(n): a, b = b, a+b\n    return a\nfor i in range(10): print(fib_iter_57(i))', 'evaluated', 77.00, 'SOSPECHOSO: stress test alumno 058', 1, UNIX_TIMESTAMP()-403936, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress058'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_iter_58(n):\n    a, b = 0, 1\n    for _ in range(n): a, b = b, a+b\n    return a\nfor i in range(10): print(fib_iter_58(i))', 'evaluated', 78.00, 'SOSPECHOSO: stress test alumno 059', 1, UNIX_TIMESTAMP()-597986, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress059'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_iter_59(n):\n    a, b = 0, 1\n    for _ in range(n): a, b = b, a+b\n    return a\nfor i in range(10): print(fib_iter_59(i))', 'evaluated', 79.00, 'SOSPECHOSO: stress test alumno 060', 1, UNIX_TIMESTAMP()-577357, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress060'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_memo_60(n, memo={}):\n    if n in memo: return memo[n]\n    if n<=1: return n\n    memo[n]=fib_memo_60(n-1,memo)+fib_memo_60(n-2,memo)\n    return memo[n]\nprint([fib_memo_60(i) for i in range(15)])', 'evaluated', 85.00, 'ORIGINAL: stress test alumno 061', 1, UNIX_TIMESTAMP()-186408, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress061'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_gen_61():\n    a,b=0,1\n    while True:\n        yield a\n        a,b=b,a+b\ng=fib_gen_61()\nprint([next(g) for _ in range(15)])', 'evaluated', 86.00, 'ORIGINAL: stress test alumno 062', 1, UNIX_TIMESTAMP()-90151, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress062'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'import numpy as np\ndef fib_matrix_62(n):\n    if n<=0: return 0\n    M=np.array([[1,1],[1,0]])\n    result=np.linalg.matrix_power(M,n-1)\n    return int(result[0][0])\nprint([fib_matrix_62(i) for i in range(1,16)])', 'evaluated', 87.00, 'ORIGINAL: stress test alumno 063', 1, UNIX_TIMESTAMP()-429865, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress063'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_memo_63(n, memo={}):\n    if n in memo: return memo[n]\n    if n<=1: return n\n    memo[n]=fib_memo_63(n-1,memo)+fib_memo_63(n-2,memo)\n    return memo[n]\nprint([fib_memo_63(i) for i in range(15)])', 'evaluated', 88.00, 'ORIGINAL: stress test alumno 064', 1, UNIX_TIMESTAMP()-24386, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress064'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_gen_64():\n    a,b=0,1\n    while True:\n        yield a\n        a,b=b,a+b\ng=fib_gen_64()\nprint([next(g) for _ in range(15)])', 'evaluated', 89.00, 'ORIGINAL: stress test alumno 065', 1, UNIX_TIMESTAMP()-501925, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress065'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'import numpy as np\ndef fib_matrix_65(n):\n    if n<=0: return 0\n    M=np.array([[1,1],[1,0]])\n    result=np.linalg.matrix_power(M,n-1)\n    return int(result[0][0])\nprint([fib_matrix_65(i) for i in range(1,16)])', 'evaluated', 90.00, 'ORIGINAL: stress test alumno 066', 1, UNIX_TIMESTAMP()-418662, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress066'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_memo_66(n, memo={}):\n    if n in memo: return memo[n]\n    if n<=1: return n\n    memo[n]=fib_memo_66(n-1,memo)+fib_memo_66(n-2,memo)\n    return memo[n]\nprint([fib_memo_66(i) for i in range(15)])', 'evaluated', 91.00, 'ORIGINAL: stress test alumno 067', 1, UNIX_TIMESTAMP()-273147, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress067'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_gen_67():\n    a,b=0,1\n    while True:\n        yield a\n        a,b=b,a+b\ng=fib_gen_67()\nprint([next(g) for _ in range(15)])', 'evaluated', 92.00, 'ORIGINAL: stress test alumno 068', 1, UNIX_TIMESTAMP()-112848, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress068'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'import numpy as np\ndef fib_matrix_68(n):\n    if n<=0: return 0\n    M=np.array([[1,1],[1,0]])\n    result=np.linalg.matrix_power(M,n-1)\n    return int(result[0][0])\nprint([fib_matrix_68(i) for i in range(1,16)])', 'evaluated', 93.00, 'ORIGINAL: stress test alumno 069', 1, UNIX_TIMESTAMP()-288231, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress069'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_memo_69(n, memo={}):\n    if n in memo: return memo[n]\n    if n<=1: return n\n    memo[n]=fib_memo_69(n-1,memo)+fib_memo_69(n-2,memo)\n    return memo[n]\nprint([fib_memo_69(i) for i in range(15)])', 'evaluated', 94.00, 'ORIGINAL: stress test alumno 070', 1, UNIX_TIMESTAMP()-553134, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress070'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_gen_70():\n    a,b=0,1\n    while True:\n        yield a\n        a,b=b,a+b\ng=fib_gen_70()\nprint([next(g) for _ in range(15)])', 'evaluated', 95.00, 'ORIGINAL: stress test alumno 071', 1, UNIX_TIMESTAMP()-544636, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress071'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'import numpy as np\ndef fib_matrix_71(n):\n    if n<=0: return 0\n    M=np.array([[1,1],[1,0]])\n    result=np.linalg.matrix_power(M,n-1)\n    return int(result[0][0])\nprint([fib_matrix_71(i) for i in range(1,16)])', 'evaluated', 96.00, 'ORIGINAL: stress test alumno 072', 1, UNIX_TIMESTAMP()-588516, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress072'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_memo_72(n, memo={}):\n    if n in memo: return memo[n]\n    if n<=1: return n\n    memo[n]=fib_memo_72(n-1,memo)+fib_memo_72(n-2,memo)\n    return memo[n]\nprint([fib_memo_72(i) for i in range(15)])', 'evaluated', 85.00, 'ORIGINAL: stress test alumno 073', 1, UNIX_TIMESTAMP()-576604, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress073'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_gen_73():\n    a,b=0,1\n    while True:\n        yield a\n        a,b=b,a+b\ng=fib_gen_73()\nprint([next(g) for _ in range(15)])', 'evaluated', 86.00, 'ORIGINAL: stress test alumno 074', 1, UNIX_TIMESTAMP()-121848, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress074'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'import numpy as np\ndef fib_matrix_74(n):\n    if n<=0: return 0\n    M=np.array([[1,1],[1,0]])\n    result=np.linalg.matrix_power(M,n-1)\n    return int(result[0][0])\nprint([fib_matrix_74(i) for i in range(1,16)])', 'evaluated', 87.00, 'ORIGINAL: stress test alumno 075', 1, UNIX_TIMESTAMP()-518097, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress075'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_memo_75(n, memo={}):\n    if n in memo: return memo[n]\n    if n<=1: return n\n    memo[n]=fib_memo_75(n-1,memo)+fib_memo_75(n-2,memo)\n    return memo[n]\nprint([fib_memo_75(i) for i in range(15)])', 'evaluated', 88.00, 'ORIGINAL: stress test alumno 076', 1, UNIX_TIMESTAMP()-395266, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress076'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_gen_76():\n    a,b=0,1\n    while True:\n        yield a\n        a,b=b,a+b\ng=fib_gen_76()\nprint([next(g) for _ in range(15)])', 'evaluated', 89.00, 'ORIGINAL: stress test alumno 077', 1, UNIX_TIMESTAMP()-197845, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress077'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'import numpy as np\ndef fib_matrix_77(n):\n    if n<=0: return 0\n    M=np.array([[1,1],[1,0]])\n    result=np.linalg.matrix_power(M,n-1)\n    return int(result[0][0])\nprint([fib_matrix_77(i) for i in range(1,16)])', 'evaluated', 90.00, 'ORIGINAL: stress test alumno 078', 1, UNIX_TIMESTAMP()-359084, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress078'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_memo_78(n, memo={}):\n    if n in memo: return memo[n]\n    if n<=1: return n\n    memo[n]=fib_memo_78(n-1,memo)+fib_memo_78(n-2,memo)\n    return memo[n]\nprint([fib_memo_78(i) for i in range(15)])', 'evaluated', 91.00, 'ORIGINAL: stress test alumno 079', 1, UNIX_TIMESTAMP()-559475, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress079'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_gen_79():\n    a,b=0,1\n    while True:\n        yield a\n        a,b=b,a+b\ng=fib_gen_79()\nprint([next(g) for _ in range(15)])', 'evaluated', 92.00, 'ORIGINAL: stress test alumno 080', 1, UNIX_TIMESTAMP()-223933, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress080'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'import numpy as np\ndef fib_matrix_80(n):\n    if n<=0: return 0\n    M=np.array([[1,1],[1,0]])\n    result=np.linalg.matrix_power(M,n-1)\n    return int(result[0][0])\nprint([fib_matrix_80(i) for i in range(1,16)])', 'evaluated', 93.00, 'ORIGINAL: stress test alumno 081', 1, UNIX_TIMESTAMP()-138442, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress081'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_memo_81(n, memo={}):\n    if n in memo: return memo[n]\n    if n<=1: return n\n    memo[n]=fib_memo_81(n-1,memo)+fib_memo_81(n-2,memo)\n    return memo[n]\nprint([fib_memo_81(i) for i in range(15)])', 'evaluated', 94.00, 'ORIGINAL: stress test alumno 082', 1, UNIX_TIMESTAMP()-133324, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress082'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_gen_82():\n    a,b=0,1\n    while True:\n        yield a\n        a,b=b,a+b\ng=fib_gen_82()\nprint([next(g) for _ in range(15)])', 'evaluated', 95.00, 'ORIGINAL: stress test alumno 083', 1, UNIX_TIMESTAMP()-507031, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress083'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'import numpy as np\ndef fib_matrix_83(n):\n    if n<=0: return 0\n    M=np.array([[1,1],[1,0]])\n    result=np.linalg.matrix_power(M,n-1)\n    return int(result[0][0])\nprint([fib_matrix_83(i) for i in range(1,16)])', 'evaluated', 96.00, 'ORIGINAL: stress test alumno 084', 1, UNIX_TIMESTAMP()-279036, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress084'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_memo_84(n, memo={}):\n    if n in memo: return memo[n]\n    if n<=1: return n\n    memo[n]=fib_memo_84(n-1,memo)+fib_memo_84(n-2,memo)\n    return memo[n]\nprint([fib_memo_84(i) for i in range(15)])', 'evaluated', 85.00, 'ORIGINAL: stress test alumno 085', 1, UNIX_TIMESTAMP()-567749, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress085'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_gen_85():\n    a,b=0,1\n    while True:\n        yield a\n        a,b=b,a+b\ng=fib_gen_85()\nprint([next(g) for _ in range(15)])', 'evaluated', 86.00, 'ORIGINAL: stress test alumno 086', 1, UNIX_TIMESTAMP()-200351, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress086'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'import numpy as np\ndef fib_matrix_86(n):\n    if n<=0: return 0\n    M=np.array([[1,1],[1,0]])\n    result=np.linalg.matrix_power(M,n-1)\n    return int(result[0][0])\nprint([fib_matrix_86(i) for i in range(1,16)])', 'evaluated', 87.00, 'ORIGINAL: stress test alumno 087', 1, UNIX_TIMESTAMP()-582840, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress087'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_memo_87(n, memo={}):\n    if n in memo: return memo[n]\n    if n<=1: return n\n    memo[n]=fib_memo_87(n-1,memo)+fib_memo_87(n-2,memo)\n    return memo[n]\nprint([fib_memo_87(i) for i in range(15)])', 'evaluated', 88.00, 'ORIGINAL: stress test alumno 088', 1, UNIX_TIMESTAMP()-343215, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress088'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_gen_88():\n    a,b=0,1\n    while True:\n        yield a\n        a,b=b,a+b\ng=fib_gen_88()\nprint([next(g) for _ in range(15)])', 'evaluated', 89.00, 'ORIGINAL: stress test alumno 089', 1, UNIX_TIMESTAMP()-548713, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress089'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'import numpy as np\ndef fib_matrix_89(n):\n    if n<=0: return 0\n    M=np.array([[1,1],[1,0]])\n    result=np.linalg.matrix_power(M,n-1)\n    return int(result[0][0])\nprint([fib_matrix_89(i) for i in range(1,16)])', 'evaluated', 90.00, 'ORIGINAL: stress test alumno 090', 1, UNIX_TIMESTAMP()-197524, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress090'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_memo_90(n, memo={}):\n    if n in memo: return memo[n]\n    if n<=1: return n\n    memo[n]=fib_memo_90(n-1,memo)+fib_memo_90(n-2,memo)\n    return memo[n]\nprint([fib_memo_90(i) for i in range(15)])', 'evaluated', 91.00, 'ORIGINAL: stress test alumno 091', 1, UNIX_TIMESTAMP()-533958, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress091'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_gen_91():\n    a,b=0,1\n    while True:\n        yield a\n        a,b=b,a+b\ng=fib_gen_91()\nprint([next(g) for _ in range(15)])', 'evaluated', 92.00, 'ORIGINAL: stress test alumno 092', 1, UNIX_TIMESTAMP()-66311, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress092'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'import numpy as np\ndef fib_matrix_92(n):\n    if n<=0: return 0\n    M=np.array([[1,1],[1,0]])\n    result=np.linalg.matrix_power(M,n-1)\n    return int(result[0][0])\nprint([fib_matrix_92(i) for i in range(1,16)])', 'evaluated', 93.00, 'ORIGINAL: stress test alumno 093', 1, UNIX_TIMESTAMP()-458349, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress093'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_memo_93(n, memo={}):\n    if n in memo: return memo[n]\n    if n<=1: return n\n    memo[n]=fib_memo_93(n-1,memo)+fib_memo_93(n-2,memo)\n    return memo[n]\nprint([fib_memo_93(i) for i in range(15)])', 'evaluated', 94.00, 'ORIGINAL: stress test alumno 094', 1, UNIX_TIMESTAMP()-195892, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress094'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_gen_94():\n    a,b=0,1\n    while True:\n        yield a\n        a,b=b,a+b\ng=fib_gen_94()\nprint([next(g) for _ in range(15)])', 'evaluated', 95.00, 'ORIGINAL: stress test alumno 095', 1, UNIX_TIMESTAMP()-533542, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress095'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'import numpy as np\ndef fib_matrix_95(n):\n    if n<=0: return 0\n    M=np.array([[1,1],[1,0]])\n    result=np.linalg.matrix_power(M,n-1)\n    return int(result[0][0])\nprint([fib_matrix_95(i) for i in range(1,16)])', 'evaluated', 96.00, 'ORIGINAL: stress test alumno 096', 1, UNIX_TIMESTAMP()-293650, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress096'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_memo_96(n, memo={}):\n    if n in memo: return memo[n]\n    if n<=1: return n\n    memo[n]=fib_memo_96(n-1,memo)+fib_memo_96(n-2,memo)\n    return memo[n]\nprint([fib_memo_96(i) for i in range(15)])', 'evaluated', 85.00, 'ORIGINAL: stress test alumno 097', 1, UNIX_TIMESTAMP()-159507, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress097'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_gen_97():\n    a,b=0,1\n    while True:\n        yield a\n        a,b=b,a+b\ng=fib_gen_97()\nprint([next(g) for _ in range(15)])', 'evaluated', 86.00, 'ORIGINAL: stress test alumno 098', 1, UNIX_TIMESTAMP()-299693, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress098'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'import numpy as np\ndef fib_matrix_98(n):\n    if n<=0: return 0\n    M=np.array([[1,1],[1,0]])\n    result=np.linalg.matrix_power(M,n-1)\n    return int(result[0][0])\nprint([fib_matrix_98(i) for i in range(1,16)])', 'evaluated', 87.00, 'ORIGINAL: stress test alumno 099', 1, UNIX_TIMESTAMP()-407714, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress099'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';
INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified)
SELECT a.id, u.id, 'def fib_memo_99(n, memo={}):\n    if n in memo: return memo[n]\n    if n<=1: return n\n    memo[n]=fib_memo_99(n-1,memo)+fib_memo_99(n-2,memo)\n    return memo[n]\nprint([fib_memo_99(i) for i in range(15)])', 'evaluated', 88.00, 'ORIGINAL: stress test alumno 100', 1, UNIX_TIMESTAMP()-473437, UNIX_TIMESTAMP()
FROM mdl_aiassignment a JOIN mdl_course c ON a.course=c.id JOIN mdl_user u ON u.username='stress100'
WHERE c.shortname='test' AND a.name='Stress Test: Fibonacci';

-- ── PASO 7: Evaluaciones con scores de plagio ──────────────
INSERT INTO mdl_aiassignment_evaluations (submission, similarity_score, ai_feedback, ai_analysis, timecreated)
SELECT s.id,
  CASE
    WHEN u.username REGEXP 'stress0[0-3][0-9]$' AND CAST(SUBSTRING(u.username,7) AS UNSIGNED) <= 40
      THEN 75 + (CAST(SUBSTRING(u.username,7) AS UNSIGNED) % 20)
    WHEN u.username REGEXP 'stress0[4-5][0-9]$' AND CAST(SUBSTRING(u.username,7) AS UNSIGNED) BETWEEN 41 AND 60
      THEN 45 + (CAST(SUBSTRING(u.username,7) AS UNSIGNED) % 25)
    ELSE 5 + (CAST(SUBSTRING(u.username,7) AS UNSIGNED) % 18)
  END,
  s.feedback, '{}', UNIX_TIMESTAMP()
FROM mdl_aiassignment_submissions s
JOIN mdl_user u ON s.userid = u.id
JOIN mdl_aiassignment a ON s.assignment = a.id
WHERE a.name = 'Stress Test: Factorial' AND u.username LIKE 'stress%'
AND NOT EXISTS (SELECT 1 FROM mdl_aiassignment_evaluations e WHERE e.submission = s.id);

INSERT INTO mdl_aiassignment_evaluations (submission, similarity_score, ai_feedback, ai_analysis, timecreated)
SELECT s.id,
  CASE
    WHEN u.username REGEXP 'stress0[0-3][0-9]$' AND CAST(SUBSTRING(u.username,7) AS UNSIGNED) <= 40
      THEN 75 + (CAST(SUBSTRING(u.username,7) AS UNSIGNED) % 20)
    WHEN u.username REGEXP 'stress0[4-5][0-9]$' AND CAST(SUBSTRING(u.username,7) AS UNSIGNED) BETWEEN 41 AND 60
      THEN 45 + (CAST(SUBSTRING(u.username,7) AS UNSIGNED) % 25)
    ELSE 5 + (CAST(SUBSTRING(u.username,7) AS UNSIGNED) % 18)
  END,
  s.feedback, '{}', UNIX_TIMESTAMP()
FROM mdl_aiassignment_submissions s
JOIN mdl_user u ON s.userid = u.id
JOIN mdl_aiassignment a ON s.assignment = a.id
WHERE a.name = 'Stress Test: Ordenamiento' AND u.username LIKE 'stress%'
AND NOT EXISTS (SELECT 1 FROM mdl_aiassignment_evaluations e WHERE e.submission = s.id);

INSERT INTO mdl_aiassignment_evaluations (submission, similarity_score, ai_feedback, ai_analysis, timecreated)
SELECT s.id,
  CASE
    WHEN u.username REGEXP 'stress0[0-3][0-9]$' AND CAST(SUBSTRING(u.username,7) AS UNSIGNED) <= 40
      THEN 75 + (CAST(SUBSTRING(u.username,7) AS UNSIGNED) % 20)
    WHEN u.username REGEXP 'stress0[4-5][0-9]$' AND CAST(SUBSTRING(u.username,7) AS UNSIGNED) BETWEEN 41 AND 60
      THEN 45 + (CAST(SUBSTRING(u.username,7) AS UNSIGNED) % 25)
    ELSE 5 + (CAST(SUBSTRING(u.username,7) AS UNSIGNED) % 18)
  END,
  s.feedback, '{}', UNIX_TIMESTAMP()
FROM mdl_aiassignment_submissions s
JOIN mdl_user u ON s.userid = u.id
JOIN mdl_aiassignment a ON s.assignment = a.id
WHERE a.name = 'Stress Test: Fibonacci' AND u.username LIKE 'stress%'
AND NOT EXISTS (SELECT 1 FROM mdl_aiassignment_evaluations e WHERE e.submission = s.id);

SET FOREIGN_KEY_CHECKS = 1;

-- ══════════════════════════════════════════════════════════════
-- VERIFICACIÓN Y MÉTRICAS DE ESTRÉS
-- ══════════════════════════════════════════════════════════════

-- Total de usuarios de estrés
SELECT COUNT(*) AS total_stress_users FROM mdl_user WHERE username LIKE 'stress%';

-- Total de envíos por tarea
SELECT a.name, COUNT(s.id) AS total_submissions
FROM mdl_aiassignment a
JOIN mdl_aiassignment_submissions s ON s.assignment = a.id
JOIN mdl_user u ON s.userid = u.id
WHERE u.username LIKE 'stress%'
GROUP BY a.name;

-- Distribución de plagio
SELECT
  CASE
    WHEN e.similarity_score >= 75 THEN 'PLAGIO (>=75%)'
    WHEN e.similarity_score >= 50 THEN 'SOSPECHOSO (50-74%)'
    ELSE 'ORIGINAL (<50%)'
  END AS nivel,
  COUNT(*) AS cantidad,
  ROUND(AVG(e.similarity_score), 1) AS promedio_similitud,
  ROUND(AVG(s.score), 1) AS promedio_calificacion
FROM mdl_aiassignment_submissions s
JOIN mdl_user u ON s.userid = u.id
JOIN mdl_aiassignment_evaluations e ON e.submission = s.id
WHERE u.username LIKE 'stress%'
GROUP BY nivel
ORDER BY promedio_similitud DESC;

-- Top 10 pares con mayor similitud (para validar el detector)
SELECT
  u.firstname, u.lastname,
  a.name AS tarea,
  s.score AS calificacion,
  e.similarity_score AS pct_plagio,
  s.feedback AS tipo
FROM mdl_aiassignment_submissions s
JOIN mdl_user u ON s.userid = u.id
JOIN mdl_aiassignment a ON s.assignment = a.id
JOIN mdl_aiassignment_evaluations e ON e.submission = s.id
WHERE u.username LIKE 'stress%'
ORDER BY e.similarity_score DESC
LIMIT 20;

-- Métricas de rendimiento esperadas
SELECT
  '100 alumnos' AS escenario,
  COUNT(DISTINCT s.id) AS total_envios,
  COUNT(DISTINCT u.id) AS alumnos_unicos,
  COUNT(DISTINCT a.id) AS tareas,
  ROUND(AVG(s.score), 1) AS promedio_general,
  SUM(CASE WHEN e.similarity_score >= 75 THEN 1 ELSE 0 END) AS alertas_plagio,
  CONCAT(COUNT(DISTINCT u.id) * (COUNT(DISTINCT u.id) - 1) / 2, ' por tarea') AS comparaciones_plagio
FROM mdl_aiassignment_submissions s
JOIN mdl_user u ON s.userid = u.id
JOIN mdl_aiassignment a ON s.assignment = a.id
LEFT JOIN mdl_aiassignment_evaluations e ON e.submission = s.id
WHERE u.username LIKE 'stress%';
