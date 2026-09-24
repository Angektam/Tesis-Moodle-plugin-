<?php
// This file is part of Moodle - http://moodle.org/

namespace mod_aiassignment;

defined('MOODLE_INTERNAL') || die();

/**
 * Detector de código generado por IA (ChatGPT, Copilot, etc.)
 * Mejora #4: Detectar código generado por IA
 */
class ai_detector {

    /**
     * Analiza si el código fue probablemente generado por IA.
     * Usa heurísticas locales + OpenAI si está disponible.
     *
     * @param string $code Código a analizar
     * @param string $type Tipo: 'programming' | 'math'
     * @return array ['score' => 0-100, 'verdict' => string, 'signals' => array]
     */
    public static function detect(string $code, string $type = 'programming'): array {
        $signals = [];
        $score   = 0;

        // ── Heurísticas locales ───────────────────────────────────────────

        // 1. Comentarios excesivamente descriptivos (patrón IA)
        $comment_lines = preg_match_all('/(#[^\n]+|\/\/[^\n]+|\/\*[\s\S]*?\*\/)/', $code);
        $total_lines   = max(1, substr_count($code, "\n") + 1);
        $comment_ratio = $comment_lines / $total_lines;
        if ($comment_ratio > 0.55) {  // subido de 0.4 → 0.55 para reducir falsos positivos
            $signals[] = 'Ratio de comentarios muy alto (' . round($comment_ratio * 100) . '%)';
            $score += 15;  // reducido de 20 → 15
        }

        // 2. Docstrings perfectos con parámetros documentados (patrón GPT)
        if (preg_match('/"""[\s\S]{50,}Args:[\s\S]+Returns:/i', $code) ||
            preg_match('/"""[\s\S]{50,}Parameters:[\s\S]+Returns:/i', $code)) {
            $signals[] = 'Docstring con formato Args/Returns (patrón GPT)';
            $score += 25;
        }

        // 3. Nombres de variables extremadamente descriptivos (umbral subido)
        $long_vars = preg_match_all('/\b([a-z][a-z_]{18,})\b/', $code);  // 15 → 18 chars
        if ($long_vars > 4) {  // 3 → 4
            $signals[] = "Nombres de variables muy largos ($long_vars encontrados)";
            $score += 10;  // reducido de 15 → 10
        }

        // 4. Manejo de errores excesivo para código simple
        $try_count = preg_match_all('/\btry\b|\bexcept\b|\bcatch\b/', $code);
        if ($try_count > 3 && strlen($code) < 400) {  // 2 → 3, 500 → 400
            $signals[] = 'Manejo de errores excesivo para código corto';
            $score += 15;
        }

        // 5. Comentarios en inglés en código de estudiante hispanohablante
        $english_comments = preg_match_all('/(#|\/\/)\s*(This|The|We|Here|Note|Check|Handle|Return|Get|Set|Create|Update|Delete)\s/i', $code);
        if ($english_comments > 3) {  // 2 → 3
            $signals[] = "Comentarios en inglés ($english_comments) en contexto hispanohablante";
            $score += 10;
        }

        // 6. Estructura perfecta: imports → constantes → funciones → main
        $has_imports   = (bool)preg_match('/^(import|from|#include|using)/m', $code);
        $has_constants = (bool)preg_match('/^[A-Z_]{3,}\s*=/m', $code);
        $has_main      = (bool)preg_match('/if\s+__name__\s*==\s*[\'"]__main__[\'"]|int\s+main\s*\(/', $code);
        if ($has_imports && $has_constants && $has_main) {
            $signals[] = 'Estructura perfecta imports→constantes→main (patrón IA)';
            $score += 15;
        }

        // 7. Type hints completos en Python (raro en estudiantes principiantes — pero NO penalizar si el nivel es avanzado)
        $type_hints = preg_match_all('/def\s+\w+\s*\([^)]*:\s*\w+[^)]*\)\s*->\s*\w+/', $code);
        if ($type_hints > 2) {  // 1 → 2
            $signals[] = "Type hints completos en $type_hints funciones";
            $score += 8;  // reducido de 10 → 8
        }

        // 8. Código perfectamente formateado sin errores de indentación
        $indent_errors = preg_match_all('/^\t+ /m', $code); // mezcla tabs+espacios
        if ($indent_errors === 0 && strlen($code) > 200) {
            // No es señal por sí sola, pero suma contexto
        }

        // Normalizar score a 0-100
        $score = min(100, $score);

        // Veredicto — umbrales más estrictos para reducir falsos positivos
        if ($score >= 85) {
            $verdict = 'probable_ia';
            $label   = '🤖 Probable código IA';
        } elseif ($score >= 60) {
            $verdict = 'sospechoso_ia';
            $label   = '⚠️ Posiblemente asistido por IA';
        } else {
            $verdict = 'humano';
            $label   = '✅ Probablemente escrito por humano';
        }

        // ── Análisis con OpenAI si está disponible ────────────────────────
        $apikey = get_config('mod_aiassignment', 'openai_api_key');
        $ai_analysis = null;
        if (!empty($apikey) && $score >= 45) {  // 30 → 45
            $ai_analysis = self::analyze_with_openai($code, $apikey);
            if ($ai_analysis !== null) {
                // Combinar score local con score IA (60/40)
                $score = round($score * 0.4 + $ai_analysis['score'] * 0.6);
                if (!empty($ai_analysis['signals'])) {
                    $signals = array_merge($signals, $ai_analysis['signals']);
                }
                // Recalcular veredicto
                if ($score >= 85) {
                    $verdict = 'probable_ia';
                    $label   = '🤖 Probable código IA';
                } elseif ($score >= 60) {
                    $verdict = 'sospechoso_ia';
                    $label   = '⚠️ Posiblemente asistido por IA';
                } else {
                    $verdict = 'humano';
                    $label   = '✅ Probablemente escrito por humano';
                }
            }
        }

        return [
            'score'       => $score,
            'verdict'     => $verdict,
            'label'       => $label,
            'signals'     => $signals,
            'ai_analysis' => $ai_analysis,
        ];
    }

