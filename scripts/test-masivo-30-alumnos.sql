-- ============================================================
-- TEST MASIVO: 30 alumnos con envíos de código Python
-- Plugin: mod_aiassignment — Detección de plagio
--
-- Grupos de plagio:
--   Grupo A (alumnos 01-08): copias del mismo factorial recursivo
--   Grupo B (alumnos 09-14): copias del mismo bubble sort
--   Grupo C (alumnos 15-18): sospechosos (cambio de bucle/lógica)
--   Grupo D (alumnos 19-22): plagio con código muerto/comentarios
--   Grupo E (alumnos 23-30): soluciones ORIGINALES (no plagio)
--
-- Ejecutar: mysql -u root -p5211 moodle < test-masivo-30-alumnos.sql
-- ============================================================

USE moodle;
SET FOREIGN_KEY_CHECKS = 0;

-- ── 1. CREAR 30 USUARIOS ─────────────────────────────────────

INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est01',MD5('pass01'),'Carlos','García','est01@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est01');

INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est02',MD5('pass02'),'María','López','est02@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est02');

INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est03',MD5('pass03'),'Pedro','Martínez','est03@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est03');

INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est04',MD5('pass04'),'Ana','Rodríguez','est04@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est04');

INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est05',MD5('pass05'),'Luis','Hernández','est05@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est05');

INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est06',MD5('pass06'),'Sofía','Jiménez','est06@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est06');

INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est07',MD5('pass07'),'Diego','Torres','est07@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est07');

INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est08',MD5('pass08'),'Valentina','Flores','est08@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est08');

INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est09',MD5('pass09'),'Andrés','Vargas','est09@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est09');

INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est10',MD5('pass10'),'Camila','Reyes','est10@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est10');

INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est11',MD5('pass11'),'Sebastián','Cruz','est11@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est11');

INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est12',MD5('pass12'),'Isabella','Morales','est12@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est12');

INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est13',MD5('pass13'),'Mateo','Ortiz','est13@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est13');

INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est14',MD5('pass14'),'Lucía','Mendoza','est14@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est14');

INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est15',MD5('pass15'),'Nicolás','Castillo','est15@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est15');

INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est16',MD5('pass16'),'Gabriela','Ramos','est16@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est16');

INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est17',MD5('pass17'),'Felipe','Gutiérrez','est17@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est17');

INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est18',MD5('pass18'),'Daniela','Sánchez','est18@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est18');

INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est19',MD5('pass19'),'Tomás','Ramírez','est19@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est19');

INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est20',MD5('pass20'),'Valeria','Núñez','est20@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est20');

INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est21',MD5('pass21'),'Emilio','Peña','est21@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est21');

INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est22',MD5('pass22'),'Renata','Aguilar','est22@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est22');

INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est23',MD5('pass23'),'Joaquín','Medina','est23@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est23');

INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est24',MD5('pass24'),'Mariana','Vega','est24@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est24');

INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est25',MD5('pass25'),'Rodrigo','Herrera','est25@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est25');

INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est26',MD5('pass26'),'Natalia','Ríos','est26@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est26');

INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est27',MD5('pass27'),'Alejandro','Mora','est27@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est27');

INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est28',MD5('pass28'),'Paula','Delgado','est28@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est28');

INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est29',MD5('pass29'),'Ignacio','Fuentes','est29@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est29');

INSERT INTO mdl_user (auth,confirmed,username,password,firstname,lastname,email,mnethostid,lang,timezone,timecreated,timemodified,lastip)
SELECT 'manual',1,'est30',MD5('pass30'),'Catalina','Espinoza','est30@test.com',1,'es','99',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),'127.0.0.1'
WHERE NOT EXISTS (SELECT 1 FROM mdl_user WHERE username='est30');

-- ── 2. VARIABLES DE IDs ───────────────────────────────────────
SET @AID = (SELECT id FROM mdl_aiassignment ORDER BY id LIMIT 1);

