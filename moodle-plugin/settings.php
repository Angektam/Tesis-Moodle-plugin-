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

    // Evaluación asíncrona
    $settings->add(new admin_setting_configcheckbox(
        'mod_aiassignment/async_evaluation',
        'Evaluación asíncrona (recomendado)',
        'Si está activo, los envíos se evalúan en background con el cron de Moodle. El estudiante no espera bloqueado. Requiere que el cron esté configurado.',
        0
    ));

    // Modo examen
    $settings->add(new admin_setting_configcheckbox(
        'mod_aiassignment/exam_mode',
        'Modo examen',
        'Activa restricciones de examen: detecta cambios de pestaña, deshabilita clic derecho y copiar/pegar.',
        0
    ));

    // Detección de código IA
    $settings->add(new admin_setting_configcheckbox(
        'mod_aiassignment/detect_ai_code',
        'Detectar código generado por IA',
        'Analiza si el código del estudiante fue generado por ChatGPT, Copilot u otras IAs. Requiere API key de OpenAI para análisis avanzado.',
        1
    ));

    // Rúbricas
    $settings->add(new admin_setting_configcheckbox(
        'mod_aiassignment/use_rubrics',
        'Usar rúbricas de evaluación',
        'Evalúa con criterios ponderados (funcionalidad, estilo, eficiencia, documentación) en lugar de un score único.',
        0
    ));

    // ── Judge0 (ejecución real de código) ─────────────────────────
    $settings->add(new admin_setting_heading(
        'mod_aiassignment/judge0_heading',
        '🚀 Ejecución de Código (Judge0)',
        'Configura Judge0 para ejecutar el código del estudiante contra test cases reales. ' .
        'Obtén tu API key en <a href="https://rapidapi.com/judge0-official/api/judge0-ce" target="_blank">RapidAPI Judge0</a>.'
    ));

    $settings->add(new admin_setting_configtext(
        'mod_aiassignment/judge0_api_key',
        'Judge0 API Key',
        'Clave API de Judge0 (RapidAPI). Deja vacío para usar modo demo.',
        '',
        PARAM_TEXT
    ));

    $settings->add(new admin_setting_configtext(
        'mod_aiassignment/judge0_api_url',
        'Judge0 API URL',
        'URL base de la API de Judge0.',
        'https://judge0-ce.p.rapidapi.com',
        PARAM_URL
    ));

    $settings->add(new admin_setting_configtext(
        'mod_aiassignment/judge0_api_host',
        'Judge0 API Host',
        'Host de la API de Judge0 para RapidAPI.',
        'judge0-ce.p.rapidapi.com',
        PARAM_TEXT
    ));

    $settings->add(new admin_setting_configcheckbox(
        'mod_aiassignment/run_code_on_submit',
        'Ejecutar código al enviar',
        'Si está activo, el código del estudiante se ejecuta automáticamente contra los test cases al enviar.',
        0
    ));
}
