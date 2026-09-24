# Fragmentos de Código Más Importantes — Tesis AI Assignment
**Plugin:** `mod_aiassignment` para Moodle  
**Versión:** 2.4.0 | **Fecha:** Junio 2026

---

## Índice

1. [AST Analyzer — Comparación estructural de código (Python)](#1-ast-analyzer)
2. [Plagiarism Detector — Motor de 3 capas (PHP)](#2-plagiarism-detector)
3. [AI Evaluator — Evaluación con OpenAI (PHP)](#3-ai-evaluator)
4. [Code Executor — Ejecución real con Judge0 (PHP)](#4-code-executor)
5. [Submit — Pipeline completo de envío (PHP)](#5-submit)
6. [Lib — Estadísticas consolidadas (PHP)](#6-lib)
7. [Generador de datos de prueba (JavaScript)](#7-generador-de-prueba)
8. [Audit Logger — Trazabilidad (PHP)](#8-audit-logger)

---

## 1. AST Analyzer

**Archivo:** `moodle-plugin/ast_analyzer.py`  
**Rol:** Parsea código Python con el módulo `ast` nativo y compara dos soluciones en 3 capas ponderadas.

### 1.1 Extracción de características del árbol AST

```python
def extract_features(code: str) -> dict:
    """Parsea código Python con ast.parse() y extrae características del árbol."""
    tree = ast.parse(code)
    node_types = Counter()
    structure  = []
    metrics    = {
        "functions": 0, "loops": 0, "conditionals": 0,
        "returns": 0,   "assignments": 0, "imports": 0,
        "recursion": 0, "max_depth": 0,
    }
    func_names = set()

    def walk(node, depth=0):
        metrics["max_depth"] = max(metrics["max_depth"], depth)
        t = type(node).__name__
        node_types[t] += 1
        structure.append(t)

        if isinstance(node, (ast.FunctionDef, ast.AsyncFunctionDef)):
            metrics["functions"] += 1
            func_names.add(node.name)
        elif isinstance(node, (ast.For, ast.While, ast.AsyncFor)):
            metrics["loops"] += 1
        elif isinstance(node, ast.If):
            metrics["conditionals"] += 1
        elif isinstance(node, ast.Return):
            metrics["returns"] += 1
        elif isinstance(node, (ast.Assign, ast.AugAssign, ast.AnnAssign)):
            metrics["assignments"] += 1
        elif isinstance(node, (ast.Import, ast.ImportFrom)):
            metrics["imports"] += 1

        for child in ast.iter_child_nodes(node):
            walk(child, depth + 1)

    walk(tree)

    # Detectar recursión: función que se llama a sí misma
    for node in ast.walk(tree):
        if isinstance(node, ast.Call):
            if isinstance(node.func, ast.Name) and node.func.id in func_names:
                metrics["recursion"] += 1

    return {"node_types": dict(node_types), "structure": structure,
            "metrics": metrics, "total_nodes": sum(node_types.values())}
```

### 1.2 Puntuación final ponderada (3 capas)

```python
def compare(code1: str, code2: str) -> dict:
    f1 = extract_features(code1)
    f2 = extract_features(code2)

    # Capa 1: similitud de tipos de nodos (coseno) — 35%
    node_sim = cosine(f1["node_types"], f2["node_types"]) * 100

    # Capa 2: similitud de secuencia estructural con bigramas Jaccard — 35%
    bg1 = [f"{f1['structure'][i]}|{f1['structure'][i+1]}"
           for i in range(len(f1["structure"]) - 1)]
    bg2 = [f"{f2['structure'][i]}|{f2['structure'][i+1]}"
           for i in range(len(f2["structure"]) - 1)]
    struct_sim = jaccard(bg1, bg2) * 100

    # Capa 3: similitud de métricas numéricas — 30%
    met_sim = metrics_sim(f1["metrics"], f2["metrics"]) * 100

    final = round(node_sim * 0.35 + struct_sim * 0.35 + met_sim * 0.30, 2)

    # Detección de técnicas de ofuscación
    techniques = []
    if node_sim > 70 and struct_sim > 65:
        techniques.append("Renombrado de variables/funciones")
    if abs(f1["metrics"]["loops"] - f2["metrics"]["loops"]) >= 1 and met_sim > 60:
        techniques.append("Cambio de tipo de bucle (for/while/recursión)")
    r1 = f1["metrics"]["recursion"] > 0
    r2 = f2["metrics"]["recursion"] > 0
    if r1 != r2 and met_sim > 55:
        techniques.append("Cambio recursión ↔ iteración")

    return {
        "similarity": final,
        "method": "ast_python",
        "details": {
            "node_types_sim": round(node_sim, 2),
            "structure_sim":  round(struct_sim, 2),
            "metrics_sim":    round(met_sim, 2),
            "techniques":     techniques,
        }
    }
```

### 1.3 Funciones de similitud (Coseno y Jaccard)

```python
def jaccard(a: list, b: list) -> float:
    """Similitud de Jaccard entre dos listas."""
    if not a and not b: return 1.0
    ca, cb = Counter(a), Counter(b)
    inter = sum((ca & cb).values())
    union = sum((ca | cb).values())
    return inter / union if union else 0.0

def cosine(v1: dict, v2: dict) -> float:
    """Similitud coseno entre dos vectores de conteo."""
    keys = set(v1) | set(v2)
    dot  = sum(v1.get(k, 0) * v2.get(k, 0) for k in keys)
    n1   = math.sqrt(sum(x**2 for x in v1.values()))
    n2   = math.sqrt(sum(x**2 for x in v2.values()))
    return dot / (n1 * n2) if n1 and n2 else 0.0
```

---

## 2. Plagiarism Detector

**Archivo:** `moodle-plugin/classes/plagiarism_detector.php`  
**Rol:** Compara envíos de código en 3 capas (léxica, estructural, semántica con IA) y genera reporte masivo.

### 2.1 Comparación en 3 capas con pesos

```php
public static function compare_code(string $code1, string $code2, bool $nosem = false): array {
    // Capa 1: Léxica — tokens normalizados, resistente a renombrado
    $lex = self::lexical_similarity($code1, $code2);

    // Capa 2: Estructural — AST real para Python, regex para otros lenguajes
    $struct = self::structural_similarity($code1, $code2);

    // Capa 3: Semántica (IA) — solo cuando el resultado es ambiguo (20–85%)
    $lex_struct_avg = ($lex['score'] + $struct['score']) / 2;
    $skip_sem = $nosem || $lex_struct_avg > 85 || $lex_struct_avg < 20;

    if ($skip_sem) {
        // Sin IA: redistribuir pesos entre léxica y estructural
        $final = round($lex['score'] * 0.55 + $struct['score'] * 0.45, 2);
        $sem   = ['score' => 0, 'analysis' => 'Omitido (resultado obvio)'];
    } else {
        $sem   = self::semantic_similarity_ai($code1, $code2);
        $final = round(
            $lex['score']    * 0.35 +   // WEIGHT_LEXICAL
            $struct['score'] * 0.30 +   // WEIGHT_STRUCTURAL
            $sem['score']    * 0.35,    // WEIGHT_SEMANTIC
            2
        );
    }

    $techniques = self::detect_obfuscation_techniques($code1, $code2, $lex, $struct);
    $verdict    = self::get_verdict($final, $techniques);

    return [
        'final_score'         => $final,
        'verdict'             => $verdict,
        'layers'              => ['lexical' => $lex, 'structural' => $struct, 'semantic' => $sem],
        'techniques_detected' => $techniques,
    ];
}
```

### 2.2 Normalización léxica (resistente a renombrado de variables)

```php
private static function normalize_identifiers(string $code): string {
    // Eliminar comentarios de todo tipo
    $code = preg_replace('/\/\*[\s\S]*?\*\//', '', $code);
    $code = preg_replace('/\/\/[^\n]*/', '', $code);
    $code = preg_replace('/#[^\n]*/', '', $code);

    // Normalizar strings literales y números
    $code = preg_replace('/"[^"]*"/', '"STR"', $code);
    $code = preg_replace("/'[^']*'/", "'STR'", $code);
    $code = preg_replace('/\b\d+(\.\d+)?\b/', 'NUM', $code);

    return preg_replace('/\s+/', ' ', trim($code));
}

private static function lcs_ratio(array $a, array $b): float {
    $la = count($a); $lb = count($b);
    if ($la === 0 && $lb === 0) return 1.0;
    // Para arrays grandes, usar Jaccard como aproximación (evita timeout O(n²))
    if ($la > 300 || $lb > 300) return self::jaccard($a, $b);

    $dp = array_fill(0, $la + 1, array_fill(0, $lb + 1, 0));
    for ($i = 1; $i <= $la; $i++) {
        for ($j = 1; $j <= $lb; $j++) {
            $dp[$i][$j] = ($a[$i-1] === $b[$j-1])
                ? $dp[$i-1][$j-1] + 1
                : max($dp[$i-1][$j], $dp[$i][$j-1]);
        }
    }
    return $dp[$la][$lb] / max($la, $lb);
}
```

### 2.3 Llamada al microservicio Python AST

```php
private static function call_python_ast_service(string $c1, string $c2): ?array {
    $script = __DIR__ . '/../ast_analyzer.py';
    if (!file_exists($script)) return null;

    // JSON en base64 para evitar problemas con comillas y saltos de línea
    $payload = base64_encode(json_encode(['code1' => $c1, 'code2' => $c2]));
    $python  = self::find_python();
    if (!$python) return null;

    $cmd = escapeshellcmd($python) . ' ' . escapeshellarg($script)
         . ' ' . escapeshellarg($payload);

    $descriptors = [0 => ['pipe', 'r'], 1 => ['pipe', 'w'], 2 => ['pipe', 'w']];
    $process = proc_open($cmd, $descriptors, $pipes);
    if (!is_resource($process)) return null;

    fclose($pipes[0]);
    $output = stream_get_contents($pipes[1]);
    fclose($pipes[1]); fclose($pipes[2]);
    proc_close($process);

    $data = json_decode(trim($output), true);
    return isset($data['similarity']) ? $data : null;
}
```

### 2.4 Capa semántica con OpenAI (detección de plagio lógico)

```php
private static function semantic_similarity_ai(string $c1, string $c2): array {
    $system = <<<PROMPT
Eres un experto en detección de plagio de código fuente para un sistema académico.
Detecta técnicas de ofuscación como:
- Renombrado de variables o funciones
- Cambio de tipo de bucle (for ↔ while ↔ recursión)
- Reordenación de sentencias independientes
- Inserción de código muerto o comentarios falsos
- Cambio de operadores equivalentes (i++ ↔ i+=1 ↔ i=i+1)

Responde ÚNICAMENTE en JSON:
{
  "similarity_score": <0-100>,
  "analysis": "<explicación en español, máx 3 oraciones>",
  "techniques_found": ["técnica1"],
  "verdict": "original" | "sospechoso" | "plagio"
}
PROMPT;

    // ... llamada a OpenAI API con gpt-4o-mini, temperature 0.2 ...
    return [
        'score'    => floatval($content['similarity_score'] ?? 0),
        'analysis' => $content['analysis'] ?? '',
        'verdict'  => $content['verdict'] ?? 'unknown',
    ];
}
```

### 2.5 Reporte masivo con caché inteligente

```php
public static function generate_plagiarism_report(int $assignmentid, bool $nosem = false, bool $force = false): array {
    // Verificar caché: solo recalcular si hay submissions nuevas
    $cache_key  = 'plagiarism_report_' . $assignmentid . ($nosem ? '_fast' : '_full');
    $cache      = \cache::make('mod_aiassignment', 'plagiarism');
    $cached     = $cache->get($cache_key);
    $latest_sub = $DB->get_field_sql(
        "SELECT MAX(timecreated) FROM {aiassignment_submissions} WHERE assignment = :a",
        ['a' => $assignmentid]
    );
    if (!$force && $cached && $cached['generated_at'] >= (int)$latest_sub) {
        return array_merge($cached, ['from_cache' => true]);
    }

    // Tomar el último envío por usuario (el más reciente)
    $sql = "SELECT s.* FROM {aiassignment_submissions} s
            INNER JOIN (
                SELECT userid, MAX(id) as maxid
                FROM {aiassignment_submissions}
                WHERE assignment = :assignment GROUP BY userid
            ) latest ON s.id = latest.maxid";

    $submissions = array_values($DB->get_records_sql($sql, ['assignment' => $assignmentid]));

    // Comparar todos contra todos: O(n²/2)
    for ($i = 0; $i < count($submissions); $i++) {
        for ($j = $i + 1; $j < count($submissions); $j++) {
            $result   = self::compare_code($submissions[$i]->answer, $submissions[$j]->answer, $nosem);
            $matrix[] = [
                'similarity_score' => $result['final_score'],
                'verdict'          => $result['verdict'],
                'is_suspicious'    => $result['final_score'] >= self::get_threshold_high(),
                'techniques'       => $result['techniques_detected'],
            ];
        }
    }
    // ... ordenar, guardar en caché y retornar ...
}
```

---

## 3. AI Evaluator

**Archivo:** `moodle-plugin/classes/ai_evaluator.php`  
**Rol:** Evalúa respuestas de estudiantes con OpenAI usando prompts especializados por tipo de tarea.

### 3.1 Dispatcher principal con caché y rate limiting

```php
public static function evaluate(
    string $studentanswer,
    string $teachersolution,
    string $type,
    ?array $rubric = null
): array {
    // Caché: evitar re-evaluar la misma respuesta
    $cache_key_extra = $rubric ? md5(json_encode($rubric)) : 'norubric';
    $cached = \mod_aiassignment\eval_cache::get($studentanswer, $teachersolution, $type . $cache_key_extra);
    if ($cached !== null) return array_merge($cached, ['from_cache' => true]);

    // Rate limiting: máx N llamadas por hora a OpenAI
    $cache     = \cache::make('mod_aiassignment', 'plagiarism');
    $rate_key  = 'openai_eval_calls_' . date('YmdH');
    $call_count = (int)$cache->get($rate_key);
    $max_calls  = (int)(get_config('mod_aiassignment', 'openai_max_calls_per_hour') ?: 100);
    if ($call_count >= $max_calls) {
        throw new \moodle_exception('openai_rate_exceeded', 'mod_aiassignment');
    }

    // Evaluación con rúbrica personalizada (si aplica)
    if ($rubric !== null) {
        $rubric_result = \mod_aiassignment\rubric_evaluator::evaluate(
            $studentanswer, $teachersolution, $type, $rubric
        );
        return ['similarity_score' => $rubric_result['total_score'],
                'feedback' => $rubric_result['feedback'], 'confidence' => 90];
    }

    // Evaluación estándar + análisis de complejidad para código
    $result = self::call_openai_api($apikey, $model,
        self::get_system_prompt($type),
        self::get_user_prompt($studentanswer, $teachersolution, $type)
    );
    if (in_array($type, ['programming', 'debugging'])) {
        $complexity = \mod_aiassignment\complexity_analyzer::analyze($studentanswer);
        $result['similarity_score'] = min(100, max(0,
            $result['similarity_score'] + $complexity['score_bonus']
        ));
    }
    $cache->set($rate_key, $call_count + 1);
    return $result;
}
```

### 3.2 Prompts especializados por tipo de tarea

```php
private static function get_system_prompt(string $type): string {
    $base = 'Eres un evaluador académico experto. Responde ÚNICAMENTE en JSON: ' .
            '{"similarity_score": 0-100, "feedback": "texto breve en español (máx 3 oraciones)", ' .
            '"analysis": "análisis detallado", "confidence": 0-100, ' .
            '"errors": [{"line": "...", "issue": "...", "suggestion": "..."}]}';

    switch ($type) {
        case 'programming':
            return $base . ' Evalúa: (1) Corrección funcional (2) Calidad del código '
                         . '(3) Eficiencia algorítmica (4) Buenas prácticas. Detecta el lenguaje automáticamente.';
        case 'math':
            return $base . ' Acepta métodos alternativos válidos. '
                         . 'Si el resultado es correcto con método diferente, score >= 85.';
        case 'sql':
            return $base . ' Evalúa sintaxis, eficiencia (índices, JOINs) y seguridad (SQL injection). '
                         . 'Acepta variantes equivalentes (subconsulta vs JOIN).';
        case 'debugging':
            return $base . ' Lista cada bug encontrado/no encontrado en el campo errors.';
        // ... essay, pseudocode ...
    }
}
```

### 3.3 Llamada a OpenAI con reintentos y backoff exponencial

```php
private static function call_openai_api(
    string $apikey, string $model,
    string $systemprompt, string $userprompt
): array {
    $data = [
        'model'           => $model,          // gpt-4o-mini por defecto
        'messages'        => [
            ['role' => 'system', 'content' => $systemprompt],
            ['role' => 'user',   'content' => $userprompt],
        ],
        'temperature'     => 0.2,             // baja aleatoriedad para evaluación consistente
        'response_format' => ['type' => 'json_object'],
    ];

    $maxretries = (int)(get_config('mod_aiassignment', 'openai_retries') ?: 2);

    for ($attempt = 1; $attempt <= $maxretries; $attempt++) {
        try {
            $curl     = new \curl();
            $response = $curl->post('https://api.openai.com/v1/chat/completions',
                json_encode($data), $options);

            $result  = json_decode($response, true);
            if (isset($result['error'])) {
                $code = $result['error']['code'] ?? '';
                if ($attempt < $maxretries && in_array($code, ['rate_limit_exceeded', 'server_error'])) {
                    sleep(2 * $attempt);  // backoff exponencial
                    continue;
                }
                throw new \Exception('OpenAI API Error: ' . $result['error']['message']);
            }

            $content = json_decode($result['choices'][0]['message']['content'], true);
            return [
                'similarity_score' => min(100, max(0, floatval($content['similarity_score']))),
                'feedback'         => $content['feedback'] ?? '',
                'confidence'       => min(100, max(0, intval($content['confidence'] ?? 80))),
                'errors'           => is_array($content['errors'] ?? null) ? $content['errors'] : [],
            ];
        } catch (\Exception $e) {
            if ($attempt < $maxretries) sleep(2 * $attempt);
            $lasterror = $e;
        }
    }
    throw $lasterror;
}
```

---

## 4. Code Executor

**Archivo:** `moodle-plugin/classes/code_executor.php`  
**Rol:** Ejecuta código del estudiante contra test cases reales usando Judge0 API.

### 4.1 Ejecución real con test cases

```php
public static function run(string $code, string $language, array $testcases): array {
    $lang_id = self::LANGUAGES[strtolower($language)] ?? 71; // 71 = Python 3
    $results = [];
    $passed  = 0;

    foreach ($testcases as $i => $tc) {
        $result   = self::execute_single($code, $lang_id, $tc['input'] ?? '', $apikey, $apiurl, $apihost);
        $actual   = trim($result['stdout'] ?? '');
        $expected = trim($tc['expected'] ?? '');
        $correct  = ($actual === $expected);
        if ($correct) $passed++;

        $results[] = [
            'test_num'  => $i + 1,
            'passed'    => $correct,
            'expected'  => $expected,
            'actual'    => $actual,
            'time_ms'   => round(($result['time'] ?? 0) * 1000),
            'memory_kb' => $result['memory'] ?? 0,
            'status'    => $result['status']['description'] ?? 'Unknown',
            'stderr'    => $result['stderr'] ?? '',
        ];
    }
    $total = count($testcases);
    return ['results' => $results, 'passed' => $passed,
            'total' => $total, 'score' => $total > 0 ? round($passed / $total * 100, 2) : 0];
}
```

### 4.2 Polling de resultado en Judge0

```php
private static function execute_single(
    string $code, int $lang_id, string $stdin,
    string $apikey, string $apiurl, string $apihost
): array {
    // 1. Crear submission (base64 por seguridad)
    $payload = json_encode([
        'source_code'    => base64_encode($code),
        'language_id'    => $lang_id,
        'stdin'          => base64_encode($stdin),
        'cpu_time_limit' => 5,       // 5 segundos máximo
        'memory_limit'   => 128000,  // 128 MB máximo
    ]);
    // POST a /submissions → obtiene token

    // 2. Polling hasta obtener resultado (status_id > 2 = terminado)
    for ($attempt = 0; $attempt < 10; $attempt++) {
        sleep(1);
        $res       = json_decode(curl_exec($curl), true);  // GET /submissions/{token}
        $status_id = $res['status']['id'] ?? 0;
        if ($status_id > 2) {
            return [
                'stdout'         => $res['stdout'] ? base64_decode($res['stdout']) : '',
                'stderr'         => $res['stderr'] ? base64_decode($res['stderr']) : '',
                'compile_output' => $res['compile_output'] ? base64_decode($res['compile_output']) : '',
                'time'           => $res['time'] ?? 0,
                'memory'         => $res['memory'] ?? 0,
                'status'         => $res['status'],
            ];
        }
    }
    throw new \Exception("Timeout esperando resultado de Judge0");
}
```

---

## 5. Submit

**Archivo:** `moodle-plugin/submit.php`  
**Rol:** Orquesta el pipeline completo al recibir un envío de estudiante.

### 5.1 Validaciones de seguridad y anti-trampa

```php
// 1. Sanitizar código con clase centralizada de seguridad
$answer = \mod_aiassignment\security::sanitize_code($answer, $maxlen);

// 2. Verificar intentos máximos
$attemptcount = $DB->count_records('aiassignment_submissions',
    ['assignment' => $aiassignment->id, 'userid' => $USER->id]);
if ($aiassignment->maxattempts > 0 && $attemptcount >= $aiassignment->maxattempts) {
    redirect(..., get_string('maxattemptsreached', 'aiassignment'), NOTIFY_ERROR);
}

// 3. Rate limiting por usuario
\mod_aiassignment\security::check_rate_limit($USER->id, $aiassignment->id);

// 4. Detectar envío duplicado (mismo contenido que el anterior)
$recentsub = $DB->get_record_sql(
    "SELECT answer FROM {aiassignment_submissions}
     WHERE assignment = :a AND userid = :u ORDER BY timecreated DESC LIMIT 1",
    ['a' => $aiassignment->id, 'u' => $USER->id]
);
if ($recentsub && trim($recentsub->answer) === $answer) {
    redirect(..., get_string('duplicateanswer', 'aiassignment'), NOTIFY_WARNING);
}
```

### 5.2 Detección de comportamiento sospechoso

```php
// Detectar código generado por IA
$ai_detection = \mod_aiassignment\ai_detector::detect($answer, $aiassignment->type);
if ($ai_detection['score'] >= 70) {
    $submission->feedback = '[⚠️ POSIBLE IA: ' . $ai_detection['label'] .
        ' (' . $ai_detection['score'] . '%)] ' . implode('; ', $ai_detection['signals']);
}

// Detectar cambios de pestaña (modo examen)
$tab_switches = optional_param('tab_switches', 0, PARAM_INT);
if ($tab_switches > 0) {
    $submission->feedback .= ' [🔒 EXAMEN: ' . $tab_switches . ' cambio(s) de pestaña detectado(s)]';
}

// Analizar comportamiento del editor: pegar masivo, velocidad de tipeo
$events = json_decode(optional_param('editor_events', '', PARAM_RAW), true);
if (is_array($events) && !empty($events)) {
    $behavior = \mod_aiassignment\behavior_tracker::analyze($events, $answer);
    if ($behavior['suspicious']) {
        $submission->feedback .= ' [⚠️ COMPORTAMIENTO: ' . implode('; ', $behavior['signals']) .
            ' | Pegados: ' . $behavior['paste_count'] .
            ' | Velocidad: ' . $behavior['typing_speed'] . ' cpm]';
    }
}
```

### 5.3 Evaluación sincrónica con notificación al estudiante

```php
$evaluation = \mod_aiassignment\ai_evaluator::evaluate(
    $answer, $aiassignment->solution, $aiassignment->type, $rubric
);

// Guardar evaluación en BD
$evalrecord->submission       = $submission->id;
$evalrecord->similarity_score = $evaluation['similarity_score'];
$evalrecord->ai_feedback      = $evaluation['feedback'];
$DB->insert_record('aiassignment_evaluations', $evalrecord);

// Actualizar libro de calificaciones de Moodle
aiassignment_update_grades($aiassignment, $USER->id);

// Notificar al estudiante por mensajería interna de Moodle
$message->component   = 'mod_aiassignment';
$message->name        = 'submission_graded';
$message->smallmessage = get_string('notif_graded_small', 'aiassignment',
    round($evaluation['similarity_score'], 2));
message_send($message);

// Mostrar encuesta de satisfacción cada 3 intentos
$show_survey = ($submission->attempt % 3 === 0);
if ($show_survey) {
    redirect(new moodle_url('/mod/aiassignment/satisfaction_survey.php', [...]), ...);
}
```

---

## 6. Lib

**Archivo:** `moodle-plugin/lib.php`  
**Rol:** Funciones requeridas por la API de Moodle e integración con el libro de calificaciones.

### 6.1 Actualización del libro de calificaciones

```php
function aiassignment_get_user_grades($aiassignment, $userid = 0) {
    global $DB;
    $sql = "SELECT userid, MAX(score) as rawgrade, MAX(timecreated) as dategraded
            FROM {aiassignment_submissions}
            WHERE assignment = :assignment AND status = 'evaluated' $usersql
            GROUP BY userid";

    $grades = $DB->get_records_sql($sql, $params);

    // Convertir score (0–100) a la escala de calificación configurada en Moodle
    foreach ($grades as $grade) {
        $grade->rawgrade = ($grade->rawgrade / 100) * $aiassignment->grade;
    }
    return $grades;
}
```

### 6.2 Estadísticas del curso en una sola query

```php
function aiassignment_get_course_statistics($courseid) {
    global $DB;
    list($insql, $params) = $DB->get_in_or_equal(array_keys($assignments));

    // Una sola query consolidada — evita N+1 queries
    $sql = "SELECT
                COUNT(*)                                             AS total_submissions,
                AVG(CASE WHEN s.score IS NOT NULL THEN s.score END) AS average_grade,
                COUNT(DISTINCT s.userid)                            AS active_students,
                SUM(CASE WHEN s.status = 'pending' THEN 1 ELSE 0 END) AS pending_evaluations
            FROM {aiassignment_submissions} s
            WHERE s.assignment $insql";

    $r = $DB->get_record_sql($sql, $params);
    $stats->total_submissions   = (int)$r->total_submissions;
    $stats->average_grade       = $r->average_grade ? round($r->average_grade, 2) : 0;
    $stats->active_students     = (int)$r->active_students;
    $stats->pending_evaluations = (int)$r->pending_evaluations;
    return $stats;
}
```

### 6.3 Alumnos de alto riesgo con JOIN optimizado

```php
function aiassignment_get_high_risk_students($courseid) {
    global $DB;
    $sql = "SELECT u.id, u.firstname, u.lastname,
                   MAX(e.similarity_score) as max_plag,
                   s.id as submission_id, a.name as assignment_name
            FROM {aiassignment_evaluations} e
            JOIN {aiassignment_submissions} s ON s.id = e.submission
            JOIN {aiassignment} a ON s.assignment = a.id
            JOIN {user} u ON s.userid = u.id
            WHERE a.course = :courseid
              AND e.similarity_score >= 75   -- umbral configurable
              AND u.username != 'admin'
            GROUP BY u.id, u.firstname, u.lastname, s.id, a.name
            ORDER BY max_plag DESC";
    return $DB->get_records_sql($sql, ['courseid' => $courseid]);
}
```

---

## 7. Generador de Prueba

**Archivo:** `scripts/generar-150-alumnos.js`  
**Rol:** Genera SQL idempotente para poblar la BD con datos de prueba realistas.

### 7.1 Distribución de tipos de envío

```javascript
function getTipo(i) {
    const r = i % 5;
    if (r === 1 || r === 2) return 'plagio';      // 40% — copia con renombrado
    if (r === 3)             return 'sospechoso'; // 20% — lógica similar
    return 'original';                             // 40% — código propio
}

// Código de ejemplo para cada tipo (Bubble Sort)
const tarea = {
    orig: (i) => `def bubble_sort_${i}(arr):\n    n=len(arr)\n    for i in range(n):...`,
    plag: (i) => `def ordenar_${i}(lista):\n    tam=len(lista)\n    for i in range(tam):...`,
    sosp: (i) => `def bubble_opt_${i}(arr):\n    ...\n    sw=False\n    if not sw: break...`,
};
```

### 7.2 Evaluaciones con distribución de similitud realista

```sql
-- Asignar score de similitud según tipo de alumno detectado
INSERT INTO oy1n_aiassignment_evaluations (submission, similarity_score, ...)
SELECT s.id,
  CASE
    WHEN MOD(alumno_num, 5) IN (1,2) THEN 75 + MOD(alumno_num, 20)  -- plagio:     75–94%
    WHEN MOD(alumno_num, 5) = 3      THEN 45 + MOD(alumno_num, 25)  -- sospechoso: 45–69%
    ELSE                                   5 + MOD(alumno_num, 18)  -- original:   5–22%
  END AS similarity_score
FROM oy1n_aiassignment_submissions s ...
```

### 7.3 Verificación final del script

```sql
-- Conteos esperados tras ejecutar el script
SELECT 'MAESTROS'         AS tipo, COUNT(*) AS total FROM oy1n_user WHERE username IN ('maestro01','maestro02','maestro03')
UNION ALL SELECT 'ALUMNOS',       COUNT(*) FROM oy1n_user WHERE username LIKE 'al%_s0%'
UNION ALL SELECT 'CURSOS',        COUNT(*) FROM oy1n_course WHERE shortname IN ('salon01',...'salon06')
UNION ALL SELECT 'TAREAS',        COUNT(*) FROM oy1n_aiassignment a JOIN oy1n_course c ON a.course=c.id WHERE ...
UNION ALL SELECT 'ENVIOS',        COUNT(*) FROM oy1n_aiassignment_submissions s JOIN oy1n_user u ON s.userid=u.id WHERE ...
UNION ALL SELECT 'EVALUACIONES',  COUNT(*) FROM oy1n_aiassignment_evaluations e JOIN ... ;
-- Esperado: 3, 150, 6, 12, 300, 300
```

---

## 8. Audit Logger

**Archivo:** `moodle-plugin/classes/audit_logger.php`  
**Rol:** Registro de trazabilidad para todas las acciones importantes (calificaciones manuales, plagio confirmado, etc.).

```php
class audit_logger {
    const ACTION_MANUAL_GRADE       = 'manual_grade';
    const ACTION_REEVALUATE         = 'reevaluate';
    const ACTION_PLAGIARISM_CONFIRM = 'plagiarism_confirm';
    const ACTION_PLAGIARISM_DISMISS = 'plagiarism_dismiss';
    const ACTION_RESUBMIT_REQUEST   = 'resubmit_request';

    public static function log(
        string $action, int $userid, int $targetid,
        string $targettype = 'submission', array $data = []
    ): void {
        global $DB;
        $record->action      = $action;
        $record->userid      = $userid;
        $record->targetid    = $targetid;
        $record->ip          = getremoteaddr();   // IP para trazabilidad forense
        $record->data        = json_encode($data, JSON_UNESCAPED_UNICODE);
        $record->timecreated = time();
        $DB->insert_record('aiassignment_audit_log', $record);
    }

    // Política de retención: elimina registros con más de N días
    public static function cleanup(int $days = 365): int {
        $cutoff = time() - ($days * 86400);
        $count  = $DB->count_records_select('aiassignment_audit_log', 'timecreated < :t', ['t' => $cutoff]);
        $DB->delete_records_select('aiassignment_audit_log', 'timecreated < :t', ['t' => $cutoff]);
        return $count;
    }
}
```

---

## Resumen de la Arquitectura

```
Envío del estudiante
        │
        ▼
  submit.php ──── Validaciones: sanitización, rate limit, anti-duplicado
        │
        ├── ai_detector.php      → detecta código generado por IA
        ├── behavior_tracker.php → detecta pegado masivo, velocidad anómala
        │
        ▼
  ai_evaluator.php ─── OpenAI GPT-4o-mini (prompt especializado por tipo)
        │                    ├── rubric_evaluator.php  (si hay rúbrica)
        │                    └── complexity_analyzer.php (para código)
        │
        ▼
  plagiarism_detector.php
        ├── Capa 1: Léxica    → tokens normalizados + Jaccard + LCS
        ├── Capa 2: Estructural → ast_analyzer.py (Python) / regex
        └── Capa 3: Semántica  → OpenAI (solo si score ambiguo 20–85%)
                │
                └── ast_analyzer.py → módulo ast nativo de Python
                        ├── cosine similarity (tipos de nodos)
                        ├── Jaccard bigramas (secuencia estructural)
                        └── metrics_sim (loops, funciones, recursión)
        │
        ▼
  code_executor.php ── Judge0 API → ejecución real contra test cases
        │
        ▼
  audit_logger.php ─── Registro de trazabilidad
  lib.php ──────────── Libro de calificaciones Moodle
```

---

*Documento generado automáticamente desde el código fuente del proyecto.*  
*Plugin: `mod_aiassignment` | Moodle 4.0+ | Versión 2.4.0*
