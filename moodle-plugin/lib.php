<?php
// This file is part of Moodle - http://moodle.org/

defined('MOODLE_INTERNAL') || die();

/**
 * Agrega una nueva instancia de aiassignment al curso
 *
 * @param stdClass $aiassignment
 * @param mod_aiassignment_mod_form $mform
 * @return int El id de la nueva instancia
 */
function aiassignment_add_instance($aiassignment, $mform = null) {
    global $DB;

    $aiassignment->timecreated = time();
    $aiassignment->timemodified = time();

    $aiassignment->id = $DB->insert_record('aiassignment', $aiassignment);

    // Actualizar el libro de calificaciones
    aiassignment_grade_item_update($aiassignment);

    return $aiassignment->id;
}

/**
 * Actualiza una instancia existente de aiassignment
 *
 * @param stdClass $aiassignment
 * @param mod_aiassignment_mod_form $mform
 * @return bool true
 */
function aiassignment_update_instance($aiassignment, $mform = null) {
    global $DB;

    $aiassignment->timemodified = time();
    $aiassignment->id = $aiassignment->instance;

    $DB->update_record('aiassignment', $aiassignment);

    // Actualizar el libro de calificaciones
    aiassignment_grade_item_update($aiassignment);

    return true;
}

/**
 * Elimina una instancia de aiassignment
 *
 * @param int $id
 * @return bool true
 */
function aiassignment_delete_instance($id) {
    global $DB;

    if (!$aiassignment = $DB->get_record('aiassignment', array('id' => $id))) {
        return false;
    }

    // Eliminar todas las submissions
    $DB->delete_records('aiassignment_submissions', array('assignment' => $id));
    
    // Eliminar todas las evaluaciones
    $submissions = $DB->get_records('aiassignment_submissions', array('assignment' => $id));
    foreach ($submissions as $submission) {
        $DB->delete_records('aiassignment_evaluations', array('submission' => $submission->id));
    }

    // Eliminar la instancia
    $DB->delete_records('aiassignment', array('id' => $id));

    // Eliminar del libro de calificaciones
    aiassignment_grade_item_delete($aiassignment);

    return true;
}

/**
 * Retorna información sobre el usuario en esta actividad
 *
 * @param stdClass $course
 * @param stdClass $user
 * @param stdClass $mod
 * @param stdClass $aiassignment
 * @return stdClass|null
 */
function aiassignment_user_outline($course, $user, $mod, $aiassignment) {
    global $DB;

    $submission = $DB->get_record('aiassignment_submissions', 
        array('assignment' => $aiassignment->id, 'userid' => $user->id),
        '*', IGNORE_MULTIPLE);

    if ($submission) {
        $result = new stdClass();
        $result->info = get_string('submitted', 'aiassignment');
        $result->time = $submission->timecreated;
        if ($submission->score !== null) {
            $result->info .= ' - ' . get_string('grade') . ': ' . round($submission->score, 2) . '%';
        }
        return $result;
    }

    return null;
}

/**
 * Imprime información detallada sobre el usuario en esta actividad
 *
 * @param stdClass $course
 * @param stdClass $user
 * @param stdClass $mod
 * @param stdClass $aiassignment
 */
function aiassignment_user_complete($course, $user, $mod, $aiassignment) {
    global $DB, $OUTPUT;

    $submissions = $DB->get_records('aiassignment_submissions',
        array('assignment' => $aiassignment->id, 'userid' => $user->id),
        'timecreated DESC');

    if ($submissions) {
        foreach ($submissions as $submission) {
            echo $OUTPUT->box_start();
            echo get_string('submitted', 'aiassignment') . ': ' . userdate($submission->timecreated);
            if ($submission->score !== null) {
                echo '<br>' . get_string('grade') . ': ' . round($submission->score, 2) . '%';
                if ($submission->feedback) {
                    echo '<br>' . get_string('feedback', 'aiassignment') . ': ' . $submission->feedback;
                }
            }
            echo $OUTPUT->box_end();
        }
    } else {
        echo get_string('nosubmission', 'aiassignment');
    }
}

/**
 * Crea o actualiza el item de calificación
 *
 * @param stdClass $aiassignment
 * @param mixed $grades opcional array/object de calificaciones
 * @return int 0 si ok, error code si hay error
 */
