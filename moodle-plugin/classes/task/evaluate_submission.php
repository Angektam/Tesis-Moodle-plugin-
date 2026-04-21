<?php
// This file is part of Moodle - http://moodle.org/

namespace mod_aiassignment\task;

defined('MOODLE_INTERNAL') || die();

/**
 * Tarea asíncrona para evaluar envíos con IA en background.
 * Mejora #2: Evaluación asíncrona — el estudiante no espera bloqueado.
 */
class evaluate_submission extends \core\task\adhoc_task {

    public function get_name() {
        return 'Evaluar envío con IA';
    }

    public function execute() {
        global $DB;

        $data = $this->get_custom_data();
        $submissionid = $data->submissionid;

        $submission = $DB->get_record('aiassignment_submissions',
            ['id' => $submissionid], '*', IGNORE_MISSING);

        if (!$submission || $submission->status !== 'pending') {
            mtrace("Envío $submissionid no encontrado o ya evaluado.");
            return;
        }

        $aiassignment = $DB->get_record('aiassignment',
            ['id' => $submission->assignment], '*', MUST_EXIST);

        try {
            $evaluation = \mod_aiassignment\ai_evaluator::evaluate(
                $submission->answer,
                $aiassignment->solution,
                $aiassignment->type
            );

            // Guardar evaluación
            $evalrecord = new \stdClass();
            $evalrecord->submission       = $submission->id;
            $evalrecord->similarity_score = $evaluation['similarity_score'];
            $evalrecord->ai_feedback      = $evaluation['feedback'];
            $evalrecord->ai_analysis      = $evaluation['analysis'];
            $evalrecord->timecreated      = time();
            $DB->insert_record('aiassignment_evaluations', $evalrecord);

            // Actualizar submission
            $submission->status       = 'evaluated';
            $submission->score        = $evaluation['similarity_score'];
            $submission->feedback     = $evaluation['feedback'];
            $submission->evaluated_at = time();
            $submission->timemodified = time();
            $DB->update_record('aiassignment_submissions', $submission);

            // Actualizar libro de calificaciones
            require_once($CFG->dirroot . '/mod/aiassignment/lib.php');
            $user = $DB->get_record('user', ['id' => $submission->userid]);
            aiassignment_update_grades($aiassignment, $submission->userid);

            // Notificar al estudiante
            $cm = get_coursemodule_from_instance('aiassignment', $aiassignment->id);
            $context = \context_module::instance($cm->id);

            $message                    = new \core\message\message();
            $message->component         = 'mod_aiassignment';
            $message->name              = 'submission_graded';
            $message->userfrom          = \core_user::get_noreply_user();
            $message->userto            = $user;
            $message->subject           = get_string('notif_graded_subject', 'aiassignment',
                                              format_string($aiassignment->name));
            $message->fullmessage       = get_string('notif_graded_body', 'aiassignment', [
                'assignment' => format_string($aiassignment->name),
                'score'      => round($evaluation['similarity_score'], 2),
                'feedback'   => $evaluation['feedback'],
            ]);
            $message->fullmessageformat = FORMAT_PLAIN;
            $message->fullmessagehtml   = '<p>' . $message->fullmessage . '</p>';
            $message->smallmessage      = get_string('notif_graded_small', 'aiassignment',
                                              round($evaluation['similarity_score'], 2));
            $message->notification      = 1;
            $message->contexturl        = (new \moodle_url('/mod/aiassignment/view.php',
                                              ['id' => $cm->id]))->out(false);
            $message->contexturlname    = format_string($aiassignment->name);
            message_send($message);

            mtrace("Envío $submissionid evaluado correctamente. Score: " .
                round($evaluation['similarity_score'], 2) . '%');

        } catch (\Exception $e) {
            mtrace("Error evaluando envío $submissionid: " . $e->getMessage());
            // Marcar como error para que el profesor lo vea
            $submission->status       = 'pending';
            $submission->timemodified = time();
            $DB->update_record('aiassignment_submissions', $submission);
            throw $e;
        }
    }
}
