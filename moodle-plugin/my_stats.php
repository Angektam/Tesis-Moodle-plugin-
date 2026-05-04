<?php
// This file is part of Moodle - http://moodle.org/
// Página de estadísticas personales del alumno — Mejora 1.

require_once('../../config.php');
require_once($CFG->dirroot . '/mod/aiassignment/lib.php');

$cmid = required_param('id', PARAM_INT); // Course Module ID

$cm           = get_coursemodule_from_id('aiassignment', $cmid, 0, false, MUST_EXIST);
$course       = $DB->get_record('course', ['id' => $cm->course], '*', MUST_EXIST);
$aiassignment = $DB->get_record('aiassignment', ['id' => $cm->instance], '*', MUST_EXIST);

require_login($course, true, $cm);
$context = context_module::instance($cm->id);

// Solo el propio alumno puede ver sus estadísticas (o el profesor)
$cangrade = has_capability('mod/aiassignment:grade', $context);

$PAGE->set_url('/mod/aiassignment/my_stats.php', ['id' => $cmid]);
$PAGE->set_title('Mis estadísticas — ' . format_string($aiassignment->name));
$PAGE->set_heading(format_string($course->fullname));
$PAGE->set_context($context);
$PAGE->requires->css('/mod/aiassignment/styles/dashboard.css');

// ── Obtener todos los envíos del alumno en ESTE curso ─────────
$sql = "SELECT s.id, s.assignment, s.attempt, s.score, s.status, s.feedback,
               s.timecreated, s.evaluated_at,
               a.name AS assignment_name, a.type AS assignment_type,
               a.maxattempts,
               e.similarity_score, e.ai_analysis
        FROM {aiassignment_submissions} s
        JOIN {aiassignment} a ON s.assignment = a.id
        LEFT JOIN {aiassignment_evaluations} e ON e.submission = s.id
        WHERE a.course = :courseid AND s.userid = :userid
        ORDER BY s.timecreated ASC";

$submissions = array_values($DB->get_records_sql($sql, [
    'courseid' => $course->id,
    'userid'   => $USER->id,
]));

// ── Calcular estadísticas ─────────────────────────────────────
$total_subs   = count($submissions);
$scores       = array_filter(array_column($submissions, 'score'), fn($v) => $v !== null);
$avg_grade    = !empty($scores) ? round(array_sum($scores) / count($scores), 1) : 0;
$best_score   = !empty($scores) ? round(max($scores), 1) : 0;
$worst_score  = !empty($scores) ? round(min($scores), 1) : 0;
$evaluated    = count(array_filter($submissions, fn($s) => $s->status === 'evaluated'));
$pending      = $total_subs - $evaluated;

// Tendencia: comparar primer y último score
$trend_text = '';
$trend_color = '#555';
if (count($scores) >= 2) {
    $first = reset($scores);
    $last  = end($scores);
    $diff  = round($last - $first, 1);
    if ($diff > 0) {
        $trend_text  = "📈 Mejoraste +{$diff}% desde tu primer envío";
        $trend_color = '#28a745';
    } elseif ($diff < 0) {
        $trend_text  = "📉 Bajaste {$diff}% desde tu primer envío";
        $trend_color = '#dc3545';
    } else {
        $trend_text  = "➡️ Tu calificación se mantiene estable";
        $trend_color = '#6c757d';
    }
}

// Datos para gráfica de evolución
$chart_labels = [];
$chart_scores = [];
$chart_colors = [];
foreach ($submissions as $sub) {
    if ($sub->score !== null) {
        $chart_labels[] = mb_substr($sub->assignment_name, 0, 15) . ' #' . $sub->attempt;
        $chart_scores[] = round($sub->score, 1);
        $chart_colors[] = $sub->score >= 80 ? 'rgba(40,167,69,0.8)'
                        : ($sub->score >= 60 ? 'rgba(255,193,7,0.8)' : 'rgba(220,53,69,0.8)');
    }
}

// Distribución de calificaciones personales
$dist = ['90-100' => 0, '80-89' => 0, '70-79' => 0, '60-69' => 0, '<60' => 0];
foreach ($scores as $s) {
    if ($s >= 90)      $dist['90-100']++;
    elseif ($s >= 80)  $dist['80-89']++;
    elseif ($s >= 70)  $dist['70-79']++;
    elseif ($s >= 60)  $dist['60-69']++;
    else               $dist['<60']++;
}

echo $OUTPUT->header();
echo html_writer::start_div('aiassignment-dashboard');

// ── Cabecera ──────────────────────────────────────────────────
$initials = mb_strtoupper(mb_substr($USER->firstname, 0, 1) . mb_substr($USER->lastname, 0, 1));
echo html_writer::start_div('', ['style' =>
    'display:flex;align-items:center;gap:16px;margin-bottom:24px;']);
