<?php
// This file is part of Moodle - http://moodle.org/

defined('MOODLE_INTERNAL') || die();

require_once($CFG->dirroot.'/course/moodleform_mod.php');

/**
 * Formulario de configuración del módulo
 */
class mod_aiassignment_mod_form extends moodleform_mod {

    /**
     * Define el formulario
     */
    public function definition() {
        global $CFG;

        $mform = $this->_form;

        // Sección general
        $mform->addElement('header', 'general', get_string('general', 'form'));

        // Nombre de la actividad
        $mform->addElement('text', 'name', get_string('assignmentname', 'aiassignment'), array('size' => '64'));
        if (!empty($CFG->formatstringstriptags)) {
            $mform->setType('name', PARAM_TEXT);
        } else {
            $mform->setType('name', PARAM_CLEANHTML);
        }
        $mform->addRule('name', null, 'required', null, 'client');
        $mform->addRule('name', get_string('maximumchars', '', 255), 'maxlength', 255, 'client');

        // Descripción (intro estándar de Moodle)
        $this->standard_intro_elements();

        // Tipo de problema
        $mform->addElement('header', 'problemsettings', get_string('problemsettings', 'aiassignment'));
        
        $types = array(
            'math' => get_string('math', 'aiassignment'),
            'programming' => get_string('programming', 'aiassignment')
        );
        $mform->addElement('select', 'type', get_string('problemtype', 'aiassignment'), $types);
        $mform->setType('type', PARAM_ALPHA);
        $mform->setDefault('type', 'math');
        $mform->addRule('type', null, 'required', null, 'client');
        $mform->addHelpButton('type', 'problemtype', 'aiassignment');

        // Solución de referencia
        $mform->addElement('textarea', 'solution', get_string('solution', 'aiassignment'),
            'wrap="virtual" rows="10" cols="80"');
        $mform->setType('solution', PARAM_RAW);
        $mform->addRule('solution', null, 'required', null, 'client');
        $mform->addHelpButton('solution', 'solution', 'aiassignment');

        // Documentación adicional
        $mform->addElement('textarea', 'documentation', get_string('documentation', 'aiassignment'),
            'wrap="virtual" rows="5" cols="80"');
        $mform->setType('documentation', PARAM_RAW);
        $mform->addHelpButton('documentation', 'documentation', 'aiassignment');

        // Casos de prueba
        $mform->addElement('textarea', 'test_cases', get_string('testcases', 'aiassignment'),
            'wrap="virtual" rows="5" cols="80"');
        $mform->setType('test_cases', PARAM_RAW);
        $mform->addHelpButton('test_cases', 'testcases', 'aiassignment');

        // Configuración de calificación
        $mform->addElement('header', 'gradesettings', get_string('gradesettings', 'aiassignment'));
        
        $this->standard_grading_coursemodule_elements();

        // Configuración de intentos
        $mform->addElement('text', 'maxattempts', get_string('maxattempts', 'aiassignment'), array('size' => '6'));
        $mform->setType('maxattempts', PARAM_INT);
        $mform->setDefault('maxattempts', 0);
        $mform->addRule('maxattempts', null, 'numeric', null, 'client');
        $mform->addHelpButton('maxattempts', 'maxattempts', 'aiassignment');

        // ── Rúbrica personalizable ────────────────────────────────────
        $mform->addElement('header', 'rubricsettings', '📋 Rúbrica de evaluación (opcional)');
        $mform->addElement('advcheckbox', 'use_rubric', 'Usar rúbrica personalizada',
            'Evalúa con criterios ponderados en lugar de un score único');
        $mform->setDefault('use_rubric', 0);

        // Pesos de la rúbrica (solo visibles si use_rubric está activo)
        $rubric_fields = [
            'rubric_funcionalidad' => ['Funcionalidad (%)', 40],
            'rubric_estilo'        => ['Estilo y claridad (%)', 20],
            'rubric_eficiencia'    => ['Eficiencia (%)', 20],
            'rubric_documentacion' => ['Documentación (%)', 20],
        ];
        foreach ($rubric_fields as $field => [$label, $default]) {
            $mform->addElement('text', $field, $label, ['size' => '5']);
            $mform->setType($field, PARAM_INT);
            $mform->setDefault($field, $default);
            $mform->hideIf($field, 'use_rubric', 'notchecked');
        }

        // ── Modo examen por tarea ─────────────────────────────────────
        $mform->addElement('header', 'examsettings', '🔒 Configuración de examen');
        $mform->addElement('advcheckbox', 'exam_mode_local', 'Modo examen para esta tarea',
            'Detecta cambios de pestaña y restringe copiar/pegar');
        $mform->setDefault('exam_mode_local', 0);

        // Elementos estándar
        $this->standard_coursemodule_elements();

        // Botones
        $this->add_action_buttons();
    }

    /**
     * Validación personalizada del formulario
     *
     * @param array $data
     * @param array $files
     * @return array errores
     */
    public function validation($data, $files) {
        $errors = parent::validation($data, $files);

        // Validar nombre (evitar solo espacios en blanco).
        if (isset($data['name']) && trim($data['name']) === '') {
            $errors['name'] = get_string('required');
        }

        // Validar solución de referencia.
        if (empty(trim($data['solution']))) {
            $errors['solution'] = get_string('required');
        }

        // Validar tipo de problema (debe estar seleccionado).
        if (empty($data['type'])) {
            $errors['type'] = get_string('required');
        }

        // Validar intentos máximos (entero >= 0).
        if ($data['maxattempts'] !== '' && isset($data['maxattempts']) && $data['maxattempts'] < 0) {
            $errors['maxattempts'] = get_string('err_numeric', 'form');
        }

        return $errors;
    }
}
