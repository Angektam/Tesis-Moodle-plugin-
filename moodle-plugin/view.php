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

// ── Mostrar lenguaje requerido al estudiante ──────────────────────────────
$required_lang = trim($aiassignment->required_language ?? '');
if (in_array($aiassignment->type, ['programming', 'debugging', 'sql'])) {
    $lang_labels = [
        'python'     => 'Python',
        'javascript' => 'JavaScript',
        'java'       => 'Java',
        'cpp'        => 'C / C++',
        'php'        => 'PHP',
        'sql'        => 'SQL',
        'typescript' => 'TypeScript',
        'ruby'       => 'Ruby',
        'go'         => 'Go',
        'rust'       => 'Rust',
        'pseudocode' => 'Pseudocódigo',
    ];
    if (!empty($required_lang) && isset($lang_labels[$required_lang])) {
        $lang_display = $lang_labels[$required_lang];
        echo '<div class="alert alert-info d-flex align-items-center" role="note" ' .
             'style="border-left:4px solid #0c63e4;padding:10px 14px;margin:8px 0 12px;font-size:14px;">' .
             get_string('language_required_hint', 'aiassignment', s($lang_display)) .
             '</div>';
    } else {
        echo '<div style="color:#6c757d;font-size:13px;margin-bottom:10px;">' .
             get_string('language_any_hint', 'aiassignment') . '</div>';
    }
}

// ── Mostrar deadline y tiempo restante ───────────────────────────────────
$now = time();
if (!empty($aiassignment->timeopen) && $now < $aiassignment->timeopen) {
    // Aún no abre
    echo '<div class="alert alert-warning" role="alert" style="font-size:13px;margin-bottom:10px;">' .
         get_string('assignmentnotopen', 'aiassignment', userdate($aiassignment->timeopen)) .
         '</div>';
} elseif (!empty($aiassignment->duedate)) {
    if ($now > $aiassignment->duedate) {
        // Cerrada
        echo '<div class="alert alert-danger" role="alert" style="font-size:13px;margin-bottom:10px;">' .
             get_string('assignmentclosed', 'aiassignment', userdate($aiassignment->duedate)) .
             '</div>';
    } else {
        // Abierta — mostrar cuenta regresiva
        $remaining = $aiassignment->duedate - $now;
        if ($remaining < 3600) {
            $time_str = round($remaining / 60) . ' minutos';
            $urgency  = 'alert-danger';
        } elseif ($remaining < 86400) {
            $time_str = round($remaining / 3600) . ' horas';
            $urgency  = 'alert-warning';
        } else {
            $time_str = round($remaining / 86400) . ' días';
            $urgency  = 'alert-info';
        }
        echo '<div class="alert ' . $urgency . '" id="deadline-banner" role="timer" ' .
             'style="font-size:13px;margin-bottom:10px;" ' .
             'data-deadline="' . $aiassignment->duedate . '">' .
             '⏱️ Fecha límite: <strong>' . userdate($aiassignment->duedate) . '</strong> ' .
             '(<span id="time-remaining">' . s($time_str) . '</span> restantes)' .
             '</div>';
        // Script de cuenta regresiva en tiempo real
        echo '<script>
(function(){
    var deadline = ' . (int)$aiassignment->duedate . ';
    function updateTimer() {
        var rem = deadline - Math.floor(Date.now()/1000);
        if (rem <= 0) {
            document.getElementById("deadline-banner").className = "alert alert-danger";
            document.getElementById("time-remaining").textContent = "VENCIDA";
            var btn = document.getElementById("submit-btn");
            if (btn) { btn.disabled = true; btn.title = "Fecha límite vencida"; }
            return;
        }
        var d = Math.floor(rem/86400), h = Math.floor((rem%86400)/3600),
            m = Math.floor((rem%3600)/60), s = rem%60;
        var parts = [];
        if (d > 0) parts.push(d + "d");
        if (h > 0) parts.push(h + "h");
        if (m > 0) parts.push(m + "m");
        parts.push(s + "s");
        var el = document.getElementById("time-remaining");
        if (el) el.textContent = parts.join(" ");
        if (rem < 3600) {
            document.getElementById("deadline-banner").className = "alert alert-danger";
        } else if (rem < 86400) {
            document.getElementById("deadline-banner").className = "alert alert-warning";
        }
        setTimeout(updateTimer, 1000);
    }
    updateTimer();
})();
</script>';
    }
}

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

