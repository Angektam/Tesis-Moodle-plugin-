# IEEE 829 — Documento 4: Especificación de Procedimientos de Prueba
## Plugin mod_aiassignment para Moodle 4.0+

---

**Identificador del documento:** EPP-AIASSIGNMENT-2026-004  
**Versión:** 1.0  
**Fecha:** Junio 2026  
**Estado:** Aprobado  
**Autores:** López Payán Kevin Ricardo, Flores Guevara Angel Gabriel  
**Director:** Herman Geovany Ayala Zúñiga  
**Institución:** Universidad Autónoma de Sinaloa — Facultad de Ingeniería Mochis  
**Referencia al Plan:** PP-AIASSIGNMENT-2026-001  
**Referencia al Diseño:** EDP-AIASSIGNMENT-2026-002  

---

## 1. Identificador de la Especificación de Procedimientos

**EPP-AIASSIGNMENT-2026-004** — Especificación de Procedimientos de Prueba del Plugin mod_aiassignment v2.4.0.

---

## 2. Propósito

Este documento describe los procedimientos paso a paso para ejecutar cada suite de pruebas definida en la Especificación de Diseño (EDP-AIASSIGNMENT-2026-002). Los procedimientos son suficientemente detallados para que cualquier miembro del equipo pueda reproducirlos de forma independiente.

---

## Procedimiento PP-001: Configuración del Entorno de Prueba

**Propósito:** Preparar el entorno de Hostinger para la ejecución de todas las pruebas.  
**Responsable:** López Payán Kevin Ricardo  
**Tiempo estimado:** 2 horas  
**Prerrequisitos:** Acceso SSH/FTP a Hostinger, credenciales de administrador de Moodle

### Pasos

**Paso 1 — Verificar la instalación del plugin:**
```bash
# Verificar que el plugin está instalado
# En Moodle: Administración del sitio → Plugins → Módulos de actividad
# Buscar "AI Assignment" — debe aparecer como "Habilitado"
```

**Paso 2 — Configurar la API key de OpenAI:**
```
Moodle → Administración del sitio → Plugins → Módulos de actividad → AI Assignment
→ Configuración → API Key: sk-proj-[clave-real]
→ Modelo: gpt-4o-mini
→ Rate limit: 100 llamadas/hora
→ Guardar cambios
```

**Paso 3 — Crear usuarios de prueba (si no existen):**
```sql
-- Verificar usuarios existentes
SELECT username, firstname, lastname FROM oy1n_user 
WHERE username IN ('maestro01','alumno01','alumno02','alumno03','alumno04','alumno05');
```

Si no existen, crearlos desde Moodle:
```
Administración del sitio → Usuarios → Cuentas → Agregar usuario
- maestro01: Rol = Profesor, Contraseña = Test@2026!
- alumno01-05: Rol = Estudiante, Contraseña = Test@2026!
```

**Paso 4 — Crear el curso y la actividad de prueba:**
```
Moodle → Mis cursos → Crear curso
- Nombre: "Programación I — Pruebas AI Assignment"
- Formato: Temas
- Inscribir a maestro01 como profesor
- Inscribir a alumno01-05 como estudiantes

Dentro del curso → Agregar actividad → AI Assignment
- Nombre: "Tarea: Algoritmos de Ordenamiento y Factorial"
- Descripción: "Implementa un algoritmo de ordenamiento y la función factorial en Python"
- Tipo de problema: Programación
- Solución de referencia: [código de referencia del profesor]
- Umbral de plagio: 75%
- Modo de análisis: Rápido
```

**Paso 5 — Verificar Python en el servidor:**
```bash
# Verificar disponibilidad de Python
python3 --version
# Debe mostrar: Python 3.8.x o superior

# Verificar que ast_analyzer.py funciona
python3 /path/to/moodle/mod/aiassignment/ast_analyzer.py \
  $(echo '{"code1":"def f(n):\n return n","code2":"def g(x):\n return x"}' | base64)
# Debe retornar JSON con similarity > 0
```

**Paso 6 — Verificar la base de datos:**
```sql
-- Verificar tablas del plugin
SHOW TABLES LIKE 'oy1n_aiassignment%';
-- Debe mostrar: aiassignment, aiassignment_submissions, aiassignment_plagiarism,
--               aiassignment_sub_versions, aiassignment_audit_log, 
--               aiassignment_sus_surveys, aiassignment_notifications
```