function aiassignment_grade_item_update($aiassignment, $grades = null) {
    global $CFG;
    require_once($CFG->libdir . '/gradelib.php');

    $params = array('itemname' => $aiassignment->name);
    
    if (isset($aiassignment->grade) && $aiassignment->grade > 0) {
        $params['gradetype'] = GRADE_TYPE_VALUE;
        $params['grademax'] = $aiassignment->grade;
        $params['grademin'] = 0;
    } else {
        $params['gradetype'] = GRADE_TYPE_NONE;
    }

    if ($grades === 'reset') {
        $params['reset'] = true;
        $grades = null;
    }

    return grade_update('mod/aiassignment', $aiassignment->course, 'mod', 'aiassignment',
        $aiassignment->id, 0, $grades, $params);
}

/**
 * Elimina el item de calificación
 *
 * @param stdClass $aiassignment
 * @return int
 */
function aiassignment_grade_item_delete($aiassignment) {
    global $CFG;
    require_once($CFG->libdir . '/gradelib.php');

    return grade_update('mod/aiassignment', $aiassignment->course, 'mod', 'aiassignment',
        $aiassignment->id, 0, null, array('deleted' => 1));
}

/**
 * Actualiza las calificaciones en el libro de calificaciones
 *
 * @param stdClass $aiassignment
 * @param int $userid opcional, 0 significa todos los usuarios
 * @param bool $nullifnone
 */
function aiassignment_update_grades($aiassignment, $userid = 0, $nullifnone = true) {
    global $CFG, $DB;
    require_once($CFG->libdir . '/gradelib.php');

    if ($aiassignment->grade == 0) {
        aiassignment_grade_item_update($aiassignment);
    } else if ($grades = aiassignment_get_user_grades($aiassignment, $userid)) {
        aiassignment_grade_item_update($aiassignment, $grades);
    } else if ($userid && $nullifnone) {
        $grade = new stdClass();
        $grade->userid = $userid;
        $grade->rawgrade = null;
        aiassignment_grade_item_update($aiassignment, $grade);
    } else {
        aiassignment_grade_item_update($aiassignment);
    }
}

/**
 * Obtiene las calificaciones de los usuarios
 *
 * @param stdClass $aiassignment
 * @param int $userid opcional
 * @return array
 */
function aiassignment_get_user_grades($aiassignment, $userid = 0) {
    global $DB;

    $params = array('assignment' => $aiassignment->id);
    $usersql = '';
    
    if ($userid) {
        $params['userid'] = $userid;
        $usersql = ' AND userid = :userid';
    }

    $sql = "SELECT userid, MAX(score) as rawgrade, MAX(timecreated) as dategraded
            FROM {aiassignment_submissions}
            WHERE assignment = :assignment AND status = 'evaluated' $usersql
            GROUP BY userid";

    $grades = $DB->get_records_sql($sql, $params);

    // Convertir score (0-100) a la escala de calificación de Moodle
    if ($grades) {
        foreach ($grades as $grade) {
            $grade->rawgrade = ($grade->rawgrade / 100) * $aiassignment->grade;
        }
    }

    return $grades;
}

/**
 * Indica si el módulo soporta características específicas
 *
 * @param string $feature FEATURE_xx constant
 * @return mixed True si soporta, null si no
 */
function aiassignment_supports($feature) {
    switch($feature) {
        case FEATURE_GROUPS:
            return false;
        case FEATURE_GROUPINGS:
            return false;
        case FEATURE_MOD_INTRO:
            return true;
        case FEATURE_COMPLETION_TRACKS_VIEWS:
            return true;
        case FEATURE_COMPLETION_HAS_RULES:
            return true;
        case FEATURE_GRADE_HAS_GRADE:
            return true;
        case FEATURE_GRADE_OUTCOMES:
            return false;
        case FEATURE_BACKUP_MOODLE2:
            return true;
        case FEATURE_SHOW_DESCRIPTION:
            return true;
        default:
            return null;
    }
}

/**
 * Get statistics for the dashboard
 *
 * @param int $assignmentid
 * @return stdClass Statistics object
 */
