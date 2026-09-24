<?php
require_once('../../config.php');
require_once($CFG->dirroot . '/mod/aiassignment/lib.php');

$courseid = required_param('courseid', PARAM_INT);
$format   = optional_param('format', 'html', PARAM_ALPHA); // html o csv

$course = $DB->get_record('course', ['id' => $courseid], '*', MUST_EXIST);
require_login($course);
$context = context_course::instance($course->id);
require_capability('mod/aiassignment:grade', $context);

// Recopilar datos
$assignments = $DB->get_records('aiassignment', ['course' => $courseid]);
$stats       = aiassignment_get_course_statistics($courseid);
$plag_count  = aiassignment_get_plagiarism_alert_count($courseid);

// Distribución de notas
$dist = ['90-100' => 0, '80-89' => 0, '70-79' => 0, '60-69' => 0, '<60' => 0];
$all_scores = $DB->get_records_sql(
    "SELECT s.score FROM {aiassignment_submissions} s
     JOIN {aiassignment} a ON s.assignment=a.id
     WHERE a.course=:c AND s.score IS NOT NULL",
    ['c' => $courseid]
);
foreach ($all_scores as $r) {
    $sc = (float)$r->score;
    if ($sc >= 90)      $dist['90-100']++;
    elseif ($sc >= 80)  $dist['80-89']++;
    elseif ($sc >= 70)  $dist['70-79']++;
    elseif ($sc >= 60)  $dist['60-69']++;
    else                $dist['<60']++;
}
$total_eval = array_sum($dist);
$pass_rate  = $total_eval > 0 ? round(($dist['90-100'] + $dist['80-89'] + $dist['70-79']) / $total_eval * 100, 1) : 0;

// ── Exportar CSV ──────────────────────────────────────────────
if ($format === 'csv') {
    header('Content-Type: text/csv; charset=utf-8');
    header('Content-Disposition: attachment; filename="reporte_' . clean_filename($course->shortname) . '_' . date('Ymd') . '.csv"');
    $out = fopen('php://output', 'w');
    fprintf($out, chr(0xEF).chr(0xBB).chr(0xBF));
    fputcsv($out, ['Reporte del Curso: ' . $course->fullname]);
    fputcsv($out, ['Generado:', date('d/m/Y H:i')]);
    fputcsv($out, []);
    fputcsv($out, ['RESUMEN GENERAL']);
    fputcsv($out, ['Total de tareas', count($assignments)]);
    fputcsv($out, ['Total de envíos', $stats->total_submissions]);
    fputcsv($out, ['Estudiantes activos', $stats->active_students]);
    fputcsv($out, ['Promedio general', number_format($stats->average_grade, 2) . '%']);
    fputcsv($out, ['Tasa de aprobación (≥70%)', $pass_rate . '%']);
    fputcsv($out, ['Alertas de plagio (≥75%)', $plag_count]);
    fputcsv($out, []);
    fputcsv($out, ['DISTRIBUCIÓN DE CALIFICACIONES']);
    fputcsv($out, ['Rango', 'Cantidad', 'Porcentaje']);
    foreach ($dist as $range => $count) {
        $pct = $total_eval > 0 ? round($count / $total_eval * 100, 1) : 0;
        fputcsv($out, [$range, $count, $pct . '%']);
    }
    fputcsv($out, []);
    fputcsv($out, ['DETALLE POR TAREA']);
    fputcsv($out, ['Tarea', 'Tipo', 'Envíos', 'Promedio']);
    $aoverview = aiassignment_get_assignments_overview($courseid);
    foreach ($aoverview as $a) {
        fputcsv($out, [
            $a->name, $a->type, $a->submission_count,
            $a->avg_grade !== null ? number_format($a->avg_grade, 2) . '%' : 'Sin datos'
        ]);
    }
    fclose($out);
    exit;
}

// ── Vista HTML ────────────────────────────────────────────────
$PAGE->set_url('/mod/aiassignment/course_report.php', ['courseid' => $courseid]);
$PAGE->set_title('Reporte — ' . format_string($course->fullname));
$PAGE->set_heading(format_string($course->fullname));
$PAGE->set_context($context);
$PAGE->set_pagelayout('incourse');
$PAGE->requires->css('/mod/aiassignment/styles/dashboard.css');

echo $OUTPUT->header();
echo html_writer::start_div('aiassignment-dashboard');
echo html_writer::tag('h2', '📊 Reporte del Curso — ' . format_string($course->fullname), ['class' => 'dashboard-title']);

