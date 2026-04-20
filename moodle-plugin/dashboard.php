<?php
// This file is part of Moodle - http://moodle.org/

require_once('../../config.php');
require_once($CFG->dirroot . '/mod/aiassignment/lib.php');

$courseid  = required_param('courseid', PARAM_INT);
$filteraid = optional_param('aid', 0, PARAM_INT);

$course = $DB->get_record('course', ['id' => $courseid], '*', MUST_EXIST);
require_login($course);
$context = context_course::instance($course->id);
require_capability('mod/aiassignment:grade', $context);

$PAGE->set_url('/mod/aiassignment/dashboard.php', ['courseid' => $courseid]);
$PAGE->set_title('Dashboard — ' . format_string($course->fullname));
$PAGE->set_heading(format_string($course->fullname));
$PAGE->set_context($context);
$PAGE->set_pagelayout('incourse');
$PAGE->requires->css('/mod/aiassignment/styles/dashboard.css');

// ── Datos ─────────────────────────────────────────────────────
$aiassignments    = $DB->get_records('aiassignment', ['course' => $courseid]);
$stats            = aiassignment_get_course_statistics($courseid);
$plagiarism_high  = aiassignment_get_plagiarism_alert_count($courseid);
$recent_subs      = aiassignment_get_course_recent_submissions_optimized($courseid, 15, $filteraid);
$student_perf     = aiassignment_get_course_student_performance($courseid);
$assignment_stats = aiassignment_get_assignments_overview($courseid);
$high_risk        = aiassignment_get_high_risk_students($courseid);
$activity7days    = aiassignment_get_activity_last7days($courseid);

// Distribución de calificaciones — query directa, sin cargar todos los envíos
$grade_dist = ['90-100' => 0, '80-89' => 0, '70-79' => 0, '60-69' => 0, '<60' => 0];
$dist_sql = "SELECT
    SUM(CASE WHEN s.score >= 90 THEN 1 ELSE 0 END) AS g90,
    SUM(CASE WHEN s.score >= 80 AND s.score < 90 THEN 1 ELSE 0 END) AS g80,
    SUM(CASE WHEN s.score >= 70 AND s.score < 80 THEN 1 ELSE 0 END) AS g70,
    SUM(CASE WHEN s.score >= 60 AND s.score < 70 THEN 1 ELSE 0 END) AS g60,
    SUM(CASE WHEN s.score < 60 THEN 1 ELSE 0 END) AS glow
FROM {aiassignment_submissions} s
JOIN {aiassignment} a ON s.assignment = a.id
WHERE a.course = :courseid AND s.score IS NOT NULL";
$dist_row = $DB->get_record_sql($dist_sql, ['courseid' => $courseid]);
if ($dist_row) {
    $grade_dist['90-100'] = (int)$dist_row->g90;
    $grade_dist['80-89']  = (int)$dist_row->g80;
    $grade_dist['70-79']  = (int)$dist_row->g70;
    $grade_dist['60-69']  = (int)$dist_row->g60;
    $grade_dist['<60']    = (int)$dist_row->glow;
}

echo $OUTPUT->header();

echo html_writer::start_div('aiassignment-dashboard');

// ── Título ────────────────────────────────────────────────────
echo html_writer::tag('h2',
    '🤖 ' . get_string('dashboard', 'mod_aiassignment') . ' — ' . format_string($course->fullname),
    ['class' => 'dashboard-title']);

// ── Botón exportar PDF (Mejora 3) ─────────────────────────────
echo html_writer::start_div('', ['style' => 'text-align:right; margin-bottom:16px; display:flex; gap:8px; justify-content:flex-end; align-items:center;']);
$report_url  = new moodle_url('/mod/aiassignment/course_report.php', ['courseid' => $courseid]);
$thesis_url  = new moodle_url('/mod/aiassignment/thesis_results.php', ['courseid' => $courseid]);
echo html_writer::link($thesis_url, '🎓 Resultados Tesis', ['class' => 'btn btn-success btn-sm no-print']);
echo html_writer::link($report_url, '📊 Reporte del Curso', ['class' => 'btn btn-info btn-sm no-print']);
echo html_writer::tag('button', '🔄 Actualizar',
    ['class' => 'btn btn-secondary btn-sm no-print',
     'onclick' => 'window.location.reload()',
     'title' => 'Recargar el dashboard para ver datos actualizados',
     'type' => 'button']);
