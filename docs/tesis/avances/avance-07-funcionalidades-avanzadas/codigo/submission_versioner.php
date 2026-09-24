<?php
// This file is part of Moodle - http://moodle.org/

namespace mod_aiassignment;

defined('MOODLE_INTERNAL') || die();

/**
 * Sistema de versionado de submissions (mejora #7).
 * Guarda historial completo de cada envío antes de sobrescribirlo.
 */
class submission_versioner {

    /**
     * Guarda una versión del submission actual antes de actualizarlo.
     *
     * @param object $submission El submission actual (antes de modificar)
     * @param string $reason Razón del cambio: 'resubmit' | 'reevaluate' | 'manual_grade'
     */
    public static function save_version(object $submission, string $reason = 'resubmit'): void {
        global $DB;

        try {
            $version = new \stdClass();
            $version->submission_id = $submission->id;
            $version->userid        = $submission->userid;
            $version->answer        = $submission->answer;
            $version->score         = $submission->score;
            $version->feedback      = $submission->feedback;
            $version->status        = $submission->status;
            $version->attempt       = $submission->attempt;
            $version->reason        = $reason;
            $version->timecreated   = time();

            $DB->insert_record('aiassignment_sub_versions', $version);
        } catch (\Exception $e) {
            debugging('submission_versioner: ' . $e->getMessage(), DEBUG_DEVELOPER);
        }
    }

    /**
     * Obtiene el historial de versiones de un submission.
     *
     * @param int $submissionid
     * @return array Lista de versiones ordenadas por fecha desc
     */
    public static function get_history(int $submissionid): array {
        global $DB;

        try {
            return array_values($DB->get_records(
                'aiassignment_sub_versions',
                ['submission_id' => $submissionid],
                'timecreated DESC'
            ));
        } catch (\Exception $e) {
            return [];
        }
    }

    /**
     * Cuenta versiones de un submission.
     */
    public static function count_versions(int $submissionid): int {
        global $DB;
        try {
            return $DB->count_records('aiassignment_sub_versions', ['submission_id' => $submissionid]);
        } catch (\Exception $e) {
            return 0;
        }
    }
}
