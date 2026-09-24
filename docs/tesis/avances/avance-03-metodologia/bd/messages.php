<?php
// This file is part of Moodle - http://moodle.org/

defined('MOODLE_INTERNAL') || die();

/**
 * Definición de proveedores de mensajes para mod_aiassignment (mejora #3)
 */
$messageproviders = [
    'submission_graded' => [
        'defaults' => [
            message_output_email::class => MESSAGE_PERMITTED + MESSAGE_DEFAULT_ENABLED,
        ],
    ],
];