SET @U01 = (SELECT id FROM mdl_user WHERE username='est01' LIMIT 1);
SET @U02 = (SELECT id FROM mdl_user WHERE username='est02' LIMIT 1);
SET @U03 = (SELECT id FROM mdl_user WHERE username='est03' LIMIT 1);
SET @U04 = (SELECT id FROM mdl_user WHERE username='est04' LIMIT 1);
SET @U05 = (SELECT id FROM mdl_user WHERE username='est05' LIMIT 1);
SET @U06 = (SELECT id FROM mdl_user WHERE username='est06' LIMIT 1);
SET @U07 = (SELECT id FROM mdl_user WHERE username='est07' LIMIT 1);
SET @U08 = (SELECT id FROM mdl_user WHERE username='est08' LIMIT 1);
SET @U09 = (SELECT id FROM mdl_user WHERE username='est09' LIMIT 1);
SET @U10 = (SELECT id FROM mdl_user WHERE username='est10' LIMIT 1);
SET @U11 = (SELECT id FROM mdl_user WHERE username='est11' LIMIT 1);
SET @U12 = (SELECT id FROM mdl_user WHERE username='est12' LIMIT 1);
SET @U13 = (SELECT id FROM mdl_user WHERE username='est13' LIMIT 1);
SET @U14 = (SELECT id FROM mdl_user WHERE username='est14' LIMIT 1);
SET @U15 = (SELECT id FROM mdl_user WHERE username='est15' LIMIT 1);
SET @U16 = (SELECT id FROM mdl_user WHERE username='est16' LIMIT 1);
SET @U17 = (SELECT id FROM mdl_user WHERE username='est17' LIMIT 1);
SET @U18 = (SELECT id FROM mdl_user WHERE username='est18' LIMIT 1);
SET @U19 = (SELECT id FROM mdl_user WHERE username='est19' LIMIT 1);
SET @U20 = (SELECT id FROM mdl_user WHERE username='est20' LIMIT 1);
SET @U21 = (SELECT id FROM mdl_user WHERE username='est21' LIMIT 1);
SET @U22 = (SELECT id FROM mdl_user WHERE username='est22' LIMIT 1);
SET @U23 = (SELECT id FROM mdl_user WHERE username='est23' LIMIT 1);
SET @U24 = (SELECT id FROM mdl_user WHERE username='est24' LIMIT 1);
SET @U25 = (SELECT id FROM mdl_user WHERE username='est25' LIMIT 1);
SET @U26 = (SELECT id FROM mdl_user WHERE username='est26' LIMIT 1);
SET @U27 = (SELECT id FROM mdl_user WHERE username='est27' LIMIT 1);
SET @U28 = (SELECT id FROM mdl_user WHERE username='est28' LIMIT 1);
SET @U29 = (SELECT id FROM mdl_user WHERE username='est29' LIMIT 1);
SET @U30 = (SELECT id FROM mdl_user WHERE username='est30' LIMIT 1);

-- ── 3. LIMPIAR ENVÍOS PREVIOS DE ESTOS USUARIOS ──────────────
DELETE e FROM mdl_aiassignment_evaluations e
  INNER JOIN mdl_aiassignment_submissions s ON e.submission = s.id
  WHERE s.assignment = @AID AND s.userid IN (
    @U01,@U02,@U03,@U04,@U05,@U06,@U07,@U08,@U09,@U10,
    @U11,@U12,@U13,@U14,@U15,@U16,@U17,@U18,@U19,@U20,
    @U21,@U22,@U23,@U24,@U25,@U26,@U27,@U28,@U29,@U30
  );

DELETE FROM mdl_aiassignment_submissions
  WHERE assignment = @AID AND userid IN (
    @U01,@U02,@U03,@U04,@U05,@U06,@U07,@U08,@U09,@U10,
    @U11,@U12,@U13,@U14,@U15,@U16,@U17,@U18,@U19,@U20,
    @U21,@U22,@U23,@U24,@U25,@U26,@U27,@U28,@U29,@U30
  );

-- ── 4. INSERTAR ENVÍOS ────────────────────────────────────────
-- GRUPO A (est01-est08): PLAGIO — factorial recursivo, variantes del mismo código

INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified) VALUES
-- est01: ORIGINAL base del grupo A
(@AID,@U01,
'def factorial(n):
    if n == 0 or n == 1:
        return 1
    return n * factorial(n - 1)

print(factorial(5))
print(factorial(10))',
'evaluated',92.00,'Solución recursiva original.',1,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()),

