<?php
// This file is part of Moodle - http://moodle.org/

namespace mod_aiassignment;

defined('MOODLE_INTERNAL') || die();

/**
 * Clase centralizada de seguridad para mod_aiassignment.
 *
 * Cubre:
 *  - Sanitización de entradas
 *  - Rate limiting por usuario/IP
 *  - Validación de archivos subidos
 *  - Logging de eventos de seguridad
 *  - Protección contra path traversal
 *  - Validación de API keys
 */
class security {

    // ── Rate limiting ─────────────────────────────────────────────────────────

    /**
     * Verifica si un usuario ha superado el límite de envíos.
     * Lanza excepción si se supera el límite.
     *
     * @param int $userid
     * @param int $assignmentid
     * @param int $max_per_hour  Máximo de envíos por hora (default 10)
     * @param int $min_gap_secs  Segundos mínimos entre envíos (default 5)
     */
    public static function check_rate_limit(
        int $userid, int $assignmentid,
        int $max_per_hour = 10, int $min_gap_secs = 5
    ): void {
        global $DB;

        // Verificar gap mínimo entre envíos
        $last = $DB->get_field_sql(
            "SELECT MAX(timecreated) FROM {aiassignment_submissions}
             WHERE assignment = :a AND userid = :u",
            ['a' => $assignmentid, 'u' => $userid]
        );
        if ($last && (time() - (int)$last) < $min_gap_secs) {
            throw new \moodle_exception('waitbetweensubmissions', 'mod_aiassignment', '', $min_gap_secs);
        }

        // Verificar límite por hora
        $count = $DB->count_records_sql(
            "SELECT COUNT(*) FROM {aiassignment_submissions}
             WHERE assignment = :a AND userid = :u AND timecreated >= :t",
            ['a' => $assignmentid, 'u' => $userid, 't' => time() - 3600]
        );
        if ($count >= $max_per_hour) {
            self::log_security_event('rate_limit_exceeded', $userid, [
                'assignment' => $assignmentid, 'count' => $count
            ]);
            throw new \moodle_exception('ratelimitexceeded', 'mod_aiassignment', '', $max_per_hour);
        }
    }

    // ── Sanitización de código ────────────────────────────────────────────────

    /**
     * Sanitiza el código del estudiante.
     * - Elimina null bytes
     * - Normaliza saltos de línea
     * - Verifica longitud
     * - Detecta patrones de inyección
     *
     * @param string $code
     * @param int    $maxlen
     * @return string Código sanitizado
     * @throws \moodle_exception Si el código es inválido
     */
    public static function sanitize_code(string $code, int $maxlen = 10000): string {
        // Eliminar null bytes (vector de ataque común)
        $code = str_replace("\0", '', $code);

        // Normalizar saltos de línea
        $code = str_replace(["\r\n", "\r"], "\n", $code);

        // Trim
        $code = trim($code);

        // Verificar vacío
        if ($code === '') {
            throw new \moodle_exception('answerrequired', 'mod_aiassignment');
        }

        // Verificar longitud mínima
        if (\core_text::strlen($code) < 5) {
            throw new \moodle_exception('answertooshort', 'mod_aiassignment', '', 5);
        }

        // Verificar longitud máxima
        if (\core_text::strlen($code) > $maxlen) {
            throw new \moodle_exception('answertoolong', 'mod_aiassignment', '', $maxlen);
        }

        // Detectar inyección de scripts (XSS en contexto de código)
        // Nota: el código legítimo puede contener <, > en comparaciones
        // Solo bloqueamos patrones claramente maliciosos
        $xss_patterns = [
            '/<script\b[^>]*>/i',
            '/javascript\s*:/i',
            '/on(?:error|load|click|mouseover)\s*=/i',
            '/eval\s*\(\s*(?:atob|unescape|String\.fromCharCode)/i',
        ];
        foreach ($xss_patterns as $pattern) {
            if (preg_match($pattern, $code)) {
                self::log_security_event('xss_attempt', 0, ['pattern' => $pattern]);
                throw new \moodle_exception('answerforbidden', 'mod_aiassignment');
            }
        }

        return $code;
    }

    // ── Validación de archivos ────────────────────────────────────────────────

    /**
     * Valida un archivo subido antes de procesarlo.
     *
     * @param array $file  Elemento de $_FILES
     * @param array $allowed_ext  Extensiones permitidas
     * @param int   $max_size     Tamaño máximo en bytes
     * @throws \moodle_exception Si el archivo es inválido
     */
    public static function validate_uploaded_file(
        array $file,
        array $allowed_ext = ['py', 'js', 'java', 'c', 'cpp', 'php', 'txt'],
        int $max_size = 2097152
    ): void {
        // Verificar errores de subida
        if ($file['error'] !== UPLOAD_ERR_OK) {
            throw new \moodle_exception('fileuploaderror', 'mod_aiassignment');
        }

        // Verificar tamaño
        if ($file['size'] > $max_size) {
            throw new \moodle_exception('filetoobig', 'mod_aiassignment', '',
                round($max_size / 1024 / 1024, 1) . 'MB');
        }

        // Verificar extensión (no confiar en MIME type del cliente)
        $ext = strtolower(pathinfo($file['name'], PATHINFO_EXTENSION));
        if (!in_array($ext, $allowed_ext, true)) {
            throw new \moodle_exception('invalidfileext', 'mod_aiassignment', '', $ext);
        }

        // Verificar que el nombre no tenga path traversal
        $basename = basename($file['name']);
        if ($basename !== $file['name'] || strpos($file['name'], '..') !== false) {
            self::log_security_event('path_traversal_attempt', 0, ['filename' => $file['name']]);
            throw new \moodle_exception('invalidfilename', 'mod_aiassignment');
        }

        // Verificar que sea un archivo real (no un symlink)
        if (!is_uploaded_file($file['tmp_name'])) {
            throw new \moodle_exception('invalidupload', 'mod_aiassignment');
        }

        // Verificar contenido: no ejecutables binarios
        $finfo = new \finfo(FILEINFO_MIME_TYPE);
        $mime  = $finfo->file($file['tmp_name']);
        $blocked_mimes = ['application/x-executable', 'application/x-elf',
                          'application/x-msdownload', 'application/x-dosexec'];
        if (in_array($mime, $blocked_mimes, true)) {
            self::log_security_event('executable_upload_attempt', 0, ['mime' => $mime]);
            throw new \moodle_exception('executablenotallowed', 'mod_aiassignment');
        }
    }

