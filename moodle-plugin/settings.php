<?php
// This file is part of Moodle - http://moodle.org/

defined('MOODLE_INTERNAL') || die();

if ($ADMIN->fulltree) {
    // OpenAI API Key
    $settings->add(new admin_setting_configtext(
        'mod_aiassignment/openai_api_key',
        get_string('openaiapikey', 'mod_aiassignment'),
        get_string('openaiapikey_desc', 'mod_aiassignment'),
        '',
        PARAM_TEXT
    ));

    // OpenAI Model
    $models = array(
        'gpt-4o-mini' => 'GPT-4o Mini (Recomendado - Rápido y económico)',
        'gpt-4o' => 'GPT-4o (Más potente, más costoso)',
        'gpt-4-turbo' => 'GPT-4 Turbo',
        'gpt-3.5-turbo' => 'GPT-3.5 Turbo (Más económico)'
    );
    
    $settings->add(new admin_setting_configselect(
        'mod_aiassignment/openai_model',
        get_string('openaimodel', 'mod_aiassignment'),
        get_string('openaimodel_desc', 'mod_aiassignment'),
        'gpt-4o-mini',
        $models
    ));

    // Demo Mode (sin API)
    $settings->add(new admin_setting_configcheckbox(
        'mod_aiassignment/demo_mode',
        get_string('demomode', 'mod_aiassignment'),
        get_string('demomode_desc', 'mod_aiassignment'),
        0
    ));

    // Max response time
    $settings->add(new admin_setting_configtext(
        'mod_aiassignment/max_response_time',
        get_string('maxresponsetime', 'mod_aiassignment'),
        get_string('maxresponsetime_desc', 'mod_aiassignment'),
        '30',
        PARAM_INT
    ));

    // Plagiarism threshold
    $settings->add(new admin_setting_configtext(
        'mod_aiassignment/plagiarism_threshold',
        'Umbral de plagio (%)',
        'Porcentaje mínimo de similitud para considerar un envío como plagio probable (0-100).',
        '75',
        PARAM_INT
    ));

    // OpenAI retries
    $settings->add(new admin_setting_configtext(
        'mod_aiassignment/openai_retries',
        'Reintentos OpenAI',
        'Número de reintentos automáticos al llamar a la API de OpenAI (1-5).',
        '2',
        PARAM_INT
    ));

    // Max submission length
    $settings->add(new admin_setting_configtext(
        'mod_aiassignment/max_submission_length',
        'Longitud máxima de envío (caracteres)',
        'Número máximo de caracteres permitidos en un envío de estudiante.',
        '10000',
        PARAM_INT
    ));
}
