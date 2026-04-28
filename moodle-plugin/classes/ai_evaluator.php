<?php
// This file is part of Moodle - http://moodle.org/

namespace mod_aiassignment;

defined('MOODLE_INTERNAL') || die();

/**
 * Servicio de evaluación con IA usando OpenAI.
 *
 * Mejoras implementadas:
 *  - Prompts especializados por tipo: programming, math, essay, sql, pseudocode, debugging
 *  - Score de confianza (confidence) en la evaluación
 *  - Análisis de errores específicos con línea y sugerencia de corrección
 *  - Evaluación multi-criterio sin rúbrica (4 dimensiones siempre)
 *  - Detección de lenguaje de programación automática
 *  - Feedback en el idioma del estudiante (español)
 *  - Modo estricto vs modo flexible configurable
 */
class ai_evaluator {

    // Tipos soportados
    const TYPES = ['programming', 'math', 'essay', 'sql', 'pseudocode', 'debugging'];

    /**
     * Evalúa una respuesta de estudiante usando OpenAI.
     *
     * @param string     $studentanswer   Respuesta del estudiante
     * @param string     $teachersolution Solución de referencia del profesor
     * @param string     $type            Tipo: programming|math|essay|sql|pseudocode|debugging
     * @param array|null $rubric          Rúbrica personalizada (null = usar evaluación estándar)
     * @return array {similarity_score, feedback, analysis, confidence, errors, rubric?, complexity?}
     */
    public static function evaluate(
        string $studentanswer,
        string $teachersolution,
        string $type,
        ?array $rubric = null
    ): array {
        // ── Caché ─────────────────────────────────────────────────────────
        $cache_key_extra = $rubric ? md5(json_encode($rubric)) : 'norubric';
        $cached = \mod_aiassignment\eval_cache::get($studentanswer, $teachersolution, $type . $cache_key_extra);
        if ($cached !== null) {
            $cached['from_cache'] = true;
            return $cached;
        }

        // ── Modo demo ─────────────────────────────────────────────────────
        if (get_config('mod_aiassignment', 'demo_mode')) {
            $result = self::demo_evaluate($studentanswer, $teachersolution, $type);
            \mod_aiassignment\eval_cache::set($studentanswer, $teachersolution, $type . $cache_key_extra, $result);
            return $result;
        }

        // ── API key ───────────────────────────────────────────────────────
        $apikey = get_config('mod_aiassignment', 'openai_api_key');
        if (empty($apikey)) {
            throw new \moodle_exception('noapikey', 'mod_aiassignment');
        }

        // ── Rate limiting para OpenAI (mejora #2) ─────────────────────────
        $cache = \cache::make('mod_aiassignment', 'plagiarism');
        $rate_key = 'openai_eval_calls_' . date('YmdH');
        $call_count = (int)$cache->get($rate_key);
        $max_calls = (int)(get_config('mod_aiassignment', 'openai_max_calls_per_hour') ?: 100);
        if ($call_count >= $max_calls) {
            throw new \moodle_exception('openai_rate_exceeded', 'mod_aiassignment');
        }

        $model = get_config('mod_aiassignment', 'openai_model') ?: 'gpt-4o-mini';

        // ── Evaluación con rúbrica ────────────────────────────────────────
        $use_rubrics = get_config('mod_aiassignment', 'use_rubrics');
        if ($use_rubrics || $rubric !== null) {
            try {
                $rubric_result = \mod_aiassignment\rubric_evaluator::evaluate(
                    $studentanswer, $teachersolution, $type, $rubric
                );
                $result = [
                    'similarity_score' => $rubric_result['total_score'],
                    'feedback'         => $rubric_result['feedback'],
                    'analysis'         => json_encode($rubric_result['breakdown'], JSON_UNESCAPED_UNICODE),
                    'confidence'       => 90,
                    'errors'           => [],
                    'rubric'           => $rubric_result,
                ];
                if ($type === 'programming' || $type === 'debugging') {
                    $complexity = \mod_aiassignment\complexity_analyzer::analyze($studentanswer);
                    $result['complexity'] = $complexity;
                    $result['similarity_score'] = min(100, max(0,
                        $result['similarity_score'] + $complexity['score_bonus']
                    ));
                }
                \mod_aiassignment\eval_cache::set($studentanswer, $teachersolution, $type . $cache_key_extra, $result);
                return $result;
            } catch (\Exception $e) {
                debugging('Rubric evaluation failed, falling back: ' . $e->getMessage(), DEBUG_DEVELOPER);
            }
        }

        // ── Evaluación estándar con prompts especializados ────────────────
        try {
            $result = self::call_openai_api(
                $apikey, $model,
                self::get_system_prompt($type),
                self::get_user_prompt($studentanswer, $teachersolution, $type)
            );

            // Análisis de complejidad para código
            if (in_array($type, ['programming', 'debugging'])) {
                $complexity = \mod_aiassignment\complexity_analyzer::analyze($studentanswer);
                $result['complexity'] = $complexity;
                $result['similarity_score'] = min(100, max(0,
                    $result['similarity_score'] + $complexity['score_bonus']
                ));
                if (!empty($complexity['feedback'])) {
                    $result['analysis'] .= "\n\n**Complejidad:**\n" . $complexity['feedback'];
                }
            }

            // Registrar llamada API para rate limiting
            $cache->set($rate_key, $call_count + 1);

            \mod_aiassignment\eval_cache::set($studentanswer, $teachersolution, $type . $cache_key_extra, $result);
            return $result;

        } catch (\Exception $e) {
            debugging('OpenAI API Error: ' . $e->getMessage(), DEBUG_DEVELOPER);
            throw new \moodle_exception('evaluationfailed', 'mod_aiassignment', '', null, $e->getMessage());
        }
    }

