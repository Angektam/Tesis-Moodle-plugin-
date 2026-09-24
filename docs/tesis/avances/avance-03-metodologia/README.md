# Avance 3 — Metodología de Desarrollo

**Plugin:** mod_aiassignment v2.5.1 | **Universidad:** UAS-FIM | **Autor:** Ángel Flores | **Sep 2026**

## Contenido de esta carpeta

```
avance-03-metodologia/
├── README.md
├── docs/
│   └── METODOLOGIA.md         ← Documento del avance (sprints, fases, herramientas)
└── bd/
    ├── install.xml            ← Esquema inicial de las 9 tablas (XMLDB Moodle)
    ├── upgrade.php            ← Migraciones de versiones anteriores (v2.0 → v2.5.1)
    ├── access.php             ← Capabilities (permisos: submit, grade, viewgrades)
    ├── tasks.php              ← Tareas programadas (evaluate_submission, cleanup)
    ├── caches.php             ← Definición de caches MUC de Moodle
    ├── messages.php           ← Mensajes internos del plugin
    └── schema-moodle.sql      ← Schema SQL de referencia para MySQL
```

## Qué demuestra este avance

- **9 tablas de BD:** `install.xml` define la estructura completa con tipos, índices y claves foráneas
- **Migraciones:** `upgrade.php` tiene el historial de cambios desde v2.0 hasta v2.5.1
- **Permisos Moodle:** `access.php` define las 5 capabilities del plugin
- **Metodología ágil:** 11 sprints documentados en `METODOLOGIA.md`

## Tablas definidas en install.xml

| Tabla | Descripción |
|---|---|
| `aiassignment` | Instancias del módulo (1 por actividad creada) |
| `aiassignment_submissions` | Entregas de estudiantes |
| `aiassignment_evaluations` | Resultados de evaluación IA |
| `aiassignment_notifications` | Notificaciones en tiempo real |
| `aiassignment_sus_surveys` | Respuestas encuesta SUS |
| `aiassignment_satisfaction` | Encuesta de satisfacción rápida |
| `aiassignment_peer_reviews` | Revisión entre pares |
| `aiassignment_sub_versions` | Historial de versiones de submissions |
| `aiassignment_audit_log` | Auditoría de acciones del profesor |
