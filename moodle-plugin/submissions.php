<?php
// This file is part of Moodle - http://moodle.org/

require_once('../../config.php');
require_once($CFG->dirroot.'/mod/aiassignment/lib.php');

$id = required_param('id', PARAM_INT); // Course Module ID

$cm = get_coursemodule_from_id('aiassignment', $id, 0, false, MUST_EXIST);
$course = $DB->get_record('course', array('id' => $cm->course), '*', MUST_EXIST);
$aiassignment = $DB->get_record('aiassignment', array('id' => $cm->instance), '*', MUST_EXIST);

require_login($course, true, $cm);
$context = context_module::instance($cm->id);
require_capability('mod/aiassignment:grade', $context);

$PAGE->set_url('/mod/aiassignment/submissions.php', array('id' => $cm->id));
$PAGE->set_title(format_string($aiassignment->name));
$PAGE->set_heading(format_string($course->fullname));
$PAGE->set_context($context);

// ── Estilos inline para la sección de plagio ─────────────────────────────
$PAGE->requires->css('/mod/aiassignment/styles/dashboard.css');

echo $OUTPUT->header();
echo $OUTPUT->heading(get_string('allsubmissions', 'aiassignment'));

// ── Paginación real con LIMIT/OFFSET (no carga todo en memoria) ──────────
$perpage = 20;
$page    = optional_param('page', 0, PARAM_INT);

// Contar total sin traer registros
$total = $DB->count_records('aiassignment_submissions', ['assignment' => $aiassignment->id]);

if ($total === 0) {
    echo $OUTPUT->notification(get_string('nosubmissions', 'aiassignment'), 'info');
    echo $OUTPUT->continue_button(new moodle_url('/mod/aiassignment/view.php', ['id' => $cm->id]));
    echo $OUTPUT->footer();
    exit;
}

// Solo traer la página actual
$sql = "SELECT s.*, u.firstname, u.lastname, u.email
        FROM {aiassignment_submissions} s
        JOIN {user} u ON s.userid = u.id
        WHERE s.assignment = :assignment
        ORDER BY s.timecreated DESC";
$submissions_paged = $DB->get_records_sql($sql, ['assignment' => $aiassignment->id],
    $page * $perpage, $perpage);

// Para estadísticas y ranking de plagio solo necesitamos IDs/scores, no el contenido
$plagiarism_by_user = [];
try {
    $plagiarism_sql = "SELECT s.userid, MAX(e.similarity_score) as max_plagiarism
                       FROM {aiassignment_submissions} s
                       JOIN {aiassignment_evaluations} e ON e.submission = s.id
                       WHERE s.assignment = :assignment
                         AND e.similarity_score IS NOT NULL
                       GROUP BY s.userid";
    foreach ($DB->get_records_sql($plagiarism_sql, ['assignment' => $aiassignment->id]) as $rec) {
        $plagiarism_by_user[$rec->userid] = $rec->max_plagiarism;
    }
} catch (Exception $e) {
    // Sin datos de plagio aún
}

// ── Tabla de envíos ───────────────────────────────────────────────────────
$table = new html_table();
$table->attributes['class'] = 'generaltable mod_index';
$table->head = array(
    get_string('student', 'aiassignment'),
    get_string('submitted', 'aiassignment'),
    get_string('attempt', 'aiassignment'),
    get_string('status', 'aiassignment'),
    get_string('score', 'aiassignment'),
    '🔍 Plagio',
    get_string('actions', 'aiassignment')
);
$table->align = array('left', 'left', 'center', 'center', 'center', 'center', 'center');