    // ─────────────────────────────────────────────────────────────────────
    // PROMPTS ESPECIALIZADOS POR TIPO
    // ─────────────────────────────────────────────────────────────────────

    private static function get_system_prompt(string $type): string {
        $base = 'Eres un evaluador académico experto. Responde ÚNICAMENTE en JSON con esta estructura exacta: ' .
                '{"similarity_score": 0-100, "feedback": "texto breve en español (máx 3 oraciones)", ' .
                '"analysis": "análisis detallado en español", "confidence": 0-100, ' .
                '"errors": [{"line": "descripción", "issue": "problema", "suggestion": "corrección"}]}. ' .
                'confidence = qué tan seguro estás de tu evaluación (0=muy inseguro, 100=muy seguro). ' .
                'errors = lista de errores específicos encontrados (vacía si no hay errores).';

        switch ($type) {
            case 'programming':
                return $base . ' Evalúa código de programación considerando: ' .
                       '(1) Corrección funcional — ¿produce el resultado esperado? ' .
                       '(2) Calidad del código — legibilidad, nombres descriptivos, estructura. ' .
                       '(3) Eficiencia — complejidad algorítmica, uso de recursos. ' .
                       '(4) Buenas prácticas — manejo de errores, casos borde, modularidad. ' .
                       'Detecta el lenguaje automáticamente. Sé estricto con la corrección funcional.';

            case 'math':
                return $base . ' Evalúa soluciones matemáticas considerando: ' .
                       '(1) Corrección del resultado final — ¿es correcto? ' .
                       '(2) Procedimiento — ¿los pasos son válidos y completos? ' .
                       '(3) Justificación — ¿explica el razonamiento? ' .
                       '(4) Notación — ¿usa notación matemática correcta? ' .
                       'Acepta métodos alternativos válidos aunque difieran de la solución de referencia. ' .
                       'Si el resultado es correcto con método diferente, score >= 85.';

            case 'essay':
                return $base . ' Evalúa ensayos/textos considerando: ' .
                       '(1) Contenido — ¿cubre los puntos clave del tema? ' .
                       '(2) Argumentación — ¿los argumentos son sólidos y coherentes? ' .
                       '(3) Estructura — ¿tiene introducción, desarrollo y conclusión? ' .
                       '(4) Originalidad — ¿aporta perspectiva propia? ' .
                       'No penalices diferencias de estilo. Valora el pensamiento crítico.';

            case 'sql':
                return $base . ' Evalúa consultas SQL considerando: ' .
                       '(1) Corrección — ¿la consulta produce el resultado esperado? ' .
                       '(2) Sintaxis — ¿es SQL válido? ' .
                       '(3) Eficiencia — ¿usa índices, evita SELECT *, usa JOINs apropiados? ' .
                       '(4) Seguridad — ¿evita SQL injection, usa parámetros? ' .
                       'Acepta variantes equivalentes (subconsulta vs JOIN, etc.). ' .
                       'Indica el tipo de error SQL si lo hay (sintaxis, lógica, rendimiento).';

            case 'pseudocode':
                return $base . ' Evalúa pseudocódigo/algoritmos considerando: ' .
                       '(1) Corrección lógica — ¿el algoritmo resuelve el problema? ' .
                       '(2) Claridad — ¿es comprensible y bien estructurado? ' .
                       '(3) Completitud — ¿maneja todos los casos? ' .
                       '(4) Eficiencia — ¿el algoritmo es razonablemente eficiente? ' .
                       'No penalices diferencias de sintaxis de pseudocódigo (es flexible por definición).';

            case 'debugging':
                return $base . ' Evalúa la corrección de bugs considerando: ' .
                       '(1) Identificación — ¿encontró todos los bugs? ' .
                       '(2) Corrección — ¿los bugs están correctamente corregidos? ' .
                       '(3) Explicación — ¿explica qué causaba cada bug? ' .
                       '(4) Calidad — ¿la solución corregida es limpia y no introduce nuevos bugs? ' .
                       'Lista cada bug encontrado/no encontrado en el campo errors.';

            default:
                return $base . ' Evalúa la respuesta del estudiante comparándola con la solución de referencia. ' .
                       'Sé justo y constructivo.';
        }
    }

