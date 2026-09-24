<?php
// This file is part of Moodle - http://moodle.org/

namespace mod_aiassignment;

defined('MOODLE_INTERNAL') || die();

/**
 * Sistema de auditoría para registrar cambios importantes (mejora #12).
 * Registra calificaciones manuales, cambios de estado, acciones de plagio, etc.
 */
class audit_logger {

    const ACTION_MANUAL_GRADE     = 'manual_grade';
    const ACTION_REEVALUATE       = 'reevaluate';
    const ACTION_PLAGIARISM_CONFIRM = 'plagiarism_confirm';
    const ACTION_PLAGIARISM_DISMISS = 'plagiarism_dismiss';
    const ACTION_RESUBMIT_REQUEST = 'resubmit_request';
    const ACTION_STATUS_CHANGE    = 'status_change';
    const ACTION_BULK_ACTION      = 'bulk_action';

    /**
     * Registra un evento de auditoría.
     *
     * @param string $action Tipo de acción
     * @param int    $userid Usuario que realizó la acción
     * @param int    $targetid ID del objeto afectado (submission, assignment, etc.)
     * @param string $targettype Tipo de objeto: 'submission' | 'assignment'
     * @param array  $data Datos adicionales del cambio
     */
    public static function log(
        string $action,
        int $userid,
        int $targetid,
        string $targettype = 'submission',
        array $data = []
    ): void {
        global $DB;

        try {
            $record = new \stdClass();
            $record->action      = $action;
            $record->userid      = $userid;
            $record->targetid    = $targetid;
            $record->targettype  = $targettype;
            $record->ip          = getremoteaddr();
            $record->data        = json_encode($data, JSON_UNESCAPED_UNICODE);
            $record->timecreated = time();

            $DB->insert_record('aiassignment_audit_log', $record);
        } catch (\Exception $e) {
            debugging('audit_logger: ' . $e->getMessage(), DEBUG_DEVELOPER);
        }
    }

    /**
     * Obtiene el historial de auditoría para un objeto.
     *
     * @param int    $targetid
     * @param string $targettype
     * @param int    $limit
     * @return array
     */
    public static function get_history(int $targetid, string $targettype = 'submission', int $limit = 50): array {
        global $DB;

        try {
            $sql = "SELECT a.*, u.firstname, u.lastname
                    FROM {aiassignment_audit_log} a
                    LEFT JOIN {user} u ON a.userid = u.id
                    WHERE a.targetid = :tid AND a.targettype = :ttype
                    ORDER BY a.timecreated DESC";
            return array_values($DB->get_records_sql($sql,
                ['tid' => $targetid, 'ttype' => $targettype], 0, $limit));
        } catch (\Exception $e) {
            return [];
        }
    }

    /**
     * Limpia registros de auditoría antiguos (política de retención).
     *
     * @param int $days Días de retención (default 365)
     * @return int Registros eliminados
     */
    public static function cleanup(int $days = 365): int {
        global $DB;

        try {
            $cutoff = time() - ($days * 86400);
            $count = $DB->count_records_select('aiassignment_audit_log', 'timecreated < :t', ['t' => $cutoff]);
            $DB->delete_records_select('aiassignment_audit_log', 'timecreated < :t', ['t' => $cutoff]);
            return $count;
        } catch (\Exception $e) {
            return 0;
        }
    }
}
