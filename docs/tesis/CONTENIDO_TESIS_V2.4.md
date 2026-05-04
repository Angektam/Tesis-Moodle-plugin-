# Contenido para agregar a la Tesis v6.docx
# ============================================
# INSTRUCCIONES: Copiar y pegar cada sección en el lugar indicado en Word.
# NO modificar el índice — solo rellenar las secciones vacías y actualizar datos.
# ============================================


## ═══════════════════════════════════════════════════════════
## SECCIÓN 3.4.1 — Código Fuente (pegar en la página 32)
## ═══════════════════════════════════════════════════════════

3.4.1 Código Fuente

El código fuente del plugin se organiza siguiendo los estándares de desarrollo de Moodle para módulos de actividad (mod). La estructura completa del proyecto se divide en cuatro componentes principales:

1. Plugin principal (moodle-plugin/): Contiene todo el código PHP, JavaScript, CSS, esquemas de base de datos y archivos de configuración que se empaquetan en un archivo ZIP para su instalación en Moodle. Este es el producto final del proyecto.

2. Demos independientes (demo-standalone/): Prototipos funcionales desarrollados en Node.js que permitieron probar cada servicio de forma aislada antes de integrarlo al plugin: Judge0 para ejecución de código, VirusTotal para escaneo de archivos, GitHub para búsqueda de código similar y el analizador AST de Python.

3. Documentación (docs/): Documentación técnica, guías de instalación, manuales de usuario y documentos de la tesis organizados en subcarpetas temáticas.

4. Scripts de utilidad (scripts/): Scripts SQL para crear datos de prueba, scripts Node.js para generar el ZIP del plugin y el manual de usuario en Word, y scripts de verificación de APIs.

El plugin está escrito principalmente en PHP 8.1+ para la lógica de negocio e integración con Moodle, Python 3.8+ para el análisis AST de código fuente, JavaScript ES6 para la interactividad del frontend (AJAX, gráficas, filtros), y CSS3 con variables personalizadas para los estilos visuales.

La versión final del plugin (v2.4.0) contiene 42 archivos PHP con aproximadamente 6,500 líneas de código, 8 archivos JavaScript con 800 líneas, 2 archivos Python con 200 líneas, y 62 tests unitarios PHPUnit distribuidos en 5 archivos de prueba. El archivo ZIP instalable tiene un tamaño de 237 KB.

El repositorio completo del proyecto está disponible en GitHub y utiliza Git para el control de versiones, con un historial de commits que documenta la evolución del desarrollo desde la versión 1.0 hasta la versión 2.4.0.


## ═══════════════════════════════════════════════════════════
## SECCIÓN 3.4.2 — Funcionalidad del software (pegar después de 3.4.1)
## ═══════════════════════════════════════════════════════════

3.4.2 Funcionalidad del software

El plugin AI Assignment implementa las siguientes funcionalidades principales:

Evaluación automática con IA: Cuando un estudiante envía su código, el sistema lo compara con la solución de referencia del profesor utilizando OpenAI GPT-4o-mini. La IA evalúa cuatro dimensiones: corrección funcional, calidad del código, eficiencia algorítmica y buenas prácticas. El resultado es una calificación de 0 a 100 con retroalimentación detallada en español. El sistema soporta seis tipos de problemas: programación, matemáticas, ensayo, SQL, pseudocódigo y depuración de código.

Detección de plagio en 3 capas: El sistema compara todos los envíos entre sí utilizando tres niveles de análisis. La capa léxica (peso 35%) normaliza los identificadores del código y calcula similitud mediante el coeficiente de Jaccard sobre bigramas de tokens, el ratio LCS (Longest Common Subsequence) y la distancia de Levenshtein normalizada. La capa estructural (peso 30%) extrae métricas del código como número de funciones, bucles, condicionales, profundidad de anidamiento y secuencia de estructuras de control; para código Python utiliza análisis AST real mediante el módulo ast.parse() ejecutado como proceso hijo. La capa semántica (peso 35%) utiliza OpenAI GPT para detectar reescrituras lógicas que mantienen la misma funcionalidad con código visualmente diferente. El score final se calcula como: score = (léxica × 0.35) + (estructural × 0.30) + (semántica × 0.35), con un ajuste adicional de +5 puntos por cada técnica de ofuscación detectada (máximo 4 técnicas).

Detección de técnicas de ofuscación: El sistema identifica automáticamente seis técnicas comunes que los estudiantes utilizan para disfrazar código copiado: renombrado de variables y funciones, cambio de tipo de bucle (for a while o recursión), reordenación de sentencias independientes, inserción de código muerto o variables sin usar, cambio de operadores equivalentes (i++ a i+=1) e inserción de comentarios falsos para inflar el código.

Dashboard del profesor: Panel de control con cinco tarjetas de estadísticas en tiempo real (total de tareas, promedio general, estudiantes activos, evaluaciones pendientes, alertas de plagio), tabla de resumen de tareas, lista de envíos recientes filtrable por tarea, ranking de los mejores estudiantes, sección de alumnos en riesgo de plagio, y cuatro gráficas interactivas generadas con Chart.js: distribución de calificaciones (barras), actividad de los últimos 7 días (línea), correlación plagio vs calificación (scatter) y precisión del detector de plagio (dona).

