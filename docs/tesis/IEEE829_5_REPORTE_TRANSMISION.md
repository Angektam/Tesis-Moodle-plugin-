# IEEE 829 — Documento 5: Reporte de Transmisión de Elementos de Prueba
## Plugin mod_aiassignment para Moodle 4.0+

---

**Identificador del documento:** RTE-AIASSIGNMENT-2026-005  
**Versión:** 1.0  
**Fecha:** Mayo 2026  
**Estado:** Aprobado  
**Autores:** López Payán Kevin Ricardo, Flores Guevara Angel Gabriel  
**Director:** Herman Geovany Ayala Zúñiga  
**Institución:** Universidad Autónoma de Sinaloa — Facultad de Ingeniería Mochis  

---

## 1. Identificador del Reporte de Transmisión

**RTE-AIASSIGNMENT-2026-005** — Reporte de Transmisión de Elementos de Prueba del Plugin mod_aiassignment v2.4.0.

---

## 2. Elementos Transmitidos

Los siguientes elementos del software son transmitidos al equipo de pruebas para su evaluación:

### 2.1 Componente Principal: Plugin mod_aiassignment v2.4.0

| Atributo | Valor |
|----------|-------|
| Nombre del producto | mod_aiassignment |
| Versión | 2.4.0 |
| Tipo | Módulo de actividad para Moodle (mod) |
| Archivo instalable | `aiassignment_final.zip` |
| Tamaño del ZIP | 237 KB |
| Checksum MD5 | `[calculado en el momento de la entrega]` |
| Fecha de compilación | Mayo 2026 |
| Moodle mínimo requerido | 4.0 (2022041900) |
| PHP mínimo requerido | 8.1 |
| Madurez | MATURITY_STABLE |

### 2.2 Inventario de Archivos del Plugin

#### Archivos PHP (42 archivos, ~6,500 líneas)

| Archivo | Descripción | Versión |
|---------|-------------|---------|
| `lib.php` | Funciones principales del módulo Moodle | 2.4.0 |
| `mod_form.php` | Formulario de configuración de la actividad | 2.4.0 |
| `view.php` | Vista principal del alumno | 2.4.0 |
| `dashboard.php` | Dashboard del profesor | 2.4.0 |
| `bulk_actions.php` | Acciones en lote | 2.4.0 |
| `plagiarism_report.php` | Reporte de plagio | 2.4.0 |
| `course_report.php` | Reporte del curso | 2.4.0 |
| `classes/ai_evaluator.php` | Evaluador con OpenAI GPT-4o-mini | 2.4.0 |
| `classes/plagiarism_detector.php` | Orquestador de detección de plagio | 2.4.0 |
| `classes/plagiarism/lexical_analyzer.php` | Capa 1: Análisis léxico | 2.4.0 |
| `classes/plagiarism/structural_analyzer.php` | Capa 2: Análisis estructural | 2.4.0 |
| `classes/plagiarism/semantic_analyzer.php` | Capa 3: Análisis semántico | 2.4.0 |
| `classes/plagiarism/obfuscation_detector.php` | Detector de técnicas de ofuscación | 2.4.0 |
| `classes/eval_cache.php` | Caché de evaluaciones | 2.4.0 |
| `classes/security.php` | Módulo de seguridad centralizado | 2.4.0 |
| `classes/audit_logger.php` | Sistema de auditoría | 2.4.0 |
| `classes/submission_versioner.php` | Versionado de submissions | 2.4.0 |
| `classes/ai_detector.php` | Detector de contenido generado por IA | 2.4.0 |
| `classes/behavior_tracker.php` | Rastreador de comportamiento | 2.4.0 |
| `classes/complexity_analyzer.php` | Analizador de complejidad | 2.4.0 |
| `classes/hint_generator.php` | Generador de pistas | 2.4.0 |
| `classes/multi_file_submission.php` | Envíos multi-archivo | 2.4.0 |
| `classes/realtime_notifier.php` | Notificaciones en tiempo real | 2.4.0 |
| `classes/rubric_evaluator.php` | Evaluador con rúbricas | 2.4.0 |
| `classes/webhook_notifier.php` | Notificaciones webhook | 2.4.0 |
| `classes/task/evaluate_submission.php` | Tarea asíncrona: evaluación | 2.4.0 |
| `classes/task/analyze_plagiarism.php` | Tarea asíncrona: plagio | 2.4.0 |
| `classes/task/cleanup_old_data.php` | Tarea programada: limpieza | 2.4.0 |
| `classes/event/course_module_viewed.php` | Evento: módulo visto | 2.4.0 |
| `classes/event/submission_created.php` | Evento: envío creado | 2.4.0 |
| `classes/event/submission_graded.php` | Evento: envío calificado | 2.4.0 |
| `classes/privacy/provider.php` | Proveedor de privacidad GDPR | 2.4.0 |
| `db/install.xml` | Esquema de base de datos | 2.4.0 |
| `db/upgrade.php` | Script de actualización | 2.4.0 |
| `db/access.php` | Definición de capacidades | 2.4.0 |
| `db/tasks.php` | Definición de tareas programadas | 2.4.0 |
| `db/caches.php` | Definición de cachés | 2.4.0 |
| `db/messages.php` | Definición de mensajes | 2.4.0 |
| `backup/moodle2/backup_aiassignment_activity_task.class.php` | Backup | 2.4.0 |
| `backup/moodle2/backup_aiassignment_stepslib.php` | Backup steps | 2.4.0 |
| `backup/moodle2/restore_aiassignment_activity_task.class.php` | Restore | 2.4.0 |
| `backup/moodle2/restore_aiassignment_stepslib.php` | Restore steps | 2.4.0 |

#### Archivos Python (2 archivos, ~200 líneas)

