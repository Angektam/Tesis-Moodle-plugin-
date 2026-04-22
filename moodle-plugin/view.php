<?php
// This file is part of Moodle - http://moodle.org/

require_once('../../config.php');
require_once($CFG->dirroot.'/mod/aiassignment/lib.php');

$id = optional_param('id', 0, PARAM_INT); // Course Module ID
$a = optional_param('a', 0, PARAM_INT);   // aiassignment ID

if ($id) {
    $cm = get_coursemodule_from_id('aiassignment', $id, 0, false, MUST_EXIST);
    $course = $DB->get_record('course', array('id' => $cm->course), '*', MUST_EXIST);
    $aiassignment = $DB->get_record('aiassignment', array('id' => $cm->instance), '*', MUST_EXIST);
} else {
    $aiassignment = $DB->get_record('aiassignment', array('id' => $a), '*', MUST_EXIST);
    $course = $DB->get_record('course', array('id' => $aiassignment->course), '*', MUST_EXIST);
    $cm = get_coursemodule_from_instance('aiassignment', $aiassignment->id, $course->id, false, MUST_EXIST);
}

require_login($course, true, $cm);
$context = context_module::instance($cm->id);

// Disparar evento de vista
$event = \mod_aiassignment\event\course_module_viewed::create(array(
    'objectid' => $aiassignment->id,
    'context' => $context
));
$event->add_record_snapshot('course', $course);
$event->add_record_snapshot('aiassignment', $aiassignment);
$event->trigger();

// Configurar la página
$PAGE->set_url('/mod/aiassignment/view.php', array('id' => $cm->id));
$PAGE->set_title(format_string($aiassignment->name));
$PAGE->set_heading(format_string($course->fullname));
$PAGE->set_context($context);

// Verificar capacidades
$cansubmit = has_capability('mod/aiassignment:submit', $context);
$cangrade = has_capability('mod/aiassignment:grade', $context);

// Salida
echo $OUTPUT->header();
echo $OUTPUT->heading(format_string($aiassignment->name));

// Show dashboard link for teachers
if ($cangrade) {
    $dashboard_url = new moodle_url('/mod/aiassignment/dashboard.php', array('courseid' => $course->id));
    echo html_writer::start_div('dashboard-link-container', array('style' => 'margin-bottom: 20px;'));
    echo html_writer::link($dashboard_url, 
        html_writer::tag('i', '', array('class' => 'fa fa-dashboard')) . ' ' . get_string('dashboard', 'mod_aiassignment'),
        array('class' => 'btn btn-primary', 'style' => 'margin-right: 10px;'));
    
    $submissions_url = new moodle_url('/mod/aiassignment/submissions.php', array('id' => $cm->id));
    echo html_writer::link($submissions_url, 
        html_writer::tag('i', '', array('class' => 'fa fa-list')) . ' ' . get_string('allsubmissions', 'mod_aiassignment'),
        array('class' => 'btn btn-secondary'));
    echo html_writer::end_div();
}

// Mostrar descripción
if ($aiassignment->intro) {
    echo $OUTPUT->box(format_module_intro('aiassignment', $aiassignment, $cm->id), 'generalbox', 'intro');
}

// Mostrar información del problema
echo $OUTPUT->box_start('generalbox');
echo '<h3>' . get_string('problemdescription', 'aiassignment') . '</h3>';
echo '<p><strong>' . get_string('type', 'aiassignment') . ':</strong> ' . 
     get_string($aiassignment->type, 'aiassignment') . '</p>';

if ($aiassignment->documentation) {
    echo '<div class="documentation">';
    echo '<h4>' . get_string('documentation', 'aiassignment') . '</h4>';
    echo '<pre>' . s($aiassignment->documentation) . '</pre>';
    echo '</div>';
}

if ($aiassignment->test_cases) {
    echo '<div class="testcases">';
    echo '<h4>' . get_string('testcases', 'aiassignment') . '</h4>';
    echo '<pre>' . s($aiassignment->test_cases) . '</pre>';
    echo '</div>';
}
echo $OUTPUT->box_end();