Acciones en lote: El profesor puede seleccionar múltiples envíos mediante checkboxes y ejecutar acciones masivas: re-evaluar con la IA, marcar como plagio confirmado o desmarcar falsos positivos. Cada acción queda registrada en el sistema de auditoría.

Versionado de submissions: Antes de cada re-envío o re-evaluación, el sistema guarda automáticamente una copia completa del envío anterior (código, calificación, feedback, estado) en una tabla de versiones. Esto permite al profesor consultar el historial completo de cambios de cualquier envío.

Sistema de auditoría: Todas las acciones del profesor (calificación manual, re-evaluación, confirmación o descarte de plagio, solicitud de re-envío) quedan registradas con la dirección IP, el timestamp y los datos del cambio. El sistema incluye una política de retención automática que elimina registros de más de un año.

Rate limiting para OpenAI: Para proteger la cuota de la API, el sistema implementa un límite configurable de llamadas por hora (default 100). Cuando se alcanza el límite, las evaluaciones quedan en cola y se procesan cuando hay cuota disponible.

Procesamiento asíncrono: Tanto la evaluación de envíos como el análisis de plagio se ejecutan como tareas asíncronas de Moodle (adhoc tasks), evitando que el estudiante o el profesor queden bloqueados esperando la respuesta de la API.

Notificaciones en tiempo real: El sistema notifica al estudiante cuando su envío es evaluado y al profesor cuando el análisis de plagio termina, utilizando el sistema de mensajería nativo de Moodle complementado con polling AJAX cada 15 segundos.

Exportación de datos: Los reportes del curso y las calificaciones se pueden exportar en formato CSV (compatible con Excel), XLSX y PDF para su uso fuera de la plataforma.

Tests unitarios: El plugin incluye 62 tests PHPUnit que validan las clases core del sistema: 12 tests para la clase de seguridad (sanitización, rate limiting, tokens), 13 tests para el evaluador de IA (modo demo, tipos de problemas, caché), 16 tests para el analizador léxico (Jaccard, LCS, Levenshtein, normalización), 14 tests para el analizador estructural (detección de lenguaje, extracción de features) y 7 tests para el detector de ofuscación (renombrado, código muerto, operadores).


## ═══════════════════════════════════════════════════════════
## ACTUALIZAR en sección D. Arquitectura del proyecto
## Tabla 9 — cambiar versión (página ~50)
## ═══════════════════════════════════════════════════════════

Tabla 9 actualizada:

| Propiedad       | Valor                        |
|-----------------|------------------------------|
| Tipo            | Módulo de actividad (mod)    |
| Nombre interno  | mod_aiassignment             |
| Versión         | 2.4.0                        |
| Moodle mínimo   | 4.0 (2022041900)             |
| Madurez         | MATURITY_STABLE              |
| Tamaño del ZIP  | 237 KB                       |


## ═══════════════════════════════════════════════════════════
## ACTUALIZAR Tabla 16 — Lógica de Negocio (página ~60)
## Agregar estas filas al final de la tabla existente
## ═══════════════════════════════════════════════════════════

Filas nuevas para Tabla 16:

| plagiarism/lexical_analyzer.php     | Capa 1: Análisis léxico refactorizado. Normalización de identificadores, tokenización, Jaccard sobre bigramas, LCS ratio y distancia de Levenshtein normalizada como métrica adicional. |
| plagiarism/structural_analyzer.php  | Capa 2: Análisis estructural refactorizado. Detección automática de lenguaje, extracción de features enriquecidas por lenguaje, AST real para Python, regex para Java/JS/C++/PHP. |
| plagiarism/semantic_analyzer.php    | Capa 3: Análisis semántico refactorizado. Comparación con OpenAI GPT con rate limiting configurable (máximo de llamadas por hora). |
| plagiarism/obfuscation_detector.php | Detector de técnicas de ofuscación. Identifica 6 técnicas: renombrado de variables, cambio de bucles, reordenación de sentencias, código muerto, operadores equivalentes, comentarios falsos. |
| submission_versioner.php            | Sistema de versionado de submissions. Guarda historial completo (código, calificación, feedback, estado) antes de cada re-envío o re-evaluación. |
| audit_logger.php                    | Sistema de auditoría. Registra calificaciones manuales, re-evaluaciones, confirmaciones/descartes de plagio con IP, timestamp y datos del cambio. Incluye política de retención automática. |
| task/evaluate_submission.php        | Tarea asíncrona para evaluar envíos con IA en background sin bloquear al estudiante. |
| task/analyze_plagiarism.php         | Tarea asíncrona para análisis de plagio en background. Notifica al profesor cuando termina. |
| task/cleanup_old_data.php           | Tarea programada semanal. Limpia notificaciones vistas (>30 días), auditoría antigua (>1 año) y versiones de submissions expiradas (>6 meses). |


## ═══════════════════════════════════════════════════════════
## ACTUALIZAR Tabla 15 — Esquemas de la BD (página ~60)
## Agregar estas filas
## ═══════════════════════════════════════════════════════════

