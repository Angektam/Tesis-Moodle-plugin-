<?php
// This file is part of Moodle - http://moodle.org/

namespace mod_aiassignment\task;

defined('MOODLE_INTERNAL') || die();

/**
 * Tarea asíncrona para análisis de plagio en background (mejora #5).
 * Evita bloquear la ejecución PHP del profesor.
 */
class analyze_plagiarism extends \core\task\adhoc_task {

    public function get_name() {
        return 'Analizar plagio de envíos';
    }

    public function execute() {
        global $DB;

        $data = $this->get_custom_data();
        $assignmentid = $data->assignmentid;
        $nosem = !empty($data->nosem);
        $requestedby = $data->requestedby ?? 0;

        mtrace("Iniciando análisis de plagio para assignment $assignmentid (nosem=$nosem)...");

        try {
            $report = \mod_aiassignment\plagiarism_detector::generate_plagiarism_report(
                $assignmentid, $nosem, true
            );

            if (isset($report['message'])) {
                mtrace("Plagio: " . $report['message']);
                return;
            }

            // Guardar similarity_score en evaluaciones
            foreach ($report['user_ranking'] as $row) {
                $uid   = $row['userid'];
                $score = $row['max_similarity'];
                $sub   = $DB->get_record_sql(
                    "SELECT id FROM {aiassignment_submissions}
                     WHERE assignment=:a AND userid=:u ORDER BY id DESC LIMIT 1",
                    ['a' => $assignmentid, 'u' => $uid]
                );
                if (!$sub) continue;
                $eval = $DB->get_record('aiassignment_evaluations', ['submission' => $sub->id]);
                if ($eval) {
                    $DB->set_field('aiassignment_evaluations', 'similarity_score', $score, ['id' => $eval->id]);
                } else {
                    $DB->insert_record('aiassignment_evaluations', (object)[
                        'submission' => $sub->id, 'similarity_score' => $score,
                        'ai_feedback' => '', 'ai_analysis' => '', 'timecreated' => time(),
                    ]);
                }
            }

            // Notificar al profesor que solicitó el análisis
            if ($requestedby > 0) {
                \mod_aiassignment\realtime_notifier::push($requestedby, 'plagiarism_complete', [
                    'title' => '🔍 Análisis de plagio completado',
                    'body'  => $report['suspicious_pairs_count'] . ' par(es) sospechoso(s) de ' .
                               $report['total_comparisons'] . ' comparaciones.',
                ]);
            }

            mtrace("Plagio completado: {$report['total_comparisons']} comparaciones, " .
                   "{$report['suspicious_pairs_count']} sospechosos.");

        } catch (\Exception $e) {
            mtrace("Error en análisis de plagio: " . $e->getMessage());
            throw $e;
        }
    }
}
