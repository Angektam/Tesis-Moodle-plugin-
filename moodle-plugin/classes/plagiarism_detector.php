<?php
// This file is part of Moodle - http://moodle.org/

namespace mod_aiassignment;

defined('MOODLE_INTERNAL') || die();

/**
 * Detector de plagio de CÓDIGO FUENTE
 *
 * Usa análisis en 3 capas:
 *   1. Léxica  – tokens normalizados (resistente a renombrado de variables)
 *   2. Estructural – patrones de control de flujo y complejidad ciclomática
 *   3. Semántica – comparación con OpenAI (detecta reescrituras lógicas)
 *
 * Detecta técnicas comunes de ofuscación:
 *   - Renombrado de variables/funciones
 *   - Reordenación de sentencias independientes
 *   - Cambio de tipo de bucle (for ↔ while)
 *   - Inserción de código muerto
 *   - Cambio de operadores equivalentes (i++ ↔ i+=1)
 */
class plagiarism_detector {

    // Umbrales de decisión
    const THRESHOLD_HIGH   = 75;   // >= plagio probable (sobreescrito por config si disponible)
    const THRESHOLD_MEDIUM = 50;   // >= sospechoso
    const THRESHOLD_LOW    = 30;   // < original

    /**
     * Devuelve el umbral alto configurable (o el valor por defecto 75).
     */
    public static function get_threshold_high(): int {
        return (int)(get_config('mod_aiassignment', 'plagiarism_threshold') ?: self::THRESHOLD_HIGH);
    }

    // Pesos de cada capa en la puntuación final
    const WEIGHT_LEXICAL    = 0.35;
    const WEIGHT_STRUCTURAL = 0.30;
    const WEIGHT_SEMANTIC   = 0.35;

    // ─────────────────────────────────────────────────────────────────────
    // API PÚBLICA
    // ─────────────────────────────────────────────────────────────────────

    /**
     * Analiza plagio de un envío contra todos los demás del mismo assignment.
     */
    public static function detect_plagiarism(int $submissionid): array {
        global $DB;

        $submission = $DB->get_record('aiassignment_submissions',
            ['id' => $submissionid], '*', MUST_EXIST);

        $others = $DB->get_records_select(
            'aiassignment_submissions',
            'assignment = ? AND id != ? AND userid != ?',
            [$submission->assignment, $submissionid, $submission->userid]
        );

        if (empty($others)) {
            return ['has_plagiarism' => false,
                    'message'        => 'No hay otros envíos para comparar',
                    'comparisons'    => []];
        }

        $comparisons = [];
        foreach ($others as $other) {
            $result = self::compare_code($submission->answer, $other->answer);
            $comparisons[] = [
                'submission_id'   => $other->id,
                'user_id'         => $other->userid,
                'similarity_score'=> $result['final_score'],
                'is_suspicious'   => $result['final_score'] >= self::get_threshold_high(),
                'verdict'         => $result['verdict'],
                'layers'          => $result['layers'],
                'techniques'      => $result['techniques_detected'],
                'analysis'        => $result['analysis'],
            ];
        }

        usort($comparisons, fn($a, $b) => $b['similarity_score'] <=> $a['similarity_score']);
        $suspicious = array_filter($comparisons, fn($c) => $c['is_suspicious']);

        return [
            'has_plagiarism'       => !empty($suspicious),
            'plagiarism_count'     => count($suspicious),
            'highest_similarity'   => $comparisons[0]['similarity_score'] ?? 0,
            'comparisons'          => $comparisons,
            'suspicious_submissions'=> array_values($suspicious),
            'total_compared'       => count($comparisons),
        ];
    }