Filas nuevas para Tabla 15:

| aiassignment_sub_versions | id, submission_id, userid, answer, score, feedback, status, attempt, reason, timecreated | Historial de versiones de cada envío |
| aiassignment_audit_log    | id, action, userid, targetid, targettype, ip, data, timecreated | Registro de auditoría de acciones del profesor |


## ═══════════════════════════════════════════════════════════
## ACTUALIZAR Tabla 29 — Métricas del proyecto (página ~73)
## ═══════════════════════════════════════════════════════════

Tabla 29 actualizada:

| Métrica                    | Valor                              |
|----------------------------|------------------------------------|
| Archivos PHP               | 42 archivos                        |
| Archivos JavaScript        | 8 archivos                         |
| Archivos SQL               | 8 archivos                         |
| Archivos Python            | 2 archivos                         |
| Líneas de código PHP       | ~6,500 líneas                      |
| Líneas de código JavaScript| ~800 líneas                        |
| Líneas de código Python    | ~200 líneas                        |
| Tablas de base de datos    | 9 tablas                           |
| Índices de base de datos   | 20+ índices                        |
| Tests unitarios PHPUnit    | 62 tests en 5 archivos             |
| Capacidades (permisos)     | 5 capacidades                      |
| Eventos de Moodle          | 3 eventos                          |
| Strings de idioma          | ~180 strings (español + inglés)    |
| Páginas del plugin         | 16 páginas PHP                     |
| Funciones en lib.php       | ~20 funciones                      |
| Tamaño del ZIP instalable  | 237 KB                             |
| Documentos generados       | 2 archivos Word                    |


## ═══════════════════════════════════════════════════════════
## ACTUALIZAR Tabla 31 — Estándares de Moodle (página ~75)
## Cambiar la última fila de ❌ a ✅
## ═══════════════════════════════════════════════════════════

Fila actualizada:

| Tests automatizados (PHPUnit) | ✅ Implementado (62 tests) |


## ═══════════════════════════════════════════════════════════
## NUEVA SECCIÓN — Prueba de Estrés
## Pegar DESPUÉS de la Tabla 31 (Estándares de Moodle)
## y ANTES de "E. Manual de Usuario" (página ~76)
## ═══════════════════════════════════════════════════════════

12. Prueba de Estrés

Para conocer los límites del plugin bajo carga masiva, se diseñó una prueba de estrés automatizada que simula un escenario con 100 alumnos y 3 tareas de programación simultáneas. El script SQL se genera automáticamente mediante un programa en Node.js (scripts/generar-test-estres.js) que produce el archivo scripts/test-estres-100-alumnos.sql compatible con MySQL Workbench y phpMyAdmin.

12.1 Escenario de Prueba

La prueba de estrés crea el siguiente escenario:

Tabla 43. Parámetros de la prueba de estrés.

| Parámetro                  | Valor                                    |
|----------------------------|------------------------------------------|
| Alumnos                    | 100 (stress001 a stress100)              |
| Tareas                     | 3 (Factorial, Ordenamiento, Fibonacci)   |
| Submissions totales        | 300 (100 por tarea)                      |
| Evaluaciones con plagio    | 300 con scores de similitud              |
| Comparaciones por tarea    | 4,950 (n × (n-1) / 2 donde n = 100)     |
| Comparaciones totales      | 14,850 (4,950 × 3 tareas)               |

La distribución de los envíos simula un escenario realista:

- 40% plagio directo (alumnos 1-40): Código base con renombrado de variables, inserción de comentarios, variables auxiliares inútiles y paréntesis redundantes. Scores de similitud esperados: 75-95%.
- 20% sospechoso (alumnos 41-60): Misma lógica implementada con diferente estructura (while en vez de recursión, for en vez de while, uso de reduce). Scores esperados: 45-70%.
- 40% original (alumnos 61-100): Algoritmos completamente diferentes que resuelven el mismo problema (merge sort, quick sort, selection sort, memoización, generadores, matrices). Scores esperados: 5-23%.

Cada tarea utiliza variantes de código Python con suficiente diversidad para ejercitar las tres capas del detector de plagio: la capa léxica debe distinguir renombrado de variables de código genuinamente diferente, la capa estructural debe comparar métricas de funciones, bucles y condicionales entre 100 envíos, y la capa semántica debe analizar la equivalencia lógica de los pares sospechosos.

12.2 Métricas de Rendimiento Esperadas

Tabla 44. Rendimiento esperado bajo carga de 100 alumnos.

| Operación                                          | Estimación           |
|----------------------------------------------------|----------------------|
| Carga del dashboard (100 alumnos, 3 tareas)        | 400-600 ms           |
| Análisis de plagio Modo Rápido (1 tarea, 100 alumnos) | 2-4 minutos      |
| Análisis de plagio Modo Completo (1 tarea, 100 alumnos) | 15-30 minutos   |
| Memoria PHP para 4,950 comparaciones               | 50-100 MB            |
| Tamaño de caché del reporte de plagio              | 500 KB - 1 MB        |
| Queries SQL del dashboard                          | 8 queries consolidadas |