-- est02: PLAGIO — renombró n→num, factorial→calc_fact
(@AID,@U02,
'def calc_fact(num):
    if num == 0 or num == 1:
        return 1
    return num * calc_fact(num - 1)

print(calc_fact(5))
print(calc_fact(10))',
'evaluated',88.00,'Alta similitud con otro envío. Renombrado de variables.',1,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()),

-- est03: PLAGIO — renombró n→x, factorial→fact
(@AID,@U03,
'def fact(x):
    if x == 0 or x == 1:
        return 1
    return x * fact(x - 1)

print(fact(5))
print(fact(10))',
'evaluated',87.00,'Alta similitud. Solo cambió nombres de variables.',1,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()),

-- est04: PLAGIO — reordenó condición base (0 y 1 → 1 y 0) + variable extra
(@AID,@U04,
'def factorial(n):
    aux = 0
    if n == 1 or n == 0:
        return 1
    result = n * factorial(n - 1)
    return result

print(factorial(5))
print(factorial(10))',
'evaluated',79.00,'Plagio probable. Variable auxiliar inútil añadida.',1,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()),

-- est05: PLAGIO — comentarios falsos + mismo algoritmo
(@AID,@U05,
'# mi solucion propia
def factorial(n):
    # caso base
    if n == 0 or n == 1:
        return 1
    # caso recursivo
    return n * factorial(n - 1)

# prueba
print(factorial(5))
print(factorial(10))',
'evaluated',82.00,'Plagio con comentarios añadidos artificialmente.',1,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()),

-- est06: PLAGIO — renombró n→valor, factorial→calcular
(@AID,@U06,
'def calcular(valor):
    if valor == 0 or valor == 1:
        return 1
    return valor * calcular(valor - 1)

print(calcular(5))
print(calcular(10))',
'evaluated',86.00,'Renombrado de función y parámetro. Estructura idéntica.',1,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()),

-- est07: PLAGIO — añadió print extra y cambió nombre
(@AID,@U07,
'def mi_factorial(n):
    if n == 0 or n == 1:
        return 1
    return n * mi_factorial(n - 1)

print("Resultado:", mi_factorial(5))
print("Resultado:", mi_factorial(10))
print("Listo")',
'evaluated',80.00,'Misma lógica con prints decorativos añadidos.',1,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()),

-- est08: PLAGIO — operador equivalente (n-1 → n-1 con paréntesis extra)
(@AID,@U08,
'def factorial(n):
    if (n == 0) or (n == 1):
        return 1
    return n * factorial((n - 1))

print(factorial(5))
print(factorial(10))',
'evaluated',84.00,'Paréntesis redundantes añadidos. Estructura idéntica.',1,UNIX_TIMESTAMP(),UNIX_TIMESTAMP());

-- GRUPO B (est09-est14): PLAGIO — bubble sort, variantes del mismo código

INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified) VALUES
-- est09: ORIGINAL base del grupo B
(@AID,@U09,
'def bubble_sort(arr):
    n = len(arr)
    for i in range(n):
        for j in range(0, n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort([64, 34, 25, 12, 22, 11, 90]))',
'evaluated',90.00,'Implementación correcta de bubble sort.',1,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()),

