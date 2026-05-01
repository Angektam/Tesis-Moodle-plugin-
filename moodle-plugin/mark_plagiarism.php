<?php
// This file is part of Moodle - http://moodle.org/

require_once('../../config.php');
require_once('lib.php');

$submissionid = required_param('sid', PARAM_INT);
$status       = required_param('status', PARAM_ALPHA); // 'confirmed' o 'false_positive'
require_sesskey();

$submission   = $DB->get_record('aiassignment_submissions', ['id' => $submissionid], '*', MUST_EXIST);
$aiassignment = $DB->get_record('aiassignment', ['id' => $submission->assignment], '*', MUST_EXIST);
$cm           = get_coursemodule_from_instance('aiassignment', $aiassignment->id, 0, false, MUST_EXIST);
$course       = $DB->get_record('course', ['id' => $cm->course], '*', MUST_EXIST);
require_login($course, true, $cm);
require_capability('mod/aiassignment:grade', context_module::instance($cm->id));

// Guardar en aiassignment_evaluations el campo plagiarism_status via ai_analysis JSON
$eval = $DB->get_record('aiassignment_evaluations', ['submission' => $submissionid]);
if ($eval) {
    $analysis = json_decode($eval->ai_analysis ?: '{}', true);
    $analysis['plagiarism_status'] = $status;
    $analysis['reviewed_by']       = $USER->id;
    $analysis['reviewed_at']       = time();
    $DB->set_field('aiassignment_evaluations', 'ai_analysis', json_encode($analysis), ['id' => $eval->id]);
}

// ── Mejora 4: Notificar al alumno cuando se confirma plagio ──────────────
if ($status === 'confirmed') {
    $student = $DB->get_record('user', ['id' => $submission->userid]);
    if ($student) {
        // Notificación en tiempo real (polling)
        \mod_aiassignment\realtime_notifier::push($student->id, 'plagiarism_alert', [
            'title' => '⚠️ Alerta de plagio en tu entrega',
            'body'  => 'El profesor ha marcado tu entrega de "' .
                       format_string($aiassignment->name) .
                       '" como posible plagio. Revisa tu tarea.',
            'url'   => (new moodle_url('/mod/aiassignment/view.php', ['id' => $cm->id]))->out(false),
        ]);

        // Notificación oficial de Moodle (aparece en el buzón del alumno)
        $message                    = new \core\message\message();
        $message->component         = 'mod_aiassignment';
        $message->name              = 'submission_graded';
        $message->userfrom          = $USER; // el profesor
        $message->userto            = $student;
        $message->subject           = '⚠️ Alerta de plagio — ' . format_string($aiassignment->name);
        $message->fullmessage       = "Hola " . fullname($student) . ",\n\n" .
            "Tu entrega para la tarea \"" . format_string($aiassignment->name) . "\" ha sido marcada " .
            "como posible plagio por tu profesor.\n\n" .
            "Por favor revisa tu trabajo y contacta a tu profesor si crees que es un error.\n\n" .
            "Puedes ver tu entrega en: " .
            (new moodle_url('/mod/aiassignment/view.php', ['id' => $cm->id]))->out(false);
        $message->fullmessageformat = FORMAT_PLAIN;
        $message->fullmessagehtml   = '<p>' . nl2br(s($message->fullmessage)) . '</p>';
        $message->smallmessage      = '⚠️ Tu entrega de "' . format_string($aiassignment->name) . '" fue marcada como posible plagio.';
        $message->notification      = 1;
        $message->contexturl        = (new moodle_url('/mod/aiassignment/view.php', ['id' => $cm->id]))->out(false);
        $message->contexturlname    = format_string($aiassignment->name);
        message_send($message);
    }

    // Registrar en auditoría
    \mod_aiassignment\audit_logger::log(
        \mod_aiassignment\audit_logger::ACTION_PLAGIARISM_CONFIRM,
        $USER->id, $submissionid, 'submission',
        ['assignment' => $aiassignment->name, 'student_id' => $submission->userid]
    );
} else {
    // Registrar descarte en auditoría
    \mod_aiassignment\audit_logger::log(
        \mod_aiassignment\audit_logger::ACTION_PLAGIARISM_DISMISS,
        $USER->id, $submissionid, 'submission',
        ['assignment' => $aiassignment->name]
    );
}

$back = new moodle_url('/mod/aiassignment/plagiarism_report.php', ['id' => $cm->id, 'analyze' => 1]);
redirect(
    $back,
    $status === 'confirmed' ? '✅ Marcado como plagio confirmado' : '✅ Marcado como falso positivo',
    null,
    \core\output\notification::NOTIFY_SUCCESS
);
