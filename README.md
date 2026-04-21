# AI Assignment — Plugin para Moodle v2.2.0

Plugin de actividad para Moodle que evalúa automáticamente tareas de programación y detecta plagio de código fuente mediante inteligencia artificial.

## ¿Qué hace?

- **Evalúa código automáticamente** con OpenAI GPT-4o-mini
- **Detecta plagio** en 3 capas: léxica, estructural y semántica
- **Analiza AST** real con Python para código Python
- **Ejecuta código** contra test cases reales con Judge0
- **Detecta código generado por IA** (ChatGPT, Copilot)
- **Analiza complejidad algorítmica** (O(n), O(n²), etc.)

## Instalación

1. Descarga `dist/mod_aiassignment.zip`
2. En Moodle: `Administración del sitio → Plugins → Instalar plugins`
3. Sube el ZIP y sigue el wizard
4. Configura tu API key de OpenAI en los ajustes del plugin

## Credenciales de prueba

Ver `USUARIOS_PRUEBA.md` — todos los usuarios usan `Test1234!`

## Tecnologías

| Tecnología | Uso |
|------------|-----|
| PHP 8.1+ | Plugin Moodle |
| OpenAI GPT-4o-mini | Evaluación + Detección de plagio |
| Python 3.8+ | Análisis AST |
| Monaco Editor | Editor de código |
| Chart.js | Gráficas del dashboard |
| Judge0 CE | Ejecución de código |

## Estructura

```
moodle-plugin/    Plugin completo para Moodle
dist/             ZIP listo para instalar
docs/             Documentación completa
scripts/          Scripts de utilidad y datos de prueba
demo-standalone/  Demo sin Moodle (Node.js)
```

## Documentación

- `docs/tesis/TESIS_DETECCION_PLAGIO.md` — Documento de tesis
- `docs/tesis/INDICE_PROYECTO.md` — Índice completo
- `USUARIOS_PRUEBA.md` — Credenciales de prueba
- `GUIA_INSTALACION_MOODLE.md` — Guía de instalación

## Versión

**v2.2.0** — Abril 2026

Cambios principales desde v1.0:
- Editor Monaco integrado
- Evaluación asíncrona
- Rúbricas personalizables
- Modo examen
- Exportación CSV/Excel/PDF
- Notificaciones en tiempo real
- Múltiples archivos
- Análisis de complejidad
- Detección de código IA
- Seguridad auditada (18 medidas)