    private static function get_user_prompt(
        string $studentanswer,
        string $teachersolution,
        string $type
    ): string {
        $lang = '';
        if ($type === 'programming') {
            $lang = self::detect_language($studentanswer);
            $lang = $lang ? " (lenguaje detectado: $lang)" : '';
        }

        $labels = [
            'programming' => "CÓDIGO DEL ESTUDIANTE{$lang}",
            'math'        => 'SOLUCIÓN MATEMÁTICA DEL ESTUDIANTE',
            'essay'       => 'ENSAYO DEL ESTUDIANTE',
            'sql'         => 'CONSULTA SQL DEL ESTUDIANTE',
            'pseudocode'  => 'PSEUDOCÓDIGO DEL ESTUDIANTE',
            'debugging'   => 'CÓDIGO CORREGIDO POR EL ESTUDIANTE',
        ];
        $ref_labels = [
            'programming' => 'SOLUCIÓN DE REFERENCIA',
            'math'        => 'SOLUCIÓN CORRECTA DE REFERENCIA',
            'essay'       => 'PUNTOS CLAVE ESPERADOS',
            'sql'         => 'CONSULTA SQL DE REFERENCIA',
            'pseudocode'  => 'ALGORITMO DE REFERENCIA',
            'debugging'   => 'CÓDIGO ORIGINAL CON BUGS (para contexto)',
        ];

        $student_label = $labels[$type] ?? 'RESPUESTA DEL ESTUDIANTE';
        $ref_label     = $ref_labels[$type] ?? 'SOLUCIÓN DE REFERENCIA';

        return "{$ref_label}:\n```\n{$teachersolution}\n```\n\n" .
               "{$student_label}:\n```\n{$studentanswer}\n```\n\n" .
               "Evalúa y devuelve el JSON requerido.";
    }