function aiassignment_get_statistics($assignmentid) {
    global $DB;
    
    $stats = new stdClass();
    
    // Total submissions
    $stats->total_submissions = $DB->count_records('aiassignment_submissions', 
        array('assignment' => $assignmentid));
    
    // Average grade
    $sql = "SELECT AVG(e.grade) as avg_grade
            FROM {aiassignment_evaluations} e
            INNER JOIN {aiassignment_submissions} s ON e.submissionid = s.id
            WHERE s.assignment = :assignment AND e.grade IS NOT NULL";
    $result = $DB->get_record_sql($sql, array('assignment' => $assignmentid));
    $stats->average_grade = $result && $result->avg_grade ? round($result->avg_grade, 2) : 0;
    
    // Active students (students who have submitted at least once)
    $sql = "SELECT COUNT(DISTINCT userid) as count
            FROM {aiassignment_submissions}
            WHERE assignment = :assignment";
    $result = $DB->get_record_sql($sql, array('assignment' => $assignmentid));
    $stats->active_students = $result ? $result->count : 0;
    
    // Pending evaluations
    $sql = "SELECT COUNT(*) as count
            FROM {aiassignment_submissions} s
            LEFT JOIN {aiassignment_evaluations} e ON s.id = e.submissionid
            WHERE s.assignment = :assignment AND e.id IS NULL";
    $result = $DB->get_record_sql($sql, array('assignment' => $assignmentid));
    $stats->pending_evaluations = $result ? $result->count : 0;
    
    return $stats;
}

/**
 * Estadísticas del curso en UNA sola query consolidada.
 */
function aiassignment_get_course_statistics($courseid) {
    global $DB;

    $stats = new stdClass();
    $stats->total_submissions   = 0;
    $stats->average_grade       = 0;
    $stats->active_students     = 0;
    $stats->pending_evaluations = 0;

    $assignments = $DB->get_records('aiassignment', ['course' => $courseid], '', 'id');
    if (empty($assignments)) {
        return $stats;
    }

    list($insql, $params) = $DB->get_in_or_equal(array_keys($assignments));

    // Una sola query para total, promedio, estudiantes activos y pendientes
    $sql = "SELECT
                COUNT(*)                                        AS total_submissions,
                AVG(CASE WHEN s.score IS NOT NULL THEN s.score END) AS average_grade,
                COUNT(DISTINCT s.userid)                        AS active_students,
                SUM(CASE WHEN s.status = 'pending' THEN 1 ELSE 0 END) AS pending_evaluations
            FROM {aiassignment_submissions} s
            WHERE s.assignment $insql";

    $r = $DB->get_record_sql($sql, $params);
    if ($r) {
        $stats->total_submissions   = (int)$r->total_submissions;
        $stats->average_grade       = $r->average_grade ? round($r->average_grade, 2) : 0;
        $stats->active_students     = (int)$r->active_students;
        $stats->pending_evaluations = (int)$r->pending_evaluations;
    }
    return $stats;
}

/**
 * Get recent submissions for the dashboard
 *
 * @param int $assignmentid
 * @param int $limit Number of submissions to retrieve
 * @return array Array of submission records
 */
function aiassignment_get_recent_submissions($assignmentid, $limit = 10) {
    global $DB;
    
    $sql = "SELECT s.*
            FROM {aiassignment_submissions} s
            WHERE s.assignment = :assignment
            ORDER BY s.timecreated DESC";
    
    return $DB->get_records_sql($sql, array('assignment' => $assignmentid), 0, $limit);
}

/**
 * Get recent submissions for all assignments in a course
 *
 * @param int $courseid
 * @param int $limit Number of submissions to retrieve
 * @return array Array of submission records
 */
function aiassignment_get_course_recent_submissions($courseid, $limit = 15) {
    global $DB;
    
    $sql = "SELECT s.*
            FROM {aiassignment_submissions} s
            INNER JOIN {aiassignment} a ON s.assignment = a.id
            WHERE a.course = :courseid
            ORDER BY s.timecreated DESC";
    
    return $DB->get_records_sql($sql, array('courseid' => $courseid), 0, $limit);
}

/**
 * Get student performance data
 *
 * @param int $assignmentid
 * @return array Array of performance records
 */
function aiassignment_get_student_performance($assignmentid) {
    global $DB;
    
    $sql = "SELECT s.userid, AVG(s.score) as avg_grade, COUNT(s.id) as submission_count
            FROM {aiassignment_submissions} s
            WHERE s.assignment = :assignment AND s.score IS NOT NULL
            GROUP BY s.userid
            ORDER BY avg_grade DESC";
    
    return $DB->get_records_sql($sql, array('assignment' => $assignmentid));
}

/**
 * Get student performance data for all assignments in a course.
 * Incluye datos de usuario en el mismo JOIN para evitar N+1 queries.
 */