// ── Banner de disponibilidad y deadline ───────────────────────────────────
$now = time();
if (!empty($aiassignment->timeopen) && $now < $aiassignment->timeopen) {
    echo html_writer::tag('div',
        '🔒 Esta tarea estará disponible el <strong>' . userdate($aiassignment->timeopen) . '</strong>',
        ['class' => 'alert alert-warning', 'style' => 'margin-top:12px;']);
}
if (!empty($aiassignment->duedate)) {
    $time_left = $aiassignment->duedate - $now;
    if ($time_left > 0) {
        $hours_left = floor($time_left / 3600);
        $mins_left  = floor(($time_left % 3600) / 60);
        $urgency_color = $time_left < 3600 ? '#dc3545' : ($time_left < 86400 ? '#856404' : '#155724');
        $urgency_bg    = $time_left < 3600 ? '#fff5f5' : ($time_left < 86400 ? '#fff3cd' : '#d1e7dd');
        if ($time_left < 3600) {
            $time_str = "⚠️ ¡Solo quedan {$mins_left} minutos!";
        } elseif ($time_left < 86400) {
            $time_str = "⏰ Quedan {$hours_left}h {$mins_left}min";
        } else {
            $days_left = floor($time_left / 86400);
            $time_str  = "📅 Quedan {$days_left} día(s)";
        }
        echo html_writer::tag('div',
            $time_str . ' — Fecha límite: <strong>' . userdate($aiassignment->duedate) . '</strong>',
            ['style' => "background:$urgency_bg;color:$urgency_color;border:1px solid currentColor;" .
                        "border-radius:8px;padding:10px 14px;margin-top:8px;font-size:13px;font-weight:600;"]);
    } else {
        echo html_writer::tag('div',
            '⛔ La fecha límite de entrega ya pasó (' . userdate($aiassignment->duedate) . '). No se aceptan más envíos.',
            ['class' => 'alert alert-danger', 'style' => 'margin-top:8px;']);
    }
}

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
            // ── Contador visual de intentos (Mejora 2) ───────────────
            $remaining = $aiassignment->maxattempts - $attemptcount;
            $pct_used  = round($attemptcount / $aiassignment->maxattempts * 100);
            $bar_color = $remaining <= 1 ? '#dc3545' : ($remaining <= 2 ? '#ffc107' : '#28a745');

            echo html_writer::start_div('', ['style' =>
                'background:#f8f9fa;border:1px solid #dee2e6;border-radius:10px;padding:12px 16px;' .
                'margin-bottom:14px;display:flex;align-items:center;gap:14px;']);

            // Círculo de intentos
            echo html_writer::start_div('', ['style' => 'text-align:center;flex-shrink:0;']);
            echo html_writer::tag('div',
                html_writer::tag('span', $attemptcount, ['style' => "font-size:1.4rem;font-weight:700;color:$bar_color;"]) .
                html_writer::tag('span', '/' . $aiassignment->maxattempts, ['style' => 'font-size:0.9rem;color:#888;']),
                ['style' => 'line-height:1;']);
            echo html_writer::tag('div', 'intentos usados', ['style' => 'font-size:10px;color:#aaa;margin-top:2px;']);
            echo html_writer::end_div();

            // Barra + texto
            echo html_writer::start_div('', ['style' => 'flex:1;']);
            echo html_writer::tag('div',
                "Intento <strong>$remaining</strong> restante" . ($remaining !== 1 ? 's' : ''),
                ['style' => "font-size:13px;font-weight:600;color:$bar_color;margin-bottom:5px;"]);
            echo html_writer::start_div('progress', ['style' => 'height:8px;margin:0;']);
            echo html_writer::div('', 'progress-bar', [
                'style'         => "width:{$pct_used}%;background:$bar_color;",
                'aria-valuenow' => $pct_used, 'aria-valuemin' => '0', 'aria-valuemax' => '100',
                'role'          => 'progressbar',
                'aria-label'    => "$attemptcount de {$aiassignment->maxattempts} intentos usados",
            ]);
            echo html_writer::end_div();
            echo html_writer::end_div();

            echo html_writer::end_div();
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

        // ── Selector de lenguaje (se bloquea si hay requerido) ────────
        $lang_options = [
            'python'     => '🐍 Python',
            'javascript' => '🟨 JavaScript',
            'java'       => '☕ Java',
            'cpp'        => '⚙️ C/C++',
            'php'        => '🐘 PHP',
            'sql'        => '🗄️ SQL',
            'typescript' => '🔷 TypeScript',
            'ruby'       => '💎 Ruby',
            'go'         => '🐹 Go',
            'rust'       => '🦀 Rust',
            'plaintext'  => '📄 Texto',
        ];
        // Si el profe fijó un lenguaje, ese es el default y se bloquea el selector
        $req_lang    = trim($aiassignment->required_language ?? '');
        $default_lang = !empty($req_lang) ? $req_lang
                      : ($aiassignment->type === 'programming' ? 'python' : 'plaintext');
        $lang_locked = !empty($req_lang);

        echo '<div style="margin-bottom:8px;display:flex;align-items:center;gap:12px;flex-wrap:wrap;">';
        echo '<label for="lang-selector" style="font-size:13px;font-weight:600;color:#555;">Lenguaje:</label>';
        $sel_attrs = 'id="lang-selector" style="padding:5px 10px;border-radius:6px;border:1px solid #dee2e6;font-size:13px;"';
        if ($lang_locked) {
            $sel_attrs .= ' disabled title="El profesor ha fijado el lenguaje para esta tarea"';
        }
        echo "<select $sel_attrs>";
        foreach ($lang_options as $val => $label) {
            $sel = $val === $default_lang ? ' selected' : '';
            echo "<option value=\"$val\"$sel>$label</option>";
        }
        echo '</select>';
        if ($lang_locked) {
            echo '<span style="font-size:12px;color:#0c63e4;font-weight:600;">🔒 Lenguaje fijado por el profesor</span>';
        } else {
            echo '<span style="font-size:12px;color:#888;">💡 El editor tiene resaltado de sintaxis</span>';
        }
        echo '</div>';

        // ── Editor Monaco con fallback a textarea ─────────────────────
        echo '<div id="monaco-editor-container" style="width:100%;height:380px;border:1px solid #dee2e6;border-radius:8px;overflow:hidden;margin-bottom:8px;"></div>';
        // Textarea de fallback visible solo si Monaco no carga
        echo '<textarea id="id_answer" name="answer" rows="16"
            style="width:100%;font-family:monospace;font-size:13px;padding:10px;border:1px solid #dee2e6;
                   border-radius:8px;display:none;box-sizing:border-box;resize:vertical;"
            placeholder="Escribe tu código aquí..." required></textarea>';
        echo '<div id="monaco-fallback-msg" style="display:none;color:#856404;font-size:12px;margin-bottom:6px;">
            ⚠️ El editor avanzado no está disponible. Puedes escribir directamente en el área de texto.
        </div>';

        echo '<div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:12px;">';
        echo '<span style="font-size:12px;color:#888;"><span id="char_counter">0</span> / 10000 ' . get_string('characters', 'aiassignment') . '</span>';
        echo '<span style="font-size:12px;color:#888;" id="line-counter">Línea 1, Col 1</span>';
        echo '</div>';

        echo '<input type="submit" id="submit-btn" value="' . get_string('submit', 'aiassignment') . '" class="btn btn-primary">';
        echo '