| Archivo | Descripción | Versión |
|---------|-------------|---------|
| `ast_analyzer.py` | Analizador AST de Python (módulo `ast` built-in) | 2.4.0 |
| `demo-standalone/services/python_ast_service.py` | Servicio AST para demo standalone | 1.0.0 |

#### Archivos JavaScript (8 archivos, ~800 líneas)

| Archivo | Descripción | Versión |
|---------|-------------|---------|
| `amd/src/dashboard.js` | Módulo AMD para el dashboard | 2.4.0 |
| `amd/build/dashboard.min.js` | Versión minificada | 2.4.0 |

#### Archivos de Base de Datos (9 tablas)

| Tabla | Descripción |
|-------|-------------|
| `oy1n_aiassignment` | Configuración de actividades |
| `oy1n_aiassignment_submissions` | Envíos de estudiantes |
| `oy1n_aiassignment_plagiarism` | Resultados de análisis de plagio |
| `oy1n_aiassignment_sub_versions` | Historial de versiones de envíos |
| `oy1n_aiassignment_audit_log` | Log de auditoría |
| `oy1n_aiassignment_sus_surveys` | Resultados de encuestas SUS |
| `oy1n_aiassignment_notifications` | Notificaciones del sistema |
| `oy1n_aiassignment_hints` | Pistas generadas |
| `oy1n_aiassignment_behaviors` | Datos de comportamiento |

#### Archivos de Prueba PHPUnit (5 archivos, 62 tests)

| Archivo | Tests | Descripción |
|---------|-------|-------------|
| `tests/security_test.php` | 12 | Tests de seguridad |
| `tests/ai_evaluator_test.php` | 13 | Tests del evaluador de IA |
| `tests/lexical_analyzer_test.php` | 16 | Tests del analizador léxico |
| `tests/structural_analyzer_test.php` | 14 | Tests del analizador estructural |
| `tests/obfuscation_detector_test.php` | 7 | Tests del detector de ofuscación |

---

## 3. Ubicación de los Elementos

| Elemento | Ubicación |
|----------|-----------|
| Plugin instalado | `https://[servidor-hostinger]/moodle/mod/aiassignment/` |
| Archivo ZIP instalable | `aiassignment_final.zip` (raíz del repositorio) |
| Código fuente | `moodle-plugin/` (directorio del repositorio) |
| Documentación técnica | `docs/tecnica/` |
| Documentación de tesis | `docs/tesis/` |
| Tests PHPUnit | `moodle-plugin/tests/` |
| Analizador AST | `moodle-plugin/ast_analyzer.py` |

---

## 4. Estado de los Elementos

| Elemento | Estado | Observaciones |
|----------|--------|---------------|
| Plugin v2.4.0 | ✅ Instalado y activo | En Moodle 4.0+ en Hostinger |
| API OpenAI configurada | ✅ Activa | GPT-4o-mini, rate limit 100/hora |
| Base de datos | ✅ Inicializada | 9 tablas con 20+ índices |
| Python AST | ✅ Funcional | Python 3.8+ disponible en servidor |
| Tests PHPUnit | ✅ Ejecutados | 62/62 tests pasaron |
| Usuarios de prueba | ✅ Creados | maestro01, alumno01-05 |
| Curso de prueba | ✅ Configurado | Con actividad AI Assignment |
| 30 envíos del experimento | ✅ Insertados | Ground truth documentado |

---

## 5. Diferencias con Versiones Anteriores

### Cambios de v2.3.0 a v2.4.0

| Componente | Cambio | Impacto en Pruebas |
|-----------|--------|-------------------|
| `lexical_analyzer.php` | Agregada métrica Levenshtein normalizada | Mejora precisión en ~3% |
| `structural_analyzer.php` | Detección automática de lenguaje (Java, JS, C++, PHP) | Amplía soporte multi-lenguaje |
| `eval_cache.php` | Método `invalidate()` implementado | Corrige bug INC-001 |
| `plagiarism_detector.php` | Tarea asíncrona para análisis de plagio | Elimina timeout de PHP |
| `bulk_actions.php` | Acciones en lote con auditoría | Nueva funcionalidad |
| `submission_versioner.php` | Versionado automático antes de re-evaluación | Nueva funcionalidad |
| `audit_logger.php` | Sistema de auditoría completo | Nueva funcionalidad |
| `dashboard.php` | Paginación real con LIMIT/OFFSET | Mejora rendimiento |
| `amd/src/dashboard.js` | Corrección de `comparisons.length` undefined | Corrige bug INC-003 |

---

## 6. Problemas Conocidos al Momento de la Transmisión

| ID | Descripción | Severidad | Estado |
|----|-------------|-----------|--------|
| INC-001 | `eval_cache::invalidate()` no existía en v2.3.0 | Media | ✅ Corregido en v2.4.0 |
| INC-002 | Error ZIP `corrupted_archive_structure` en algunos servidores | Baja | ✅ Corregido en v2.4.0 |
| INC-003 | `comparisons.length` undefined en dashboard JS | Media | ✅ Corregido en v2.4.0 |

---

## 7. Aprobación de la Transmisión

| Rol | Nombre | Firma | Fecha |
|-----|--------|-------|-------|
| Desarrollador | López Payán Kevin Ricardo | _________________ | Mayo 2026 |
| Co-desarrollador | Flores Guevara Angel Gabriel | _________________ | Mayo 2026 |
| Receptor (Tester) | López Payán Kevin Ricardo | _________________ | Mayo 2026 |
| Director | Herman Geovany Ayala Zúñiga | _________________ | Mayo 2026 |

---

*Documento elaborado conforme al estándar IEEE 829-2008.*  
*Universidad Autónoma de Sinaloa — Facultad de Ingeniería Mochis — 2026*
