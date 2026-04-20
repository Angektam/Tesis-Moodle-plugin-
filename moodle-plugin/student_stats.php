<?php
// This file is part of Moodle - http://moodle.org/

require_once('../../config.php');
require_once($CFG->dirroot . '/mod/aiassignment/lib.php');

$userid   = required_param('userid',   PARAM_INT);
$courseid = required_param('courseid', PARAM_INT);

$course = $DB->get_record('course', ['id' => $courseid], '*', MUST_EXIST);
$student = $DB->get_record('user', ['id' => $userid], '*', MUST_EXIST);

require_login($course);
$context = context_course::instance($course->id);
require_capability('mod/aiassignment:grade', $context);

$PAGE->set_url('/mod/aiassignment/student_stats.php', ['userid' => $userid, 'courseid' => $courseid]);
$PAGE->set_title('Estadísticas — ' . fullname($student));
$PAGE->set_heading(format_string($course->fullname));
$PAGE->set_context($context);
$PAGE->set_pagelayout('incourse');
$PAGE->requires->css('/mod/aiassignment/styles/dashboard.css');

// ── Obtener todos los envíos del alumno en el curso ───────────
$sql = "SELECT s.id, s.assignment, s.attempt, s.score, s.status, s.timecreated,
               a.name AS assignment_name,
               cm.id AS cmid,
               e.similarity_score
        FROM {aiassignment_submissions} s
        JOIN {aiassignment} a ON s.assignment = a.id
        JOIN {course_modules} cm ON cm.instance = a.id
        JOIN {modules} mo ON mo.id = cm.module AND mo.name = 'aiassignment'
        LEFT JOIN {aiassignment_evaluations} e ON e.submission = s.id
        WHERE a.course = :courseid AND s.userid = :userid
        ORDER BY s.timecreated ASC";

$submissions = $DB->get_records_sql($sql, ['courseid' => $courseid, 'userid' => $userid]);

// Estadísticas resumen
$total_subs  = count($submissions);
$scores      = array_filter(array_column((array)$submissions, 'score'), fn($v) => $v !== null);
$avg_grade   = $total_subs > 0 && !empty($scores) ? round(array_sum($scores) / count($scores), 2) : 0;

// Datos para gráfica
$chart_labels = [];
$chart_scores = [];
$attempt_num  = 1;
foreach ($submissions as $sub) {
    if ($sub->score !== null) {
        $chart_labels[] = 'Intento ' . $attempt_num;
        $chart_scores[] = round($sub->score, 2);
    }
    $attempt_num++;
}

echo $OUTPUT->header();

echo html_writer::start_div('aiassignment-dashboard');

// ── Cabecera del alumno ───────────────────────────────────────
$initials = mb_strtoupper(mb_substr($student->firstname, 0, 1) . mb_substr($student->lastname, 0, 1));
echo html_writer::start_div('', ['style' => 'display:flex; align-items:center; gap:16px; margin-bottom:24px;']);
echo html_writer::tag('div', $initials, [
    'style' => 'width:64px; height:64px; border-radius:50%; background:linear-gradient(135deg,#2563eb,#1d4ed8);
                color:#fff; font-size:22px; font-weight:700; display:flex; align-items:center;
                justify-content:center; flex-shrink:0; box-shadow:0 2px 8px rgba(37,99,235,.3);'
]);
echo html_writer::start_div('');
echo html_writer::tag('h2', fullname($student), ['style' => 'margin:0 0 4px; font-size:22px; font-weight:700;']);
echo html_writer::tag('p', s($student->email), ['style' => 'margin:0; color:#6b7280; font-size:14px;']);
echo html_writer::end_div();
echo html_writer::end_div();

// ── Tarjetas resumen ──────────────────────────────────────────
echo html_writer::start_div('stats-cards-container', ['style' => 'grid-template-columns:repeat(3,1fr);']);

echo html_writer::start_div('stat-card stat-card-primary');
echo html_writer::tag('div', $total_subs, ['class' => 'stat-number']);
echo html_writer::tag('div', 'Total de Envíos', ['class' => 'stat-label']);
echo html_writer::end_div();

echo html_writer::start_div('stat-card stat-card-success');
echo html_writer::tag('div', $avg_grade . '%', ['class' => 'stat-number']);
echo html_writer::tag('div', 'Promedio de Calificaciones', ['class' => 'stat-label']);
echo html_writer::end_div();

$max_plag = 0;
foreach ($submissions as $sub) {
    if ($sub->similarity_score !== null && $sub->similarity_score > $max_plag) {
        $max_plag = $sub->similarity_score;
    }
}
$plag_class = $max_plag >= 75 ? 'stat-card-danger' : ($max_plag >= 50 ? 'stat-card-warning' : 'stat-card-ok');
echo html_writer::start_div('stat-card ' . $plag_class);
echo html_writer::tag('div', round($max_plag, 1) . '%', ['class' => 'stat-number']);
echo html_writer::tag('div', 'Plagio Máximo Detectado', ['class' => 'stat-label']);
echo html_writer::end_div();

