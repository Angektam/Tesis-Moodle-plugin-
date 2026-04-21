<?php
// This file is part of Moodle - http://moodle.org/

defined('MOODLE_INTERNAL') || die();

/**
 * Registro de tareas programadas y adhoc para mod_aiassignment.
 */
$tasks = [
    // Tarea adhoc: evaluar envíos en background (mejora #2)
    // Se encola automáticamente desde submit.php cuando async_evaluation está activo.
    // No tiene schedule fijo — se ejecuta en el próximo ciclo del cron.
];
