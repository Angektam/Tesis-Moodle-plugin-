<?php
// This file is part of Moodle - http://moodle.org/
// Encuesta de usabilidad SUS para el plugin AI Assignment.

require_once('../../config.php');
require_once($CFG->dirroot . '/mod/aiassignment/lib.php');

$cmid   = required_param('id', PARAM_INT);
$action = optional_param('action', '', PARAM_ALPHA);

$cm     = get_coursemodule_from_id('aiassignment', $cmid, 0, false, MUST_EXIST);
$course = $DB->get_record('course', ['id' => $cm->course], '*', MUST_EXIST);

require_login($course, true, $cm);
$context = context_module::instance($cm->id);

$PAGE->set_url('/mod/aiassignment/sus_survey.php', ['id' => $cmid]);
$PAGE->set_title('Encuesta de Usabilidad — ' . format_string($cm->name));
$PAGE->set_heading(format_string($course->fullname));
$PAGE->set_context($context);

// ── Guardar respuestas ────────────────────────────────────────
if ($action === 'save' && confirm_sesskey()) {
    $responses = [];
    for ($i = 1; $i <= 10; $i++) {
        $responses["q$i"] = (int)optional_param("q$i", 3, PARAM_INT);
        $responses["q$i"] = max(1, min(5, $responses["q$i"]));
    }

    // Calcular score SUS
    $sum = 0;
    for ($i = 1; $i <= 10; $i++) {
        $v = $responses["q$i"];
        if ($i % 2 === 1) { // impares: restar 1
            $sum += ($v - 1);
        } else { // pares: 5 menos el valor
            $sum += (5 - $v);
        }
    }
    $sus_score = $sum * 2.5;

    // Guardar en BD
    $existing = $DB->get_record('aiassignment_sus_surveys', ['userid' => $USER->id, 'cmid' => $cmid]);
    $record = new stdClass();
    $record->userid      = $USER->id;
    $record->cmid        = $cmid;
    $record->responses   = json_encode($responses);
    $record->sus_score   = $sus_score;
    $record->timecreated = time();

    if ($existing) {
        $record->id = $existing->id;
        $DB->update_record('aiassignment_sus_surveys', $record);
    } else {
        $DB->insert_record('aiassignment_sus_surveys', $record);
    }

    redirect(
        new moodle_url('/mod/aiassignment/sus_survey.php', ['id' => $cmid, 'saved' => 1]),
        '✅ Encuesta guardada. ¡Gracias por tu retroalimentación!'
    );
}

$saved = optional_param('saved', 0, PARAM_INT);
$existing = $DB->get_record('aiassignment_sus_surveys', ['userid' => $USER->id, 'cmid' => $cmid]);

echo $OUTPUT->header();
echo html_writer::tag('h2', '📋 Encuesta de Usabilidad del Sistema',
    ['style' => 'margin-bottom:8px;']);
echo html_writer::tag('p',
    'Tu opinión nos ayuda a mejorar el sistema. La encuesta toma menos de 5 minutos.',
    ['style' => 'color:#666;margin-bottom:24px;']);

if ($saved) {
    echo $OUTPUT->notification('✅ ¡Gracias! Tu respuesta fue guardada correctamente.', 'success');
}

// Preguntas SUS adaptadas al contexto del plugin
$is_teacher = has_capability('mod/aiassignment:grade', $context);
$questions = $is_teacher ? [
    1  => 'Creo que me gustaría usar este sistema con frecuencia para gestionar tareas.',
    2  => 'Encontré el sistema innecesariamente complejo.',
    3  => 'Pensé que el sistema era fácil de usar.',
    4  => 'Creo que necesitaría apoyo técnico para usar este sistema.',
    5  => 'Las funciones del sistema (evaluación, plagio, dashboard) estaban bien integradas.',
    6  => 'Pensé que había demasiada inconsistencia en el sistema.',
    7  => 'Imagino que la mayoría de profesores aprendería a usar este sistema rápidamente.',
    8  => 'Encontré el sistema muy difícil de usar.',
    9  => 'Me sentí muy confiado usando el sistema.',
    10 => 'Necesité aprender muchas cosas antes de poder usar el sistema.',
] : [
    1  => 'Me gustaría usar este sistema para entregar mis tareas de programación.',
    2  => 'El sistema me pareció innecesariamente complicado.',
    3  => 'El sistema fue fácil de usar para enviar mi código.',
    4  => 'Necesitaría ayuda de alguien para usar este sistema.',
    5  => 'Las diferentes partes del sistema funcionaron bien juntas.',
    6  => 'Había demasiadas inconsistencias en el sistema.',
    7  => 'La mayoría de personas aprendería a usar este sistema rápidamente.',
    8  => 'El sistema fue muy difícil de usar.',
    9  => 'Me sentí seguro usando el sistema.',
    10 => 'Tuve que aprender muchas cosas antes de poder usar el sistema.',
];

$prev = $existing ? json_decode($existing->responses, true) : [];

echo html_writer::start_tag('form', [
    'method' => 'post',
    'action' => (new moodle_url('/mod/aiassignment/sus_survey.php', ['id' => $cmid]))->out(false),
    'style'  => 'max-width:800px;',
]);
echo html_writer::empty_tag('input', ['type' => 'hidden', 'name' => 'sesskey', 'value' => sesskey()]);
echo html_writer::empty_tag('input', ['type' => 'hidden', 'name' => 'action', 'value' => 'save']);

$labels = ['1<br><small>Totalmente<br>en desacuerdo</small>', '2', '3', '4',
           '5<br><small>Totalmente<br>de acuerdo</small>'];