echo html_writer::tag('div', $initials, ['style' =>
    'width:60px;height:60px;border-radius:50%;background:linear-gradient(135deg,#2563eb,#1d4ed8);' .
    'color:#fff;font-size:20px;font-weight:700;display:flex;align-items:center;' .
    'justify-content:center;flex-shrink:0;box-shadow:0 2px 8px rgba(37,99,235,.3);']);
echo html_writer::start_div('');
echo html_writer::tag('h2', '📊 Mis Estadísticas — ' . fullname($USER),
    ['style' => 'margin:0 0 4px;font-size:20px;font-weight:700;']);
echo html_writer::tag('p', format_string($course->fullname),
    ['style' => 'margin:0;color:#6b7280;font-size:13px;']);
echo html_writer::end_div();
echo html_writer::end_div();

if ($total_subs === 0) {
    echo $OUTPUT->notification('Aún no has enviado ninguna tarea en este curso.', 'info');
    echo html_writer::link(
        new moodle_url('/mod/aiassignment/view.php', ['id' => $cmid]),
        '← Volver a la tarea', ['class' => 'btn btn-primary']);
    echo $OUTPUT->footer();
    exit;
}

// ── Tarjetas de estadísticas ──────────────────────────────────
echo html_writer::start_div('stats-cards-container');

echo html_writer::start_div('stat-card stat-card-primary');
echo html_writer::tag('div', $total_subs, ['class' => 'stat-number']);
echo html_writer::tag('div', 'Total de Envíos', ['class' => 'stat-label']);
echo html_writer::end_div();

echo html_writer::start_div('stat-card stat-card-success');
echo html_writer::tag('div', $avg_grade . '%', ['class' => 'stat-number']);
echo html_writer::tag('div', 'Mi Promedio', ['class' => 'stat-label']);
echo html_writer::end_div();

echo html_writer::start_div('stat-card stat-card-info');
echo html_writer::tag('div', $best_score . '%', ['class' => 'stat-number']);
echo html_writer::tag('div', 'Mejor Nota', ['class' => 'stat-label']);
echo html_writer::end_div();

$pend_class = $pending > 0 ? 'stat-card-warning' : 'stat-card-ok';
echo html_writer::start_div('stat-card ' . $pend_class);
echo html_writer::tag('div', $pending, ['class' => 'stat-number']);
echo html_writer::tag('div', 'Pendientes', ['class' => 'stat-label']);
echo html_writer::end_div();

echo html_writer::end_div(); // stats-cards-container

// ── Tendencia ─────────────────────────────────────────────────
if ($trend_text) {
    echo html_writer::tag('div', $trend_text, ['style' =>
        "background:#f8f9fa;border-radius:8px;padding:10px 16px;margin-bottom:16px;" .
        "font-size:14px;font-weight:600;color:$trend_color;border:1px solid #dee2e6;"]);
}

// ── Layout: gráficas + tabla ──────────────────────────────────
echo html_writer::start_div('dashboard-content');
echo html_writer::start_div('dashboard-column dashboard-left');

// Gráfica de evolución
if (count($chart_scores) > 0) {
    echo html_writer::start_div('dashboard-section');
    echo html_writer::tag('h3', '📈 Evolución de mis calificaciones', ['class' => 'section-title']);
    echo '<div class="chart-container chart-md"><canvas id="myEvolutionChart"></canvas></div>';
    echo html_writer::end_div();
}

// Tabla de envíos
echo html_writer::start_div('dashboard-section');
echo html_writer::tag('h3', '📋 Mis Envíos', ['class' => 'section-title']);
echo html_writer::start_tag('table', ['class' => 'submissions-table']);
echo html_writer::tag('thead', html_writer::tag('tr',
    html_writer::tag('th', 'Tarea') .
    html_writer::tag('th', 'Intento') .
    html_writer::tag('th', 'Fecha') .
    html_writer::tag('th', 'Calificación') .
    html_writer::tag('th', 'Estado') .
    html_writer::tag('th', 'Acción')
));
echo html_writer::start_tag('tbody');

foreach ($submissions as $sub) {
    $score_cell = ($sub->score !== null)
        ? html_writer::tag('span', number_format($sub->score, 1) . '%',
            ['class' => 'grade-badge ' . aiassignment_get_grade_class($sub->score)])
        : html_writer::tag('span', '—', ['style' => 'color:#bbb;']);

    $status_map = [
        'evaluated' => html_writer::tag('span', '✅ Evaluado',  ['class' => 'badge badge-success']),
        'pending'   => html_writer::tag('span', '⏳ Pendiente', ['class' => 'badge badge-warning']),
        'flagged'   => html_writer::tag('span', '📩 Re-envío',  ['class' => 'badge badge-danger']),
    ];
    $status_cell = $status_map[$sub->status] ?? html_writer::tag('span', s($sub->status), ['class' => 'badge']);

    $view_url = new moodle_url('/mod/aiassignment/submission.php', ['id' => $sub->id]);

    echo html_writer::tag('tr',
        html_writer::tag('td', s($sub->assignment_name), ['style' => 'font-size:12px;color:#666;']) .
        html_writer::tag('td', $sub->attempt, ['class' => 'text-center']) .
        html_writer::tag('td', userdate($sub->timecreated, '%d/%m/%Y %H:%M')) .
        html_writer::tag('td', $score_cell, ['class' => 'text-center']) .
        html_writer::tag('td', $status_cell, ['class' => 'text-center']) .
        html_writer::tag('td',
            html_writer::link($view_url, 'Ver detalle', ['class' => 'btn btn-sm btn-primary']),
            ['class' => 'text-center'])
    );
}
echo html_writer::end_tag('tbody');
echo html_writer::end_tag('table');
echo html_writer::end_div();

