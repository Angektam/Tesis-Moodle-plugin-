# Avance 3 — Metodología de Desarrollo

| Campo | Detalle |
|---|---|
| **Número de Avance** | 3 de 10 |
| **Título** | Metodología de Desarrollo |
| **Fecha** | Septiembre 2026 |
| **Universidad** | Universidad Autónoma de Sinaloa — Facultad de Informática Mazatlán (FIM) |
| **Autor** | Ángel Flores |
| **Versión del Plugin** | v2.5.1 |

---

## 1. Metodología Ágil Adaptada

El desarrollo del plugin `mod_aiassignment` siguió una metodología ágil adaptada al contexto de un proyecto de tesis individual, inspirada en Scrum pero simplificada para un equipo de un único desarrollador con supervisión académica. La metodología se estructuró en **sprints de dos semanas**, con entregables funcionales al final de cada sprint y revisiones con el director de tesis.

Las principales adaptaciones al framework Scrum estándar fueron:

- **Product Backlog personal**: Gestión de historias de usuario en un tablero Kanban con priorización MoSCoW (Must have, Should have, Could have, Won't have).
- **Sprint Review con el director**: Sesiones quincenales de revisión del avance funcional y corrección de rumbo.
- **Integración continua**: Ejecución automática de la suite PHPUnit al finalizar cada módulo, garantizando regresión cero entre sprints.
- **Documentación incremental**: Cada sprint incluyó la actualización de la documentación técnica correspondiente al módulo desarrollado.

La duración total del proyecto fue de 11 sprints (22 semanas), desde el análisis inicial de requerimientos hasta la validación final con el experimento controlado.

---

## 2. Fases del Proyecto

### Fase 1 — Análisis de Requerimientos (Sprint 1)
Levantamiento de requerimientos con 5 docentes de la FIM mediante entrevistas semiestructuradas. Análisis de las herramientas existentes (MOSS, JPlag, Copyleaks). Definición del alcance y las 6 historias de usuario principales. Estudio de viabilidad técnica de la integración con Moodle 4.0.

### Fase 2 — Diseño de la Arquitectura (Sprint 2)
Diseño del esquema de base de datos (9 tablas). Definición de la arquitectura de capas del detector de plagio. Diseño de los flujos de interacción usuario-sistema. Prototipado de la interfaz del dashboard con wireframes. Selección y evaluación de APIs externas (OpenAI GPT-4o-mini vs GPT-3.5-turbo; Judge0 vs Sphere Engine).

### Fase 3 — Desarrollo del Núcleo (Sprints 3–5)
Implementación de la estructura base del plugin Moodle: `version.php`, `mod_form.php`, `lib.php`, `view.php`, tablas de base de datos. Desarrollo de la capa léxica del detector de plagio (`plagiarism_detector.php`). Integración inicial con OpenAI para evaluación básica (`ai_evaluator.php`). Editor Monaco con fallback a textarea.

### Fase 4 — Desarrollo de Funcionalidades Avanzadas (Sprints 6–8)
Implementación de la capa estructural AST (`ast_analyzer.py`, integración PHP-Python). Capa semántica con GPT-4o-mini. Dashboard con Chart.js. Modo examen y behavior tracker. Sistema de deadline con cuenta regresiva. Validación de lenguaje requerido por tarea. Judge0 para ejecución de código real.

### Fase 5 — Pruebas y Refinamiento (Sprints 9–10)
Desarrollo de los 62 tests PHPUnit. Prueba de estrés con 150 estudiantes simulados y script `generar-150-alumnos.js`. Corrección de bugs críticos detectados. Optimización de queries N+1 en el reporte masivo.

### Fase 6 — Validación y Documentación (Sprint 11)
Experimento controlado con 30 estudiantes reales. Encuesta SUS. Generación de la documentación IEEE 829. Redacción del documento de tesis final.

---

## 3. Herramientas y Tecnologías Utilizadas

| Categoría | Tecnología | Versión | Propósito |
|---|---|---|---|
| **Plataforma LMS** | Moodle | 4.0 / 4.1 / 4.3 | Plataforma base del plugin |
| **Lenguaje Backend** | PHP | 8.1 | Lógica del plugin, API interna |
| **Lenguaje Análisis** | Python | 3.8+ | AST parsing, ast_analyzer.py |
| **Lenguaje Frontend** | JavaScript | ES2020 | Módulos AMD, Chart.js, Monaco |
| **Base de Datos** | MySQL | 8.0 | Almacenamiento de datos del plugin |
| **IA Evaluación** | OpenAI GPT-4o-mini | API v1 | Evaluación semántica y retroalimentación |
| **Ejecución de Código** | Judge0 API | CE v1.13 | Ejecución sandbox en 10 lenguajes |
| **Editor de Código** | Monaco Editor | 0.44 | Editor con syntax highlighting en navegador |
| **Visualización** | Chart.js | 4.x | Gráficas del dashboard |
| **Pruebas** | PHPUnit | 9.x (Moodle estándar) | Tests unitarios y de integración |
| **Control de Versiones** | Git | 2.x | Gestión de código fuente |
| **Estilo de Código** | PSR-2 + Moodle CS | — | Estándares de codificación |
| **Documentación API** | phpDocumentor | 3.x | Documentación inline PHP |
| **Entorno de Desarrollo** | XAMPP + VS Code | — | Servidor local de pruebas |

---

## 4. Arquitectura del Sistema — Descripción de Capas

El plugin `mod_aiassignment` sigue una arquitectura en 4 capas claramente delimitadas:

```
┌─────────────────────────────────────────────────────┐
│              CAPA DE PRESENTACIÓN                    │
│  view.php · mod_form.php · dashboard.php             │
│  Monaco Editor · Chart.js · AMD Modules (JS)         │
├─────────────────────────────────────────────────────┤
│              CAPA DE LÓGICA DE NEGOCIO               │
│  plagiarism_detector.php · ai_evaluator.php          │
│  security.php · complexity_analyzer.php              │
│  ai_detector.php · hint_generator.php                │
├─────────────────────────────────────────────────────┤
│              CAPA DE INTEGRACIÓN EXTERNA             │
│  OpenAI GPT-4o-mini API · Judge0 API                 │
│  ast_analyzer.py (Python subprocess)                 │
├─────────────────────────────────────────────────────┤
│              CAPA DE DATOS                           │
│  MySQL 8.0 · $DB Moodle API · 9 tablas               │
│  Sistema de caché (MUC - Moodle Universal Cache)     │
└─────────────────────────────────────────────────────┘
```

La comunicación entre la capa PHP y el script Python (`ast_analyzer.py`) se realiza mediante `exec()` con argumentos escapados vía `escapeshellarg()`, recibiendo la respuesta como JSON por stdout. Esta decisión de diseño evita la necesidad de instalar extensiones PHP adicionales y mantiene el análisis AST en su entorno nativo (Python).

---

## 5. Diseño de la Base de Datos — 9 Tablas

| # | Tabla | Descripción | Registros esperados |
|---|---|---|---|
| 1 | `mdl_aiassignment` | Instancias del módulo. Cada actividad creada por un profesor genera un registro. Contiene: nombre, descripción, fechas de apertura/cierre, lenguaje requerido, parámetros de evaluación | 1 por actividad creada |
| 2 | `mdl_aiassignment_submissions` | Entregas de estudiantes. Campos: userid, assignment, code, language, version, timecreated, timemodified, status | N por actividad |
| 3 | `mdl_aiassignment_grades` | Calificaciones calculadas por la IA. Vinculada a submissions. Campos: submission_id, ai_score, rubric_scores (JSON), feedback (TEXT), evaluated_by, timecreated | 1 por submission evaluada |
| 4 | `mdl_aiassignment_plagiarism` | Resultados de comparaciones de plagio. Campos: submission1_id, submission2_id, lexical_score, structural_score, semantic_score, final_score, details (JSON) | N² pares por análisis |
| 5 | `mdl_aiassignment_cache` | Caché de evaluaciones IA para evitar llamadas redundantes. Clave: hash SHA-256 del código. TTL configurable | Variable |
| 6 | `mdl_aiassignment_logs` | Auditoría de acciones de profesores. Campos: userid, action, target_id, details (JSON), timeaction, ip_address | Registro completo |
| 7 | `mdl_aiassignment_behavior` | Datos del behavior tracker. Campos: submission_id, typing_speed_avg, paste_ratio, focus_changes, session_data (JSON) | 1 por submission en modo examen |
| 8 | `mdl_aiassignment_hints` | Historial de pistas solicitadas por estudiantes. Campos: submission_id, hint_level, hint_text, tokens_used, timecreated | Variable |
| 9 | `mdl_aiassignment_sus` | Respuestas a la encuesta SUS integrada. Campos: userid, course_id, responses (JSON), sus_score, timecreated | 1 por participante encuestado |

---

## 6. Estrategia de Pruebas

La estrategia de pruebas siguió el estándar **IEEE 829** y comprende tres niveles:

### 6.1 Pruebas Unitarias con PHPUnit
62 tests distribuidos en 5 archivos de la carpeta `tests/`:

| Archivo | Tests | Cobertura |
|---|---|---|
| `plagiarism_detector_test.php` | 18 | Algoritmos Jaccard, LCS, normalización, scores ponderados |
| `ai_evaluator_test.php` | 14 | Tipos de problema, parsing JSON, mock de API OpenAI |
| `security_test.php` | 12 | Validación de entradas, XSS, CSRF, escapado de shell |
| `submission_manager_test.php` | 10 | Versionado, estados, queries de base de datos |
| `complexity_analyzer_test.php` | 8 | Complejidad ciclomática, detección de patrones IA |

Ejecución: `vendor/bin/phpunit --testdox mod/aiassignment/tests/`

### 6.2 Prueba de Estrés
Simulación de carga con el script `generar-150-alumnos.js` que crea: 150 usuarios, 6 salones, 3 maestros, 300 entregas de código y dispara 300 evaluaciones simultáneas. Métricas medidas: tiempo de respuesta promedio, peak de memoria PHP, queries por segundo en MySQL.

### 6.3 Experimento Controlado
Validación de precisión con 30 estudiantes reales de la FIM distribuidos en 5 grupos experimentales (A–E), con materiales de código preparados intencionalmente: originales, plagiados con diferentes técnicas de ofuscación y similares no plagiados. Métricas: exactitud, precisión, recall, F1-score y curvas ROC por umbral.

---

*Fin del Avance 3 — Siguiente: Arquitectura del Sistema*
