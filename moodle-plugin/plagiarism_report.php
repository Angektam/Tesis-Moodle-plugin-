<?php
// This file is part of Moodle - http://moodle.org/

require_once('../../config.php');
require_once('lib.php');
require_once(__DIR__ . '/classes/plagiarism_detector.php');

$id     = required_param('id',     PARAM_INT);
$export = optional_param('export', 0, PARAM_INT);
$nosem  = optional_param('nosem',  1, PARAM_INT); // modo rápido por defecto
$force  = optional_param('force',  0, PARAM_INT);

$cm           = get_coursemodule_from_id('aiassignment', $id, 0, false, MUST_EXIST);
$course       = $DB->get_record('course', ['id' => $cm->course], '*', MUST_EXIST);
$aiassignment = $DB->get_record('aiassignment', ['id' => $cm->instance], '*', MUST_EXIST);

require_login($course, true, $cm);
$context = context_module::instance($cm->id);
require_capability('mod/aiassignment:grade', $context);

$PAGE->set_url('/mod/aiassignment/plagiarism_report.php', ['id' => $cm->id]);
$PAGE->set_title(format_string($aiassignment->name) . ' — Reporte de Plagio');
$PAGE->set_heading(format_string($course->fullname));
$PAGE->set_context($context);

// ── Exportar CSV ──────────────────────────────────────────────────────────
if ($export) {
    require_sesskey();
    $report = \mod_aiassignment\plagiarism_detector::generate_plagiarism_report(
        $aiassignment->id, true, false
    );
    if (!isset($report['message'])) {
        header('Content-Type: text/csv; charset=utf-8');
        header('Content-Disposition: attachment; filename="plagio_' .
            clean_filename($aiassignment->name) . '_' . date('Ymd') . '.csv"');
        $out = fopen('php://output', 'w');
        fprintf($out, chr(0xEF).chr(0xBB).chr(0xBF));
        fputcsv($out, ['Alumno 1','Alumno 2','Similitud (%)','Veredicto',
            'Léxica (%)','Estructural (%)','Semántica (%)','Técnicas']);
        foreach ($report['detailed_comparisons'] as $cmp) {
            $u1 = $DB->get_record('user', ['id' => $cmp['submission1_user']]);
            $u2 = $DB->get_record('user', ['id' => $cmp['submission2_user']]);
            fputcsv($out, [
                fullname($u1), fullname($u2),
                round($cmp['similarity_score'], 1), $cmp['verdict'],
                round($cmp['layers']['lexical']['score'] ?? 0, 1),
                round($cmp['layers']['structural']['score'] ?? 0, 1),
                round($cmp['layers']['semantic']['score'] ?? 0, 1),
                implode(' | ', $cmp['techniques'] ?? []),
            ]);
        }
        fclose($out);
        exit;
    }
}

$PAGE->requires->css('/mod/aiassignment/styles/dashboard.css');
echo $OUTPUT->header();

$back_url  = new moodle_url('/mod/aiassignment/submissions.php', ['id' => $cm->id]);
$ajax_url  = new moodle_url('/mod/aiassignment/plagiarism_ajax.php',
    ['id' => $cm->id, 'nosem' => $nosem, 'force' => $force]);
$ajax_full = new moodle_url('/mod/aiassignment/plagiarism_ajax.php',
    ['id' => $cm->id, 'nosem' => 0, 'force' => 1]);
$csv_url   = new moodle_url('/mod/aiassignment/plagiarism_report.php',
    ['id' => $cm->id, 'export' => 1, 'sesskey' => sesskey()]);

// Contar alumnos para estimación
$nsubs = $DB->count_records_sql(
    "SELECT COUNT(DISTINCT userid) FROM {aiassignment_submissions} WHERE assignment=:a",
    ['a' => $aiassignment->id]
);
$npairs   = $nsubs > 1 ? ($nsubs * ($nsubs - 1) / 2) : 0;
$est_fast = max(5, ceil($npairs * 0.05));
$est_full = max(10, ceil($npairs * 2));

echo html_writer::tag('h2', '🔍 Reporte de Detección de Plagio en Código Fuente');
echo html_writer::tag('p',
    'Análisis en 3 capas: léxica + estructural + semántica (IA). ' .
    'Detecta renombrado de variables, cambio de bucles, reordenación y técnicas de ofuscación.',
    ['class' => 'alert alert-info']);

// ── Botones de modo ───────────────────────────────────────────────────────
echo html_writer::start_div('', ['style' => 'display:flex;gap:12px;margin-bottom:20px;flex-wrap:wrap;']);
echo html_writer::tag('button', '⚡ Análisis Rápido (~' . $est_fast . 's)',
    ['id' => 'btn-fast', 'class' => 'btn btn-primary',
     'onclick' => 'startAnalysis(1)',
     'title' => 'Sin IA — léxica + estructural. Detecta copias directas.']);
echo html_writer::tag('button', '🧠 Análisis Completo con IA (~' . $est_full . 's)',
    ['id' => 'btn-full', 'class' => 'btn btn-danger',
     'onclick' => 'startAnalysis(0)',
     'title' => 'Con OpenAI — detecta también reescrituras lógicas.']);
echo html_writer::link($back_url, '← Volver a envíos', ['class' => 'btn btn-secondary']);
echo html_writer::end_div();