echo html_writer::tag('button', '📄 Exportar PDF',
    ['class' => 'btn btn-secondary btn-sm no-print', 'onclick' => 'window.print()', 'type' => 'button']);
echo html_writer::end_div();

// ── TARJETAS ──────────────────────────────────────────────────
echo html_writer::start_div('stats-cards-container');

// 1. Total tareas
echo html_writer::start_div('stat-card stat-card-primary');
echo html_writer::tag('div', count($aiassignments), ['class' => 'stat-number']);
echo html_writer::tag('div', 'Total de Tareas', ['class' => 'stat-label']);
echo html_writer::tag('i', '', ['class' => 'stat-icon fa fa-tasks']);
echo html_writer::end_div();

// 2. Promedio
echo html_writer::start_div('stat-card stat-card-success');
echo html_writer::tag('div', number_format($stats->average_grade, 1) . '%', ['class' => 'stat-number']);
echo html_writer::tag('div', 'Promedio General', ['class' => 'stat-label']);
echo html_writer::tag('i', '', ['class' => 'stat-icon fa fa-star']);
echo html_writer::end_div();

// 3. Estudiantes activos
echo html_writer::start_div('stat-card stat-card-info');
echo html_writer::tag('div', $stats->active_students, ['class' => 'stat-number']);
echo html_writer::tag('div', 'Estudiantes Activos', ['class' => 'stat-label']);
echo html_writer::tag('i', '', ['class' => 'stat-icon fa fa-users']);
echo html_writer::end_div();

// 4. Pendientes
echo html_writer::start_div('stat-card stat-card-warning');
echo html_writer::tag('div', $stats->pending_evaluations, ['class' => 'stat-number']);
echo html_writer::tag('div', 'Evaluaciones Pendientes', ['class' => 'stat-label']);
echo html_writer::tag('i', '', ['class' => 'stat-icon fa fa-clock-o']);
echo html_writer::end_div();

// 5. Alertas de plagio — clickeable con enlace al reporte
$plag_class = $plagiarism_high > 0 ? 'stat-card stat-card-danger' : 'stat-card stat-card-ok';
// Buscar el cm del primer assignment para el enlace
$first_cm = null;
if (!empty($aiassignments)) {
    $first_a  = reset($aiassignments);
    $first_cm = get_coursemodule_from_instance('aiassignment', $first_a->id);
}
$plag_url = $first_cm
    ? (new moodle_url('/mod/aiassignment/plagiarism_report.php', ['id' => $first_cm->id, 'analyze' => 1, 'nosem' => 1]))->out(false)
    : '#';

echo html_writer::start_div($plag_class . ' stat-card-clickable',
    ['onclick' => "window.location='{$plag_url}'", 'style' => 'cursor:pointer;']);
echo html_writer::tag('div', $plagiarism_high, ['class' => 'stat-number']);
echo html_writer::tag('div', '🔍 Alertas de Plagio', ['class' => 'stat-label']);
echo html_writer::tag('a', 'Ver reporte →', ['href' => $plag_url, 'class' => 'stat-card-link']);
echo html_writer::end_div();

echo html_writer::end_div(); // stats-cards-container

// ── Banner de alerta si hay plagio ────────────────────────────
if ($plagiarism_high > 0) {
    echo html_writer::start_div('plagio-alert-banner');
    echo html_writer::tag('span', '🚨', ['class' => 'alert-icon']);
    echo html_writer::start_div('alert-text');
    echo html_writer::tag('strong', $plagiarism_high . ' alumno' . ($plagiarism_high > 1 ? 's' : '') .
        ' con similitud ≥ 75% detectada');
    echo html_writer::tag('span', ' Se recomienda revisar el reporte antes de publicar calificaciones. ');
    echo html_writer::link($plag_url, 'Ver reporte completo →', ['style' => 'color:#721c24;font-weight:700;']);
    echo html_writer::end_div();
    echo html_writer::end_div();
}

