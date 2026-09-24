# Avance 1 — Introducción y Planteamiento del Problema

**Plugin:** mod_aiassignment v2.5.1 | **Universidad:** UAS-FIM | **Autor:** Ángel Flores | **Sep 2026**

## Contenido de esta carpeta

```
avance-01-introduccion/
├── README.md              ← Este archivo (índice)
├── docs/
│   ├── INTRODUCCION.md    ← Documento del avance (problema, objetivos, hipótesis)
│   ├── README.md          ← README general del plugin
│   └── INSTALACION.md     ← Guía de instalación
└── codigo/
    ├── version.php        ← Metadatos del plugin (nombre, versión, Moodle requerido)
    ├── mod_form.php       ← Formulario de creación/edición de tarea (UI del profesor)
    ├── settings.php       ← Configuración global del plugin (API keys, umbrales)
    └── index.php          ← Página índice de actividades en el curso
```

## Qué demuestra este avance

- **Problema identificado:** falta de herramientas integradas en Moodle para evaluación automática y detección de plagio de código
- **Solución propuesta:** plugin nativo `mod_aiassignment` con 3 capas de análisis + GPT-4o-mini
- **Evidencia en código:** `version.php` define v2.5.1, `mod_form.php` muestra los campos del plugin (tipo de tarea, lenguaje requerido, deadline, rúbrica)

## Archivos clave

| Archivo | Propósito | Líneas aprox. |
|---|---|---|
| `version.php` | Declaración del plugin en Moodle | 15 |
| `mod_form.php` | Formulario de configuración de tarea | ~150 |
| `settings.php` | Administración global (API key OpenAI, Judge0, umbrales) | ~180 |