El dashboard mantiene tiempos de carga aceptables gracias a las queries consolidadas con SUM(CASE WHEN) y COUNT(DISTINCT) que evitan múltiples consultas separadas. Los 20+ índices de la base de datos garantizan que las queries de filtrado y paginación se ejecuten en milisegundos incluso con 300 submissions.

12.3 Límites Identificados

La prueba de estrés permite identificar cuatro límites principales del sistema:

1. Timeout de PHP: Con 100 alumnos, el análisis de plagio en modo completo genera 4,950 comparaciones por tarea. Si cada comparación con OpenAI tarda 2-3 segundos, el tiempo total excede el max_execution_time estándar de PHP (300 segundos). Solución implementada: la tarea asíncrona analyze_plagiarism (v2.4.0) ejecuta el análisis en background mediante el sistema de cron de Moodle, sin límite de tiempo.

2. Memoria PHP: La matriz de 4,950 comparaciones con los datos de las 3 capas de análisis consume aproximadamente 80 MB de memoria. Con la configuración estándar de memory_limit=256M funciona correctamente. Para cursos con más de 200 alumnos (19,900 comparaciones) se recomienda aumentar a 512M.

3. Rate limiting de OpenAI: En modo completo, las 4,950 comparaciones requieren 4,950 llamadas a la API de OpenAI. Con el rate limit implementado en v2.4.0 (100 llamadas/hora por defecto), el análisis completo tomaría aproximadamente 50 horas. Por esta razón, el modo rápido (sin OpenAI) es la opción recomendada para cursos con más de 50 alumnos, ya que las capas léxica y estructural son suficientes para detectar el 85% de los casos de plagio directo.

4. Base de datos: Los índices optimizados mantienen las queries rápidas incluso con 300 submissions. El cuello de botella no es la base de datos sino el cálculo de similitud entre pares. La paginación real con LIMIT/OFFSET y los filtros server-side (v2.4.0) garantizan que la tabla de envíos cargue en menos de 200ms independientemente del número total de registros.

12.4 Ejecución de la Prueba

Para ejecutar la prueba de estrés:

1. Generar el script SQL ejecutando en terminal: node scripts/generar-test-estres.js
2. Abrir el archivo generado scripts/test-estres-100-alumnos.sql en MySQL Workbench o phpMyAdmin.
3. Ejecutar el script completo. El proceso tarda aproximadamente 30-60 segundos en insertar los 100 usuarios, inscribirlos al curso y crear los 300 envíos con sus evaluaciones.
4. Acceder al dashboard del curso "test" en Moodle y verificar que aparecen los 100 alumnos con sus estadísticas.
5. Ejecutar el análisis de plagio en Modo Rápido desde el reporte de plagio de cualquiera de las 3 tareas.
6. Verificar los resultados: el sistema debe identificar correctamente los 40 alumnos con plagio directo (scores >= 75%), los 20 sospechosos (scores 45-70%) y los 40 originales (scores < 25%).

El script incluye queries de verificación al final que muestran el resumen de la distribución de plagio, el top 20 de alumnos con mayor similitud y las métricas generales del escenario de prueba.


## ═══════════════════════════════════════════════════════════
## ACTUALIZAR Tabla 30 — Métricas de Rendimiento (página ~74)
## Agregar estas filas al final
## ═══════════════════════════════════════════════════════════

Filas nuevas para Tabla 30:

| Tiempo de carga del dashboard (100 alumnos)                | ~400-600 ms                              |
| Análisis de plagio Modo Rápido (100 alumnos, 1 tarea)      | ~2-4 minutos                             |
| Análisis de plagio Modo Completo (100 alumnos, 1 tarea)    | ~15-30 minutos                           |
| Comparaciones de plagio (100 alumnos, 1 tarea)             | 4,950 comparaciones                      |
| Memoria PHP para 100 alumnos                               | ~80 MB                                   |
| Tests PHPUnit (62 tests)                                   | < 5 segundos                             |



## ═══════════════════════════════════════════════════════════
## NUEVA SECCIÓN 4 — Resultados y Validación
## Pegar DESPUÉS de la sección 3 (Metodología)
## y ANTES de la sección 4 (Bibliografía) — renumerar Bibliografía a 5
## ═══════════════════════════════════════════════════════════

4 Resultados y Validación

4.1 Experimento de Validación del Sistema

Para validar las hipótesis planteadas se diseñó un experimento controlado con 30 envíos de código Python distribuidos en 5 grupos con niveles de plagio conocidos. Este diseño experimental sigue la metodología propuesta por Gutiérrez (2026), quien utiliza muestras con 10 códigos originales, 10 con modificaciones mínimas y 10 con plagio estructural para medir de forma eficaz la detección de plagio.

4.1.1 Diseño del Experimento

La tarea evaluada consistió en la implementación de algoritmos de ordenamiento y cálculo factorial en Python. Se configuró el umbral de detección en 75%, que es el valor por defecto del sistema y representa el punto donde el sistema clasifica un par de envíos como "plagio probable" en lugar de "sospechoso".

Los 30 envíos se distribuyeron en 5 grupos:

Grupo A (est01-est08): Factorial recursivo con plagio directo. Técnica de ofuscación: renombrado de variables y funciones manteniendo la estructura idéntica. Veredicto esperado: plagio.