foreach ($submissions_paged as $submission) {
    $student  = fullname($submission);
    $submitted = userdate($submission->timecreated);
    $attempt  = $submission->attempt;

    // Estado
    if ($submission->status == 'evaluated') {
        $status = html_writer::span(get_string('evaluated', 'aiassignment'), 'badge badge-success');
    } elseif ($submission->status == 'flagged') {
        $status = html_writer::span('📩 Re-envío solicitado', 'badge badge-warning');
    } else {
        $status = html_writer::span(get_string('pending', 'aiassignment'), 'badge badge-warning');
    }

    // Calificación
    $score = ($submission->score !== null) ? round($submission->score, 2) . '%' : '-';

    // Porcentaje de plagio — leer desde plagiarism_by_user (evaluaciones)
    $plagiarism_pct = '-';
    if (isset($plagiarism_by_user[$submission->userid])) {
        $pct = round($plagiarism_by_user[$submission->userid], 1);
        $color = ($pct >= 70) ? '#dc3545' : (($pct >= 40) ? '#856404' : '#155724');
        $plagiarism_pct = html_writer::tag('span',
            $pct . '%',
            array('style' => "font-weight:600; color:{$color};")
        );
    }

    // Acción: botón Ver funcional
    $view_url = new moodle_url('/mod/aiassignment/submission.php', array('id' => $submission->id));
    $actions = html_writer::link(
        $view_url,
        get_string('view'),
        array('class' => 'btn btn-sm btn-primary')
    );

    // Botón solicitar re-envío directo desde la lista — abre en nueva pestaña
    $resubmit_url = new moodle_url('/mod/aiassignment/request_resubmit.php',
        ['sid' => $submission->id, 'sesskey' => sesskey()]);
    $resubmit_btn = html_writer::link(
        $resubmit_url,
        '📩',
        ['class' => 'btn btn-sm btn-outline-danger',
         'title' => 'Solicitar re-envío',
         'target' => '_blank',
         'onclick' => "return confirm('¿Solicitar re-envío a " . s($student) . "?');"]
    );
    // Botón plagio abre en nueva pestaña
    $plag_btn_url = new moodle_url('/mod/aiassignment/plagiarism_report.php',
        ['id' => $cm->id, 'nosem' => 1]);
    $actions .= ' ' . $resubmit_btn;

    $table->data[] = array($student, $submitted, $attempt, $status, $score, $plagiarism_pct, $actions);
}

// Filtro de estado (Mejora 5)
$status_filter = optional_param('status_filter', '', PARAM_ALPHA);
echo html_writer::start_div('', ['style' => 'display:flex;gap:10px;margin-bottom:10px;align-items:center;flex-wrap:wrap;']);
echo html_writer::tag('label', 'Estado:', ['style' => 'font-size:13px;font-weight:600;color:#666;']);
$status_options = [
    ''          => 'Todos',
    'evaluated' => '✅ Evaluados',
    'pending'   => '⏳ Pendientes',
    'flagged'   => '📩 Re-envío solicitado',
];
$status_select = html_writer::start_tag('select', [
    'id' => 'status-filter',
    'style' => 'padding:7px 12px;border-radius:8px;border:1px solid #dee2e6;font-size:13px;',
    'onchange' => 'filterByStatus(this.value)'
]);
foreach ($status_options as $val => $label) {
    $attrs = ['value' => $val];
    if ($status_filter === $val) $attrs['selected'] = 'selected';
    $status_select .= html_writer::tag('option', $label, $attrs);
}
$status_select .= html_writer::end_tag('select');
echo $status_select;
echo html_writer::end_div();

echo html_writer::tag('input', '', [
    'type' => 'text',
    'id'   => 'search-submissions',
    'placeholder' => '🔍 Buscar por nombre de estudiante...',
    'style' => 'width:100%; padding:10px 14px; border-radius:8px; border:1px solid #dee2e6;
                font-size:14px; margin-bottom:4px; box-shadow:0 1px 3px rgba(0,0,0,.06);',
    'oninput' => "filterTable(this.value)"
]);
echo html_writer::tag('span', '', ['id' => 'search-counter', 'style' => 'font-size:12px;color:#888;margin-left:8px;display:block;margin-bottom:10px;']);

echo html_writer::table($table);

// Paginación
if ($total > $perpage) {
    $paging_url = new moodle_url('/mod/aiassignment/submissions.php', ['id' => $cm->id]);
    echo $OUTPUT->paging_bar($total, $page, $perpage, $paging_url);
}

// ── Estadísticas ──────────────────────────────────────────────────────────
echo $OUTPUT->box_start('generalbox statistics');
echo html_writer::tag('h3', get_string('statistics', 'aiassignment'));

