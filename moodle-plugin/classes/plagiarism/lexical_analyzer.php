<?php
// This file is part of Moodle - http://moodle.org/

namespace mod_aiassignment\plagiarism;

defined('MOODLE_INTERNAL') || die();

/**
 * Capa 1: Análisis léxico para detección de plagio.
 * Compara tokens normalizados resistentes al renombrado de variables.
 */
class lexical_analyzer {

    /**
     * Calcula similitud léxica entre dos fragmentos de código.
     */
    public static function similarity(string $c1, string $c2): array {
        $norm1 = self::normalize_identifiers($c1);
        $norm2 = self::normalize_identifiers($c2);

        $tokens1 = self::tokenize($norm1);
        $tokens2 = self::tokenize($norm2);

        // Jaccard sobre bigramas de tokens
        $bigrams1 = self::bigrams($tokens1);
        $bigrams2 = self::bigrams($tokens2);
        $jaccard_score = self::jaccard($bigrams1, $bigrams2) * 100;

        // LCS ratio
        $lcs = self::lcs_ratio($tokens1, $tokens2) * 100;

        // Levenshtein normalizado (mejora: métrica adicional)
        $lev = self::levenshtein_ratio($norm1, $norm2) * 100;

        $combined = round(($jaccard_score + $lcs + $lev) / 3, 2);

        return [
            'score'      => $combined,
            'jaccard'    => round($jaccard_score, 2),
            'lcs'        => round($lcs, 2),
            'levenshtein'=> round($lev, 2),
            'norm1'      => $norm1,
            'norm2'      => $norm2,
            'tokens1'    => count($tokens1),
            'tokens2'    => count($tokens2),
        ];
    }

    /**
     * Normaliza identificadores: reemplaza nombres de variables y funciones
     * por tokens genéricos para detectar renombrado.
     */
    public static function normalize_identifiers(string $code): string {
        $code = preg_replace('/\/\*[\s\S]*?\*\//', '', $code);
        $code = preg_replace('/\/\/[^\n]*/', '', $code);
        $code = preg_replace('/#[^\n]*/', '', $code);
        $code = preg_replace('/"[^"]*"/', '"STR"', $code);
        $code = preg_replace("/'[^']*'/", "'STR'", $code);
        $code = preg_replace('/\b\d+(\.\d+)?\b/', 'NUM', $code);
        $code = preg_replace('/\s+/', ' ', trim($code));
        return $code;
    }

    /**
     * Tokeniza código en palabras clave + operadores + delimitadores.
     */
    public static function tokenize(string $code): array {
        $tokens = preg_split('/(\s+|(?=[{}()\[\];,])|(?<=[{}()\[\];,]))/', $code, -1, PREG_SPLIT_NO_EMPTY);
        return array_values(array_filter($tokens, fn($t) => trim($t) !== ''));
    }

    public static function bigrams(array $tokens): array {
        $bg = [];
        for ($i = 0; $i < count($tokens) - 1; $i++) {
            $bg[] = $tokens[$i] . '|' . $tokens[$i + 1];
        }
        return $bg;
    }

    public static function jaccard(array $a, array $b): float {
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

    public static function lcs_ratio(array $a, array $b): float {
        $la = count($a);
        $lb = count($b);
        if ($la === 0 && $lb === 0) return 1.0;
        if ($la === 0 || $lb === 0) return 0.0;
        if ($la > 300 || $lb > 300) {
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

    /**
     * Distancia de Levenshtein normalizada (mejora: nueva métrica).
     */
    public static function levenshtein_ratio(string $s1, string $s2): float {
        $len1 = strlen($s1);
        $len2 = strlen($s2);
        if ($len1 === 0 && $len2 === 0) return 1.0;
        if ($len1 === 0 || $len2 === 0) return 0.0;
        // Para strings muy largos, usar aproximación
        if ($len1 > 2000 || $len2 > 2000) {
            $s1 = substr($s1, 0, 2000);
            $s2 = substr($s2, 0, 2000);
            $len1 = strlen($s1);
            $len2 = strlen($s2);
        }
        $dist = levenshtein($s1, $s2);
        return 1.0 - ($dist / max($len1, $len2));
    }
}