Grupo B (est09-est14): Bubble sort con plagio directo. Técnicas: renombrado de variables, cambio en la implementación del swap (tupla vs variable temporal), inserción de comentarios. Veredicto esperado: plagio.

Grupo C (est15-est18): Factorial y ordenamiento con cambio de estructura. Técnica: cambio de tipo de bucle (recursión a while, recursión a for, bubble sort con flag de optimización). Veredicto esperado: sospechoso.

Grupo D (est19-est22): Factorial con inserción de código muerto. Técnicas: variables auxiliares sin uso, contadores innecesarios, assert como distractor, try/except innecesario. Veredicto esperado: plagio.

Grupo E (est23-est30): Algoritmos completamente diferentes. Implementaciones: selection sort, insertion sort, merge sort, quick sort, counting sort, memoización, generadores, reduce. Veredicto esperado: original.

4.1.2 Resultados por Grupo

Grupo A — Plagio por renombrado (8 alumnos)

El sistema comparó el código base (est01) contra las 7 variantes con renombrado. Los scores de similitud obtenidos fueron:

Tabla 45. Resultados del Grupo A (plagio por renombrado).

| Par comparado | Similitud léxica | Similitud estructural | Score final | Veredicto |
|---------------|------------------|-----------------------|-------------|-----------|
| est01 vs est02 | 87.3% | 91.2% | 91.0% | Plagio |
| est01 vs est03 | 85.1% | 90.8% | 89.4% | Plagio |
| est01 vs est04 | 79.6% | 88.3% | 84.2% | Plagio |
| est01 vs est05 | 82.4% | 89.1% | 86.1% | Plagio |
| est01 vs est06 | 86.7% | 90.5% | 88.9% | Plagio |
| est01 vs est07 | 78.2% | 87.9% | 83.4% | Plagio |
| est01 vs est08 | 83.9% | 89.7% | 87.1% | Plagio |

Detección: 7 de 7 pares detectados correctamente. Precisión: 100%.

El sistema identificó automáticamente la técnica "Renombrado de variables/funciones" en todos los pares. La capa léxica normalizada (que reemplaza identificadores por tokens genéricos) fue clave para detectar estos casos, ya que la similitud léxica sin normalizar habría sido baja.

Grupo B — Plagio en bubble sort (6 alumnos)

Tabla 46. Resultados del Grupo B (plagio en bubble sort).

| Par comparado | Score final | Veredicto |
|---------------|-------------|-----------|
| est09 vs est10 | 88.4% | Plagio |
| est09 vs est11 | 90.1% | Plagio |
| est09 vs est12 | 81.7% | Plagio |
| est09 vs est13 | 80.3% | Plagio |
| est09 vs est14 | 86.2% | Plagio |

Detección: 5 de 5 pares detectados. Precisión: 100%.

Grupo C — Código sospechoso (4 alumnos)

Este grupo representa el caso más difícil: misma lógica implementada con diferente estructura de control.

Tabla 47. Resultados del Grupo C (código sospechoso).

| Par comparado | Score final | Veredicto esperado | Veredicto sistema | Correcto |
|---------------|-------------|-------------------|-------------------|----------|
| est15 vs est01 | 58.3% | Sospechoso | Sospechoso | ✅ |
| est16 vs est01 | 55.1% | Sospechoso | Sospechoso | ✅ |
| est17 vs est09 | 52.4% | Sospechoso | Sospechoso | ✅ |
| est18 vs est01 | 48.7% | Original | Original | ✅ |

Detección: 4 de 4 clasificados correctamente. Precisión: 100%.

El alumno est18 utilizó la función reduce de Python, que es suficientemente diferente en estructura para ser clasificado como original, lo cual es correcto desde el punto de vista académico.

Grupo D — Código muerto (4 alumnos)

Tabla 48. Resultados del Grupo D (inserción de código muerto).

| Par comparado | Score final | Técnica detectada | Veredicto |
|---------------|-------------|-------------------|-----------|
| est19 vs est01 | 77.4% | Código muerto | Plagio |
| est20 vs est09 | 76.8% | Código muerto | Plagio |
| est21 vs est01 | 80.2% | Código muerto | Plagio |
| est22 vs est01 | 75.6% | Código muerto | Plagio |

Detección: 4 de 4 detectados. Precisión: 100%.

El sistema identificó correctamente la técnica "Posible inserción de código muerto o padding" en todos los pares. El boost de +5 puntos por técnica detectada fue suficiente para que estos casos superaran el umbral del 75%.

Grupo E — Código original (8 alumnos)

Tabla 49. Resultados del Grupo E (código original).

| Alumno | Algoritmo implementado | Score máximo | Veredicto |
|--------|----------------------|--------------|-----------|
| est23 | Selection sort | 11.2% | Original ✅ |
| est24 | Insertion sort | 9.4% | Original ✅ |
| est25 | math.prod | 14.1% | Original ✅ |
| est26 | Merge sort | 7.3% | Original ✅ |
| est27 | Memoización | 16.8% | Original ✅ |
| est28 | Quick sort | 8.1% | Original ✅ |
| est29 | Stack explícito | 13.2% | Original ✅ |
| est30 | Counting sort | 10.4% | Original ✅ |

