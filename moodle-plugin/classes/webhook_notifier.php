<?php
namespace mod_aiassignment;
defined('MOODLE_INTERNAL') || die();

/**
 * Notificaciones via webhook a Slack, Discord y Teams.
 * Mejora #6: Alertas automáticas cuando se detecta plagio alto.
 */
class webhook_notifier {

    /**
     * Envía alerta de plagio a todos los webhooks configurados.
     *
     * @param array  $plagiarism_data  Datos del plagio detectado
     * @param object $course           Curso de Moodle
     * @param object $assignment       Tarea
     */
    public static function send_plagiarism_alert(
        array $plagiarism_data, object $course, object $assignment
    ): void {
        global $DB;

        $threshold = (int)(get_config('mod_aiassignment', 'plagiarism_threshold') ?: 75);
        $score     = $plagiarism_data['highest_similarity'] ?? 0;

        if ($score < $threshold) return;

        $message = self::build_message($plagiarism_data, $course, $assignment, $score);

        // Slack
        $slack_url = get_config('mod_aiassignment', 'webhook_slack');
        if (!empty($slack_url)) {
            self::send_slack($slack_url, $message, $score);
        }

        // Discord
        $discord_url = get_config('mod_aiassignment', 'webhook_discord');
        if (!empty($discord_url)) {
            self::send_discord($discord_url, $message, $score);
        }

        // Teams
        $teams_url = get_config('mod_aiassignment', 'webhook_teams');
        if (!empty($teams_url)) {
            self::send_teams($teams_url, $message, $score);
        }
    }

    /**
     * Envía notificación cuando un envío es evaluado.
     */
    public static function send_evaluation_complete(
        object $submission, float $score, object $assignment
    ): void {
        $url = get_config('mod_aiassignment', 'webhook_slack');
        if (empty($url)) return;

        $payload = json_encode([
            'text' => "✅ *Evaluación completada* — {$assignment->name}\nCalificación: *{$score}%*",
        ]);
        self::post($url, $payload);
    }

    // ── Formatos por plataforma ───────────────────────────────────────────────

    private static function build_message(
        array $data, object $course, object $assignment, float $score
    ): array {
        $pairs   = $data['suspicious_pairs_count'] ?? 0;
        $users   = count($data['suspicious_users'] ?? []);
        $course_name = format_string($course->fullname);
        $assign_name = format_string($assignment->name);

        return [
            'title'   => "🚨 Alerta de Plagio Detectado",
            'course'  => $course_name,
            'task'    => $assign_name,
            'score'   => round($score, 1),
            'pairs'   => $pairs,
            'users'   => $users,
            'summary' => "Se detectó {$score}% de similitud en *{$assign_name}* ({$course_name}). " .
                         "{$pairs} par(es) sospechoso(s), {$users} alumno(s) involucrado(s).",
        ];
    }

    private static function send_slack(string $url, array $msg, float $score): void {
        $color = $score >= 90 ? 'danger' : 'warning';
        $payload = json_encode([
            'attachments' => [[
                'color'  => $color,
                'title'  => $msg['title'],
                'text'   => $msg['summary'],
                'fields' => [
                    ['title' => 'Curso',      'value' => $msg['course'], 'short' => true],
                    ['title' => 'Tarea',      'value' => $msg['task'],   'short' => true],
                    ['title' => 'Similitud',  'value' => $msg['score'] . '%', 'short' => true],
                    ['title' => 'Alumnos',    'value' => $msg['users'],  'short' => true],
                ],
                'footer' => 'AI Assignment Plugin · Moodle',
                'ts'     => time(),
            ]],
        ]);
        self::post($url, $payload);
    }

    private static function send_discord(string $url, array $msg, float $score): void {
        $color = $score >= 90 ? 15158332 : 16776960; // rojo o amarillo
        $payload = json_encode([
            'embeds' => [[
                'title'       => $msg['title'],
                'description' => $msg['summary'],
                'color'       => $color,
                'fields'      => [
                    ['name' => 'Curso',     'value' => $msg['course'], 'inline' => true],
                    ['name' => 'Tarea',     'value' => $msg['task'],   'inline' => true],
                    ['name' => 'Similitud', 'value' => $msg['score'] . '%', 'inline' => true],
                ],
                'footer'      => ['text' => 'AI Assignment Plugin · Moodle'],
                'timestamp'   => date('c'),
            ]],
        ]);
        self::post($url, $payload);
    }

    private static function send_teams(string $url, array $msg, float $score): void {
        $payload = json_encode([
            '@type'      => 'MessageCard',
            '@context'   => 'http://schema.org/extensions',
            'themeColor' => $score >= 90 ? 'FF0000' : 'FFA500',
            'summary'    => $msg['title'],
            'sections'   => [[
                'activityTitle'    => $msg['title'],
                'activitySubtitle' => $msg['course'] . ' — ' . $msg['task'],
                'activityText'     => $msg['summary'],
                'facts'            => [
                    ['name' => 'Similitud máxima', 'value' => $msg['score'] . '%'],
                    ['name' => 'Pares sospechosos', 'value' => (string)$msg['pairs']],
                    ['name' => 'Alumnos involucrados', 'value' => (string)$msg['users']],
                ],
            ]],
        ]);
        self::post($url, $payload);
    }

    private static function post(string $url, string $payload): void {
        $curl = curl_init($url);
        curl_setopt_array($curl, [
            CURLOPT_POST           => true,
            CURLOPT_POSTFIELDS     => $payload,
            CURLOPT_HTTPHEADER     => ['Content-Type: application/json'],
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_TIMEOUT        => 5,
            CURLOPT_SSL_VERIFYPEER => true,
        ]);
        curl_exec($curl);
        curl_close($curl);
    }
}
