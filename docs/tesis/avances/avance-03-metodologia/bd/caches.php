<?php
// This file is part of Moodle - http://moodle.org/

defined('MOODLE_INTERNAL') || die();

/**
 * Definición de áreas de caché para mod_aiassignment
 */
$definitions = [
    // Caché del reporte de plagio (mejora #8)
    // Se invalida automáticamente cuando hay submissions nuevas.
    'plagiarism' => [
        'mode'       => cache_store::MODE_APPLICATION,
        'simplekeys' => true,
        'ttl'        => 3600, // 1 hora máximo aunque no haya cambios
    ],

    // Caché de evaluaciones IA (mejora v2.1 #4)
    // Evita llamadas duplicadas a OpenAI para código idéntico.
    'evaluations' => [
        'mode'       => cache_store::MODE_APPLICATION,
        'simplekeys' => true,
        'ttl'        => 86400, // 24 horas
    ],
];
