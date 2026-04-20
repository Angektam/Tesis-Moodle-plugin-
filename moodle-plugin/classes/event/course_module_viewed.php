<?php
// This file is part of Moodle - http://moodle.org/

namespace mod_aiassignment\event;

defined('MOODLE_INTERNAL') || die();

/**
 * Evento cuando se ve el módulo
 */
class course_module_viewed extends \core\event\course_module_viewed {

    /**
     * Inicializar el evento
     */
    protected function init() {
        $this->data['objecttable'] = 'aiassignment';
        $this->data['crud'] = 'r';
        $this->data['edulevel'] = self::LEVEL_PARTICIPATING;
    }

    /**
     * Obtener el nombre del evento
     *
     * @return string
     */
    public static function get_name() {
        return get_string('eventcoursemoduleviewed', 'mod_aiassignment');
    }

    /**
     * Obtener la descripción del evento
     *
     * @return string
     */
    public function get_description() {
        return "The user with id '$this->userid' viewed the AI assignment activity with " .
            "course module id '$this->contextinstanceid'.";
    }

    /**
     * Obtener la URL relacionada
     *
     * @return \moodle_url
     */
    public function get_url() {
        return new \moodle_url('/mod/aiassignment/view.php', array('id' => $this->contextinstanceid));
    }

    /**
     * Mapeo personalizado
     *
     * @return array
     */
    public static function get_objectid_mapping() {
        return array('db' => 'aiassignment', 'restore' => 'aiassignment');
    }
}
