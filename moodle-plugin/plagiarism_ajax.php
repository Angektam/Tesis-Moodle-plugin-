<?php
// This file is part of Moodle - http://moodle.org/
// Endpoint AJAX para ejecutar el análisis de plagio en background.
// Devuelve JSON con el resultado o el estado actual.

define('AJAX_SCRIPT', true);
require_once('../../config.php');
require_once('lib.php');
require_once(__DIR__ . '/classes/plagiarism_detector.php');

$id     = required_param('id',     PARAM_INT);
$nosem  = optional_param('nosem',  1, PARAM_INT);
$force  = optional_param('force',  0, PARAM_INT);

$cm           = get_coursemodule_from_id('aiassignment', $id, 0, false, MUST_EXIST);
$course       = $DB->get_record('course', ['id' => $cm->course], '*', MUST_EXIST);
$aiassignment = $DB->get_record('aiassignment', ['id' => $cm->instance], '*', MUST_EXIST);

require_login($course, true, $cm);
require_capability('mod/aiassignment:grade', context_module::instance($cm->id));

@set_time_limit(300);
@ini_set('max_execution_time', 300);

$start_time = time();

header('Content-Type: application/json; charset=utf-8');

try {
    $report = \mod_aiassignment\plagiarism_detector::generate_plagiarism_report(
        $aiassignment->id, (bool)$nosem, (bool)$force
    );

    if (isset($report['message'])) {
        echo json_encode(['status' => 'error', 'message' => $report['message']]);
        exit;
    }

    // Guardar similarity_score en evaluaciones
    foreach ($report['user_ranking'] as $row) {
        $uid   = $row['userid'];
        $score = $row['max_similarity'];
        $sub   = $DB->get_record_sql(
            "SELECT id FROM {aiassignment_submissions}
             WHERE assignment=:a AND userid=:u ORDER BY id DESC LIMIT 1",
            ['a' => $aiassignment->id, 'u' => $uid]
        );
        if (!$sub) continue;
        $eval = $DB->get_record('aiassignment_evaluations', ['submission' => $sub->id]);
        if ($eval) {
            $DB->set_field('aiassignment_evaluations', 'similarity_score', $score, ['id' => $eval->id]);
        } else {
            $DB->insert_record('aiassignment_evaluations', (object)[
                'submission' => $sub->id, 'similarity_score' => $score,
                'ai_feedback' => '', 'ai_analysis' => '', 'timecreated' => time(),
            ]);
        }
    }

    // Preparar datos para el frontend (sin objetos PHP complejos)
    $result = [
        'status'               => 'done',
        'mode'                 => $nosem ? 'fast' : 'full',
        'elapsed_seconds'      => time() - $start_time,
        'from_cache'           => !empty($report['from_cache']),
        'total_submissions'    => $report['total_submissions'],
        'total_comparisons'    => $report['total_comparisons'],
        'suspicious_pairs'     => $report['suspicious_pairs_count'],
        'highest_similarity'   => round($report['highest_similarity'], 1),
        'user_ranking'         => [],
        'comparisons'          => [],
    ];

    // Ranking con nombres de usuario
    foreach ($report['user_ranking'] as $row) {
        $u = $DB->get_record('user', ['id' => $row['userid']], 'id,firstname,lastname');
        $result['user_ranking'][] = [
            'userid'         => $row['userid'],
            'name'           => $u ? trim($u->firstname . ' ' . $u->lastname) : 'Usuario ' . $row['userid'],
            'max_similarity' => round($row['max_similarity'], 1),
        ];
    }

    // Comparaciones detalladas
    foreach ($report['detailed_comparisons'] as $cmp) {
        $u1 = $DB->get_record('user', ['id' => $cmp['submission1_user']], 'id,firstname,lastname');
        $u2 = $DB->get_record('user', ['id' => $cmp['submission2_user']], 'id,firstname,lastname');
        $result['comparisons'][] = [
            'sub1_id'    => $cmp['submission1_id'],
            'sub2_id'    => $cmp['submission2_id'],
            'user1'      => $u1 ? trim($u1->firstname . ' ' . $u1->lastname) : '?',
            'user2'      => $u2 ? trim($u2->firstname . ' ' . $u2->lastname) : '?',
            'score'      => round($cmp['similarity_score'], 1),
            'verdict'    => $cmp['verdict'],
            'techniques' => $cmp['techniques'] ?? [],
            'analysis'   => $cmp['analysis'] ?? '',
            'layers'     => [
                'lexical'    => round($cmp['layers']['lexical']['score'] ?? 0, 1),
                'structural' => round($cmp['layers']['structural']['score'] ?? 0, 1),
                'semantic'   => round($cmp['layers']['semantic']['score'] ?? 0, 1),
            ],
        ];
    }

    echo json_encode($result);

} catch (Exception $e) {
    echo json_encode(['status' => 'error', 'message' => $e->getMessage()]);
}