function aiassignment_get_course_student_performance($courseid) {
    global $DB;
    $sql = "SELECT s.userid, AVG(s.score) as avg_grade, COUNT(s.id) as submission_count,
                   u.firstname, u.lastname, u.picture, u.imagealt, u.email
            FROM {aiassignment_submissions} s
            INNER JOIN {aiassignment} a ON s.assignment = a.id
            INNER JOIN {user} u ON s.userid = u.id
            WHERE a.course = :courseid AND s.score IS NOT NULL
            GROUP BY s.userid, u.firstname, u.lastname, u.picture, u.imagealt, u.email
            ORDER BY avg_grade DESC";
    return $DB->get_records_sql($sql, ['courseid' => $courseid]);
}

/**
 * Get grade distribution data
 *
 * @param int $assignmentid
 * @return array Array of grade records
 */
function aiassignment_get_grade_distribution($assignmentid) {
    global $DB;
    
    $sql = "SELECT e.grade
            FROM {aiassignment_evaluations} e
            INNER JOIN {aiassignment_submissions} s ON e.submissionid = s.id
            WHERE s.assignment = :assignment AND e.grade IS NOT NULL
            ORDER BY e.grade DESC";
    
    return $DB->get_records_sql($sql, array('assignment' => $assignmentid));
}

/**
 * Get CSS class for grade badge based on grade value
 *
 * @param float $grade Grade value (0-100)
 * @return string CSS class name
 */
function aiassignment_get_grade_class($grade) {
    if ($grade >= 90) {
        return 'grade-excellent';
    } else if ($grade >= 80) {
        return 'grade-good';
    } else if ($grade >= 70) {
        return 'grade-average';
    } else {
        return 'grade-poor';
    }
}

/**
 * Get overview statistics for all assignments in a course
 *
 * @param int $courseid
 * @return array Array of assignment statistics
 */
function aiassignment_get_assignments_overview($courseid) {
    global $DB;
    
    $sql = "SELECT a.id, a.name, a.type,
                   COUNT(DISTINCT s.id) as submission_count,
                   AVG(s.score) as avg_grade
            FROM {aiassignment} a
            LEFT JOIN {aiassignment_submissions} s ON a.id = s.assignment
            WHERE a.course = :courseid
            GROUP BY a.id, a.name, a.type
            ORDER BY a.name";
    
    return $DB->get_records_sql($sql, array('courseid' => $courseid));
}

/**
 * Mejora #1: Cuenta alumnos con plagio alto (similarity_score >= 75) en el curso.
 */
function aiassignment_get_plagiarism_alert_count($courseid) {
    global $DB;
    $sql = "SELECT COUNT(DISTINCT s.userid) as cnt
            FROM {aiassignment_submissions} s
            JOIN {aiassignment} a ON s.assignment = a.id
            JOIN {aiassignment_evaluations} e ON e.submission = s.id
            WHERE a.course = :courseid AND e.similarity_score >= 75";
    $r = $DB->get_record_sql($sql, ['courseid' => $courseid]);
    return $r ? (int)$r->cnt : 0;
}

/**
 * Mejora #5: Envíos recientes con un solo JOIN (sin N+1 queries).
 */
function aiassignment_get_course_recent_submissions_optimized($courseid, $limit = 15, $assignmentid = 0) {
    global $DB;
    $params = ['courseid' => $courseid];
    $filter = '';
    if ($assignmentid > 0) {
        $filter = ' AND s.assignment = :aid';
        $params['aid'] = $assignmentid;
    }
    $sql = "SELECT s.id, s.userid, s.assignment, s.score, s.status, s.timecreated,
                   u.firstname, u.lastname, u.picture, u.imagealt, u.email,
                   a.name AS assignment_name,
                   cm.id AS cmid,
                   e.similarity_score
            FROM {aiassignment_submissions} s
            JOIN {aiassignment} a ON s.assignment = a.id
            JOIN {user} u ON s.userid = u.id
            JOIN {course_modules} cm ON cm.instance = a.id
            JOIN {modules} mo ON mo.id = cm.module AND mo.name = 'aiassignment'
            LEFT JOIN {aiassignment_evaluations} e ON e.submission = s.id
            WHERE a.course = :courseid{$filter}
            ORDER BY s.timecreated DESC";
    return $DB->get_records_sql($sql, $params, 0, $limit);
}

