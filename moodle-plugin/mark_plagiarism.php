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

$back = new moodle_url('/mod/aiassignment/plagiarism_report.php', ['id' => $cm->id, 'analyze' => 1]);
redirect(
    $back,
    $status === 'confirmed' ? '✅ Marcado como plagio confirmado' : '✅ Marcado como falso positivo',
    null,
    \core\output\notification::NOTIFY_SUCCESS
);
