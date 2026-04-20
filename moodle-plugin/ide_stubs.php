<?php
// This file is part of Moodle - http://moodle.org/
//
// STUBS ONLY - For Intelephense/IDE. Do not require this file from Moodle.
// Moodle provides these at runtime via config.php. This file exists so the
// language server recognizes Moodle API when the Moodle root is not in the workspace.
//
// When running inside Moodle, MOODLE_INTERNAL is defined and the block below is skipped.

if (defined('MOODLE_INTERNAL')) {
    return;
}

// ---------------------------------------------------------------------------
// Constants (so IDE knows PARAM_*, MUST_EXIST, etc.)
// ---------------------------------------------------------------------------
if (!defined('PARAM_INT')) {
    define('PARAM_INT', 'int');
}
if (!defined('PARAM_RAW')) {
    define('PARAM_RAW', 'raw');
}
if (!defined('PARAM_TEXT')) {
    define('PARAM_TEXT', 'text');
}
if (!defined('PARAM_ALPHA')) {
    define('PARAM_ALPHA', 'alpha');
}
if (!defined('MUST_EXIST')) {
    define('MUST_EXIST', 1);
}
if (!defined('IGNORE_MISSING')) {
    define('IGNORE_MISSING', 0);
}

// ---------------------------------------------------------------------------
// Global objects (type hints for IDE)
// ---------------------------------------------------------------------------
/** @var \moodle_database $DB */
global $DB;
/** @var \core_renderer $OUTPUT */
global $OUTPUT;
/** @var \moodle_page $PAGE */
global $PAGE;
/** @var \stdClass $USER */
global $USER;
/** @var \stdClass $CFG */
global $CFG;
/** @var \stdClass $COURSE */
global $COURSE;

// ---------------------------------------------------------------------------
// Functions
// ---------------------------------------------------------------------------
if (!function_exists('optional_param')) {
    /** @param string $parname @param mixed $default @param int|string $type @return mixed */
    function optional_param($parname, $default, $type) {
        return $default;
    }
}
if (!function_exists('required_param')) {
    /** @param string $parname @param int|string $type @return mixed */
    function required_param($parname, $type) {
        return null;
    }
}
if (!function_exists('get_coursemodule_from_id')) {
    /** @return \stdClass */
    function get_coursemodule_from_id($modname, $cmid, $courseid, $add, $strictness) {
        return new \stdClass();
    }
}
if (!function_exists('get_coursemodule_from_instance')) {
    /** @return \stdClass */
    function get_coursemodule_from_instance($modname, $instanceid, $courseid, $add, $strictness) {
        return new \stdClass();
    }
}
if (!function_exists('require_login')) {
    /** @param \stdClass|null $course @param bool $autologinguest @param \stdClass|null $cm */
    function require_login($course = null, $autologinguest = true, $cm = null, $setwantsurltome = true, $preferredirect = true) {}
}
if (!function_exists('format_string')) {
    /** @return string */
    function format_string($string, $striplinks = true, $options = []) {
        return (string) $string;
    }
}
if (!function_exists('has_capability')) {
    /** @return bool */
    function has_capability($capability, $context, $user = null, $doanything = true) {
        return false;
    }
}
if (!function_exists('get_string')) {
    /** @return string */
    function get_string($identifier, $component = 'moodle', $a = null) {
        return (string) $identifier;
    }
}
if (!function_exists('format_module_intro')) {
    /** @return string */
    function format_module_intro($modname, $mod, $cmid) {
        return '';
    }
}
if (!function_exists('s')) {
    /** @return string */
    function s($string) {
        return (string) $string;
    }
}
if (!function_exists('sesskey')) {
    /** @return string */
    function sesskey() {
        return '';
    }
}
if (!function_exists('userdate')) {
    /** @return string */
    function userdate($timestamp, $format = '', $timezone = 99) {
        return '';
    }
}
if (!function_exists('redirect')) {
    /** @param \moodle_url|string $url @param \lang_string|string|null $message */
    function redirect($url, $message = '', $delay = null, $type = null) {}
}
if (!function_exists('debugging')) {
    /** @param string $message @param int $level */
    function debugging($message, $level = 1, $backtrace = null) {}
}

// ---------------------------------------------------------------------------
// Classes (minimal stubs so IDE recognizes types)
// ---------------------------------------------------------------------------
if (!class_exists('context_module', false)) {
    class context_module {
        /** @return \stdClass */
        public static function instance($cmid) {
            return new \stdClass();
        }
    }
}
if (!class_exists('moodle_url', false)) {
    class moodle_url {
        /** @param string $url @param array|null $params @param string|null $anchor */
        public function __construct($url, $params = null, $anchor = null) {}
    }
}
if (!class_exists('html_writer', false)) {
    class html_writer {
        /** @return string */
        public static function start_div($class = null, $attributes = []) {
            return '';
        }
        /** @return string */
        public static function end_div() {
            return '';
        }
        /** @return string */
        public static function link($url, $text, $attributes = []) {
            return '';
        }
        /** @return string */
        public static function tag($tagname, $contents = '', $attributes = null) {
            return '';
        }
    }
}
