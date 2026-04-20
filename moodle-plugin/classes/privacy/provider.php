<?php
// This file is part of Moodle - http://moodle.org/

namespace mod_aiassignment\privacy;

use core_privacy\local\metadata\collection;
use core_privacy\local\request\approved_contextlist;
use core_privacy\local\request\approved_userlist;
use core_privacy\local\request\contextlist;
use core_privacy\local\request\deletion_criteria;
use core_privacy\local\request\helper;
use core_privacy\local\request\userlist;
use core_privacy\local\request\writer;

defined('MOODLE_INTERNAL') || die();

/**
 * Privacy Subsystem implementation for mod_aiassignment.
 * Cumplimiento con GDPR y regulaciones de privacidad.
 */
class provider implements
    \core_privacy\local\metadata\provider,
    \core_privacy\local\request\plugin\provider,
    \core_privacy\local\request\core_userlist_provider {

    /**
     * Retorna metadatos sobre los datos de usuario almacenados.
     *
     * @param collection $collection La colección de metadatos
     * @return collection La colección actualizada
     */
    public static function get_metadata(collection $collection): collection {
        
        // Tabla aiassignment_submissions
        $collection->add_database_table(
            'aiassignment_submissions',
            [
                'userid' => 'privacy:metadata:aiassignment_submissions:userid',
                'answer' => 'privacy:metadata:aiassignment_submissions:answer',
                'status' => 'privacy:metadata:aiassignment_submissions:status',
                'score' => 'privacy:metadata:aiassignment_submissions:score',
                'feedback' => 'privacy:metadata:aiassignment_submissions:feedback',
                'attempt' => 'privacy:metadata:aiassignment_submissions:attempt',
                'timecreated' => 'privacy:metadata:aiassignment_submissions:timecreated',
                'timemodified' => 'privacy:metadata:aiassignment_submissions:timemodified',
            ],
            'privacy:metadata:aiassignment_submissions'
        );

        // Tabla aiassignment_evaluations
        $collection->add_database_table(
            'aiassignment_evaluations',
            [
                'similarity_score' => 'privacy:metadata:aiassignment_evaluations:similarity_score',
                'ai_feedback' => 'privacy:metadata:aiassignment_evaluations:ai_feedback',
                'ai_analysis' => 'privacy:metadata:aiassignment_evaluations:ai_analysis',
                'timecreated' => 'privacy:metadata:aiassignment_evaluations:timecreated',
            ],
            'privacy:metadata:aiassignment_evaluations'
        );

        // Subsistema de calificaciones
        $collection->add_subsystem_link(
            'core_grades',
            [],
            'privacy:metadata:core_grades'
        );

        // Servicio externo: OpenAI
        $collection->add_external_location_link(
            'openai',
            [
                'answer' => 'privacy:metadata:openai:answer',
                'solution' => 'privacy:metadata:openai:solution',
            ],
            'privacy:metadata:openai'
        );

        return $collection;
    }

    /**
     * Obtiene la lista de contextos que contienen datos de usuario.
     *
     * @param int $userid El ID del usuario
     * @return contextlist La lista de contextos
     */
    public static function get_contexts_for_userid(int $userid): contextlist {
        $sql = "SELECT c.id
                FROM {context} c
                INNER JOIN {course_modules} cm ON cm.id = c.instanceid AND c.contextlevel = :contextlevel
                INNER JOIN {modules} m ON m.id = cm.module AND m.name = :modname
                INNER JOIN {aiassignment} a ON a.id = cm.instance
                INNER JOIN {aiassignment_submissions} s ON s.assignment = a.id
                WHERE s.userid = :userid";

        $params = [
            'modname' => 'aiassignment',
            'contextlevel' => CONTEXT_MODULE,
            'userid' => $userid,
        ];

        $contextlist = new contextlist();
        $contextlist->add_from_sql($sql, $params);

        return $contextlist;
    }

    /**
     * Obtiene la lista de usuarios en un contexto.
     *
     * @param userlist $userlist La lista de usuarios
     */
    public static function get_users_in_context(userlist $userlist) {
        $context = $userlist->get_context();

        if (!$context instanceof \context_module) {
            return;
        }

        $sql = "SELECT s.userid
                FROM {course_modules} cm
                JOIN {modules} m ON m.id = cm.module AND m.name = :modname
                JOIN {aiassignment} a ON a.id = cm.instance
                JOIN {aiassignment_submissions} s ON s.assignment = a.id
                WHERE cm.id = :cmid";

        $params = [
            'cmid' => $context->instanceid,
            'modname' => 'aiassignment',
        ];

        $userlist->add_from_sql('userid', $sql, $params);
    }

    /**
     * Exporta todos los datos de usuario para los contextos aprobados.
     *
     * @param approved_contextlist $contextlist La lista de contextos aprobados
     */
    public static function export_user_data(approved_contextlist $contextlist) {
        global $DB;

        if (empty($contextlist->count())) {
            return;
        }

        $user = $contextlist->get_user();

        list($contextsql, $contextparams) = $DB->get_in_or_equal($contextlist->get_contextids(), SQL_PARAMS_NAMED);

        $sql = "SELECT cm.id AS cmid,
                       s.id as submissionid,
                       s.answer,
                       s.status,
                       s.score,
                       s.feedback,
                       s.attempt,
                       s.timecreated,
                       s.timemodified,
                       a.name as assignmentname
                FROM {context} c
                INNER JOIN {course_modules} cm ON cm.id = c.instanceid AND c.contextlevel = :contextlevel
                INNER JOIN {modules} m ON m.id = cm.module AND m.name = :modname
                INNER JOIN {aiassignment} a ON a.id = cm.instance
                INNER JOIN {aiassignment_submissions} s ON s.assignment = a.id
                WHERE c.id {$contextsql}
                  AND s.userid = :userid
                ORDER BY cm.id, s.timecreated";

        $params = [
            'modname' => 'aiassignment',
            'contextlevel' => CONTEXT_MODULE,
            'userid' => $user->id,
        ] + $contextparams;

        $submissions = $DB->get_recordset_sql($sql, $params);

        foreach ($submissions as $submission) {
            $context = \context_module::instance($submission->cmid);
            
            $data = (object) [
                'assignment' => $submission->assignmentname,
                'answer' => $submission->answer,
                'status' => $submission->status,
                'score' => $submission->score,
                'feedback' => $submission->feedback,
                'attempt' => $submission->attempt,
                'timecreated' => \core_privacy\local\request\transform::datetime($submission->timecreated),
                'timemodified' => \core_privacy\local\request\transform::datetime($submission->timemodified),
            ];

            // Obtener evaluación de IA si existe
            $evaluation = $DB->get_record('aiassignment_evaluations', 
                ['submission' => $submission->submissionid]);
            
            if ($evaluation) {
                $data->ai_evaluation = (object) [
                    'similarity_score' => $evaluation->similarity_score,
                    'ai_feedback' => $evaluation->ai_feedback,
                    'ai_analysis' => $evaluation->ai_analysis,
                    'timecreated' => \core_privacy\local\request\transform::datetime($evaluation->timecreated),
                ];
            }

            writer::with_context($context)->export_data(
                [get_string('submissions', 'mod_aiassignment'), $submission->submissionid],
                $data
            );
        }

        $submissions->close();
    }

    /**
     * Elimina todos los datos de usuario para los contextos aprobados.
     *
     * @param approved_contextlist $contextlist La lista de contextos aprobados
     */
    public static function delete_data_for_all_users_in_context(\context $context) {
        global $DB;

        if (!$context instanceof \context_module) {
            return;
        }

        $cm = get_coursemodule_from_id('aiassignment', $context->instanceid);
        if (!$cm) {
            return;
        }

        $aiassignment = $DB->get_record('aiassignment', ['id' => $cm->instance]);
        if (!$aiassignment) {
            return;
        }

        // Obtener todos los envíos
        $submissions = $DB->get_records('aiassignment_submissions', 
            ['assignment' => $aiassignment->id], '', 'id');

        if ($submissions) {
            $submissionids = array_keys($submissions);
            
            // Eliminar evaluaciones
            list($insql, $inparams) = $DB->get_in_or_equal($submissionids, SQL_PARAMS_NAMED);
            $DB->delete_records_select('aiassignment_evaluations', 
                "submission $insql", $inparams);
            
            // Eliminar envíos
            $DB->delete_records('aiassignment_submissions', 
                ['assignment' => $aiassignment->id]);
        }
    }

    /**
     * Elimina todos los datos de usuario para el usuario especificado.
     *
     * @param approved_contextlist $contextlist La lista de contextos aprobados
     */
    public static function delete_data_for_user(approved_contextlist $contextlist) {
        global $DB;

        if (empty($contextlist->count())) {
            return;
        }

        $userid = $contextlist->get_user()->id;

        foreach ($contextlist->get_contexts() as $context) {
            if (!$context instanceof \context_module) {
                continue;
            }

            $cm = get_coursemodule_from_id('aiassignment', $context->instanceid);
            if (!$cm) {
                continue;
            }

            $aiassignment = $DB->get_record('aiassignment', ['id' => $cm->instance]);
            if (!$aiassignment) {
                continue;
            }

            // Obtener envíos del usuario
            $submissions = $DB->get_records('aiassignment_submissions', [
                'assignment' => $aiassignment->id,
                'userid' => $userid
            ], '', 'id');

            if ($submissions) {
                $submissionids = array_keys($submissions);
                
                // Eliminar evaluaciones
                list($insql, $inparams) = $DB->get_in_or_equal($submissionids, SQL_PARAMS_NAMED);
                $DB->delete_records_select('aiassignment_evaluations', 
                    "submission $insql", $inparams);
                
                // Eliminar envíos
                $DB->delete_records('aiassignment_submissions', [
                    'assignment' => $aiassignment->id,
                    'userid' => $userid
                ]);
            }
        }
    }

    /**
     * Elimina datos para múltiples usuarios en un contexto.
     *
     * @param approved_userlist $userlist La lista de usuarios aprobados
     */
    public static function delete_data_for_users(approved_userlist $userlist) {
        global $DB;

        $context = $userlist->get_context();

        if (!$context instanceof \context_module) {
            return;
        }

        $cm = get_coursemodule_from_id('aiassignment', $context->instanceid);
        if (!$cm) {
            return;
        }

        $aiassignment = $DB->get_record('aiassignment', ['id' => $cm->instance]);
        if (!$aiassignment) {
            return;
        }

        $userids = $userlist->get_userids();

        foreach ($userids as $userid) {
            // Obtener envíos del usuario
            $submissions = $DB->get_records('aiassignment_submissions', [
                'assignment' => $aiassignment->id,
                'userid' => $userid
            ], '', 'id');

            if ($submissions) {
                $submissionids = array_keys($submissions);
                
                // Eliminar evaluaciones
                list($insql, $inparams) = $DB->get_in_or_equal($submissionids, SQL_PARAMS_NAMED);
                $DB->delete_records_select('aiassignment_evaluations', 
                    "submission $insql", $inparams);
                
                // Eliminar envíos
                $DB->delete_records('aiassignment_submissions', [
                    'assignment' => $aiassignment->id,
                    'userid' => $userid
                ]);
            }
        }
    }
}