<div id="eval-spinner" style="display:none;margin-top:16px;background:#e8f4fd;border:1px solid #bee3f8;
     border-radius:10px;padding:16px 20px;text-align:center;">
    <div style="display:inline-block;width:32px;height:32px;border:4px solid #bee3f8;
                border-top-color:#1a73e8;border-radius:50%;animation:spin 0.8s linear infinite;
                vertical-align:middle;margin-right:10px;"></div>
    <span style="font-size:14px;font-weight:600;color:#1a73e8;vertical-align:middle;">
        ⏳ Tu código está siendo evaluado por la IA...
    </span>
    <p style="margin:8px 0 0;font-size:12px;color:#555;">
        Esto toma entre 2 y 5 segundos. Recibirás una notificación cuando esté listo.<br>
        <strong>No cierres ni recargues esta página.</strong>
    </p>
</div>
<style>@keyframes spin { to { transform:rotate(360deg); } }</style>
';
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

        $req_lang_js   = json_encode($req_lang);
        $lang_locked_js = $lang_locked ? 'true' : 'false';
        echo "
<script>
(function() {
    var REQUIRED_LANG = $req_lang_js;
    var LANG_LOCKED   = $lang_locked_js;
    var monacoLoaded  = false;

    $exam_js

    // ── Detección simple de lenguaje en el cliente ────────────────────
    function detectLangClient(code) {
        if (!code || code.length < 10) return '';
        if (/\\bdef\\s+\\w+\\s*\\(|\\belif\\b|^import\\s+\\w|^from\\s+\\w+\\s+import/m.test(code)) return 'python';
        if (/\\bpublic\\s+class\\b|\\bSystem\\.out\\.print|\\bimport\\s+java\\./m.test(code)) return 'java';
        if (/\\bconsole\\.log\\b|\\bconst\\b|=>\\s*[{(]|\\brequire\\s*\\(/m.test(code)) return 'javascript';
        if (/<\\?php|\\$[a-zA-Z_]\\w*\\s*=/m.test(code)) return 'php';
        if (/\\b#include\\b|\\bprintf\\s*\\(|\\bint\\s+main\\s*\\(/m.test(code)) return 'cpp';
        if (/\\bSELECT\\b.*\\bFROM\\b/im.test(code)) return 'sql';
        if (/\\bfn\\s+\\w+\\s*\\(|\\blet\\s+mut\\b|println!/m.test(code)) return 'rust';
        if (/\\bfunc\\s+\\w+\\s*\\(|\\bpackage\\s+main\\b/m.test(code)) return 'go';
        return '';
    }

    var LANG_NAMES = {
        python:'Python', javascript:'JavaScript', java:'Java',
        cpp:'C/C++', php:'PHP', sql:'SQL', typescript:'TypeScript',
        ruby:'Ruby', go:'Go', rust:'Rust'
    };

    function showLangWarning(detected) {
        var el = document.getElementById('lang-warning-inline');
        if (!el) {
            el = document.createElement('div');
            el.id = 'lang-warning-inline';
            el.style.cssText = 'background:#fff3cd;border:1px solid #ffc107;border-radius:6px;' +
                'padding:8px 12px;font-size:13px;color:#856404;margin-bottom:8px;display:none;';
            var btn = document.getElementById('submit-btn');
            btn.parentNode.insertBefore(el, btn);
        }
        if (detected && REQUIRED_LANG && detected !== REQUIRED_LANG) {
            el.innerHTML = '⚠️ Parece que estás escribiendo en <strong>' + (LANG_NAMES[detected]||detected) +
                '</strong>, pero esta tarea requiere <strong>' + (LANG_NAMES[REQUIRED_LANG]||REQUIRED_LANG) + '</strong>.';
            el.style.display = 'block';
        } else {
            el.style.display = 'none';
        }
    }

    function syncAnswer(val) {
        document.getElementById('id_answer').value = val;
        document.getElementById('char_counter').textContent = val.length;
        if (REQUIRED_LANG) showLangWarning(detectLangClient(val));
    }

    // ── Activar fallback textarea si Monaco no carga en 6s ───────────
    var fallbackTimer = setTimeout(function() {
        if (!monacoLoaded) {
            document.getElementById('monaco-editor-container').style.display = 'none';
            document.getElementById('id_answer').style.display = 'block';
            document.getElementById('monaco-fallback-msg').style.display = 'block';
            document.getElementById('id_answer').addEventListener('input', function() {
                syncAnswer(this.value);
            });
        }
    }, 6000);

    function initMonaco() {
        require.config({ paths: { vs: 'https://cdn.jsdelivr.net/npm/monaco-editor@0.45.0/min/vs' }});
        require(['vs/editor/editor.main'], function() {
            monacoLoaded = true;
            clearTimeout(fallbackTimer);

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

            editor.onDidChangeModelContent(function() {
                syncAnswer(editor.getValue());
            });

            editor.onDidChangeCursorPosition(function(e) {
                document.getElementById('line-counter').textContent =
                    'Línea ' + e.position.lineNumber + ', Col ' + e.position.column;
            });

            var selector = document.getElementById('lang-selector');
            if (selector && !LANG_LOCKED) {
                selector.addEventListener('change', function() {
                    monaco.editor.setModelLanguage(editor.getModel(), this.value);
                });
            }
            window.monacoEditor = editor;
        });
    }

    var script = document.createElement('script');
    script.src  = 'https://cdn.jsdelivr.net/npm/monaco-editor@0.45.0/min/vs/loader.js';
    script.onerror = function() {
        clearTimeout(fallbackTimer);
        document.getElementById('monaco-editor-container').style.display = 'none';
        document.getElementById('id_answer').style.display = 'block';
        document.getElementById('monaco-fallback-msg').style.display = 'block';
    };
    script.onload = initMonaco;
    document.head.appendChild(script);

    // ── Validar antes de enviar ───────────────────────────────────────
    document.getElementById('submission-form').addEventListener('submit', function(e) {
        var answer = document.getElementById('id_answer').value.trim();
        if (!answer) {
            e.preventDefault();
            alert('Por favor escribe tu respuesta antes de enviar.');
            return;
        }
        document.getElementById('submit-btn').disabled = true;
        document.getElementById('submit-btn').value = 'Enviando...';
        document.getElementById('eval-spinner').style.display = 'block';
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

        // Enlace a mis estadísticas personales
        $mystats_url = new moodle_url('/mod/aiassignment/my_stats.php', ['id' => $cm->id]);
        echo html_writer::link($mystats_url, '📊 Ver mis estadísticas completas →',
            ['style' => 'font-size:13px;color:#1a73e8;font-weight:600;display:block;margin-bottom:12px;']);
        
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
                // ── Polling para evaluación asíncrona: recargar automáticamente ─
                echo html_writer::tag('div',
                    '<span id="async-poll-msg">⏳ Esperando resultado de la evaluación...</span>',
                    ['style' => 'font-size:12px;color:#6c757d;margin-top:4px;']);
                echo "<script>
(function() {
    var sid = {$submission->id};
    var interval = setInterval(function() {
        fetch('plagiarism_ajax.php?action=check_evaluated&sid=' + sid)
            .then(function(r){ return r.json(); })
            .then(function(data) {
                if (data.evaluated) {
                    clearInterval(interval);
                    document.getElementById('async-poll-msg').textContent =
                        '✅ ¡Tu tarea fue evaluada! Calificación: ' + data.score + '%. Recargando...';
                    setTimeout(function(){ location.reload(); }, 1500);
                }
            }).catch(function(){});
    }, 8000); // revisar cada 8 segundos
})();
</script>";
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

// ── Enlace a encuesta SUS ─────────────────────────────────────
$sus_url = new moodle_url('/mod/aiassignment/sus_survey.php', ['id' => $cm->id]);
$sus_done = $DB->record_exists('aiassignment_sus_surveys', ['userid' => $USER->id, 'cmid' => $cm->id]);
echo html_writer::start_div('', ['style' =>
    'margin-top:24px;padding:12px 16px;background:#f8f9fa;border:1px solid #dee2e6;' .
    'border-radius:8px;display:flex;align-items:center;justify-content:space-between;']);
echo html_writer::tag('span',
    $sus_done ? '✅ Ya completaste la encuesta de usabilidad.' : '📋 ¿Puedes ayudarnos? Completa la encuesta de usabilidad (5 min).',
    ['style' => 'font-size:13px;color:#555;']);
echo html_writer::link($sus_url,
    $sus_done ? 'Ver mis respuestas' : 'Completar encuesta →',
    ['class' => 'btn btn-sm ' . ($sus_done ? 'btn-outline-secondary' : 'btn-outline-primary')]);
echo html_writer::end_div();

echo $OUTPUT->footer();
