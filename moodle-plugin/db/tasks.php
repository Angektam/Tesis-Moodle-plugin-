<?php
// This file is part of Moodle - http://moodle.org/

defined('MOODLE_INTERNAL') || die();

/**
 * Registro de tareas programadas y adhoc para mod_aiassignment.
 */
$tasks = [
    // Tarea programada: limpieza de datos antiguos (mejora: retención de datos)
    [
        'classname' => 'mod_aiassignment\task\cleanup_old_data',
        'blocking'  => 0,
        'minute'    => '0',
        'hour'      => '3',
        'day'       => '*',
        'month'     => '*',
        'dayofweek' => '0', // Domingos a las 3:00 AM
    ],
];
