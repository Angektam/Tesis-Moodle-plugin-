<?php
// This file is part of Moodle - http://moodle.org/
// Página de resultados de evaluación del sistema — para la tesis

require_once('../../config.php');
require_once($CFG->dirroot . '/mod/aiassignment/lib.php');

$courseid = required_param('courseid', PARAM_INT);
$format   = optional_param('format', 'html', PARAM_ALPHA); // html | csv | excel

$course = $DB->get_record('course', ['id' => $courseid], '*', MUST_EXIST);
require_login($course);
$context = context_course::instance($course->id);
require_capability('mod/aiassignment:grade', $context);

// ── Recopilar todos los datos del experimento ─────────────────
$sql = "SELECT
    u.id AS userid,
    CONCAT(u.firstname, ' ', u.lastname) AS alumno,
    s.id AS submission_id,
    s.score,
    s.status,
    s.attempt,
    s.timecreated,
    e.similarity_score,
    e.ai_analysis,
    a.name AS assignment_name,
    a.type AS assignment_type
FROM {aiassignment_submissions} s
JOIN {aiassignment} a ON s.assignment = a.id
JOIN {user} u ON s.userid = u.id
LEFT JOIN {aiassignment_evaluations} e ON e.submission = s.id
WHERE a.course = :courseid
ORDER BY e.similarity_score DESC, s.score DESC";

$rows = $DB->get_records_sql($sql, ['courseid' => $courseid]);

// Calcular métricas del sistema
$total          = count($rows);
$evaluated      = 0;
$with_plagio    = 0;
$confirmed      = 0;
$false_positive = 0;
$pending_review = 0;
$scores         = [];
$sim_scores     = [];

foreach ($rows as $r) {
    if ($r->status === 'evaluated') $evaluated++;
    if ($r->similarity_score !== null) {
        $sim_scores[] = (float)$r->similarity_score;
        if ($r->similarity_score >= 75) {
            $with_plagio++;
            // Leer estado de revisión del JSON
            $ai = json_decode($r->ai_analysis ?: '{}', true);
            $ps = $ai['plagiarism_status'] ?? null;
            if ($ps === 'confirmed')      $confirmed++;
            elseif ($ps === 'false_positive') $false_positive++;
            else                          $pending_review++;
        }
    }
    if ($r->score !== null) $scores[] = (float)$r->score;
}

$avg_score      = !empty($scores)     ? round(array_sum($scores) / count($scores), 2)     : 0;
$avg_sim        = !empty($sim_scores) ? round(array_sum($sim_scores) / count($sim_scores), 2) : 0;
$max_sim        = !empty($sim_scores) ? max($sim_scores) : 0;
$precision      = ($confirmed + $false_positive) > 0
    ? round($confirmed / ($confirmed + $false_positive) * 100, 1) : null;
$detection_rate = $total > 0 ? round($with_plagio / $total * 100, 1) : 0;

// ── Exportar CSV ──────────────────────────────────────────────
if ($format === 'csv') {
    header('Content-Type: text/csv; charset=utf-8');
    header('Content-Disposition: attachment; filename="resultados_tesis_' . date('Ymd') . '.csv"');
    $out = fopen('php://output', 'w');
    fprintf($out, chr(0xEF).chr(0xBB).chr(0xBF));
    fputcsv($out, ['Alumno', 'Tarea', 'Tipo', 'Intento', 'Calificación (%)',
        'Similitud Plagio (%)', 'Estado', 'Revisión Plagio', 'Fecha Envío']);
    foreach ($rows as $r) {
        $ai = json_decode($r->ai_analysis ?: '{}', true);
        $ps = $ai['plagiarism_status'] ?? 'Sin revisar';
        fputcsv($out, [
            $r->alumno,
            $r->assignment_name,
            $r->assignment_type,
            $r->attempt,
            $r->score !== null ? number_format($r->score, 2) : 'N/A',
            $r->similarity_score !== null ? number_format($r->similarity_score, 2) : 'N/A',
            $r->status,
            $ps === 'confirmed' ? 'Plagio confirmado' : ($ps === 'false_positive' ? 'Falso positivo' : 'Sin revisar'),
            date('d/m/Y H:i', $r->timecreated),
        ]);
    }
    // Sección de métricas al final
    fputcsv($out, []);
    fputcsv($out, ['=== MÉTRICAS DEL SISTEMA ===']);
    fputcsv($out, ['Total de envíos', $total]);
    fputcsv($out, ['Envíos evaluados', $evaluated]);
    fputcsv($out, ['Promedio de calificaciones', $avg_score . '%']);
    fputcsv($out, ['Casos con plagio detectado (>= 75%)', $with_plagio]);
    fputcsv($out, ['Tasa de detección', $detection_rate . '%']);
    fputcsv($out, ['Plagio confirmado por profesor', $confirmed]);
    fputcsv($out, ['Falsos positivos', $false_positive]);
    fputcsv($out, ['Sin revisar', $pending_review]);
    if ($precision !== null) fputcsv($out, ['Precisión del detector', $precision . '%']);
    fputcsv($out, ['Similitud promedio', $avg_sim . '%']);
    fputcsv($out, ['Similitud máxima detectada', $max_sim . '%']);
    fclose($out);
    exit;
}

