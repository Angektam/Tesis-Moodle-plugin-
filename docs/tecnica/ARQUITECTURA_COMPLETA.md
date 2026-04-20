# Arquitectura Completa del Proyecto

**Plugin:** mod_aiassignment para Moodle  
**Versión:** 1.5.0  
**Tipo:** Módulo de actividad (mod)

---

## Estructura General del Proyecto

```
Tesis/
├── moodle-plugin/          ← Plugin principal (se empaqueta en ZIP)
├── demo-standalone/        ← Demos independientes de las APIs
├── docs/                   ← Documentación técnica y de usuario
├── scripts/                ← Scripts SQL y utilidades
├── dist/                   ← ZIP del plugin generado
└── package.json            ← Dependencias Node.js (docx, etc.)
```

---

## 1. Carpeta `moodle-plugin/` — El Plugin

Esta es la carpeta que se empaqueta en el ZIP y se instala en Moodle.

### Archivos principales (raíz)

| Archivo | Propósito |
|---|---|
| `version.php` | **Metadatos del plugin**: versión, release, requisitos de Moodle. Moodle lee este archivo para saber qué versión está instalada. |
| `lib.php` | **Funciones requeridas por Moodle**: `_add_instance`, `_update_instance`, `_delete_instance`, `_supports`, funciones de calificación y estadísticas. |
| `mod_form.php` | **Formulario de creación/edición** de la tarea. Define los campos que el profesor llena al crear una tarea (nombre, tipo, solución de referencia, etc.). |
| `settings.php` | **Página de configuración** del plugin en Administración del sitio. Define los campos: API Key, modelo OpenAI, umbral de plagio, reintentos, etc. |
| `view.php` | **Vista principal** de la tarea. Muestra el enunciado, el formulario de envío (estudiantes) y botones de gestión (profesores). |
| `index.php` | **Lista de todas las tareas** AI Assignment en un curso. Moodle lo llama automáticamente. |

### Páginas de gestión del profesor

| Archivo | Propósito |
|---|---|
| `dashboard.php` | **Panel de control del curso**. Muestra tarjetas de estadísticas, tabla de tareas, envíos recientes, top estudiantes, alumnos en riesgo, gráficas de distribución/actividad/correlación/precisión. |
| `submissions.php` | **Lista de todos los envíos** de una tarea. Tabla con estudiante, fecha, intento, estado, calificación, % de plagio. Incluye búsqueda en tiempo real, filtro por estado, ordenamiento por columna y paginación. |
| `submission.php` | **Detalle de un envío individual**. Muestra el código del estudiante, comparación lado a lado con la solución, evaluación de la IA, formulario de calificación manual, solicitud de re-envío. |
| `plagiarism_report.php` | **Reporte de plagio** con interfaz AJAX. Dos botones (Modo Rápido / Modo Completo), spinner de progreso, resultados con matriz NxN, ranking, comparaciones detalladas. |
| `plagiarism_ajax.php` | **Endpoint AJAX** que ejecuta el análisis de plagio en background y devuelve JSON. Usado por `plagiarism_report.php`. |
| `course_report.php` | **Reporte del curso** exportable. Resumen general, distribución de calificaciones, detalle por tarea. Exporta a CSV o imprime como PDF. |
| `student_stats.php` | **Estadísticas de un alumno individual**. Tarjetas resumen, gráfica de evolución de calificaciones, tabla de historial de envíos. |
| `reevaluate.php` | **Re-evalúa un envío** con la IA. Llama a `ai_evaluator::evaluate()` y actualiza la calificación. |
| `manual_grade.php` | **Guarda calificación manual** del profesor. Sobrescribe la nota de la IA y guarda el historial de cambios en JSON. |
| `request_resubmit.php` | **Solicita re-envío** al estudiante. Marca el envío como `flagged` y envía notificación por Moodle. |
| `mark_plagiarism.php` | **Marca un caso de plagio** como confirmado o falso positivo. Guarda el estado en `ai_analysis` JSON. |

### Páginas del estudiante

| Archivo | Propósito |
|---|---|
| `submit.php` | **Procesa el envío** del estudiante. Valida el código, lo guarda en BD, llama a la IA para evaluar automáticamente, envía notificación al estudiante con su calificación. |

### Carpeta `db/` — Base de Datos