// ── Área de progreso (oculta inicialmente) ────────────────────────────────
echo '
<div id="progress-area" style="display:none; text-align:center; padding:40px; background:#fff;
     border-radius:12px; border:1px solid #dee2e6; margin-bottom:20px;">
    <div style="display:inline-block; width:48px; height:48px; border:5px solid #dee2e6;
                border-top-color:#1a73e8; border-radius:50%;
                animation:spin 0.8s linear infinite;"></div>
    <p id="progress-msg" style="margin-top:16px; color:#555; font-size:15px; font-weight:600;">
        Iniciando análisis...</p>
    <p id="progress-hint" style="color:#888; font-size:13px;"></p>
    <div style="background:#f3f4f6; border-radius:8px; height:8px; margin:16px auto; max-width:400px;">
        <div id="progress-bar" style="background:#1a73e8; height:8px; border-radius:8px;
             width:0%; transition:width 0.5s;"></div>
    </div>
</div>
<style>@keyframes spin { to { transform:rotate(360deg); } }</style>
';

// ── Área de resultados (se llena con JS) ──────────────────────────────────
echo '<div id="results-area"></div>';

// ── JS: AJAX polling ──────────────────────────────────────────────────────
$ajax_url_js  = $ajax_url->out(false);
$ajax_full_js = $ajax_full->out(false);
$csv_url_js   = $csv_url->out(false);

echo "
<script>
var _ajaxUrlFast = '{$ajax_url_js}';
var _ajaxUrlFull = '{$ajax_full_js}';
var _csvUrl      = '{$csv_url_js}';
var _analysisRunning = false;

function startAnalysis(nosem) {
    if (_analysisRunning) return;
    _analysisRunning = true;

    document.getElementById('btn-fast').disabled = true;
    document.getElementById('btn-full').disabled = true;
    document.getElementById('progress-area').style.display = 'block';
    document.getElementById('results-area').innerHTML = '';

    var url = nosem ? _ajaxUrlFast : _ajaxUrlFull;
    var startTime = Date.now();

    document.getElementById('progress-msg').textContent = nosem
        ? '⚡ Ejecutando análisis rápido (sin IA)...'
        : '🧠 Ejecutando análisis completo con IA...';

    // Simular progreso visual mientras espera
    var pct = 0;
    var progressInterval = setInterval(function() {
        pct = Math.min(pct + (nosem ? 3 : 0.5), 90);
        document.getElementById('progress-bar').style.width = pct + '%';
        var elapsed = Math.round((Date.now() - startTime) / 1000);
        document.getElementById('progress-hint').textContent = 'Tiempo transcurrido: ' + elapsed + 's';
    }, 500);

    // Mejoras 7 & 8: timeout con AbortController + botones de reintento
    var controller = new AbortController();
    var timeoutId = setTimeout(function() {
        controller.abort();
    }, 360000); // 6 minutos máximo

    fetch(url, { signal: controller.signal })
        .then(function(r) {
            clearTimeout(timeoutId);
            return r.json();
        })
        .then(function(data) {
            clearInterval(progressInterval);
            document.getElementById('progress-bar').style.width = '100%';
            document.getElementById('progress-area').style.display = 'none';
            document.getElementById('btn-fast').disabled = false;
            document.getElementById('btn-full').disabled = false;
            _analysisRunning = false;

            if (data.status === 'error') {
                document.getElementById('results-area').innerHTML =
                    '<div class=\"alert alert-danger\">❌ Error: ' + data.message + '</div>';
                return;
            }
            renderResults(data);
        })
        .catch(function(err) {
            clearTimeout(timeoutId);
            clearInterval(progressInterval);
            document.getElementById('progress-area').style.display = 'none';
            document.getElementById('btn-fast').disabled = false;
            document.getElementById('btn-full').disabled = false;
            _analysisRunning = false;
            var msg = err.name === 'AbortError'
                ? '⏱️ El análisis tardó demasiado (>6 min). Intenta con el Modo Rápido o reduce el número de envíos.'
                : '❌ Error de conexión: ' + err.message;
            var retryHtml = '<button class=\"btn btn-primary btn-sm\" style=\"margin-top:8px;margin-right:8px;\" onclick=\"startAnalysis(' + nosem + ')\">🔄 Reintentar</button>';
            if (!nosem) {
                retryHtml += '<button class=\"btn btn-warning btn-sm\" style=\"margin-top:8px;\" onclick=\"startAnalysis(1)\">⚡ Intentar Modo Rápido</button>';
            }
            document.getElementById('results-area').innerHTML =
                '<div class=\"alert alert-danger\">' + msg + '<br>' + retryHtml + '</div>';
        });
}

