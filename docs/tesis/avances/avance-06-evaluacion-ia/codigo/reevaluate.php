<?php
// This file is part of Moodle - http://moodle.org/
// Re-evaluación de un envío con IA — soporta rúbricas, historial y forzar sin caché.

require_once('../../config.php');
require_once($CFG->dirroot . '/mod/aiassignment/lib.php');

$id    = required_param('id',    PARAM_INT);   // Submission ID
$force = optional_param('force', 1, PARAM_INT); // 1 = ignorar caché
require_sesskey();

$submission   = $DB->get_record('aiassignment_submissions', ['id' => $id], '*', MUST_EXIST);
$aiassignment = $DB->get_record('aiassignment', ['id' => $submission->assignment], '*', MUST_EXIST);
$cm           = get_coursemodule_from_instance('aiassignment', $aiassignment->id, 0, false, MUST_EXIST);
$course       = $DB->get_record('course', ['id' => $cm->course], '*', MUST_EXIST);

require_login($course, true, $cm);
$context = context_module::instance($cm->id);
require_capability('mod/aiassignment:grade', $context);

// ── Limpiar caché para forzar nueva evaluación ────────────────────────────
if ($force) {
    \mod_aiassignment\eval_cache::invalidate($submission->answer, $aiassignment->solution, $aiassignment->type);
}

// ── Construir rúbrica personalizada si la tarea la tiene ──────────────────
$rubric = null;
if (!empty($aiassignment->use_rubric)) {
    $rubric_fields = [
        'rubric_funcionalidad' => 'Funcionalidad',
        'rubric_estilo'        => 'Estilo y claridad',
        'rubric_eficiencia'    => 'Eficiencia',
        'rubric_documentacion' => 'Documentación',
    ];
    $total_weight = 0;
    foreach ($rubric_fields as $field => $label) {
        $weight = (int)($aiassignment->$field ?? 0);
        if ($weight > 0) {
            $key = str_replace('rubric_', '', $field);
            $rubric[$key] = ['weight' => $weight, 'label' => $label];
            $total_weight += $weight;
        }
    }
    if ($total_weight < 90 || $total_weight > 110) {
        $rubric = null; // pesos inválidos → evaluación estándar
    }
}

try {
    $evaluation = \mod_aiassignment\ai_evaluator::evaluate(
        $submission->answer,
        $aiassignment->solution,
        $aiassignment->type,
        $rubric
    );

    // ── Guardar historial de re-evaluaciones ──────────────────────────────
    $existing = $DB->get_record('aiassignment_evaluations', ['submission' => $submission->id]);
    $evalrecord = $existing ? clone $existing : new stdClass();

    // Preservar historial anterior
    $old_analysis = [];
    if ($existing && !empty($existing->ai_analysis)) {
        $old_analysis = json_decode($existing->ai_analysis, true) ?: [];
    }
    if (!isset($old_analysis['reeval_history'])) {
        $old_analysis['reeval_history'] = [];
    }
    // Guardar snapshot de la evaluación anterior
    if ($existing) {
        $old_analysis['reeval_history'][] = [
            'score'        => $existing->similarity_score,
            'feedback'     => $existing->ai_feedback,
            'reevaluated_by' => $USER->id,
            'reevaluated_at' => time(),
            'model'        => get_config('mod_aiassignment', 'openai_model') ?: 'gpt-4o-mini',
            'used_rubric'  => $rubric !== null,
        ];
        // Mantener solo los últimos 10 snapshots
        if (count($old_analysis['reeval_history']) > 10) {
            $old_analysis['reeval_history'] = array_slice($old_analysis['reeval_history'], -10);
        }
    }

    // Combinar análisis nuevo con historial
    $new_analysis = $old_analysis;
    if (isset($evaluation['rubric'])) {
        $new_analysis['rubric_breakdown'] = $evaluation['rubric']['breakdown'];
    }
    if (isset($evaluation['complexity'])) {
        $new_analysis['complexity'] = $evaluation['complexity'];
    }
    if (isset($old_analysis['grade_history'])) {
        $new_analysis['grade_history'] = $old_analysis['grade_history'];
    }
    if (isset($old_analysis['plagiarism_status'])) {
        $new_analysis['plagiarism_status'] = $old_analysis['plagiarism_status'];
    }

    $evalrecord->submission       = $submission->id;
    $evalrecord->similarity_score = $evaluation['similarity_score'];
    $evalrecord->ai_feedback      = $evaluation['feedback'];
    $evalrecord->ai_analysis      = json_encode($new_analysis, JSON_UNESCAPED_UNICODE);
    $evalrecord->timecreated      = time();

    if ($existing) {
        $DB->update_record('aiassignment_evaluations', $evalrecord);
    } else {
        $DB->insert_record('aiassignment_evaluations', $evalrecord);
    }

    // ── Actualizar submission ─────────────────────────────────────────────
    $old_score = $submission->score;
    $submission->status       = 'evaluated';
    $submission->score        = $evaluation['similarity_score'];
    $submission->feedback     = $evaluation['feedback'];
    $submission->evaluated_at = time();
    $submission->timemodified = time();
    $DB->update_record('aiassignment_submissions', $submission);

    aiassignment_update_grades($aiassignment, $submission->userid);

    // ── Notificar al estudiante ───────────────────────────────────────────
    $student = $DB->get_record('user', ['id' => $submission->userid]);
    if ($student) {
        $score_change = '';
        if ($old_score !== null) {
            $diff = round($evaluation['similarity_score'] - $old_score, 1);
            $score_change = $diff >= 0 ? " (+{$diff}%)" : " ({$diff}%)";
        }

        $msg                    = new \core\message\message();
        $msg->component         = 'mod_aiassignment';
        $msg->name              = 'submission_graded';
        $msg->userfrom          = \core_user::get_noreply_user();
        $msg->userto            = $student;
        $msg->subject           = '🔄 Re-evaluación: ' . format_string($aiassignment->name);
        $msg->fullmessage       = "Tu envío en \"" . format_string($aiassignment->name) . "\" fue re-evaluado.\n" .
                                  "Nueva calificación: " . round($evaluation['similarity_score'], 1) . "%" . $score_change . "\n\n" .
                                  "Feedback: " . $evaluation['feedback'];
        $msg->fullmessageformat = FORMAT_PLAIN;
        $msg->fullmessagehtml   = '<p>' . nl2br(htmlspecialchars($msg->fullmessage)) . '</p>';
        $msg->smallmessage      = 'Re-evaluación: ' . round($evaluation['similarity_score'], 1) . '%' . $score_change;
        $msg->notification      = 1;
        $msg->contexturl        = (new moodle_url('/mod/aiassignment/view.php', ['id' => $cm->id]))->out(false);
        $msg->contexturlname    = format_string($aiassignment->name);
        message_send($msg);
    }

    $score_str = round($evaluation['similarity_score'], 1) . '%';
    $rubric_str = $rubric ? ' (con rúbrica)' : '';
    redirect(
        new moodle_url('/mod/aiassignment/submission.php', ['id' => $submission->id]),
        "✅ Re-evaluación completada: {$score_str}{$rubric_str}",
        null,
        \core\output\notification::NOTIFY_SUCCESS
    );

} catch (Exception $e) {
    redirect(
        new moodle_url('/mod/aiassignment/submission.php', ['id' => $submission->id]),
        '❌ Error en re-evaluación: ' . $e->getMessage(),
        null,
        \core\output\notification::NOTIFY_ERROR
    );
}
