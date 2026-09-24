# Avance 4 — Arquitectura del Sistema

| Campo | Detalle |
|---|---|
| **Número de Avance** | 4 de 10 |
| **Título** | Arquitectura del Sistema |
| **Fecha** | Septiembre 2026 |
| **Universidad** | Universidad Autónoma de Sinaloa — Facultad de Informática Mazatlán (FIM) |
| **Autor** | Ángel Flores |
| **Versión del Plugin** | v2.5.1 |

---

## 1. Arquitectura General del Plugin en Moodle

El plugin `mod_aiassignment` sigue la arquitectura estándar de Moodle para módulos de actividad, extendida con servicios externos y un subsistema de análisis Python. La siguiente representación en texto ilustra los componentes principales y sus relaciones:

```
┌──────────────────────────── MOODLE 4.0+ ────────────────────────────────┐
│                                                                           │
│  ┌──────────────┐    ┌──────────────┐    ┌───────────────────────────┐  │
│  │  ESTUDIANTE   │    │   PROFESOR   │    │     ADMINISTRADOR         │  │
│  │  view.php     │    │  dashboard   │    │     settings.php          │  │
│  │  submit form  │    │  grader      │    │     admin_settings.php    │  │
│  └──────┬────────┘    └──────┬───────┘    └─────────────┬─────────────┘  │
│         │                   │                           │               │
│  ┌──────▼───────────────────▼───────────────────────────▼────────────┐  │
│  │                    NÚCLEO DEL PLUGIN                               │  │
│  │                                                                    │  │
│  │  lib.php          mod_form.php       locallib.php                  │  │
│  │  view.php         index.php          renderer.php                  │  │
│  │                                                                    │  │
│  │  ┌─────────────────┐  ┌──────────────────┐  ┌──────────────────┐  │  │
│  │  │plagiarism_       │  │  ai_evaluator    │  │   security.php   │  │  │
│  │  │detector.php      │  │  .php            │  │                  │  │  │
│  │  │                  │  │                  │  │  CSRF validation │  │  │
│  │  │ Léxica 35%       │  │ 6 problem types  │  │  XSS prevention  │  │  │
│  │  │ Estructural 30%  │  │ JSON response    │  │  Shell escaping  │  │  │
│  │  │ Semántica 35%    │  │ Cache system     │  │  Rate limiting   │  │  │
│  │  └────────┬─────────┘  └────────┬─────────┘  └──────────────────┘  │  │
│  │           │                     │                                    │  │
│  │  ┌────────▼─────────┐  ┌────────▼─────────┐                         │  │
│  │  │ ast_analyzer.py  │  │ complexity_       │                         │  │
│  │  │ (Python 3.8)     │  │ analyzer.php      │                         │  │
│  │  │ ast.parse()      │  │ ai_detector.php   │                         │  │
│  │  └──────────────────┘  └──────────────────┘                         │  │
│  └────────────────────────────────────────────────────────────────────┘  │
│                                                                           │
│  ┌──────────────────────────── BASE DE DATOS ──────────────────────────┐  │
│  │  mdl_aiassignment  mdl_aiassignment_submissions  mdl_aiassignment_  │  │
│  │  _grades  _plagiarism  _cache  _logs  _behavior  _hints  _sus      │  │
│  └─────────────────────────────────────────────────────────────────────┘  │
└───────────────────────────────────────────────────────────────────────────┘
                    │                           │
        ┌───────────▼──────────┐    ┌───────────▼──────────┐
        │   OpenAI API          │    │     Judge0 API        │
        │   GPT-4o-mini         │    │   Code Execution      │
        │   Evaluación semántica│    │   10 lenguajes        │
        │   $0.15/M tokens      │    │   Sandbox seguro      │
        └──────────────────────┘    └──────────────────────┘
```

---

## 2. Componentes Principales y Responsabilidades

### 2.1 `plagiarism_detector.php`
Clase central del motor de detección de plagio. Orquesta las tres capas de análisis, gestiona el sistema de caché, genera el reporte masivo en O(n²/2) y produce el JSON de resultados. Métodos principales:

- `detectPlagiarism(int $assignmentId): array` — Punto de entrada principal
- `calculateLexicalSimilarity(string $code1, string $code2): float` — Capa léxica
- `calculateStructuralSimilarity(string $code1, string $code2, string $lang): float` — Capa estructural
- `calculateSemanticSimilarity(string $code1, string $code2): float` — Capa semántica vía GPT
- `normalizeIdentifiers(string $code, string $lang): string` — Normalización de tokens
- `generatePlagiarismReport(int $assignmentId): array` — Reporte masivo paginado

### 2.2 `ai_evaluator.php`
Gestiona todas las interacciones con la API de OpenAI. Implementa rate limiting con ventana deslizante, caché de respuestas por hash SHA-256 del código, reintentos con backoff exponencial (1s, 2s, 4s) y evaluación con rúbrica personalizable de 4 criterios.