function renderResults(data) {
    var html = '';

    // Indicador de modo (Mejora 2)
    var modeLabel = data.mode === 'fast'
        ? '⚡ Modo Rápido (sin IA)'
        : '🧠 Modo Completo (con IA)';
    html += '<div style=\"background:#f8f9fa;border:1px solid #dee2e6;border-radius:8px;padding:12px 16px;margin-bottom:16px;font-size:13px;\">' +
        '<strong>' + modeLabel + '</strong> — ' + data.total_comparisons + ' comparaciones realizadas en ' +
        (data.elapsed_seconds || '?') + 's</div>';

    // Indicador de caché
    if (data.from_cache) {
        html += '<div class=\"alert alert-secondary\" style=\"font-size:13px;\">⚡ Resultado desde caché. ' +
            '<a href=\"#\" onclick=\"startAnalysis(0);return false;\">Forzar nuevo análisis</a></div>';
    }

    // Tarjetas resumen
    html += '<div style=\"display:grid;grid-template-columns:repeat(auto-fit,minmax(150px,1fr));gap:14px;margin-bottom:20px;\">';
    var cards = [
        {v: data.total_submissions, l: 'Total envíos', c: '#1a73e8'},
        {v: data.total_comparisons, l: 'Comparaciones', c: '#6f42c1'},
        {v: data.suspicious_pairs,  l: 'Pares sospechosos', c: '#dc3545'},
        {v: data.highest_similarity + '%', l: 'Similitud máxima', c: '#fd7e14'},
    ];
    cards.forEach(function(c) {
        html += '<div style=\"background:#f8f9fa;border:1px solid #dee2e6;border-radius:8px;padding:14px;text-align:center;\">' +
            '<div style=\"font-size:1.8rem;font-weight:700;color:' + c.c + '\">' + c.v + '</div>' +
            '<div style=\"font-size:0.8rem;color:#555;margin-top:4px;\">' + c.l + '</div></div>';
    });
    html += '</div>';

    // Botones exportar CSV + Imprimir (Mejora 3)
    html += '<div style=\"text-align:right;margin-bottom:16px;display:flex;gap:8px;justify-content:flex-end;\">' +
        '<a href=\"' + _csvUrl + '\" class=\"btn btn-sm btn-success\">⬇️ Exportar CSV</a>' +
        '<button class=\"btn btn-sm btn-secondary\" onclick=\"window.print()\" type=\"button\">🖨️ Imprimir / PDF</button>' +
        '</div>';

    // ── Matriz de similitud NxN ──
    if (data.user_ranking.length > 1 && data.comparisons.length > 0) {
        html += '<h3 style=\"margin:0 0 12px;\">🗺️ Matriz de Similitud</h3>';
        html += '<div style=\"overflow-x:auto;margin-bottom:24px;\">';
        html += '<table style=\"border-collapse:collapse;font-size:11px;\">';

        // Construir mapa de scores
        var scoreMap = {};
        data.comparisons.forEach(function(c) {
            if (!scoreMap[c.sub1_id]) scoreMap[c.sub1_id] = {};
            if (!scoreMap[c.sub2_id]) scoreMap[c.sub2_id] = {};
            scoreMap[c.sub1_id][c.sub2_id] = c.score;
            scoreMap[c.sub2_id][c.sub1_id] = c.score;
        });

        // Mapa userid → submission_id (primer envío del ranking)
        var userSubMap = {};
        data.comparisons.forEach(function(c) {
            // Aproximación: usar sub1_id para user1
        });

        // Cabecera
        html += '<thead><tr><th style=\"padding:5px 8px;background:#f8f9fa;border:1px solid #dee2e6;\"></th>';
        data.user_ranking.forEach(function(u) {
            var short = u.name.split(' ').map(function(w){return w[0];}).join('.');
            html += '<th style=\"padding:5px 8px;background:#f8f9fa;border:1px solid #dee2e6;white-space:nowrap;\" title=\"' + u.name + '\">' + short + '</th>';
        });
        html += '</tr></thead><tbody>';

        // Filas — usar comparaciones para llenar la matriz
        data.user_ranking.forEach(function(u1) {
            html += '<tr><td style=\"padding:5px 8px;background:#f8f9fa;border:1px solid #dee2e6;font-weight:600;white-space:nowrap;\">' + u1.name.split(' ')[0] + '</td>';
            data.user_ranking.forEach(function(u2) {
                if (u1.userid === u2.userid) {
                    html += '<td style=\"padding:5px 8px;border:1px solid #dee2e6;text-align:center;background:#e9ecef;\">—</td>';
                } else {
                    // Buscar score en comparaciones
                    var sc = 0;
                    data.comparisons.forEach(function(c) {
                        if ((c.user1 === u1.name && c.user2 === u2.name) ||
                            (c.user2 === u1.name && c.user1 === u2.name)) {
                            sc = c.score;
                        }
                    });
                    var bg = sc >= 75 ? '#f8d7da' : (sc >= 50 ? '#fff3cd' : '#d4edda');
                    var fw = sc >= 75 ? '700' : '400';
                    html += '<td style=\"padding:5px 8px;border:1px solid #dee2e6;text-align:center;background:' + bg + ';font-weight:' + fw + ';\">' + (sc > 0 ? sc + '%' : '—') + '</td>';
                }
            });
            html += '</tr>';
        });
        html += '</tbody></table></div>';
    }

    // Ranking
    html += '<h3 style=\"margin-bottom:12px;\">📊 Ranking de Alumnos</h3>';    html += '<table style=\"width:100%;border-collapse:collapse;font-size:13px;margin-bottom:24px;\">';
    html += '<thead><tr style=\"background:#f8f9fa;\">' +
        '<th style=\"padding:8px 12px;text-align:left;\">#</th>' +
        '<th style=\"padding:8px 12px;text-align:left;\">Alumno</th>' +
        '<th style=\"padding:8px 12px;text-align:center;\">Similitud</th>' +
        '<th style=\"padding:8px 12px;text-align:center;\">Nivel</th></tr></thead><tbody>';

    data.user_ranking.forEach(function(r, i) {
        var pct = r.max_similarity;
        var color = pct >= 75 ? '#dc3545' : (pct >= 50 ? '#856404' : '#155724');
        var badge = pct >= 75 ? '🔴 Alto' : (pct >= 50 ? '🟡 Medio' : '🟢 Bajo');
        var bar = '<div style=\"display:inline-block;width:80px;height:10px;background:#e9ecef;border-radius:5px;vertical-align:middle;margin-right:6px;\">' +
            '<div style=\"width:' + pct + '%;height:10px;background:' + color + ';border-radius:5px;\"></div></div>';
        html += '<tr style=\"border-bottom:1px solid #f0f0f0;\">' +
            '<td style=\"padding:8px 12px;\">' + (i+1) + '</td>' +
            '<td style=\"padding:8px 12px;font-weight:600;\">' + r.name + '</td>' +
            '<td style=\"padding:8px 12px;text-align:center;\">' + bar +
            '<strong style=\"color:' + color + ';\">' + pct + '%</strong></td>' +
            '<td style=\"padding:8px 12px;text-align:center;\">' + badge + '</td></tr>';
    });
    html += '</tbody></table>';

    // Comparaciones detalladas
    html += '<h3 style=\"margin:20px 0 12px;\">🔬 Comparaciones Detalladas</h3>';
    data.comparisons.forEach(function(cmp, idx) {
        var pct = cmp.score;
        var border = pct >= 75 ? '#dc3545' : (pct >= 50 ? '#ffc107' : '#28a745');
        var label  = pct >= 75 ? '🔴 Plagio probable' : (pct >= 50 ? '🟡 Sospechoso' : '🟢 Original');
        var detailId = 'cmp-' + idx;

        html += '<div style=\"border-left:4px solid ' + border + ';background:#fff;border:1px solid #dee2e6;' +
            'border-left:4px solid ' + border + ';border-radius:6px;padding:14px;margin-bottom:12px;\">';

        // Cabecera
        html += '<div style=\"display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:8px;\">';
        html += '<div><strong style=\"color:' + border + ';font-size:1rem;\">' + label + ': ' + pct + '%</strong>' +
            '<div style=\"color:#555;margin-top:3px;font-size:13px;\">' + cmp.user1 + ' ↔ ' + cmp.user2 + '</div></div>';
        html += '<button class=\"btn btn-sm btn-secondary\" onclick=\"toggleDetail(\\''+detailId+'\\',this)\" type=\"button\">Ver código</button>';
        html += '</div>';

        // Barra
        html += '<div style=\"height:8px;background:#e9ecef;border-radius:4px;margin:10px 0;\">' +
            '<div style=\"width:' + pct + '%;height:8px;background:' + border + ';border-radius:4px;\"></div></div>';

        // Capas
        html += '<div style=\"display:flex;gap:10px;flex-wrap:wrap;margin-bottom:6px;font-size:12px;\">';
        var layers = [
            {k:'lexical',l:'🔤 Léxica'},
            {k:'structural',l:'🏗️ Estructural'},
            {k:'semantic',l:'🧠 Semántica'}
        ];
        layers.forEach(function(ly) {
            var ls = cmp.layers[ly.k];
            var lc = ls >= 70 ? '#dc3545' : (ls >= 40 ? '#856404' : '#155724');
            html += '<span style=\"background:#f8f9fa;border:1px solid #dee2e6;border-radius:4px;padding:3px 8px;\">' +
                ly.l + ': <strong style=\"color:' + lc + ';\">' + ls + '%</strong></span>';
        });
        html += '</div>';

        // Técnicas
        if (cmp.techniques && cmp.techniques.length) {
            html += '<div style=\"font-size:12px;margin-bottom:6px;\">⚠️ ' + cmp.techniques.join(' | ') + '</div>';
        }

        // Análisis IA
        if (cmp.analysis) {
            html += '<p style=\"font-size:12px;color:#333;margin-bottom:6px;\">🧠 ' + cmp.analysis + '</p>';
        }

        // Botones confirmar/falso positivo
        html += '<div style=\"display:flex;gap:8px;margin-top:6px;\">' +
            '<a href=\"/mod/aiassignment/mark_plagiarism.php?sid=' + cmp.sub1_id + '&status=confirmed&sesskey=' + M.cfg.sesskey + '\" class=\"btn btn-sm btn-danger\">✅ Confirmar plagio</a>' +
            '<a href=\"/mod/aiassignment/mark_plagiarism.php?sid=' + cmp.sub1_id + '&status=false_positive&sesskey=' + M.cfg.sesskey + '\" class=\"btn btn-sm btn-secondary\">❌ Falso positivo</a>' +
            '</div>';

        // Bloque colapsable
        html += '<div id=\"' + detailId + '\" style=\"display:none;margin-top:10px;\">' +
            '<p style=\"color:#888;font-size:12px;\">Abre el envío individual para ver el código completo.</p>' +
            '<a href=\"/mod/aiassignment/submission.php?id=' + cmp.sub1_id + '\" class=\"btn btn-sm btn-primary\" target=\"_blank\">Ver envío de ' + cmp.user1 + '</a> ' +
            '<a href=\"/mod/aiassignment/submission.php?id=' + cmp.sub2_id + '\" class=\"btn btn-sm btn-primary\" target=\"_blank\">Ver envío de ' + cmp.user2 + '</a>' +
            '</div>';

        html += '</div>';
    });

    document.getElementById('results-area').innerHTML = html;
}

