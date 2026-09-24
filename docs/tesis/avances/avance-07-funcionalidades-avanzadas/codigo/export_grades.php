<?php
// This file is part of Moodle - http://moodle.org/
// Exportación de calificaciones en CSV, Excel (XLSX) y PDF.

require_once('../../config.php');
require_once($CFG->dirroot . '/mod/aiassignment/lib.php');

$courseid = required_param('courseid', PARAM_INT);
$format   = optional_param('format', 'csv', PARAM_ALPHA); // csv | xlsx | pdf
$aid      = optional_param('aid', 0, PARAM_INT); // 0 = todos

$course = $DB->get_record('course', ['id' => $courseid], '*', MUST_EXIST);
require_login($course);
$context = context_course::instance($course->id);
require_capability('mod/aiassignment:grade', $context);

// ── Recopilar datos ───────────────────────────────────────────
$where_aid = $aid ? 'AND a.id = :aid' : '';
$params    = ['courseid' => $courseid];
if ($aid) $params['aid'] = $aid;

$sql = "SELECT s.id, s.userid, s.assignment, s.attempt, s.score, s.status,
               s.timecreated, s.feedback,
               u.firstname, u.lastname, u.email,
               a.name AS assignment_name, a.type,
               e.similarity_score
        FROM {aiassignment_submissions} s
        JOIN {user} u ON s.userid = u.id
        JOIN {aiassignment} a ON s.assignment = a.id
        LEFT JOIN {aiassignment_evaluations} e ON e.submission = s.id
        WHERE a.course = :courseid $where_aid
        ORDER BY u.lastname, u.firstname, a.name, s.attempt";

$rows = $DB->get_records_sql($sql, $params);

$filename = 'calificaciones_' . clean_filename($course->shortname) .
            ($aid ? '_tarea' . $aid : '') . '_' . date('Ymd_His');

// ── CSV ───────────────────────────────────────────────────────
if ($format === 'csv') {
    header('Content-Type: text/csv; charset=utf-8');
    header('Content-Disposition: attachment; filename="' . $filename . '.csv"');
    $out = fopen('php://output', 'w');
    // BOM para Excel
    fprintf($out, chr(0xEF) . chr(0xBB) . chr(0xBF));

    fputcsv($out, ['Curso', $course->fullname]);
    fputcsv($out, ['Generado', date('d/m/Y H:i')]);
    fputcsv($out, []);
    fputcsv($out, ['Apellido', 'Nombre', 'Email', 'Tarea', 'Tipo',
                   'Intento', 'Calificación (%)', 'Plagio (%)', 'Estado', 'Fecha', 'Feedback']);

    foreach ($rows as $r) {
        fputcsv($out, [
            $r->lastname,
            $r->firstname,
            $r->email,
            $r->assignment_name,
            $r->type === 'programming' ? 'Programación' : 'Matemáticas',
            $r->attempt,
            $r->score !== null ? number_format($r->score, 2) : '',
            $r->similarity_score !== null ? number_format($r->similarity_score, 2) : '',
            $r->status,
            date('d/m/Y H:i', $r->timecreated),
            $r->feedback ?? '',
        ]);
    }
    fclose($out);
    exit;
}

