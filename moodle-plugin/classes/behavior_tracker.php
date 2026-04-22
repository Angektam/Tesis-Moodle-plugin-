<?php
namespace mod_aiassignment;
defined('MOODLE_INTERNAL') || die();

/**
 * Rastreador de comportamiento del estudiante.
 * Mejora #8: Detecta si el código fue pegado de golpe (posible copia).
 * Registra tiempo de escritura, número de cambios, velocidad de tipeo.
 */
class behavior_tracker {

    /**
     * Analiza los datos de comportamiento enviados desde el editor Monaco.
     *
     * @param array $events  Array de eventos del editor: [type, timestamp, chars]
     * @param string $code   Código final enviado
     * @return array Análisis de comportamiento
     */
    public static function analyze(array $events, string $code): array {
        if (empty($events)) {
            return ['suspicious' => false, 'reason' => 'Sin datos de comportamiento'];
        }

        $total_chars   = strlen($code);
        $total_events  = count($events);
        $paste_events  = array_filter($events, fn($e) => ($e['type'] ?? '') === 'paste');
        $paste_count   = count($paste_events);

        // Calcular tiempo total de escritura
        $timestamps = array_column($events, 'timestamp');
        $time_span  = !empty($timestamps) ? (max($timestamps) - min($timestamps)) / 1000 : 0; // segundos

        // Velocidad de tipeo (chars por minuto)
        $typing_speed = $time_span > 0 ? round($total_chars / $time_span * 60) : 0;

        // Detectar pegado masivo (>50% del código en un solo paste)
        $max_paste_chars = 0;
        foreach ($paste_events as $pe) {
            $max_paste_chars = max($max_paste_chars, $pe['chars'] ?? 0);
        }
        $paste_ratio = $total_chars > 0 ? $max_paste_chars / $total_chars : 0;

        // Señales sospechosas
        $signals = [];
        $suspicious = false;

        if ($paste_ratio > 0.7) {
            $signals[] = 'Más del 70% del código fue pegado en un solo evento';
            $suspicious = true;
        }
        if ($paste_count > 3 && $total_chars < 500) {
            $signals[] = "Múltiples pegados ($paste_count) en código corto";
            $suspicious = true;
        }
        if ($typing_speed > 800 && $total_chars > 200) {
            $signals[] = "Velocidad de escritura muy alta ($typing_speed chars/min)";
            $suspicious = true;
        }
        if ($time_span < 30 && $total_chars > 300) {
            $signals[] = 'Código largo escrito en menos de 30 segundos';
            $suspicious = true;
        }

        return [
            'suspicious'    => $suspicious,
            'signals'       => $signals,
            'paste_count'   => $paste_count,
            'paste_ratio'   => round($paste_ratio * 100, 1),
            'typing_speed'  => $typing_speed,
            'time_spent_s'  => round($time_span),
            'total_events'  => $total_events,
        ];
    }

    /**
     * Genera el JavaScript para rastrear eventos en el editor Monaco.
     * Se incluye en view.php.
     */
    public static function get_tracking_script(): string {
        return '
<script>
(function() {
    var editorEvents = [];
    var startTime    = Date.now();

    function trackEditor(editor) {
        // Rastrear cambios de contenido
        editor.onDidChangeModelContent(function(e) {
            e.changes.forEach(function(change) {
                editorEvents.push({
                    type:      change.text.length > 50 ? "paste" : "type",
                    timestamp: Date.now() - startTime,
                    chars:     change.text.length,
                    deleted:   change.rangeLength,
                });
            });
        });
    }

    // Esperar a que Monaco esté listo
    var checkMonaco = setInterval(function() {
        if (window.monacoEditor) {
            trackEditor(window.monacoEditor);
            clearInterval(checkMonaco);
        }
    }, 500);

    // Serializar eventos al enviar el formulario
    var form = document.getElementById("submission-form");
    if (form) {
        var input = document.createElement("input");
        input.type  = "hidden";
        input.name  = "editor_events";
        input.id    = "editor_events_input";
        form.appendChild(input);

        form.addEventListener("submit", function() {
            input.value = JSON.stringify(editorEvents.slice(-500)); // máx 500 eventos
        });
    }
})();
</script>';
    }
}