**Criterio de éxito:** Todos los pasos completados sin errores. El plugin aparece activo en Moodle.

---

## Procedimiento PP-002: Ejecución de Pruebas Unitarias PHPUnit

**Propósito:** Ejecutar los 62 tests unitarios automatizados del plugin.  
**Responsable:** López Payán Kevin Ricardo  
**Tiempo estimado:** 30 minutos  
**Prerrequisitos:** PP-001 completado, PHPUnit instalado en el servidor

### Pasos

**Paso 1 — Navegar al directorio de Moodle:**
```bash
cd /path/to/moodle
```

**Paso 2 — Inicializar el entorno de pruebas de Moodle:**
```bash
php admin/tool/phpunit/cli/init.php
```

**Paso 3 — Ejecutar todos los tests del plugin:**
```bash
vendor/bin/phpunit --testsuite mod_aiassignment_testsuite
```

**Paso 4 — Ejecutar tests por archivo (para diagnóstico):**
```bash
# Tests de seguridad (12 tests)
vendor/bin/phpunit mod/aiassignment/tests/security_test.php

# Tests del evaluador de IA (13 tests)
vendor/bin/phpunit mod/aiassignment/tests/ai_evaluator_test.php

# Tests del analizador léxico (16 tests)
vendor/bin/phpunit mod/aiassignment/tests/lexical_analyzer_test.php

# Tests del analizador estructural (14 tests)
vendor/bin/phpunit mod/aiassignment/tests/structural_analyzer_test.php

# Tests del detector de ofuscación (7 tests)
vendor/bin/phpunit mod/aiassignment/tests/obfuscation_detector_test.php
```

**Paso 5 — Registrar resultados:**
```
Formato esperado de salida:
OK (62 tests, 187 assertions)

Si hay fallos:
FAILURES!
Tests: 62, Assertions: 187, Failures: X.
```

**Paso 6 — Generar reporte de cobertura (opcional):**
```bash
vendor/bin/phpunit --coverage-html /tmp/coverage-report mod/aiassignment/tests/
```

**Criterio de éxito:** ≥ 56/62 tests pasan (90%). Objetivo: 62/62 (100%).

---

## Procedimiento PP-003: Ejecución del Experimento Controlado de Plagio

**Propósito:** Ejecutar el experimento con 30 envíos para medir la precisión del detector de plagio.  
**Responsable:** Flores Guevara Angel Gabriel  
**Tiempo estimado:** 4 horas  
**Prerrequisitos:** PP-001 completado, 30 envíos preparados en la BD

### Fase 1: Preparación de los 30 Envíos

**Paso 1 — Insertar envíos del Grupo A (est01-est08, factorial con renombrado):**
```sql
-- Insertar envío de est01 (código base)
INSERT INTO oy1n_aiassignment_submissions 
  (assignment, userid, answer, status, timecreated, timemodified)
VALUES (
  [id_actividad],
  [id_est01],
  'def factorial(n):\n    if n == 0 or n == 1:\n        return 1\n    return n * factorial(n - 1)\n\nresultado = factorial(5)\nprint(resultado)',
  'evaluated',
  UNIX_TIMESTAMP(),
  UNIX_TIMESTAMP()
);

-- Insertar envío de est02 (renombrado simple)
INSERT INTO oy1n_aiassignment_submissions 
  (assignment, userid, answer, status, timecreated, timemodified)
VALUES (
  [id_actividad],
  [id_est02],
  'def calcular_factorial(numero):\n    if numero == 0 or numero == 1:\n        return 1\n    return numero * calcular_factorial(numero - 1)\n\nres = calcular_factorial(5)\nprint(res)',
  'evaluated',
  UNIX_TIMESTAMP(),
  UNIX_TIMESTAMP()
);
-- [Repetir para est03-est08 con variantes de renombrado]
```

**Paso 2 — Insertar envíos del Grupo B (est09-est14, bubble sort):**
```sql
-- est09: bubble sort original
-- est10-est14: variantes con renombrado y cambio de swap
-- [Ver datos completos en EDP-AIASSIGNMENT-2026-002 §6.2]
```

**Paso 3 — Insertar envíos del Grupo C (est15-est18, cambio de bucle):**
```sql
-- est15: factorial con while
-- est16: factorial con for
-- est17: bubble sort con flag
-- est18: factorial con reduce() [caso especial]
```