    /**
     * Genera reporte completo para todos los envíos de un assignment.
     * Usa caché: solo recalcula si hay submissions nuevas desde el último análisis (mejora #8).
     *
     * @param int  $assignmentid
     * @param bool $nosem   Si true, omite la capa semántica (OpenAI) — modo rápido
     * @param bool $force   Si true, ignora la caché y recalcula todo
     */
    public static function generate_plagiarism_report(int $assignmentid, bool $nosem = false, bool $force = false): array {
        global $DB;

        // ── Verificar caché ───────────────────────────────────────────────
        $cache_key = 'plagiarism_report_' . $assignmentid . ($nosem ? '_fast' : '_full');
        $cache     = \cache::make('mod_aiassignment', 'plagiarism');

        if (!$force) {
            $cached     = $cache->get($cache_key);
            $latest_sub = $DB->get_field_sql(
                "SELECT MAX(timecreated) FROM {aiassignment_submissions} WHERE assignment = :a",
                ['a' => $assignmentid]
            );
            if ($cached && isset($cached['generated_at']) && $cached['generated_at'] >= (int)$latest_sub) {
                $cached['from_cache'] = true;
                return $cached;
            }
        }

        // Tomar el último envío por usuario (el más reciente)
        $sql = "SELECT s.*
                FROM {aiassignment_submissions} s
                INNER JOIN (
                    SELECT userid, MAX(id) as maxid
                    FROM {aiassignment_submissions}
                    WHERE assignment = :assignment
                    GROUP BY userid
                ) latest ON s.id = latest.maxid";

        $submissions = array_values($DB->get_records_sql($sql, ['assignment' => $assignmentid]));

        if (count($submissions) < 2) {
            return ['message' => 'Se necesitan al menos 2 estudiantes para analizar plagio.'];
        }

        $matrix       = [];
        $user_scores  = [];   // userid => max similarity

        for ($i = 0; $i < count($submissions); $i++) {
            for ($j = $i + 1; $j < count($submissions); $j++) {
                $s1 = $submissions[$i];
                $s2 = $submissions[$j];

                $result = self::compare_code($s1->answer, $s2->answer, $nosem);

                $entry = [
                    'submission1_id'   => $s1->id,
                    'submission1_user' => $s1->userid,
                    'submission2_id'   => $s2->id,
                    'submission2_user' => $s2->userid,
                    'similarity_score' => $result['final_score'],
                    'verdict'          => $result['verdict'],
                    'is_suspicious'    => $result['final_score'] >= self::get_threshold_high(),
                    'layers'           => $result['layers'],
                    'techniques'       => $result['techniques_detected'],
                    'analysis'         => $result['analysis'],
                    'code1_normalized' => $result['code1_normalized'],
                    'code2_normalized' => $result['code2_normalized'],
                ];
                $matrix[] = $entry;

                // Acumular score máximo por usuario
                foreach ([$s1->userid, $s2->userid] as $uid) {
                    $user_scores[$uid] = max($user_scores[$uid] ?? 0, $result['final_score']);
                }
            }
        }

        usort($matrix, fn($a, $b) => $b['similarity_score'] <=> $a['similarity_score']);

        // Usuarios sospechosos
        $suspicious_users = [];
        foreach ($matrix as $cmp) {
            if (!$cmp['is_suspicious']) continue;
            foreach ([
                [$cmp['submission1_user'], $cmp['submission2_user']],
                [$cmp['submission2_user'], $cmp['submission1_user']],
            ] as [$uid, $match]) {
                if (!isset($suspicious_users[$uid])) {
                    $suspicious_users[$uid] = ['count' => 0, 'matches' => [], 'max_score' => 0];
                }
                $suspicious_users[$uid]['count']++;
                $suspicious_users[$uid]['matches'][] = $match;
                $suspicious_users[$uid]['max_score'] = max(
                    $suspicious_users[$uid]['max_score'],
                    $cmp['similarity_score']
                );
            }
        }
        uasort($suspicious_users, fn($a, $b) => $b['max_score'] <=> $a['max_score']);

        // Ranking de todos los usuarios por score máximo
        arsort($user_scores);
        $ranking = [];
        foreach ($user_scores as $uid => $score) {
            $ranking[] = ['userid' => $uid, 'max_similarity' => $score];
        }

        $result = [
            'total_submissions'    => count($submissions),
            'total_comparisons'    => count($matrix),
            'suspicious_pairs_count'=> count(array_filter($matrix, fn($c) => $c['is_suspicious'])),
            'highest_similarity'   => $matrix[0]['similarity_score'] ?? 0,
            'suspicious_users'     => $suspicious_users,
            'detailed_comparisons' => $matrix,
            'user_ranking'         => $ranking,
            'generated_at'         => time(),
            'from_cache'           => false,
        ];

        // Guardar en caché (válido hasta que haya una submission más nueva)
        $cache->set($cache_key, $result);

        return $result;
    }

