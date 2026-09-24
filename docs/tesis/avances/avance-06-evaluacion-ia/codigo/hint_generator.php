<?php
namespace mod_aiassignment;
defined('MOODLE_INTERNAL') || die();

/**
 * Generador de pistas progresivas.
 * Mejora #1: Después de N intentos fallidos, genera una pista sin dar la solución.
 */
class hint_generator {

    const HINT_LEVELS = [
        1 => 'conceptual',   // Pista conceptual (qué enfoque usar)
        2 => 'structural',   // Pista estructural (cómo organizar el código)
        3 => 'specific',     // Pista específica (qué función/método usar)
    ];

    /**
     * Genera una pista para el estudiante según el número de intentos.
     *
     * @param string $problem_description  Descripción del problema
     * @param string $student_answer       Último intento del estudiante
     * @param string $type                 Tipo de problema
     * @param int    $attempt_number       Número de intento actual
     * @return array ['hint' => string, 'level' => int, 'label' => string]
     */
    public static function generate(
        string $problem_description,
        string $student_answer,
        string $type,
        int $attempt_number
    ): array {
        $level = min($attempt_number, 3);
        $hint_type = self::HINT_LEVELS[$level] ?? 'conceptual';

        $apikey   = get_config('mod_aiassignment', 'openai_api_key');
        $demomode = get_config('mod_aiassignment', 'demo_mode');

        if (empty($apikey) || $demomode) {
            return self::demo_hint($hint_type, $attempt_number);
        }

        return self::generate_with_ai($problem_description, $student_answer, $hint_type, $apikey);
    }

    private static function generate_with_ai(
        string $problem, string $answer, string $hint_type, string $apikey
    ): array {
        $model = get_config('mod_aiassignment', 'openai_model') ?: 'gpt-4o-mini';

        $instructions = [
            'conceptual'  => 'Da una pista CONCEPTUAL: explica qué enfoque o estrategia debería usar el estudiante. NO des código ni la solución.',
            'structural'  => 'Da una pista ESTRUCTURAL: explica cómo organizar el código (qué estructuras de control usar). NO des código completo.',
            'specific'    => 'Da una pista ESPECÍFICA: menciona qué función, método o técnica concreta debería usar. Puedes dar un fragmento pequeño de código como ejemplo.',
        ];

        $labels = [
            'conceptual'  => '💡 Pista conceptual',
            'structural'  => '🔧 Pista estructural',
            'specific'    => '🎯 Pista específica',
        ];

        $system = 'Eres un tutor de programación. Tu objetivo es guiar al estudiante sin darle la solución completa. ' .
                  $instructions[$hint_type] . ' Responde en español, máximo 3 oraciones.';

        $user = "PROBLEMA:\n$problem\n\nÚLTIMO INTENTO DEL ESTUDIANTE:\n$answer\n\nGenera la pista.";

        try {
            $curl = new \curl();
            $response = $curl->post(
                'https://api.openai.com/v1/chat/completions',
                json_encode([
                    'model'       => $model,
                    'messages'    => [
                        ['role' => 'system', 'content' => $system],
                        ['role' => 'user',   'content' => $user],
                    ],
                    'temperature' => 0.7,
                    'max_tokens'  => 200,
                ]),
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
            $hint    = $result['choices'][0]['message']['content'] ?? '';

            return [
                'hint'  => trim($hint),
                'level' => array_search($hint_type, self::HINT_LEVELS),
                'label' => $labels[$hint_type],
            ];
        } catch (\Exception $e) {
            return self::demo_hint($hint_type, 1);
        }
    }

    private static function demo_hint(string $hint_type, int $attempt): array {
        $hints = [
            'conceptual'  => 'Piensa en qué estructura de datos o algoritmo es más adecuado para este problema. ¿Necesitas iterar, recursión o una fórmula directa?',
            'structural'  => 'Considera dividir el problema en partes más pequeñas. ¿Qué condiciones base necesitas manejar primero?',
            'specific'    => 'Revisa si estás manejando correctamente los casos borde (valores 0, negativos, listas vacías). Prueba con ejemplos simples primero.',
        ];
        $labels = [
            'conceptual' => '💡 Pista conceptual',
            'structural' => '🔧 Pista estructural',
            'specific'   => '🎯 Pista específica',
        ];
        return [
            'hint'  => $hints[$hint_type] ?? $hints['conceptual'],
            'level' => $attempt,
            'label' => $labels[$hint_type] ?? $labels['conceptual'],
        ];
    }

    /**
     * Renderiza la pista en HTML para mostrar al estudiante.
     */
    public static function render(array $hint): string {
        $colors = [1 => '#17a2b8', 2 => '#ffc107', 3 => '#fd7e14'];
        $color  = $colors[$hint['level']] ?? '#17a2b8';

        return '<div class="hint-box" style="border-left:4px solid ' . $color . ';background:#f8f9fa;' .
               'border-radius:0 8px 8px 0;padding:12px 16px;margin:12px 0;">' .
               '<div style="font-weight:700;color:' . $color . ';margin-bottom:6px;font-size:13px;">' .
               htmlspecialchars($hint['label']) . '</div>' .
               '<div style="font-size:14px;color:#333;line-height:1.6;">' .
               nl2br(htmlspecialchars($hint['hint'])) . '</div>' .
               '</div>';
    }
}