/**
 * Mejora #8: Formatea un timestamp como tiempo relativo en español.
 */
function aiassignment_time_ago($timestamp) {
    $diff = time() - $timestamp;
    if ($diff < 60)        return 'hace ' . $diff . ' seg';
    if ($diff < 3600)      return 'hace ' . floor($diff/60) . ' min';
    if ($diff < 86400)     return 'hace ' . floor($diff/3600) . ' h';
    if ($diff < 604800)    return 'hace ' . floor($diff/86400) . ' días';
    return userdate($timestamp, get_string('strftimedate', 'langconfig'));
}

/**
 * Mejora 1: Actividad de los últimos 7 días (envíos por día).
 */
function aiassignment_get_activity_last7days($courseid) {
    global $DB;
    $days = [];
    for ($i = 6; $i >= 0; $i--) {
        $start = mktime(0,0,0, date('n'), date('j')-$i, date('Y'));
        $end   = $start + 86400;
        $count = $DB->count_records_sql(
            "SELECT COUNT(*) FROM {aiassignment_submissions} s
             JOIN {aiassignment} a ON s.assignment=a.id
             WHERE a.course=:c AND s.timecreated>=:s AND s.timecreated<:e",
            ['c'=>$courseid,'s'=>$start,'e'=>$end]
        );
        $days[] = ['label' => date('D', $start), 'count' => (int)$count];
    }
    return $days;
}

/**
 * Mejora 2: Alumnos con alto riesgo de plagio — query optimizada con índices.
 */
function aiassignment_get_high_risk_students($courseid) {
    global $DB;
    // Usa índice en similarity_score y assignment para evitar full scan
    $sql = "SELECT u.id, u.firstname, u.lastname, u.picture, u.imagealt, u.email,
                   MAX(e.similarity_score) as max_plag,
                   s.id as submission_id,
                   a.name as assignment_name,
                   cm.id as cmid
            FROM {aiassignment_evaluations} e
            JOIN {aiassignment_submissions} s ON s.id = e.submission
            JOIN {aiassignment} a ON s.assignment = a.id
            JOIN {course_modules} cm ON cm.instance = a.id
            JOIN {modules} mo ON mo.id = cm.module AND mo.name = 'aiassignment'
            JOIN {user} u ON s.userid = u.id
            WHERE a.course = :courseid
              AND e.similarity_score >= 75
            GROUP BY u.id, u.firstname, u.lastname, u.picture, u.imagealt, u.email,
                     s.id, a.name, cm.id
            ORDER BY max_plag DESC";
    return $DB->get_records_sql($sql, ['courseid' => $courseid]);
}

/**
 * Mejora 4: Datos de correlación plagio vs calificación para scatter plot.
 */
function aiassignment_get_plagiarism_vs_grade($courseid) {
    global $DB;
    $sql = "SELECT s.score, e.similarity_score
            FROM {aiassignment_submissions} s
            JOIN {aiassignment} a ON s.assignment = a.id
            JOIN {aiassignment_evaluations} e ON e.submission = s.id
            WHERE a.course = :c AND s.score IS NOT NULL AND e.similarity_score IS NOT NULL";
    return $DB->get_records_sql($sql, ['c' => $courseid]);
}

/**
 * Mejora 1: Precisión del detector — cuenta confirmados vs falsos positivos.
 */
function aiassignment_get_plagiarism_accuracy($courseid) {
    global $DB;
    $sql = "SELECT e.ai_analysis
            FROM {aiassignment_evaluations} e
            JOIN {aiassignment_submissions} s ON s.id = e.submission
            JOIN {aiassignment} a ON s.assignment = a.id
            WHERE a.course = :c AND e.ai_analysis IS NOT NULL AND e.ai_analysis != ''";
    $records = $DB->get_records_sql($sql, ['c' => $courseid]);
    $confirmed = 0; $false_pos = 0; $pending = 0;
    foreach ($records as $r) {
        $data = json_decode($r->ai_analysis, true);
        if (!is_array($data) || !isset($data['plagiarism_status'])) { $pending++; continue; }
        if ($data['plagiarism_status'] === 'confirmed')      $confirmed++;
        elseif ($data['plagiarism_status'] === 'false_positive') $false_pos++;
        else $pending++;
    }
    return ['confirmed' => $confirmed, 'false_positive' => $false_pos, 'pending' => $pending];
}
