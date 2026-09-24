<?php
// Encuesta de satisfacción rápida post-tarea — Mejora #5
require_once('../../config.php');
require_once($CFG->dirroot . '/mod/aiassignment/lib.php');

$cmid   = required_param('id',     PARAM_INT);
$sid    = required_param('sid',    PARAM_INT); // submission id
$action = optional_param('action', 'show', PARAM_ALPHA);

$cm = get_coursemodule_from_id('aiassignment', $cmid, 0, false, MUST_EXIST);
require_login($cm->course, false, $cm);
$context = context_module::instance($cm->id);

// ── Guardar respuesta ─────────────────────────────────────────
if ($action === 'save' && confirm_sesskey()) {
    $rating    = required_param('rating',    PARAM_INT);
    $difficulty = optional_param('difficulty', 3, PARAM_INT);
    $comment   = optional_param('comment',   '', PARAM_TEXT);

    $rating     = max(1, min(5, $rating));
    $difficulty = max(1, min(5, $difficulty));

    try {
        $DB->insert_record('aiassignment_satisfaction', (object)[
            'userid'      => $USER->id,
            'cmid'        => $cmid,
            'submissionid'=> $sid,
            'rating'      => $rating,
            'difficulty'  => $difficulty,
            'comment'     => clean_param($comment, PARAM_TEXT),
            'timecreated' => time(),
        ]);
    } catch (Exception $e) {
        // Ignorar si la tabla no existe
    }

    redirect(
        new moodle_url('/mod/aiassignment/view.php', ['id' => $cmid]),
        '✅ ¡Gracias por tu opinión!',
        null,
        \core\output\notification::NOTIFY_SUCCESS
    );
}

// ── Mostrar encuesta ──────────────────────────────────────────
$PAGE->set_url('/mod/aiassignment/satisfaction_survey.php', ['id' => $cmid, 'sid' => $sid]);
$PAGE->set_title('¿Cómo fue tu experiencia?');
$PAGE->set_context($context);
$PAGE->set_pagelayout('popup');

echo $OUTPUT->header();

echo '<div style="max-width:480px;margin:20px auto;font-family:sans-serif;padding:20px;">';
echo '<h3 style="color:#1a73e8;margin-bottom:4px;">¿Cómo fue tu experiencia?</h3>';
echo '<p style="color:#888;font-size:13px;margin-bottom:20px;">Solo 3 preguntas rápidas</p>';

$form_url = new moodle_url('/mod/aiassignment/satisfaction_survey.php',
    ['id' => $cmid, 'sid' => $sid, 'action' => 'save']);

echo '<form method="post" action="' . $form_url->out(false) . '">';
echo html_writer::empty_tag('input', ['type' => 'hidden', 'name' => 'sesskey', 'value' => sesskey()]);

// Pregunta 1: Satisfacción general (estrellas)
echo '<div style="margin-bottom:20px;">';
echo '<p style="font-weight:600;margin-bottom:8px;">1. ¿Qué tan útil fue el feedback de la IA?</p>';
echo '<div style="display:flex;gap:8px;font-size:32px;">';
for ($i = 1; $i <= 5; $i++) {
    echo '<label style="cursor:pointer;" title="' . $i . ' estrella(s)">';
    echo '<input type="radio" name="rating" value="' . $i . '" required style="display:none;" ' .
         'onchange="updateStars(this)">';
    echo '<span class="star" data-val="' . $i . '" style="color:#dee2e6;transition:color .1s;">★</span>';
    echo '</label>';
}
echo '</div></div>';

// Pregunta 2: Dificultad
echo '<div style="margin-bottom:20px;">';
echo '<p style="font-weight:600;margin-bottom:8px;">2. ¿Qué tan difícil fue la tarea?</p>';
$diff_labels = ['Muy fácil', 'Fácil', 'Normal', 'Difícil', 'Muy difícil'];
echo '<div style="display:flex;gap:6px;flex-wrap:wrap;">';
for ($i = 1; $i <= 5; $i++) {
    echo '<label style="cursor:pointer;">';
    echo '<input type="radio" name="difficulty" value="' . $i . '" style="margin-right:4px;">';
    echo htmlspecialchars($diff_labels[$i - 1]);
    echo '</label>';
}
echo '</div></div>';

// Pregunta 3: Comentario libre
echo '<div style="margin-bottom:20px;">';
echo '<p style="font-weight:600;margin-bottom:8px;">3. ¿Algún comentario? (opcional)</p>';
echo '<textarea name="comment" rows="3" style="width:100%;padding:8px;border-radius:6px;border:1px solid #dee2e6;font-size:13px;resize:vertical;" placeholder="Tu opinión nos ayuda a mejorar..."></textarea>';
echo '</div>';

echo '<div style="display:flex;gap:10px;">';
echo '<button type="submit" class="btn btn-primary" style="flex:1;">Enviar</button>';
echo html_writer::link(
    new moodle_url('/mod/aiassignment/view.php', ['id' => $cmid]),
    'Omitir', ['class' => 'btn btn-outline-secondary', 'style' => 'flex:1;text-align:center;']
);
echo '</div>';
echo '</form>';

echo '<script>
function updateStars(input) {
    var val = parseInt(input.value);
    document.querySelectorAll(".star").forEach(function(s) {
        s.style.color = parseInt(s.dataset.val) <= val ? "#ffc107" : "#dee2e6";
    });
}
</script>';

echo '</div>';
echo $OUTPUT->footer();
