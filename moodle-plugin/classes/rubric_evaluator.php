<?php
// This file is part of Moodle - http://moodle.org/

namespace mod_aiassignment;

defined('MOODLE_INTERNAL') || die();

/**
 * Evaluador con rúbricas personalizables.
 * Mejora #8: Rúbricas — el profesor define pesos por criterio.
 */
class rubric_evaluator {

    /**
     * Rúbrica por defecto para programación.
     */
    public static function default_rubric_programming(): array {
        return [
            'funcionalidad'  => ['weight' => 40, 'label' => 'Funcionalidad'],
            'estilo'         => ['weight' => 20, 'label' => 'Estilo y claridad'],
            'eficiencia'     => ['weight' => 20, 'label' => 'Eficiencia'],
            'documentacion'  => ['weight' => 20, 'label' => 'Documentación'],
        ];
    }

    /**
     * Rúbrica por defecto para matemáticas.
     */
    public static function default_rubric_math(): array {
        return [
            'correcto'       => ['weight' => 50, 'label' => 'Resultado correcto'],
            'procedimiento'  => ['weight' => 30, 'label' => 'Procedimiento'],
            'claridad'       => ['weight' => 20, 'label' => 'Claridad de explicación'],
        ];
    }

    /**
     * Evalúa con rúbrica usando OpenAI.
     * Devuelve score ponderado + desglose por criterio.
     *
     * @param string $studentanswer
     * @param string $teachersolution
     * @param string $type
     * @param array  $rubric  Rúbrica personalizada (o null para usar la por defecto)
     * @return array
     */
    public static function evaluate(
        string $studentanswer,
        string $teachersolution,
        string $type,
        ?array $rubric = null
    ): array {
        if ($rubric === null) {
            $rubric = $type === 'programming'
                ? self::default_rubric_programming()
                : self::default_rubric_math();
        }

        $apikey = get_config('mod_aiassignment', 'openai_api_key');
        $demomode = get_config('mod_aiassignment', 'demo_mode');

        if (empty($apikey) || $demomode) {
            return self::demo_evaluate($studentanswer, $teachersolution, $rubric);
        }

        return self::evaluate_with_openai($studentanswer, $teachersolution, $rubric, $apikey);
    }

    /**
     * Evaluación demo sin API.
     */
    private static function demo_evaluate(string $answer, string $solution, array $rubric): array {
        $breakdown = [];
        $total     = 0;

        foreach ($rubric as $key => $criterion) {
            // Score simulado basado en longitud y palabras comunes
            $sim = similar_text(strtolower($answer), strtolower($solution));
            $base = min(95, max(55, $sim / max(1, strlen($solution)) * 200));
            $score = round($base + rand(-10, 10));
            $score = min(100, max(0, $score));

            $breakdown[$key] = [
                'label'    => $criterion['label'],
                'weight'   => $criterion['weight'],
                'score'    => $score,
                'weighted' => round($score * $criterion['weight'] / 100, 2),
                'feedback' => self::score_to_feedback($score, $criterion['label']),
            ];
            $total += $score * $criterion['weight'] / 100;
        }

        return [
            'total_score' => round($total, 2),
            'breakdown'   => $breakdown,
            'feedback'    => 'Evaluación simulada (modo demo). Score: ' . round($total, 2) . '%',
            'rubric_used' => $rubric,
        ];
    }