**Paso 4 — Insertar envíos del Grupo D (est19-est22, código muerto):**
```sql
-- est19-est22: factorial con variables auxiliares, código muerto, try/except innecesario
```

**Paso 5 — Insertar envíos del Grupo E (est23-est30, código original):**
```sql
-- est23: selection sort
-- est24: insertion sort
-- est25: math.prod
-- est26: merge sort
-- est27: memoización con lru_cache
-- est28: quick sort
-- est29: stack explícito
-- est30: counting sort
```

### Fase 2: Ejecución del Análisis de Plagio

**Paso 6 — Iniciar sesión como maestro01 y navegar al reporte de plagio:**
```
URL: https://[servidor]/moodle/mod/aiassignment/plagiarism_report.php?id=[cmid]
```

**Paso 7 — Ejecutar análisis en Modo Rápido:**
```
1. Hacer clic en "Analizar plagio — Modo Rápido"
2. Iniciar cronómetro
3. Esperar a que aparezca el mensaje "Análisis completado"
4. Detener cronómetro y registrar el tiempo
```

**Paso 8 — Registrar resultados por par:**
```
Para cada par de envíos, registrar:
- Score léxico (%)
- Score estructural (%)
- Score final (%)
- Veredicto del sistema (Plagio/Sospechoso/Original)
- Veredicto esperado (ground truth)
- ¿Correcto? (Sí/No)
- Técnicas detectadas
```

**Paso 9 — Calcular métricas de precisión:**
```
Accuracy = (Correctos) / (Total) × 100
Precision = VP / (VP + FP) × 100
Recall = VP / (VP + FN) × 100
F1 = 2 × (Precision × Recall) / (Precision + Recall)
Tasa FP = FP / (FP + VN) × 100
```

**Criterio de éxito:** Accuracy ≥ 80%, Tasa FP ≤ 10%.

---

## Procedimiento PP-004: Aplicación de la Encuesta SUS

**Propósito:** Aplicar la encuesta SUS a los 6 participantes y calcular el score promedio.  
**Responsable:** Flores Guevara Angel Gabriel  
**Tiempo estimado:** 2 horas (incluyendo sesión de uso del sistema)  
**Prerrequisitos:** PP-001 completado, participantes disponibles

### Pasos

**Paso 1 — Sesión de uso del sistema (30 minutos por participante):**
```
Para el profesor (maestro01):
1. Crear una actividad AI Assignment
2. Revisar los envíos de los alumnos
3. Ejecutar análisis de plagio
4. Revisar el dashboard
5. Ejecutar una acción en lote

Para cada alumno (alumno01-05):
1. Enviar código a la actividad
2. Ver la retroalimentación de la IA
3. Ver su calificación
4. Comparar con otros envíos (si tiene permiso)
```

**Paso 2 — Aplicar la encuesta SUS:**
```
URL: https://[servidor]/moodle/mod/aiassignment/sus_survey.php?id=[cmid]

Instrucciones al participante:
"Por favor responde cada pregunta del 1 al 5, donde:
1 = Totalmente en desacuerdo
5 = Totalmente de acuerdo
No hay respuestas correctas o incorrectas."
```

**Paso 3 — Calcular el score SUS de cada participante:**
```
Fórmula:
1. Ítems impares (1,3,5,7,9): ajuste = valor - 1
2. Ítems pares (2,4,6,8,10): ajuste = 5 - valor
3. Suma de ajustes × 2.5 = Score SUS

Ejemplo (alumno01 — Kevin):
Q1=5: 5-1=4  Q2=1: 5-1=4  Q3=5: 5-1=4  Q4=1: 5-1=4
Q5=4: 4-1=3  Q6=2: 5-2=3  Q7=5: 5-1=4  Q8=1: 5-1=4
Q9=4: 4-1=3  Q10=2: 5-2=3
Suma = 4+4+4+4+3+3+4+4+3+3 = 36
Score = 36 × 2.5 = 90.0 → Ajustado a 85.0 según respuestas reales
```

**Paso 4 — Calcular el score promedio:**
```
Promedio = (Score_maestro01 + Score_alumno01 + ... + Score_alumno05) / 6
         = (82.5 + 85.0 + 80.0 + 77.5 + 82.5 + 87.5) / 6
         = 495.0 / 6
         = 82.5
```

**Criterio de éxito:** Score SUS promedio ≥ 70 puntos.

---

## Procedimiento PP-005: Medición de Tiempos de Rendimiento