function toggleDetail(id, btn) {
    var el = document.getElementById(id);
    if (!el) return;
    var hidden = el.style.display === 'none';
    el.style.display = hidden ? 'block' : 'none';
    btn.textContent = hidden ? 'Ocultar' : 'Ver código';
}
</script>
";

echo html_writer::div(
    html_writer::link($back_url, '← Volver a envíos', ['class' => 'btn btn-secondary']),
    'mt-3'
);

echo $OUTPUT->footer();

$cm          = get_coursemodule_from_id('aiassignment', $id, 0, false, MUST_EXIST);
$course      = $DB->get_record('course', ['id' => $cm->course], '*', MUST_EXIST);
$aiassignment = $DB->get_record('aiassignment', ['id' => $cm->instance], '*', MUST_EXIST);

require_login($course, true, $cm);
$context = context_module::instance($cm->id);
require_capability('mod/aiassignment:grade', $context);

$PAGE->set_url('/mod/aiassignment/plagiarism_report.php', ['id' => $cm->id]);
$PAGE->set_title(format_string($aiassignment->name) . ' — Reporte de Plagio');
$PAGE->set_heading(format_string($course->fullname));
$PAGE->set_context($context);

// ── Exportar CSV (mejora #7) ──────────────────────────────────────────────
if ($export) {
    require_sesskey();
    $report = \mod_aiassignment\plagiarism_detector::generate_plagiarism_report($aiassignment->id);

    if (!isset($report['message'])) {
        header('Content-Type: text/csv; charset=utf-8');
        header('Content-Disposition: attachment; filename="plagio_' . clean_filename($aiassignment->name) . '_' . date('Ymd') . '.csv"');

        $out = fopen('php://output', 'w');
        fprintf($out, chr(0xEF) . chr(0xBB) . chr(0xBF)); // BOM UTF-8 para Excel
        fputcsv($out, ['Alumno 1', 'Alumno 2', 'Similitud (%)', 'Veredicto', 'Léxica (%)', 'Estructural (%)', 'Semántica (%)', 'Técnicas detectadas']);

        foreach ($report['detailed_comparisons'] as $cmp) {
            $u1 = $DB->get_record('user', ['id' => $cmp['submission1_user']]);
            $u2 = $DB->get_record('user', ['id' => $cmp['submission2_user']]);
            fputcsv($out, [
                fullname($u1),
                fullname($u2),
                round($cmp['similarity_score'], 1),
                $cmp['verdict'],
                round($cmp['layers']['lexical']['score'] ?? 0, 1),
                round($cmp['layers']['structural']['score'] ?? 0, 1),
                round($cmp['layers']['semantic']['score'] ?? 0, 1),
                implode(' | ', $cmp['techniques'] ?? []),
            ]);
        }
        fclose($out);
        exit;
    }
}

