<?php
// This file is part of Moodle - http://moodle.org/

require_once('../../config.php');
require_once($CFG->dirroot.'/mod/aiassignment/lib.php');

$id = required_param('id', PARAM_INT); // Course ID

$course = $DB->get_record('course', array('id' => $id), '*', MUST_EXIST);

require_login($course);
$PAGE->set_url('/mod/aiassignment/index.php', array('id' => $id));
$PAGE->set_title(format_string($course->fullname));
$PAGE->set_heading(format_string($course->fullname));
$PAGE->set_context(context_course::instance($course->id));
$PAGE->set_pagelayout('incourse');

echo $OUTPUT->header();
echo $OUTPUT->heading(get_string('modulenameplural', 'aiassignment'));

// Obtener todas las instancias de AI Assignment en este curso
$aiassignments = $DB->get_records('aiassignment', array('course' => $course->id), 'name');

if (!$aiassignments) {
    notice(get_string('thereareno', 'moodle', get_string('modulenameplural', 'aiassignment')),
        new moodle_url('/course/view.php', array('id' => $course->id)));
    exit;
}

// Crear tabla
$table = new html_table();
$table->attributes['class'] = 'generaltable mod_index';

$table->head = array(
    get_string('name'),
    get_string('type', 'aiassignment'),
    get_string('submissions', 'aiassignment')
);
$table->align = array('left', 'left', 'center');

foreach ($aiassignments as $aiassignment) {
    $cm = get_coursemodule_from_instance('aiassignment', $aiassignment->id);
    
    // Contar envíos
    $submissioncount = $DB->count_records('aiassignment_submissions', 
        array('assignment' => $aiassignment->id));
    
    // Nombre con enlace
    $name = html_writer::link(
        new moodle_url('/mod/aiassignment/view.php', array('id' => $cm->id)),
        format_string($aiassignment->name)
    );
    
    // Tipo
    $type = get_string($aiassignment->type, 'aiassignment');
    
    $table->data[] = array($name, $type, $submissioncount);
}

echo html_writer::table($table);
echo $OUTPUT->footer();