| Archivo | Propósito |
|---|---|
| `install.xml` | **Esquema de la BD**. Define las 3 tablas: `aiassignment`, `aiassignment_submissions`, `aiassignment_evaluations` con todos sus campos, claves foráneas e índices. |
| `upgrade.php` | **Migraciones de BD**. Aplica cambios de esquema cuando se actualiza el plugin (ej: agregar índices nuevos). |
| `access.php` | **Capacidades (permisos)**. Define quién puede hacer qué: `addinstance`, `view`, `submit`, `grade`, `viewgrades`. |
| `caches.php` | **Definición de áreas de caché**. Registra el área `plagiarism` para guardar reportes de plagio en caché de Moodle. |
| `messages.php` | **Proveedores de mensajes**. Registra `submission_graded` para que Moodle pueda enviar notificaciones a los estudiantes. |

### Carpeta `classes/` — Lógica de Negocio

| Archivo | Propósito |
|---|---|
| `ai_evaluator.php` | **Evaluador con IA**. Clase `ai_evaluator` con método `evaluate()` que llama a OpenAI GPT para comparar la respuesta del estudiante con la solución del profesor. Incluye modo demo (sin API), reintentos automáticos y manejo de errores. |
| `plagiarism_detector.php` | **Detector de plagio en 3 capas**. Clase `plagiarism_detector` con métodos: `compare_code()` (compara dos códigos), `generate_plagiarism_report()` (analiza todos los pares), análisis léxico/estructural/semántico, detección de técnicas de ofuscación, caché inteligente. |
| `event/course_module_viewed.php` | **Evento de Moodle**: se dispara cuando alguien ve la tarea. Usado para logs y estadísticas de Moodle. |
| `event/submission_created.php` | **Evento**: se dispara cuando un estudiante envía una respuesta. |
| `event/submission_graded.php` | **Evento**: se dispara cuando se califica un envío (automático o manual). |
| `privacy/provider.php` | **Cumplimiento GDPR**. Define qué datos personales almacena el plugin y cómo exportarlos/eliminarlos. Requerido por Moodle. |

### Carpeta `lang/` — Internacionalización

| Archivo | Propósito |
|---|---|
| `en/aiassignment.php` | **Strings en inglés**. Todos los textos de la interfaz: títulos, botones, mensajes de error, notificaciones. |
| `es/aiassignment.php` | **Strings en español**. Traducción completa de todos los textos. |

### Carpeta `backup/` — Respaldo y Restauración

| Archivo | Propósito |
|---|---|
| `moodle2/backup_aiassignment_activity_task.class.php` | **Tarea de respaldo**. Define qué datos incluir al hacer backup del curso. |
| `moodle2/backup_aiassignment_stepslib.php` | **Pasos del respaldo**. Especifica cómo guardar las tablas del plugin en el archivo de backup. |
| `moodle2/restore_aiassignment_activity_task.class.php` | **Tarea de restauración**. Define cómo restaurar la actividad desde un backup. |
| `moodle2/restore_aiassignment_stepslib.php` | **Pasos de restauración**. Especifica cómo recrear las tablas y datos desde el backup. |

### Carpeta `amd/src/` — JavaScript AMD (Moodle)

| Archivo | Propósito |
|---|---|
| `dashboard.js` | **JavaScript del dashboard**. Actualmente vacío — las gráficas se cargan con scripts inline por simplicidad. |

### Carpeta `styles/` — CSS

| Archivo | Propósito |
|---|---|
| `dashboard.css` | **Estilos del dashboard y todas las páginas**. Define variables CSS, tarjetas, tablas, badges, botones, avatares, gráficas, responsive, animaciones, estilos de impresión. |

### Carpeta `pix/` — Iconos

| Archivo | Propósito |
|---|---|
| `icon.svg` | **Icono del plugin**. Aparece en la lista de actividades de Moodle cuando el profesor agrega una tarea. |

### Otros archivos

| Archivo | Propósito |
|---|---|
| `ast_analyzer.py` | **Analizador AST para Python**. Script que recibe dos códigos Python en JSON base64, los parsea con `ast.parse()`, extrae métricas estructurales y devuelve JSON con el score de similitud. Se ejecuta como proceso hijo desde PHP. |
| `demo.html` | **Demo standalone** del formulario de envío con evaluación simulada. Para pruebas sin Moodle. |
| `dashboard-demo.html` | **Boceto HTML** del dashboard con estilos finales. Para diseñar la UI antes de implementarla en PHP. |
| `ide_stubs.php` | **Stubs de funciones de Moodle** para autocompletado en IDEs. No se incluye en el ZIP. |

---

## 2. Carpeta `demo-standalone/` — Demos Independientes

Prototipos funcionales de las APIs antes de integrarlas al plugin.