-- est10: PLAGIO — renombró arr→lista, n→tam
(@AID,@U10,
'def bubble_sort(lista):
    tam = len(lista)
    for i in range(tam):
        for j in range(0, tam-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

print(bubble_sort([64, 34, 25, 12, 22, 11, 90]))',
'evaluated',87.00,'Renombrado de variables. Estructura idéntica al original.',1,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()),

-- est11: PLAGIO — renombró arr→datos, bubble_sort→ordenar
(@AID,@U11,
'def ordenar(datos):
    n = len(datos)
    for i in range(n):
        for j in range(0, n-i-1):
            if datos[j] > datos[j+1]:
                datos[j], datos[j+1] = datos[j+1], datos[j]
    return datos

print(ordenar([64, 34, 25, 12, 22, 11, 90]))',
'evaluated',88.00,'Renombrado de función y parámetro.',1,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()),

-- est12: PLAGIO — variable temporal explícita en el swap
(@AID,@U12,
'def bubble_sort(arr):
    n = len(arr)
    for i in range(n):
        for j in range(0, n-i-1):
            if arr[j] > arr[j+1]:
                temp = arr[j]
                arr[j] = arr[j+1]
                arr[j+1] = temp
    return arr

print(bubble_sort([64, 34, 25, 12, 22, 11, 90]))',
'evaluated',83.00,'Swap con variable temporal en lugar de tuple unpacking.',1,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()),

-- est13: PLAGIO — comentarios + mismo algoritmo
(@AID,@U13,
'def bubble_sort(arr):
    n = len(arr)
    # recorrer todos los elementos
    for i in range(n):
        # comparar elementos adyacentes
        for j in range(0, n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort([64, 34, 25, 12, 22, 11, 90]))',
'evaluated',81.00,'Comentarios añadidos. Lógica idéntica.',1,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()),

-- est14: PLAGIO — renombró variables + print diferente
(@AID,@U14,
'def sort_burbuja(arreglo):
    longitud = len(arreglo)
    for i in range(longitud):
        for j in range(0, longitud-i-1):
            if arreglo[j] > arreglo[j+1]:
                arreglo[j], arreglo[j+1] = arreglo[j+1], arreglo[j]
    return arreglo

resultado = sort_burbuja([64, 34, 25, 12, 22, 11, 90])
print("Ordenado:", resultado)',
'evaluated',85.00,'Renombrado completo de variables. Misma estructura.',1,UNIX_TIMESTAMP(),UNIX_TIMESTAMP());

-- GRUPO C (est15-est18): SOSPECHOSOS — cambio de bucle o lógica equivalente

INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified) VALUES
-- est15: SOSPECHOSO — factorial con while en vez de recursión
(@AID,@U15,
'def factorial(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(factorial(5))
print(factorial(10))',
'evaluated',75.00,'Sospechoso. Misma lógica con while en lugar de recursión.',1,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()),

-- est16: SOSPECHOSO — factorial con for
(@AID,@U16,
'def factorial(n):
    resultado = 1
    for i in range(1, n+1):
        resultado = resultado * i
    return resultado

print(factorial(5))
print(factorial(10))',
'evaluated',76.00,'Sospechoso. Cambio de recursión a bucle for.',1,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()),

-- est17: SOSPECHOSO — bubble sort con flag de optimización
(@AID,@U17,
'def bubble_sort(arr):
    n = len(arr)
    for i in range(n):
        swapped = False
        for j in range(0, n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
                swapped = True
        if not swapped:
            break
    return arr

print(bubble_sort([64, 34, 25, 12, 22, 11, 90]))',
'evaluated',72.00,'Sospechoso. Bubble sort optimizado con flag. Lógica base similar.',1,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()),

-- est18: SOSPECHOSO — factorial reduce
(@AID,@U18,
'from functools import reduce

def factorial(n):
    if n == 0:
        return 1
    return reduce(lambda x, y: x * y, range(1, n+1))

print(factorial(5))
print(factorial(10))',
'evaluated',68.00,'Sospechoso. Usa reduce pero misma lógica matemática.',1,UNIX_TIMESTAMP(),UNIX_TIMESTAMP());

-- GRUPO D (est19-est22): PLAGIO con código muerto y reordenación

INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified) VALUES
-- est19: PLAGIO — factorial con variables inútiles y código muerto
(@AID,@U19,
'def factorial(n):
    x = 0
    y = 1
    z = n + 0
    if z == 0 or z == 1:
        return 1
    return z * factorial(z - 1)

a = factorial(5)
b = factorial(10)
print(a)
print(b)',
'evaluated',77.00,'Plagio con variables inútiles (x,y,z). Lógica idéntica.',1,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()),

-- est20: PLAGIO — bubble sort con líneas de código muerto
(@AID,@U20,
'def bubble_sort(arr):
    n = len(arr)
    dummy = []
    count = 0
    for i in range(n):
        for j in range(0, n-i-1):
            count += 1
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

print(bubble_sort([64, 34, 25, 12, 22, 11, 90]))',
'evaluated',78.00,'Variables dummy y contador inútil añadidos.',1,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()),

