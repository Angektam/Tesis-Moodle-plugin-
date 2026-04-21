<?php
// This file is part of Moodle - http://moodle.org/

namespace mod_aiassignment;

defined('MOODLE_INTERNAL') || die();

/**
 * Analizador de complejidad algorítmica.
 * Mejora #7: Detecta O(n), O(n²), O(log n), etc.
 */
class complexity_analyzer {

    /**
     * Analiza la complejidad del código y devuelve estimación + feedback.
     *
     * @param string $code
     * @return array ['time' => 'O(n)', 'space' => 'O(1)', 'feedback' => '...', 'score_bonus' => int]
     */
    public static function analyze(string $code): array {
        $loops        = self::count_nested_loops($code);
        $recursion    = self::detect_recursion($code);
        $sorting      = self::detect_sorting_algorithm($code);
        $binary_search = self::detect_binary_search($code);
        $memoization  = self::detect_memoization($code);
        $space        = self::estimate_space($code);

        // Determinar complejidad temporal
        if ($sorting === 'merge_sort' || $sorting === 'quick_sort') {
            $time_complexity = 'O(n log n)';
            $time_label      = '🟢 Eficiente';
            $score_bonus     = 10;
        } elseif ($binary_search) {
            $time_complexity = 'O(log n)';
            $time_label      = '🟢 Muy eficiente';
            $score_bonus     = 15;
        } elseif ($recursion && $memoization) {
            $time_complexity = 'O(n)';
            $time_label      = '🟢 Eficiente (memoización)';
            $score_bonus     = 10;
        } elseif ($loops['max_depth'] === 0 && !$recursion) {
            $time_complexity = 'O(1)';
            $time_label      = '🟢 Constante';
            $score_bonus     = 5;
        } elseif ($loops['max_depth'] === 1 || ($recursion && !$memoization && $loops['max_depth'] <= 1)) {
            $time_complexity = 'O(n)';
            $time_label      = '🟢 Lineal';
            $score_bonus     = 5;
        } elseif ($loops['max_depth'] === 2) {
            $time_complexity = 'O(n²)';
            $time_label      = '🟡 Cuadrática';
            $score_bonus     = 0;
        } elseif ($loops['max_depth'] >= 3) {
            $time_complexity = 'O(n³)';
            $time_label      = '🔴 Cúbica — considera optimizar';
            $score_bonus     = -5;
        } else {
            $time_complexity = 'O(n)';
            $time_label      = '🟢 Lineal (estimado)';
            $score_bonus     = 0;
        }

        // Feedback
        $feedback = self::build_feedback($time_complexity, $loops, $recursion, $memoization, $sorting);

        return [
            'time_complexity' => $time_complexity,
            'time_label'      => $time_label,
            'space_complexity' => $space,
            'nested_loops'    => $loops['max_depth'],
            'has_recursion'   => $recursion,
            'has_memoization' => $memoization,
            'sorting_algo'    => $sorting,
            'feedback'        => $feedback,
            'score_bonus'     => $score_bonus,
        ];
    }

    /**
     * Cuenta la profundidad máxima de bucles anidados.
     */
    private static function count_nested_loops(string $code): array {
        $loop_keywords = ['for', 'while', 'do'];
        $lines         = explode("\n", $code);
        $depth         = 0;
        $max_depth     = 0;
        $total_loops   = 0;

        foreach ($lines as $line) {
            $stripped = trim($line);
            foreach ($loop_keywords as $kw) {
                if (preg_match('/\b' . $kw . '\b\s*[\(\:]/', $stripped)) {
                    $depth++;
                    $total_loops++;
                    $max_depth = max($max_depth, $depth);
                }
            }
            // Detectar fin de bloque (simplificado)
            if (preg_match('/^(end|done|\})\s*$/', $stripped) || $stripped === '}') {
                $depth = max(0, $depth - 1);
            }
        }

        return ['max_depth' => $max_depth, 'total' => $total_loops];
    }

    /**
     * Detecta si hay recursión (función que se llama a sí misma).
     */
    private static function detect_recursion(string $code): bool {
        // Buscar definición de función
        if (preg_match('/\b(?:def|function|void|int|float)\s+(\w+)\s*\(/', $code, $m)) {
            $fname = $m[1];
            // Contar cuántas veces aparece el nombre de la función
            return substr_count($code, $fname . '(') > 1;
        }
        return false;
    }

    /**
     * Detecta algoritmos de ordenamiento conocidos.
     */
    private static function detect_sorting_algorithm(string $code): ?string {
        $code_lower = strtolower($code);

        if (strpos($code_lower, 'merge_sort') !== false || strpos($code_lower, 'mergesort') !== false ||
            (strpos($code_lower, 'merge') !== false && strpos($code_lower, 'mid') !== false)) {
            return 'merge_sort';
        }
        if (strpos($code_lower, 'quick_sort') !== false || strpos($code_lower, 'quicksort') !== false ||
            (strpos($code_lower, 'pivot') !== false)) {
            return 'quick_sort';
        }
        if (strpos($code_lower, 'bubble') !== false) {
            return 'bubble_sort';
        }
        if (strpos($code_lower, 'insertion') !== false || strpos($code_lower, 'insercion') !== false) {
            return 'insertion_sort';
        }
        if (strpos($code_lower, 'selection') !== false || strpos($code_lower, 'seleccion') !== false) {
            return 'selection_sort';
        }
        return null;
    }