$evaluated = $DB->count_records('aiassignment_submissions',
    array('assignment' => $aiassignment->id, 'status' => 'evaluated'));
$pending = $total - $evaluated;

$avg_sql = "SELECT AVG(score) as average
            FROM {aiassignment_submissions}
            WHERE assignment = :assignment AND status = 'evaluated'";
$average = $DB->get_record_sql($avg_sql, array('assignment' => $aiassignment->id));

echo html_writer::start_tag('ul');
echo html_writer::tag('li', get_string('totalsubmissions', 'aiassignment') . ': ' . $total);
echo html_writer::tag('li', get_string('evaluated', 'aiassignment') . ': ' . $evaluated);
echo html_writer::tag('li', get_string('pending', 'aiassignment') . ': <span style="color:#dc3545;font-weight:600;">' . $pending . '</span>');
if ($average->average !== null) {
    echo html_writer::tag('li', get_string('averagescore', 'aiassignment') . ': ' .
        round($average->average, 2) . '%');
}
echo html_writer::end_tag('ul');
echo $OUTPUT->box_end();

// ── Sección: Detección de Plagio ──────────────────────────────────────────
echo $OUTPUT->box_start('generalbox', 'plagiarism-section');
echo html_writer::tag('h3', '🔍 Reporte de Plagio', array('style' => 'margin-bottom:10px;'));
echo html_writer::tag('p',
    'Este análisis usa IA para comparar todos los envíos y detectar posible plagio. Analiza similitudes semánticas, estructurales y lógicas.',
    array('class' => 'alert alert-info')
);

$distinctusers = $DB->count_records_sql(
    "SELECT COUNT(DISTINCT userid) FROM {aiassignment_submissions} WHERE assignment = :a",
    array('a' => $aiassignment->id)
);

if ($distinctusers < 2) {
    echo html_writer::tag('p',
        html_writer::tag('em', 'Se necesitan envíos de al menos 2 estudiantes distintos para analizar plagio.'),
        array('class' => 'alert alert-warning')
    );
} else {
    $plagiarism_url = new moodle_url('/mod/aiassignment/plagiarism_report.php', array('id' => $cm->id, 'nosem' => 1));
    echo html_writer::link(
        $plagiarism_url,
        '🔍 Iniciar análisis de plagio',
        array('class' => 'btn btn-danger btn-lg')
    );
}
echo $OUTPUT->box_end();

// ── Ranking de alumnos por porcentaje de plagio (query directa, sin iterar submissions) ──
$ranking_sql = "SELECT u.id AS userid, u.firstname, u.lastname,
                       MAX(e.similarity_score) AS plagiarism
                FROM {aiassignment_submissions} s
                JOIN {user} u ON s.userid = u.id
                LEFT JOIN {aiassignment_evaluations} e ON e.submission = s.id
                WHERE s.assignment = :assignment
                GROUP BY u.id, u.firstname, u.lastname
                ORDER BY plagiarism DESC";
$ranking = $DB->get_records_sql($ranking_sql, ['assignment' => $aiassignment->id]);

echo $OUTPUT->box_start('generalbox', 'plagiarism-ranking');
echo html_writer::tag('h3', '📊 Ranking de Alumnos por Porcentaje de Plagio',
    array('style' => 'margin-bottom:12px;'));
echo html_writer::tag('p',
    'Listado ordenado de mayor a menor porcentaje de similitud detectada.',
    array('style' => 'color:#666; margin-bottom:16px;')
);

$rtable = new html_table();
$rtable->attributes['class'] = 'generaltable';
$rtable->head  = array('#', 'Alumno', 'Porcentaje de Plagio', 'Nivel de Riesgo');
$rtable->align = array('center', 'left', 'center', 'center');