// ── Layout principal ──────────────────────────────────────────
echo html_writer::start_div('dashboard-content');
echo html_writer::start_div('dashboard-column dashboard-left');

// ── Tabla de tareas ───────────────────────────────────────────
echo html_writer::start_div('dashboard-section');
echo html_writer::tag('h3', '📋 Resumen de Tareas', ['class' => 'section-title']);

if (!empty($assignment_stats)) {
    echo html_writer::start_tag('table', ['class' => 'submissions-table']);
    echo html_writer::tag('thead', html_writer::tag('tr',
        html_writer::tag('th', 'Nombre de la Tarea') .
        html_writer::tag('th', 'Tipo') .
        html_writer::tag('th', 'Envíos') .
        html_writer::tag('th', 'Promedio') .
        html_writer::tag('th', 'Acciones')
    ));
    echo html_writer::start_tag('tbody');
    foreach ($assignment_stats as $stat) {
        $cm       = get_coursemodule_from_instance('aiassignment', $stat->id);
        $view_url = new moodle_url('/mod/aiassignment/view.php', ['id' => $cm->id]);
        $subs_url = new moodle_url('/mod/aiassignment/submissions.php', ['id' => $cm->id]);
        $plag_url2= new moodle_url('/mod/aiassignment/plagiarism_report.php', ['id' => $cm->id, 'analyze' => 1, 'nosem' => 1]);

        $type_badge = html_writer::tag('span',
            $stat->type === 'programming' ? '💻 Programación' : '📐 Matemáticas',
            ['class' => 'badge ' . ($stat->type === 'programming' ? 'badge-teal' : 'badge-amber')]);

        $grade_cell = $stat->avg_grade !== null
            ? html_writer::tag('span', number_format($stat->avg_grade, 1) . '%',
                ['class' => 'grade-badge ' . aiassignment_get_grade_class($stat->avg_grade)])
            : html_writer::tag('span', 'Sin datos', ['style' => 'color:#999;']);

        echo html_writer::tag('tr',
            html_writer::tag('td', html_writer::link($view_url, format_string($stat->name),
                ['style' => 'font-weight:600;color:#1a73e8;'])) .
            html_writer::tag('td', $type_badge) .
            html_writer::tag('td', html_writer::tag('strong', $stat->submission_count),
                ['class' => 'text-center']) .
            html_writer::tag('td', $grade_cell, ['class' => 'text-center']) .
            html_writer::tag('td',
                html_writer::link($subs_url, 'Ver envíos', ['class' => 'btn btn-sm btn-primary']) . ' ' .
                html_writer::link($plag_url2, '🔍 Plagio', ['class' => 'btn btn-sm btn-danger']),
                ['class' => 'text-center'])
        );
    }
    echo html_writer::end_tag('tbody');
    echo html_writer::end_tag('table');
} else {
    echo html_writer::tag('p', 'No hay tareas en este curso aún.', ['class' => 'alert alert-info']);
}
echo html_writer::end_div();

// ── Envíos recientes ──────────────────────────────────────────
echo html_writer::start_div('dashboard-section');
echo html_writer::tag('h3', '🕐 Envíos Recientes', ['class' => 'section-title']);

// Filtro por tarea
if (!empty($aiassignments)) {
    echo html_writer::start_tag('form', ['method' => 'get', 'style' => 'margin-bottom:14px;display:flex;align-items:center;gap:10px;']);
    echo html_writer::empty_tag('input', ['type' => 'hidden', 'name' => 'courseid', 'value' => $courseid]);
    echo html_writer::tag('label', 'Filtrar por tarea:', ['style' => 'font-size:13px;color:#666;font-weight:600;']);
    echo html_writer::start_tag('select', ['name' => 'aid', 'onchange' => 'this.form.submit()',
        'style' => 'padding:7px 12px;border-radius:8px;border:1px solid #dee2e6;font-size:13px;background:#f8f9fa;']);
    echo html_writer::tag('option', 'Todas las tareas', ['value' => '0', ($filteraid == 0 ? 'selected' : 'x') => '']);
    foreach ($aiassignments as $a) {
        $attrs = ['value' => $a->id];
        if ($filteraid == $a->id) $attrs['selected'] = 'selected';
        echo html_writer::tag('option', format_string($a->name), $attrs);
    }
    echo html_writer::end_tag('select');
    echo html_writer::end_tag('form');
}

