<?php
// This file is part of Moodle - http://moodle.org/

namespace mod_aiassignment\plagiarism;

defined('MOODLE_INTERNAL') || die();

/**
 * Capa 3: Análisis semántico con IA (OpenAI) para detección de plagio.
 * Detecta reescrituras lógicas y ofuscación avanzada.
 */
class semantic_analyzer {

    /**
     * Compara semánticamente dos fragmentos de código usando OpenAI.
     */
    public static function similarity(string $c1, string $c2): array {
        $apikey = get_config('mod_aiassignment', 'openai_api_key');
        if (empty($apikey)) {
            return ['score' => 0, 'analysis' => 'API key no configurada.', 'verdict' => 'unknown'];
        }

        // Rate limiting para llamadas a OpenAI (mejora #2)
        if (!self::check_api_rate_limit()) {
            return [
                'score' => 0,
                'analysis' => 'Límite de llamadas a la API alcanzado. Intente más tarde.',
                'verdict' => 'unknown',
            ];
        }

        $model = get_config('mod_aiassignment', 'openai_model') ?: 'gpt-4o-mini';

        $system = <<<PROMPT
Eres un experto en detección de plagio de código fuente para un sistema académico.
Tu tarea es analizar si dos fragmentos de código fueron escritos de forma independiente
o si uno es una copia/adaptación del otro.

Debes detectar técnicas de ofuscación como:
- Renombrado de variables o funciones
- Cambio de tipo de bucle (for ↔ while ↔ recursión)
- Reordenación de sentencias independientes
- Inserción de código muerto o comentarios falsos
- Cambio de operadores equivalentes (i++ ↔ i+=1 ↔ i=i+1)
- Refactorización superficial manteniendo la misma lógica

Responde ÚNICAMENTE en JSON con esta estructura:
{
  "similarity_score": <número 0-100>,
  "analysis": "<explicación en español de máximo 3 oraciones>",
  "techniques_found": ["técnica1", "técnica2"],
  "verdict": "original" | "sospechoso" | "plagio"
}
PROMPT;

        $user = "CÓDIGO A:\n```\n{$c1}\n```\n\nCÓDIGO B:\n```\n{$c2}\n```\n\n" .
                "Analiza si hay plagio considerando similitud semántica y lógica, no solo textual.";

        try {
            $data = [
                'model'           => $model,
                'messages'        => [
                    ['role' => 'system', 'content' => $system],
                    ['role' => 'user',   'content' => $user],
                ],
                'temperature'     => 0.2,
                'response_format' => ['type' => 'json_object'],
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
                ]
            );

            $result  = json_decode($response, true);
            $content = json_decode($result['choices'][0]['message']['content'] ?? '{}', true);

            // Registrar uso de API
            self::log_api_call();

            return [
                'score'      => floatval($content['similarity_score'] ?? 0),
                'analysis'   => $content['analysis'] ?? '',
                'techniques' => $content['techniques_found'] ?? [],
                'verdict'    => $content['verdict'] ?? 'unknown',
            ];
        } catch (\Exception $e) {
            return ['score' => 0, 'analysis' => 'Error IA: ' . $e->getMessage(), 'verdict' => 'unknown'];
        }
    }

    /**
     * Verifica rate limit de llamadas a OpenAI (mejora #2).
     * Máximo configurable de llamadas por hora (default 100).
     */
    private static function check_api_rate_limit(): bool {
        $cache = \cache::make('mod_aiassignment', 'plagiarism');
        $key = 'openai_api_calls_' . date('YmdH');
        $count = (int)$cache->get($key);
        $max = (int)(get_config('mod_aiassignment', 'openai_max_calls_per_hour') ?: 100);
        return $count < $max;
    }

    /**
     * Registra una llamada a la API para rate limiting.
     */
    private static function log_api_call(): void {
        $cache = \cache::make('mod_aiassignment', 'plagiarism');
        $key = 'openai_api_calls_' . date('YmdH');
        $count = (int)$cache->get($key);
        $cache->set($key, $count + 1);
    }
}