    /**
     * Analiza con OpenAI si el código fue generado por IA.
     */
    private static function analyze_with_openai(string $code, string $apikey): ?array {
        $model = get_config('mod_aiassignment', 'openai_model') ?: 'gpt-4o-mini';

        $system = 'Eres un experto en detectar código generado por IA (ChatGPT, Copilot, etc.) vs código escrito por estudiantes. ' .
                  'Analiza el código y responde SOLO en JSON: ' .
                  '{"score": 0-100, "verdict": "humano|sospechoso|ia_generado", "signals": ["señal1", "señal2"]}. ' .
                  'score=0 significa humano, score=100 significa claramente generado por IA.';

        $user = "Analiza si este código fue generado por IA:\n\n```\n$code\n```";

        try {
            $data = [
                'model'           => $model,
                'messages'        => [
                    ['role' => 'system', 'content' => $system],
                    ['role' => 'user',   'content' => $user],
                ],
                'temperature'     => 0.1,
                'response_format' => ['type' => 'json_object'],
                'max_tokens'      => 300,
            ];

            $curl = new \curl();
            $response = $curl->post(
                'https://api.openai.com/v1/chat/completions',
                json_encode($data),
                [
                    'CURLOPT_RETURNTRANSFER' => true,
                    'CURLOPT_HTTPHEADER'     => [
                        'Content-Type: application/json',
                        'Authorization: Bearer ' . $apikey,
                    ],
                    'CURLOPT_TIMEOUT' => 15,
                ]
            );

            $result  = json_decode($response, true);
            $content = json_decode($result['choices'][0]['message']['content'] ?? '{}', true);

            return [
                'score'   => (int)($content['score'] ?? 0),
                'verdict' => $content['verdict'] ?? 'unknown',
                'signals' => $content['signals'] ?? [],
            ];
        } catch (\Exception $e) {
            return null;
        }
    }
}
