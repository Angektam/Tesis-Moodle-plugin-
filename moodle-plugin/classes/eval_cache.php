<?php
// This file is part of Moodle - http://moodle.org/

namespace mod_aiassignment;

defined('MOODLE_INTERNAL') || die();

/**
 * Caché de evaluaciones IA.
 * Mejora #4: Evita llamadas duplicadas a OpenAI para código idéntico.
 * Reduce costos hasta 80% cuando hay plagio masivo.
 */
class eval_cache {

    const CACHE_TTL = 86400; // 24 horas

    /**
     * Obtiene una evaluación cacheada o null si no existe.
     *
     * @param string $answer     Código del estudiante
     * @param string $solution   Solución de referencia
     * @param string $type       Tipo de problema
     * @return array|null
     */
    public static function get(string $answer, string $solution, string $type): ?array {
        $cache = \cache::make('mod_aiassignment', 'evaluations');
        $key   = self::make_key($answer, $solution, $type);
        $data  = $cache->get($key);
        return $data ?: null;
    }

    /**
     * Guarda una evaluación en caché.
     */
    public static function set(string $answer, string $solution, string $type, array $result): void {
        $cache = \cache::make('mod_aiassignment', 'evaluations');
        $key   = self::make_key($answer, $solution, $type);
        $cache->set($key, $result);
    }

    /**
     * Genera clave única para la combinación código+solución+tipo.
     */
    private static function make_key(string $answer, string $solution, string $type): string {
        // Normalizar: quitar espacios extra y comentarios para que
        // código idéntico con diferente indentación use la misma clave
        $norm_answer   = self::normalize($answer);
        $norm_solution = self::normalize($solution);
        return 'eval_' . md5($norm_answer . '|' . $norm_solution . '|' . $type);
    }

    /**
     * Normaliza código para comparación (quita comentarios y espacios extra).
     */
    private static function normalize(string $code): string {
        // Quitar comentarios de línea
        $code = preg_replace('/\/\/[^\n]*/', '', $code);
        $code = preg_replace('/#[^\n]*/', '', $code);
        // Quitar comentarios de bloque
        $code = preg_replace('/\/\*[\s\S]*?\*\//', '', $code);
        // Normalizar espacios
        $code = preg_replace('/\s+/', ' ', trim($code));
        return strtolower($code);
    }

    /**
     * Invalida la caché para un envío específico (forzar re-evaluación).
     */
    public static function invalidate(string $answer, string $solution, string $type): void {
        $cache = \cache::make('mod_aiassignment', 'evaluations');
        $key   = self::make_key($answer, $solution, $type);
        $cache->delete($key);
    }

    /**
     * Invalida caché para un assignment específico (cuando cambia la solución).
     */
    public static function invalidate_assignment(int $assignmentid): void {
        $cache = \cache::make('mod_aiassignment', 'evaluations');
        $cache->purge();
    }

    /**
     * Estadísticas de uso de caché (para el dashboard).
     */
    public static function get_stats(): array {
        // Obtener desde la BD cuántas evaluaciones tienen el mismo hash
        global $DB;
        try {
            $sql = "SELECT COUNT(*) as total,
                           COUNT(DISTINCT MD5(s.answer)) as unique_codes,
                           COUNT(*) - COUNT(DISTINCT MD5(s.answer)) as cache_hits_potential
                    FROM {aiassignment_submissions} s
                    WHERE s.status = 'evaluated'";
            $row = $DB->get_record_sql($sql);
            return [
                'total_evaluations'    => (int)($row->total ?? 0),
                'unique_codes'         => (int)($row->unique_codes ?? 0),
                'potential_cache_hits' => (int)($row->cache_hits_potential ?? 0),
                'savings_pct'          => $row->total > 0
                    ? round($row->cache_hits_potential / $row->total * 100, 1)
                    : 0,
            ];
        } catch (\Exception $e) {
            return ['total_evaluations' => 0, 'unique_codes' => 0,
                    'potential_cache_hits' => 0, 'savings_pct' => 0];
        }
    }
}
