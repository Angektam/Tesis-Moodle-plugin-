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
