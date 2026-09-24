<?php
// Peer Review anónimo — Mejora #4
require_once('../../config.php');
require_once($CFG->dirroot . '/mod/aiassignment/lib.php');

$cmid   = required_param('id',     PARAM_INT);
$action = optional_param('action', 'show', PARAM_ALPHA);

$cm           = get_coursemodule_from_id('aiassignment', $cmid, 0, false, MUST_EXIST);
$course       = $DB->get_record('course', ['id' => $cm->course], '*', MUST_EXIST);
$aiassignment = $DB->get_record('aiassignment', ['id' => $cm->instance], '*', MUST_EXIST);

require_login($course, true, $cm);
$context = context_module::instance($cm->id);
require_capability('mod/aiassignment:submit', $context);

$PAGE->set_url('/mod/aiassignment/peer_review.php', ['id' => $cmid]);
$PAGE->set_title('Revisión entre pares — ' . format_string($aiassignment->name));
$PAGE->set_context($context);
$PAGE->set_pagelayout('incourse');

// ── Guardar revisión ──────────────────────────────────────────
if ($action === 'save' && confirm_sesskey()) {
    $reviewed_sub_id = required_param('reviewed_id', PARAM_INT);
    $score           = required_param('peer_score',  PARAM_INT);
    $feedback        = required_param('peer_feedback', PARAM_TEXT);

    $score = max(0, min(100, $score));

    // Verificar que no se revise a sí mismo
    $reviewed_sub = $DB->get_record('aiassignment_submissions',
        ['id' => $reviewed_sub_id], 'userid', MUST_EXIST);
    if ($reviewed_sub->userid === $USER->id) {
        redirect(new moodle_url('/mod/aiassignment/peer_review.php', ['id' => $cmid]),
            '⚠️ No puedes revisar tu propio envío.', null,
            \core\output\notification::NOTIFY_WARNING);
    }

    try {
        $DB->insert_record('aiassignment_peer_reviews', (object)[
            'reviewer_id'  => $USER->id,
            'submission_id'=> $reviewed_sub_id,
            'score'        => $score,
            'feedback'     => clean_param($feedback, PARAM_TEXT),
            'timecreated'  => time(),
        ]);
        redirect(new moodle_url('/mod/aiassignment/peer_review.php', ['id' => $cmid]),
            '✅ Revisión enviada. ¡Gracias!', null,
            \core\output\notification::NOTIFY_SUCCESS);
    } catch (Exception $e) {
        redirect(new moodle_url('/mod/aiassignment/peer_review.php', ['id' => $cmid]),
            '❌ Error al guardar la revisión.', null,
            \core\output\notification::NOTIFY_ERROR);
    }
}

// ── Obtener envío aleatorio para revisar ─────────────────────
// Excluir: el propio envío del usuario y los que ya revisó
$already_reviewed = $DB->get_fieldset_select(
    'aiassignment_peer_reviews', 'submission_id',
    'reviewer_id = :uid', ['uid' => $USER->id]
) ?: [0];

list($not_in_sql, $not_in_params) = $DB->get_in_or_equal($already_reviewed, SQL_PARAMS_NAMED, 'pr', false);
$not_in_params['assignment'] = $aiassignment->id;
$not_in_params['userid']     = $USER->id;

$to_review = $DB->get_records_sql(
    "SELECT s.id, s.answer, s.score, s.attempt
     FROM {aiassignment_submissions} s
     WHERE s.assignment = :assignment
       AND s.userid != :userid
       AND s.status = 'evaluated'
       AND s.id $not_in_sql
     ORDER BY RAND()
     LIMIT 1",
    $not_in_params
);

echo $OUTPUT->header();
echo html_writer::tag('h2', '👥 Revisión entre Pares', ['style' => 'color:#1a73e8;']);
echo html_writer::tag('p',
    'Revisa el código de un compañero de forma anónima. Tu identidad no será revelada.',
    ['style' => 'color:#666;font-size:14px;margin-bottom:20px;']);

if (empty($to_review)) {
    echo html_writer::tag('div',
        '✅ Ya revisaste todos los envíos disponibles, o no hay envíos para revisar aún.',
        ['class' => 'alert alert-info']);
} else {
    $sub = reset($to_review);

    echo '<div style="background:#f8f9fa;border-radius:8px;padding:16px;margin-bottom:20px;">';
    echo '<h4 style="margin-bottom:8px;">📄 Código a revisar</h4>';
    echo '<pre style="background:#1e1e1e;color:#d4d4d4;padding:16px;border-radius:6px;overflow-x:auto;font-size:13px;">';
    echo htmlspecialchars($sub->answer);
    echo '</pre></div>';

    $form_url = new moodle_url('/mod/aiassignment/peer_review.php',
        ['id' => $cmid, 'action' => 'save']);
    echo '<form method="post" action="' . $form_url->out(false) . '">';
    echo html_writer::empty_tag('input', ['type' => 'hidden', 'name' => 'sesskey',     'value' => sesskey()]);
    echo html_writer::empty_tag('input', ['type' => 'hidden', 'name' => 'reviewed_id', 'value' => $sub->id]);

    echo '<div style="margin-bottom:16px;">';
    echo '<label style="font-weight:600;display:block;margin-bottom:6px;">Calificación (0-100):</label>';
    echo '<input type="number" name="peer_score" min="0" max="100" required
          style="padding:8px;border-radius:6px;border:1px solid #dee2e6;width:120px;font-size:14px;">';
    echo '</div>';

    echo '<div style="margin-bottom:16px;">';
    echo '<label style="font-weight:600;display:block;margin-bottom:6px;">Feedback constructivo:</label>';
    echo '<textarea name="peer_feedback" rows="5" required
          style="width:100%;padding:10px;border-radius:6px;border:1px solid #dee2e6;font-size:13px;resize:vertical;"
          placeholder="Describe qué está bien, qué se puede mejorar y por qué..."></textarea>';
    echo '</div>';

    echo '<button type="submit" class="btn btn-primary">Enviar revisión</button> ';
    echo html_writer::link(
        new moodle_url('/mod/aiassignment/view.php', ['id' => $cmid]),
        'Cancelar', ['class' => 'btn btn-secondary']
    );
    echo '</form>';
}

// Mostrar revisiones recibidas por el usuario
$received = $DB->get_records_sql(
    "SELECT pr.score, pr.feedback, pr.timecreated
     FROM {aiassignment_peer_reviews} pr
     JOIN {aiassignment_submissions} s ON pr.submission_id = s.id
     WHERE s.userid = :uid AND s.assignment = :aid
     ORDER BY pr.timecreated DESC",
    ['uid' => $USER->id, 'aid' => $aiassignment->id]
);

if (!empty($received)) {
    echo '<hr style="margin:24px 0;">';
    echo '<h4>📬 Revisiones que recibiste</h4>';
    foreach ($received as $r) {
        $color = $r->score >= 80 ? '#28a745' : ($r->score >= 60 ? '#ffc107' : '#dc3545');
        echo '<div style="border-left:4px solid ' . $color . ';padding:12px 16px;background:#f8f9fa;border-radius:0 8px 8px 0;margin-bottom:10px;">';
        echo '<div style="font-weight:700;color:' . $color . ';margin-bottom:4px;">' . $r->score . '/100</div>';
        echo '<div style="font-size:13px;color:#555;">' . htmlspecialchars($r->feedback) . '</div>';
        echo '<div style="font-size:11px;color:#999;margin-top:4px;">' . userdate($r->timecreated) . '</div>';
        echo '</div>';
    }
}

echo $OUTPUT->footer();
