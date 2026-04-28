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
        fprintf($out, chr(0xEF).chr(0xBB).chr(0xBF)); // BOM UTF-8 para Excel
        fputcsv($out, ['Alumno 1','Alumno 2','Similitud (%)','Veredicto',
            'Léxica (%)','Estructural (%)','Semántica (%)','Técnicas detectadas']);
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

// Contar alumnos para estimación de tiempo
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

// ── Área de progreso ──────────────────────────────────────────────────────
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

// ── JS: AJAX + renderizado ────────────────────────────────────────────────
$ajax_url_js  = $ajax_url->out(false);
$ajax_full_js = $ajax_full->out(false);
$csv_url_js   = $csv_url->out(false);
$sesskey_js   = sesskey();

echo "
<script>
var _ajaxUrlFast = '{$ajax_url_js}';
var _ajaxUrlFull = '{$ajax_full_js}';
var _csvUrl      = '{$csv_url_js}';
var _sesskey     = '{$sesskey_js}';
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

    var pct = 0;
    var progressInterval = setInterval(function() {
        pct = Math.min(pct + (nosem ? 3 : 0.5), 90);
        document.getElementById('progress-bar').style.width = pct + '%';
        var elapsed = Math.round((Date.now() - startTime) / 1000);
        document.getElementById('progress-hint').textContent = 'Tiempo transcurrido: ' + elapsed + 's';
    }, 500);

    var controller = new AbortController();
    var timeoutId = setTimeout(function() { controller.abort(); }, 360000);

    fetch(url, { signal: controller.signal })
        .then(function(r) { clearTimeout(timeoutId); return r.json(); })
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
                ? '⏱️ El análisis tardó demasiado (>6 min). Intenta con el Modo Rápido.'
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

    // Indicador de modo
    var modeLabel = data.mode === 'fast' ? '⚡ Modo Rápido (sin IA)' : '🧠 Modo Completo (con IA)';
    html += '<div style=\"background:#f8f9fa;border:1px solid #dee2e6;border-radius:8px;padding:12px 16px;margin-bottom:16px;font-size:13px;\">' +
        '<strong>' + modeLabel + '</strong> — ' + data.total_comparisons + ' comparaciones en ' +
        (data.elapsed_seconds || '?') + 's</div>';

    if (data.from_cache) {
        html += '<div class=\"alert alert-secondary\" style=\"font-size:13px;\">⚡ Resultado desde caché. ' +
            '<a href=\"#\" onclick=\"startAnalysis(0);return false;\">Forzar nuevo análisis</a></div>';
    }

    // Tarjetas resumen
    html += '<div style=\"display:grid;grid-template-columns:repeat(auto-fit,minmax(150px,1fr));gap:14px;margin-bottom:20px;\">';
    [{v:data.total_submissions,l:'Total envíos',c:'#1a73e8'},
     {v:data.total_comparisons,l:'Comparaciones',c:'#6f42c1'},
     {v:data.suspicious_pairs,l:'Pares sospechosos',c:'#dc3545'},
     {v:data.highest_similarity+'%',l:'Similitud máxima',c:'#fd7e14'}
    ].forEach(function(c) {
        html += '<div style=\"background:#f8f9fa;border:1px solid #dee2e6;border-radius:8px;padding:14px;text-align:center;\">' +
            '<div style=\"font-size:1.8rem;font-weight:700;color:' + c.c + '\">' + c.v + '</div>' +
            '<div style=\"font-size:0.8rem;color:#555;margin-top:4px;\">' + c.l + '</div></div>';
    });
    html += '</div>';

    // Botones exportar + imprimir
    html += '<div style=\"text-align:right;margin-bottom:16px;display:flex;gap:8px;justify-content:flex-end;\">' +
        '<a href=\"' + _csvUrl + '\" class=\"btn btn-sm btn-success\">⬇️ Exportar CSV</a>' +
        '<button class=\"btn btn-sm btn-secondary\" onclick=\"window.print()\" type=\"button\">🖨️ Imprimir / PDF</button>' +
        '</div>';

    // ── Matriz de similitud NxN ──────────────────────────────────────────
    if (data.user_ranking && data.user_ranking.length > 1 && data.comparisons.length > 0) {
        html += '<h3 style=\"margin:0 0 12px;\">🗺️ Matriz de Similitud</h3>';
        html += '<div style=\"overflow-x:auto;margin-bottom:24px;\"><table style=\"border-collapse:collapse;font-size:11px;\">';

        // Cabecera
        html += '<thead><tr><th style=\"padding:5px 8px;background:#f8f9fa;border:1px solid #dee2e6;\"></th>';
        data.user_ranking.forEach(function(u) {
            var short = u.name.split(' ').map(function(w){return w[0]||'';}).join('.');
            html += '<th style=\"padding:5px 8px;background:#f8f9fa;border:1px solid #dee2e6;white-space:nowrap;\" title=\"' + u.name + '\">' + short + '</th>';
        });
        html += '</tr></thead><tbody>';

        // Filas
        data.user_ranking.forEach(function(u1) {
            html += '<tr><td style=\"padding:5px 8px;background:#f8f9fa;border:1px solid #dee2e6;font-weight:600;white-space:nowrap;\">' + u1.name.split(' ')[0] + '</td>';
            data.user_ranking.forEach(function(u2) {
                if (u1.userid === u2.userid) {
                    html += '<td style=\"padding:5px 8px;border:1px solid #dee2e6;text-align:center;background:#e9ecef;\">—</td>';
                } else {
                    var sc = 0;
                    data.comparisons.forEach(function(c) {
                        if ((c.user1 === u1.name && c.user2 === u2.name) ||
                            (c.user2 === u1.name && c.user1 === u2.name)) sc = c.score;
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

    // ── Ranking de alumnos ───────────────────────────────────────────────
    html += '<h3 style=\"margin-bottom:12px;\">📊 Ranking de Alumnos</h3>';
    html += '<table style=\"width:100%;border-collapse:collapse;font-size:13px;margin-bottom:24px;\">';
    html += '<thead><tr style=\"background:#f8f9fa;\">' +
        '<th style=\"padding:8px 12px;text-align:left;\">#</th>' +
        '<th style=\"padding:8px 12px;text-align:left;\">Alumno</th>' +
        '<th style=\"padding:8px 12px;text-align:center;\">Similitud</th>' +
        '<th style=\"padding:8px 12px;text-align:center;\">Nivel</th></tr></thead><tbody>';

    data.user_ranking.forEach(function(r, i) {
        var pct   = r.max_similarity;
        var color = pct >= 75 ? '#dc3545' : (pct >= 50 ? '#856404' : '#155724');
        var badge = pct >= 75 ? '🔴 Alto' : (pct >= 50 ? '🟡 Medio' : '🟢 Bajo');
        var bar   = '<div style=\"display:inline-block;width:80px;height:10px;background:#e9ecef;border-radius:5px;vertical-align:middle;margin-right:6px;\">' +
            '<div style=\"width:' + pct + '%;height:10px;background:' + color + ';border-radius:5px;\"></div></div>';
        html += '<tr style=\"border-bottom:1px solid #f0f0f0;\">' +
            '<td style=\"padding:8px 12px;\">' + (i+1) + '</td>' +
            '<td style=\"padding:8px 12px;font-weight:600;\">' + r.name + '</td>' +
            '<td style=\"padding:8px 12px;text-align:center;\">' + bar +
            '<strong style=\"color:' + color + ';\">' + pct + '%</strong></td>' +
            '<td style=\"padding:8px 12px;text-align:center;\">' + badge + '</td></tr>';
    });
    html += '</tbody></table>';

    // ── Comparaciones detalladas ─────────────────────────────────────────
    html += '<h3 style=\"margin:20px 0 12px;\">🔬 Comparaciones Detalladas</h3>';
    data.comparisons.forEach(function(cmp, idx) {
        var pct    = cmp.score;
        var border = pct >= 75 ? '#dc3545' : (pct >= 50 ? '#ffc107' : '#28a745');
        var label  = pct >= 75 ? '🔴 Plagio probable' : (pct >= 50 ? '🟡 Sospechoso' : '🟢 Original');
        var did    = 'cmp-' + idx;

        html += '<div style=\"border-left:4px solid ' + border + ';background:#fff;border:1px solid #dee2e6;' +
            'border-radius:6px;padding:14px;margin-bottom:12px;\">';

        html += '<div style=\"display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:8px;\">';
        html += '<div><strong style=\"color:' + border + ';font-size:1rem;\">' + label + ': ' + pct + '%</strong>' +
            '<div style=\"color:#555;margin-top:3px;font-size:13px;\">' + cmp.user1 + ' ↔ ' + cmp.user2 + '</div></div>';
        html += '<button class=\"btn btn-sm btn-secondary\" onclick=\"toggleDetail(\\'' + did + '\\',this)\" type=\"button\">Ver código</button>';
        html += '</div>';

        // Barra de progreso
        html += '<div style=\"height:8px;background:#e9ecef;border-radius:4px;margin:10px 0;\">' +
            '<div style=\"width:' + pct + '%;height:8px;background:' + border + ';border-radius:4px;\"></div></div>';

        // Capas
        html += '<div style=\"display:flex;gap:10px;flex-wrap:wrap;margin-bottom:6px;font-size:12px;\">';
        [{k:'lexical',l:'🔤 Léxica'},{k:'structural',l:'🏗️ Estructural'},{k:'semantic',l:'🧠 Semántica'}]
        .forEach(function(ly) {
            var ls = cmp.layers[ly.k];
            var lc = ls >= 70 ? '#dc3545' : (ls >= 40 ? '#856404' : '#155724');
            html += '<span style=\"background:#f8f9fa;border:1px solid #dee2e6;border-radius:4px;padding:3px 8px;\">' +
                ly.l + ': <strong style=\"color:' + lc + ';\">' + ls + '%</strong></span>';
        });
        html += '</div>';

        // Técnicas de ofuscación detectadas
        if (cmp.techniques && cmp.techniques.length) {
            html += '<div style=\"font-size:12px;margin-bottom:6px;color:#856404;\">⚠️ Técnicas: ' + cmp.techniques.join(' | ') + '</div>';
        }

        // Análisis IA
        if (cmp.analysis) {
            html += '<p style=\"font-size:12px;color:#333;margin-bottom:6px;\">🧠 ' + cmp.analysis + '</p>';
        }

        // Acciones
        html += '<div style=\"display:flex;gap:8px;margin-top:6px;\">' +
            '<a href=\"/mod/aiassignment/mark_plagiarism.php?sid=' + cmp.sub1_id + '&status=confirmed&sesskey=' + _sesskey + '\" class=\"btn btn-sm btn-danger\">✅ Confirmar plagio</a>' +
            '<a href=\"/mod/aiassignment/mark_plagiarism.php?sid=' + cmp.sub1_id + '&status=false_positive&sesskey=' + _sesskey + '\" class=\"btn btn-sm btn-secondary\">❌ Falso positivo</a>' +
            '</div>';

        // Bloque colapsable con links a envíos
        html += '<div id=\"' + did + '\" style=\"display:none;margin-top:10px;\">' +
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
    btn.textContent  = hidden ? 'Ocultar' : 'Ver código';
}
</script>
";

echo html_writer::div(
    html_writer::link($back_url, '← Volver a envíos', ['class' => 'btn btn-secondary']),
    'mt-3'
);

echo $OUTPUT->footer();
