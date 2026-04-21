<?php
// This file is part of Moodle - http://moodle.org/

require_once('../../config.php');
require_once($CFG->dirroot.'/mod/aiassignment/lib.php');

$id = required_param('id', PARAM_INT); // Submission ID

$submission = $DB->get_record('aiassignment_submissions', array('id' => $id), '*', MUST_EXIST);
$aiassignment = $DB->get_record('aiassignment', array('id' => $submission->assignment), '*', MUST_EXIST);
$cm = get_coursemodule_from_instance('aiassignment', $aiassignment->id, 0, false, MUST_EXIST);
$course = $DB->get_record('course', array('id' => $cm->course), '*', MUST_EXIST);
$student = $DB->get_record('user', array('id' => $submission->userid), '*', MUST_EXIST);

require_login($course, true, $cm);
$context = context_module::instance($cm->id);

// Verificar permisos
$cangrade = has_capability('mod/aiassignment:grade', $context);
$isownsubmission = ($USER->id == $submission->userid);

if (!$cangrade && !$isownsubmission) {
    throw new moodle_exception('nopermissions', 'error', '', 'view submission');
}

$PAGE->set_url('/mod/aiassignment/submission.php', array('id' => $id));
$PAGE->set_title(format_string($aiassignment->name));
$PAGE->set_heading(format_string($course->fullname));
$PAGE->set_context($context);

echo $OUTPUT->header();
echo $OUTPUT->heading(get_string('submissiondetails', 'aiassignment'));

// Información del envío
echo $OUTPUT->box_start('generalbox submissioninfo');
echo html_writer::tag('h3', get_string('submissioninfo', 'aiassignment'));

$table = new html_table();
$table->attributes['class'] = 'generaltable';

$table->data[] = array(
    html_writer::tag('strong', get_string('student', 'aiassignment')),
    fullname($student)
);
$table->data[] = array(
    html_writer::tag('strong', get_string('submitted', 'aiassignment')),
    userdate($submission->timecreated)
);
$table->data[] = array(
    html_writer::tag('strong', get_string('attempt', 'aiassignment')),
    $submission->attempt
);
$table->data[] = array(
    html_writer::tag('strong', get_string('status', 'aiassignment')),
    get_string($submission->status, 'aiassignment')
);

echo html_writer::table($table);
echo $OUTPUT->box_end();

// Respuesta del estudiante
echo $OUTPUT->box_start('generalbox studentanswer');
echo html_writer::tag('h3', get_string('youranswer', 'aiassignment'));
echo html_writer::tag('pre',
    html_writer::tag('code', s($submission->answer)),
    array('class' => 'answer-content', 'style' => 'background:#f6f8fa; border-radius:6px; padding:16px; overflow-x:auto;')
);
echo $OUTPUT->box_end();