echo html_writer::end_div(); // stats-cards-container

// ── Gráfica de evolución ──────────────────────────────────────
if (count($chart_scores) > 1) {
    echo html_writer::start_div('dashboard-section', ['style' => 'margin-bottom:20px;']);
    echo html_writer::tag('h3', '📈 Evolución de Calificaciones', ['class' => 'section-title']);
    echo '<canvas id="studentChart" height="120"></canvas>';
    $labels_json = json_encode($chart_labels);
    $scores_json = json_encode($chart_scores);
    echo "
<script>
(function waitStudentChart() {
    if (typeof Chart === 'undefined') {
        var s = document.createElement('script');
        s.src = 'https://cdn.jsdelivr.net/npm/chart.js@4/dist/chart.umd.min.js';
        s.onload = buildStudentChart;
        document.head.appendChild(s);
    } else { buildStudentChart(); }

    function buildStudentChart() {
        new Chart(document.getElementById('studentChart'), {
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
    echo html_writer::end_div();
}

// ── Tabla de envíos ───────────────────────────────────────────
echo html_writer::start_div('dashboard-section');
echo html_writer::tag('h3', '📋 Historial de Envíos', ['class' => 'section-title']);

if (!empty($submissions)) {
    echo html_writer::start_tag('table', ['class' => 'submissions-table']);
    echo html_writer::tag('thead', html_writer::tag('tr',
        html_writer::tag('th', 'Tarea') .
        html_writer::tag('th', 'Intento') .
        html_writer::tag('th', 'Fecha') .
        html_writer::tag('th', 'Calificación') .
        html_writer::tag('th', 'Plagio') .
        html_writer::tag('th', 'Estado') .
        html_writer::tag('th', 'Acción')
    ));
    echo html_writer::start_tag('tbody');

    foreach ($submissions as $sub) {
        $score_cell = ($sub->score !== null)
            ? html_writer::tag('span', number_format($sub->score, 1) . '%',
                ['class' => 'grade-badge ' . aiassignment_get_grade_class($sub->score)])
            : html_writer::tag('span', '—', ['style' => 'color:#bbb;']);

        if ($sub->similarity_score !== null) {
            $pc  = round($sub->similarity_score, 1);
            $cls = $pc >= 75 ? 'plag-high' : ($pc >= 50 ? 'plag-medium' : 'plag-low');
            $plag_cell = html_writer::tag('span', $pc . '%', ['class' => $cls]);
        } else {
            $plag_cell = html_writer::tag('span', '—', ['style' => 'color:#bbb;']);
        }

        $status_labels = [
            'submitted'  => html_writer::tag('span', 'Enviado',   ['class' => 'badge badge-warning']),
            'evaluated'  => html_writer::tag('span', 'Evaluado',  ['class' => 'badge badge-green']),
            'pending'    => html_writer::tag('span', 'Pendiente', ['class' => 'badge badge-secondary']),
        ];
        $status_cell = $status_labels[$sub->status] ?? html_writer::tag('span', s($sub->status), ['class' => 'badge']);

        $view_url = new moodle_url('/mod/aiassignment/submission.php', ['id' => $sub->id]);

        echo html_writer::tag('tr',
            html_writer::tag('td', s($sub->assignment_name), ['style' => 'font-size:12px;color:#666;']) .
            html_writer::tag('td', $sub->attempt, ['class' => 'text-center']) .
            html_writer::tag('td', userdate($sub->timecreated, get_string('strftimedatetimeshort', 'langconfig'))) .
            html_writer::tag('td', $score_cell, ['class' => 'text-center']) .
            html_writer::tag('td', $plag_cell,  ['class' => 'text-center']) .
            html_writer::tag('td', $status_cell, ['class' => 'text-center']) .
            html_writer::tag('td',
                html_writer::link($view_url, 'Ver', ['class' => 'btn btn-sm btn-primary']),
                ['class' => 'text-center'])
        );
    }

    echo html_writer::end_tag('tbody');
    echo html_writer::end_tag('table');
} else {
    echo html_writer::tag('p', 'Este alumno no tiene envíos en este curso.', ['class' => 'alert alert-info']);
}
echo html_writer::end_div();

// ── Botón volver ──────────────────────────────────────────────
$back_url = new moodle_url('/mod/aiassignment/dashboard.php', ['courseid' => $courseid]);
echo html_writer::div(
    html_writer::link($back_url, '← Volver al dashboard', ['class' => 'btn btn-secondary']),
    '', ['style' => 'margin-top:20px;']
);

echo html_writer::end_div(); // aiassignment-dashboard
echo $OUTPUT->footer();
