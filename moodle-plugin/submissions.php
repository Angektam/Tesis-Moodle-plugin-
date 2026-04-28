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
$status_filter = optional_param('status_filter', '', PARAM_ALPHA);
$search  = optional_param('search', '', PARAM_TEXT);

// Contar total con filtros server-side (mejora #9)
$where_parts = ['s.assignment = :assignment'];
$params = ['assignment' => $aiassignment->id];

if ($status_filter !== '') {
    $where_parts[] = 's.status = :status';
    $params['status'] = $status_filter;
}

$join_user = 'JOIN {user} u ON s.userid = u.id';
if ($search !== '') {
    $where_parts[] = $DB->sql_like($DB->sql_concat('u.firstname', "' '", 'u.lastname'), ':search', false);
    $params['search'] = '%' . $DB->sql_like_escape($search) . '%';
}

$where_sql = implode(' AND ', $where_parts);
$total = $DB->count_records_sql(
    "SELECT COUNT(*) FROM {aiassignment_submissions} s $join_user WHERE $where_sql", $params);

if ($total === 0) {
    echo $OUTPUT->notification(get_string('nosubmissions', 'aiassignment'), 'info');
    echo $OUTPUT->continue_button(new moodle_url('/mod/aiassignment/view.php', ['id' => $cm->id]));
    echo $OUTPUT->footer();
    exit;
}

// Solo traer la página actual con filtros server-side
$sql = "SELECT s.*, u.firstname, u.lastname, u.email
        FROM {aiassignment_submissions} s
        $join_user
        WHERE $where_sql
        ORDER BY s.timecreated DESC";
$submissions_paged = $DB->get_records_sql($sql, $params,
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
    html_writer::tag('input', '', ['type' => 'checkbox', 'id' => 'select-all',
        'aria-label' => get_string('bulk_select_all', 'aiassignment'),
        'onchange' => 'toggleSelectAll(this.checked)']),
    get_string('student', 'aiassignment'),
    get_string('submitted', 'aiassignment'),
    get_string('attempt', 'aiassignment'),
    get_string('status', 'aiassignment'),
    get_string('score', 'aiassignment'),
    '🔍 Plagio',
    get_string('actions', 'aiassignment')
);
$table->align = array('center', 'left', 'left', 'center', 'center', 'center', 'center', 'center');

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

    // Plagio con aria-label para accesibilidad (mejora #15)
    $plagiarism_pct = '-';
    if (isset($plagiarism_by_user[$submission->userid])) {
        $pct = round($plagiarism_by_user[$submission->userid], 1);
        $color = ($pct >= 70) ? '#dc3545' : (($pct >= 40) ? '#856404' : '#155724');
        $aria = ($pct >= 70) ? get_string('aria_plagiarism_high', 'aiassignment')
              : (($pct >= 40) ? get_string('aria_plagiarism_medium', 'aiassignment')
              : get_string('aria_plagiarism_low', 'aiassignment'));
        $plagiarism_pct = html_writer::tag('span',
            $pct . '%',
            array('style' => "font-weight:600; color:{$color};", 'aria-label' => $aria, 'role' => 'status')
        );
    }

    // Checkbox para acciones en lote
    $checkbox = html_writer::tag('input', '', [
        'type' => 'checkbox', 'class' => 'bulk-check', 'value' => $submission->id,
        'aria-label' => 'Seleccionar envío de ' . fullname($submission),
        'onchange' => 'updateBulkButtons()',
    ]);

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

    $table->data[] = array($checkbox, $student, $submitted, $attempt, $status, $score, $plagiarism_pct, $actions);
}

// Filtro de estado server-side (mejora #9) y búsqueda
echo html_writer::start_tag('form', ['method' => 'get', 'id' => 'filter-form',
    'style' => 'display:flex;gap:10px;margin-bottom:10px;align-items:center;flex-wrap:wrap;']);
echo html_writer::empty_tag('input', ['type' => 'hidden', 'name' => 'id', 'value' => $cm->id]);
echo html_writer::tag('label', 'Estado:', ['for' => 'status-filter',
    'style' => 'font-size:13px;font-weight:600;color:#666;']);
$status_options = [
    ''          => 'Todos',
    'evaluated' => '✅ Evaluados',
    'pending'   => '⏳ Pendientes',
    'flagged'   => '📩 Re-envío solicitado',
];
$status_select = html_writer::start_tag('select', [
    'id' => 'status-filter', 'name' => 'status_filter',
    'aria-label' => get_string('aria_filter_status', 'aiassignment'),
    'style' => 'padding:7px 12px;border-radius:8px;border:1px solid #dee2e6;font-size:13px;',
    'onchange' => 'this.form.submit()'
]);
foreach ($status_options as $val => $label) {
    $attrs = ['value' => $val];
    if ($status_filter === $val) $attrs['selected'] = 'selected';
    $status_select .= html_writer::tag('option', $label, $attrs);
}
$status_select .= html_writer::end_tag('select');
echo $status_select;