### 2.3 `security.php`
Capa transversal de seguridad. Valida tokens CSRF en todas las operaciones de escritura (usando `require_sesskey()`), sanitiza entradas de usuarios, aplica `escapeshellarg()` antes de cualquier llamada a `exec()`, y valida las capability de Moodle (`mod/aiassignment:submit`, `mod/aiassignment:grade`).

### 2.4 `ast_analyzer.py`
Script Python invocado como proceso separado. Recibe código fuente por stdin o como argumento, aplica `ast.parse()` para Python nativo, y retorna un JSON con las características del AST. Para otros lenguajes, ejecuta análisis heurístico de patrones textuales.

### 2.5 `complexity_analyzer.php`
Calcula la complejidad ciclomática de fragmentos de código PHP, Python, Java y JavaScript. Detecta patrones estadísticos que sugieren generación automática por IA (distribución de entropía, consistencia de estilo, vocabulario).

### 2.6 `ai_detector.php`
Subclase especializada de `ai_evaluator.php` orientada a detectar si el código fue generado por herramientas de IA (GitHub Copilot, ChatGPT). Analiza 8 señales: entropía de identificadores, distribución de longitud de líneas, presencia de docstrings perfectos, consistencia de estilo, y envía un prompt especializado a GPT.

---

## 3. Flujo de Envío de un Estudiante (Paso a Paso)

El siguiente flujo describe el ciclo completo desde que un estudiante abre la actividad hasta que recibe su retroalimentación:

```
1. ACCESO A LA ACTIVIDAD
   ├── El estudiante navega al curso y hace clic en la actividad "AI Assignment"
   ├── view.php verifica: sesión activa, inscripción en el curso, capability submit
   ├── Se consulta mdl_aiassignment.timeopen → Si la fecha no ha llegado: muestra cuenta regresiva
   └── Se consulta mdl_aiassignment.duedate → Si venció: muestra mensaje de cierre (o permite entrega tardía si está configurado)

2. CARGA DEL EDITOR
   ├── El módulo AMD amd/src/editor.js intenta cargar Monaco Editor
   ├── Si Monaco no está disponible (fallo de CDN): fallback automático a <textarea> estilizada
   ├── Si mdl_aiassignment.required_language ≠ NULL: se fija el lenguaje en Monaco y se deshabilita el selector
   └── Si modo_examen = true: se activan los listeners de visibilitychange y beforecopy/beforepaste

3. ESCRITURA DE CÓDIGO
   ├── behavior_tracker.js registra: timestamps de escritura, eventos de pegado, número de caracteres por burst
   └── Si cambio de pestaña detectado: incrementa tab_changes_count, guarda en localStorage

4. ENVÍO DEL FORMULARIO
   ├── Validación cliente: lenguaje coincide con required_language, código no vacío, longitud mínima
   ├── POST → submission_handler.php
   ├── security.php: verifica sesskey CSRF, capability, tamaño máximo de código
   ├── Se crea registro en mdl_aiassignment_submissions (version = última + 1)
   └── Se guarda datos de behavior en mdl_aiassignment_behavior

5. EVALUACIÓN AUTOMÁTICA (asíncrona via task Moodle)
   ├── Se encola una tarea Moodle: \mod_aiassignment\task\evaluate_submission
   ├── ai_evaluator.php consulta caché por hash SHA-256 del código
   │   ├── HIT: se usa resultado cacheado → no se llama a OpenAI
   │   └── MISS: se construye prompt por tipo de problema → llamada a GPT-4o-mini
   ├── Se parsea respuesta JSON: similarity_score, feedback, errors, suggestions
   ├── Se calcula score final con rúbrica ponderada (4 criterios configurables)
   └── Se guarda en mdl_aiassignment_grades

6. NOTIFICACIÓN AL ESTUDIANTE
   ├── Moodle messaging API: notificación interna con el score y feedback
   ├── El polling AJAX de view.php detecta estado "evaluated"
   └── Se muestra el panel de retroalimentación con Chart.js (radar chart de criterios)
```

---

## 4. Flujo de Detección de Plagio