$rank_pos = 1;
foreach ($ranking as $row) {
    $pct  = $row->plagiarism;
    $name = trim($row->firstname . ' ' . $row->lastname);

    if ($pct === null) {
        $pct_display = html_writer::tag('span', 'Sin datos', array('style' => 'color:#999;'));
        $risk = html_writer::span('—', 'badge badge-secondary');
    } else {
        $pct_rounded = round($pct, 1);
        if ($pct_rounded >= 70) {
            $color = '#dc3545';
            $risk  = html_writer::span('🔴 Alto', 'badge badge-danger');
        } elseif ($pct_rounded >= 40) {
            $color = '#856404';
            $risk  = html_writer::span('🟡 Medio', 'badge badge-warning');
        } else {
            $color = '#155724';
            $risk  = html_writer::span('🟢 Bajo', 'badge badge-success');
        }

        // Barra visual
        $bar = html_writer::start_div('progress', array('style' => 'height:14px; min-width:120px; display:inline-block; width:120px; vertical-align:middle; margin-right:8px;'));
        $bar .= html_writer::div('', 'progress-bar', array(
            'role'           => 'progressbar',
            'style'          => "width:{$pct_rounded}%; background-color:{$color};",
            'aria-valuenow'  => $pct_rounded,
            'aria-valuemin'  => '0',
            'aria-valuemax'  => '100',
        ));
        $bar .= html_writer::end_div();

        $pct_display = $bar . html_writer::tag('strong', $pct_rounded . '%', array('style' => "color:{$color};"));
    }

    $rtable->data[] = array($rank_pos, $name, $pct_display, $risk);
    $rank_pos++;
}

echo html_writer::table($rtable);
echo $OUTPUT->box_end();
// ─────────────────────────────────────────────────────────────────────────────

echo $OUTPUT->continue_button(new moodle_url('/mod/aiassignment/view.php', array('id' => $cm->id)));

echo html_writer::tag('script', "
function filterTable(query) {
    query = query.toLowerCase().trim();
    var rows = document.querySelectorAll('.mod_index tbody tr');
    var visible = 0;
    rows.forEach(function(row) {
        var name = row.cells[0] ? row.cells[0].textContent.toLowerCase() : '';
        var show = !query || name.includes(query);
        row.style.display = show ? '' : 'none';
        if (show) visible++;
    });
    var counter = document.getElementById('search-counter');
    if (counter) counter.textContent = query ? visible + ' resultado(s)' : '';
}
");

// Mejora 4: Ordenar tabla por columna
echo html_writer::tag('script', "
document.addEventListener('DOMContentLoaded', function() {
    var table = document.querySelector('.mod_index');
    if (!table) return;
    var headers = table.querySelectorAll('th');
    var sortDir = {};
    headers.forEach(function(th, idx) {
        if (idx >= headers.length - 1) return;
        th.style.cursor = 'pointer';
        th.title = 'Clic para ordenar';
        th.addEventListener('click', function() {
            var asc = !sortDir[idx];
            sortDir[idx] = asc;
            var tbody = table.querySelector('tbody');
            var rows = Array.from(tbody.querySelectorAll('tr'));
            rows.sort(function(a, b) {
                var va = a.cells[idx] ? a.cells[idx].textContent.trim() : '';
                var vb = b.cells[idx] ? b.cells[idx].textContent.trim() : '';
                var na = parseFloat(va.replace('%',''));
                var nb = parseFloat(vb.replace('%',''));
                if (!isNaN(na) && !isNaN(nb)) {
                    return asc ? na - nb : nb - na;
                }
                return asc ? va.localeCompare(vb) : vb.localeCompare(va);
            });
            rows.forEach(function(r) { tbody.appendChild(r); });
            headers.forEach(function(h) { h.textContent = h.textContent.replace(' ↑','').replace(' ↓',''); });
            th.textContent += asc ? ' ↑' : ' ↓';
        });
    });
});
");

// Mejora 5: Filtro por estado
echo html_writer::tag('script', "
function filterByStatus(status) {
    var rows = document.querySelectorAll('.mod_index tbody tr');
    rows.forEach(function(row) {
        if (!status) { row.style.display = ''; return; }
        var statusCell = row.cells[3] ? row.cells[3].textContent.toLowerCase() : '';
        var show = false;
        if (status === 'evaluated' && statusCell.includes('evaluad')) show = true;
        else if (status === 'pending' && statusCell.includes('pendiente')) show = true;
        else if (status === 'flagged' && (statusCell.includes('re-env') || statusCell.includes('solicit'))) show = true;
        row.style.display = show ? '' : 'none';
    });
}
");

echo $OUTPUT->footer();
