<?php
// This file is part of Moodle - http://moodle.org/

namespace mod_aiassignment;

defined('MOODLE_INTERNAL') || die();

/**
 * Ejecutor de código real usando Judge0 API.
 * Mejora #1: Ejecución real de código contra test cases.
 */
class code_executor {

    // IDs de lenguajes en Judge0
    const LANGUAGES = [
        'python'     => 71,
        'javascript' => 63,
        'java'       => 62,
        'cpp'        => 54,
        'c'          => 50,
        'php'        => 68,
        'ruby'       => 72,
        'go'         => 60,
        'rust'       => 73,
        'typescript' => 74,
    ];

    /**
     * Ejecuta código contra test cases y devuelve resultados.
     *
     * @param string $code       Código del estudiante
     * @param string $language   Lenguaje de programación
     * @param array  $testcases  [['input' => '...', 'expected' => '...'], ...]
     * @return array
     */
    public static function run(string $code, string $language, array $testcases): array {
        $apikey = get_config('mod_aiassignment', 'judge0_api_key');
        $apiurl = get_config('mod_aiassignment', 'judge0_api_url') ?: 'https://judge0-ce.p.rapidapi.com';
        $apihost = get_config('mod_aiassignment', 'judge0_api_host') ?: 'judge0-ce.p.rapidapi.com';

        if (empty($apikey)) {
            return self::demo_run($code, $language, $testcases);
        }

        $lang_id = self::LANGUAGES[strtolower($language)] ?? 71;
        $results = [];
        $passed  = 0;

        foreach ($testcases as $i => $tc) {
            try {
                $result = self::execute_single($code, $lang_id, $tc['input'] ?? '', $apikey, $apiurl, $apihost);
                $actual   = trim($result['stdout'] ?? '');
                $expected = trim($tc['expected'] ?? '');
                $correct  = ($actual === $expected);

                if ($correct) $passed++;

                $results[] = [
                    'test_num'    => $i + 1,
                    'input'       => $tc['input'] ?? '',
                    'expected'    => $expected,
                    'actual'      => $actual,
                    'passed'      => $correct,
                    'time_ms'     => round(($result['time'] ?? 0) * 1000),
                    'memory_kb'   => $result['memory'] ?? 0,
                    'status'      => $result['status']['description'] ?? 'Unknown',
                    'stderr'      => $result['stderr'] ?? '',
                    'compile_err' => $result['compile_output'] ?? '',
                ];
            } catch (\Exception $e) {
                $results[] = [
                    'test_num'  => $i + 1,
                    'input'     => $tc['input'] ?? '',
                    'expected'  => $tc['expected'] ?? '',
                    'actual'    => '',
                    'passed'    => false,
                    'status'    => 'Error: ' . $e->getMessage(),
                    'time_ms'   => 0,
                    'memory_kb' => 0,
                    'stderr'    => $e->getMessage(),
                ];
            }
        }

        $total = count($testcases);
        $score = $total > 0 ? round($passed / $total * 100, 2) : 0;

        return [
            'results'  => $results,
            'passed'   => $passed,
            'total'    => $total,
            'score'    => $score,
            'language' => $language,
            'executed' => true,
        ];
    }

    /**
     * Ejecuta un solo test case en Judge0.
     */
    private static function execute_single(
        string $code, int $lang_id, string $stdin,
        string $apikey, string $apiurl, string $apihost
    ): array {
        $curl = curl_init();

        // Crear submission
        $payload = json_encode([
            'source_code' => base64_encode($code),
            'language_id' => $lang_id,
            'stdin'       => base64_encode($stdin),
            'cpu_time_limit' => 5,
            'memory_limit'   => 128000,
        ]);

        curl_setopt_array($curl, [
            CURLOPT_URL            => "$apiurl/submissions?base64_encoded=true&wait=false",
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_POST           => true,
            CURLOPT_POSTFIELDS     => $payload,
            CURLOPT_HTTPHEADER     => [
                'Content-Type: application/json',
                "X-RapidAPI-Key: $apikey",
                "X-RapidAPI-Host: $apihost",
            ],
            CURLOPT_TIMEOUT => 15,
        ]);

        $response = curl_exec($curl);
        $err      = curl_error($curl);
        curl_close($curl);

        if ($err) throw new \Exception("cURL error: $err");

        $data  = json_decode($response, true);
        $token = $data['token'] ?? null;
        if (!$token) throw new \Exception("No token received from Judge0");

        // Polling hasta obtener resultado
        for ($attempt = 0; $attempt < 10; $attempt++) {
            sleep(1);
            $curl = curl_init();
            curl_setopt_array($curl, [
                CURLOPT_URL            => "$apiurl/submissions/$token?base64_encoded=true",
                CURLOPT_RETURNTRANSFER => true,
                CURLOPT_HTTPHEADER     => [
                    "X-RapidAPI-Key: $apikey",
                    "X-RapidAPI-Host: $apihost",
                ],
                CURLOPT_TIMEOUT => 10,
            ]);
            $res = json_decode(curl_exec($curl), true);
            curl_close($curl);

            $status_id = $res['status']['id'] ?? 0;
            if ($status_id > 2) {
                return [
                    'status'         => $res['status'],
                    'stdout'         => $res['stdout'] ? base64_decode($res['stdout']) : '',
                    'stderr'         => $res['stderr'] ? base64_decode($res['stderr']) : '',
                    'compile_output' => $res['compile_output'] ? base64_decode($res['compile_output']) : '',
                    'time'           => $res['time'] ?? 0,
                    'memory'         => $res['memory'] ?? 0,
                ];
            }
        }

        throw new \Exception("Timeout esperando resultado de Judge0");
    }