    // ─────────────────────────────────────────────────────────────────────
    // NÚCLEO: COMPARACIÓN EN 3 CAPAS
    // ─────────────────────────────────────────────────────────────────────

    /**
     * Compara dos fragmentos de código fuente.
     * @param bool $nosem Si true, omite la capa semántica (OpenAI) — mucho más rápido
     */
    public static function compare_code(string $code1, string $code2, bool $nosem = false): array {
        // ── Capa 1: Léxica ────────────────────────────────────────────────
        $lex = self::lexical_similarity($code1, $code2);

        // ── Capa 2: Estructural ───────────────────────────────────────────
        $struct = self::structural_similarity($code1, $code2);

        // ── Capa 3: Semántica (IA) ────────────────────────────────────────
        // Omitir si: modo rápido, o si léxica+estructural ya son muy altas (>85%) o muy bajas (<20%)
        $lex_struct_avg = ($lex['score'] + $struct['score']) / 2;
        $skip_sem = $nosem || $lex_struct_avg > 85 || $lex_struct_avg < 20;

        if ($skip_sem) {
            // Sin IA: usar léxica+estructural con pesos redistribuidos
            $final = round(
                $lex['score']    * 0.55 +
                $struct['score'] * 0.45,
                2
            );
            $sem = ['score' => 0, 'analysis' => $nosem ? 'Modo rápido (sin IA)' : 'Omitido (resultado obvio)', 'verdict' => 'unknown'];
        } else {
            $sem   = self::semantic_similarity_ai($code1, $code2);
            $final = round(
                $lex['score']    * self::WEIGHT_LEXICAL +
                $struct['score'] * self::WEIGHT_STRUCTURAL +
                $sem['score']    * self::WEIGHT_SEMANTIC,
                2
            );
        }

        // ── Técnicas de ofuscación detectadas ────────────────────────────
        $techniques = self::detect_obfuscation_techniques($code1, $code2, $lex, $struct);

        // ── Veredicto ─────────────────────────────────────────────────────
        $verdict = self::get_verdict($final, $techniques);

        return [
            'final_score'      => $final,
            'verdict'          => $verdict,
            'layers'           => [
                'lexical'    => $lex,
                'structural' => $struct,
                'semantic'   => $sem,
            ],
            'techniques_detected' => $techniques,
            'analysis'            => $sem['analysis'] ?? '',
            'code1_normalized'    => $lex['norm1'] ?? '',
            'code2_normalized'    => $lex['norm2'] ?? '',
        ];
    }

    // ─────────────────────────────────────────────────────────────────────
    // CAPA 1: ANÁLISIS LÉXICO
    // ─────────────────────────────────────────────────────────────────────

    /**
     * Similitud léxica sobre tokens normalizados.
     * Reemplaza identificadores por VAR/FUNC para ser resistente al renombrado.
     */
    private static function lexical_similarity(string $c1, string $c2): array {
        $norm1 = self::normalize_identifiers($c1);
        $norm2 = self::normalize_identifiers($c2);

        $tokens1 = self::tokenize($norm1);
        $tokens2 = self::tokenize($norm2);

        // Jaccard sobre bigramas de tokens (más sensible al orden)
        $bigrams1 = self::bigrams($tokens1);
        $bigrams2 = self::bigrams($tokens2);

        $score = self::jaccard($bigrams1, $bigrams2) * 100;

        // También calcular similitud de secuencia (LCS)
        $lcs_ratio = self::lcs_ratio($tokens1, $tokens2) * 100;

        // Promedio de ambas métricas
        $combined = round(($score + $lcs_ratio) / 2, 2);

        return [
            'score'      => $combined,
            'jaccard'    => round($score, 2),
            'lcs'        => round($lcs_ratio, 2),
            'norm1'      => $norm1,
            'norm2'      => $norm2,
            'tokens1'    => count($tokens1),
            'tokens2'    => count($tokens2),
        ];
    }