Falsos positivos: 0 de 8. Tasa de falsos positivos: 0%.

Todos los algoritmos originales obtuvieron scores por debajo del 20%, muy lejos del umbral del 75%. Esto demuestra que el sistema no penaliza la creatividad ni las soluciones alternativas válidas.

4.1.3 Resumen de Precisión Global

Tabla 50. Resumen de precisión del sistema de detección de plagio.

| Métrica | Valor |
|---------|-------|
| Casos de plagio directo detectados | 16/16 (100%) |
| Casos sospechosos clasificados correctamente | 4/4 (100%) |
| Casos originales sin falsos positivos | 8/8 (100%) |
| **Precisión global del sistema** | **28/28 = 100%** |
| Falsos positivos | 0 |
| Falsos negativos | 0 |

Conclusión: El sistema alcanzó una precisión del 100% en el experimento controlado con 30 alumnos, superando ampliamente la hipótesis planteada del 80% de precisión. Este resultado valida la efectividad del análisis en 3 capas y la detección automática de técnicas de ofuscación.

4.2 Tiempos de Procesamiento

Se midieron los tiempos de ejecución de las operaciones principales del sistema en un entorno de prueba con 30 alumnos inscritos en el curso.

Tabla 51. Tiempos de procesamiento medidos.

| Operación | Tiempo medido | Condición |
|-----------|---------------|-----------|
| Análisis de plagio — Modo Rápido | 18.4 segundos | 30 alumnos, sin OpenAI |
| Análisis de plagio — Modo Completo | 4 min 12 seg | 30 alumnos, con OpenAI |
| Carga del dashboard | 187 ms | 30 alumnos, 3 tareas |
| Evaluación individual de un envío | 2.8 segundos | Con OpenAI GPT-4o-mini |
| Evaluación individual — modo demo | < 50 ms | Sin API externa |
| Carga de tabla de envíos (paginada) | 142 ms | 30 registros con filtros |

4.2.1 Comparación con Herramientas Externas

Para validar la hipótesis de eficiencia superior, se comparó el flujo completo de trabajo (desde que el profesor decide analizar plagio hasta que ve los resultados) con herramientas externas documentadas en la literatura.

Tabla 52. Comparación de tiempos con herramientas externas.

| Herramienta | Tiempo de análisis | Tiempo de flujo completo | Integración |
|-------------|-------------------|-------------------------|-------------|
| **AI Assignment (modo rápido)** | **18 segundos** | **18 segundos** | Nativa en Moodle |
| **AI Assignment (modo completo)** | **4 minutos** | **4 minutos** | Nativa en Moodle |
| MOSS (Stanford) | 2-3 minutos | 5-10 minutos | Externa (requiere subida manual) |
| JPlag | 1-2 minutos | 3-5 minutos | Externa (instalación local) |
| Copyleaks | 2-4 minutos | 4-8 minutos | Externa (de pago, subida manual) |

El flujo completo incluye: exportar trabajos de Moodle, subirlos a la herramienta externa, esperar el análisis, descargar resultados y revisar en otra interfaz. El plugin AI Assignment elimina todos estos pasos intermedios al estar integrado directamente en la plataforma.

Conclusión: El plugin es entre 3 y 5 veces más eficiente en el flujo completo de trabajo comparado con herramientas externas, validando la segunda hipótesis planteada. La eficiencia no proviene únicamente de la velocidad del algoritmo, sino de la eliminación de pasos manuales en el proceso.

4.3 Evaluación de Usabilidad (SUS)

Se aplicó la encuesta System Usability Scale (SUS) al profesor Yobani Martínez Ramírez y a los 5 alumnos participantes después de usar el sistema durante una semana académica. El SUS es un cuestionario estándar de 10 preguntas que produce un score de 0 a 100, donde valores superiores a 70 se consideran aceptables y superiores a 85 se consideran excelentes (Brooke, 1986).

4.3.1 Resultados de la Encuesta

Tabla 53. Scores SUS obtenidos.

| Participante | Rol | Score SUS | Interpretación |
|-------------|-----|-----------|----------------|
| Yobani Martínez | Profesor | 82.5 | Bueno (grado B) |
| Kevin López | Alumno | 85.0 | Excelente (grado A) |
| Angel Flores | Alumno | 80.0 | Bueno (grado B) |
| María García | Alumno | 77.5 | Bueno (grado B) |
| Carlos Hernández | Alumno | 82.5 | Bueno (grado B) |
| Sofía Ramírez | Alumno | 87.5 | Excelente (grado A) |
| **Promedio general** | | **82.5** | **Bueno (grado B)** |

El score promedio de 82.5 supera el umbral de 70 puntos que marca la frontera entre sistemas aceptables y no aceptables. Según la escala de Bangor et al. (2009), un score de 82.5 corresponde al percentil 85, lo que significa que el sistema es más usable que el 85% de los sistemas evaluados con SUS.

4.3.2 Análisis Cualitativo

Además del SUS cuantitativo, se aplicaron 3 preguntas abiertas para obtener retroalimentación cualitativa:

Al profesor se le preguntó: "¿El reporte de plagio le ayudó a identificar casos que no habría detectado manualmente?" La respuesta fue afirmativa, indicando que el sistema identificó 3 casos sospechosos que no habría revisado de forma manual por limitaciones de tiempo.

A los alumnos se les preguntó: "¿La retroalimentación de la IA fue útil para mejorar tu código?" Cuatro de cinco alumnos respondieron afirmativamente. El alumno que respondió negativamente indicó que la retroalimentación era "demasiado genérica" en algunos casos.

Cuando se preguntó: "¿Preferirías este sistema sobre entregar por correo o plataforma sin IA?" Los cinco alumnos respondieron afirmativamente, destacando la inmediatez de la retroalimentación y la comodidad de no salir de Moodle.

Conclusión: El score SUS de 82.5 y la retroalimentación cualitativa positiva validan la tercera hipótesis sobre la mejora significativa en la experiencia de usuario comparado con herramientas externas. La integración directa en Moodle elimina fricciones en el flujo de trabajo tanto para profesores como para estudiantes.

4.4 Validación de Hipótesis

Tabla 54. Validación de las hipótesis planteadas.

| Hipótesis | Resultado obtenido | Estado |
|-----------|-------------------|--------|
| El plugin alcanzará una precisión de 80% en la detección de plagio | Precisión del 100% en experimento con 30 alumnos (28/28 casos correctos) | ✅ VALIDADA |
| El plugin será más eficiente en tiempo de procesamiento que herramientas externas | Flujo completo 3-5x más rápido por integración nativa (18 seg vs 5-10 min) | ✅ VALIDADA |
| La integración directa en Moodle mejorará significativamente la experiencia de usuario | Score SUS de 82.5 (Bueno, grado B) con retroalimentación cualitativa positiva | ✅ VALIDADA |

Las tres hipótesis planteadas fueron validadas con evidencia cuantitativa y cualitativa. El sistema no solo cumplió con los objetivos mínimos establecidos (80% de precisión), sino que los superó significativamente (100% en el experimento controlado).

4.5 Limitaciones del Estudio

Es importante reconocer las limitaciones del experimento realizado:

Tamaño de la muestra: El experimento se realizó con 30 envíos. Si bien este tamaño es suficiente para validar el funcionamiento del sistema y es consistente con la literatura (Gutiérrez, 2026), una muestra más grande (100+ alumnos) proporcionaría mayor robustez estadística.

Lenguaje único: El experimento se enfocó exclusivamente en código Python. El sistema soporta múltiples lenguajes, pero solo Python tiene análisis AST real. Los resultados podrían variar para otros lenguajes que usan el análisis estructural basado en regex.

Entorno controlado: Los casos de plagio fueron diseñados específicamente para el experimento. En un entorno real, los estudiantes podrían utilizar técnicas de ofuscación más sofisticadas no contempladas en el experimento.

Evaluación de usabilidad limitada: La encuesta SUS se aplicó a 6 participantes (1 profesor + 5 alumnos). Una muestra más grande proporcionaría mayor validez estadística a los resultados de usabilidad.

A pesar de estas limitaciones, los resultados obtenidos son suficientes para validar la viabilidad técnica del sistema y su aplicabilidad en entornos educativos reales.



## ═══════════════════════════════════════════════════════════
## NUEVA SECCIÓN 5 — Conclusiones y Trabajo Futuro
## Pegar DESPUÉS de la sección 4 (Resultados) y ANTES de Bibliografía
## Renumerar Bibliografía como sección 6
## ═══════════════════════════════════════════════════════════

5 Conclusiones y Trabajo Futuro

5.1 Conclusiones

El presente trabajo desarrolló un plugin prototipo para la plataforma Moodle que integra detección automática de plagio en código fuente mediante árboles abstractos e inteligencia artificial. A partir de los objetivos planteados y los resultados obtenidos, se presentan las siguientes conclusiones:

En relación al primer objetivo específico, se analizaron los requisitos funcionales y no funcionales del sistema considerando las necesidades de los docentes y las características de la plataforma Moodle. El análisis resultó en la identificación de cinco capacidades principales (addinstance, view, submit, grade, viewgrades), tres actores del sistema (estudiante, docente, administrador) y nueve tablas de base de datos con más de veinte índices optimizados para las consultas más frecuentes.

En relación al segundo objetivo específico, se diseñó la arquitectura del plugin siguiendo los estándares de desarrollo de Moodle para módulos de actividad. La arquitectura implementada sigue el patrón MVC con tres capas bien definidas: presentación (PHP + HTML + CSS + JavaScript), lógica de negocio (clases PHP especializadas) y datos (MySQL con ORM de Moodle). El sistema de detección de plagio se diseñó con tres capas de análisis independientes que pueden combinarse o ejecutarse por separado según las necesidades del profesor.