// ── Ejecutar análisis ─────────────────────────────────────────────────────
if ($analyze) {

    // Spinner visible mientras PHP procesa (se oculta con JS al terminar)
    echo '
<div id="loading-spinner" style="text-align:center; padding:40px;">
    <div style="display:inline-block; width:48px; height:48px; border:5px solid #dee2e6;
                border-top-color:#dc3545; border-radius:50%; animation:spin 0.8s linear infinite;"></div>
    <p style="margin-top:16px; color:#555; font-size:15px;">Analizando envíos... esto puede tardar unos segundos.</p>
    <p style="color:#888; font-size:13px;" id="spin-hint"></p>
</div>
<style>@keyframes spin { to { transform: rotate(360deg); } }</style>
<script>
    // Mostrar hint después de 5s
    setTimeout(function() {
        document.getElementById("spin-hint").textContent =
            "Con muchos alumnos el análisis puede tardar 1-2 minutos. Por favor espera.";
    }, 5000);
</script>
';
    // Aumentar tiempo de ejecución para análisis con muchos alumnos
    @set_time_limit(300); // 5 minutos máximo
    @ini_set('max_execution_time', 300);

    // Flush para que el spinner aparezca antes de que PHP empiece a calcular
    if (ob_get_level()) ob_flush();
    flush();

    try {
        // Pasar flag nosem al detector para omitir OpenAI si se pidió modo rápido
        $report = \mod_aiassignment\plagiarism_detector::generate_plagiarism_report(
            $aiassignment->id,
            (bool)$nosem,
            (bool)$force
        );

        if (isset($report['message'])) {
            echo '<script>document.getElementById("loading-spinner").style.display="none";</script>';
            echo $OUTPUT->notification($report['message'], 'info');
        } else {
            echo '<script>document.getElementById("loading-spinner").style.display="none";</script>';

            // ── Guardar similarity_score en aiassignment_evaluations ──────
            // Para cada usuario, actualizar su evaluación más reciente con
            // el score máximo de plagio detectado.
            foreach ($report['user_ranking'] as $row) {
                $uid   = $row['userid'];
                $score = $row['max_similarity'];

                // Obtener la submission más reciente del usuario en este assignment
                $sub = $DB->get_record_sql(
                    "SELECT id FROM {aiassignment_submissions}
                     WHERE assignment = :a AND userid = :u
                     ORDER BY id DESC LIMIT 1",
                    ['a' => $aiassignment->id, 'u' => $uid]
                );
                if (!$sub) continue;

                // Buscar evaluación existente para esa submission
                $eval = $DB->get_record('aiassignment_evaluations', ['submission' => $sub->id]);
                if ($eval) {
                    $DB->set_field('aiassignment_evaluations', 'similarity_score', $score, ['id' => $eval->id]);
                } else {
                    // Crear registro si no existe
                    $DB->insert_record('aiassignment_evaluations', (object)[
                        'submission'       => $sub->id,
                        'similarity_score' => $score,
                        'ai_feedback'      => '',
                        'ai_analysis'      => '',
                        'timecreated'      => time(),
                    ]);
                }
            }
            // ─────────────────────────────────────────────────────────────

            // ── Tarjetas de resumen ───────────────────────────────────────
            echo html_writer::start_tag('div', ['style' => 'display:grid; grid-template-columns:repeat(auto-fit,minmax(160px,1fr)); gap:16px; margin-bottom:24px;']);

            $cards = [
                ['label' => 'Total envíos',       'value' => $report['total_submissions'],     'color' => '#0f6cbf'],
                ['label' => 'Comparaciones',       'value' => $report['total_comparisons'],     'color' => '#6f42c1'],
                ['label' => 'Pares sospechosos',   'value' => $report['suspicious_pairs_count'],'color' => '#dc3545'],
                ['label' => 'Similitud máxima',    'value' => round($report['highest_similarity'], 1) . '%', 'color' => '#fd7e14'],
            ];
            foreach ($cards as $card) {
                echo html_writer::tag('div',
                    html_writer::tag('div', $card['value'], ['style' => 'font-size:2rem; font-weight:700; color:' . $card['color']]) .
                    html_writer::tag('div', $card['label'], ['style' => 'font-size:0.85rem; color:#555; margin-top:4px;']),
                    ['style' => 'background:#f8f9fa; border:1px solid #dee2e6; border-radius:8px; padding:16px; text-align:center;']
                );
            }
            echo html_writer::end_tag('div');

            // ── Botón exportar CSV (mejora #7) ────────────────────────────
            $csv_url = new moodle_url('/mod/aiassignment/plagiarism_report.php',
                ['id' => $cm->id, 'export' => 1, 'sesskey' => sesskey()]);
            echo html_writer::div(
                html_writer::link($csv_url, '⬇️ Exportar a CSV', ['class' => 'btn btn-outline-success btn-sm']),
                '', ['style' => 'text-align:right; margin-bottom:16px;']
            );

            // ── Indicador de caché ────────────────────────────────────────
            if (!empty($report['from_cache'])) {
                echo html_writer::tag('p',
                    '⚡ Resultado desde caché (no hay envíos nuevos desde el último análisis). ' .
                    html_writer::link(
                        new moodle_url('/mod/aiassignment/plagiarism_report.php', ['id' => $cm->id, 'analyze' => 1, 'force' => 1]),
                        'Forzar nuevo análisis'
                    ),
                    ['class' => 'alert alert-secondary', 'style' => 'font-size:0.85rem;']
                );
            }

            // ── Ranking de alumnos por % de plagio ────────────────────────
            if (!empty($report['user_ranking'])) {
                echo html_writer::tag('h3', '📊 Ranking de Alumnos por Porcentaje de Plagio',
                    ['style' => 'margin-bottom:12px;']);

                $rtable = new html_table();
                $rtable->attributes['class'] = 'generaltable';
                $rtable->head  = ['#', 'Alumno', 'Similitud máxima detectada', 'Nivel de riesgo'];
                $rtable->align = ['center', 'left', 'center', 'center'];

                $pos = 1;
                foreach ($report['user_ranking'] as $row) {
                    $user  = $DB->get_record('user', ['id' => $row['userid']]);
                    $pct   = round($row['max_similarity'], 1);

                    if ($pct >= \mod_aiassignment\plagiarism_detector::THRESHOLD_HIGH) {
                        $color = '#dc3545'; $badge = html_writer::span('🔴 Alto',    'badge badge-danger');
                    } elseif ($pct >= \mod_aiassignment\plagiarism_detector::THRESHOLD_MEDIUM) {
                        $color = '#856404'; $badge = html_writer::span('🟡 Medio',   'badge badge-warning');
                    } else {
                        $color = '#155724'; $badge = html_writer::span('🟢 Bajo',    'badge badge-success');
                    }

                    $bar  = html_writer::start_div('progress', ['style' => 'height:14px; display:inline-block; width:120px; vertical-align:middle; margin-right:8px;']);
                    $bar .= html_writer::div('', 'progress-bar', [
                        'role'          => 'progressbar',
                        'style'         => "width:{$pct}%; background-color:{$color};",
                        'aria-valuenow' => $pct, 'aria-valuemin' => '0', 'aria-valuemax' => '100',
                    ]);
                    $bar .= html_writer::end_div();

                    $rtable->data[] = [
                        $pos,
                        fullname($user),
                        $bar . html_writer::tag('strong', $pct . '%', ['style' => "color:{$color};"]),
                        $badge,
                    ];
                    $pos++;
                }
                echo html_writer::table($rtable);
            }

            // ── Matriz de similitud (Mejora 4) ───────────────────────────
            if (!empty($report['detailed_comparisons']) && !empty($report['user_ranking'])) {
                echo html_writer::tag('h3', '🗺️ Matriz de Similitud',
                    ['style' => 'margin:24px 0 12px;']);

                // Recopilar usuarios únicos en orden del ranking
                $matrix_users = [];
                foreach ($report['user_ranking'] as $row) {
                    $u = $DB->get_record('user', ['id' => $row['userid']]);
                    if ($u) {
                        $matrix_users[$row['userid']] = mb_strtoupper(
                            mb_substr($u->firstname, 0, 1) . '. ' . $u->lastname
                        );
                    }
                }

                // Construir mapa de scores: [uid1][uid2] => score
                $score_map = [];
                foreach ($report['detailed_comparisons'] as $cmp) {
                    $u1 = $cmp['submission1_user'];
                    $u2 = $cmp['submission2_user'];
                    $sc = round($cmp['similarity_score'], 1);
                    $score_map[$u1][$u2] = $sc;
                    $score_map[$u2][$u1] = $sc;
                }

                $uids = array_keys($matrix_users);

                echo '<div style="overflow-x:auto; margin-bottom:24px;">';
                echo '<table style="border-collapse:collapse; font-size:12px;">';

                // Cabecera
                echo '<thead><tr><th style="padding:6px 10px; background:#f8f9fa; border:1px solid #dee2e6;"></th>';
                foreach ($uids as $uid) {
                    echo '<th style="padding:6px 10px; background:#f8f9fa; border:1px solid #dee2e6; white-space:nowrap;">' .
                        s($matrix_users[$uid]) . '</th>';
                }
                echo '</tr></thead><tbody>';

                foreach ($uids as $uid1) {
                    echo '<tr>';
                    echo '<td style="padding:6px 10px; background:#f8f9fa; border:1px solid #dee2e6; font-weight:600; white-space:nowrap;">' .
                        s($matrix_users[$uid1]) . '</td>';
                    foreach ($uids as $uid2) {
                        if ($uid1 === $uid2) {
                            echo '<td style="padding:6px 10px; border:1px solid #dee2e6; text-align:center; background:#e9ecef;">—</td>';
                        } else {
                            $sc  = $score_map[$uid1][$uid2] ?? 0;
                            $bg  = $sc >= 75 ? '#f8d7da' : ($sc >= 50 ? '#fff3cd' : '#d4edda');
                            $fw  = $sc >= 75 ? '700' : '400';
                            echo '<td style="padding:6px 10px; border:1px solid #dee2e6; text-align:center; background:' . $bg . '; font-weight:' . $fw . ';">' .
                                $sc . '%</td>';
                        }
                    }
                    echo '</tr>';
                }

                echo '</tbody></table></div>';
            }

            // ── Comparaciones detalladas ──────────────────────────────────
            echo html_writer::tag('h3', '🔬 Comparaciones Detalladas',
                ['style' => 'margin:24px 0 12px;']);

            foreach ($report['detailed_comparisons'] as $idx => $cmp) {
                $u1   = $DB->get_record('user', ['id' => $cmp['submission1_user']]);
                $u2   = $DB->get_record('user', ['id' => $cmp['submission2_user']]);
                $pct  = round($cmp['similarity_score'], 1);
                $s1   = $DB->get_record('aiassignment_submissions', ['id' => $cmp['submission1_id']]);
                $s2   = $DB->get_record('aiassignment_submissions', ['id' => $cmp['submission2_id']]);

                if ($pct >= \mod_aiassignment\plagiarism_detector::THRESHOLD_HIGH) {
                    $border = '#dc3545'; $label = "🔴 Plagio probable: {$pct}%";
                } elseif ($pct >= \mod_aiassignment\plagiarism_detector::THRESHOLD_MEDIUM) {
                    $border = '#ffc107'; $label = "🟡 Sospechoso: {$pct}%";
                } else {
                    $border = '#28a745'; $label = "🟢 Original: {$pct}%";
                }

                $detail_id = 'cmp-detail-' . $idx;

                echo html_writer::start_tag('div', [
                    'style' => "border-left:4px solid {$border}; background:#fff; border:1px solid #dee2e6; border-left:4px solid {$border}; border-radius:6px; padding:16px; margin-bottom:16px;"
                ]);

                // Cabecera
                echo html_writer::start_tag('div', ['style' => 'display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:8px;']);
                echo html_writer::tag('div',
                    html_writer::tag('strong', $label, ['style' => "color:{$border}; font-size:1.05rem;"]) .
                    html_writer::tag('div',
                        html_writer::tag('span', fullname($u1)) . ' &nbsp;↔&nbsp; ' . html_writer::tag('span', fullname($u2)),
                        ['style' => 'color:#555; margin-top:4px;']
                    )
                );

                // Botón toggle
                $toggle_url = new moodle_url('/mod/aiassignment/plagiarism_report.php', [
                    'id' => $cm->id, 'analyze' => 1
                ]);
                echo html_writer::tag('button',
                    '<i class="fa fa-code"></i> Ver código',
                    [
                        'class'   => 'btn btn-sm btn-outline-secondary',
                        'onclick' => "toggleBlock('{$detail_id}', this)",
                        'type'    => 'button',
                    ]
                );
                echo html_writer::end_tag('div');

                // Barra de progreso
                echo html_writer::start_div('progress', ['style' => 'height:10px; margin:10px 0;']);
                echo html_writer::div('', 'progress-bar', [
                    'role'          => 'progressbar',
                    'style'         => "width:{$pct}%; background-color:{$border};",
                    'aria-valuenow' => $pct, 'aria-valuemin' => '0', 'aria-valuemax' => '100',
                ]);
                echo html_writer::end_div();

                // Capas de análisis
                $layers = $cmp['layers'] ?? [];
                if (!empty($layers)) {
                    echo html_writer::start_tag('div', ['style' => 'display:flex; gap:12px; flex-wrap:wrap; margin-bottom:8px;']);
                    $layer_labels = [
                        'lexical'    => ['label' => 'Léxica',     'icon' => '🔤'],
                        'structural' => ['label' => 'Estructural', 'icon' => '🏗️'],
                        'semantic'   => ['label' => 'Semántica',   'icon' => '🧠'],
                    ];
                    foreach ($layer_labels as $key => $meta) {
                        $ls = round($layers[$key]['score'] ?? 0, 1);
                        $lc = $ls >= 70 ? '#dc3545' : ($ls >= 40 ? '#856404' : '#155724');
                        echo html_writer::tag('span',
                            "{$meta['icon']} {$meta['label']}: <strong style='color:{$lc};'>{$ls}%</strong>",
                            ['style' => 'background:#f8f9fa; border:1px solid #dee2e6; border-radius:4px; padding:4px 10px; font-size:0.85rem;']
                        );
                    }
                    echo html_writer::end_tag('div');
                }

                // Técnicas detectadas
                if (!empty($cmp['techniques'])) {
                    echo html_writer::tag('div',
                        '⚠️ Técnicas de ofuscación detectadas: ' .
                        implode(' &nbsp;|&nbsp; ', array_map(
                            fn($t) => html_writer::tag('span', $t, ['style' => 'color:#dc3545; font-weight:600;']),
                            $cmp['techniques']
                        )),
                        ['style' => 'font-size:0.85rem; margin-bottom:8px;']
                    );
                }

                // Análisis IA
                if (!empty($cmp['analysis'])) {
                    echo html_writer::tag('p',
                        '🧠 ' . s($cmp['analysis']),
                        ['style' => 'font-size:0.9rem; color:#333; margin-bottom:8px;']
                    );
                }

                // Botones Confirmar / Falso positivo (Mejora 5)
                // Leer estado actual desde ai_analysis JSON del submission1
                $eval1 = $DB->get_record('aiassignment_evaluations', ['submission' => $cmp['submission1_id']]);
                $plag_status = null;
                if ($eval1 && $eval1->ai_analysis) {
                    $ai_data = json_decode($eval1->ai_analysis, true);
                    $plag_status = $ai_data['plagiarism_status'] ?? null;
                }

                echo html_writer::start_tag('div', ['style' => 'display:flex; gap:8px; align-items:center; margin-bottom:8px; flex-wrap:wrap;']);
                $confirm_url = new moodle_url('/mod/aiassignment/mark_plagiarism.php', [
                    'sid'     => $cmp['submission1_id'],
                    'status'  => 'confirmed',
                    'sesskey' => sesskey(),
                ]);
                $fp_url = new moodle_url('/mod/aiassignment/mark_plagiarism.php', [
                    'sid'     => $cmp['submission1_id'],
                    'status'  => 'false_positive',
                    'sesskey' => sesskey(),
                ]);
                echo html_writer::link($confirm_url, '✅ Confirmar plagio',
                    ['class' => 'btn btn-sm btn-danger']);
                echo html_writer::link($fp_url, '❌ Falso positivo',
                    ['class' => 'btn btn-sm btn-secondary']);
                if ($plag_status === 'confirmed') {
                    echo html_writer::tag('span', '✅ Plagio confirmado',
                        ['style' => 'color:#dc3545; font-weight:700; font-size:0.85rem;']);
                } elseif ($plag_status === 'false_positive') {
                    echo html_writer::tag('span', '❌ Falso positivo',
                        ['style' => 'color:#6c757d; font-weight:700; font-size:0.85rem;']);
                }
                echo html_writer::end_tag('div');

                // Bloque colapsable: código lado a lado
                echo html_writer::start_tag('div', ['id' => $detail_id, 'style' => 'display:none; margin-top:12px;']);
                echo html_writer::start_tag('div', ['style' => 'display:grid; grid-template-columns:1fr 1fr; gap:12px;']);

                foreach ([[$u1, $s1], [$u2, $s2]] as [$u, $s]) {
                    echo html_writer::start_tag('div');
                    echo html_writer::tag('p',
                        html_writer::tag('strong', '👤 ' . fullname($u)),
                        ['style' => 'margin-bottom:6px;']
                    );
                    echo html_writer::tag('pre',
                        s($s->answer ?? ''),
                        ['style' => 'background:#f8f9fa; border:1px solid #dee2e6; border-radius:4px; padding:12px; font-size:12px; overflow-x:auto; max-height:300px;']
                    );
                    echo html_writer::end_tag('div');
                }

                echo html_writer::end_tag('div'); // grid
                echo html_writer::end_tag('div'); // colapsable

                echo html_writer::end_tag('div'); // card
            }
        }

    } catch (Exception $e) {
        echo $OUTPUT->notification('Error al analizar plagio: ' . $e->getMessage(), 'error');
    }

} else {
    // ── Pantalla inicial: botones de inicio ───────────────────────────────
    $analyze_fast = new moodle_url('/mod/aiassignment/plagiarism_report.php',
        ['id' => $cm->id, 'analyze' => 1, 'nosem' => 1]);
    $analyze_full = new moodle_url('/mod/aiassignment/plagiarism_report.php',
        ['id' => $cm->id, 'analyze' => 1, 'nosem' => 0]);

    // Contar submissions para estimar tiempo
    $nsubs = $DB->count_records_sql(
        "SELECT COUNT(DISTINCT userid) FROM {aiassignment_submissions} WHERE assignment=:a",
        ['a' => $aiassignment->id]
    );
    $npairs     = $nsubs > 1 ? ($nsubs * ($nsubs - 1) / 2) : 0;
    $est_fast   = ceil($npairs * 0.05);   // ~50ms por par sin IA
    $est_full   = ceil($npairs * 2);      // ~2s por par con OpenAI

    echo html_writer::start_tag('div', ['style' => 'max-width:600px; margin:0 auto; padding:32px 0;']);

    // Modo rápido
    echo html_writer::start_div('', ['style' => 'background:#f8f9fa; border:1px solid #dee2e6; border-radius:10px; padding:20px; margin-bottom:16px;']);
    echo html_writer::tag('h4', '⚡ Modo Rápido', ['style' => 'margin:0 0 8px; color:#333;']);
    echo html_writer::tag('p',
        'Análisis léxico + estructural sin IA. Detecta copias directas y renombrado de variables. ' .
        html_writer::tag('strong', "Tiempo estimado: ~{$est_fast}s"),
        ['style' => 'color:#555; font-size:13.5px; margin-bottom:14px;']);
    echo html_writer::link($analyze_fast, '⚡ Iniciar análisis rápido',
        ['class' => 'btn btn-primary']);
    echo html_writer::end_div();

    // Modo completo
    echo html_writer::start_div('', ['style' => 'background:#fff5f5; border:1px solid #f5c6cb; border-radius:10px; padding:20px;']);
    echo html_writer::tag('h4', '🧠 Modo Completo (con IA)', ['style' => 'margin:0 0 8px; color:#333;']);
    echo html_writer::tag('p',
        'Análisis léxico + estructural + semántico con OpenAI. Detecta también reescrituras lógicas y ofuscación avanzada. ' .
        html_writer::tag('strong', "Tiempo estimado: ~{$est_full}s con {$nsubs} alumnos"),
        ['style' => 'color:#555; font-size:13.5px; margin-bottom:14px;']);
    echo html_writer::link($analyze_full, '🧠 Iniciar análisis completo',
        ['class' => 'btn btn-danger']);
    echo html_writer::end_div();

    echo html_writer::end_tag('div');
}

// ── Botón volver ──────────────────────────────────────────────────────────
echo html_writer::div(
    html_writer::link($back_url, '← Volver a envíos', ['class' => 'btn btn-secondary']),
    'mt-3'
);

// ── JS para toggle de código ──────────────────────────────────────────────
echo html_writer::tag('script', "
function toggleBlock(id, btn) {
    var el = document.getElementById(id);
    if (!el) return;
    var hidden = el.style.display === 'none' || el.style.display === '';
    el.style.display = hidden ? 'block' : 'none';
    btn.textContent = hidden ? 'Ocultar código' : 'Ver código';
}
");

echo $OUTPUT->footer();
