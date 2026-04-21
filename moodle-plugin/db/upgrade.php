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

    if ($oldversion < 2026042003) {
        // v2.1.0: Tabla de notificaciones en tiempo real
        $table = new xmldb_table('aiassignment_notifications');
        if (!$dbman->table_exists($table)) {
            $table->add_field('id',          XMLDB_TYPE_INTEGER, '10', null, XMLDB_NOTNULL, XMLDB_SEQUENCE);
            $table->add_field('userid',      XMLDB_TYPE_INTEGER, '10', null, XMLDB_NOTNULL, null, '0');
            $table->add_field('type',        XMLDB_TYPE_CHAR,    '50', null, XMLDB_NOTNULL);
            $table->add_field('payload',     XMLDB_TYPE_TEXT,    null, null, null);
            $table->add_field('seen',        XMLDB_TYPE_INTEGER, '1',  null, XMLDB_NOTNULL, null, '0');
            $table->add_field('timecreated', XMLDB_TYPE_INTEGER, '10', null, XMLDB_NOTNULL, null, '0');
            $table->add_key('primary', XMLDB_KEY_PRIMARY, ['id']);
            $table->add_index('userid_seen', XMLDB_INDEX_NOTUNIQUE, ['userid', 'seen']);
            $table->add_index('timecreated', XMLDB_INDEX_NOTUNIQUE, ['timecreated']);
            $dbman->create_table($table);
        }
        upgrade_mod_savepoint(true, 2026042003, 'aiassignment');
    }

    return true;
}