// Comparación lado a lado (solo profesores)
if ($cangrade) {
    echo $OUTPUT->box_start('generalbox');
    echo html_writer::tag('h3', '🔍 Comparación con Solución de Referencia');
    echo html_writer::start_tag('div', ['style' => 'display:grid;grid-template-columns:1fr 1fr;gap:16px;']);

    // Columna alumno
    echo html_writer::start_div('');
    echo html_writer::tag('p', html_writer::tag('strong', '👤 Respuesta del Estudiante'), ['style' => 'margin-bottom:6px;']);
    echo html_writer::tag('pre',
        html_writer::tag('code', s($submission->answer)),
        ['id' => 'code-student',
         'style' => 'background:#f6f8fa;border-radius:6px;padding:14px;overflow-x:auto;max-height:400px;overflow-y:auto;font-size:12px;border:1px solid #dee2e6;',
         'onscroll' => 'syncScroll(this, "code-solution")']);
    echo html_writer::end_div();

    // Columna solución
    echo html_writer::start_div('');
    echo html_writer::tag('p', html_writer::tag('strong', '✅ Solución de Referencia'), ['style' => 'margin-bottom:6px;']);
    echo html_writer::tag('pre',
        html_writer::tag('code', s($aiassignment->solution)),
        ['id' => 'code-solution',
         'style' => 'background:#f0fff4;border-radius:6px;padding:14px;overflow-x:auto;max-height:400px;overflow-y:auto;font-size:12px;border:1px solid #c3e6cb;',
         'onscroll' => 'syncScroll(this, "code-student")']);
    echo html_writer::end_div();

    echo html_writer::end_tag('div');
    echo html_writer::tag('script', '
var _syncing = false;
function syncScroll(src, targetId) {
    if (_syncing) return;
    _syncing = true;
    var target = document.getElementById(targetId);
    if (target) {
        target.scrollTop = src.scrollTop;
        target.scrollLeft = src.scrollLeft;
    }
    _syncing = false;
}
');
    echo $OUTPUT->box_end();
}

// Evaluación (si existe)
if ($submission->status == 'evaluated' && $submission->score !== null) {
    echo $OUTPUT->box_start('generalbox evaluation');
    echo html_writer::tag('h3', get_string('evaluation', 'aiassignment'));
    
    // Calificación
    echo html_writer::tag('div', 
        html_writer::tag('span', get_string('score', 'aiassignment') . ': ', array('class' => 'label')) .
        html_writer::tag('span', round($submission->score, 2) . '%', array('class' => 'score-value')),
        array('class' => 'score-display')
    );
    
    // Barra de progreso
    $percentage = round($submission->score);
    echo html_writer::start_div('progress', array('style' => 'height: 30px; margin: 15px 0;'));
    echo html_writer::div('', 'progress-bar bg-primary', array(
        'role' => 'progressbar',
        'style' => 'width: ' . $percentage . '%',
        'aria-valuenow' => $percentage,
        'aria-valuemin' => '0',
        'aria-valuemax' => '100'
    ));
    echo html_writer::end_div();
    
    // Retroalimentación
    if ($submission->feedback) {
        echo html_writer::tag('h4', get_string('feedback', 'aiassignment'));
        echo html_writer::tag('div', s($submission->feedback), array('class' => 'feedback-content'));
    }

    // ── Análisis de complejidad (solo programación) ───────────
    if ($aiassignment->type === 'programming') {
        $complexity = \mod_aiassignment\complexity_analyzer::analyze($submission->answer);
        echo \mod_aiassignment\complexity_analyzer::render($complexity);
    }

    // ── Resultados de ejecución con Judge0 ────────────────────
    $evaluation = $DB->get_record('aiassignment_evaluations',
        array('submission' => $submission->id), '*', IGNORE_MULTIPLE);

    if ($evaluation && !empty($aiassignment->test_cases) && $aiassignment->type === 'programming') {
        $testcases = \mod_aiassignment\code_executor::parse_testcases($aiassignment->test_cases);
        if (!empty($testcases)) {
            // Verificar si ya hay resultados de ejecución guardados
            $exec_results = null;
            if ($evaluation->ai_analysis) {
                $analysis_data = json_decode($evaluation->ai_analysis, true);
                if (!empty($analysis_data['execution_results'])) {
                    $exec_results = $analysis_data['execution_results'];
                }
            }
            if ($exec_results === null) {
                // Detectar lenguaje del código
                $lang = 'python';
                if (preg_match('/\bpublic\s+class\b/', $submission->answer)) $lang = 'java';
                elseif (preg_match('/\bconsole\.log\b/', $submission->answer)) $lang = 'javascript';
                elseif (preg_match('/\b#include\b/', $submission->answer)) $lang = 'cpp';
                $exec_results = \mod_aiassignment\code_executor::run($submission->answer, $lang, $testcases);
            }
            echo \mod_aiassignment\code_executor::render_results($exec_results);
        }
    }
    
    // Análisis detallado de IA
    $evaluation = $DB->get_record('aiassignment_evaluations', 
        array('submission' => $submission->id), '*', IGNORE_MULTIPLE);
    
    if ($evaluation && $evaluation->ai_analysis) {
        echo html_writer::tag('h4', get_string('aianalysis', 'aiassignment'));

        // Mejora 7: Feedback expandible por sección
        $raw_analysis = $evaluation->ai_analysis;
        $sections_map = [
            'Funcionalidad'    => '⚙️',
            'Estilo'           => '🎨',
            'Eficiencia'       => '⚡',
            'Buenas prácticas' => '✅',
            'Buenas Prácticas' => '✅',
        ];

        // Intentar detectar secciones en el texto
        $found_sections = [];
        foreach ($sections_map as $section_name => $emoji) {
            // Buscar "Sección:" o "**Sección**" o "Sección\n"
            if (preg_match('/' . preg_quote($section_name, '/') . '\s*[:\*\n]/i', $raw_analysis)) {
                $found_sections[$section_name] = $emoji;
            }
        }

        if (!empty($found_sections)) {
            // Dividir el texto por las secciones encontradas
            $pattern = '/(' . implode('|', array_map(fn($s) => preg_quote($s, '/'), array_keys($found_sections))) . ')\s*[:\*]?\s*/i';
            $parts   = preg_split($pattern, $raw_analysis, -1, PREG_SPLIT_DELIM_CAPTURE);

            echo html_writer::start_div('analysis-sections');
            $i = 0;
            // First part before any section (intro text)
            if (!empty(trim($parts[0]))) {
                echo html_writer::tag('div', nl2br(s(trim($parts[0]))),
                    ['class' => 'analysis-intro', 'style' => 'margin-bottom:8px; font-size:0.9rem;']);
            }
            $i = 1;
            while ($i < count($parts)) {
                $sec_name = $parts[$i] ?? '';
                $sec_body = $parts[$i + 1] ?? '';
                $emoji    = $found_sections[$sec_name] ?? $found_sections[ucfirst(strtolower($sec_name))] ?? '📌';
                echo '<details style="margin-bottom:8px; border:1px solid #dee2e6; border-radius:6px; padding:0;">';
                echo '<summary style="padding:10px 14px; cursor:pointer; font-weight:600; background:#f8f9fa; border-radius:6px; list-style:none; display:flex; align-items:center; gap:6px;">';
                echo s($emoji . ' ' . $sec_name);
                echo '</summary>';
                echo '<div style="padding:12px 14px; font-size:0.9rem; line-height:1.6;">';
                echo nl2br(s(trim($sec_body)));
                echo '</div></details>';
                $i += 2;
            }
            echo html_writer::end_div();
        } else {
            // Sin secciones detectadas: mostrar texto completo
            echo html_writer::tag('div', nl2br(s($raw_analysis)),
                ['class' => 'analysis-content']);
        }
    }
    
    echo $OUTPUT->box_end();
}

// Botón de re-evaluación (solo para profesores)
if ($cangrade && $submission->status == 'evaluated') {
    echo $OUTPUT->box_start('generalbox reevaluate');
    echo html_writer::tag('h4', get_string('reevaluate', 'aiassignment'));
    echo html_writer::tag('p', get_string('reevaluate_help', 'aiassignment'));
    
    $reevaluateurl = new moodle_url('/mod/aiassignment/reevaluate.php', 
        array('id' => $submission->id, 'sesskey' => sesskey()));
    echo html_writer::link($reevaluateurl, get_string('reevaluate', 'aiassignment'), 
        array('class' => 'btn btn-warning'));
    echo $OUTPUT->box_end();
}

// ── Solicitar re-envío (solo para profesores) ─────────────────
if ($cangrade) {
    echo $OUTPUT->box_start('generalbox');
    echo html_writer::tag('h4', '📝 Solicitar Re-envío al Estudiante');
    echo html_writer::tag('p',
        'Marca este envío como inválido y notifica al estudiante para que envíe una nueva versión. ' .
        'El alumno podrá enviar aunque haya alcanzado el límite de intentos.');

    if ($submission->status === 'flagged') {
        echo html_writer::tag('div',
            '⚠️ Ya se solicitó un re-envío. El alumno puede enviar una nueva versión.',
            ['class' => 'alert alert-warning', 'style' => 'margin-bottom:12px;']);
    }

    $resubmit_url = new moodle_url('/mod/aiassignment/request_resubmit.php');
    echo html_writer::start_tag('form', ['method' => 'post', 'action' => $resubmit_url->out(false)]);
    echo html_writer::empty_tag('input', ['type' => 'hidden', 'name' => 'sid',     'value' => $submission->id]);
    echo html_writer::empty_tag('input', ['type' => 'hidden', 'name' => 'sesskey', 'value' => sesskey()]);
    echo html_writer::tag('label', 'Motivo (opcional):',
        ['for' => 'resubmit_reason', 'style' => 'display:block;font-weight:600;margin-bottom:6px;font-size:13px;']);
    echo html_writer::tag('textarea', '',
        ['id' => 'resubmit_reason', 'name' => 'reason', 'rows' => '3',
         'placeholder' => 'Ej: Se detectó plagio. Por favor envía una solución original.',
         'style' => 'width:100%;padding:8px;border-radius:6px;border:1px solid #dee2e6;font-size:13px;margin-bottom:10px;resize:vertical;']);
    echo html_writer::tag('button', '📩 Solicitar Re-envío',
        ['type' => 'submit', 'class' => 'btn btn-danger',
         'onclick' => "return confirm('¿Solicitar re-envío a " . s(fullname($student)) . "? Recibirá una notificación.');"]);
    echo html_writer::end_tag('form');
    echo $OUTPUT->box_end();
}

// Solo para profesores, cuando el envío está evaluado
if ($cangrade) {
    echo $OUTPUT->box_start('generalbox');
    echo html_writer::tag('h4', '✏️ Calificación Manual');
    echo html_writer::tag('p', 'Sobrescribe la calificación de la IA. Ingresa un valor entre 0 y 100.');

    $grade_url = new moodle_url('/mod/aiassignment/manual_grade.php');
    echo html_writer::start_tag('form', ['method' => 'post', 'action' => $grade_url->out(false), 'style' => 'display:flex;gap:10px;align-items:flex-end;flex-wrap:wrap;']);
    echo html_writer::empty_tag('input', ['type' => 'hidden', 'name' => 'sid', 'value' => $submission->id]);
    echo html_writer::empty_tag('input', ['type' => 'hidden', 'name' => 'sesskey', 'value' => sesskey()]);

    echo html_writer::start_div('', ['style' => 'display:flex;flex-direction:column;gap:4px;']);
    echo html_writer::tag('label', 'Calificación (0-100):', ['for' => 'manual_score', 'style' => 'font-size:13px;font-weight:600;']);
    echo html_writer::empty_tag('input', ['type' => 'number', 'id' => 'manual_score', 'name' => 'score',
        'min' => '0', 'max' => '100', 'step' => '0.5',
        'value' => $submission->score !== null ? round($submission->score, 1) : '',
        'style' => 'padding:7px 10px;border-radius:6px;border:1px solid #dee2e6;width:120px;font-size:14px;']);
    echo html_writer::end_div();

    echo html_writer::start_div('', ['style' => 'display:flex;flex-direction:column;gap:4px;flex:1;min-width:200px;']);
    echo html_writer::tag('label', 'Comentario del profesor:', ['for' => 'manual_comment', 'style' => 'font-size:13px;font-weight:600;']);
    echo html_writer::empty_tag('input', ['type' => 'text', 'id' => 'manual_comment', 'name' => 'comment',
        'placeholder' => 'Ej: Revisado manualmente. Solución correcta.',
        'style' => 'padding:7px 10px;border-radius:6px;border:1px solid #dee2e6;font-size:13px;width:100%;']);
    echo html_writer::end_div();

    echo html_writer::tag('button', '💾 Guardar calificación',
        ['type' => 'submit', 'class' => 'btn btn-success',
         'style' => 'align-self:flex-end;']);
    echo html_writer::end_tag('form');

    // Mostrar historial de cambios de calificación (Mejora 6)
    $eval_hist = $DB->get_record('aiassignment_evaluations', ['submission' => $submission->id]);
    if ($eval_hist && $eval_hist->ai_analysis) {
        $hist_data = json_decode($eval_hist->ai_analysis, true);
        if (!empty($hist_data['grade_history'])) {
            echo html_writer::tag('h5', '📋 Historial de cambios de calificación',
                ['style' => 'margin-top:14px;font-size:13px;color:#555;']);
            foreach (array_reverse($hist_data['grade_history']) as $h) {
                $changer = $DB->get_record('user', ['id' => $h['changed_by']], 'firstname,lastname');
                echo html_writer::tag('div',
                    userdate($h['changed_at'], '%d/%m/%Y %H:%M') . ' — ' .
                    html_writer::tag('strong', fullname($changer)) . ': ' .
                    round($h['old_score'] ?? 0, 1) . '% → ' .
                    html_writer::tag('strong', round($h['new_score'], 1) . '%',
                        ['style' => 'color:#28a745;']) .
                    (!empty($h['comment']) ? ' (' . s($h['comment']) . ')' : ''),
                    ['style' => 'font-size:12px;color:#666;padding:4px 0;border-bottom:1px solid #f0f0f0;']
                );
            }
        }
    }

    echo $OUTPUT->box_end();
}

// Botones de navegación
echo html_writer::start_div('navigation-buttons', array('style' => 'margin-top: 20px;'));

if ($cangrade) {
    echo $OUTPUT->single_button(
        new moodle_url('/mod/aiassignment/submissions.php', array('id' => $cm->id)),
        get_string('backtosubmissions', 'aiassignment'),
        'get'
    );
} else {
    echo $OUTPUT->single_button(
        new moodle_url('/mod/aiassignment/view.php', array('id' => $cm->id)),
        get_string('backtocourse', 'moodle'),
        'get'
    );
}

echo html_writer::end_div();

// Highlight.js para resaltado de sintaxis (mejora #5) — cargado inline para evitar restricciones de Moodle
echo '
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/github.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/highlight.min.js"></script>
<script>document.querySelectorAll("pre code").forEach(function(el){ hljs.highlightElement(el); });</script>
';

echo $OUTPUT->footer();