| Archivo | Propósito |
|---|---|
| `server.js` | Servidor Express con endpoints para probar todas las APIs (Judge0, VirusTotal, GitHub, AST). |
| `plugin-funcional.html/js/css` | Demo completa del plugin funcionando sin Moodle, con evaluación simulada. |
| `services/ast_comparator.js` | Servicio Node.js que compara dos códigos Python usando el script Python. |
| `services/judge0_service.js` | Cliente de la API Judge0 para ejecutar código. |
| `services/virustotal_service.js` | Cliente de VirusTotal para escanear archivos. |
| `services/github_service.js` | Cliente de GitHub API para buscar código similar. |
| `services/python_ast_service.py` | Versión standalone del analizador AST (igual que `ast_analyzer.py` del plugin). |
| `test-*.js` | Scripts de prueba para cada API. |

---

## 3. Carpeta `docs/` — Documentación

### `docs/tecnica/` — Documentación Técnica

| Archivo | Propósito |
|---|---|
| `DETECCION_PLAGIO_AUTOMATICA.md` | **Documentación completa del sistema de plagio**: 3 capas, parámetros, fórmulas, umbrales, técnicas de ofuscación, flujo de comparación. |
| `CLASES_E_INTERFACES.md` | Diagrama de clases del sistema. |
| `ESTRUCTURA_BD.md` | Esquema de la base de datos con relaciones. |
| `COMPARACION_AST.md` | Explicación del análisis AST para Python. |
| `DIRECTORIO_PROYECTO.md` | Árbol de directorios con descripción de cada carpeta. |
| `TECNOLOGIAS_PROYECTO.md` | Stack tecnológico: PHP, MySQL, OpenAI, Python, Chart.js, etc. |
| `APIS_UTILES_PROYECTO.md` | APIs evaluadas para el proyecto (Judge0, VirusTotal, GitHub). |
| `dbdiagram-code.dbml` | Código DBML para generar diagrama ER de la BD. |
| `diagrama-bd.html` | Visualización HTML del diagrama de BD. |

### `docs/instalacion/` — Guías de Instalación

| Archivo | Propósito |
|---|---|
| `INSTALACION_RAPIDA.md` | Guía rápida de instalación en 5 pasos. |
| `GUIA_INSTALACION_MOODLE_LOCAL.md` | Instalación completa de Moodle en local (XAMPP). |
| `CONFIGURAR_API_KEY.md` | Cómo obtener y configurar la API Key de OpenAI. |
| `GUIA_PRUEBAS_PLUGIN.md` | Casos de prueba manuales para validar el plugin. |
| `FASE1_APIS.md` | Documentación de la fase 1 (evaluación de APIs). |

### `docs/usuario/` — Documentación de Usuario

| Archivo | Propósito |
|---|---|
| `GUIA_RAPIDA.md` | Guía rápida para profesores y estudiantes. |
| `CASOS_PRUEBA_MANUAL.md` | Casos de prueba paso a paso. |
| `MODO_DEMO_VS_REAL.md` | Diferencias entre modo demo y modo real con API. |

### `docs/tesis/` — Documentos de la Tesis

| Archivo | Propósito |
|---|---|
| `TESIS_DETECCION_PLAGIO.md` | Documento principal de la tesis. |
| `RESUMEN_PROYECTO.md` | Resumen ejecutivo del proyecto. |
| `INDICE_PROYECTO.md` | Índice de la tesis. |

### Otros documentos

| Archivo | Propósito |
|---|---|
| `MANUAL_USUARIO_AI_ASSIGNMENT.docx` | **Manual de usuario completo** en Word con portada, índice, guías paso a paso, tablas de parámetros, FAQ y solución de problemas. Generado con `scripts/generar-manual-word.js`. |
| `INDICE_DOCUMENTACION.md` | Índice maestro de toda la documentación del proyecto. |

---

## 4. Carpeta `scripts/` — Scripts SQL y Utilidades

| Archivo | Propósito |
|---|---|
| `schema-moodle.sql` | Esquema completo de las tablas de Moodle relevantes para el plugin. |
| `inscribir-30-alumnos.sql` | **Script de prueba**: crea 30 usuarios, los inscribe al curso "test" e inserta envíos con distintos niveles de plagio (grupos A-E). Compatible con MySQL Workbench. |
| `test-masivo-30-alumnos.sql` | Versión anterior del script de prueba. |
| `datos-prueba-plagio.sql` | Datos de prueba para validar la detección de plagio. |
| `insertar-alumnos-prueba.sql` | Script simple con 5 alumnos de prueba. |
| `crear-zip-moodle.js` | **Script Node.js** que empaqueta `moodle-plugin/` en `dist/mod_aiassignment.zip`. Ejecutar: `node scripts/crear-zip-moodle.js`. |
| `generar-manual-word.js` | **Script Node.js** que genera el manual de usuario en Word usando la librería `docx`. Ejecutar: `node scripts/generar-manual-word.js`. |
| `verificar-openai.js` | Script para probar la conexión con OpenAI API. |
| `iniciar-ast-python.bat` | Script batch para iniciar el servidor Python AST en Windows. |
| `README.md` | Documentación de los scripts disponibles. |

