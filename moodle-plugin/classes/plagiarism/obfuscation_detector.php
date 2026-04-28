<?php
// This file is part of Moodle - http://moodle.org/

namespace mod_aiassignment\plagiarism;

defined('MOODLE_INTERNAL') || die();

/**
 * Detecta técnicas de ofuscación usadas para evadir detección de plagio.
 */
class obfuscation_detector {

    /**
     * Detecta técnicas de ofuscación entre dos fragmentos de código.
     */
    public static function detect(string $c1, string $c2, array $lex, array $struct): array {
        $techniques = [];

        // Renombrado de variables
        $raw_lex = lexical_analyzer::jaccard(
            lexical_analyzer::tokenize($c1),
            lexical_analyzer::tokenize($c2)
        ) * 100;

        if ($lex['score'] > 60 && $raw_lex < 40) {
            $techniques[] = 'Renombrado de variables/funciones';
        }

        // Cambio de tipo de bucle
        $loops1 = $struct['features1']['loops'] ?? 0;
        $loops2 = $struct['features2']['loops'] ?? 0;
        if ($loops1 !== $loops2 && $struct['score'] > 55) {
            $techniques[] = 'Cambio de tipo de bucle (for/while/recursión)';
        }

        // Reordenación de sentencias
        $tokens1 = lexical_analyzer::tokenize(lexical_analyzer::normalize_identifiers($c1));
        $tokens2 = lexical_analyzer::tokenize(lexical_analyzer::normalize_identifiers($c2));
        $sorted1 = $tokens1; sort($sorted1);
        $sorted2 = $tokens2; sort($sorted2);
        $sorted_sim = lexical_analyzer::jaccard($sorted1, $sorted2);
        if ($sorted_sim > 0.85 && ($lex['lcs'] ?? 0) < 70) {
            $techniques[] = 'Reordenación de sentencias';
        }

        // Inserción de código muerto
        $len1 = strlen(preg_replace('/\s+/', '', $c1));
        $len2 = strlen(preg_replace('/\s+/', '', $c2));
        $size_diff = $len1 > 0 ? abs($len1 - $len2) / max($len1, $len2) : 0;
        if ($size_diff > 0.30 && $lex['score'] > 55) {
            $techniques[] = 'Posible inserción de código muerto o padding';
        }

        // Cambio de operadores equivalentes
        $ops1 = self::normalize_operators($c1);
        $ops2 = self::normalize_operators($c2);
        $ops_sim = lexical_analyzer::jaccard(
            lexical_analyzer::tokenize($ops1),
            lexical_analyzer::tokenize($ops2)
        ) * 100;
        if ($ops_sim > 80 && ($lex['jaccard'] ?? 0) < 60) {
            $techniques[] = 'Cambio de operadores equivalentes (i++ ↔ i+=1)';
        }

        // Inserción de comentarios falsos
        $cr1 = self::comment_ratio($c1);
        $cr2 = self::comment_ratio($c2);
        if (abs($cr1 - $cr2) > 0.20 && $lex['score'] > 50) {
            $techniques[] = 'Inserción de comentarios falsos (ratio inusual)';
        }

        // Renombrado de funciones/clases
        if ($lex['score'] > 70 && $raw_lex < 35) {
            if (!in_array('Renombrado de variables/funciones', $techniques)) {
                $techniques[] = 'Renombrado de funciones/clases';
            }
        }

        return $techniques;
    }

    public static function normalize_operators(string $code): string {
        $code = preg_replace('/(\w+)\+\+/', '$1+=1', $code);
        $code = preg_replace('/(\w+)--/',   '$1-=1', $code);
        $code = preg_replace('/\+\+(\w+)/', '$1+=1', $code);
        $code = preg_replace('/--(\w+)/',   '$1-=1', $code);
        $code = preg_replace('/(\w+)\s*=\s*\1\s*\+\s*1/', '$1+=1', $code);
        $code = preg_replace('/(\w+)\s*=\s*\1\s*-\s*1/', '$1-=1', $code);
        $code = preg_replace('/\bTrue\b|\bTRUE\b/', 'true', $code);
        $code = preg_replace('/\bFalse\b|\bFALSE\b/', 'false', $code);
        $code = preg_replace('/\bNone\b|\bNULL\b/', 'null', $code);
        return $code;
    }

    public static function comment_ratio(string $code): float {
        $total_lines = max(1, substr_count($code, "\n") + 1);
        $comment_lines = 0;
        foreach (explode("\n", $code) as $line) {
            $trimmed = ltrim($line);
            if (str_starts_with($trimmed, '//') || str_starts_with($trimmed, '#') ||
                str_starts_with($trimmed, '*') || str_starts_with($trimmed, '/*') ||
                str_starts_with($trimmed, '"""') || str_starts_with($trimmed, "'''")) {
                $comment_lines++;
            }
        }
        return $comment_lines / $total_lines;
    }
}
