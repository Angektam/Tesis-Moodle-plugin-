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
// VALIDACIONES DE ENTRADA
// ============================================================================

// 1. Normalizar respuesta
$answer = trim($answer);

// 2. Validar que la respuesta no esté vacía
if ($answer === '') {
    redirect(new moodle_url('/mod/aiassignment/view.php', array('id' => $cm->id)),
        get_string('answerrequired', 'aiassignment'), null, \core\output\notification::NOTIFY_ERROR);
}

// 3. Validar longitud mínima (al menos 10 caracteres)
$minlen = 10;
if (\core_text::strlen($answer) < $minlen) {
    redirect(new moodle_url('/mod/aiassignment/view.php', array('id' => $cm->id)),
        get_string('answertooshort', 'aiassignment', $minlen),
        null, \core\output\notification::NOTIFY_ERROR);
}

// 4. Validar longitud máxima
$maxlen = 10000; // Aumentado a 10000 para código más largo
if (\core_text::strlen($answer) > $maxlen) {
    redirect(new moodle_url('/mod/aiassignment/view.php', array('id' => $cm->id)),
        get_string('answertoolong', 'aiassignment', $maxlen), null, \core\output\notification::NOTIFY_ERROR);
}

// 4b. Validar que el texto tenga estructura de código (al menos una palabra clave)
$code_keywords = ['def ', 'function ', 'class ', 'for ', 'while ', 'if ', 'return ',
                  'int ', 'void ', 'public ', 'print(', 'cout', '#include', 'import '];
$has_code = false;
foreach ($code_keywords as $kw) {
    if (stripos($answer, $kw) !== false) {
        $has_code = true;
        break;
    }
}
if ($aiassignment->type === 'programming' && !$has_code && strlen($answer) < 200) {
    redirect(new moodle_url('/mod/aiassignment/view.php', ['id' => $cm->id]),
        '⚠️ Tu respuesta no parece contener código de programación. Por favor envía tu solución en código.',
        null, \core\output\notification::NOTIFY_WARNING);
}

// 5. Validar caracteres sospechosos (prevenir inyección)
if (preg_match('/<script|javascript:|onerror=|onclick=/i', $answer)) {
    redirect(new moodle_url('/mod/aiassignment/view.php', array('id' => $cm->id)),
        get_string('answerforbidden', 'aiassignment'),
        null, \core\output\notification::NOTIFY_ERROR);
}

// 6. Verificar intentos máximos
$attemptcount = $DB->count_records('aiassignment_submissions',
    array('assignment' => $aiassignment->id, 'userid' => $USER->id));

if ($aiassignment->maxattempts > 0 && $attemptcount >= $aiassignment->maxattempts) {
    redirect(new moodle_url('/mod/aiassignment/view.php', array('id' => $cm->id)),
        get_string('maxattemptsreached', 'aiassignment'), null, \core\output\notification::NOTIFY_ERROR);
}

// 7. Prevenir envíos duplicados rápidos (anti-spam)
$recentsub = $DB->get_record_sql(
    "SELECT * FROM {aiassignment_submissions} 
     WHERE assignment = ? AND userid = ? 
     ORDER BY timecreated DESC LIMIT 1",
    array($aiassignment->id, $USER->id)
);

if ($recentsub && (time() - $recentsub->timecreated) < 5) {
    redirect(new moodle_url('/mod/aiassignment/view.php', array('id' => $cm->id)),
        get_string('waitbetweensubmissions', 'aiassignment', 5),
        null, \core\output\notification::NOTIFY_WARNING);
}

// 7b. Límite de intentos por hora (anti fuerza bruta)
$attempts_last_hour = $DB->count_records_sql(
    "SELECT COUNT(*) FROM {aiassignment_submissions}
     WHERE assignment = :a AND userid = :u AND timecreated >= :t",
    ['a' => $aiassignment->id, 'u' => $USER->id, 't' => time() - 3600]
);
$max_per_hour = 10; // máximo 10 intentos por hora
if ($attempts_last_hour >= $max_per_hour) {
    redirect(new moodle_url('/mod/aiassignment/view.php', array('id' => $cm->id)),
        '⏳ Has alcanzado el límite de ' . $max_per_hour . ' envíos por hora. Por favor espera antes de intentar de nuevo.',
        null, \core\output\notification::NOTIFY_WARNING);
}