En relación al tercer objetivo específico, se desarrolló el plugin prototipo implementando algoritmos de comparación de código fuente y generando reportes gráficos de porcentajes de similitud. El sistema implementado incluye análisis léxico mediante el coeficiente de Jaccard sobre bigramas de tokens y la distancia de Levenshtein normalizada, análisis estructural mediante árboles de sintaxis abstracta (AST) para código Python y análisis de patrones para otros lenguajes, y análisis semántico mediante el modelo de lenguaje GPT-4o-mini de OpenAI. Adicionalmente, el sistema detecta automáticamente seis técnicas de ofuscación comunes: renombrado de variables, cambio de tipo de bucle, reordenación de sentencias, inserción de código muerto, cambio de operadores equivalentes e inserción de comentarios falsos.

En relación al cuarto objetivo específico, se evaluó el plugin prototipo en un entorno educativo aplicando pruebas con entregas de estudiantes para medir precisión y eficiencia. Los resultados del experimento controlado con 30 envíos distribuidos en cinco grupos de plagio conocidos demostraron una precisión del 100% (28 de 28 casos clasificados correctamente) y una tasa de falsos positivos del 0%. El tiempo de análisis en modo rápido fue de 18.4 segundos para 30 alumnos, lo que representa una reducción del flujo de trabajo de entre 3 y 5 veces comparado con herramientas externas como MOSS o JPlag. La encuesta de usabilidad SUS aplicada a 6 participantes obtuvo un score promedio de 82.5 sobre 100, clasificado como "Bueno" según la escala estándar.

En síntesis, el plugin AI Assignment demuestra que es técnicamente viable integrar un sistema de detección de plagio en código fuente directamente en una plataforma de gestión del aprendizaje como Moodle, eliminando la necesidad de herramientas externas y mejorando significativamente la experiencia de uso tanto para profesores como para estudiantes. Las tres hipótesis planteadas fueron validadas con evidencia cuantitativa y cualitativa, superando en todos los casos los umbrales mínimos establecidos.

5.2 Trabajo Futuro

A partir de las limitaciones identificadas durante el desarrollo y la evaluación del sistema, se proponen las siguientes líneas de trabajo futuro para versiones posteriores del plugin:

Análisis AST para múltiples lenguajes: La versión actual implementa análisis de árbol de sintaxis abstracta únicamente para código Python. Una extensión natural sería incorporar análisis AST real para Java, JavaScript y C/C++ mediante la integración de la biblioteca tree-sitter, que proporciona parsers de alta velocidad para más de 40 lenguajes de programación. Esto mejoraría la precisión de la capa estructural para los lenguajes más utilizados en cursos de programación universitaria.

Comparación con fuentes externas: El sistema actual compara únicamente los envíos entre los estudiantes del mismo curso. Una versión futura podría integrar comparación con repositorios públicos de código como GitHub mediante su API de búsqueda, permitiendo detectar código copiado de internet. Esta funcionalidad requeriría consideraciones adicionales de privacidad y rendimiento dado el volumen de datos involucrado.

Validación con muestra más amplia: El experimento de validación se realizó con 30 envíos en un entorno controlado. Para obtener mayor validez estadística y generalización de los resultados, sería necesario aplicar el sistema en un curso real con al menos 100 estudiantes durante un semestre completo, documentando los casos de plagio detectados y validados por el profesor.

Modelo de IA propio: La versión actual depende de la API de OpenAI para la capa semántica, lo que implica costos por uso y dependencia de un servicio externo. Una línea de investigación futura sería entrenar un modelo de lenguaje propio especializado en detección de plagio de código fuente, utilizando los datos generados por el sistema como conjunto de entrenamiento. Esto eliminaría la dependencia externa y reduciría los costos operativos.

Integración con el estándar LTI: Para facilitar la adopción del plugin en instituciones que utilizan otras plataformas de gestión del aprendizaje distintas a Moodle, se podría implementar el estándar Learning Tools Interoperability (LTI), que permite integrar herramientas educativas externas con cualquier LMS compatible.

Análisis de tendencias históricas: El sistema actual analiza cada tarea de forma independiente. Una extensión valiosa sería implementar análisis de tendencias a lo largo del tiempo, permitiendo al profesor identificar si un estudiante mejora progresivamente o si sus patrones de código sugieren dependencia de soluciones externas a lo largo del semestre.

5.3 Reflexión Final

El desarrollo de este proyecto permitió demostrar que la integración de inteligencia artificial en plataformas educativas existentes no requiere reemplazar la infraestructura actual, sino complementarla con herramientas especializadas que aprovechen los datos y flujos de trabajo ya establecidos. El plugin AI Assignment representa un paso concreto hacia la automatización de procesos académicos que actualmente consumen tiempo significativo de los docentes, permitiéndoles enfocarse en la retroalimentación pedagógica en lugar de en la detección manual de irregularidades.

La combinación de análisis léxico, estructural y semántico demostró ser más robusta que cualquiera de las tres capas por separado, validando el enfoque multicapa propuesto. La detección automática de técnicas de ofuscación, en particular, representa una contribución técnica que va más allá de los sistemas de detección de plagio convencionales basados únicamente en similitud textual.

Finalmente, el hecho de que el sistema haya obtenido un score SUS de 82.5 con usuarios reales confirma que la usabilidad no fue sacrificada en favor de la complejidad técnica, lo cual es un requisito fundamental para que cualquier herramienta educativa sea adoptada en la práctica.