    /**
     * Detecta el lenguaje de programación del código.
     */
    private static function detect_language(string $code): string {
        if (preg_match('/\bdef\s+\w+\s*\(|^\s*import\s+\w|^\s*from\s+\w+\s+import/m', $code)) return 'Python';
        if (preg_match('/\bpublic\s+class\b|\bSystem\.out\.print|\bimport\s+java\./m', $code)) return 'Java';
        if (preg_match('/\bconsole\.log\b|\bconst\b|\blet\b|=>\s*[{(]/m', $code)) return 'JavaScript';
        if (preg_match('/\b#include\b|\bprintf\s*\(|\bint\s+main\s*\(/m', $code)) return 'C/C++';
        if (preg_match('/<\?php|\$\w+\s*=/', $code)) return 'PHP';
        if (preg_match('/\bSELECT\b|\bFROM\b|\bWHERE\b/i', $code)) return 'SQL';
        return '';
    }

    // ─────────────────────────────────────────────────────────────────────
    // LLAMADA A OPENAI CON REINTENTOS
    // ─────────────────────────────────────────────────────────────────────

    private static function call_openai_api(
        string $apikey,
        string $model,
        string $systemprompt,
        string $userprompt
    ): array {
        $url  = 'https://api.openai.com/v1/chat/completions';
        $data = [
            'model'           => $model,
            'messages'        => [
                ['role' => 'system', 'content' => $systemprompt],
                ['role' => 'user',   'content' => $userprompt],
            ],
            'temperature'     => 0.2,
            'response_format' => ['type' => 'json_object'],
        ];

        $options = [
            'CURLOPT_RETURNTRANSFER' => true,
            'CURLOPT_HTTPHEADER'     => [
                'Content-Type: application/json',
                'Authorization: Bearer ' . $apikey,
            ],
        ];

        $maxretries = (int)(get_config('mod_aiassignment', 'openai_retries') ?: 2);
        $lasterror  = null;

        for ($attempt = 1; $attempt <= $maxretries; $attempt++) {
            try {
                $curl     = new \curl();
                $response = $curl->post($url, json_encode($data), $options);

                if ($curl->get_errno()) {
                    throw new \Exception('cURL Error: ' . $curl->error);
                }

                $result = json_decode($response, true);

                if (isset($result['error'])) {
                    $code = $result['error']['code'] ?? '';
                    if ($attempt < $maxretries && in_array($code, ['rate_limit_exceeded', 'server_error'])) {
                        sleep(2 * $attempt); // backoff exponencial
                        continue;
                    }
                    throw new \Exception('OpenAI API Error: ' . $result['error']['message']);
                }

                if (!isset($result['choices'][0]['message']['content'])) {
                    throw new \Exception('Invalid API response structure');
                }

                $content = json_decode($result['choices'][0]['message']['content'], true);

                if (!isset($content['similarity_score'])) {
                    throw new \Exception('Missing similarity_score in response');
                }

                return [
                    'similarity_score' => min(100, max(0, floatval($content['similarity_score']))),
                    'feedback'         => $content['feedback'] ?? '',
                    'analysis'         => $content['analysis'] ?? '',
                    'confidence'       => min(100, max(0, intval($content['confidence'] ?? 80))),
                    'errors'           => is_array($content['errors'] ?? null) ? $content['errors'] : [],
                ];

            } catch (\Exception $e) {
                $lasterror = $e;
                if ($attempt < $maxretries) {
                    sleep(2 * $attempt);
                }
            }
        }

        throw $lasterror;
    }

    // ─────────────────────────────────────────────────────────────────────
    // MODO DEMO (sin API)
    // ─────────────────────────────────────────────────────────────────────

    private static function demo_evaluate(
        string $studentanswer,
        string $teachersolution,
        string $type
    ): array {
        $score    = self::calculate_demo_score($studentanswer, $teachersolution, $type);
        $feedback = self::generate_demo_feedback($score, $type);
        $analysis = self::generate_demo_analysis($studentanswer, $type, $score);
        $errors   = self::generate_demo_errors($studentanswer, $type, $score);

        return [
            'similarity_score' => $score,
            'feedback'         => $feedback,
            'analysis'         => $analysis,
            'confidence'       => 60, // demo siempre baja confianza
            'errors'           => $errors,
        ];
    }