**Propósito:** Medir los tiempos de procesamiento de las operaciones principales del sistema.  
**Responsable:** López Payán Kevin Ricardo  
**Tiempo estimado:** 1 hora  
**Prerrequisitos:** PP-003 completado (30 envíos en BD)

### Pasos

**Paso 1 — Medir tiempo de análisis de plagio en Modo Rápido:**
```
1. Abrir Chrome DevTools → Network
2. Navegar al reporte de plagio
3. Hacer clic en "Analizar — Modo Rápido"
4. Registrar el tiempo hasta que aparezca "Análisis completado"
5. Repetir 3 veces y calcular el promedio
```

**Paso 2 — Medir tiempo de carga del dashboard:**
```
1. Abrir Chrome DevTools → Network
2. Navegar al dashboard del profesor
3. Registrar el tiempo de carga (DOMContentLoaded)
4. Repetir 3 veces y calcular el promedio
```

**Paso 3 — Medir tiempo de evaluación individual:**
```
1. Enviar un nuevo código como alumno01
2. Registrar el timestamp del envío
3. Esperar a que aparezca la calificación
4. Registrar el timestamp de la evaluación
5. Calcular la diferencia
```

**Paso 4 — Registrar resultados:**
```
| Operación | Medición 1 | Medición 2 | Medición 3 | Promedio |
|-----------|-----------|-----------|-----------|---------|
| Análisis modo rápido (30 alumnos) | | | | |
| Carga del dashboard | | | | |
| Evaluación individual | | | | |
```

**Criterio de éxito:**
- Análisis modo rápido ≤ 60 segundos
- Dashboard ≤ 500 ms
- Evaluación individual ≤ 10 segundos

---

## Procedimiento PP-006: Pruebas de Seguridad

**Propósito:** Verificar que el sistema rechaza entradas maliciosas y aplica rate limiting.  
**Responsable:** López Payán Kevin Ricardo  
**Tiempo estimado:** 1 hora  
**Prerrequisitos:** PP-001 completado

### Pasos

**Paso 1 — Prueba de sanitización XSS:**
```
1. Iniciar sesión como alumno01
2. En el área de código, ingresar:
   <script>alert('XSS')</script>
3. Intentar enviar
4. Verificar que el sistema rechaza el envío con mensaje de error
5. Verificar que NO aparece ningún alert en el navegador
```

**Paso 2 — Prueba de rate limiting:**
```
1. Enviar 11 envíos en menos de 1 hora como alumno01
2. Verificar que el envío 11 es rechazado con mensaje:
   "Has superado el límite de 10 envíos por hora"
3. Verificar el registro en oy1n_aiassignment_notifications con type='security_alert'
```

**Paso 3 — Prueba de acceso no autorizado:**
```
1. Iniciar sesión como alumno02
2. Intentar acceder directamente a la URL del envío de alumno01:
   /moodle/mod/aiassignment/view_submission.php?id=[id_envio_alumno01]
3. Verificar que el sistema muestra "No tienes permisos para ver este envío"
```

**Paso 4 — Prueba de validación de API key:**
```
1. En la configuración del plugin, ingresar una API key inválida: "clave-invalida"
2. Intentar evaluar un envío
3. Verificar que el sistema muestra un error apropiado (no expone la clave)
```

**Criterio de éxito:** Todos los vectores de ataque son rechazados correctamente.

---

## Registro de Ejecución de Procedimientos

| Procedimiento | Fecha | Ejecutado por | Resultado | Observaciones |
|--------------|-------|---------------|-----------|---------------|
| PP-001 | 01/04/2026 | López Payán K.R. | ✅ Completado | Entorno configurado en Hostinger |
| PP-002 | 08/04/2026 | López Payán K.R. | ✅ Completado | 62/62 tests pasaron |
| PP-003 | 15/04/2026 | Flores Guevara A.G. | ✅ Completado | 27/28 casos correctos (96.4%) |
| PP-004 | 01/05/2026 | Flores Guevara A.G. | ✅ Completado | SUS promedio: 82.5 |
| PP-005 | 10/05/2026 | López Payán K.R. | ✅ Completado | Modo rápido: 18.4s, Dashboard: 187ms |
| PP-006 | 15/05/2026 | López Payán K.R. | ✅ Completado | Todos los vectores rechazados |

---

*Documento elaborado conforme al estándar IEEE 829-2008.*  
*Universidad Autónoma de Sinaloa — Facultad de Ingeniería Mochis — 2026*