    /**
     * Modo demo sin API: simula ejecución.
     */
    private static function demo_run(string $code, string $language, array $testcases): array {
        $results = [];
        $passed  = 0;

        foreach ($testcases as $i => $tc) {
            // Simulación: pasa si el código contiene palabras clave del lenguaje
            $keywords = ['def ', 'return', 'print', 'function', 'int ', 'void '];
            $has_code = false;
            foreach ($keywords as $kw) {
                if (stripos($code, $kw) !== false) { $has_code = true; break; }
            }
            $correct = $has_code && strlen($code) > 20;
            if ($correct) $passed++;

            $results[] = [
                'test_num'  => $i + 1,
                'input'     => $tc['input'] ?? '',
                'expected'  => $tc['expected'] ?? '',
                'actual'    => $correct ? ($tc['expected'] ?? 'output_simulado') : '',
                'passed'    => $correct,
                'time_ms'   => rand(10, 150),
                'memory_kb' => rand(1000, 5000),
                'status'    => $correct ? 'Accepted' : 'Wrong Answer',
                'stderr'    => '',
                'compile_err' => '',
                'demo'      => true,
            ];
        }

        $total = count($testcases);
        return [
            'results'  => $results,
            'passed'   => $passed,
            'total'    => $total,
            'score'    => $total > 0 ? round($passed / $total * 100, 2) : 0,
            'language' => $language,
            'executed' => false,
            'demo'     => true,
        ];
    }

    /**
     * Parsea test cases desde texto (formato: INPUT\n---\nEXPECTED).
     */
    public static function parse_testcases(string $raw): array {
        $cases = [];
        $blocks = preg_split('/\n\s*---+\s*\n/', trim($raw));
        foreach ($blocks as $block) {
            $parts = preg_split('/\n\s*=+\s*\n/', trim($block), 2);
            if (count($parts) === 2) {
                $cases[] = ['input' => trim($parts[0]), 'expected' => trim($parts[1])];
            } elseif (!empty(trim($block))) {
                // Sin input, solo expected
                $cases[] = ['input' => '', 'expected' => trim($block)];
            }
        }
        return $cases;
    }

    /**
     * Renderiza resultados de ejecución en HTML.
     */
    public static function render_results(array $run): string {
        if (empty($run['results'])) return '';

        $html  = '<div class="execution-results" style="margin-top:16px;">';
        $html .= '<h4 style="margin-bottom:12px;">🚀 Resultados de Ejecución</h4>';

        if (!empty($run['demo'])) {
            $html .= '<div class="alert alert-info" style="font-size:13px;margin-bottom:12px;">
                ⚠️ Modo demo — configura Judge0 API Key para ejecución real.
            </div>';
        }

        // Resumen
        $color = $run['score'] >= 80 ? '#28a745' : ($run['score'] >= 50 ? '#ffc107' : '#dc3545');
        $html .= '<div style="display:flex;gap:16px;margin-bottom:16px;flex-wrap:wrap;">';
        $html .= '<div style="background:#f8f9fa;border-radius:8px;padding:12px 20px;text-align:center;">';
        $html .= '<div style="font-size:24px;font-weight:700;color:' . $color . ';">' . $run['score'] . '%</div>';
        $html .= '<div style="font-size:12px;color:#666;">Score</div></div>';
        $html .= '<div style="background:#f8f9fa;border-radius:8px;padding:12px 20px;text-align:center;">';
        $html .= '<div style="font-size:24px;font-weight:700;color:#28a745;">' . $run['passed'] . '/' . $run['total'] . '</div>';
        $html .= '<div style="font-size:12px;color:#666;">Tests pasados</div></div>';
        $html .= '</div>';

        // Detalle por test
        foreach ($run['results'] as $r) {
            $icon  = $r['passed'] ? '✅' : '❌';
            $bg    = $r['passed'] ? '#f0fff4' : '#fff5f5';
            $border = $r['passed'] ? '#c3e6cb' : '#f5c6cb';

            $html .= '<div style="border:1px solid ' . $border . ';border-radius:8px;padding:12px;margin-bottom:8px;background:' . $bg . ';">';
            $html .= '<div style="font-weight:600;margin-bottom:6px;">' . $icon . ' Test ' . $r['test_num'];
            $html .= ' <span style="font-size:11px;color:#888;font-weight:400;">' . $r['time_ms'] . 'ms · ' . round($r['memory_kb'] / 1024, 1) . 'MB</span></div>';

            if (!empty($r['input'])) {
                $html .= '<div style="font-size:12px;margin-bottom:4px;"><strong>Input:</strong> <code>' . htmlspecialchars($r['input']) . '</code></div>';
            }
            $html .= '<div style="font-size:12px;margin-bottom:4px;"><strong>Esperado:</strong> <code>' . htmlspecialchars($r['expected']) . '</code></div>';
            $html .= '<div style="font-size:12px;margin-bottom:4px;"><strong>Obtenido:</strong> <code>' . htmlspecialchars($r['actual'] ?: '(vacío)') . '</code></div>';

            if (!empty($r['stderr'])) {
                $html .= '<div style="font-size:11px;color:#dc3545;margin-top:4px;"><strong>Error:</strong> ' . htmlspecialchars(substr($r['stderr'], 0, 200)) . '</div>';
            }
            if (!empty($r['compile_err'])) {
                $html .= '<div style="font-size:11px;color:#dc3545;margin-top:4px;"><strong>Compilación:</strong> ' . htmlspecialchars(substr($r['compile_err'], 0, 200)) . '</div>';
            }
            $html .= '</div>';
        }

        $html .= '</div>';
        return $html;
    }
}
