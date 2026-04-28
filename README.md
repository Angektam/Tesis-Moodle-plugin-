# AI Assignment — Plugin para Moodle v2.4.0

Plugin de actividad para Moodle que evalúa automáticamente tareas de programación y detecta plagio de código fuente mediante inteligencia artificial.

## ¿Qué hace?

- **Evalúa código automáticamente** con OpenAI GPT-4o-mini
- **Detecta plagio** en 3 capas: léxica, estructural y semántica
- **Analiza AST** real con Python para código Python
- **Ejecuta código** contra test cases reales con Judge0
- **Detecta código generado por IA** (ChatGPT, Copilot)
- **Analiza complejidad algorítmica** (O(n), O(n²), etc.)
- **Acciones en lote** para re-evaluar, marcar/desmarcar plagio
- **Versionado de submissions** con historial completo
- **Auditoría** de todas las acciones del profesor
- **Rate limiting** para proteger la cuota de OpenAI
- **Tests PHPUnit** para clases core

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

**v2.4.0** — Abril 2026

Cambios principales desde v2.3:
- Refactorización del detector de plagio en 4 clases especializadas
- Tests PHPUnit para security, ai_evaluator, plagiarism (lexical, structural, obfuscation)
- Rate limiting para llamadas a OpenAI (configurable)
- Análisis de plagio asíncrono via adhoc tasks
- Versionado de submissions (historial completo)
- Sistema de auditoría para acciones del profesor
- Acciones en lote (re-evaluar, marcar/desmarcar plagio)
- Filtros server-side en tabla de submissions (búsqueda + estado)
- Tarea programada de limpieza de datos antiguos
- Accesibilidad mejorada (aria-labels, roles, keyboard navigation)
- Distancia de Levenshtein como métrica adicional en análisis léxico
- Cadenas de idioma EN/ES para todas las nuevas funcionalidades

Cambios desde v1.0:
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