// ── Vista HTML ────────────────────────────────────────────────
$PAGE->set_url('/mod/aiassignment/thesis_results.php', ['courseid' => $courseid]);
$PAGE->set_title('Resultados del Sistema — ' . format_string($course->fullname));
$PAGE->set_heading(format_string($course->fullname));
$PAGE->set_context($context);
$PAGE->set_pagelayout('incourse');
$PAGE->requires->css('/mod/aiassignment/styles/dashboard.css');

echo $OUTPUT->header();
echo html_writer::start_div('aiassignment-dashboard');
echo html_writer::tag('h2', '📊 Resultados de Evaluación del Sistema', ['class' => 'dashboard-title']);

// Botones de exportación
$csv_url  = new moodle_url('/mod/aiassignment/thesis_results.php', ['courseid' => $courseid, 'format' => 'csv']);
$back_url = new moodle_url('/mod/aiassignment/dashboard.php', ['courseid' => $courseid]);
echo html_writer::start_div('', ['style' => 'display:flex;gap:10px;margin-bottom:20px;flex-wrap:wrap;']);
echo html_writer::link($csv_url, '⬇️ Exportar CSV (Excel)', ['class' => 'btn btn-success']);
echo html_writer::tag('button', '🖨️ Imprimir / PDF', ['class' => 'btn btn-secondary', 'onclick' => 'window.print()', 'type' => 'button']);
echo html_writer::link($back_url, '← Dashboard', ['class' => 'btn btn-secondary']);
echo html_writer::end_div();

// ── Tarjetas de métricas ──────────────────────────────────────
echo html_writer::start_div('stats-cards-container', ['style' => 'grid-template-columns:repeat(4,1fr);']);
$cards = [
    ['num' => $total,           'label' => 'Total Envíos',          'cls' => 'stat-card-primary'],
    ['num' => $avg_score . '%', 'label' => 'Promedio Calificación', 'cls' => 'stat-card-success'],
    ['num' => $with_plagio,     'label' => 'Casos Plagio ≥75%',     'cls' => 'stat-card-danger'],
    ['num' => $detection_rate . '%', 'label' => 'Tasa de Detección', 'cls' => 'stat-card-warning'],
    ['num' => $confirmed,       'label' => 'Plagio Confirmado',     'cls' => 'stat-card-danger'],
    ['num' => $false_positive,  'label' => 'Falsos Positivos',      'cls' => 'stat-card-warning'],
    ['num' => $precision !== null ? $precision . '%' : 'N/A', 'label' => 'Precisión del Detector', 'cls' => 'stat-card-success'],
    ['num' => $avg_sim . '%',   'label' => 'Similitud Promedio',    'cls' => 'stat-card-info'],
];
foreach ($cards as $c) {
    echo html_writer::start_div('stat-card ' . $c['cls']);
    echo html_writer::tag('div', $c['num'], ['class' => 'stat-number']);
    echo html_writer::tag('div', $c['label'], ['class' => 'stat-label']);
    echo html_writer::end_div();
}
echo html_writer::end_div();

// ── Gráfica de distribución de similitud ─────────────────────
$sim_dist = ['0-24' => 0, '25-49' => 0, '50-74' => 0, '75-89' => 0, '90-100' => 0];
foreach ($sim_scores as $s) {
    if ($s < 25)       $sim_dist['0-24']++;
    elseif ($s < 50)   $sim_dist['25-49']++;
    elseif ($s < 75)   $sim_dist['50-74']++;
    elseif ($s < 90)   $sim_dist['75-89']++;
    else               $sim_dist['90-100']++;
}

