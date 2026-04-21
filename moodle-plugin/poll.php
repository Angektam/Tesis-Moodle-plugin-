<?php
// This file is part of Moodle - http://moodle.org/
// Endpoint de polling para notificaciones en tiempo real.

define('AJAX_SCRIPT', true);
require_once('../../config.php');

$id       = required_param('id',    PARAM_INT);
$since    = optional_param('since', 0, PARAM_INT);
$markseen = optional_param('mark_seen', 0, PARAM_INT);
$ids_raw  = optional_param('ids',   '', PARAM_TEXT);

$cm = get_coursemodule_from_id('aiassignment', $id, 0, false, MUST_EXIST);
require_login($cm->course, false, $cm);
require_sesskey();

header('Content-Type: application/json; charset=utf-8');

if ($markseen && !empty($ids_raw)) {
    $ids = array_filter(array_map('intval', explode(',', $ids_raw)));
    \mod_aiassignment\realtime_notifier::mark_seen($USER->id, $ids);
    echo json_encode(['ok' => true]);
    exit;
}

$notifications = \mod_aiassignment\realtime_notifier::get_pending($USER->id, $since);

// También verificar si hay envíos pendientes que ya fueron evaluados
// (para el caso de evaluación asíncrona)
$pending_check = $DB->get_records_select(
    'aiassignment_submissions',
    'userid = :uid AND status = :st AND timecreated > :since',
    ['uid' => $USER->id, 'st' => 'evaluated', 'since' => $since],
    'timecreated DESC',
    'id, assignment, score, feedback',
    0, 5
);

foreach ($pending_check as $sub) {
    $assignment = $DB->get_record('aiassignment', ['id' => $sub->assignment], 'name');
    $notifications[] = [
        'id'          => 'sub_' . $sub->id,
        'type'        => 'evaluated',
        'data'        => [
            'title' => '✅ Tarea evaluada',
            'body'  => ($assignment ? format_string($assignment->name) . ': ' : '') .
                       round($sub->score, 1) . '%',
            'url'   => (new moodle_url('/mod/aiassignment/view.php', ['id' => $id]))->out(false),
        ],
        'timecreated' => time(),
    ];
}

echo json_encode(['notifications' => $notifications, 'timestamp' => time()]);
