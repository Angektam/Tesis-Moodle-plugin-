<?php
// This file is part of Moodle - http://moodle.org/

namespace mod_aiassignment\plagiarism;

defined('MOODLE_INTERNAL') || die();

/**
 * Capa 2: Análisis estructural para detección de plagio.
 * Compara patrones de control de flujo, complejidad ciclomática y AST.
 */
class structural_analyzer {

    /**
     * Compara estructura de dos fragmentos de código.
     */
    public static function similarity(string $c1, string $c2): array {
        // Intentar AST real para Python
        if (self::is_python($c1) || self::is_python($c2)) {
            $ast_result = self::call_python_ast($c1, $c2);
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

        // Fallback: análisis con regex enriquecido por lenguaje
        $f1 = self::extract_features($c1);
        $f2 = self::extract_features($c2);

        $scores  = [];
        $metrics = ['functions', 'loops', 'conditionals', 'returns',
                    'recursion', 'nested_depth', 'operators_count'];
        foreach ($metrics as $m) {
            $v1 = $f1[$m] ?? 0;
            $v2 = $f2[$m] ?? 0;
            $max = max($v1, $v2);
            $scores[] = $max > 0 ? 1 - abs($v1 - $v2) / $max : 1.0;
        }

        $ctrl_sim = lexical_analyzer::jaccard($f1['control_sequence'], $f2['control_sequence']);
        $scores[] = $ctrl_sim;

        return [
            'score'    => round(array_sum($scores) / count($scores) * 100, 2),
            'method'   => 'regex',
            'features1'=> $f1,
            'features2'=> $f2,
        ];
    }

    public static function detect_language(string $code): string {
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

    public static function is_python(string $code): bool {
        $hits = 0;
        foreach (['/\bdef\s+\w+\s*\(/', '/\belif\b/', '/\bprint\s*\(/',
                  '/^import\s+/m', '/^from\s+\w+\s+import/m'] as $pat) {
            if (preg_match($pat, $code)) $hits++;
        }
        return $hits >= 1;
    }

    /**
     * Extrae métricas estructurales enriquecidas según el lenguaje.
     */
    public static function extract_features(string $code): array {
        $lang = self::detect_language($code);
        $f = self::extract_base_features($code);
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

    private static function extract_base_features(string $code): array {
        $f = [
            'functions' => 0, 'loops' => 0, 'conditionals' => 0,
            'returns' => 0, 'recursion' => 0, 'nested_depth' => 0,
            'operators_count' => 0, 'control_sequence' => [],
        ];

        $f['functions'] = preg_match_all(
            '/\b(def |function |void |int |float |double |public |private |static )\s*\w+\s*\(/', $code);
        $f['loops'] = preg_match_all('/\b(for|while|do)\b/', $code);
        $f['conditionals'] = preg_match_all('/\b(if|elif|else if|switch)\b/', $code);
        $f['returns'] = preg_match_all('/\breturn\b/', $code);

        if (preg_match('/\b(\w+)\s*\(/', $code, $m)) {
            $f['recursion'] = (int)(substr_count($code, $m[1] . '(') > 1);
        }

        $depth = 0; $max_depth = 0;
        for ($i = 0; $i < strlen($code); $i++) {
            if ($code[$i] === '{' || $code[$i] === ':') $depth++;
            elseif ($code[$i] === '}') $depth = max(0, $depth - 1);
            $max_depth = max($max_depth, $depth);
        }
        $f['nested_depth'] = $max_depth;
        $f['operators_count'] = preg_match_all('/[+\-*\/%&|^~<>!=]=?|&&|\|\|/', $code);

        preg_match_all('/\b(for|while|do|if|elif|else|switch|return|def|function|class)\b/', $code, $matches);
        $f['control_sequence'] = $matches[1] ?? [];

        return $f;
    }

    private static function call_python_ast(string $c1, string $c2): ?array {
        $script = dirname(__DIR__, 2) . '/ast_analyzer.py';
        if (!file_exists($script)) return null;

        $payload = base64_encode(json_encode(['code1' => $c1, 'code2' => $c2]));
        $python = self::find_python();
        if (!$python) return null;

        $cmd = escapeshellcmd($python) . ' ' . escapeshellarg($script) . ' ' . escapeshellarg($payload);
        $descriptors = [0 => ['pipe', 'r'], 1 => ['pipe', 'w'], 2 => ['pipe', 'w']];
        $process = proc_open($cmd, $descriptors, $pipes);
        if (!is_resource($process)) return null;

        fclose($pipes[0]);
        $output = stream_get_contents($pipes[1]);
        fclose($pipes[1]);
        fclose($pipes[2]);
        $return_code = proc_close($process);

        if ($return_code !== 0 || empty($output)) return null;
        $data = json_decode(trim($output), true);
        return isset($data['similarity']) ? $data : null;
    }

    private static function find_python(): ?string {
        $candidates = ['python3', 'python', 'C:\\Python312\\python.exe',
                       'C:\\Python311\\python.exe', 'C:\\Python310\\python.exe'];
        foreach ($candidates as $py) {
            $test = shell_exec(escapeshellcmd($py) . ' --version 2>&1');
            if ($test && stripos($test, 'python') !== false) return $py;
        }
        return null;
    }
}