    private static function calculate_demo_score(
        string $studentanswer,
        string $teachersolution,
        string $type
    ): float {
        $studentlen = strlen(trim($studentanswer));
        $teacherlen = strlen(trim($teachersolution));

        $lengthratio = min($studentlen, $teacherlen) / max($studentlen, $teacherlen, 1);
        $basescore   = $lengthratio * 50;

        // Palabras clave por tipo
        $keywords_map = [
            'programming' => ['def', 'function', 'return', 'if', 'for', 'while', 'class', 'import'],
            'math'        => ['=', '+', '-', '×', '÷', 'resultado', 'solución', 'por lo tanto'],
            'essay'       => ['porque', 'por lo tanto', 'en conclusión', 'además', 'sin embargo'],
            'sql'         => ['SELECT', 'FROM', 'WHERE', 'JOIN', 'GROUP BY', 'ORDER BY'],
            'pseudocode'  => ['inicio', 'fin', 'si', 'entonces', 'mientras', 'para', 'retornar'],
            'debugging'   => ['error', 'bug', 'corregido', 'fix', 'arreglado', 'problema'],
        ];
        $keywords = $keywords_map[$type] ?? $keywords_map['programming'];
        $kw_count = 0;
        foreach ($keywords as $kw) {
            if (stripos($studentanswer, $kw) !== false) $kw_count++;
        }
        $basescore += $kw_count * 4;

        // Palabras comunes con la solución
        $tw = str_word_count(strtolower($teachersolution), 1);
        $sw = str_word_count(strtolower($studentanswer), 1);
        $basescore += min(count(array_intersect($tw, $sw)) * 2, 25);

        return round(min(95, max(55, $basescore)), 2);
    }

    private static function generate_demo_feedback(float $score, string $type): string {
        $type_labels = [
            'programming' => 'código',
            'math'        => 'solución matemática',
            'essay'       => 'ensayo',
            'sql'         => 'consulta SQL',
            'pseudocode'  => 'pseudocódigo',
            'debugging'   => 'corrección de bugs',
        ];
        $label = $type_labels[$type] ?? 'respuesta';

        if ($score >= 90) return "Excelente {$label}. Cumple todos los criterios esperados.";
        if ($score >= 80) return "Muy buen {$label}. Hay pequeñas áreas de mejora.";
        if ($score >= 70) return "Buen {$label}, aunque hay aspectos que necesitan revisión.";
        if ($score >= 60) return "El {$label} es parcialmente correcto. Revisa los puntos clave.";
        return "El {$label} necesita mejoras significativas. Revisa la lógica y estructura.";
    }

    private static function generate_demo_analysis(
        string $studentanswer,
        string $type,
        float $score
    ): string {
        $lines = substr_count($studentanswer, "\n") + 1;
        $chars = strlen($studentanswer);

        $analysis = "⚠️ MODO DEMO — Evaluación simulada (sin OpenAI API)\n\n";
        $analysis .= "Métricas básicas:\n";
        $analysis .= "- Longitud: {$chars} caracteres, {$lines} líneas\n";
        $analysis .= "- Calificación estimada: {$score}%\n\n";

        switch ($type) {
            case 'programming':
                $analysis .= "Análisis de código:\n";
                $analysis .= "- Estructura: " . ($score >= 80 ? "✅ Adecuada" : "⚠️ Necesita mejoras") . "\n";
                $analysis .= "- Lógica: " . ($score >= 75 ? "✅ Funcional" : "⚠️ Revisar") . "\n";
                $analysis .= "- Estilo: " . ($score >= 70 ? "✅ Aceptable" : "⚠️ Mejorar") . "\n";
                break;
            case 'math':
                $analysis .= "Análisis matemático:\n";
                $analysis .= "- Procedimiento: " . ($score >= 80 ? "✅ Correcto" : "⚠️ Revisar pasos") . "\n";
                $analysis .= "- Resultado: " . ($score >= 75 ? "✅ Adecuado" : "⚠️ Verificar") . "\n";
                break;
            case 'sql':
                $analysis .= "Análisis SQL:\n";
                $analysis .= "- Sintaxis: " . ($score >= 80 ? "✅ Válida" : "⚠️ Revisar") . "\n";
                $analysis .= "- Lógica: " . ($score >= 75 ? "✅ Correcta" : "⚠️ Verificar") . "\n";
                break;
            default:
                $analysis .= "Análisis general:\n";
                $analysis .= "- Contenido: " . ($score >= 80 ? "✅ Completo" : "⚠️ Incompleto") . "\n";
                $analysis .= "- Calidad: " . ($score >= 75 ? "✅ Buena" : "⚠️ Mejorar") . "\n";
        }

        $analysis .= "\nPara evaluación real, configura la OpenAI API Key en Administración del sitio → Plugins → Módulos de actividad → AI Assignment.";
        return $analysis;
    }