// 8. Validar que no sea exactamente igual al envío anterior
if ($recentsub && trim($recentsub->answer) === $answer) {
    redirect(new moodle_url('/mod/aiassignment/view.php', array('id' => $cm->id)),
        get_string('duplicateanswer', 'aiassignment'),
        null, \core\output\notification::NOTIFY_WARNING);
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

// Evaluar con IA de forma asíncrona (o síncrona para simplicidad)
try {
    $evaluation = \mod_aiassignment\ai_evaluator::evaluate(
        $answer,
        $aiassignment->solution,
        $aiassignment->type
    );

    // Guardar evaluación
    $evalrecord = new stdClass();
    $evalrecord->submission = $submission->id;
    $evalrecord->similarity_score = $evaluation['similarity_score'];
    $evalrecord->ai_feedback = $evaluation['feedback'];
    $evalrecord->ai_analysis = $evaluation['analysis'];
    $evalrecord->timecreated = time();
    $DB->insert_record('aiassignment_evaluations', $evalrecord);

    // Actualizar submission
    $submission->status = 'evaluated';
    $submission->score = $evaluation['similarity_score'];
    $submission->feedback = $evaluation['feedback'];
    $submission->timemodified = time();
    $DB->update_record('aiassignment_submissions', $submission);

    // Actualizar calificación en el libro de calificaciones
    aiassignment_update_grades($aiassignment, $USER->id);

    // Notificar al estudiante que su envío fue evaluado (mejora #3)
    $message                     = new \core\message\message();
    $message->component          = 'mod_aiassignment';
    $message->name               = 'submission_graded';
    $message->userfrom           = \core_user::get_noreply_user();
    $message->userto             = $USER;
    $message->subject            = get_string('notif_graded_subject', 'aiassignment',
                                       format_string($aiassignment->name));
    $message->fullmessage        = get_string('notif_graded_body', 'aiassignment', [
        'assignment' => format_string($aiassignment->name),
        'score'      => round($evaluation['similarity_score'], 2),
        'feedback'   => $evaluation['feedback'],
    ]);
    $message->fullmessageformat  = FORMAT_PLAIN;
    $message->fullmessagehtml    = '<p>' . $message->fullmessage . '</p>';
    $message->smallmessage       = get_string('notif_graded_small', 'aiassignment',
                                       round($evaluation['similarity_score'], 2));
    $message->notification       = 1;
    $message->contexturl         = (new moodle_url('/mod/aiassignment/view.php', ['id' => $cm->id]))->out(false);
    $message->contexturlname     = format_string($aiassignment->name);
    message_send($message);

    // Disparar evento de calificación
    $event = \mod_aiassignment\event\submission_graded::create(array(
        'objectid' => $submission->id,
        'context' => $context,
        'relateduserid' => $USER->id,
        'other' => array(
            'assignmentid' => $aiassignment->id,
            'score' => $evaluation['similarity_score']
        )
    ));
    $event->trigger();

    redirect(new moodle_url('/mod/aiassignment/view.php', array('id' => $cm->id)),
        get_string('submissionsaved', 'aiassignment'), null, \core\output\notification::NOTIFY_SUCCESS);

} catch (Exception $e) {
    // Si falla la evaluación, el envío se queda como 'pending'
    debugging('Evaluation failed: ' . $e->getMessage(), DEBUG_DEVELOPER);
    
    redirect(new moodle_url('/mod/aiassignment/view.php', array('id' => $cm->id)),
        get_string('submissionsaved', 'aiassignment') . ' ' . get_string('evaluationfailed', 'aiassignment'),
        null, \core\output\notification::NOTIFY_WARNING);
}