if (!empty($recent_subs)) {
    echo html_writer::start_tag('table', ['class' => 'submissions-table']);
    echo html_writer::tag('thead', html_writer::tag('tr',
        html_writer::tag('th', 'Tarea') .
        html_writer::tag('th', 'Estudiante') .
        html_writer::tag('th', 'Enviado') .
        html_writer::tag('th', 'Calificación') .
        html_writer::tag('th', '🔍 Plagio') .
        html_writer::tag('th', 'Acciones')
    ));
    echo html_writer::start_tag('tbody');

    foreach ($recent_subs as $sub) {
        // Calificación real (score de la submission)
        $score_cell = ($sub->score !== null)
            ? html_writer::tag('span', number_format($sub->score, 1) . '%',
                ['class' => 'grade-badge ' . aiassignment_get_grade_class($sub->score)])
            : html_writer::tag('span', 'Pendiente', ['class' => 'badge badge-warning']);

        // Plagio con color rojo/amarillo/verde
        if ($sub->similarity_score !== null) {
            $pc  = round($sub->similarity_score, 1);
            $cls = $pc >= 75 ? 'plag-high' : ($pc >= 50 ? 'plag-medium' : 'plag-low');
            $plagio_cell = html_writer::tag('span', $pc . '%', ['class' => $cls]);
        } else {
            $plagio_cell = html_writer::tag('span', '—', ['style' => 'color:#bbb;']);
        }

        // Tiempo relativo con tooltip
        $time_cell = html_writer::tag('span', aiassignment_time_ago($sub->timecreated),
            ['class' => 'time-rel', 'title' => userdate($sub->timecreated)]);

        // Avatar con iniciales
        $initials = mb_strtoupper(mb_substr($sub->firstname, 0, 1) . mb_substr($sub->lastname, 0, 1));
        $avatar   = html_writer::tag('span', $initials, ['class' => 'avatar-initials']);

        $userobj = (object)['id' => $sub->userid, 'firstname' => $sub->firstname,
            'lastname' => $sub->lastname, 'picture' => $sub->picture,
            'imagealt' => $sub->imagealt, 'email' => $sub->email];

        $view_url = new moodle_url('/mod/aiassignment/submission.php', ['id' => $sub->id]);

        echo html_writer::tag('tr',
            html_writer::tag('td', format_string($sub->assignment_name),
                ['style' => 'font-size:12px;color:#666;']) .
            html_writer::tag('td',
                html_writer::tag('div', $avatar . ' ' . fullname($userobj), ['class' => 'student-cell'])) .
            html_writer::tag('td', $time_cell) .
            html_writer::tag('td', $score_cell, ['class' => 'text-center']) .
            html_writer::tag('td', $plagio_cell, ['class' => 'text-center']) .
            html_writer::tag('td',
                html_writer::link($view_url, 'Ver', ['class' => 'btn btn-sm btn-primary']),
                ['class' => 'text-center'])
        );
    }
    echo html_writer::end_tag('tbody');
    echo html_writer::end_tag('table');
} else {
    echo html_writer::tag('p', 'No hay envíos aún.', ['class' => 'alert alert-info']);
}
echo html_writer::end_div();
echo html_writer::end_div(); // dashboard-left

// ── Columna derecha ───────────────────────────────────────────
echo html_writer::start_div('dashboard-column dashboard-right');

// Top performers primero (contenido real, sin espacio en blanco)
echo html_writer::start_div('dashboard-section');
echo html_writer::tag('h3', '🏆 Top Estudiantes', ['class' => 'section-title']);

