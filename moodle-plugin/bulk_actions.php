<?php
// This file is part of Moodle - http://moodle.org/
// Endpoint para acciones en lote sobre submissions (mejora #14).

require_once('../../config.php');
require_once($CFG->dirroot . '/mod/aiassignment/lib.php');

$id     = required_param('id', PARAM_INT); // Course Module ID
$action = required_param('action', PARAM_ALPHA); // reevaluate | export | flag_plagiarism
$sids   = required_param('sids', PARAM_TEXT); // Comma-separated submission IDs

$cm = get_coursemodule_from_id('aiassignment', $id, 0, false, MUST_EXIST);
$course = $DB->get_record('course', ['id' => $cm->course], '*', MUST_EXIST);
$aiassignment = $DB->get_record('aiassignment', ['id' => $cm->instance], '*', MUST_EXIST);

require_login($course, true, $cm);
require_sesskey();
$context = context_module::instance($cm->id);
require_capability('mod/aiassignment:grade', $context);

$submission_ids = array_filter(array_map('intval', explode(',', $sids)));

if (empty($submission_ids)) {
    redirect(
        new moodle_url('/mod/aiassignment/submissions.php', ['id' => $cm->id]),
        'No se seleccionaron envíos.', null, \core\output\notification::NOTIFY_WARNING
    );
}

$processed = 0;

switch ($action) {
    case 'reevaluate':
        // Re-evaluar en lote usando tareas asíncronas
        foreach ($submission_ids as $sid) {
            $sub = $DB->get_record('aiassignment_submissions', ['id' => $sid, 'assignment' => $aiassignment->id]);
            if (!$sub) continue;

            // Guardar versión antes de re-evaluar
            \mod_aiassignment\submission_versioner::save_version($sub, 'reevaluate');

            // Resetear estado
            $sub->status = 'pending';
            $sub->timemodified = time();
            $DB->update_record('aiassignment_submissions', $sub);

            // Encolar tarea asíncrona
            $task = new \mod_aiassignment\task\evaluate_submission();
            $task->set_custom_data((object)['submissionid' => $sid]);
            \core\task\manager::queue_adhoc_task($task, true);

            \mod_aiassignment\audit_logger::log('reevaluate', $USER->id, $sid, 'submission', [
                'bulk' => true, 'total_in_batch' => count($submission_ids),
            ]);
            $processed++;
        }
        $msg = "$processed envío(s) encolados para re-evaluación.";
        break;

    case 'flag':
        // Marcar como plagio en lote
        foreach ($submission_ids as $sid) {
            $sub = $DB->get_record('aiassignment_submissions', ['id' => $sid, 'assignment' => $aiassignment->id]);
            if (!$sub) continue;

            $sub->status = 'flagged';
            $sub->timemodified = time();
            $DB->update_record('aiassignment_submissions', $sub);

            \mod_aiassignment\audit_logger::log('plagiarism_confirm', $USER->id, $sid, 'submission', [
                'bulk' => true,
            ]);
            $processed++;
        }
        $msg = "$processed envío(s) marcados como plagio.";
        break;

    case 'unflag':
        // Desmarcar plagio en lote
        foreach ($submission_ids as $sid) {
            $sub = $DB->get_record('aiassignment_submissions', ['id' => $sid, 'assignment' => $aiassignment->id]);
            if (!$sub) continue;

            $sub->status = 'evaluated';
            $sub->timemodified = time();
            $DB->update_record('aiassignment_submissions', $sub);

            \mod_aiassignment\audit_logger::log('plagiarism_dismiss', $USER->id, $sid, 'submission', [
                'bulk' => true,
            ]);
            $processed++;
        }
        $msg = "$processed envío(s) desmarcados.";
        break;

    default:
        $msg = 'Acción no reconocida.';
}

redirect(
    new moodle_url('/mod/aiassignment/submissions.php', ['id' => $cm->id]),
    $msg, null, \core\output\notification::NOTIFY_SUCCESS
);
