# Avance 4 — Arquitectura del Sistema

**Plugin:** mod_aiassignment v2.5.1 | **Universidad:** UAS-FIM | **Autor:** Ángel Flores | **Sep 2026**

## Contenido de esta carpeta

```
avance-04-arquitectura/
├── README.md
├── docs/
│   ├── ARQUITECTURA.md           ← Documento del avance (diagramas, flujos, decisiones)
│   ├── COMPONENTES.md            ← Lista de todos los componentes del plugin
│   ├── ARQUITECTURA_COMPLETA.md  ← Documentación técnica detallada
│   ├── CLASES_E_INTERFACES.md    ← Clases PHP y sus métodos
│   └── ESTRUCTURA_BD.md          ← Modelo de base de datos
└── codigo/
    ├── lib.php         ← API Moodle requerida: add/update/delete_instance, grades
    ├── view.php        ← Vista principal: editor Monaco, deadline, formulario envío
    ├── submit.php      ← Pipeline completo de envío (validación → IA → notificación)
    ├── submission.php  ← Vista de detalle de un envío (diff, feedback, rúbrica)
    └── submissions.php ← Lista de envíos del profesor (filtros, plagio, acciones)
```

## Qué demuestra este avance

- **Flujo completo de envío:** `submit.php` orquesta: validación → detección IA → evaluación → libro de calificaciones → notificación
- **Integración Moodle:** `lib.php` implementa todas las funciones requeridas por la API de Moodle
- **UI del estudiante:** `view.php` incluye editor Monaco, cuenta regresiva JS, lenguaje forzado
- **Dashboard del profesor:** `submissions.php` con filtros server-side, paginación real, columna de lenguaje detectado

## Flujo de envío resumido (submit.php)

```
Estudiante envía código
        ↓
1. Validar sesskey + capability
2. Verificar timeopen / duedate
3. Sanitizar código (security::sanitize_code)
4. Verificar lenguaje (security::detect_language vs required_language)
5. Rate limiting
6. Detectar duplicado
7. Insertar submission en BD
8. ai_detector::detect() → ¿generado por IA?
9. behavior_tracker::analyze() → ¿pegado masivo?
10. ai_evaluator::evaluate() → score + feedback
11. update_grades() → libro de calificaciones Moodle
12. message_send() → notificación al estudiante
```