    /**
     * Detecta búsqueda binaria.
     */
    private static function detect_binary_search(string $code): bool {
        $code_lower = strtolower($code);
        return strpos($code_lower, 'binary') !== false ||
               strpos($code_lower, 'binaria') !== false ||
               (strpos($code_lower, 'mid') !== false && strpos($code_lower, 'low') !== false && strpos($code_lower, 'high') !== false);
    }

    /**
     * Detecta memoización (caché de resultados).
     */
    private static function detect_memoization(string $code): bool {
        $code_lower = strtolower($code);
        return strpos($code_lower, 'memo') !== false ||
               strpos($code_lower, 'cache') !== false ||
               strpos($code_lower, 'dp[') !== false ||
               strpos($code_lower, 'lru') !== false ||
               preg_match('/\{\s*\}|\[\s*\]/', $code) && strpos($code_lower, 'return') !== false;
    }

    /**
     * Estima complejidad espacial.
     */
    private static function estimate_space(string $code): string {
        // Detectar estructuras de datos que crecen con n
        $has_list  = preg_match('/\[\s*\]|new\s+\w+\[|ArrayList|vector</', $code);
        $has_dict  = preg_match('/\{\s*\}|HashMap|dict\(/', $code);
        $has_matrix = preg_match('/\[\s*\[|\[\s*0\s*\]\s*\*/', $code);

        if ($has_matrix) return 'O(n²)';
        if ($has_list || $has_dict) return 'O(n)';
        return 'O(1)';
    }

    /**
     * Construye feedback textual sobre la complejidad.
     */
    private static function build_feedback(
        string $complexity, array $loops, bool $recursion, bool $memo, ?string $sorting
    ): string {
        $fb = "Complejidad temporal estimada: **$complexity**\n\n";

        if ($sorting) {
            $names = [
                'merge_sort'     => 'Merge Sort (O(n log n))',
                'quick_sort'     => 'Quick Sort (O(n log n) promedio)',
                'bubble_sort'    => 'Bubble Sort (O(n²))',
                'insertion_sort' => 'Insertion Sort (O(n²))',
                'selection_sort' => 'Selection Sort (O(n²))',
            ];
            $fb .= "Se detectó el algoritmo: " . ($names[$sorting] ?? $sorting) . "\n";
        }

        if ($loops['max_depth'] >= 2) {
            $fb .= "⚠️ Se detectaron {$loops['max_depth']} niveles de bucles anidados. ";
            $fb .= "Considera si es posible reducir la complejidad.\n";
        }

        if ($recursion && !$memo) {
            $fb .= "💡 Usas recursión sin memoización. Si hay subproblemas repetidos, ";
            $fb .= "considera agregar caché para mejorar a O(n).\n";
        }

        if ($recursion && $memo) {
            $fb .= "✅ Excelente uso de memoización con recursión.\n";
        }

        if ($complexity === 'O(1)') {
            $fb .= "✅ Solución de tiempo constante — muy eficiente.\n";
        }

        return trim($fb);
    }

    /**
     * Renderiza el análisis en HTML.
     */
    public static function render(array $analysis): string {
        $time_color = match(true) {
            str_contains($analysis['time_complexity'], 'O(1)')      => '#28a745',
            str_contains($analysis['time_complexity'], 'O(log')     => '#28a745',
            str_contains($analysis['time_complexity'], 'O(n log')   => '#17a2b8',
            str_contains($analysis['time_complexity'], 'O(n)')      => '#17a2b8',
            str_contains($analysis['time_complexity'], 'O(n²)')     => '#ffc107',
            default                                                  => '#dc3545',
        };

        $html  = '<div class="complexity-analysis" style="background:#f8f9fa;border-radius:8px;padding:14px;margin-top:12px;">';
        $html .= '<h5 style="margin:0 0 10px;font-size:14px;">⚡ Análisis de Complejidad</h5>';
        $html .= '<div style="display:flex;gap:16px;flex-wrap:wrap;margin-bottom:10px;">';

        $html .= '<div style="text-align:center;">';
        $html .= '<div style="font-size:20px;font-weight:700;color:' . $time_color . ';">' .
                 htmlspecialchars($analysis['time_complexity']) . '</div>';
        $html .= '<div style="font-size:11px;color:#666;">Tiempo</div></div>';

        $html .= '<div style="text-align:center;">';
        $html .= '<div style="font-size:20px;font-weight:700;color:#6c757d;">' .
                 htmlspecialchars($analysis['space_complexity']) . '</div>';
        $html .= '<div style="font-size:11px;color:#666;">Espacio</div></div>';

        $html .= '<div style="text-align:center;">';
        $html .= '<div style="font-size:14px;font-weight:600;">' . $analysis['time_label'] . '</div>';
        $html .= '<div style="font-size:11px;color:#666;">Evaluación</div></div>';

        $html .= '</div>';

        if (!empty($analysis['feedback'])) {
            $html .= '<div style="font-size:13px;color:#555;line-height:1.6;">';
            $html .= nl2br(htmlspecialchars($analysis['feedback']));
            $html .= '</div>';
        }

        if ($analysis['score_bonus'] > 0) {
            $html .= '<div style="margin-top:8px;font-size:12px;color:#28a745;font-weight:600;">+' .
                     $analysis['score_bonus'] . ' puntos bonus por eficiencia</div>';
        } elseif ($analysis['score_bonus'] < 0) {
            $html .= '<div style="margin-top:8px;font-size:12px;color:#dc3545;font-weight:600;">' .
                     $analysis['score_bonus'] . ' puntos por complejidad alta</div>';
        }

        $html .= '</div>';
        return $html;
    }
}