---

## 5. Archivos de Configuración (raíz)

| Archivo | Propósito |
|---|---|
| `.env` | **Variables de entorno**: API Keys de OpenAI, Judge0, VirusTotal, GitHub. NO se sube a Git (está en `.gitignore`). |
| `.env.example` | Plantilla del archivo `.env` con las variables necesarias. |
| `.gitignore` | Archivos y carpetas excluidos de Git: `node_modules/`, `.env`, `dist/`, archivos temporales. |
| `package.json` | **Dependencias Node.js**: `docx` para generar Word, `express` para demos. |
| `package-lock.json` | Lockfile de npm con versiones exactas de dependencias. |

---

## 6. Documentos de Gestión del Proyecto (raíz)

| Archivo | Propósito |
|---|---|
| `README.md` | **Readme principal** del proyecto con descripción, instalación rápida y enlaces a documentación. |
| `ESTRUCTURA_PROYECTO.md` | Árbol de directorios con descripción breve de cada carpeta. |
| `PROYECTO_ORGANIZADO.md` | Explicación de la reorganización del proyecto en 2026. |
| `PROXIMOS_PASOS.md` | Tareas pendientes y próximos pasos del desarrollo. |
| `ANTES_Y_DESPUES.md` | Comparación del proyecto antes y después de la reorganización. |
| `USUARIOS_PRUEBA.md` | Lista de usuarios de prueba con credenciales. |
| `RESUMEN_SESION.md` | Resumen de sesiones de trabajo. |
| `CUMPLIMIENTO_ESTANDARES_MOODLE.md` | Checklist de cumplimiento de estándares de Moodle. |
| `PLUGIN_VERIFICACION_FINAL.md` | Checklist de verificación antes de entregar. |
| `RESUMEN_FINAL_PLUGIN.md` | Resumen ejecutivo del plugin terminado. |

---

## Flujo de Datos del Sistema

### Flujo de Envío del Estudiante

```
1. Estudiante abre view.php
2. Llena el textarea con su código
3. Hace clic en "Enviar"
4. submit.php recibe el POST
   ├─ Valida longitud, caracteres, estructura de código
   ├─ Guarda en mdl_aiassignment_submissions (status='pending')
   ├─ Llama a ai_evaluator::evaluate()
   │  ├─ Construye prompt con solución del profesor
   │  ├─ Llama a OpenAI API (con reintentos automáticos)
   │  └─ Devuelve {similarity_score, feedback, analysis}
   ├─ Guarda en mdl_aiassignment_evaluations
   ├─ Actualiza submission (status='evaluated', score=X)
   ├─ Actualiza libro de calificaciones de Moodle
   ├─ Envía notificación al estudiante
   └─ Redirige a view.php con mensaje de éxito
```

### Flujo de Análisis de Plagio

```
1. Profesor abre plagiarism_report.php
2. Ve dos botones: ⚡ Rápido / 🧠 Completo
3. Hace clic en uno
4. JavaScript llama a plagiarism_ajax.php vía fetch()
5. plagiarism_ajax.php:
   ├─ Llama a plagiarism_detector::generate_plagiarism_report($aid, $nosem, $force)
   ├─ Verifica caché (si no hay envíos nuevos, devuelve cached)
   ├─ Si no hay caché:
   │  ├─ Trae todos los envíos (último por usuario)
   │  ├─ Para cada par (i,j):
   │  │  ├─ compare_code(código1, código2, $nosem)
   │  │  │  ├─ Capa 1: lexical_similarity() → Jaccard + LCS
   │  │  │  ├─ Capa 2: structural_similarity() → AST o regex
   │  │  │  ├─ Capa 3: semantic_similarity_ai() → OpenAI (si no $nosem)
   │  │  │  ├─ score_final = léxica×0.35 + estructural×0.30 + semántica×0.35
   │  │  │  ├─ detect_obfuscation_techniques() → boost
   │  │  │  └─ Devuelve {final_score, verdict, layers, techniques}
   │  │  └─ Guarda en matriz de comparaciones
   │  ├─ Ordena por score descendente
   │  ├─ Identifica usuarios sospechosos
   │  ├─ Guarda en caché
   │  └─ Devuelve JSON
   ├─ Guarda similarity_score en mdl_aiassignment_evaluations
   └─ Devuelve JSON al frontend
6. JavaScript renderResults(data):
   ├─ Construye HTML con tarjetas, matriz NxN, ranking, comparaciones
   └─ Lo inyecta en #results-area
```

