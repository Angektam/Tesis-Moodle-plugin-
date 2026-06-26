# Documento 4 — Procedimientos de Prueba (IEEE 829)
# AI Assignment Plugin v2.5.0

---

## PROC-01: Ejecutar pruebas unitarias PHPUnit

**Casos cubiertos:** CP-01 al CP-12
**Tiempo estimado:** 5 minutos

**Pasos:**

1. Abrir terminal en el directorio raíz de Moodle
2. Ejecutar el siguiente comando:
   ```bash
   vendor/bin/phpunit mod/aiassignment/tests/
   ```
3. Verificar que todos los tests pasan (verde)
4. Si algún test falla, revisar el mensaje de error y el archivo correspondiente
5. Registrar resultados en el Log de Pruebas (Documento 6)

**Criterio de éxito:** 62 tests ejecutados, 0 fallos, 0 errores

---

## PROC-02: Ejecutar experimento controlado con 30 alumnos

**Casos cubiertos:** CP-13, CP-14
**Tiempo estimado:** 30 minutos

**Pasos:**

1. Abrir phpMyAdmin en Hostinger
2. Seleccionar la base de datos `u698086472_56pkq`
3. Ir a la pestaña SQL
4. Copiar y pegar el contenido de `scripts/inscribir-30-alumnos.sql`
5. Hacer clic en "Go" para ejecutar
6. Verificar que se insertaron 30 alumnos con sus envíos:
   ```sql
   SELECT COUNT(*) FROM oy1n_aiassignment_submissions s
   JOIN oy1n_user u ON s.userid = u.id
   WHERE u.username LIKE 'est%';
   ```
   Resultado esperado: 30 registros
7. Iniciar sesión en Moodle como `yobani` / `Test1234!`
8. Ir al curso de prueba → tarea → "Ver todos los envíos"
9. Hacer clic en "🔍 Iniciar análisis de plagio"
10. Seleccionar "⚡ Análisis Rápido"
11. Registrar el tiempo de inicio
12. Esperar a que termine el análisis
13. Registrar el tiempo de fin
14. Verificar los resultados:
    - Total comparaciones: 435
    - Pares sospechosos: ≥ 16 (grupos A, B, D)
    - Similitud máxima: ≥ 75%
15. Registrar resultados en el Log de Pruebas

**Criterio de éxito:** Análisis completo en ≤ 60 segundos, ≥ 16 pares detectados

---

## PROC-03: Aplicar encuesta SUS

**Casos cubiertos:** CP-15
**Tiempo estimado:** 45 minutos (15 min por participante × 3 sesiones)

**Pasos:**

1. Preparar el entorno: asegurarse de que el plugin está funcionando en Moodle
2. Para cada participante (maestro Yobani + alumnos 01-05):
   a. Pedir al participante que use el plugin durante al menos 10 minutos
   b. Para el maestro: crear una tarea, ver el dashboard, ejecutar análisis de plagio
   c. Para los alumnos: enviar código, ver calificación, ver retroalimentación
3. Después del uso, pedir al participante que acceda a:
   `https://[dominio]/mod/aiassignment/sus_survey.php?id=[cmid]`
4. El participante completa las 10 preguntas del 1 al 5
5. El sistema calcula automáticamente el score SUS
4. Registrar el score de cada participante
5. Calcular el promedio

**Criterio de éxito:** Score promedio ≥ 70

---

## PROC-04: Prueba de seguridad — entradas maliciosas

**Casos cubiertos:** CP-02, CP-03
**Tiempo estimado:** 15 minutos

**Pasos:**

1. Iniciar sesión en Moodle como `alumno01` / `Test1234!`
2. Ir a la tarea de prueba
3. En el editor de código, intentar enviar cada una de las siguientes entradas:

   **Prueba 4.1 — Código vacío:**
   - Dejar el editor vacío
   - Hacer clic en "Enviar"
   - Resultado esperado: mensaje de error "La respuesta es obligatoria"

   **Prueba 4.2 — Script XSS:**
   - Escribir: `<script>alert("xss")</script>`
   - Hacer clic en "Enviar"
   - Resultado esperado: mensaje de error "La respuesta contiene contenido no permitido"

   **Prueba 4.3 — Código muy corto:**
   - Escribir: `ab`
   - Hacer clic en "Enviar"
   - Resultado esperado: mensaje de error sobre longitud mínima

4. Registrar cada resultado en el Log de Pruebas

**Criterio de éxito:** Todas las entradas maliciosas son rechazadas con mensaje de error apropiado

---

## PROC-05: Prueba de rendimiento con 150 alumnos

**Casos cubiertos:** CP-13 (escala mayor)
**Tiempo estimado:** 2 horas

**Pasos:**

1. Generar el script SQL ejecutando:
   ```bash
   node scripts/generar-150-alumnos.js
   ```
2. Ejecutar el script generado en phpMyAdmin
3. Verificar que se crearon 150 alumnos, 6 cursos y 300 envíos
4. Iniciar sesión como `maestro01` / `Test1234!`
5. Ir al curso "Programación I — Grupo A"
6. Ejecutar análisis de plagio en Modo Rápido
7. Registrar tiempo de inicio y fin
8. Verificar que el análisis completa sin timeout
9. Registrar resultados

**Criterio de éxito:** Análisis completa sin error de timeout, resultados coherentes con la distribución esperada (40% plagio, 20% sospechoso, 40% original)