// Botones exportar
$csv_url  = new moodle_url('/mod/aiassignment/course_report.php', ['courseid' => $courseid, 'format' => 'csv']);
$back_url = new moodle_url('/mod/aiassignment/dashboard.php', ['courseid' => $courseid]);
echo html_writer::start_div('', ['style' => 'display:flex;gap:10px;margin-bottom:20px;']);
echo html_writer::link($csv_url, '⬇️ Exportar CSV', ['class' => 'btn btn-success']);
echo html_writer::tag('button', '🖨️ Imprimir / PDF', ['class' => 'btn btn-secondary', 'onclick' => 'window.print()', 'type' => 'button']);
echo html_writer::link($back_url, '← Dashboard', ['class' => 'btn btn-secondary']);
echo html_writer::end_div();

// Tarjetas resumen
echo html_writer::start_div('stats-cards-container', ['style' => 'grid-template-columns:repeat(3,1fr);']);
$cards = [
    ['num' => count($assignments), 'label' => 'Total de Tareas', 'cls' => 'stat-card-primary'],
    ['num' => $stats->total_submissions, 'label' => 'Total de Envíos', 'cls' => 'stat-card-info'],
    ['num' => $stats->active_students, 'label' => 'Estudiantes Activos', 'cls' => 'stat-card-success'],
    ['num' => number_format($stats->average_grade, 1) . '%', 'label' => 'Promedio General', 'cls' => 'stat-card-success'],
    ['num' => $pass_rate . '%', 'label' => 'Tasa de Aprobación', 'cls' => 'stat-card-info'],
    ['num' => $plag_count, 'label' => 'Alertas de Plagio', 'cls' => $plag_count > 0 ? 'stat-card-danger' : 'stat-card-ok'],
];
foreach ($cards as $c) {
    echo html_writer::start_div('stat-card ' . $c['cls']);
    echo html_writer::tag('div', $c['num'], ['class' => 'stat-number']);
    echo html_writer::tag('div', $c['label'], ['class' => 'stat-label']);
    echo html_writer::end_div();
}
echo html_writer::end_div();

// Distribución
echo html_writer::start_div('dashboard-section', ['style' => 'margin-bottom:20px;']);
echo html_writer::tag('h3', '📊 Distribución de Calificaciones', ['class' => 'section-title']);
echo '<canvas id="reportChart" height="120"></canvas>';
$labels_j = json_encode(array_keys($dist));
$data_j   = json_encode(array_values($dist));
echo "<script>
(function() {
    function build() {
        new Chart(document.getElementById('reportChart'), {
            type: 'bar',
            data: { labels: {$labels_j}, datasets: [{ data: {$data_j},
                backgroundColor: ['#28a745','#17a2b8','#ffc107','#fd7e14','#dc3545'],
                borderRadius: 8 }] },
            options: { responsive: true, plugins: { legend: { display: false } },
                scales: { y: { beginAtZero: true, ticks: { stepSize: 1 },
                    title: { display: true, text: 'Nº alumnos' } } } }
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

// Tabla por tarea
echo html_writer::start_div('dashboard-section');
echo html_writer::tag('h3', '📋 Detalle por Tarea', ['class' => 'section-title']);
$aoverview = aiassignment_get_assignments_overview($courseid);
echo html_writer::start_tag('table', ['class' => 'submissions-table']);
echo html_writer::tag('thead', html_writer::tag('tr',
    html_writer::tag('th', 'Tarea') . html_writer::tag('th', 'Tipo') .
    html_writer::tag('th', 'Envíos') . html_writer::tag('th', 'Promedio')
));
echo html_writer::start_tag('tbody');
foreach ($aoverview as $a) {
    $grade = $a->avg_grade !== null
        ? html_writer::tag('span', number_format($a->avg_grade, 1) . '%',
            ['class' => 'grade-badge ' . aiassignment_get_grade_class($a->avg_grade)])
        : '—';
    echo html_writer::tag('tr',
        html_writer::tag('td', s($a->name)) .
        html_writer::tag('td', $a->type === 'programming' ? '💻 Programación' : '📐 Matemáticas') .
        html_writer::tag('td', $a->submission_count, ['class' => 'text-center']) .
        html_writer::tag('td', $grade, ['class' => 'text-center'])
    );
}
echo html_writer::end_tag('tbody');
echo html_writer::end_tag('table');
echo html_writer::end_div();

echo html_writer::end_div();
echo $OUTPUT->footer();