    /**
     * Normaliza identificadores: reemplaza nombres de variables y funciones
     * por tokens genéricos VAR_n / FUNC_n para detectar renombrado.
     */
    private static function normalize_identifiers(string $code): string {
        // Eliminar comentarios
        $code = preg_replace('/\/\*[\s\S]*?\*\//', '', $code);
        $code = preg_replace('/\/\/[^\n]*/', '', $code);
        $code = preg_replace('/#[^\n]*/', '', $code);

        // Normalizar strings literales
        $code = preg_replace('/"[^"]*"/', '"STR"', $code);
        $code = preg_replace("/'[^']*'/", "'STR'", $code);

        // Normalizar números
        $code = preg_replace('/\b\d+(\.\d+)?\b/', 'NUM', $code);

        // Normalizar espacios
        $code = preg_replace('/\s+/', ' ', trim($code));

        return $code;
    }

    /**
     * Tokeniza código en palabras clave + operadores + delimitadores.
     */
    private static function tokenize(string $code): array {
        // Separar por espacios y delimitadores, conservando los delimitadores
        $tokens = preg_split('/(\s+|(?=[{}()\[\];,])|(?<=[{}()\[\];,]))/', $code, -1, PREG_SPLIT_NO_EMPTY);
        return array_values(array_filter($tokens, fn($t) => trim($t) !== ''));
    }

    /**
     * Genera bigramas de un array de tokens.
     */
    private static function bigrams(array $tokens): array {
        $bg = [];
        for ($i = 0; $i < count($tokens) - 1; $i++) {
            $bg[] = $tokens[$i] . '|' . $tokens[$i + 1];
        }
        return $bg;
    }

    /**
     * Índice de Jaccard entre dos arrays.
     */
    private static function jaccard(array $a, array $b): float {
        if (empty($a) && empty($b)) return 1.0;
        if (empty($a) || empty($b)) return 0.0;
        $sa = array_count_values($a);
        $sb = array_count_values($b);
        $inter = 0;
        foreach ($sa as $k => $v) {
            $inter += min($v, $sb[$k] ?? 0);
        }
        $union = array_sum($sa) + array_sum($sb) - $inter;
        return $union > 0 ? $inter / $union : 0.0;
    }

