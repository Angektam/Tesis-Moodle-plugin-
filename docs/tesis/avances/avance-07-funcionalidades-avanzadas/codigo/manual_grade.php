<?php
require_once('../../config.php');
require_once($CFG->dirroot . '/mod/aiassignment/lib.php');

$sid     = required_param('sid',     PARAM_INT);
$score   = required_param('score',   PARAM_FLOAT);
$comment = optional_param('comment', '', PARAM_TEXT);
require_sesskey();

$submission   = $DB->get_record('aiassignment_submissions', ['id' => $sid], '*', MUST_EXIST);
$aiassignment = $DB->get_record('aiassignment', ['id' => $submission->assignment], '*', MUST_EXIST);
$cm           = get_coursemodule_from_instance('aiassignment', $aiassignment->id, 0, false, MUST_EXIST);
$course       = $DB->get_record('course', ['id' => $cm->course], '*', MUST_EXIST);
require_login($course, true, $cm);
require_capability('mod/aiassignment:grade', context_module::instance($cm->id));

$score = \mod_aiassignment\security::normalize_score($score);

// Sanitizar comentario
$comment = clean_param($comment, PARAM_TEXT);
if (\core_text::strlen($comment) > 500) {
    $comment = \core_text::substr($comment, 0, 500);
}

// Guardar historial de cambios de calificación (Mejora 6)
$eval = $DB->get_record('aiassignment_evaluations', ['submission' => $sid]);
if ($eval) {
    $analysis = json_decode($eval->ai_analysis ?: '{}', true);
    if (!isset($analysis['grade_history'])) $analysis['grade_history'] = [];
    $analysis['grade_history'][] = [
        'old_score'  => $submission->score,
        'new_score'  => $score,
        'comment'    => $comment,
        'changed_by' => $USER->id,
        'changed_at' => time(),
    ];
    $DB->set_field('aiassignment_evaluations', 'ai_analysis', json_encode($analysis), ['id' => $eval->id]);
}

$upd = new stdClass();
$upd->id           = $sid;
$upd->score        = $score;
$upd->status       = 'evaluated';
$upd->timemodified = time();
if (!empty($comment)) {
    $upd->feedback = '👨‍🏫 Calificación manual: ' . $comment;
}
$DB->update_record('aiassignment_submissions', $upd);

// Actualizar libro de calificaciones
aiassignment_update_grades($aiassignment, $submission->userid);

redirect(
    new moodle_url('/mod/aiassignment/submission.php', ['id' => $sid]),
    '✅ Calificación actualizada a ' . round($score, 1) . '%',
    null,
    \core\output\notification::NOTIFY_SUCCESS
);