if (!empty($student_perf)) {
    echo html_writer::start_div('performers-list');
    $rank = 1;
    foreach (array_slice((array)$student_perf, 0, 8) as $perf) {
        // Datos del usuario ya vienen en el JOIN — sin query adicional
        $grade_cls   = aiassignment_get_grade_class($perf->avg_grade);
        $profile_url = new moodle_url('/mod/aiassignment/student_stats.php',
            ['userid' => $perf->userid, 'courseid' => $courseid]);
        $initials    = mb_strtoupper(
            mb_substr($perf->firstname, 0, 1) . mb_substr($perf->lastname, 0, 1)
        );
        $fullname    = trim($perf->firstname . ' ' . $perf->lastname);
        $rank_class  = 'rank-badge' . ($rank <= 3 ? ' rank-badge-top rank-' . $rank : '');

        echo html_writer::start_div('performer-item');
        echo html_writer::tag('div', $rank, ['class' => $rank_class]);
        echo html_writer::start_div('performer-info');
        echo html_writer::tag('div', $initials, ['class' => 'avatar-initials avatar-sm']);
        echo html_writer::start_div('');
        echo html_writer::tag('div',
            html_writer::link($profile_url, s($fullname),
                ['style' => 'color:#333;text-decoration:none;font-weight:600;']),
            ['class' => 'performer-name']);
        echo html_writer::tag('div',
            $perf->submission_count . ' envío' . ($perf->submission_count > 1 ? 's' : ''),
            ['class' => 'performer-submissions']);
        echo html_writer::end_div();
        echo html_writer::end_div();
        echo html_writer::tag('div', number_format($perf->avg_grade, 1) . '%',
            ['class' => 'performer-grade ' . $grade_cls]);
        echo html_writer::end_div();
        $rank++;
    }
    echo html_writer::end_div();
} else {
    echo html_writer::tag('p', 'Sin datos aún.', ['class' => 'alert alert-info']);
}
echo html_writer::end_div();

// ── Alumnos en Riesgo (Mejora 2) ─────────────────────────────
echo html_writer::start_div('dashboard-section');
echo html_writer::tag('h3', '🚨 Alumnos en Riesgo', ['class' => 'section-title']);
if (!empty($high_risk)) {
    echo html_writer::start_tag('table', ['class' => 'submissions-table']);
    echo html_writer::tag('thead', html_writer::tag('tr',
        html_writer::tag('th', 'Alumno') .
        html_writer::tag('th', 'Tarea') .
        html_writer::tag('th', 'Plagio') .
        html_writer::tag('th', 'Acción')
    ));
    echo html_writer::start_tag('tbody');
    foreach ($high_risk as $hr) {
        $initials_hr = mb_strtoupper(mb_substr($hr->firstname, 0, 1) . mb_substr($hr->lastname, 0, 1));
        $avatar_hr   = html_writer::tag('span', $initials_hr, ['class' => 'avatar-initials']);
        $profile_hr  = new moodle_url('/user/view.php', ['id' => $hr->id, 'course' => $courseid]);
        $sub_url_hr  = new moodle_url('/mod/aiassignment/submission.php', ['id' => $hr->submission_id]);
        $pct_hr      = round($hr->max_plag, 1);
        echo html_writer::tag('tr',
            html_writer::tag('td',
                html_writer::tag('div',
                    $avatar_hr . ' ' . html_writer::link($profile_hr,
                        s($hr->firstname . ' ' . $hr->lastname),
                        ['style' => 'color:#333;font-weight:600;text-decoration:none;']),
                    ['class' => 'student-cell'])) .
            html_writer::tag('td', s($hr->assignment_name), ['style' => 'font-size:12px;color:#666;']) .
            html_writer::tag('td',
                html_writer::tag('span', $pct_hr . '%',
                    ['style' => 'color:#dc3545;font-weight:700;']),
                ['class' => 'text-center']) .
            html_writer::tag('td',
                html_writer::link($sub_url_hr, 'Ver envío', ['class' => 'btn btn-sm btn-danger']),
                ['class' => 'text-center'])
        );
    }
    echo html_writer::end_tag('tbody');
    echo html_writer::end_tag('table');
} else {
    echo html_writer::tag('p', 'No hay alumnos en riesgo.', ['class' => 'alert alert-info']);
}
echo html_writer::end_div();