echo html_writer::tag('input', '', [
    'type' => 'text', 'name' => 'search', 'value' => $search,
    'placeholder' => '🔍 Buscar por nombre...',
    'aria-label' => get_string('aria_search_students', 'aiassignment'),
    'style' => 'flex:1;min-width:200px;padding:7px 12px;border-radius:8px;border:1px solid #dee2e6;font-size:13px;',
]);
echo html_writer::tag('button', '🔍 Buscar', [
    'type' => 'submit', 'class' => 'btn btn-sm btn-primary']);
if ($search !== '' || $status_filter !== '') {
    echo html_writer::link(
        new moodle_url('/mod/aiassignment/submissions.php', ['id' => $cm->id]),
        '✕ Limpiar', ['class' => 'btn btn-sm btn-outline-secondary']);
}
echo html_writer::end_tag('form');

// Acciones en lote (mejora #14)
echo html_writer::start_tag('form', ['method' => 'post', 'id' => 'bulk-form',
    'action' => (new moodle_url('/mod/aiassignment/bulk_actions.php', ['id' => $cm->id]))->out(false)]);
echo html_writer::empty_tag('input', ['type' => 'hidden', 'name' => 'sesskey', 'value' => sesskey()]);
echo html_writer::empty_tag('input', ['type' => 'hidden', 'name' => 'id', 'value' => $cm->id]);
echo html_writer::empty_tag('input', ['type' => 'hidden', 'name' => 'sids', 'id' => 'bulk-sids', 'value' => '']);
echo html_writer::empty_tag('input', ['type' => 'hidden', 'name' => 'action', 'id' => 'bulk-action', 'value' => '']);

echo html_writer::start_div('', ['style' => 'display:flex;gap:8px;margin-bottom:10px;']);
echo html_writer::tag('button', '🔄 ' . get_string('bulk_reevaluate', 'aiassignment'), [
    'type' => 'button', 'class' => 'btn btn-sm btn-outline-primary',
    'onclick' => "submitBulk('reevaluate')", 'disabled' => 'disabled', 'id' => 'btn-bulk-reeval']);
echo html_writer::tag('button', '🚩 ' . get_string('bulk_flag', 'aiassignment'), [
    'type' => 'button', 'class' => 'btn btn-sm btn-outline-danger',
    'onclick' => "submitBulk('flag')", 'disabled' => 'disabled', 'id' => 'btn-bulk-flag']);
echo html_writer::tag('button', '✅ ' . get_string('bulk_unflag', 'aiassignment'), [
    'type' => 'button', 'class' => 'btn btn-sm btn-outline-success',
    'onclick' => "submitBulk('unflag')", 'disabled' => 'disabled', 'id' => 'btn-bulk-unflag']);
echo html_writer::end_div();

echo html_writer::table($table);
echo html_writer::end_tag('form'); // bulk-form

// Paginación con filtros preservados
if ($total > $perpage) {
    $paging_params = ['id' => $cm->id];
    if ($status_filter !== '') $paging_params['status_filter'] = $status_filter;
    if ($search !== '') $paging_params['search'] = $search;
    $paging_url = new moodle_url('/mod/aiassignment/submissions.php', $paging_params);
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
$rtable->attributes['role'] = 'table';
$rtable->attributes['aria-label'] = 'Ranking de alumnos por porcentaje de plagio';
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
function toggleSelectAll(checked) {
    document.querySelectorAll('.bulk-check').forEach(function(cb) { cb.checked = checked; });
    updateBulkButtons();
}
function updateBulkButtons() {
    var checked = document.querySelectorAll('.bulk-check:checked').length;
    ['btn-bulk-reeval','btn-bulk-flag','btn-bulk-unflag'].forEach(function(id) {
        document.getElementById(id).disabled = checked === 0;
    });
}
function submitBulk(action) {
    var ids = [];
    document.querySelectorAll('.bulk-check:checked').forEach(function(cb) { ids.push(cb.value); });
    if (!ids.length) return;
    var msgs = {
        reevaluate: '¿Re-evaluar ' + ids.length + ' envío(s)?',
        flag: '¿Marcar ' + ids.length + ' envío(s) como plagio?',
        unflag: '¿Desmarcar ' + ids.length + ' envío(s)?'
    };
    if (!confirm(msgs[action])) return;
    document.getElementById('bulk-sids').value = ids.join(',');
    document.getElementById('bulk-action').value = action;
    document.getElementById('bulk-form').submit();
}
");

// Mejora 4: Ordenar tabla por columna (con aria-labels)
echo html_writer::tag('script', "
document.addEventListener('DOMContentLoaded', function() {
    var table = document.querySelector('.mod_index');
    if (!table) return;
    var headers = table.querySelectorAll('th');
    var sortDir = {};
    headers.forEach(function(th, idx) {
        if (idx === 0 || idx >= headers.length - 1) return; // Skip checkbox and actions
        th.style.cursor = 'pointer';
        th.title = 'Clic para ordenar';
        th.setAttribute('aria-label', th.textContent.trim() + ' - clic para ordenar');
        th.setAttribute('role', 'button');
        th.setAttribute('tabindex', '0');
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

echo $OUTPUT->footer();