// ── XLSX (usando PhpSpreadsheet si está disponible, sino CSV con extensión xlsx) ──
if ($format === 'xlsx') {
    // Intentar usar PhpSpreadsheet (disponible en Moodle 4.x)
    if (class_exists('\PhpOffice\PhpSpreadsheet\Spreadsheet')) {
        $spreadsheet = new \PhpOffice\PhpSpreadsheet\Spreadsheet();
        $sheet = $spreadsheet->getActiveSheet();
        $sheet->setTitle('Calificaciones');

        // Encabezados con estilo
        $headers = ['Apellido', 'Nombre', 'Email', 'Tarea', 'Tipo',
                    'Intento', 'Calificación (%)', 'Plagio (%)', 'Estado', 'Fecha', 'Feedback'];
        $sheet->fromArray($headers, null, 'A1');

        // Estilo de encabezados
        $headerStyle = [
            'font'      => ['bold' => true, 'color' => ['rgb' => 'FFFFFF']],
            'fill'      => ['fillType' => \PhpOffice\PhpSpreadsheet\Style\Fill::FILL_SOLID,
                            'startColor' => ['rgb' => '1a73e8']],
            'alignment' => ['horizontal' => \PhpOffice\PhpSpreadsheet\Style\Alignment::HORIZONTAL_CENTER],
        ];
        $sheet->getStyle('A1:K1')->applyFromArray($headerStyle);

        // Datos
        $row = 2;
        foreach ($rows as $r) {
            $score = $r->score !== null ? (float)number_format($r->score, 2) : '';
            $plag  = $r->similarity_score !== null ? (float)number_format($r->similarity_score, 2) : '';

            $sheet->fromArray([
                $r->lastname, $r->firstname, $r->email,
                $r->assignment_name,
                $r->type === 'programming' ? 'Programación' : 'Matemáticas',
                (int)$r->attempt, $score, $plag,
                $r->status, date('d/m/Y H:i', $r->timecreated),
                $r->feedback ?? '',
            ], null, 'A' . $row);

            // Color por calificación
            if ($score !== '') {
                $color = $score >= 80 ? 'c3e6cb' : ($score >= 60 ? 'fff3cd' : 'f5c6cb');
                $sheet->getStyle('G' . $row)->applyFromArray([
                    'fill' => ['fillType' => \PhpOffice\PhpSpreadsheet\Style\Fill::FILL_SOLID,
                               'startColor' => ['rgb' => $color]],
                ]);
            }
            $row++;
        }

        // Auto-ajustar columnas
        foreach (range('A', 'K') as $col) {
            $sheet->getColumnDimension($col)->setAutoSize(true);
        }

        header('Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
        header('Content-Disposition: attachment; filename="' . $filename . '.xlsx"');
        $writer = new \PhpOffice\PhpSpreadsheet\Writer\Xlsx($spreadsheet);
        $writer->save('php://output');
        exit;
    }

    // Fallback: CSV con extensión xlsx
    header('Content-Type: text/csv; charset=utf-8');
    header('Content-Disposition: attachment; filename="' . $filename . '.csv"');
    $out = fopen('php://output', 'w');
    fprintf($out, chr(0xEF) . chr(0xBB) . chr(0xBF));
    fputcsv($out, ['Apellido', 'Nombre', 'Email', 'Tarea', 'Tipo',
                   'Intento', 'Calificación (%)', 'Plagio (%)', 'Estado', 'Fecha']);
    foreach ($rows as $r) {
        fputcsv($out, [
            $r->lastname, $r->firstname, $r->email, $r->assignment_name,
            $r->type, $r->attempt,
            $r->score !== null ? number_format($r->score, 2) : '',
            $r->similarity_score !== null ? number_format($r->similarity_score, 2) : '',
            $r->status, date('d/m/Y H:i', $r->timecreated),
        ]);
    }
    fclose($out);
    exit;
}

// ── PDF (HTML imprimible con estilos) ─────────────────────────
if ($format === 'pdf') {
    $PAGE->set_url('/mod/aiassignment/export_grades.php', ['courseid' => $courseid, 'format' => 'pdf']);
    $PAGE->set_title('Calificaciones — ' . format_string($course->fullname));
    $PAGE->set_heading(format_string($course->fullname));
    $PAGE->set_context($context);
    $PAGE->set_pagelayout('print');

    echo $OUTPUT->header();

    // Agrupar por tarea
    $by_assignment = [];
    foreach ($rows as $r) {
        $by_assignment[$r->assignment_name][] = $r;
    }

    echo '<style>
        body { font-family: Arial, sans-serif; font-size: 12px; }
        h1   { font-size: 18px; color: #1a73e8; margin-bottom: 4px; }
        h2   { font-size: 14px; color: #333; margin: 16px 0 8px; border-bottom: 2px solid #1a73e8; padding-bottom: 4px; }
        table { width: 100%; border-collapse: collapse; margin-bottom: 16px; }
        th    { background: #1a73e8; color: #fff; padding: 6px 8px; text-align: left; font-size: 11px; }
        td    { padding: 5px 8px; border-bottom: 1px solid #dee2e6; font-size: 11px; }
        tr:nth-child(even) td { background: #f8f9fa; }
        .grade-high   { color: #28a745; font-weight: 700; }
        .grade-medium { color: #856404; font-weight: 700; }
        .grade-low    { color: #dc3545; font-weight: 700; }
        .plag-high    { color: #dc3545; font-weight: 700; }
        .footer       { margin-top: 20px; font-size: 10px; color: #888; text-align: center; }
        @media print { .no-print { display: none; } }
    </style>';

    echo '<div class="no-print" style="margin-bottom:16px;">';
    echo '<button onclick="window.print()" class="btn btn-primary">🖨️ Imprimir / Guardar PDF</button> ';
    echo '<a href="' . (new moodle_url('/mod/aiassignment/export_grades.php',
        ['courseid' => $courseid, 'format' => 'csv']))->out() . '" class="btn btn-secondary">⬇️ Descargar CSV</a>';
    echo '</div>';

    echo '<h1>📊 Reporte de Calificaciones</h1>';
    echo '<p style="color:#666;font-size:12px;">Curso: <strong>' . format_string($course->fullname) . '</strong> · Generado: ' . date('d/m/Y H:i') . '</p>';

    foreach ($by_assignment as $aname => $arows) {
        $scores = array_filter(array_column($arows, 'score'), fn($v) => $v !== null);
        $avg    = !empty($scores) ? round(array_sum($scores) / count($scores), 1) : 'N/A';

        echo '<h2>' . htmlspecialchars($aname) . ' <span style="font-size:12px;color:#666;font-weight:400;">— Promedio: ' . $avg . '%</span></h2>';
        echo '<table>';
        echo '<thead><tr><th>#</th><th>Apellido</th><th>Nombre</th><th>Intento</th><th>Calificación</th><th>Plagio</th><th>Estado</th><th>Fecha</th></tr></thead>';
        echo '<tbody>';
        $i = 1;
        foreach ($arows as $r) {
            $sc    = $r->score !== null ? round($r->score, 1) : '—';
            $scls  = $r->score !== null ? ($r->score >= 80 ? 'grade-high' : ($r->score >= 60 ? 'grade-medium' : 'grade-low')) : '';
            $plag  = $r->similarity_score !== null ? round($r->similarity_score, 1) . '%' : '—';
            $pcls  = $r->similarity_score !== null && $r->similarity_score >= 75 ? 'plag-high' : '';
            echo '<tr>';
            echo '<td>' . $i++ . '</td>';
            echo '<td>' . htmlspecialchars($r->lastname) . '</td>';
            echo '<td>' . htmlspecialchars($r->firstname) . '</td>';
            echo '<td style="text-align:center;">' . $r->attempt . '</td>';
            echo '<td class="' . $scls . '" style="text-align:center;">' . ($sc !== '—' ? $sc . '%' : '—') . '</td>';
            echo '<td class="' . $pcls . '" style="text-align:center;">' . $plag . '</td>';
            echo '<td>' . htmlspecialchars($r->status) . '</td>';
            echo '<td>' . date('d/m/Y', $r->timecreated) . '</td>';
            echo '</tr>';
        }
        echo '</tbody></table>';
    }

    echo '<div class="footer">AI Assignment Plugin · Moodle · ' . date('Y') . '</div>';
    echo $OUTPUT->footer();
    exit;
}

// Redirigir si formato no reconocido
redirect(new moodle_url('/mod/aiassignment/dashboard.php', ['courseid' => $courseid]));