// ── Mini gráfica de actividad últimos 7 días (Mejora 1) ───────
echo html_writer::start_div('dashboard-section');
echo html_writer::tag('h3', '📈 Actividad — Últimos 7 días', ['class' => 'section-title']);
echo '<div style="position:relative; height:160px;"><canvas id="activityChart"></canvas></div>';
echo html_writer::end_div();

// Gráfica distribución de calificaciones — después del contenido real
$has_grade_data = array_sum($grade_dist) > 0;
echo html_writer::start_div('dashboard-section');
echo html_writer::tag('h3', '📊 Distribución de Calificaciones', ['class' => 'section-title']);
if ($has_grade_data) {
    echo '<div style="position:relative; height:200px;"><canvas id="gradeChart"></canvas></div>';
} else {
    echo html_writer::tag('p', 'Sin calificaciones aún.', ['class' => 'alert alert-info', 'style' => 'font-size:13px;']);
}
echo html_writer::end_div();

// ── Correlación Plagio vs Calificación ────────────────────────
$corr_raw = aiassignment_get_plagiarism_vs_grade($courseid);
$corr_pts = [];
foreach ($corr_raw as $r) {
    $x = (float)$r->similarity_score;
    $y = (float)$r->score;
    $color = $x >= 75 ? 'rgba(220,53,69,0.8)' : ($x >= 50 ? 'rgba(255,193,7,0.9)' : 'rgba(40,167,69,0.8)');
    $corr_pts[] = ['x' => $x, 'y' => $y, 'color' => $color];
}

echo html_writer::start_div('dashboard-section');
echo html_writer::tag('h3', '🔗 Correlación Plagio vs Calificación', ['class' => 'section-title']);
if (!empty($corr_pts)) {
    echo '<div style="position:relative; height:200px;"><canvas id="correlationChart"></canvas></div>';
    echo html_writer::tag('p',
        '🔴 Plagio alto  🟡 Sospechoso  🟢 Original',
        ['style' => 'font-size:11px; color:#888; text-align:center; margin-top:6px;']);
} else {
    echo html_writer::tag('p',
        'Sin datos. Ejecuta el análisis de plagio para ver esta gráfica.',
        ['class' => 'alert alert-info', 'style' => 'font-size:13px;']);
}
echo html_writer::end_div();

// ── Precisión del Detector (Mejora 1) ────────────────────────
$accuracy = aiassignment_get_plagiarism_accuracy($courseid);
$total_reviewed = $accuracy['confirmed'] + $accuracy['false_positive'];
$precision = $total_reviewed > 0 ? round($accuracy['confirmed'] / $total_reviewed * 100, 1) : null;

echo html_writer::start_div('dashboard-section');
echo html_writer::tag('h3', '🎯 Precisión del Detector', ['class' => 'section-title']);
if ($total_reviewed > 0) {
    echo '<div style="position:relative;height:160px;"><canvas id="accuracyChart"></canvas></div>';
    echo html_writer::tag('p',
        'Basado en ' . $total_reviewed . ' caso(s) revisados por el profesor. ' .
        'Precisión: ' . html_writer::tag('strong', $precision . '%',
            ['style' => 'color:' . ($precision >= 70 ? '#28a745' : '#dc3545') . ';']),
        ['style' => 'font-size:12px;color:#666;text-align:center;margin-top:8px;']);
} else {
    echo html_writer::tag('p',
        'Sin casos revisados aún. Confirma o descarta casos de plagio en el reporte para ver la precisión.',
        ['class' => 'alert alert-info', 'style' => 'font-size:13px;']);
}
echo html_writer::end_div();

echo html_writer::end_div(); // dashboard-right
echo html_writer::end_div(); // dashboard-content
echo html_writer::end_div(); // aiassignment-dashboard