```
INICIO: Profesor hace clic en "Detectar Plagio"
│
▼
plagiarism_detector.php::detectPlagiarism($assignmentId)
│
├── Carga todas las submissions del assignment (N entregas)
├── Genera N*(N-1)/2 pares únicos (combinatoria sin repetición)
│
└── Para cada par (submission_i, submission_j):
    │
    ├── 1. CACHÉ CHECK
    │   ├── Hash = SHA256(code_i + code_j)
    │   ├── HIT → retorna resultado cacheado
    │   └── MISS → continúa análisis
    │
    ├── 2. CAPA LÉXICA (35%)
    │   ├── normalizeIdentifiers(code_i) → token_seq_i
    │   ├── normalizeIdentifiers(code_j) → token_seq_j
    │   ├── jaccardBigrams(token_seq_i, token_seq_j) → j_score
    │   ├── lcs(token_seq_i, token_seq_j) → lcs_score
    │   └── lexical_score = 0.6*j_score + 0.4*lcs_score
    │
    ├── 3. CAPA ESTRUCTURAL (30%)
    │   ├── Python: exec('python ast_analyzer.py', code_i) → ast_features_i
    │   ├── exec('python ast_analyzer.py', code_j) → ast_features_j
    │   └── cosineSimilarity(ast_features_i, ast_features_j) → structural_score
    │
    ├── 4. CAPA SEMÁNTICA (35%) — CONDICIONAL
    │   ├── Si combined_score < 0.20 → semantic_score = 0.0 (skip, obvio no plagio)
    │   ├── Si combined_score > 0.85 → semantic_score = 1.0 (skip, obvio plagio)
    │   └── Si 0.20 ≤ combined_score ≤ 0.85 → llamada a GPT-4o-mini
    │
    ├── 5. SCORE FINAL
    │   └── final = 0.35*lexical + 0.30*structural + 0.35*semantic
    │
    └── 6. PERSISTENCIA
        └── INSERT INTO mdl_aiassignment_plagiarism (scores, details JSON)

▼
REPORTE: dashboard muestra matriz de similitud + pares sospechosos ordenados por score
```

---

## 5. Integración con APIs Externas

### 5.1 OpenAI GPT-4o-mini

La integración se gestiona completamente en `ai_evaluator.php`. Las llamadas utilizan el endpoint `https://api.openai.com/v1/chat/completions` con autenticación Bearer token almacenado en la configuración de Moodle (`get_config('mod_aiassignment', 'openai_api_key')`).

El plugin implementa un sistema de rate limiting con ventana deslizante de 3,600 segundos. El contador de llamadas se mantiene en la tabla `mdl_aiassignment_cache` con clave especial `rate_limit_counter`. Si el límite configurado (100 llamadas/hora por defecto) se alcanza, las evaluaciones se encolan para procesamiento diferido.

### 5.2 Judge0 API

La ejecución de código real se implementa en `code_executor.php`. El flujo es: (1) POST del código fuente con el language_id de Judge0, (2) polling del token de ejecución hasta estado "Accepted" o "Time Limit Exceeded", (3) captura de stdout, stderr y tiempo de ejecución, (4) comparación con los casos de prueba definidos por el profesor.

---

## 6. Esquema de Base de Datos — Relaciones Principales

```
mdl_aiassignment (1)
    │
    ├──── (N) mdl_aiassignment_submissions
    │              │
    │              ├── (1) mdl_aiassignment_grades
    │              ├── (1) mdl_aiassignment_behavior
    │              └── (N) mdl_aiassignment_hints
    │
    ├──── (N²/2) mdl_aiassignment_plagiarism
    │              (submission1_id FK + submission2_id FK)
    │
    └──── (N) mdl_aiassignment_logs (auditoria por assignment)

mdl_aiassignment_cache (independiente, clave-valor global)
mdl_aiassignment_sus (por curso, no por assignment)
```

---

## 7. Decisiones de Diseño Importantes

**¿Por qué 3 capas de análisis con pesos distintos?**
Cada capa tiene fortalezas y debilidades complementarias. La capa léxica es rápida y efectiva para ofuscación superficial (peso 35%). La capa estructural con AST es resistente a cambios de nombres pero no detecta refactorizaciones semánticas (peso 30%). La capa semántica con GPT es la más robusta pero costosa; su peso de 35% refleja su alta confiabilidad cuando se activa, pero solo se invoca en la zona de incertidumbre para controlar costos.

**¿Por qué Python para el análisis AST?**
Python ofrece `ast.parse()` en su biblioteca estándar sin dependencias adicionales, generando un AST rico y navigable. PHP no tiene equivalente nativo de calidad similar para análisis de código Python. La comunicación PHP→Python vía `exec()` introduce latencia menor a 200ms, aceptable para análisis en background.

**¿Por qué Monaco Editor con fallback a textarea?**
Monaco Editor (el editor de VS Code) ofrece syntax highlighting, autocompletado y plegado de código, mejorando significativamente la experiencia del estudiante. Sin embargo, al ser un módulo pesado (~2MB), puede fallar en conexiones lentas o configuraciones CDN restrictivas. El fallback a `<textarea>` con estilos CSS garantiza que la funcionalidad esencial siempre esté disponible.

**¿Por qué almacenar el score semántico condicionalmente?**
Activar GPT-4o-mini para todos los pares de código en un grupo de 30 estudiantes generaría 30×29/2 = 435 llamadas a la API por análisis completo, con un costo de ~$0.05 USD. El umbral condicional (20%-85%) reduce el número de llamadas reales en aproximadamente un 60%, bajando el costo a ~$0.02 USD sin pérdida significativa de precisión.

---

*Fin del Avance 4 — Siguiente: Implementación del Sistema de Detección de Plagio*
