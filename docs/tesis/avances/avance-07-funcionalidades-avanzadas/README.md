# Avance 7 — Funcionalidades Avanzadas del Plugin

**Plugin:** mod_aiassignment v2.5.1 | **Universidad:** UAS-FIM | **Autor:** Ángel Flores | **Sep 2026**

## Contenido de esta carpeta

```
avance-07-funcionalidades-avanzadas/
├── README.md
├── docs/
│   ├── FUNCIONALIDADES.md         ← Documento del avance
│   └── DASHBOARD.md               ← Documentación del dashboard
└── codigo/
    ├── dashboard.php              ← Panel del profesor: stats, 4 gráficas Chart.js
    ├── behavior_tracker.php       ← Análisis de velocidad tipeo, ratio pegado
    ├── code_executor.php          ← Ejecución real de código con Judge0 API
    ├── realtime_notifier.php      ← Notificaciones AJAX polling cada 15s
    ├── webhook_notifier.php       ← Alertas a Slack/Discord/Teams
    ├── submission_versioner.php   ← Historial de versiones de entregas
    ├── multi_file_submission.php  ← Soporte de múltiples archivos
    ├── export_grades.php          ← Exportar calificaciones CSV/XLSX/PDF
    ├── peer_review.php            ← Revisión entre pares anónima
    ├── sus_survey.php             ← Encuesta SUS (System Usability Scale)
    ├── satisfaction_survey.php    ← Encuesta de satisfacción rápida (3 preguntas)
    ├── my_stats.php               ← Dashboard personal del estudiante
    ├── manual_grade.php           ← Calificación manual del profesor
    ├── bulk_actions.php           ← Acciones en lote (re-evaluar, marcar plagio)
    └── request_resubmit.php       ← Solicitar re-envío al estudiante
```

## Qué demuestra este avance

### Dashboard del profesor (dashboard.php)
- **5 tarjetas:** total envíos, promedio, alertas plagio, pendientes, estudiantes activos
- **4 gráficas Chart.js:** distribución de calificaciones, actividad 7 días, correlación plagio vs nota, precisión detector
- **Consulta consolidada** en lib.php evita N+1 queries: una sola SQL con SUM(CASE WHEN)

### Deadline con cuenta regresiva (view.php)
```javascript
// Actualiza cada segundo en el cliente
var remaining = deadline - Math.floor(Date.now()/1000);
// Cambia color: azul → naranja (<24h) → rojo (<1h)
// Deshabilita submit cuando vence
```

### Lenguaje requerido por tarea
- Profe elige lenguaje en `mod_form.php` → guardado en `aiassignment.required_language`
- Editor Monaco se bloquea al lenguaje forzado
- Validación en JS antes del submit + validación en `submit.php`
- `submissions.php` muestra columna "Lenguaje detectado" en rojo si no coincide

### Ejecución real con Judge0 (code_executor.php)
```
Lenguajes: Python(71), JS(63), Java(62), C++(54), PHP(68), Ruby(72), Go(60), Rust(73), TS(74)
Límites: 5s CPU, 128MB RAM
Flujo: POST código → polling token → stdout/stderr/tiempo/memoria
```

### Acciones en lote (bulk_actions.php)
- Seleccionar múltiples envíos con checkboxes
- Re-evaluar todos con IA / Marcar como plagio / Desmarcar
- Cada acción queda en `audit_logger.php` con IP y timestamp