foreach ($questions as $num => $text) {
    $is_negative = ($num % 2 === 0); // pares son negativos
    $border = $is_negative ? '#fff3cd' : '#d4edda';

    echo html_writer::start_div('', ['style' =>
        "background:#fff;border:1px solid #dee2e6;border-left:4px solid " .
        ($is_negative ? '#ffc107' : '#28a745') .
        ";border-radius:8px;padding:16px 20px;margin-bottom:12px;"]);

    echo html_writer::tag('p',
        "<strong>$num.</strong> $text",
        ['style' => 'margin-bottom:12px;font-size:14px;']);

    echo html_writer::start_div('', ['style' =>
        'display:flex;gap:8px;align-items:center;flex-wrap:wrap;']);

    for ($v = 1; $v <= 5; $v++) {
        $checked = (isset($prev["q$num"]) && $prev["q$num"] == $v) ? 'checked' : '';
        $label_text = $v === 1 ? 'Totalmente en desacuerdo' :
                     ($v === 5 ? 'Totalmente de acuerdo' : $v);

        echo html_writer::start_div('', ['style' =>
            'display:flex;flex-direction:column;align-items:center;gap:4px;min-width:60px;']);
        echo html_writer::tag('input', '', [
            'type'     => 'radio',
            'name'     => "q$num",
            'value'    => $v,
            'id'       => "q{$num}_v{$v}",
            'required' => 'required',
            $checked   => $checked,
            'style'    => 'width:20px;height:20px;cursor:pointer;',
            'aria-label' => "Pregunta $num, opción $v: $label_text",
        ]);
        echo html_writer::tag('label', $v,
            ['for' => "q{$num}_v{$v}", 'style' => 'font-size:13px;cursor:pointer;font-weight:600;']);
        if ($v === 1) {
            echo html_writer::tag('small', 'En desacuerdo', ['style' => 'font-size:10px;color:#888;text-align:center;']);
        } elseif ($v === 5) {
            echo html_writer::tag('small', 'De acuerdo', ['style' => 'font-size:10px;color:#888;text-align:center;']);
        }
        echo html_writer::end_div();
    }
    echo html_writer::end_div();
    echo html_writer::end_div();
}

// Preguntas abiertas adicionales
echo html_writer::tag('h3', 'Preguntas adicionales', ['style' => 'margin-top:24px;margin-bottom:12px;']);

$open_questions = $is_teacher ? [
    'open1' => '¿El reporte de plagio le ayudó a identificar casos que no habría detectado manualmente?',
    'open2' => '¿Recomendaría este plugin a otros profesores? ¿Por qué?',
    'open3' => '¿Qué mejoraría del sistema?',
] : [
    'open1' => '¿La retroalimentación de la IA fue útil para mejorar tu código?',
    'open2' => '¿Preferirías este sistema sobre entregar por correo o plataforma sin IA?',
    'open3' => '¿La calificación automática te pareció justa? ¿Por qué?',
];

foreach ($open_questions as $name => $question) {
    echo html_writer::start_div('', ['style' =>
        'background:#f8f9fa;border:1px solid #dee2e6;border-radius:8px;padding:16px;margin-bottom:12px;']);
    echo html_writer::tag('label', $question,
        ['for' => $name, 'style' => 'display:block;font-size:14px;font-weight:600;margin-bottom:8px;']);
    echo html_writer::tag('textarea', $prev[$name] ?? '', [
        'name'        => $name,
        'id'          => $name,
        'rows'        => 3,
        'style'       => 'width:100%;padding:8px;border:1px solid #dee2e6;border-radius:6px;font-size:13px;',
        'placeholder' => 'Escribe tu respuesta aquí...',
    ]);
    echo html_writer::end_div();
}

echo html_writer::tag('button', '💾 Guardar encuesta', [
    'type'  => 'submit',
    'class' => 'btn btn-primary btn-lg',
    'style' => 'margin-top:16px;',
]);

echo html_writer::end_tag('form');

// Mostrar score previo si ya respondió
if ($existing) {
    $grade = $existing->sus_score >= 85 ? 'Excelente 🌟' :
            ($existing->sus_score >= 70 ? 'Bueno ✅' :
            ($existing->sus_score >= 50 ? 'Aceptable ⚠️' : 'Deficiente ❌'));
    echo html_writer::start_div('', ['style' =>
        'margin-top:20px;padding:16px;background:#d4edda;border-radius:8px;border:1px solid #c3e6cb;']);
    echo html_writer::tag('p',
        "Tu score SUS anterior: <strong>" . round($existing->sus_score, 1) . " / 100</strong> — $grade",
        ['style' => 'margin:0;font-size:15px;']);
    echo html_writer::end_div();
}

// Resultados globales (solo para profesores)
if ($is_teacher) {
    $all_scores = $DB->get_records('aiassignment_sus_surveys', ['cmid' => $cmid]);
    if (count($all_scores) > 0) {
        $avg = array_sum(array_column((array)$all_scores, 'sus_score')) / count($all_scores);
        echo html_writer::start_div('', ['style' =>
            'margin-top:20px;padding:16px;background:#cce5ff;border-radius:8px;border:1px solid #b8daff;']);
        echo html_writer::tag('h4', '📊 Resultados globales del curso', ['style' => 'margin-bottom:8px;']);
        echo html_writer::tag('p',
            "Respuestas recibidas: <strong>" . count($all_scores) . "</strong> | " .
            "Score SUS promedio: <strong>" . round($avg, 1) . " / 100</strong>",
            ['style' => 'margin:0;']);
        echo html_writer::end_div();
    }
}

echo $OUTPUT->footer();