// Vista para estudiantes
if ($cansubmit && !$cangrade) {
    // Obtener envíos previos del usuario
    $submissions = $DB->get_records('aiassignment_submissions',
        array('assignment' => $aiassignment->id, 'userid' => $USER->id),
        'timecreated DESC');

    $attemptcount = count($submissions);

    // Verificar si puede enviar más intentos
    $cansubmitnow = true;
    if ($aiassignment->maxattempts > 0 && $attemptcount >= $aiassignment->maxattempts) {
        // Verificar si el último envío fue marcado como flagged (re-envío solicitado)
        $last_submission = reset($submissions);
        $resubmit_requested = ($last_submission && $last_submission->status === 'flagged');

        if (!$resubmit_requested) {
            $cansubmitnow = false;
            echo $OUTPUT->notification(get_string('maxattemptsreached', 'aiassignment'), 'notifyproblem');
        } else {
            // Mostrar aviso de re-envío solicitado
            echo html_writer::tag('div',
                '📝 El docente ha solicitado que envíes una nueva versión de tu trabajo.' .
                (!empty($last_submission->feedback) ? '<br><strong>Motivo:</strong> ' . s($last_submission->feedback) : ''),
                ['class' => 'alert alert-warning', 'style' => 'margin-bottom:16px;']);
        }
    }

    // Formulario de envío
    if ($cansubmitnow) {
        echo $OUTPUT->box_start('generalbox submitform');
        echo '<h3>' . get_string('submitanswer', 'aiassignment') . '</h3>';

        // ── Pista progresiva si hay intentos fallidos ─────────────
        if ($attemptcount >= 2) {
            $last_sub = reset($submissions);
            if ($last_sub && $last_sub->score !== null && $last_sub->score < 70) {
                $hint = \mod_aiassignment\hint_generator::generate(
                    $aiassignment->intro ?? $aiassignment->name,
                    $last_sub->answer,
                    $aiassignment->type,
                    $attemptcount
                );
                echo \mod_aiassignment\hint_generator::render($hint);
            }
        }

        // ── Enlace a peer review ──────────────────────────────────
        if ($attemptcount > 0) {
            $pr_url = new moodle_url('/mod/aiassignment/peer_review.php', ['id' => $cm->id]);
            echo html_writer::tag('div',
                '👥 ' . html_writer::link($pr_url, 'Revisar el código de un compañero', ['style' => 'color:#1a73e8;']),
                ['style' => 'font-size:13px;color:#666;margin-bottom:12px;']);
        }

        // Verificar si hay API key o modo demo activo
        $apikey   = get_config('mod_aiassignment', 'openai_api_key');
        $demomode = get_config('mod_aiassignment', 'demo_mode');
        if (empty($apikey) && !$demomode) {
            echo html_writer::tag('div',
                '⚠️ El sistema de evaluación automática no está configurado aún. ' .
                'Tu respuesta será guardada y evaluada cuando el profesor configure el sistema.',
                ['class' => 'alert alert-warning', 'style' => 'margin-bottom:12px;']);
        }
        
        if ($aiassignment->maxattempts > 0) {
            echo '<p>' . get_string('attemptsremaining', 'aiassignment', 
                $aiassignment->maxattempts - $attemptcount) . '</p>';
        }

        // ── Modo examen: detectar cambio de pestaña ──────────────────
        $exammode = (bool)get_config('mod_aiassignment', 'exam_mode');
        if ($exammode) {
            echo html_writer::tag('div',
                '🔒 Modo examen activo. Los cambios de pestaña serán registrados.',
                ['class' => 'alert alert-warning', 'id' => 'exam-warning']);
        }

        echo '<form method="post" action="submit.php" id="submission-form">';
        echo '<input type="hidden" name="id" value="' . $cm->id . '">';
        echo '<input type="hidden" name="sesskey" value="' . sesskey() . '">';
        echo '<input type="hidden" name="tab_switches" id="tab_switches_input" value="0">';

        // ── Selector de lenguaje ──────────────────────────────────────
        $lang_options = ['python' => 'Python', 'javascript' => 'JavaScript',
                         'java' => 'Java', 'cpp' => 'C/C++', 'php' => 'PHP', 'plaintext' => 'Texto'];
        $default_lang = $aiassignment->type === 'programming' ? 'python' : 'plaintext';
        echo '<div style="margin-bottom:8px;display:flex;align-items:center;gap:12px;">';
        echo '<label style="font-size:13px;font-weight:600;color:#555;">Lenguaje:</label>';
        echo '<select id="lang-selector" style="padding:5px 10px;border-radius:6px;border:1px solid #dee2e6;font-size:13px;">';
        foreach ($lang_options as $val => $label) {
            $sel = $val === $default_lang ? ' selected' : '';
            echo "<option value=\"$val\"$sel>$label</option>";
        }
        echo '</select>';
        echo '<span style="font-size:12px;color:#888;">💡 El editor tiene resaltado de sintaxis</span>';
        echo '</div>';

        // ── Editor Monaco ─────────────────────────────────────────────
        echo '<div id="monaco-editor-container" style="width:100%;height:380px;border:1px solid #dee2e6;border-radius:8px;overflow:hidden;margin-bottom:8px;"></div>';
        // Textarea oculto que se sincroniza con Monaco
        echo '<textarea id="id_answer" name="answer" style="display:none;" required></textarea>';

        echo '<div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:12px;">';
        echo '<span style="font-size:12px;color:#888;"><span id="char_counter">0</span> / 10000 ' . get_string('characters', 'aiassignment') . '</span>';
        echo '<span style="font-size:12px;color:#888;" id="line-counter">Línea 1, Col 1</span>';
        echo '</div>';

        echo '<input type="submit" id="submit-btn" value="' . get_string('submit', 'aiassignment') . '" class="btn btn-primary">';
        echo '<span id="eval-spinner" style="display:none; margin-left:12px; color:#555; font-size:14px;">
    ⏳ Enviando... tu respuesta será evaluada en breve.
</span>';
        echo '</form>';

        // ── Script Monaco + modo examen ───────────────────────────────
        $exam_js = $exammode ? '
            var tabSwitches = 0;
            document.addEventListener("visibilitychange", function() {
                if (document.hidden) {
                    tabSwitches++;
                    document.getElementById("tab_switches_input").value = tabSwitches;
                    var warn = document.getElementById("exam-warning");
                    if (warn) warn.innerHTML = "⚠️ Cambio de pestaña detectado (" + tabSwitches + " vez/veces). Esto será registrado.";
                }
            });
            document.addEventListener("contextmenu", function(e) { e.preventDefault(); });
            document.addEventListener("copy", function(e) {
                if (document.activeElement && document.activeElement.id === "id_answer") {
                    e.preventDefault();
                    alert("⚠️ Copiar está deshabilitado en modo examen.");
                }
            });
        ' : '';

        echo "
<script>
(function() {
    $exam_js

    function initMonaco() {
        require.config({ paths: { vs: 'https://cdn.jsdelivr.net/npm/monaco-editor@0.45.0/min/vs' }});
        require(['vs/editor/editor.main'], function() {
            var editor = monaco.editor.create(document.getElementById('monaco-editor-container'), {
                value: '',
                language: '" . $default_lang . "',
                theme: 'vs',
                fontSize: 14,
                minimap: { enabled: false },
                lineNumbers: 'on',
                wordWrap: 'on',
                automaticLayout: true,
                scrollBeyondLastLine: false,
                tabSize: 4,
                insertSpaces: true,
                formatOnPaste: true,
                suggestOnTriggerCharacters: true,
            });

            // Sincronizar con textarea oculto
            editor.onDidChangeModelContent(function() {
                var val = editor.getValue();
                document.getElementById('id_answer').value = val;
                document.getElementById('char_counter').textContent = val.length;
            });

            // Actualizar posición del cursor
            editor.onDidChangeCursorPosition(function(e) {
                document.getElementById('line-counter').textContent =
                    'Línea ' + e.position.lineNumber + ', Col ' + e.position.column;
            });

            // Cambiar lenguaje
            document.getElementById('lang-selector').addEventListener('change', function() {
                monaco.editor.setModelLanguage(editor.getModel(), this.value);
            });

            // Guardar referencia global
            window.monacoEditor = editor;
        });
    }

    // Cargar Monaco loader
    var script = document.createElement('script');
    script.src = 'https://cdn.jsdelivr.net/npm/monaco-editor@0.45.0/min/vs/loader.js';
    script.onload = initMonaco;
    document.head.appendChild(script);

    // Validar antes de enviar
    document.getElementById('submission-form').addEventListener('submit', function(e) {
        var answer = document.getElementById('id_answer').value.trim();
        if (!answer) {
            e.preventDefault();
            alert('Por favor escribe tu respuesta antes de enviar.');
            return;
        }
        document.getElementById('submit-btn').disabled = true;
        document.getElementById('submit-btn').value = 'Enviando...';
        document.getElementById('eval-spinner').style.display = 'inline';
    });
})();
</script>
";
        echo $OUTPUT->box_end();
    }

    // Mostrar envíos previos
    if ($submissions) {
        echo $OUTPUT->box_start('generalbox submissions');
        echo '<h3>' . get_string('yoursubmissions', 'aiassignment') . '</h3>';
        
        // Gráfica de evolución de calificaciones (Mejora 6)
        $chart_attempts = [];
        $chart_scores   = [];
        $attempt_num    = 1;
        foreach (array_reverse(array_values($submissions)) as $sub) {
            if ($sub->score !== null) {
                $chart_attempts[] = 'Intento ' . $attempt_num;
                $chart_scores[]   = round($sub->score, 2);
            }
            $attempt_num++;
        }
        if (count($chart_scores) > 1) {
            $labels_json = json_encode($chart_attempts);
            $scores_json = json_encode($chart_scores);
            echo '<canvas id="attemptsChart" height="120" style="margin-bottom:16px;"></canvas>';
            echo "
<script>
(function waitAttemptsChart() {
    if (typeof Chart === 'undefined') {
        var s = document.createElement('script');
        s.src = 'https://cdn.jsdelivr.net/npm/chart.js@4/dist/chart.umd.min.js';
        s.onload = buildAttemptsChart;
        document.head.appendChild(s);
    } else { buildAttemptsChart(); }

    function buildAttemptsChart() {
        new Chart(document.getElementById('attemptsChart'), {
            type: 'line',
            data: {
                labels: {$labels_json},
                datasets: [{
                    label: 'Calificación (%)',
                    data: {$scores_json},
                    borderColor: '#2563eb',
                    backgroundColor: 'rgba(37,99,235,0.1)',
                    borderWidth: 2,
                    pointBackgroundColor: '#2563eb',
                    pointRadius: 5,
                    fill: true,
                    tension: 0.3
                }]
            },
            options: {
                responsive: true,
                plugins: { legend: { display: false } },
                scales: {
                    y: { beginAtZero: true, max: 100,
                         title: { display: true, text: 'Calificación (%)' } }
                }
            }
        });
    }
})();
</script>
";
        }

        foreach ($submissions as $submission) {
            echo '<div class="submission">';
            echo '<p><strong>' . get_string('submitted', 'aiassignment') . ':</strong> ' . 
                 userdate($submission->timecreated) . '</p>';
            
            if ($submission->status == 'evaluated' && $submission->score !== null) {
                echo '<p><strong>' . get_string('grade') . ':</strong> ' . 
                     round($submission->score, 2) . '%</p>';
                
                if ($submission->feedback) {
                    echo '<p><strong>' . get_string('feedback', 'aiassignment') . ':</strong></p>';
                    echo '<div class="feedback">' . s($submission->feedback) . '</div>';
                }
                
                echo '<a href="submission.php?id=' . $submission->id . '">' . 
                     get_string('viewdetails', 'aiassignment') . '</a>';
            } else {
                echo '<p><em>' . get_string('pendingevaluation', 'aiassignment') . '</em></p>';
            }
            echo '</div><hr>';
        }
        echo $OUTPUT->box_end();
    }
}

// Vista para profesores
if ($cangrade) {
    echo $OUTPUT->box_start('generalbox');
    echo '<h3>' . get_string('allsubmissions', 'aiassignment') . '</h3>';
    echo '<a href="submissions.php?id=' . $cm->id . '" class="btn btn-primary">' . 
         get_string('viewallsubmissions', 'aiassignment') . '</a>';
    echo $OUTPUT->box_end();
}

echo html_writer::tag('script', "
document.addEventListener('DOMContentLoaded', function() {
    var form = document.querySelector('form[action=\"submit.php\"]');
    if (form) {
        form.addEventListener('submit', function() {
            document.getElementById('submit-btn').disabled = true;
            document.getElementById('submit-btn').value = 'Enviando...';
            document.getElementById('eval-spinner').style.display = 'inline';
        });
    }
});
");

// ── Polling de notificaciones en tiempo real ──────────────────
echo \mod_aiassignment\realtime_notifier::render_polling_script($cm->id, $USER->id);

// ── Rastreo de comportamiento en el editor ────────────────────
echo \mod_aiassignment\behavior_tracker::get_tracking_script();

echo $OUTPUT->footer();