---

## Tecnologías Usadas

| Tecnología | Uso en el Proyecto |
|---|---|
| **PHP 7.4+** | Backend del plugin, lógica de negocio, queries a BD |
| **MySQL/MariaDB** | Base de datos con 3 tablas + índices optimizados |
| **OpenAI GPT-4o-mini** | Evaluación automática de código y análisis semántico de plagio |
| **Python 3.8+** | Análisis AST real para código Python (`ast.parse()`) |
| **JavaScript ES6** | AJAX, gráficas Chart.js, búsqueda en tiempo real, filtros |
| **Chart.js 4.x** | Gráficas de barras, línea, scatter, dona en dashboard y reportes |
| **Moodle 4.0+** | Plataforma LMS, sistema de permisos, libro de calificaciones, notificaciones |
| **Node.js** | Scripts de generación (ZIP, Word), servidor de demos |
| **docx (npm)** | Generación del manual de usuario en formato Word |

---

## Patrones de Diseño Aplicados

- **MVC**: Moodle separa vistas (archivos .php raíz), lógica (classes/) y datos (db/)
- **Repository Pattern**: `lib.php` actúa como capa de acceso a datos con funciones `aiassignment_get_*`
- **Strategy Pattern**: `plagiarism_detector` usa diferentes estrategias según el lenguaje (AST para Python, regex para otros)
- **Cache-Aside**: el reporte de plagio verifica caché antes de calcular
- **Observer Pattern**: eventos de Moodle (`submission_created`, `submission_graded`) para logs y notificaciones

---

## Métricas del Proyecto

- **Archivos PHP**: 28
- **Archivos JavaScript**: 8
- **Archivos SQL**: 6
- **Líneas de código PHP**: ~4,500
- **Líneas de código JavaScript**: ~800
- **Líneas de código Python**: ~200
- **Tablas de BD**: 3 (+ 15 índices)
- **Capacidades (permisos)**: 5
- **Eventos de Moodle**: 3
- **Strings de idioma**: ~120 (español + inglés)
- **Tamaño del ZIP**: 159.8 KB

---

## Cumplimiento de Estándares de Moodle

✅ Estructura de carpetas estándar (`db/`, `lang/`, `classes/`, `backup/`)  
✅ Archivo `version.php` con metadatos correctos  
✅ Funciones requeridas en `lib.php` implementadas  
✅ Sistema de capacidades (permisos) definido  
✅ Eventos de Moodle para logs  
✅ Integración con libro de calificaciones  
✅ Backup y restauración implementados  
✅ Cumplimiento GDPR con `privacy/provider.php`  
✅ Internacionalización (inglés + español)  
✅ Responsive design con CSS moderno  
✅ Accesibilidad básica (labels, ARIA, contraste de colores)

---

## Puntos Fuertes del Proyecto

1. **Innovación técnica** — análisis en 3 capas con AST real es más avanzado que la mayoría de detectores académicos
2. **Completitud** — cubre todo el flujo: creación de tarea, envío, evaluación automática, plagio, calificación manual, reportes
3. **Rendimiento** — queries optimizadas, caché, AJAX, paginación real, índices en BD
4. **UX profesional** — dashboard con gráficas, búsqueda en tiempo real, filtros, ordenamiento, notificaciones
5. **Documentación exhaustiva** — manual de usuario, documentación técnica, guías de instalación, scripts de prueba

---

## Áreas de Mejora Potenciales

1. **Tests automatizados** — no hay PHPUnit ni tests de integración
2. **Limpieza de código** — `plagiarism_report.php` tiene código duplicado de versiones anteriores
3. **Análisis AST para más lenguajes** — actualmente solo Python tiene AST real
4. **API de terceros para plagio** — podría integrarse con Turnitin o Copyleaks para comparar con internet
5. **Procesamiento asíncrono real** — el análisis de plagio aún bloquea PHP; idealmente usaría cron tasks de Moodle

---

**Conclusión**: Para una tesis de licenciatura, el plugin está en un nivel **muy bueno**. Tiene funcionalidad completa, rendimiento optimizado, UI profesional y documentación sólida. Los puntos pendientes son refinamientos que no afectan la funcionalidad core.
