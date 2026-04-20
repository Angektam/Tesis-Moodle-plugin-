<?php
// This file is part of Moodle - http://moodle.org/

require_once('../../config.php');
require_once($CFG->dirroot . '/mod/aiassignment/lib.php');

$submissionid = required_param('sid',     PARAM_INT);
$reason       = optional_param('reason',  '', PARAM_TEXT);
require_sesskey();

$submission   = $DB->get_record('aiassignment_submissions', ['id' => $submissionid], '*', MUST_EXIST);
$aiassignment = $DB->get_record('aiassignment', ['id' => $submission->assignment], '*', MUST_EXIST);
$cm           = get_coursemodule_from_instance('aiassignment', $aiassignment->id, 0, false, MUST_EXIST);
$course       = $DB->get_record('course', ['id' => $cm->course], '*', MUST_EXIST);
$student      = $DB->get_record('user', ['id' => $submission->userid], '*', MUST_EXIST);

require_login($course, true, $cm);
$context = context_module::instance($cm->id);
require_capability('mod/aiassignment:grade', $context);

// Marcar la submission como 'flagged' para indicar que se solicitó re-envío
$DB->set_field('aiassignment_submissions', 'status', 'flagged', ['id' => $submissionid]);

// Guardar la razón en el feedback
if (!empty($reason)) {
    $DB->set_field('aiassignment_submissions', 'feedback',
        '⚠️ Re-envío solicitado por el docente: ' . $reason, ['id' => $submissionid]);
}

// Enviar notificación al estudiante
$msg                    = new \core\message\message();
$msg->component         = 'mod_aiassignment';
$msg->name              = 'submission_graded';
$msg->userfrom          = $USER;
$msg->userto            = $student;
$msg->subject           = '📝 Re-envío solicitado: ' . format_string($aiassignment->name);
$msg->fullmessage       = "Hola " . fullname($student) . ",\n\n" .
    "El docente " . fullname($USER) . " ha solicitado que vuelvas a enviar tu trabajo en:\n" .
    format_string($aiassignment->name) . "\n\n" .
    (!empty($reason) ? "Motivo: " . $reason . "\n\n" : "") .
    "Por favor ingresa a Moodle y envía una nueva versión de tu trabajo.\n\n" .
    "Accede aquí: " . (new moodle_url('/mod/aiassignment/view.php', ['id' => $cm->id]))->out(false);
$msg->fullmessageformat = FORMAT_PLAIN;
$msg->fullmessagehtml   = '<p>' . nl2br(s($msg->fullmessage)) . '</p>';
$msg->smallmessage      = 'Re-envío solicitado en ' . format_string($aiassignment->name);
$msg->notification      = 1;
$msg->contexturl        = (new moodle_url('/mod/aiassignment/view.php', ['id' => $cm->id]))->out(false);
$msg->contexturlname    = format_string($aiassignment->name);
message_send($msg);

$back = new moodle_url('/mod/aiassignment/submission.php', ['id' => $submissionid]);
redirect($back,
    '✅ Re-envío solicitado. ' . fullname($student) . ' recibirá una notificación.',
    null,
    \core\output\notification::NOTIFY_SUCCESS
);
