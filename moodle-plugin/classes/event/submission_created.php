<?php
// This file is part of Moodle - http://moodle.org/

namespace mod_aiassignment\event;

defined('MOODLE_INTERNAL') || die();

/**
 * Evento cuando se crea un envío
 */
class submission_created extends \core\event\base {

    /**
     * Inicializar el evento
     */
    protected function init() {
        $this->data['objecttable'] = 'aiassignment_submissions';
        $this->data['crud'] = 'c';
        $this->data['edulevel'] = self::LEVEL_PARTICIPATING;
    }

    /**
     * Obtener el nombre del evento
     *
     * @return string
     */
    public static function get_name() {
        return get_string('eventsubmissioncreated', 'mod_aiassignment');
    }

    /**
     * Obtener la descripción del evento
     *
     * @return string
     */
    public function get_description() {
        return "The user with id '$this->relateduserid' created a submission with id '$this->objectid' " .
            "for the AI assignment activity with course module id '$this->contextinstanceid'.";
    }

    /**
     * Obtener la URL relacionada
     *
     * @return \moodle_url
     */
    public function get_url() {
        return new \moodle_url('/mod/aiassignment/submission.php', array('id' => $this->objectid));
    }

    /**
     * Mapeo personalizado
     *
     * @return array
     */
    public static function get_objectid_mapping() {
        return array('db' => 'aiassignment_submissions', 'restore' => 'aiassignment_submission');
    }
}
