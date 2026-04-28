<?php
// This file is part of Moodle - http://moodle.org/

require_once('../../config.php');
require_once($CFG->dirroot.'/mod/aiassignment/lib.php');

$id = required_param('id', PARAM_INT); // Course Module ID.
$answer = required_param('answer', PARAM_RAW);

$cm = get_coursemodule_from_id('aiassignment', $id, 0, false, MUST_EXIST);
$course = $DB->get_record('course', array('id' => $cm->course), '*', MUST_EXIST);
$aiassignment = $DB->get_record('aiassignment', array('id' => $cm->instance), '*', MUST_EXIST);

require_login($course, true, $cm);
require_sesskey();

$context = context_module::instance($cm->id);
require_capability('mod/aiassignment:submit', $context);

// ============================================================================
// VALIDACIONES DE ENTRADA — usando clase centralizada de seguridad
// ============================================================================

// 1. Sanitizar y validar el código
$maxlen = (int)(get_config('mod_aiassignment', 'max_submission_length') ?: 10000);
try {
    $answer = \mod_aiassignment\security::sanitize_code($answer, $maxlen);
} catch (\moodle_exception $e) {
    redirect(new moodle_url('/mod/aiassignment/view.php', ['id' => $cm->id]),
        $e->getMessage(), null, \core\output\notification::NOTIFY_ERROR);
}

// 2. Validar que el texto tenga estructura de código para tipo programming
$code_keywords = ['def ', 'function ', 'class ', 'for ', 'while ', 'if ', 'return ',
                  'int ', 'void ', 'public ', 'print(', 'cout', '#include', 'import '];
$has_code = false;
foreach ($code_keywords as $kw) {
    if (stripos($answer, $kw) !== false) { $has_code = true; break; }
}
if ($aiassignment->type === 'programming' && !$has_code && strlen($answer) < 200) {
    redirect(new moodle_url('/mod/aiassignment/view.php', ['id' => $cm->id]),
        '⚠️ Tu respuesta no parece contener código de programación.',
        null, \core\output\notification::NOTIFY_WARNING);
}

// 3. Verificar intentos máximos
$attemptcount = $DB->count_records('aiassignment_submissions',
    ['assignment' => $aiassignment->id, 'userid' => $USER->id]);

if ($aiassignment->maxattempts > 0 && $attemptcount >= $aiassignment->maxattempts) {
    redirect(new moodle_url('/mod/aiassignment/view.php', ['id' => $cm->id]),
        get_string('maxattemptsreached', 'aiassignment'), null, \core\output\notification::NOTIFY_ERROR);
}

// 4. Rate limiting centralizado
try {
    \mod_aiassignment\security::check_rate_limit($USER->id, $aiassignment->id);
} catch (\moodle_exception $e) {
    redirect(new moodle_url('/mod/aiassignment/view.php', ['id' => $cm->id]),
        $e->getMessage(), null, \core\output\notification::NOTIFY_WARNING);
}

// 5. Verificar envío duplicado (mismo contenido que el anterior)
$recentsub = $DB->get_record_sql(
    "SELECT answer FROM {aiassignment_submissions}
     WHERE assignment = :a AND userid = :u ORDER BY timecreated DESC LIMIT 1",
    ['a' => $aiassignment->id, 'u' => $USER->id]
);
if ($recentsub && trim($recentsub->answer) === $answer) {
    redirect(new moodle_url('/mod/aiassignment/view.php', ['id' => $cm->id]),
        get_string('duplicateanswer', 'aiassignment'), null, \core\output\notification::NOTIFY_WARNING);
}

// Crear el envío
$submission = new stdClass();
$submission->assignment = $aiassignment->id;
$submission->userid = $USER->id;
$submission->answer = $answer;
$submission->status = 'pending';
$submission->attempt = $attemptcount + 1;
$submission->timecreated = time();
$submission->timemodified = time();

$submission->id = $DB->insert_record('aiassignment_submissions', $submission);

// Disparar evento
$event = \mod_aiassignment\event\submission_created::create(array(
    'objectid' => $submission->id,
    'context' => $context,
    'relateduserid' => $USER->id,
    'other' => array(
        'assignmentid' => $aiassignment->id
    )
));
$event->trigger();

// ── Detección de código generado por IA ──────────────────────────────────
if ($aiassignment->type === 'programming') {
    try {
        $ai_detection = \mod_aiassignment\ai_detector::detect($answer, $aiassignment->type);
        if ($ai_detection['score'] >= 70) {
            // Guardar señal en el feedback para que el profesor la vea
            $submission->feedback = '[⚠️ POSIBLE IA: ' . $ai_detection['label'] . ' (' .
                $ai_detection['score'] . '%)] ' . implode('; ', $ai_detection['signals']);
            $DB->update_record('aiassignment_submissions', $submission);
        }
    } catch (Exception $e) {
        debugging('AI detection failed: ' . $e->getMessage(), DEBUG_DEVELOPER);
    }
}

// ── Registrar cambios de pestaña (modo examen) ────────────────────────────
$tab_switches = optional_param('tab_switches', 0, PARAM_INT);
if ($tab_switches > 0) {
    $submission->feedback = ($submission->feedback ?? '') .
        ' [🔒 EXAMEN: ' . $tab_switches . ' cambio(s) de pestaña detectado(s)]';
    $DB->update_record('aiassignment_submissions', $submission);
}

