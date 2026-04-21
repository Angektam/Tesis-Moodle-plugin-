<?php
// This file is part of Moodle - http://moodle.org/

namespace mod_aiassignment;

defined('MOODLE_INTERNAL') || die();

/**
 * Notificaciones en tiempo real mediante polling ligero.
 * Moodle no soporta WebSockets nativamente, así que usamos
 * un endpoint de polling que el cliente consulta cada N segundos.
 */
class realtime_notifier {

    /**
     * Registra un evento para notificación en tiempo real.
     * Se guarda en la tabla de sesión de Moodle para que el
     * endpoint de polling lo devuelva al cliente.
     *
     * @param int    $userid
     * @param string $type    'evaluated' | 'plagiarism_alert' | 'resubmit_request'
     * @param array  $data    Datos del evento
     */
    public static function push(int $userid, string $type, array $data): void {
        global $DB;

        // Guardar en tabla de notificaciones pendientes
        $record = new \stdClass();
        $record->userid      = $userid;
        $record->type        = $type;
        $record->payload     = json_encode($data);
        $record->timecreated = time();
        $record->seen        = 0;

        try {
            $DB->insert_record('aiassignment_notifications', $record);
        } catch (\Exception $e) {
            // Tabla puede no existir en instalaciones antiguas — ignorar
            debugging('realtime_notifier: ' . $e->getMessage(), DEBUG_DEVELOPER);
        }
    }

    /**
     * Obtiene notificaciones pendientes para un usuario.
     * Llamado por el endpoint de polling (poll.php).
     *
     * @param int $userid
     * @param int $since  Timestamp — solo notificaciones más nuevas
     * @return array
     */
    public static function get_pending(int $userid, int $since = 0): array {
        global $DB;

        try {
            $records = $DB->get_records_select(
                'aiassignment_notifications',
                'userid = :uid AND seen = 0 AND timecreated > :since',
                ['uid' => $userid, 'since' => $since],
                'timecreated ASC',
                'id, type, payload, timecreated'
            );

            $result = [];
            foreach ($records as $r) {
                $result[] = [
                    'id'          => $r->id,
                    'type'        => $r->type,
                    'data'        => json_decode($r->payload, true),
                    'timecreated' => $r->timecreated,
                ];
            }
            return $result;
        } catch (\Exception $e) {
            return [];
        }
    }

    /**
     * Marca notificaciones como vistas.
     */
    public static function mark_seen(int $userid, array $ids): void {
        global $DB;
        if (empty($ids)) return;
        try {
            list($insql, $params) = $DB->get_in_or_equal($ids);
            $params[] = $userid;
            $DB->execute(
                "UPDATE {aiassignment_notifications} SET seen=1 WHERE id $insql AND userid=?",
                $params
            );
        } catch (\Exception $e) {
            // Ignorar si la tabla no existe
        }
    }

    /**
     * Genera el JavaScript de polling para incluir en view.php.
     * Consulta poll.php cada 15 segundos y muestra notificaciones.
     *
     * @param int $cmid
     * @param int $userid
     * @return string HTML+JS
     */
    public static function render_polling_script(int $cmid, int $userid): string {
        return '
<div id="rt-notifications" style="position:fixed;top:70px;right:20px;z-index:9999;width:320px;pointer-events:none;"></div>
<script>
(function() {
    var lastCheck = Math.floor(Date.now() / 1000) - 5;
    var cmid      = ' . $cmid . ';
    var container = document.getElementById("rt-notifications");

    function checkNotifications() {
        fetch("/mod/aiassignment/poll.php?id=" + cmid + "&since=" + lastCheck + "&sesskey=" + M.cfg.sesskey)
            .then(function(r) { return r.json(); })
            .then(function(data) {
                if (!data.notifications || !data.notifications.length) return;
                lastCheck = Math.floor(Date.now() / 1000);
                data.notifications.forEach(showNotification);
                // Marcar como vistas
                var ids = data.notifications.map(function(n) { return n.id; });
                fetch("/mod/aiassignment/poll.php?id=" + cmid + "&mark_seen=1&ids=" + ids.join(",") + "&sesskey=" + M.cfg.sesskey);
            })
            .catch(function() {}); // Silenciar errores de red
    }

    function showNotification(n) {
        var icons = { evaluated: "✅", plagiarism_alert: "🚨", resubmit_request: "📩" };
        var colors = { evaluated: "#28a745", plagiarism_alert: "#dc3545", resubmit_request: "#ffc107" };
        var icon  = icons[n.type]  || "🔔";
        var color = colors[n.type] || "#1a73e8";

        var div = document.createElement("div");
        div.style.cssText = "background:#fff;border-left:4px solid " + color + ";border-radius:8px;" +
            "box-shadow:0 4px 16px rgba(0,0,0,.15);padding:12px 16px;margin-bottom:10px;" +
            "pointer-events:all;animation:slideIn .3s ease;font-size:13px;";

        var title = n.data.title || "Notificación";
        var body  = n.data.body  || "";
        var url   = n.data.url   || "";

        div.innerHTML = "<div style=\'display:flex;align-items:flex-start;gap:8px;\'>" +
            "<span style=\'font-size:18px;\'>" + icon + "</span>" +
            "<div style=\'flex:1;\'>" +
            "<div style=\'font-weight:700;color:#333;margin-bottom:2px;\'>" + title + "</div>" +
            (body ? "<div style=\'color:#666;\'>" + body + "</div>" : "") +
            (url  ? "<a href=\'" + url + "\' style=\'color:" + color + ";font-size:12px;font-weight:600;\'>Ver →</a>" : "") +
            "</div>" +
            "<button onclick=\'this.parentElement.parentElement.remove()\' style=\'background:none;border:none;color:#999;cursor:pointer;font-size:16px;padding:0;\'>✕</button>" +
            "</div>";

        container.appendChild(div);
        // Auto-cerrar después de 8 segundos
        setTimeout(function() {
            if (div.parentElement) {
                div.style.opacity = "0";
                div.style.transition = "opacity .5s";
                setTimeout(function() { if (div.parentElement) div.remove(); }, 500);
            }
        }, 8000);

        // Si es evaluación completada, recargar la sección de envíos
        if (n.type === "evaluated") {
            setTimeout(function() { window.location.reload(); }, 3000);
        }
    }

    // Iniciar polling cada 15 segundos
    setInterval(checkNotifications, 15000);
    // Primera consulta a los 3 segundos
    setTimeout(checkNotifications, 3000);
})();
</script>
<style>
@keyframes slideIn {
    from { transform: translateX(100%); opacity: 0; }
    to   { transform: translateX(0);    opacity: 1; }
}
</style>';
    }
}