    private static function generate_demo_errors(
        string $studentanswer,
        string $type,
        float $score
    ): array {
        if ($score >= 85) return [];

        $errors = [];
        if ($type === 'programming') {
            if (!preg_match('/\breturn\b/', $studentanswer)) {
                $errors[] = ['line' => 'Función principal', 'issue' => 'Posible falta de return', 'suggestion' => 'Asegúrate de retornar el valor esperado'];
            }
            if (preg_match('/\bprint\b.*\bprint\b/s', $studentanswer)) {
                $errors[] = ['line' => 'Salida', 'issue' => 'Múltiples prints detectados', 'suggestion' => 'Consolida la salida en un solo punto'];
            }
        } elseif ($type === 'sql') {
            if (!preg_match('/\bSELECT\b/i', $studentanswer)) {
                $errors[] = ['line' => 'Consulta', 'issue' => 'Falta cláusula SELECT', 'suggestion' => 'Toda consulta de selección debe comenzar con SELECT'];
            }
        }
        return $errors;
    }

    // ─────────────────────────────────────────────────────────────────────
    // MÉTODO PÚBLICO: RENDERIZAR ERRORES EN HTML
    // ─────────────────────────────────────────────────────────────────────

    /**
     * Renderiza la lista de errores específicos en HTML.
     */
    public static function render_errors(array $errors): string {
        if (empty($errors)) return '';

        $html  = '<div class="eval-errors" style="margin-top:12px;">';
        $html .= '<h5 style="font-size:13px;color:#dc3545;margin-bottom:8px;">🐛 Errores / Problemas detectados</h5>';
        foreach ($errors as $err) {
            $html .= '<div style="background:#fff5f5;border-left:3px solid #dc3545;padding:8px 12px;margin-bottom:6px;border-radius:0 6px 6px 0;font-size:13px;">';
            if (!empty($err['line'])) {
                $html .= '<div style="font-weight:600;color:#dc3545;">' . htmlspecialchars($err['line']) . '</div>';
            }
            if (!empty($err['issue'])) {
                $html .= '<div style="color:#555;margin-top:2px;">⚠️ ' . htmlspecialchars($err['issue']) . '</div>';
            }
            if (!empty($err['suggestion'])) {
                $html .= '<div style="color:#28a745;margin-top:2px;">💡 ' . htmlspecialchars($err['suggestion']) . '</div>';
            }
            $html .= '</div>';
        }
        $html .= '</div>';
        return $html;
    }

    /**
     * Renderiza el badge de confianza de la evaluación.
     */
    public static function render_confidence(int $confidence): string {
        $color = $confidence >= 80 ? '#28a745' : ($confidence >= 60 ? '#ffc107' : '#dc3545');
        $label = $confidence >= 80 ? 'Alta' : ($confidence >= 60 ? 'Media' : 'Baja');
        return '<span style="background:' . $color . ';color:#fff;padding:2px 8px;border-radius:12px;font-size:11px;font-weight:600;">' .
               'Confianza: ' . $label . ' (' . $confidence . '%)' .
               '</span>';
    }
}