-- est21: PLAGIO — factorial con assert inútil al inicio
(@AID,@U21,
'def factorial(n):
    assert isinstance(n, int)
    if n == 0 or n == 1:
        return 1
    return n * factorial(n - 1)

print(factorial(5))
print(factorial(10))',
'evaluated',80.00,'Assert añadido como distractor. Lógica idéntica.',1,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()),

-- est22: PLAGIO — factorial con try/except innecesario
(@AID,@U22,
'def factorial(n):
    try:
        if n == 0 or n == 1:
            return 1
        return n * factorial(n - 1)
    except:
        return -1

print(factorial(5))
print(factorial(10))',
'evaluated',76.00,'Try/except innecesario añadido. Misma lógica interna.',1,UNIX_TIMESTAMP(),UNIX_TIMESTAMP());

-- GRUPO E (est23-est30): ORIGINALES — soluciones completamente distintas

INSERT INTO mdl_aiassignment_submissions (assignment,userid,answer,status,score,feedback,attempt,timecreated,timemodified) VALUES
-- est23: ORIGINAL — selection sort
(@AID,@U23,
'def selection_sort(arr):
    n = len(arr)
    for i in range(n):
        min_idx = i
        for j in range(i+1, n):
            if arr[j] < arr[min_idx]:
                min_idx = j
        arr[i], arr[min_idx] = arr[min_idx], arr[i]
    return arr

print(selection_sort([64, 34, 25, 12, 22, 11, 90]))',
'evaluated',91.00,'Solución original con selection sort.',1,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()),

-- est24: ORIGINAL — insertion sort
(@AID,@U24,
'def insertion_sort(arr):
    for i in range(1, len(arr)):
        key = arr[i]
        j = i - 1
        while j >= 0 and arr[j] > key:
            arr[j+1] = arr[j]
            j -= 1
        arr[j+1] = key
    return arr

print(insertion_sort([64, 34, 25, 12, 22, 11, 90]))',
'evaluated',93.00,'Solución original con insertion sort.',1,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()),

-- est25: ORIGINAL — factorial con math.prod
(@AID,@U25,
'import math

def factorial(n):
    return math.prod(range(1, n+1)) if n > 0 else 1

print(factorial(5))
print(factorial(10))',
'evaluated',88.00,'Solución original usando math.prod.',1,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()),

-- est26: ORIGINAL — merge sort
(@AID,@U26,
'def merge_sort(arr):
    if len(arr) <= 1:
        return arr
    mid = len(arr) // 2
    left = merge_sort(arr[:mid])
    right = merge_sort(arr[mid:])
    return merge(left, right)

def merge(left, right):
    result = []
    i = j = 0
    while i < len(left) and j < len(right):
        if left[i] <= right[j]:
            result.append(left[i]); i += 1
        else:
            result.append(right[j]); j += 1
    result.extend(left[i:])
    result.extend(right[j:])
    return result

print(merge_sort([64, 34, 25, 12, 22, 11, 90]))',
'evaluated',96.00,'Excelente. Merge sort original y bien implementado.',1,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()),

-- est27: ORIGINAL — factorial con memoización
(@AID,@U27,
'cache = {}

def factorial(n):
    if n in cache:
        return cache[n]
    if n <= 1:
        return 1
    cache[n] = n * factorial(n - 1)
    return cache[n]

print(factorial(5))
print(factorial(10))',
'evaluated',94.00,'Solución original con memoización. Muy eficiente.',1,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()),

