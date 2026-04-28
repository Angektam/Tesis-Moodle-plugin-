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
        // Agregar campos de pesos de rúbrica
        $rubric_fields = [
            'rubric_funcionalidad' => '40',
            'rubric_estilo'        => '20',
            'rubric_eficiencia'    => '20',
            'rubric_documentacion' => '20',
        ];
        foreach ($rubric_fields as $fname => $default) {
            $rf = new xmldb_field($fname, XMLDB_TYPE_INTEGER, '3', null, XMLDB_NOTNULL, null, $default);
            if (!$dbman->field_exists($table, $rf)) {
                $dbman->add_field($table, $rf);
            }
        }
        upgrade_mod_savepoint(true, 2026042500, 'aiassignment');
    }

    if ($oldversion < 2026042800) {
        // v2.4.0: Tabla de versiones de submissions (mejora #7)
        $table = new xmldb_table('aiassignment_sub_versions');
        if (!$dbman->table_exists($table)) {
            $table->add_field('id', XMLDB_TYPE_INTEGER, '10', null, XMLDB_NOTNULL, XMLDB_SEQUENCE);
            $table->add_field('submission_id', XMLDB_TYPE_INTEGER, '10', null, XMLDB_NOTNULL, null, '0');
            $table->add_field('userid', XMLDB_TYPE_INTEGER, '10', null, XMLDB_NOTNULL, null, '0');
            $table->add_field('answer', XMLDB_TYPE_TEXT, null, null, XMLDB_NOTNULL);
            $table->add_field('score', XMLDB_TYPE_NUMBER, '5', 2);
            $table->add_field('feedback', XMLDB_TYPE_TEXT);
            $table->add_field('status', XMLDB_TYPE_CHAR, '20', null, XMLDB_NOTNULL, null, 'pending');
            $table->add_field('attempt', XMLDB_TYPE_INTEGER, '6', null, XMLDB_NOTNULL, null, '1');
            $table->add_field('reason', XMLDB_TYPE_CHAR, '50', null, XMLDB_NOTNULL, null, 'resubmit');
            $table->add_field('timecreated', XMLDB_TYPE_INTEGER, '10', null, XMLDB_NOTNULL, null, '0');
            $table->add_key('primary', XMLDB_KEY_PRIMARY, ['id']);
            $table->add_key('submission_id', XMLDB_KEY_FOREIGN, ['submission_id'], 'aiassignment_submissions', ['id']);
            $table->add_index('sub_time', XMLDB_INDEX_NOTUNIQUE, ['submission_id', 'timecreated']);
            $dbman->create_table($table);
        }

        // v2.4.0: Tabla de auditoría (mejora #12)
        $table2 = new xmldb_table('aiassignment_audit_log');
        if (!$dbman->table_exists($table2)) {
            $table2->add_field('id', XMLDB_TYPE_INTEGER, '10', null, XMLDB_NOTNULL, XMLDB_SEQUENCE);
            $table2->add_field('action', XMLDB_TYPE_CHAR, '50', null, XMLDB_NOTNULL);
            $table2->add_field('userid', XMLDB_TYPE_INTEGER, '10', null, XMLDB_NOTNULL, null, '0');
            $table2->add_field('targetid', XMLDB_TYPE_INTEGER, '10', null, XMLDB_NOTNULL, null, '0');
            $table2->add_field('targettype', XMLDB_TYPE_CHAR, '30', null, XMLDB_NOTNULL, null, 'submission');
            $table2->add_field('ip', XMLDB_TYPE_CHAR, '45');
            $table2->add_field('data', XMLDB_TYPE_TEXT);
            $table2->add_field('timecreated', XMLDB_TYPE_INTEGER, '10', null, XMLDB_NOTNULL, null, '0');
            $table2->add_key('primary', XMLDB_KEY_PRIMARY, ['id']);
            $table2->add_index('target', XMLDB_INDEX_NOTUNIQUE, ['targetid', 'targettype']);
            $table2->add_index('action_time', XMLDB_INDEX_NOTUNIQUE, ['action', 'timecreated']);
            $table2->add_index('userid_time', XMLDB_INDEX_NOTUNIQUE, ['userid', 'timecreated']);
            $dbman->create_table($table2);
        }

        upgrade_mod_savepoint(true, 2026042800, 'aiassignment');
    }

    return true;
}