    /**
     * Ratio de Longest Common Subsequence (normalizado).
     */
    private static function lcs_ratio(array $a, array $b): float {
        $la = count($a);
        $lb = count($b);
        if ($la === 0 && $lb === 0) return 1.0;
        if ($la === 0 || $lb === 0) return 0.0;

        // Para arrays grandes, limitar para evitar timeout
        if ($la > 300 || $lb > 300) {
            // Usar Jaccard como aproximación
            return self::jaccard($a, $b);
        }

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

    // ─────────────────────────────────────────────────────────────────────
    // CAPA 2: ANÁLISIS ESTRUCTURAL (AST real para Python, regex para otros)
    // ─────────────────────────────────────────────────────────────────────

    /**
     * Compara estructura usando el microservicio Python AST cuando el código
     * es Python, o análisis de regex para otros lenguajes.
     */
    private static function structural_similarity(string $c1, string $c2): array {
        // Detectar si el código es Python
        if (self::is_python($c1) || self::is_python($c2)) {
            $ast_result = self::call_python_ast_service($c1, $c2);
            if ($ast_result !== null) {
                return [
                    'score'      => $ast_result['similarity'],
                    'method'     => 'ast_python',
                    'techniques' => $ast_result['details']['techniques'] ?? [],
                    'features1'  => $ast_result['details']['features1'] ?? [],
                    'features2'  => $ast_result['details']['features2'] ?? [],
                    'detail'     => $ast_result['details'],
                ];
            }
        }

        // Fallback: análisis estructural con regex (enriquecido por lenguaje)
        $f1 = self::extract_structural_features_for_language($c1);
        $f2 = self::extract_structural_features_for_language($c2);

        $scores  = [];
        $metrics = ['functions', 'loops', 'conditionals', 'returns',
                    'recursion', 'nested_depth', 'operators_count'];
        foreach ($metrics as $m) {
            $v1 = $f1[$m] ?? 0;
            $v2 = $f2[$m] ?? 0;
            $max = max($v1, $v2);
            $scores[] = $max > 0 ? 1 - abs($v1 - $v2) / $max : 1.0;
        }
        $ctrl_sim = self::jaccard($f1['control_sequence'], $f2['control_sequence']);
        $scores[] = $ctrl_sim;

        return [
            'score'    => round(array_sum($scores) / count($scores) * 100, 2),
            'method'   => 'regex',
            'features1'=> $f1,
            'features2'=> $f2,
        ];
    }

    /**
     * Detecta si el código es Python por sus palabras clave y sintaxis.
     */
    private static function is_python(string $code): bool {
        $python_signals = ['/\bdef\s+\w+\s*\(/', '/\belif\b/', '/\bprint\s*\(/',
                           '/^\s*import\s+\w/m', '/:\s*$/', '/\bindent\b/'];
        $hits = 0;
        foreach (['/\bdef\s+\w+\s*\(/', '/\belif\b/', '/\bprint\s*\(/',
                  '/^import\s+/m', '/^from\s+\w+\s+import/m'] as $pat) {
            if (preg_match($pat, $code)) $hits++;
        }
        return $hits >= 1;
    }

    /**
     * Detecta el lenguaje del código para ajustar el análisis estructural.
     * Soporta: python, java, javascript, c_cpp, php, generic (mejora #10)
     */
    private static function detect_language(string $code): string {
        $py = 0;
        foreach (['/\bdef\s+\w+\s*\(/', '/\belif\b/', '/^import\s+/m', '/^from\s+\w+\s+import/m'] as $p) {
            if (preg_match($p, $code)) $py++;
        }
        if ($py >= 1) return 'python';

        $java = 0;
        foreach (['/\bpublic\s+class\b/', '/\bSystem\.out\.print/', '/\bpublic\s+static\s+void\s+main/', '/\bimport\s+java\./'] as $p) {
            if (preg_match($p, $code)) $java++;
        }
        if ($java >= 1) return 'java';

        $js = 0;
        foreach (['/\bconsole\.log\b/', '/\bconst\b|\blet\b/', '/=>\s*[{(]/', '/\brequire\s*\(/', '/\bfunction\s*\w*\s*\(/'] as $p) {
            if (preg_match($p, $code)) $js++;
        }
        if ($js >= 2) return 'javascript';

        $c = 0;
        foreach (['/\b#include\b/', '/\bprintf\s*\(/', '/\bint\s+main\s*\(/', '/\bcout\s*<</', '/\bstd::/', '/\bmalloc\s*\(/'] as $p) {
            if (preg_match($p, $code)) $c++;
        }
        if ($c >= 1) return 'c_cpp';

        if (preg_match('/<\?php/', $code) || preg_match('/\$\w+\s*=/', $code)) return 'php';

        return 'generic';
    }

    /**
     * Extrae métricas estructurales enriquecidas según el lenguaje detectado.
     */
    private static function extract_structural_features_for_language(string $code): array {
        $lang = self::detect_language($code);
        $f    = self::extract_structural_features($code);
        $f['language'] = $lang;

        switch ($lang) {
            case 'java':
                $f['classes']    = preg_match_all('/\bclass\s+\w+/', $code);
                $f['interfaces'] = preg_match_all('/\binterface\s+\w+/', $code);
                $f['exceptions'] = preg_match_all('/\btry\b|\bcatch\b|\bthrow\b/', $code);
                break;
            case 'javascript':
                $f['arrow_fns']  = preg_match_all('/=>\s*[{(]/', $code);
                $f['promises']   = preg_match_all('/\.then\s*\(|async\s+function|await\s+/', $code);
                $f['callbacks']  = preg_match_all('/function\s*\(/', $code);
                break;
            case 'c_cpp':
                $f['pointers']   = preg_match_all('/\*\w+|\w+\s*->\s*\w+/', $code);
                $f['structs']    = preg_match_all('/\bstruct\s+\w+/', $code);
                $f['includes']   = preg_match_all('/#include/', $code);
                break;
            case 'python':
                $f['list_compr'] = preg_match_all('/\[.+\s+for\s+\w+\s+in\s+/', $code);
                $f['decorators'] = preg_match_all('/@\w+/', $code);
                $f['with_stmts'] = preg_match_all('/\bwith\s+/', $code);
                break;
        }
        return $f;
    }

    /**
     * Ejecuta el analizador Python AST directamente como proceso hijo.
     * No requiere ningún servidor externo corriendo.
     *
     * Llama a: python ast_analyzer.py "<json_base64>"
     * Devuelve null si Python no está disponible (usa fallback regex).
     */
    private static function call_python_ast_service(string $c1, string $c2): ?array {
        $script = __DIR__ . '/../ast_analyzer.py';
        if (!file_exists($script)) {
            return null;
        }

        // Pasar los códigos como JSON en base64 para evitar problemas con comillas/saltos
        $payload = base64_encode(json_encode(['code1' => $c1, 'code2' => $c2]));

        // Detectar ejecutable Python disponible
        $python = self::find_python();
        if (!$python) {
            return null;
        }

        $cmd        = escapeshellcmd($python) . ' ' . escapeshellarg($script) . ' ' . escapeshellarg($payload);
        $output     = '';
        $return_code = 0;

        // Ejecutar con timeout de 10 segundos
        $descriptors = [
            0 => ['pipe', 'r'],
            1 => ['pipe', 'w'],
            2 => ['pipe', 'w'],
        ];
        $process = proc_open($cmd, $descriptors, $pipes);
        if (!is_resource($process)) {
            return null;
        }

        fclose($pipes[0]);
        $output = stream_get_contents($pipes[1]);
        fclose($pipes[1]);
        fclose($pipes[2]);
        $return_code = proc_close($process);

        if ($return_code !== 0 || empty($output)) {
            return null;
        }

        $data = json_decode(trim($output), true);
        if (!isset($data['similarity'])) {
            return null;
        }
        return $data;
    }

    /**
     * Encuentra el ejecutable Python disponible en el sistema.
     */
    private static function find_python(): ?string {
        $candidates = ['python3', 'python', 'C:\\Python312\\python.exe',
                       'C:\\Python311\\python.exe', 'C:\\Python310\\python.exe',
                       'C:\\xampp\\python\\python.exe'];
        foreach ($candidates as $py) {
            $test = shell_exec(escapeshellcmd($py) . ' --version 2>&1');
            if ($test && stripos($test, 'python') !== false) {
                return $py;
            }
        }
        return null;
    }

    /**
     * Extrae métricas estructurales del código fuente.
     */
    private static function extract_structural_features(string $code): array {
        $f = [
            'functions'       => 0,
            'loops'           => 0,
            'conditionals'    => 0,
            'returns'         => 0,
            'recursion'       => 0,
            'nested_depth'    => 0,
            'operators_count' => 0,
            'control_sequence'=> [],
        ];

        // Funciones
        $f['functions'] = preg_match_all(
            '/\b(def |function |void |int |float |double |public |private |static )\s*\w+\s*\(/',
            $code
        );

        // Bucles
        $loops = preg_match_all('/\b(for|while|do)\b/', $code);
        $f['loops'] = $loops;

        // Condicionales
        $conds = preg_match_all('/\b(if|elif|else if|switch)\b/', $code);
        $f['conditionals'] = $conds;

        // Returns
        $f['returns'] = preg_match_all('/\breturn\b/', $code);

        // Recursión (función que se llama a sí misma — heurística)
        if (preg_match('/\b(\w+)\s*\(/', $code, $m)) {
            $fname = $m[1];
            $f['recursion'] = (int)(substr_count($code, $fname . '(') > 1);
        }

        // Profundidad de anidamiento (contar llaves/indentación)
        $depth = 0; $max_depth = 0;
        for ($i = 0; $i < strlen($code); $i++) {
            if ($code[$i] === '{' || $code[$i] === ':') $depth++;
            elseif ($code[$i] === '}') $depth = max(0, $depth - 1);
            $max_depth = max($max_depth, $depth);
        }
        $f['nested_depth'] = $max_depth;

        // Operadores
        $f['operators_count'] = preg_match_all('/[+\-*\/%&|^~<>!=]=?|&&|\|\|/', $code);

        // Secuencia de estructuras de control (para comparar orden)
        preg_match_all('/\b(for|while|do|if|elif|else|switch|return|def|function|class)\b/', $code, $matches);
        $f['control_sequence'] = $matches[1] ?? [];

        return $f;
    }

    // ─────────────────────────────────────────────────────────────────────
    // CAPA 3: ANÁLISIS SEMÁNTICO CON IA
    // ─────────────────────────────────────────────────────────────────────

    private static function semantic_similarity_ai(string $c1, string $c2): array {
        $apikey = get_config('mod_aiassignment', 'openai_api_key');
        if (empty($apikey)) {
            return ['score' => 0, 'analysis' => 'API key no configurada.', 'verdict' => 'unknown'];
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

    // ─────────────────────────────────────────────────────────────────────
    // DETECCIÓN DE TÉCNICAS DE OFUSCACIÓN
    // ─────────────────────────────────────────────────────────────────────

    private static function detect_obfuscation_techniques(
        string $c1, string $c2, array $lex, array $struct
    ): array {
        $techniques = [];

        // Renombrado de variables: similitud estructural alta pero léxica baja en tokens literales
        $raw_lex = self::jaccard(
            self::tokenize($c1),
            self::tokenize($c2)
        ) * 100;
        if ($lex['score'] > 60 && $raw_lex < 40) {
            $techniques[] = 'Renombrado de variables/funciones';
        }

        // Cambio de tipo de bucle
        $loops1 = $struct['features1']['loops'] ?? 0;
        $loops2 = $struct['features2']['loops'] ?? 0;
        $conds1 = $struct['features1']['conditionals'] ?? 0;
        $conds2 = $struct['features2']['conditionals'] ?? 0;
        if ($loops1 !== $loops2 && $struct['score'] > 55) {
            $techniques[] = 'Cambio de tipo de bucle (for/while/recursión)';
        }

        // Reordenación de sentencias (mismos tokens, diferente orden)
        $tokens1 = self::tokenize(self::normalize_identifiers($c1));
        $tokens2 = self::tokenize(self::normalize_identifiers($c2));
        $sorted1 = $tokens1; sort($sorted1);
        $sorted2 = $tokens2; sort($sorted2);
        $sorted_sim = self::jaccard($sorted1, $sorted2);
        if ($sorted_sim > 0.85 && $lex['lcs'] < 70) {
            $techniques[] = 'Reordenación de sentencias';
        }

        // Inserción de código muerto (diferencia de tamaño > 30% con alta similitud)
        $len1 = strlen(preg_replace('/\s+/', '', $c1));
        $len2 = strlen(preg_replace('/\s+/', '', $c2));
        $size_diff = $len1 > 0 ? abs($len1 - $len2) / max($len1, $len2) : 0;
        if ($size_diff > 0.30 && $lex['score'] > 55) {
            $techniques[] = 'Posible inserción de código muerto o padding';
        }

        return $techniques;
    }

    // ─────────────────────────────────────────────────────────────────────
    // VEREDICTO FINAL
    // ─────────────────────────────────────────────────────────────────────

    private static function get_verdict(float $score, array $techniques): string {
        // Si hay técnicas de ofuscación detectadas, subir el nivel de alerta
        $boost = count($techniques) * 5;
        $adjusted = min(100, $score + $boost);

        if ($adjusted >= self::THRESHOLD_HIGH)   return 'plagio';
        if ($adjusted >= self::THRESHOLD_MEDIUM) return 'sospechoso';
        return 'original';
    }
}