// ── Análisis de comportamiento del editor (behavior tracker) ─────────────
$editor_events_raw = optional_param('editor_events', '', PARAM_RAW);
if (!empty($editor_events_raw)) {
    $events = json_decode($editor_events_raw, true);
    if (is_array($events) && !empty($events)) {
        $behavior = \mod_aiassignment\behavior_tracker::analyze($events, $answer);
        if ($behavior['suspicious']) {
            $signals_str = implode('; ', $behavior['signals']);
            $behavior_note = ' [⚠️ COMPORTAMIENTO: ' . $signals_str .
                ' | Pegados: ' . $behavior['paste_count'] .
                ' | Ratio: ' . $behavior['paste_ratio'] . '%' .
                ' | Velocidad: ' . $behavior['typing_speed'] . ' cpm' .
                ' | Tiempo: ' . $behavior['time_spent_s'] . 's]';
            $submission->feedback = ($submission->feedback ?? '') . $behavior_note;
            $DB->update_record('aiassignment_submissions', $submission);
        }
    }
}

// ── Evaluar: asíncrono si hay cron, síncrono como fallback ───────────────
$async_mode = (bool)get_config('mod_aiassignment', 'async_evaluation');

if ($async_mode) {
    // Encolar tarea asíncrona — el estudiante no espera
    $task = new \mod_aiassignment\task\evaluate_submission();
    $task->set_custom_data(['submissionid' => $submission->id]);
    \core\task\manager::queue_adhoc_task($task);

    redirect(new moodle_url('/mod/aiassignment/view.php', array('id' => $cm->id)),
        '✅ Tu respuesta fue enviada. La evaluación estará lista en unos minutos.',
        null, \core\output\notification::NOTIFY_SUCCESS);
} else {
    // Evaluación síncrona (comportamiento original)
    try {
        // ── Construir rúbrica personalizada si la tarea la tiene ──────
        $rubric = null;
        if (!empty($aiassignment->use_rubric)) {
            $rubric = [];
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
            // Si los pesos no suman 100, usar rúbrica por defecto
            if ($total_weight < 90 || $total_weight > 110) {
                $rubric = null;
            }
        }

        $evaluation = \mod_aiassignment\ai_evaluator::evaluate(
            $answer,
            $aiassignment->solution,
            $aiassignment->type,
            $rubric
        );

        // Guardar evaluación
        $evalrecord = new stdClass();
        $evalrecord->submission       = $submission->id;
        $evalrecord->similarity_score = $evaluation['similarity_score'];
        $evalrecord->ai_feedback      = $evaluation['feedback'];
        $evalrecord->ai_analysis      = $evaluation['analysis'];
        $evalrecord->timecreated      = time();
        $DB->insert_record('aiassignment_evaluations', $evalrecord);

        // Actualizar submission
        $submission->status       = 'evaluated';
        $submission->score        = $evaluation['similarity_score'];
        $submission->feedback     = $evaluation['feedback'];
        $submission->evaluated_at = time();
        $submission->timemodified = time();
        $DB->update_record('aiassignment_submissions', $submission);

        aiassignment_update_grades($aiassignment, $USER->id);

        // Notificar al estudiante
        $message                    = new \core\message\message();
        $message->component         = 'mod_aiassignment';
        $message->name              = 'submission_graded';
        $message->userfrom          = \core_user::get_noreply_user();
        $message->userto            = $USER;
        $message->subject           = get_string('notif_graded_subject', 'aiassignment',
                                          format_string($aiassignment->name));
        $message->fullmessage       = get_string('notif_graded_body', 'aiassignment', [
            'assignment' => format_string($aiassignment->name),
            'score'      => round($evaluation['similarity_score'], 2),
            'feedback'   => $evaluation['feedback'],
        ]);
        $message->fullmessageformat = FORMAT_PLAIN;
        $message->fullmessagehtml   = '<p>' . $message->fullmessage . '</p>';
        $message->smallmessage      = get_string('notif_graded_small', 'aiassignment',
                                          round($evaluation['similarity_score'], 2));
        $message->notification      = 1;
        $message->contexturl        = (new moodle_url('/mod/aiassignment/view.php',
                                          ['id' => $cm->id]))->out(false);
        $message->contexturlname    = format_string($aiassignment->name);
        message_send($message);

        $event = \mod_aiassignment\event\submission_graded::create([
            'objectid'      => $submission->id,
            'context'       => $context,
            'relateduserid' => $USER->id,
            'other'         => ['assignmentid' => $aiassignment->id,
                                'score'        => $evaluation['similarity_score']],
        ]);
        $event->trigger();

        // Redirigir a encuesta de satisfacción (cada 3 intentos)
        $show_survey = ($submission->attempt % 3 === 0);
        if ($show_survey) {
            redirect(new moodle_url('/mod/aiassignment/satisfaction_survey.php',
                ['id' => $cm->id, 'sid' => $submission->id]),
                get_string('submissionsaved', 'aiassignment'), null,
                \core\output\notification::NOTIFY_SUCCESS);
        }

        redirect(new moodle_url('/mod/aiassignment/view.php', array('id' => $cm->id)),
            get_string('submissionsaved', 'aiassignment'), null, \core\output\notification::NOTIFY_SUCCESS);

    } catch (Exception $e) {
        debugging('Evaluation failed: ' . $e->getMessage(), DEBUG_DEVELOPER);
        redirect(new moodle_url('/mod/aiassignment/view.php', array('id' => $cm->id)),
            get_string('submissionsaved', 'aiassignment') . ' ' . get_string('evaluationfailed', 'aiassignment'),
            null, \core\output\notification::NOTIFY_WARNING);
    }
}
