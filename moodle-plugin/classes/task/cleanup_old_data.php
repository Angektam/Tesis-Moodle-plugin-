<?php
// This file is part of Moodle - http://moodle.org/

namespace mod_aiassignment\task;

defined('MOODLE_INTERNAL') || die();

/**
 * Tarea programada para limpieza de datos antiguos (mejora: retención de datos).
 * Se ejecuta semanalmente.
 */
class cleanup_old_data extends \core\task\scheduled_task {

    public function get_name() {
        return 'Limpieza de datos antiguos de AI Assignment';
    }

    public function execute() {
        global $DB;

        // Limpiar notificaciones vistas de más de 30 días
        $cutoff_notif = time() - (30 * 86400);
        $deleted_notif = $DB->count_records_select(
            'aiassignment_notifications',
            'seen = 1 AND timecreated < :t',
            ['t' => $cutoff_notif]
        );
        $DB->delete_records_select(
            'aiassignment_notifications',
            'seen = 1 AND timecreated < :t',
            ['t' => $cutoff_notif]
        );
        mtrace("Notificaciones antiguas eliminadas: $deleted_notif");

        // Limpiar auditoría de más de 1 año
        $deleted_audit = \mod_aiassignment\audit_logger::cleanup(365);
        mtrace("Registros de auditoría eliminados: $deleted_audit");

        // Limpiar versiones de submissions de más de 6 meses
        $cutoff_versions = time() - (180 * 86400);
        try {
            $deleted_versions = $DB->count_records_select(
                'aiassignment_sub_versions',
                'timecreated < :t',
                ['t' => $cutoff_versions]
            );
            $DB->delete_records_select(
                'aiassignment_sub_versions',
                'timecreated < :t',
                ['t' => $cutoff_versions]
            );
            mtrace("Versiones antiguas eliminadas: $deleted_versions");
        } catch (\Exception $e) {
            mtrace("Tabla de versiones no disponible: " . $e->getMessage());
        }
    }
}
