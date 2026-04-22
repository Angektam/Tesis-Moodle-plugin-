<?php
// Encuesta de usabilidad SUS (System Usability Scale) — Mejora #14
require_once('../../config.php');
require_once($CFG->dirroot . '/mod/aiassignment/lib.php');

$cmid   = required_param('id',   PARAM_INT);
$action = optional_param('action', 'show', PARAM_ALPHA);

$cm = get_coursemodule_from_id('aiassignment', $cmid, 0, false, MUST_EXIST);
require_login($cm->course, false, $cm);
$context = context_module::instance($cm->id);

$PAGE->set_url('/mod/aiassignment/sus_survey.php', ['id' => $cmid]);
$PAGE->set_title('Encuesta de Usabilidad');
$PAGE->set_context($context);
$PAGE->set_pagelayout('incourse');

// ── Guardar respuestas ────────────────────────────────────────
if ($action === 'save' && confirm_sesskey()) {
    $responses = [];
    for ($i = 1; $i <= 10; $i++) {
        $responses[$i] = required_param('q' . $i, PARAM_INT);
        $responses[$i] = max(1, min(5, $responses[$i]));
    }

    // Calcular score SUS
    $score = 0;
    for ($i = 1; $i <= 10; $i++) {
        if ($i % 2 === 1) { // Preguntas impares: (respuesta - 1)
            $score += $responses[$i] - 1;
        } else {            // Preguntas pares: (5 - respuesta)
            $score += 5 - $responses[$i];
        }
    }
    $sus_score = $score * 2.5; // Escala 0-100

    // Guardar en BD
    $record = new stdClass();
    $record->userid      = $USER->id;
    $record->cmid        = $cmid;
    $record->responses   = json_encode($responses);
    $record->sus_score   = $sus_score;
    $record->timecreated = time();

    try {
        $DB->insert_record('aiassignment_sus_surveys', $record);
    } catch (Exception $e) {
        // Tabla puede no existir aún — guardar en sesión
        $_SESSION['sus_result_' . $cmid] = $sus_score;
    }

    // Mostrar resultado
    echo $OUTPUT->header();
    $grade = $sus_score >= 85 ? 'Excelente' : ($sus_score >= 70 ? 'Bueno' : ($sus_score >= 50 ? 'Aceptable' : 'Necesita mejoras'));
    $color = $sus_score >= 85 ? '#28a745' : ($sus_score >= 70 ? '#17a2b8' : ($sus_score >= 50 ? '#ffc107' : '#dc3545'));

    echo '<div style="max-width:500px;margin:40px auto;text-align:center;font-family:sans-serif;">';
    echo '<div style="font-size:64px;font-weight:700;color:' . $color . ';">' . round($sus_score, 1) . '</div>';
    echo '<div style="font-size:20px;color:#333;margin-bottom:8px;">Score SUS</div>';
    echo '<div style="font-size:16px;color:' . $color . ';font-weight:600;margin-bottom:20px;">' . $grade . '</div>';
    echo '<p style="color:#666;font-size:14px;">Gracias por completar la encuesta. Tu opinión ayuda a mejorar el sistema.</p>';
    echo html_writer::link(
        new moodle_url('/mod/aiassignment/view.php', ['id' => $cmid]),
        '← Volver a la tarea', ['class' => 'btn btn-primary', 'style' => 'margin-top:16px;']
    );
    echo '</div>';
    echo $OUTPUT->footer();
    exit;
}

// ── Mostrar encuesta ──────────────────────────────────────────
// Verificar si ya respondió
$already = false;
try {
    $already = $DB->record_exists('aiassignment_sus_surveys',
        ['userid' => $USER->id, 'cmid' => $cmid]);
} catch (Exception $e) {}

echo $OUTPUT->header();

if ($already) {
    echo html_writer::tag('div',
        '✅ Ya completaste esta encuesta. ¡Gracias por tu participación!',
        ['class' => 'alert alert-success', 'style' => 'max-width:600px;margin:40px auto;']);
    echo html_writer::div(
        html_writer::link(new moodle_url('/mod/aiassignment/view.php', ['id' => $cmid]),
            '← Volver', ['class' => 'btn btn-secondary']),
        '', ['style' => 'text-align:center;']
    );
    echo $OUTPUT->footer();
    exit;
}

$questions = [
    1  => 'Creo que me gustaría usar este sistema frecuentemente.',
    2  => 'Encontré el sistema innecesariamente complejo.',
    3  => 'Pensé que el sistema era fácil de usar.',
    4  => 'Creo que necesitaría el apoyo de un técnico para poder usar este sistema.',
    5  => 'Encontré que las diversas funciones de este sistema estaban bien integradas.',
    6  => 'Pensé que había demasiada inconsistencia en este sistema.',
    7  => 'Imagino que la mayoría de las personas aprenderían a usar este sistema muy rápidamente.',
    8  => 'Encontré el sistema muy engorroso de usar.',
    9  => 'Me sentí muy seguro usando el sistema.',
    10 => 'Necesité aprender muchas cosas antes de poder empezar a usar este sistema.',
];

echo '<div style="max-width:700px;margin:0 auto;font-family:sans-serif;padding:20px;">';
echo '<h2 style="color:#1a73e8;margin-bottom:8px;">📋 Encuesta de Usabilidad</h2>';
echo '<p style="color:#666;margin-bottom:24px;font-size:14px;">Por favor indica tu nivel de acuerdo con cada afirmación sobre el sistema de evaluación con IA. Esta encuesta es anónima y toma menos de 2 minutos.</p>';

echo '<form method="post" action="' . (new moodle_url('/mod/aiassignment/sus_survey.php', ['id' => $cmid, 'action' => 'save']))->out(false) . '">';
echo html_writer::empty_tag('input', ['type' => 'hidden', 'name' => 'sesskey', 'value' => sesskey()]);

$labels = ['Totalmente en desacuerdo', 'En desacuerdo', 'Neutral', 'De acuerdo', 'Totalmente de acuerdo'];

foreach ($questions as $num => $text) {
    echo '<div style="background:#f8f9fa;border-radius:8px;padding:16px;margin-bottom:12px;">';
    echo '<p style="font-weight:600;margin:0 0 12px;font-size:14px;color:#333;">' . $num . '. ' . htmlspecialchars($text) . '</p>';
    echo '<div style="display:flex;justify-content:space-between;gap:8px;">';
    for ($v = 1; $v <= 5; $v++) {
        echo '<label style="flex:1;text-align:center;cursor:pointer;">';
        echo '<input type="radio" name="q' . $num . '" value="' . $v . '" required style="display:block;margin:0 auto 4px;">';
        echo '<span style="font-size:11px;color:#666;">' . $labels[$v - 1] . '</span>';
        echo '</label>';
    }
    echo '</div></div>';
}

echo '<div style="text-align:center;margin-top:20px;">';
echo '<button type="submit" class="btn btn-primary" style="padding:10px 32px;font-size:16px;">Enviar encuesta</button>';
echo '</div>';
echo '</form>';
echo '</div>';
echo $OUTPUT->footer();
