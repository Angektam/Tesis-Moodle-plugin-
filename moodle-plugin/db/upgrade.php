<?php
// This file is part of Moodle - http://moodle.org/

defined('MOODLE_INTERNAL') || die();

function xmldb_aiassignment_upgrade($oldversion) {
    global $DB;
    $dbman = $DB->get_manager();

    if ($oldversion < 2026041501) {
        $table_subs = new xmldb_table('aiassignment_submissions');
        $table_eval = new xmldb_table('aiassignment_evaluations');
        $table_main = new xmldb_table('aiassignment');

        // Índices en aiassignment_submissions
        $indexes = [
            new xmldb_index('assignment_status',  XMLDB_INDEX_NOTUNIQUE, ['assignment', 'status']),
            new xmldb_index('assignment_score',   XMLDB_INDEX_NOTUNIQUE, ['assignment', 'score']),
            new xmldb_index('userid_assignment',  XMLDB_INDEX_NOTUNIQUE, ['userid', 'assignment']),
            new xmldb_index('score_idx',          XMLDB_INDEX_NOTUNIQUE, ['score']),
            new xmldb_index('timecreated_idx',    XMLDB_INDEX_NOTUNIQUE, ['timecreated']),
        ];
        foreach ($indexes as $idx) {
            if (!$dbman->index_exists($table_subs, $idx)) {
                $dbman->add_index($table_subs, $idx);
            }
        }

        // Índice compuesto en aiassignment_evaluations
        $idx_eval = new xmldb_index('sim_score_not_null', XMLDB_INDEX_NOTUNIQUE,
            ['submission', 'similarity_score']);
        if (!$dbman->index_exists($table_eval, $idx_eval)) {
            $dbman->add_index($table_eval, $idx_eval);
        }

        // Índice en aiassignment.course
        $idx_course = new xmldb_index('course_idx', XMLDB_INDEX_NOTUNIQUE, ['course']);
        if (!$dbman->index_exists($table_main, $idx_course)) {
            $dbman->add_index($table_main, $idx_course);
        }

        upgrade_mod_savepoint(true, 2026041501, 'aiassignment');
    }

    if ($oldversion < 2026042004) {
        // v2.3.0: Tablas para encuestas, peer review
        $tables = [
            'aiassignment_sus_surveys' => [
                ['id', XMLDB_TYPE_INTEGER, '10', null, XMLDB_NOTNULL, XMLDB_SEQUENCE],
                ['userid', XMLDB_TYPE_INTEGER, '10', null, XMLDB_NOTNULL, null, '0'],
                ['cmid', XMLDB_TYPE_INTEGER, '10', null, XMLDB_NOTNULL, null, '0'],
                ['responses', XMLDB_TYPE_TEXT, null, null, null],
                ['sus_score', XMLDB_TYPE_NUMBER, '5', 2, null],
                ['timecreated', XMLDB_TYPE_INTEGER, '10', null, XMLDB_NOTNULL, null, '0'],
            ],
            'aiassignment_satisfaction' => [
                ['id', XMLDB_TYPE_INTEGER, '10', null, XMLDB_NOTNULL, XMLDB_SEQUENCE],
                ['userid', XMLDB_TYPE_INTEGER, '10', null, XMLDB_NOTNULL, null, '0'],
                ['cmid', XMLDB_TYPE_INTEGER, '10', null, XMLDB_NOTNULL, null, '0'],
                ['submissionid', XMLDB_TYPE_INTEGER, '10', null, XMLDB_NOTNULL, null, '0'],
                ['rating', XMLDB_TYPE_INTEGER, '1', null, XMLDB_NOTNULL, null, '0'],
                ['difficulty', XMLDB_TYPE_INTEGER, '1', null, XMLDB_NOTNULL, null, '3'],
                ['comment', XMLDB_TYPE_TEXT, null, null, null],
                ['timecreated', XMLDB_TYPE_INTEGER, '10', null, XMLDB_NOTNULL, null, '0'],
            ],
            'aiassignment_peer_reviews' => [
                ['id', XMLDB_TYPE_INTEGER, '10', null, XMLDB_NOTNULL, XMLDB_SEQUENCE],
                ['reviewer_id', XMLDB_TYPE_INTEGER, '10', null, XMLDB_NOTNULL, null, '0'],
                ['submission_id', XMLDB_TYPE_INTEGER, '10', null, XMLDB_NOTNULL, null, '0'],
                ['score', XMLDB_TYPE_NUMBER, '5', 2, null],
                ['feedback', XMLDB_TYPE_TEXT, null, null, null],
                ['timecreated', XMLDB_TYPE_INTEGER, '10', null, XMLDB_NOTNULL, null, '0'],
            ],
        ];

        foreach ($tables as $tablename => $fields) {
            $table = new xmldb_table($tablename);
            if (!$dbman->table_exists($table)) {
                foreach ($fields as $f) {
                    $table->add_field(...$f);
                }
                $table->add_key('primary', XMLDB_KEY_PRIMARY, ['id']);
                $dbman->create_table($table);
            }
        }

        upgrade_mod_savepoint(true, 2026042004, 'aiassignment');
    }

    if ($oldversion < 2026042500) {
        // v2.3.0: Agregar columna exam_mode_local a aiassignment si no existe
        $table = new xmldb_table('aiassignment');
        $field = new xmldb_field('exam_mode_local', XMLDB_TYPE_INTEGER, '1', null, XMLDB_NOTNULL, null, '0');
        if (!$dbman->field_exists($table, $field)) {
            $dbman->add_field($table, $field);
        }
        // Agregar columna use_rubric
        $field2 = new xmldb_field('use_rubric', XMLDB_TYPE_INTEGER, '1', null, XMLDB_NOTNULL, null, '0');
        if (!$dbman->field_exists($table, $field2)) {
            $dbman->add_field($table, $field2);
        }
        upgrade_mod_savepoint(true, 2026042500, 'aiassignment');
    }

    return true;
}