    // ── Validación de API keys ────────────────────────────────────────────────

    /**
     * Valida que una API key tenga el formato correcto.
     * No verifica si es válida contra la API, solo el formato.
     *
     * @param string $key
     * @param string $type  'openai' | 'judge0'
     * @return bool
     */
    public static function validate_api_key_format(string $key, string $type = 'openai'): bool {
        if (empty($key)) return false;

        switch ($type) {
            case 'openai':
                // OpenAI keys: sk-... o sk-proj-...
                return (bool)preg_match('/^sk-[a-zA-Z0-9\-_]{20,}$/', $key);
            case 'judge0':
                // RapidAPI keys: alfanumérico, 40-60 chars
                return (bool)preg_match('/^[a-zA-Z0-9]{20,80}$/', $key);
            default:
                return strlen($key) >= 10;
        }
    }

    // ── Protección de datos sensibles ─────────────────────────────────────────

    /**
     * Enmascara una API key para mostrarla en logs/UI.
     * Muestra solo los primeros 8 y últimos 4 caracteres.
     *
     * @param string $key
     * @return string  Ej: "sk-proj-AbCd...XyZw"
     */
    public static function mask_api_key(string $key): string {
        if (strlen($key) <= 12) return str_repeat('*', strlen($key));
        return substr($key, 0, 8) . '...' . substr($key, -4);
    }

    // ── Logging de seguridad ──────────────────────────────────────────────────

    /**
     * Registra un evento de seguridad en el log de Moodle.
     *
     * @param string $event   Tipo de evento
     * @param int    $userid  Usuario involucrado (0 = desconocido)
     * @param array  $data    Datos adicionales
     */
    public static function log_security_event(string $event, int $userid, array $data = []): void {
        global $DB;

        $ip = getremoteaddr();

        // Log en debugging de Moodle
        debugging(
            "[aiassignment security] $event | user=$userid | ip=$ip | " . json_encode($data),
            DEBUG_DEVELOPER
        );

        // También guardar en tabla de notificaciones como alerta de seguridad
        // (solo para eventos críticos)
        $critical = ['rate_limit_exceeded', 'xss_attempt', 'path_traversal_attempt',
                     'executable_upload_attempt'];
        if (in_array($event, $critical) && $userid > 0) {
            try {
                $record = new \stdClass();
                $record->userid      = $userid;
                $record->type        = 'security_alert';
                $record->payload     = json_encode([
                    'event' => $event,
                    'ip'    => $ip,
                    'data'  => $data,
                    'title' => '🔒 Alerta de seguridad: ' . $event,
                    'body'  => 'IP: ' . $ip,
                ]);
                $record->seen        = 0;
                $record->timecreated = time();
                $DB->insert_record('aiassignment_notifications', $record);
            } catch (\Exception $e) {
                // Ignorar si la tabla no existe
            }
        }
    }

    // ── Verificación de integridad ────────────────────────────────────────────

    /**
     * Verifica que un submission pertenece al usuario actual o que
     * el usuario tiene permisos de profesor.
     *
     * @param object $submission
     * @param object $context
     * @throws \moodle_exception Si no tiene permisos
     */
    public static function check_submission_access(object $submission, object $context): void {
        global $USER;

        $cangrade = has_capability('mod/aiassignment:grade', $context);
        $isowner  = ((int)$USER->id === (int)$submission->userid);

        if (!$cangrade && !$isowner) {
            self::log_security_event('unauthorized_submission_access', $USER->id, [
                'submission_id' => $submission->id,
                'owner_id'      => $submission->userid,
            ]);
            throw new \moodle_exception('nopermissions', 'error', '', 'view submission');
        }
    }

    /**
     * Verifica que el score está en rango válido (0-100).
     *
     * @param float $score
     * @return float Score normalizado
     */
    public static function normalize_score(float $score): float {
        return min(100.0, max(0.0, round($score, 2)));
    }

    /**
     * Genera un token seguro para operaciones sensibles.
     * Más seguro que sesskey() para operaciones de un solo uso.
     *
     * @param int $userid
     * @param string $action
     * @return string Token HMAC
     */
    public static function generate_action_token(int $userid, string $action): string {
        $secret = get_config('mod_aiassignment', 'secret_key');
        if (empty($secret)) {
            $secret = get_site_identifier();
        }
        return hash_hmac('sha256', $userid . '|' . $action . '|' . date('YmdH'), $secret);
    }

    /**
     * Verifica un token de acción.
     */
    public static function verify_action_token(int $userid, string $action, string $token): bool {
        $expected = self::generate_action_token($userid, $action);
        return hash_equals($expected, $token);
    }
}
