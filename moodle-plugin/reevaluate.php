<?php
require_once('../../config.php');
require_once($CFG->dirroot.'/mod/aiassignment/lib.php');

$id = required_param('id', PARAM_INT); // Submission ID
require_sesskey();

$submission = $DB->get_record('aiassignment_submissions', array('id' => $id), '*', MUST_EXIST);
$aiassignment = $DB->get_record('aiassignment', array('id' => $submission->assignment), '*', MUST_EXIST);
$cm = get_coursemodule_from_instance('aiassignment', $aiassignment->id, 0, false, MUST_EXIST);
$course = $DB->get_record('course', array('id' => $cm->course), '*', MUST_EXIST);

require_login($course, true, $cm);
$context = context_module::instance($cm->id);
require_capability('mod/aiassignment:grade', $context);

try {
    $evaluation = \mod_aiassignment\ai_evaluator::evaluate(
        $submission->answer,
        $aiassignment->solution,
        $aiassignment->type
    );

    // Actualizar o crear evaluacion
    $existing = $DB->get_record('aiassignment_evaluations', array('submission' => $submission->id));
    $evalrecord = $existing ?: new stdClass();
    $evalrecord->submission       = $submission->id;
    $evalrecord->similarity_score = $evaluation['similarity_score'];
    $evalrecord->ai_feedback      = $evaluation['feedback'];
    $evalrecord->ai_analysis      = $evaluation['analysis'];
    $evalrecord->timecreated      = time();

    if ($existing) {
        $DB->update_record('aiassignment_evaluations', $evalrecord);
    } else {
        $DB->insert_record('aiassignment_evaluations', $evalrecord);
    }

    // Actualizar submission
    $submission->status       = 'evaluated';
    $submission->score        = $evaluation['similarity_score'];
    $submission->feedback     = $evaluation['feedback'];
    $submission->timemodified = time();
    $DB->update_record('aiassignment_submissions', $submission);

    aiassignment_update_grades($aiassignment, $submission->userid);

    // Notificar al estudiante que su envío fue re-evaluado (mejora #3)
    $student = $DB->get_record('user', ['id' => $submission->userid]);
    if ($student) {
        $msg                    = new \core\message\message();
        $msg->component         = 'mod_aiassignment';
        $msg->name              = 'submission_graded';
        $msg->userfrom          = \core_user::get_noreply_user();
        $msg->userto            = $student;
        $msg->subject           = get_string('notif_graded_subject', 'aiassignment',
                                      format_string($aiassignment->name));
        $msg->fullmessage       = get_string('notif_graded_body', 'aiassignment', [
            'assignment' => format_string($aiassignment->name),
            'score'      => round($evaluation['similarity_score'], 2),
            'feedback'   => $evaluation['feedback'],
        ]);
        $msg->fullmessageformat = FORMAT_PLAIN;
        $msg->fullmessagehtml   = '<p>' . $msg->fullmessage . '</p>';
        $msg->smallmessage      = get_string('notif_graded_small', 'aiassignment',
                                      round($evaluation['similarity_score'], 2));
        $msg->notification      = 1;
        $msg->contexturl        = (new moodle_url('/mod/aiassignment/view.php',
                                      ['id' => $cm->id]))->out(false);
        $msg->contexturlname    = format_string($aiassignment->name);
        message_send($msg);
    }

    redirect(
        new moodle_url('/mod/aiassignment/submission.php', array('id' => $submission->id)),
        'Re-evaluacion completada.',
        null,
        \core\output\notification::NOTIFY_SUCCESS
    );

} catch (Exception $e) {
    redirect(
        new moodle_url('/mod/aiassignment/submission.php', array('id' => $submission->id)),
        'Error en re-evaluacion: ' . $e->getMessage(),
        null,
        \core\output\notification::NOTIFY_ERROR
    );
}