-- est28: ORIGINAL — quick sort
(@AID,@U28,
'def quick_sort(arr):
    if len(arr) <= 1:
        return arr
    pivot = arr[len(arr) // 2]
    left = [x for x in arr if x < pivot]
    middle = [x for x in arr if x == pivot]
    right = [x for x in arr if x > pivot]
    return quick_sort(left) + middle + quick_sort(right)

print(quick_sort([64, 34, 25, 12, 22, 11, 90]))',
'evaluated',95.00,'Quick sort original con list comprehensions.',1,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()),

-- est29: ORIGINAL — factorial iterativo con stack
(@AID,@U29,
'def factorial(n):
    stack = list(range(2, n+1))
    result = 1
    while stack:
        result *= stack.pop()
    return result

print(factorial(5))
print(factorial(10))',
'evaluated',89.00,'Solución original usando stack explícito.',1,UNIX_TIMESTAMP(),UNIX_TIMESTAMP()),

-- est30: ORIGINAL — counting sort
(@AID,@U30,
'def counting_sort(arr):
    if not arr:
        return arr
    max_val = max(arr)
    count = [0] * (max_val + 1)
    for num in arr:
        count[num] += 1
    result = []
    for i, c in enumerate(count):
        result.extend([i] * c)
    return result

print(counting_sort([64, 34, 25, 12, 22, 11, 90]))',
'evaluated',92.00,'Counting sort original. Enfoque completamente diferente.',1,UNIX_TIMESTAMP(),UNIX_TIMESTAMP());

-- ── 5. INSERTAR EVALUACIONES IA ───────────────────────────────
INSERT INTO mdl_aiassignment_evaluations (submission, similarity_score, ai_feedback, ai_analysis, timecreated)
SELECT
  s.id,
  CASE u.username
    -- Grupo A: plagio factorial
    WHEN 'est01' THEN  8.00
    WHEN 'est02' THEN 91.00
    WHEN 'est03' THEN 89.00
    WHEN 'est04' THEN 79.00
    WHEN 'est05' THEN 82.00
    WHEN 'est06' THEN 87.00
    WHEN 'est07' THEN 78.00
    WHEN 'est08' THEN 84.00
    -- Grupo B: plagio bubble sort
    WHEN 'est09' THEN  9.00
    WHEN 'est10' THEN 88.00
    WHEN 'est11' THEN 90.00
    WHEN 'est12' THEN 81.00
    WHEN 'est13' THEN 80.00
    WHEN 'est14' THEN 86.00
    -- Grupo C: sospechosos
    WHEN 'est15' THEN 58.00
    WHEN 'est16' THEN 55.00
    WHEN 'est17' THEN 52.00
    WHEN 'est18' THEN 48.00
    -- Grupo D: plagio con código muerto
    WHEN 'est19' THEN 77.00
    WHEN 'est20' THEN 76.00
    WHEN 'est21' THEN 80.00
    WHEN 'est22' THEN 75.00
    -- Grupo E: originales
    WHEN 'est23' THEN 11.00
    WHEN 'est24' THEN  9.00
    WHEN 'est25' THEN 14.00
    WHEN 'est26' THEN  7.00
    WHEN 'est27' THEN 16.00
    WHEN 'est28' THEN  8.00
    WHEN 'est29' THEN 13.00
    WHEN 'est30' THEN 10.00
  END AS similarity_score,
  CASE u.username
    WHEN 'est01' THEN 'Solución recursiva original. Sin similitudes sospechosas.'
    WHEN 'est02' THEN 'PLAGIO: Renombrado de variables (n→num, factorial→calc_fact). Estructura idéntica.'
    WHEN 'est03' THEN 'PLAGIO: Renombrado (n→x, factorial→fact). Estructura idéntica.'
    WHEN 'est04' THEN 'PLAGIO: Variable auxiliar inútil y reordenación de condición base.'
    WHEN 'est05' THEN 'PLAGIO: Comentarios añadidos artificialmente. Lógica idéntica.'
    WHEN 'est06' THEN 'PLAGIO: Renombrado completo (n→valor, factorial→calcular).'
    WHEN 'est07' THEN 'PLAGIO: Prefijo mi_ añadido al nombre. Prints decorativos.'
    WHEN 'est08' THEN 'PLAGIO: Paréntesis redundantes añadidos. Estructura idéntica.'
    WHEN 'est09' THEN 'Bubble sort original. Sin similitudes sospechosas.'
    WHEN 'est10' THEN 'PLAGIO: Renombrado (arr→lista, n→tam). Estructura idéntica.'
    WHEN 'est11' THEN 'PLAGIO: Renombrado (arr→datos, bubble_sort→ordenar).'
    WHEN 'est12' THEN 'PLAGIO: Swap con variable temporal en lugar de tuple unpacking.'
    WHEN 'est13' THEN 'PLAGIO: Comentarios añadidos. Lógica idéntica.'
    WHEN 'est14' THEN 'PLAGIO: Renombrado completo de todas las variables.'
    WHEN 'est15' THEN 'SOSPECHOSO: Misma lógica factorial con while en lugar de recursión.'
    WHEN 'est16' THEN 'SOSPECHOSO: Cambio de recursión a bucle for.'
    WHEN 'est17' THEN 'SOSPECHOSO: Bubble sort optimizado con flag. Base similar.'
    WHEN 'est18' THEN 'SOSPECHOSO: Usa reduce pero misma lógica matemática.'
    WHEN 'est19' THEN 'PLAGIO: Variables inútiles (x,y,z) añadidas como distractor.'
    WHEN 'est20' THEN 'PLAGIO: Variable dummy y contador inútil añadidos.'
    WHEN 'est21' THEN 'PLAGIO: Assert añadido como distractor. Lógica idéntica.'
    WHEN 'est22' THEN 'PLAGIO: Try/except innecesario envolviendo la misma lógica.'
    WHEN 'est23' THEN 'Solución original con selection sort.'
    WHEN 'est24' THEN 'Solución original con insertion sort.'
    WHEN 'est25' THEN 'Solución original usando math.prod.'
    WHEN 'est26' THEN 'Solución original con merge sort. Excelente implementación.'
    WHEN 'est27' THEN 'Solución original con memoización.'
    WHEN 'est28' THEN 'Solución original con quick sort.'
    WHEN 'est29' THEN 'Solución original usando stack explícito.'
    WHEN 'est30' THEN 'Solución original con counting sort.'
  END AS ai_feedback,
  CASE u.username
    WHEN 'est01' THEN '{"verdict":"original","lexical":8,"structural":10,"semantic":8,"techniques":[]}'
    WHEN 'est02' THEN '{"verdict":"plagio","lexical":93,"structural":96,"semantic":91,"techniques":["Renombrado de variables","Renombrado de función"]}'
    WHEN 'est03' THEN '{"verdict":"plagio","lexical":91,"structural":95,"semantic":89,"techniques":["Renombrado de variables","Renombrado de función"]}'
    WHEN 'est04' THEN '{"verdict":"plagio","lexical":68,"structural":84,"semantic":79,"techniques":["Reordenación de sentencias","Inserción de código muerto"]}'
    WHEN 'est05' THEN '{"verdict":"plagio","lexical":72,"structural":88,"semantic":82,"techniques":["Comentarios falsos"]}'
    WHEN 'est06' THEN '{"verdict":"plagio","lexical":90,"structural":94,"semantic":87,"techniques":["Renombrado de variables","Renombrado de función"]}'
    WHEN 'est07' THEN '{"verdict":"plagio","lexical":70,"structural":85,"semantic":78,"techniques":["Renombrado de función","Código decorativo"]}'
    WHEN 'est08' THEN '{"verdict":"plagio","lexical":88,"structural":92,"semantic":84,"techniques":["Paréntesis redundantes"]}'
    WHEN 'est09' THEN '{"verdict":"original","lexical":9,"structural":11,"semantic":9,"techniques":[]}'
    WHEN 'est10' THEN '{"verdict":"plagio","lexical":90,"structural":95,"semantic":88,"techniques":["Renombrado de variables"]}'
    WHEN 'est11' THEN '{"verdict":"plagio","lexical":91,"structural":96,"semantic":90,"techniques":["Renombrado de variables","Renombrado de función"]}'
    WHEN 'est12' THEN '{"verdict":"plagio","lexical":75,"structural":86,"semantic":81,"techniques":["Cambio de operador equivalente (tuple swap→temp var)"]}'
    WHEN 'est13' THEN '{"verdict":"plagio","lexical":71,"structural":87,"semantic":80,"techniques":["Comentarios falsos"]}'
    WHEN 'est14' THEN '{"verdict":"plagio","lexical":89,"structural":93,"semantic":86,"techniques":["Renombrado completo"]}'
    WHEN 'est15' THEN '{"verdict":"sospechoso","lexical":40,"structural":65,"semantic":58,"techniques":["Cambio de bucle (recursión→while)"]}'
    WHEN 'est16' THEN '{"verdict":"sospechoso","lexical":38,"structural":62,"semantic":55,"techniques":["Cambio de bucle (recursión→for)"]}'
    WHEN 'est17' THEN '{"verdict":"sospechoso","lexical":35,"structural":60,"semantic":52,"techniques":["Optimización superficial"]}'
    WHEN 'est18' THEN '{"verdict":"sospechoso","lexical":22,"structural":55,"semantic":48,"techniques":["Cambio de paradigma (reduce)"]}'
    WHEN 'est19' THEN '{"verdict":"plagio","lexical":62,"structural":80,"semantic":77,"techniques":["Inserción de código muerto","Variables inútiles"]}'
    WHEN 'est20' THEN '{"verdict":"plagio","lexical":60,"structural":79,"semantic":76,"techniques":["Inserción de código muerto","Contador inútil"]}'
    WHEN 'est21' THEN '{"verdict":"plagio","lexical":74,"structural":83,"semantic":80,"techniques":["Código decorativo (assert)"]}'
    WHEN 'est22' THEN '{"verdict":"plagio","lexical":65,"structural":81,"semantic":75,"techniques":["Envoltorio innecesario (try/except)"]}'
    WHEN 'est23' THEN '{"verdict":"original","lexical":11,"structural":14,"semantic":11,"techniques":[]}'
    WHEN 'est24' THEN '{"verdict":"original","lexical":9,"structural":12,"semantic":9,"techniques":[]}'
    WHEN 'est25' THEN '{"verdict":"original","lexical":14,"structural":16,"semantic":14,"techniques":[]}'
    WHEN 'est26' THEN '{"verdict":"original","lexical":7,"structural":9,"semantic":7,"techniques":[]}'
    WHEN 'est27' THEN '{"verdict":"original","lexical":16,"structural":18,"semantic":16,"techniques":[]}'
    WHEN 'est28' THEN '{"verdict":"original","lexical":8,"structural":10,"semantic":8,"techniques":[]}'
    WHEN 'est29' THEN '{"verdict":"original","lexical":13,"structural":15,"semantic":13,"techniques":[]}'
    WHEN 'est30' THEN '{"verdict":"original","lexical":10,"structural":12,"semantic":10,"techniques":[]}'
  END AS ai_analysis,
  UNIX_TIMESTAMP() AS timecreated
FROM mdl_aiassignment_submissions s
JOIN mdl_user u ON s.userid = u.id
WHERE s.assignment = @AID
  AND u.username IN (
    'est01','est02','est03','est04','est05','est06','est07','est08',
    'est09','est10','est11','est12','est13','est14','est15','est16',
    'est17','est18','est19','est20','est21','est22','est23','est24',
    'est25','est26','est27','est28','est29','est30'
  );

SET FOREIGN_KEY_CHECKS = 1;

-- ── 6. REPORTE FINAL ─────────────────────────────────────────
SELECT
  u.firstname AS nombre,
  u.lastname  AS apellido,
  s.score     AS calificacion,
  e.similarity_score AS pct_plagio,
  JSON_UNQUOTE(JSON_EXTRACT(e.ai_analysis,'$.verdict')) AS veredicto,
  JSON_UNQUOTE(JSON_EXTRACT(e.ai_analysis,'$.techniques[0]')) AS tecnica_principal,
  CASE
    WHEN e.similarity_score >= 75 THEN '🔴 PLAGIO'
    WHEN e.similarity_score >= 50 THEN '🟡 SOSPECHOSO'
    ELSE '🟢 ORIGINAL'
  END AS estado
FROM mdl_aiassignment_submissions s
JOIN mdl_user u ON s.userid = u.id
JOIN mdl_aiassignment_evaluations e ON e.submission = s.id
WHERE s.assignment = @AID
  AND u.username REGEXP '^est[0-9]+$'
ORDER BY e.similarity_score DESC;

-- Resumen por grupo
SELECT
  CASE
    WHEN e.similarity_score >= 75 THEN 'PLAGIO'
    WHEN e.similarity_score >= 50 THEN 'SOSPECHOSO'
    ELSE 'ORIGINAL'
  END AS categoria,
  COUNT(*) AS total,
  ROUND(AVG(e.similarity_score),2) AS promedio_similitud
FROM mdl_aiassignment_submissions s
JOIN mdl_user u ON s.userid = u.id
JOIN mdl_aiassignment_evaluations e ON e.submission = s.id
WHERE s.assignment = @AID AND u.username REGEXP '^est[0-9]+$'
GROUP BY categoria
ORDER BY promedio_similitud DESC;