// ── Script unificado: carga Chart.js UNA vez y construye todas las gráficas ──
$chart_labels = json_encode(array_keys($grade_dist));
$chart_data   = json_encode(array_values($grade_dist));
$act_labels   = json_encode(array_column($activity7days, 'label'));
$act_data     = json_encode(array_column($activity7days, 'count'));
$corr_json    = json_encode($corr_pts);
$acc_confirmed = json_encode($accuracy['confirmed']);
$acc_false_pos = json_encode($accuracy['false_positive']);
$acc_pending   = json_encode($accuracy['pending']);

echo "
<script>
(function() {
    function buildAllCharts() {
        // ── Gráfica 1: Distribución de calificaciones ──
        var gradeEl = document.getElementById('gradeChart');
        if (gradeEl) {
            new Chart(gradeEl, {
                type: 'bar',
                data: {
                    labels: {$chart_labels},
                    datasets: [{
                        data: {$chart_data},
                        backgroundColor: ['#28a745','#17a2b8','#ffc107','#fd7e14','#dc3545'],
                        borderRadius: 8,
                        borderSkipped: false
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: false },
                        tooltip: { callbacks: {
                            label: function(ctx) {
                                return ' ' + ctx.raw + ' alumno' + (ctx.raw !== 1 ? 's' : '');
                            }
                        }}
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: { stepSize: 1, font: { size: 11 } },
                            title: { display: true, text: 'Nº de alumnos', font: { size: 11 } }
                        },
                        x: { ticks: { font: { size: 12 } } }
                    }
                }
            });
        }

        // ── Gráfica 2: Actividad últimos 7 días ──
        var actEl = document.getElementById('activityChart');
        if (actEl) {
            new Chart(actEl, {
                type: 'line',
                data: {
                    labels: {$act_labels},
                    datasets: [{
                        label: 'Envíos',
                        data: {$act_data},
                        borderColor: '#2563eb',
                        backgroundColor: 'rgba(37,99,235,0.1)',
                        borderWidth: 2,
                        pointBackgroundColor: '#2563eb',
                        pointRadius: 4,
                        fill: true,
                        tension: 0.3
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { display: false } },
                    scales: {
                        y: { beginAtZero: true, ticks: { stepSize: 1, font: { size: 11 } } },
                        x: { ticks: { font: { size: 11 } } }
                    }
                }
            });
        }

        // ── Gráfica 3: Correlación plagio vs calificación ──
        var corrEl = document.getElementById('correlationChart');
        if (corrEl) {
            var raw = {$corr_json};
            var datasets = raw.map(function(p) {
                return {
                    data: [{x: p.x, y: p.y}],
                    backgroundColor: p.color,
                    pointRadius: 7,
                    pointHoverRadius: 9
                };
            });
            new Chart(corrEl, {
                type: 'scatter',
                data: { datasets: datasets },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: false },
                        tooltip: { callbacks: {
                            label: function(ctx) {
                                return 'Plagio: ' + ctx.parsed.x + '% | Nota: ' + ctx.parsed.y + '%';
                            }
                        }}
                    },
                    scales: {
                        x: {
                            title: { display: true, text: 'Similitud / Plagio (%)', font: { size: 11 } },
                            min: 0, max: 100
                        },
                        y: {
                            title: { display: true, text: 'Calificación (%)', font: { size: 11 } },
                            min: 0, max: 100
                        }
                    }
                }
            });
        }
        // ── Gráfica 4: Precisión del detector ──
        var accEl = document.getElementById('accuracyChart');
        if (accEl) {
            new Chart(accEl, {
                type: 'doughnut',
                data: {
                    labels: ['Plagio confirmado', 'Falso positivo', 'Sin revisar'],
                    datasets: [{
                        data: [{$acc_confirmed}, {$acc_false_pos}, {$acc_pending}],
                        backgroundColor: ['#dc3545', '#6c757d', '#dee2e6'],
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

    // Cargar Chart.js si no está disponible, luego construir todo
    if (typeof Chart === 'undefined') {
        var s = document.createElement('script');
        s.src = 'https://cdn.jsdelivr.net/npm/chart.js@4/dist/chart.umd.min.js';
        s.onload = buildAllCharts;
        document.head.appendChild(s);
    } else {
        buildAllCharts();
    }
})();
</script>
";

echo $OUTPUT->footer();