echo html_writer::start_div('dashboard-section', ['style' => 'margin-bottom:20px;']);
echo html_writer::tag('h3', '📊 Distribución de Similitud de Plagio', ['class' => 'section-title']);
echo '<div style="display:grid;grid-template-columns:1fr 1fr;gap:20px;">';
echo '<div style="position:relative;height:220px;"><canvas id="simChart"></canvas></div>';
echo '<div style="position:relative;height:220px;"><canvas id="precisionChart"></canvas></div>';
echo '</div>';
$sim_labels = json_encode(array_keys($sim_dist));
$sim_data   = json_encode(array_values($sim_dist));
$prec_data  = json_encode([$confirmed, $false_positive, $pending_review]);
echo "<script>
(function() {
    function build() {
        new Chart(document.getElementById('simChart'), {
            type: 'bar',
            data: { labels: {$sim_labels}, datasets: [{ data: {$sim_data},
                backgroundColor: ['#28a745','#17a2b8','#ffc107','#fd7e14','#dc3545'],
                borderRadius: 6 }] },
            options: { responsive: true, maintainAspectRatio: false,
                plugins: { legend: { display: false },
                    title: { display: true, text: 'Distribución de Similitud (%)' } },
                scales: { y: { beginAtZero: true, ticks: { stepSize: 1 } } } }
        });
        new Chart(document.getElementById('precisionChart'), {
            type: 'doughnut',
            data: { labels: ['Plagio confirmado', 'Falso positivo', 'Sin revisar'],
                datasets: [{ data: {$prec_data},
                    backgroundColor: ['#dc3545','#6c757d','#dee2e6'], borderWidth: 2 }] },
            options: { responsive: true, maintainAspectRatio: false,
                plugins: { legend: { position: 'bottom' },
                    title: { display: true, text: 'Precisión del Detector' } } }
        });
    }
    if (typeof Chart === 'undefined') {
        var s = document.createElement('script');
        s.src = 'https://cdn.jsdelivr.net/npm/chart.js@4/dist/chart.umd.min.js';
        s.onload = build; document.head.appendChild(s);
    } else { build(); }
})();
</script>";
echo html_writer::end_div();

// ── Tabla completa de resultados ──────────────────────────────
echo html_writer::start_div('dashboard-section');
echo html_writer::tag('h3', '📋 Tabla Completa de Resultados', ['class' => 'section-title']);
echo html_writer::tag('p',
    'Todos los envíos ordenados por porcentaje de similitud detectada (mayor a menor).',
    ['style' => 'color:#666;font-size:13px;margin-bottom:12px;']);

echo html_writer::start_tag('table', ['class' => 'submissions-table']);
echo html_writer::tag('thead', html_writer::tag('tr',
    html_writer::tag('th', '#') .
    html_writer::tag('th', 'Alumno') .
    html_writer::tag('th', 'Tarea') .
    html_writer::tag('th', 'Calificación') .
    html_writer::tag('th', 'Similitud') .
    html_writer::tag('th', 'Estado') .
    html_writer::tag('th', 'Revisión')
));
echo html_writer::start_tag('tbody');
$i = 1;
foreach ($rows as $r) {
    $score_cell = $r->score !== null
        ? html_writer::tag('span', number_format($r->score, 1) . '%',
            ['class' => 'grade-badge ' . aiassignment_get_grade_class($r->score)])
        : html_writer::tag('span', '—', ['style' => 'color:#bbb;']);

    $sim = $r->similarity_score;
    if ($sim !== null) {
        $sc  = round($sim, 1);
        $cls = $sc >= 75 ? 'plag-high' : ($sc >= 50 ? 'plag-medium' : 'plag-low');
        $sim_cell = html_writer::tag('span', $sc . '%', ['class' => $cls]);
    } else {
        $sim_cell = html_writer::tag('span', '—', ['style' => 'color:#bbb;']);
    }

    $ai = json_decode($r->ai_analysis ?: '{}', true);
    $ps = $ai['plagiarism_status'] ?? null;
    if ($ps === 'confirmed')      $rev = html_writer::tag('span', '✅ Confirmado', ['style' => 'color:#dc3545;font-weight:700;font-size:12px;']);
    elseif ($ps === 'false_positive') $rev = html_writer::tag('span', '❌ Falso positivo', ['style' => 'color:#6c757d;font-size:12px;']);
    else                          $rev = html_writer::tag('span', '—', ['style' => 'color:#bbb;']);

    $status_map = [
        'evaluated' => html_writer::tag('span', 'Evaluado', ['class' => 'badge badge-green']),
        'pending'   => html_writer::tag('span', 'Pendiente', ['class' => 'badge badge-warning']),
        'flagged'   => html_writer::tag('span', 'Re-envío', ['class' => 'badge badge-warning']),
    ];
    $status_cell = $status_map[$r->status] ?? html_writer::tag('span', $r->status);

    echo html_writer::tag('tr',
        html_writer::tag('td', $i, ['style' => 'color:#888;font-size:12px;']) .
        html_writer::tag('td', s($r->alumno), ['style' => 'font-weight:600;']) .
        html_writer::tag('td', s($r->assignment_name), ['style' => 'font-size:12px;color:#666;']) .
        html_writer::tag('td', $score_cell, ['class' => 'text-center']) .
        html_writer::tag('td', $sim_cell, ['class' => 'text-center']) .
        html_writer::tag('td', $status_cell, ['class' => 'text-center']) .
        html_writer::tag('td', $rev, ['class' => 'text-center'])
    );
    $i++;
}
echo html_writer::end_tag('tbody');
echo html_writer::end_tag('table');
echo html_writer::end_div();

echo html_writer::end_div();
echo $OUTPUT->footer();