echo html_writer::end_div(); // dashboard-left

// ── Columna derecha: distribución ────────────────────────────
echo html_writer::start_div('dashboard-column dashboard-right');

echo html_writer::start_div('dashboard-section');
echo html_writer::tag('h3', '📊 Distribución de mis notas', ['class' => 'section-title']);
if (array_sum($dist) > 0) {
    echo '<div class="chart-container chart-md"><canvas id="myDistChart"></canvas></div>';
} else {
    echo html_writer::tag('p', 'Sin calificaciones aún.', ['class' => 'alert alert-info']);
}
echo html_writer::end_div();

// Consejo personalizado
echo html_writer::start_div('dashboard-section');
echo html_writer::tag('h3', '💡 Consejo personalizado', ['class' => 'section-title']);
if ($avg_grade >= 85) {
    $tip = '🌟 Excelente rendimiento. Sigue así y considera revisar el código de tus compañeros en la sección de peer review.';
} elseif ($avg_grade >= 70) {
    $tip = '✅ Buen trabajo. Para mejorar, revisa el análisis detallado de la IA en cada envío y enfócate en los criterios con menor puntuación.';
} elseif ($avg_grade >= 55) {
    $tip = '⚠️ Rendimiento aceptable. Lee el feedback de la IA con atención — identifica qué criterio (funcionalidad, estilo, eficiencia) tiene menor puntuación y trabaja en eso.';
} else {
    $tip = '📚 Necesitas mejorar. Revisa los ejemplos de la tarea, lee el feedback detallado de cada envío y no dudes en pedir ayuda al profesor.';
}
echo html_writer::tag('div', $tip, ['style' =>
    'background:#f0f9ff;border:1px solid #bee3f8;border-radius:8px;padding:14px;font-size:13px;color:#1a56db;']);
echo html_writer::end_div();

echo html_writer::end_div(); // dashboard-right
echo html_writer::end_div(); // dashboard-content

// ── Botón volver ──────────────────────────────────────────────
echo html_writer::div(
    html_writer::link(
        new moodle_url('/mod/aiassignment/view.php', ['id' => $cmid]),
        '← Volver a la tarea', ['class' => 'btn btn-secondary']
    ),
    '', ['style' => 'margin-top:20px;']
);

echo html_writer::end_div(); // aiassignment-dashboard

// ── Gráficas ──────────────────────────────────────────────────
$labels_json = json_encode($chart_labels);
$scores_json = json_encode($chart_scores);
$colors_json = json_encode($chart_colors);
$dist_labels = json_encode(array_keys($dist));
$dist_data   = json_encode(array_values($dist));

echo "
<script>
(function() {
    function buildCharts() {
        // Gráfica de evolución
        var evEl = document.getElementById('myEvolutionChart');
        if (evEl) {
            new Chart(evEl, {
                type: 'bar',
                data: {
                    labels: {$labels_json},
                    datasets: [{
                        label: 'Calificación (%)',
                        data: {$scores_json},
                        backgroundColor: {$colors_json},
                        borderRadius: 6,
                        borderSkipped: false,
                    }]
                },
                options: {
                    responsive: true, maintainAspectRatio: false,
                    plugins: { legend: { display: false } },
                    scales: {
                        y: { beginAtZero: true, max: 100,
                             title: { display: true, text: 'Calificación (%)' },
                             ticks: { font: { size: 11 } } },
                        x: { ticks: { font: { size: 10 } } }
                    }
                }
            });
        }

        // Gráfica de distribución
        var distEl = document.getElementById('myDistChart');
        if (distEl) {
            new Chart(distEl, {
                type: 'doughnut',
                data: {
                    labels: {$dist_labels},
                    datasets: [{
                        data: {$dist_data},
                        backgroundColor: ['#28a745','#17a2b8','#ffc107','#fd7e14','#dc3545'],
                        borderWidth: 2
                    }]
                },
                options: {
                    responsive: true, maintainAspectRatio: false,
                    plugins: {
                        legend: { position: 'bottom', labels: { font: { size: 11 } } }
                    }
                }
            });
        }
    }

    if (typeof Chart === 'undefined') {
        var s = document.createElement('script');
        s.src = 'https://cdn.jsdelivr.net/npm/chart.js@4/dist/chart.umd.min.js';
        s.onload = buildCharts;
        document.head.appendChild(s);
    } else {
        buildCharts();
    }
})();
</script>
";

echo $OUTPUT->footer();