    /**
     * Evaluación real con OpenAI usando rúbrica.
     */
    private static function evaluate_with_openai(
        string $answer,
        string $solution,
        array $rubric,
        string $apikey
    ): array {
        $model = get_config('mod_aiassignment', 'openai_model') ?: 'gpt-4o-mini';

        // Construir descripción de la rúbrica para el prompt
        $rubric_desc = '';
        foreach ($rubric as $key => $criterion) {
            $rubric_desc .= "- {$criterion['label']} (peso: {$criterion['weight']}%)\n";
        }

        // Construir JSON esperado
        $json_keys = '';
        foreach ($rubric as $key => $criterion) {
            $json_keys .= "\"$key\": {\"score\": 0-100, \"feedback\": \"texto\"}, ";
        }

        $system = "Eres un evaluador académico experto. Evalúa la respuesta del estudiante " .
                  "usando la siguiente rúbrica:\n$rubric_desc\n" .
                  "Responde SOLO en JSON con esta estructura exacta:\n" .
                  "{\"breakdown\": {{$json_keys}}, \"general_feedback\": \"texto\"}";

        $user = "SOLUCIÓN DE REFERENCIA:\n$solution\n\nRESPUESTA DEL ESTUDIANTE:\n$answer";

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

            $breakdown = [];
            $total     = 0;

            foreach ($rubric as $key => $criterion) {
                $item  = $content['breakdown'][$key] ?? ['score' => 70, 'feedback' => ''];
                $score = min(100, max(0, (int)($item['score'] ?? 70)));

                $breakdown[$key] = [
                    'label'    => $criterion['label'],
                    'weight'   => $criterion['weight'],
                    'score'    => $score,
                    'weighted' => round($score * $criterion['weight'] / 100, 2),
                    'feedback' => $item['feedback'] ?? '',
                ];
                $total += $score * $criterion['weight'] / 100;
            }

            return [
                'total_score' => round($total, 2),
                'breakdown'   => $breakdown,
                'feedback'    => $content['general_feedback'] ?? '',
                'rubric_used' => $rubric,
            ];

        } catch (\Exception $e) {
            return self::demo_evaluate($answer, $solution, $rubric);
        }
    }

    /**
     * Convierte score numérico a texto de feedback.
     */
    private static function score_to_feedback(int $score, string $criterion): string {
        if ($score >= 90) return "$criterion: Excelente.";
        if ($score >= 75) return "$criterion: Muy bien, con pequeñas áreas de mejora.";
        if ($score >= 60) return "$criterion: Aceptable, pero necesita mejorar.";
        return "$criterion: Necesita trabajo significativo.";
    }

    /**
     * Renderiza el desglose de rúbrica en HTML para mostrar al estudiante.
     */
    public static function render_breakdown(array $result): string {
        if (empty($result['breakdown'])) return '';

        $html  = '<div class="rubric-breakdown" style="margin-top:16px;">';
        $html .= '<h4 style="margin-bottom:12px;">📋 Desglose por criterio</h4>';
        $html .= '<table style="width:100%;border-collapse:collapse;font-size:14px;">';
        $html .= '<thead><tr style="background:#f8f9fa;">';
        $html .= '<th style="padding:8px;text-align:left;border:1px solid #dee2e6;">Criterio</th>';
        $html .= '<th style="padding:8px;text-align:center;border:1px solid #dee2e6;">Peso</th>';
        $html .= '<th style="padding:8px;text-align:center;border:1px solid #dee2e6;">Score</th>';
        $html .= '<th style="padding:8px;text-align:left;border:1px solid #dee2e6;">Feedback</th>';
        $html .= '</tr></thead><tbody>';

        foreach ($result['breakdown'] as $criterion) {
            $color = $criterion['score'] >= 80 ? '#28a745' :
                     ($criterion['score'] >= 60 ? '#ffc107' : '#dc3545');
            $html .= '<tr>';
            $html .= '<td style="padding:8px;border:1px solid #dee2e6;font-weight:600;">' .
                     htmlspecialchars($criterion['label']) . '</td>';
            $html .= '<td style="padding:8px;border:1px solid #dee2e6;text-align:center;">' .
                     $criterion['weight'] . '%</td>';
            $html .= '<td style="padding:8px;border:1px solid #dee2e6;text-align:center;">';
            $html .= '<span style="color:' . $color . ';font-weight:700;">' .
                     $criterion['score'] . '%</span>';
            $html .= '</td>';
            $html .= '<td style="padding:8px;border:1px solid #dee2e6;font-size:13px;color:#555;">' .
                     htmlspecialchars($criterion['feedback']) . '</td>';
            $html .= '</tr>';
        }

        $html .= '</tbody></table>';
        $html .= '<div style="text-align:right;margin-top:10px;font-size:16px;font-weight:700;">';
        $html .= 'Total: <span style="color:#1a73e8;">' . $result['total_score'] . '%</span>';
        $html .= '</div></div>';

        return $html;
    }
}
