/**
 * Genera el documento Word de Arquitectura del Proyecto
 * Ejecutar: node scripts/generar-arquitectura-word.js
 */
const {
    Document, Packer, Paragraph, TextRun, HeadingLevel,
    AlignmentType, Table, TableRow, TableCell, WidthType,
    BorderStyle, ShadingType, PageBreak, Header, Footer,
    PageNumber, convertInchesToTwip
} = require('docx');
const fs = require('fs');
const path = require('path');

// ── Colores ───────────────────────────────────────────────────
const C = {
    primary:   '1a73e8',
    dark:      '1d3557',
    success:   '16a34a',
    danger:    'dc2626',
    warning:   'd97706',
    gray:      '6b7280',
    lightgray: 'f3f4f6',
    white:     'ffffff',
    black:     '111827',
    code:      '1e293b',
};

// ── Helpers ───────────────────────────────────────────────────
const h1 = (text) => new Paragraph({
    text, heading: HeadingLevel.HEADING_1,
    spacing: { before: 480, after: 200 },
    run: { color: C.dark, bold: true, size: 36 },
});
const h2 = (text) => new Paragraph({
    text, heading: HeadingLevel.HEADING_2,
    spacing: { before: 360, after: 160 },
    run: { color: C.primary, bold: true, size: 28 },
});
const h3 = (text) => new Paragraph({
    text, heading: HeadingLevel.HEADING_3,
    spacing: { before: 240, after: 120 },
    run: { color: C.dark, bold: true, size: 24 },
});
const p = (text, opts = {}) => new Paragraph({
    children: [new TextRun({ text, size: 22, color: C.black, ...opts })],
    spacing: { before: 80, after: 80 },
    alignment: AlignmentType.JUSTIFIED,
});
const bullet = (text, level = 0) => new Paragraph({
    children: [new TextRun({ text, size: 22, color: C.black })],
    bullet: { level },
    spacing: { before: 60, after: 60 },
});
const code = (text) => new Paragraph({
    children: [new TextRun({ text, size: 18, color: C.code, font: 'Courier New' })],
    spacing: { before: 40, after: 40 },
    indent: { left: 360 },
    shading: { fill: 'f8f9fa', type: ShadingType.CLEAR },
});
const sep = () => new Paragraph({
    border: { bottom: { style: BorderStyle.SINGLE, size: 2, color: 'e5e7eb' } },
    spacing: { before: 200, after: 200 },
});
const pb = () => new Paragraph({ children: [new PageBreak()] });
const note = (text) => new Paragraph({
    children: [
        new TextRun({ text: '📌 ', size: 20 }),
        new TextRun({ text, size: 20, color: C.primary, italics: true }),
    ],
    spacing: { before: 80, after: 80 },
    indent: { left: 360 },
    border: { left: { style: BorderStyle.SINGLE, size: 6, color: C.primary } },
});

// Tabla de 2 columnas con encabezado azul
const tbl2 = (rows) => new Table({
    rows: rows.map((r, i) => new TableRow({
        children: [r[0], r[1]].map((text, ci) => new TableCell({
            children: [new Paragraph({
                children: [new TextRun({
                    text, bold: i === 0, size: i === 0 ? 20 : 19,
                    color: i === 0 ? C.white : C.black,
                })],
                spacing: { before: 60, after: 60 },
            })],
            shading: i === 0
                ? { fill: C.primary, type: ShadingType.CLEAR }
                : { fill: ci % 2 === 0 ? 'f8f9fa' : C.white, type: ShadingType.CLEAR },
            width: { size: ci === 0 ? 35 : 65, type: WidthType.PERCENTAGE },
            margins: { top: 80, bottom: 80, left: 120, right: 120 },
        })),
    })),
    width: { size: 100, type: WidthType.PERCENTAGE },
});

// Tabla de 3 columnas
const tbl3 = (rows) => new Table({
    rows: rows.map((r, i) => new TableRow({
        children: r.map((text, ci) => new TableCell({
            children: [new Paragraph({
                children: [new TextRun({
                    text, bold: i === 0, size: i === 0 ? 20 : 19,
                    color: i === 0 ? C.white : C.black,
                })],
                spacing: { before: 60, after: 60 },
            })],
            shading: i === 0
                ? { fill: C.primary, type: ShadingType.CLEAR }
                : { fill: i % 2 === 0 ? 'f8f9fa' : C.white, type: ShadingType.CLEAR },
            width: { size: 33, type: WidthType.PERCENTAGE },
            margins: { top: 80, bottom: 80, left: 120, right: 120 },
        })),
    })),
    width: { size: 100, type: WidthType.PERCENTAGE },
});

// Tabla de 4 columnas
const tbl4 = (rows) => new Table({
    rows: rows.map((r, i) => new TableRow({
        children: r.map((text, ci) => new TableCell({
            children: [new Paragraph({
                children: [new TextRun({
                    text, bold: i === 0, size: i === 0 ? 20 : 19,
                    color: i === 0 ? C.white : C.black,
                })],
                spacing: { before: 60, after: 60 },
            })],
            shading: i === 0
                ? { fill: C.primary, type: ShadingType.CLEAR }
                : { fill: i % 2 === 0 ? 'f8f9fa' : C.white, type: ShadingType.CLEAR },
            width: { size: 25, type: WidthType.PERCENTAGE },
            margins: { top: 80, bottom: 80, left: 120, right: 120 },
        })),
    })),
    width: { size: 100, type: WidthType.PERCENTAGE },
});

// ── Contenido ─────────────────────────────────────────────────
const children = [];

// ════════════════════════════════════════════════════════════
// PORTADA
// ════════════════════════════════════════════════════════════
children.push(
    new Paragraph({ spacing: { before: 1400 } }),
    new Paragraph({
        children: [new TextRun({ text: 'ARQUITECTURA Y ESTRUCTURA', bold: true, size: 56, color: C.dark })],
        alignment: AlignmentType.CENTER, spacing: { before: 200, after: 100 },
    }),
    new Paragraph({
        children: [new TextRun({ text: 'DEL PROYECTO', bold: true, size: 56, color: C.dark })],
        alignment: AlignmentType.CENTER, spacing: { before: 0, after: 200 },
    }),
    new Paragraph({
        children: [new TextRun({ text: 'Plugin AI Assignment para Moodle', bold: true, size: 32, color: C.primary })],
        alignment: AlignmentType.CENTER, spacing: { before: 100, after: 100 },
    }),
    new Paragraph({
        children: [new TextRun({ text: 'Documentación Técnica Completa — v1.5.0', size: 24, color: C.gray, italics: true })],
        alignment: AlignmentType.CENTER, spacing: { before: 100, after: 600 },
    }),
    new Paragraph({
        children: [new TextRun({ text: 'Equipo 8 — Tesis de Licenciatura', size: 22, color: C.gray })],
        alignment: AlignmentType.CENTER, spacing: { before: 60, after: 40 },
    }),
    new Paragraph({
        children: [new TextRun({ text: 'Flores Guevara Angel Gabriel  |  López Payán Kevin Ricardo', size: 22, color: C.gray })],
        alignment: AlignmentType.CENTER, spacing: { before: 40, after: 40 },
    }),
    new Paragraph({
        children: [new TextRun({ text: 'Abril 2026', size: 22, color: C.gray })],
        alignment: AlignmentType.CENTER, spacing: { before: 40 },
    }),
    pb(),
);

// ════════════════════════════════════════════════════════════
// ÍNDICE
// ════════════════════════════════════════════════════════════
children.push(h1('Índice de Contenidos'));
const idx = [
    ['1.', 'Visión General del Proyecto', '3'],
    ['2.', 'Estructura de Directorios', '4'],
    ['3.', 'Plugin Principal — moodle-plugin/', '5'],
    ['  3.1', 'Archivos Raíz del Plugin', '5'],
    ['  3.2', 'Páginas del Profesor', '8'],
    ['  3.3', 'Páginas del Estudiante', '12'],
    ['  3.4', 'Carpeta db/ — Base de Datos', '13'],
    ['  3.5', 'Carpeta classes/ — Lógica de Negocio', '14'],
    ['  3.6', 'Carpeta lang/ — Internacionalización', '18'],
    ['  3.7', 'Carpeta backup/ — Respaldo', '18'],
    ['  3.8', 'Carpeta styles/ y pix/', '19'],
    ['4.', 'Demos Independientes — demo-standalone/', '20'],
    ['5.', 'Documentación — docs/', '21'],
    ['6.', 'Scripts SQL y Utilidades — scripts/', '22'],
    ['7.', 'Archivos de Configuración', '23'],
    ['8.', 'Flujo de Datos del Sistema', '24'],
    ['9.', 'Tecnologías Utilizadas', '27'],
    ['10.', 'Patrones de Diseño', '28'],
    ['11.', 'Métricas del Proyecto', '29'],
    ['12.', 'Cumplimiento de Estándares Moodle', '30'],
];
idx.forEach(([num, title, page]) => children.push(new Paragraph({
    children: [
        new TextRun({ text: `${num}  ${title}`, size: 22, color: C.black }),
        new TextRun({ text: `  ......  ${page}`, size: 22, color: C.gray }),
    ],
    spacing: { before: 60, after: 60 },
    indent: { left: num.startsWith('  ') ? 360 : 0 },
})));
children.push(pb());

// ════════════════════════════════════════════════════════════
// 1. VISIÓN GENERAL
// ════════════════════════════════════════════════════════════
children.push(
    h1('1. Visión General del Proyecto'),
    p('El proyecto consiste en un plugin de actividad para Moodle (mod_aiassignment) que permite a los profesores crear tareas de programación o matemáticas evaluadas automáticamente mediante Inteligencia Artificial. Adicionalmente, incluye un sistema avanzado de detección de plagio en código fuente que analiza los envíos de los estudiantes usando tres capas de análisis: léxica, estructural y semántica.'),
    p(''),
    h2('Tipo de Plugin'),
    tbl2([
        ['Propiedad', 'Valor'],
        ['Tipo', 'Módulo de actividad (mod)'],
        ['Nombre interno', 'mod_aiassignment'],
        ['Versión', '1.5.0'],
        ['Moodle mínimo', '4.0 (2022041900)'],
        ['Madurez', 'MATURITY_STABLE'],
        ['Tamaño del ZIP', '159.8 KB'],
    ]),
    p(''),
    h2('Componentes Principales'),
    bullet('Plugin Moodle (moodle-plugin/) — el producto final instalable'),
    bullet('Demos independientes (demo-standalone/) — prototipos de APIs'),
    bullet('Documentación técnica y de usuario (docs/)'),
    bullet('Scripts SQL de prueba y utilidades (scripts/)'),
    sep(),
    pb(),
);

// ════════════════════════════════════════════════════════════
// 2. ESTRUCTURA DE DIRECTORIOS
// ════════════════════════════════════════════════════════════
children.push(
    h1('2. Estructura de Directorios'),
    p('La siguiente estructura muestra la organización completa del proyecto:'),
    p(''),
    code('Tesis/'),
    code('├── moodle-plugin/          ← Plugin principal (se empaqueta en ZIP)'),
    code('│   ├── classes/            ← Lógica de negocio (IA, plagio)'),
    code('│   ├── db/                 ← Esquema BD, migraciones, permisos'),
    code('│   ├── lang/               ← Strings en español e inglés'),
    code('│   ├── backup/             ← Backup y restauración de Moodle'),
    code('│   ├── amd/src/            ← JavaScript AMD de Moodle'),
    code('│   ├── styles/             ← CSS del plugin'),
    code('│   └── pix/                ← Iconos del plugin'),
    code('├── demo-standalone/        ← Demos independientes de APIs'),
    code('│   └── services/           ← Servicios Node.js y Python'),
    code('├── docs/                   ← Documentación completa'),
    code('│   ├── tecnica/            ← Documentación técnica'),
    code('│   ├── instalacion/        ← Guías de instalación'),
    code('│   ├── usuario/            ← Guías de usuario'),
    code('│   └── tesis/              ← Documentos de la tesis'),
    code('├── scripts/                ← Scripts SQL y utilidades Node.js'),
    code('├── dist/                   ← ZIP del plugin generado'),
    code('├── .env                    ← Variables de entorno (API Keys)'),
    code('└── package.json            ← Dependencias Node.js'),
    sep(),
    pb(),
);

// ════════════════════════════════════════════════════════════
// 3. PLUGIN PRINCIPAL
// ════════════════════════════════════════════════════════════
children.push(h1('3. Plugin Principal — moodle-plugin/'));

// ─────────────────────────────────────────────────────────────
// 3.1 Archivos raíz
// ─────────────────────────────────────────────────────────────
children.push(
    h2('3.1 Archivos Raíz del Plugin'),
    p('Estos archivos son requeridos por Moodle para que el plugin funcione correctamente. Cada uno cumple un rol específico dentro del ciclo de vida del módulo de actividad:'),
    p(''),
    tbl2([
        ['Archivo', 'Propósito'],
        ['version.php', 'Metadatos del plugin: versión, release, requisitos de Moodle. Moodle lee este archivo para detectar actualizaciones.'],
        ['lib.php', 'Funciones requeridas por Moodle: _add_instance, _update_instance, _delete_instance, _supports, funciones de calificación y estadísticas del dashboard.'],
        ['mod_form.php', 'Formulario de creación y edición de la tarea. Define los campos que el profesor llena: nombre, tipo, solución de referencia, intentos máximos, etc.'],
        ['settings.php', 'Página de configuración en Administración del sitio. Campos: API Key OpenAI, modelo, umbral de plagio, reintentos, longitud máxima de envío.'],
        ['view.php', 'Vista principal de la tarea. Muestra el enunciado, formulario de envío (estudiantes) y botones de gestión (profesores). Incluye gráfica de evolución de intentos.'],
        ['index.php', 'Lista de todas las tareas AI Assignment en un curso. Moodle lo llama automáticamente al navegar al módulo.'],
    ]),
    p(''),
    h3('lib.php — Funciones Principales'),
    p('lib.php es el archivo más importante del plugin. Contiene todas las funciones que Moodle requiere para integrar el módulo con el sistema de calificaciones, el libro de actividades y el dashboard del profesor. A continuación se describen las funciones más relevantes:'),
    p(''),
    bullet('aiassignment_get_course_statistics($courseid)'),
    p('Parámetros: $courseid (int) — ID del curso de Moodle. Devuelve: objeto stdClass con campos total_assignments, total_submissions, avg_score, unique_students, flagged_count. Implementación: ejecuta UNA sola query consolidada con COUNT(*), AVG(score), COUNT(DISTINCT userid) y SUM(CASE WHEN status=\'flagged\' THEN 1 ELSE 0 END) sobre un JOIN de aiassignment + aiassignment_submissions. Evita múltiples queries separadas para cada estadística.', { italics: true }),
    p(''),
    bullet('aiassignment_get_course_recent_submissions_optimized($courseid, $limit, $assignmentid)'),
    p('Parámetros: $courseid (int), $limit (int, default 10), $assignmentid (int|null, opcional para filtrar por tarea). Devuelve: array de objetos con userid, fullname, assignment_name, score, status, timecreated. Implementación: JOIN de 6 tablas (aiassignment_submissions, aiassignment_evaluations, aiassignment, mdl_user, mdl_user_info_field, mdl_course) con ORDER BY timecreated DESC y LIMIT. Elimina el problema N+1 al obtener nombres de usuario y datos de evaluación en una sola consulta.', { italics: true }),
    p(''),
    bullet('aiassignment_get_plagiarism_alert_count($courseid)'),
    p('Parámetros: $courseid (int). Devuelve: int — número de alumnos distintos con al menos una evaluación con similarity_score >= 75. Implementación: query con COUNT(DISTINCT userid) y WHERE similarity_score >= 75 sobre el JOIN de las tres tablas del plugin. Usa el umbral configurado en settings.php (default 75).', { italics: true }),
    p(''),
    bullet('aiassignment_get_high_risk_students($courseid)'),
    p('Parámetros: $courseid (int). Devuelve: array de objetos con userid, fullname, max_similarity, assignment_name. Implementación: query optimizada con driving table en aiassignment_evaluations (tabla más selectiva por el filtro similarity_score >= 75), luego JOIN hacia submissions y aiassignment. Usa MAX(similarity_score) con GROUP BY userid para obtener el peor caso por alumno.', { italics: true }),
    p(''),
    bullet('aiassignment_get_plagiarism_accuracy($courseid)'),
    p('Parámetros: $courseid (int). Devuelve: objeto con confirmed (int), false_positive (int), pending (int), accuracy_pct (float). Implementación: lee el campo ai_analysis (JSON) de aiassignment_evaluations para cada evaluación con similarity_score >= 75, decodifica el JSON y cuenta los campos plagiarism_confirmed, plagiarism_false_positive. Calcula accuracy_pct = confirmed / (confirmed + false_positive) * 100.', { italics: true }),
    p(''),
    bullet('aiassignment_time_ago($timestamp)'),
    p('Parámetros: $timestamp (int) — Unix timestamp. Devuelve: string formateado como "hace X min", "hace X h", "hace X días" o "hace X semanas". Implementación: calcula la diferencia con time(), aplica umbrales: < 60s → "hace X seg", < 3600 → "hace X min", < 86400 → "hace X h", < 604800 → "hace X días", resto → "hace X semanas". Usada en la tabla de envíos recientes del dashboard.', { italics: true }),
    p(''),
    bullet('aiassignment_get_activity_last7days($courseid)'),
    p('Parámetros: $courseid (int). Devuelve: array de 7 enteros, uno por día (hoy en índice 6, hace 6 días en índice 0). Implementación: ejecuta 7 queries separadas, una por día, con WHERE timecreated BETWEEN $start AND $end. Cada query cuenta los envíos de ese día. Los resultados alimentan la gráfica de línea de actividad en el dashboard.', { italics: true }),
    p(''),
    bullet('aiassignment_get_plagiarism_vs_grade($courseid)'),
    p('Parámetros: $courseid (int). Devuelve: array de objetos con x (similarity_score, float) e y (score, float) para cada envío evaluado. Implementación: JOIN de aiassignment_submissions + aiassignment_evaluations con WHERE similarity_score IS NOT NULL AND score IS NOT NULL. Los datos alimentan el scatter plot de correlación plagio/calificación en el dashboard.', { italics: true }),
    p(''),
    h3('settings.php — Parámetros Configurables'),
    p('La página de configuración del plugin (Administración del sitio → Plugins → Módulos de actividad → AI Assignment) expone los siguientes parámetros:'),
    p(''),
    tbl2([
        ['Parámetro', 'Descripción'],
        ['openai_api_key', 'API Key de OpenAI. Formato: sk-... Se guarda cifrada en la configuración de Moodle. Sin este valor el plugin opera en modo demo automáticamente.'],
        ['openai_model', 'Modelo de lenguaje a usar. Opciones: gpt-4o-mini (default, más económico), gpt-4o (más preciso), gpt-4-turbo, gpt-3.5-turbo (más rápido). Afecta costo y calidad de la evaluación.'],
        ['demo_mode', 'Activa evaluación simulada sin llamar a la API de OpenAI. Útil para pruebas sin costo. En modo demo, el score se calcula por longitud y palabras clave del código.'],
        ['plagiarism_threshold', 'Umbral de similitud para marcar un envío como plagio probable. Rango: 0-100, default 75. Afecta el conteo de alertas en el dashboard y el color de los badges.'],
        ['openai_retries', 'Número de reintentos automáticos si la API de OpenAI falla. Rango: 1-5, default 2. Solo reintenta en errores rate_limit_exceeded o server_error, con pausa de 2s entre intentos.'],
        ['max_submission_length', 'Longitud máxima del código enviado por el estudiante en caracteres. Default: 10,000. Envíos más largos son rechazados con mensaje de error antes de llamar a la API.'],
        ['max_response_time', 'Timeout máximo para la llamada a la API de OpenAI en segundos. Default: 30. Si la API no responde en este tiempo, el envío queda como "pending" para re-evaluación posterior.'],
    ]),
    p(''),
);

// ─────────────────────────────────────────────────────────────
// 3.2 Páginas del profesor
// ─────────────────────────────────────────────────────────────
children.push(
    h2('3.2 Páginas de Gestión del Profesor'),
    p('Estas páginas conforman la interfaz de administración del plugin. Cada una tiene un propósito específico y se comunica con lib.php y las clases de negocio para obtener y procesar datos.'),
    p(''),
    tbl2([
        ['Archivo', 'Propósito General'],
        ['dashboard.php', 'Panel de control del curso con 5 tarjetas de estadísticas, tabla de tareas, envíos recientes, top estudiantes, alumnos en riesgo y 4 gráficas interactivas.'],
        ['submissions.php', 'Lista paginada de todos los envíos de una tarea con búsqueda, filtros y ordenamiento en tiempo real.'],
        ['submission.php', 'Detalle completo de un envío individual con comparación lado a lado, feedback expandible e historial de calificaciones.'],
        ['plagiarism_report.php', 'Reporte de plagio con interfaz AJAX, dos modos de análisis, matriz NxN coloreada y ranking de similitud.'],
        ['plagiarism_ajax.php', 'Endpoint AJAX que ejecuta el análisis de plagio en background y devuelve JSON estructurado.'],
        ['course_report.php', 'Reporte del curso exportable a CSV o imprimible como PDF con resumen general y detalle por tarea.'],
        ['student_stats.php', 'Estadísticas individuales de un alumno: tarjetas, gráfica de evolución y tabla de historial completo.'],
        ['reevaluate.php', 'Re-evalúa un envío llamando a ai_evaluator::evaluate() y actualiza el libro de calificaciones.'],
        ['manual_grade.php', 'Guarda calificación manual del profesor con historial de cambios en ai_analysis JSON.'],
        ['request_resubmit.php', 'Solicita re-envío al estudiante marcando el envío como flagged y enviando notificación.'],
        ['mark_plagiarism.php', 'Confirma o descarta un caso de plagio guardando el estado en ai_analysis JSON.'],
    ]),
    p(''),
    h3('dashboard.php — Panel de Control del Curso'),
    p('El dashboard es la página central del profesor. Carga datos de 8 funciones distintas de lib.php y construye una vista completa del estado del curso:'),
    p(''),
    bullet('Datos que carga (8 llamadas a lib.php):'),
    bullet('aiassignment_get_course_statistics() → 5 tarjetas superiores (total tareas, envíos, promedio, alumnos únicos, alertas de plagio)', 1),
    bullet('aiassignment_get_course_recent_submissions_optimized() → tabla de últimos 10 envíos con nombre, tarea, nota y estado', 1),
    bullet('aiassignment_get_high_risk_students() → sección "Alumnos en Riesgo" con similarity máxima por alumno', 1),
    bullet('aiassignment_get_plagiarism_alert_count() → contador de badge rojo en la tarjeta de plagio', 1),
    bullet('aiassignment_get_plagiarism_accuracy() → datos para la gráfica de dona (precisión del detector)', 1),
    bullet('aiassignment_get_activity_last7days() → array de 7 valores para la gráfica de línea', 1),
    bullet('aiassignment_get_plagiarism_vs_grade() → puntos (x,y) para el scatter plot', 1),
    bullet('$DB->get_records() directo → lista de tareas del curso para la tabla de resumen', 1),
    p(''),
    bullet('Gráficas (4 instancias de Chart.js):'),
    bullet('Distribución de calificaciones: gráfica de barras con rangos 0-59, 60-69, 70-79, 80-89, 90-100. Calculada con SUM(CASE WHEN score BETWEEN X AND Y THEN 1 ELSE 0 END) en 1 sola query en lugar de cargar todos los envíos y agrupar en PHP.', 1),
    bullet('Actividad últimos 7 días: gráfica de línea con los 7 valores de aiassignment_get_activity_last7days(). Muestra tendencia de participación.', 1),
    bullet('Correlación plagio/calificación: scatter plot donde cada punto es un envío (x=similarity_score, y=score). Permite ver si los alumnos con plagio tienen notas altas o bajas.', 1),
    bullet('Precisión del detector: gráfica de dona con 3 segmentos: Confirmados (verde), Falsos positivos (rojo), Pendientes (gris). Alimentada por aiassignment_get_plagiarism_accuracy().', 1),
    p(''),
    note('Chart.js se carga UNA sola vez al inicio del script y las 4 gráficas se construyen en el mismo bloque <script>. Esto evita cargar la librería 4 veces y reduce el tiempo de carga de la página.'),
    p(''),
    h3('plagiarism_report.php — Reporte de Plagio con AJAX'),
    p('Esta página implementa una interfaz asíncrona para ejecutar el análisis de plagio sin bloquear el servidor ni el navegador del profesor:'),
    p(''),
    bullet('Interfaz AJAX: el botón de análisis llama a plagiarism_ajax.php vía fetch() con AbortController configurado con timeout de 6 minutos. Si el servidor no responde en ese tiempo, el AbortController cancela la petición y muestra un mensaje de error al profesor.'),
    bullet('Dos modos de análisis disponibles:'),
    bullet('Modo Rápido (nosem=1): omite la capa semántica de OpenAI. Solo ejecuta análisis léxico y estructural. Tiempo estimado: ~20 segundos con 30 alumnos. Ideal para una primera revisión rápida.', 1),
    bullet('Modo Completo (nosem=0): ejecuta las 3 capas incluyendo OpenAI para análisis semántico. Tiempo estimado: 3-5 minutos con 30 alumnos dependiendo de la velocidad de la API. Más preciso para casos sospechosos.', 1),
    p(''),
    bullet('Resultados renderizados por JavaScript (sin recargar la página):'),
    bullet('Banner de modo y tiempo: muestra si fue análisis rápido o completo y cuántos segundos tardó.', 1),
    bullet('Tarjetas resumen: total de pares analizados, pares con plagio probable (>= umbral), pares sospechosos (50-74%).', 1),
    bullet('Matriz NxN coloreada: tabla donde cada celda (i,j) muestra el score de similitud entre el alumno i y el alumno j. Colores: rojo >= 75%, amarillo 50-74%, verde < 50%.', 1),
    bullet('Ranking con barras de progreso: lista de alumnos ordenados por su similarity_score máximo, con barra visual proporcional al porcentaje.', 1),
    bullet('Comparaciones detalladas: para cada par con score >= umbral, muestra los dos códigos lado a lado con el score desglosado por capa.', 1),
    bullet('Botones de acción por comparación: "Confirmar plagio" y "Falso positivo". Al hacer clic llaman a mark_plagiarism.php vía AJAX y guardan el estado en el campo ai_analysis JSON de la evaluación.', 1),
    p(''),
    h3('submissions.php — Lista de Envíos con Paginación Real'),
    p('Muestra todos los envíos de una tarea con herramientas de navegación y filtrado implementadas de forma eficiente:'),
    p(''),
    bullet('Paginación real: usa LIMIT/OFFSET directamente en la query SQL (no array_slice() en PHP). Carga exactamente 20 registros por página. La query incluye COUNT(*) en una subquery para calcular el total de páginas sin cargar todos los registros.'),
    bullet('Búsqueda en tiempo real: la función filterTable() en JavaScript filtra las filas visibles de la tabla comparando el texto de la columna "Alumno" con el valor del input de búsqueda. No hace peticiones al servidor, opera sobre el DOM ya cargado.'),
    bullet('Filtro de estado: la función filterByStatus() filtra las filas por el valor del badge de estado. Acepta los valores: "all" (todos), "evaluated" (Evaluado), "pending" (Pendiente), "resubmit" (Re-envío solicitado). Combina con el filtro de búsqueda.'),
    bullet('Ordenamiento por columna: clic en el encabezado de cualquier columna activa la función sortTable(). Usa Array.sort() en JavaScript sobre las filas del DOM, alternando entre ascendente (↑) y descendente (↓). Las columnas numéricas (score) se ordenan como números, no como strings.'),
    bullet('Ranking de plagio: la query que obtiene el similarity_score máximo por alumno usa GROUP BY userid con MAX(similarity_score), no itera sobre los submissions en PHP. Esto evita N+1 queries.'),
    p(''),
    h3('submission.php — Detalle de Envío Individual'),
    p('Página de revisión detallada de un envío. Combina visualización de código, evaluación de IA e historial de cambios:'),
    p(''),
    bullet('Comparación lado a lado: implementada con CSS Grid (grid-template-columns: 1fr 1fr). Ambos paneles (código del alumno y solución del profesor) tienen overflow-y: auto con altura fija. La función syncScroll() en JavaScript sincroniza el scroll de ambos paneles: cuando el profesor hace scroll en uno, el otro se mueve proporcionalmente.'),
    bullet('Feedback expandible: el feedback de la IA se parsea buscando secciones con encabezados conocidos (Funcionalidad, Estilo, Eficiencia, Buenas prácticas). Cada sección se envuelve en un elemento <details><summary> para que el profesor pueda expandir o colapsar cada apartado individualmente.'),
    bullet('Historial de calificaciones: lee el array grade_history del campo ai_analysis JSON de la evaluación. Cada entrada del historial contiene: fecha del cambio (timestamp), nombre del profesor que hizo el cambio, nota anterior y nota nueva. Se muestra como tabla cronológica en la parte inferior de la página.'),
    bullet('Highlight.js: la librería de resaltado de sintaxis se carga inline (como <script> embebido en el HTML) en lugar de desde una URL externa. Esto evita las restricciones de Content Security Policy de Moodle que bloquean scripts de dominios externos.'),
    p(''),
);

// ─────────────────────────────────────────────────────────────
// 3.3 Páginas del estudiante
// ─────────────────────────────────────────────────────────────
children.push(
    h2('3.3 Páginas del Estudiante'),
    p(''),
    tbl2([
        ['Archivo', 'Propósito'],
        ['submit.php', 'Procesa el envío del estudiante. Valida longitud mínima/máxima, estructura de código, caracteres sospechosos, límite de intentos y duplicados. Guarda en BD, llama a la IA, guarda evaluación, actualiza calificaciones y envía notificación.'],
    ]),
    p(''),
    note('El archivo submit.php es el más crítico del flujo del estudiante. Si falla la evaluación de la IA, el envío queda como "pending" en lugar de mostrar un error al estudiante.'),
    p(''),
);

// ─────────────────────────────────────────────────────────────
// 3.4 Base de datos
// ─────────────────────────────────────────────────────────────
children.push(
    h2('3.4 Carpeta db/ — Base de Datos'),
    p(''),
    tbl2([
        ['Archivo', 'Propósito'],
        ['install.xml', 'Esquema completo de la BD. Define 3 tablas: aiassignment (tareas), aiassignment_submissions (envíos), aiassignment_evaluations (evaluaciones). Incluye 15 índices optimizados para las queries más frecuentes.'],
        ['upgrade.php', 'Migraciones de BD. Aplica cambios de esquema cuando se actualiza el plugin. Versión 2026041501 agrega índices en assignment_status, assignment_score, userid_assignment, score_idx, timecreated_idx.'],
        ['access.php', 'Capacidades (permisos). Define 5 capacidades: addinstance, view, submit, grade, viewgrades. Controla quién puede hacer qué en el plugin.'],
        ['caches.php', 'Definición de áreas de caché. Registra el área "plagiarism" (TTL 1 hora) para guardar reportes de plagio y evitar recalcular cuando no hay envíos nuevos.'],
        ['messages.php', 'Proveedores de mensajes. Registra "submission_graded" para que Moodle pueda enviar notificaciones a los estudiantes cuando su envío es evaluado.'],
    ]),
    p(''),
    h3('Esquema de la Base de Datos'),
    p(''),
    tbl3([
        ['Tabla', 'Campos principales', 'Propósito'],
        ['aiassignment', 'id, course, teacher_id, name, type, solution, grade, maxattempts', 'Almacena las instancias de la tarea (problemas)'],
        ['aiassignment_submissions', 'id, assignment, userid, answer, status, score, feedback, attempt', 'Almacena los envíos de los estudiantes'],
        ['aiassignment_evaluations', 'id, submission, similarity_score, ai_feedback, ai_analysis', 'Almacena el análisis de la IA y datos de plagio'],
    ]),
    p(''),
);

// ─────────────────────────────────────────────────────────────
// 3.5 Classes — Lógica de Negocio (expandida)
// ─────────────────────────────────────────────────────────────
children.push(
    h2('3.5 Carpeta classes/ — Lógica de Negocio'),
    p(''),
    tbl2([
        ['Archivo', 'Propósito'],
        ['ai_evaluator.php', 'Clase ai_evaluator. Método evaluate() que llama a OpenAI GPT para comparar la respuesta del estudiante con la solución del profesor. Incluye modo demo (sin API), reintentos automáticos configurables, manejo de errores y fallback a "pending".'],
        ['plagiarism_detector.php', 'Clase plagiarism_detector. Métodos: compare_code() compara dos códigos en 3 capas, generate_plagiarism_report() analiza todos los pares del assignment. Incluye análisis léxico (Jaccard+LCS), estructural (AST/regex por lenguaje), semántico (OpenAI), detección de ofuscación y caché inteligente.'],
        ['event/course_module_viewed.php', 'Evento de Moodle que se dispara cuando alguien ve la tarea. Usado para logs de actividad y estadísticas de Moodle.'],
        ['event/submission_created.php', 'Evento que se dispara cuando un estudiante envía una respuesta. Permite a otros plugins reaccionar al evento.'],
        ['event/submission_graded.php', 'Evento que se dispara cuando se califica un envío (automático o manual). Incluye el score en los datos del evento.'],
        ['privacy/provider.php', 'Cumplimiento GDPR. Define qué datos personales almacena el plugin y cómo exportarlos o eliminarlos. Requerido por Moodle 3.3+.'],
    ]),
    p(''),
    h3('Clase ai_evaluator — Flujo Detallado de Evaluación'),
    p('La clase ai_evaluator encapsula toda la lógica de comunicación con OpenAI. Su método principal evaluate($submission, $assignment) sigue este flujo:'),
    p(''),
    bullet('1. Verifica si está en modo demo (get_config("aiassignment", "demo_mode") == 1) → llama a evaluate_demo() que calcula un score basado en la longitud del código y la presencia de palabras clave del lenguaje (def, for, if, return, etc.) sin llamar a ninguna API externa.'),
    bullet('2. Obtiene la API Key (openai_api_key) y el modelo (openai_model) de la configuración del plugin.'),
    bullet('3. Construye el prompt del sistema según el tipo de tarea: para "programming" instruye a GPT a evaluar funcionalidad, estilo, eficiencia y buenas prácticas; para "math" evalúa procedimiento, resultado y claridad.'),
    bullet('4. Configura la llamada a la API con temperatura 0.3 (para respuestas consistentes y reproducibles) y response_format: json_object (garantiza que la respuesta sea JSON válido, evita parseo fallido).'),
    bullet('5. Ejecuta la llamada con reintentos: el número de reintentos es configurable desde settings.php (default 2). Entre cada intento hay una pausa de 2 segundos. Solo reintenta si el error es rate_limit_exceeded o server_error; errores de autenticación o modelo inválido no se reintentan.'),
    bullet('6. Parsea la respuesta JSON esperando los campos: similarity_score (0-100), feedback (string con evaluación detallada), analysis (objeto con desglose por criterio).'),
    bullet('7. En caso de error irrecuperable: lanza una excepción que submit.php captura para dejar el envío con status="pending" en lugar de mostrar un error al estudiante.'),
    p(''),
    note('El prompt del sistema instruye a GPT a responder SOLO en JSON con la estructura {similarity_score, feedback, analysis}. La temperatura 0.3 reduce la variabilidad entre evaluaciones del mismo código.'),
    p(''),
    h3('Clase plagiarism_detector — Análisis en 3 Capas'),
    p('La clase plagiarism_detector implementa el sistema de detección de plagio más sofisticado del proyecto. El método compare_code($code1, $code2, $nosem) devuelve un objeto con el score final y el desglose por capa:'),
    p(''),
    bullet('Capa 1 — Análisis Léxico (peso 35%): normaliza los identificadores (reemplaza nombres de variables y funciones por tokens genéricos), tokeniza el código, calcula el coeficiente de Jaccard sobre bigramas de tokens y el ratio LCS (Longest Common Subsequence). El score léxico es el promedio ponderado de ambas métricas.'),
    bullet('Capa 2 — Análisis Estructural (peso 30%): detecta el lenguaje del código (Python, Java, JavaScript, C++, PHP) por extensión o patrones sintácticos. Para Python usa AST real (ast.parse() vía proceso hijo ast_analyzer.py). Para otros lenguajes usa regex enriquecido que extrae: número de funciones, bucles (for/while), condicionales (if/else), clases y profundidad de anidamiento. Compara los vectores de características con distancia coseno.'),
    bullet('Capa 3 — Análisis Semántico (peso 35%): llama a OpenAI con un prompt especializado en detección de plagio de código. Devuelve un score de similitud semántica considerando el propósito del código, no solo su forma.'),
    p(''),
    h3('Fórmula del Score Final'),
    p('El score final se calcula en dos pasos:'),
    p(''),
    code('score_final = (léxica × 0.35) + (estructural × 0.30) + (semántica × 0.35)'),
    code('score_ajustado = min(100, score_final + técnicas_detectadas × 5)'),
    p(''),
    p('Donde técnicas_detectadas es el número de técnicas de ofuscación identificadas (0 a 4). Cada técnica detectada suma 5 puntos al score final, con un máximo de 100.'),
    p(''),
    h3('Umbrales de Clasificación'),
    p(''),
    tbl2([
        ['Rango de Score', 'Clasificación'],
        ['>= 75%', 'Plagio probable — badge rojo, aparece en alertas del dashboard'],
        ['50% – 74%', 'Sospechoso — badge amarillo, requiere revisión manual'],
        ['< 50%', 'Original — badge verde, sin alerta'],
    ]),
    p(''),
    h3('Optimización de Llamadas a OpenAI'),
    p('La capa semántica (OpenAI) es la más costosa en tiempo y dinero. El detector la omite en tres casos para optimizar el rendimiento:'),
    p(''),
    bullet('Se omite si léxica + estructural > 85%: el plagio es tan obvio que la capa semántica no aportaría información adicional. El score semántico se asume igual al promedio de las otras dos capas.'),
    bullet('Se omite si léxica + estructural < 20%: los códigos son claramente originales. Llamar a OpenAI sería un gasto innecesario. El score semántico se asume 0.'),
    bullet('Se omite en modo rápido (nosem=1): el profesor eligió el análisis rápido. El score semántico se excluye del cálculo y los pesos se redistribuyen entre léxica (54%) y estructural (46%).'),
    p(''),
    h3('Técnicas de Ofuscación Detectadas'),
    p('El detector identifica 4 técnicas comunes de ofuscación de código. Cada técnica detectada suma +5 puntos al score final:'),
    p(''),
    tbl3([
        ['Técnica', 'Condición de Detección', 'Boost'],
        ['Renombrado de variables', 'Score léxico normalizado > 60% pero Jaccard literal (sin normalizar) < 40%. Indica que la estructura es similar pero los nombres fueron cambiados.', '+5 puntos'],
        ['Cambio de tipo de bucle', 'Número de bucles diferente entre los dos códigos pero score estructural > 55%. Indica que se cambió for por while o viceversa manteniendo la lógica.', '+5 puntos'],
        ['Reordenación de bloques', 'Jaccard de tokens ordenados alfabéticamente > 85% pero LCS ratio < 70%. Indica que los mismos bloques de código fueron reordenados.', '+5 puntos'],
        ['Inserción de código muerto', 'Diferencia de tamaño entre los dos códigos > 30% pero score léxico > 55%. Indica que se agregaron funciones o variables que no se usan para inflar el código.', '+5 puntos'],
    ]),
    p(''),
    h3('Clase ai_evaluator — Modo Demo'),
    p('Cuando demo_mode está activado, evaluate_demo() calcula el score sin llamar a ninguna API:'),
    p(''),
    bullet('Calcula un score base proporcional a la longitud del código (más largo = más trabajo = score más alto, hasta un máximo de 70 puntos por longitud).'),
    bullet('Suma puntos por palabras clave del lenguaje detectado: funciones (def/function), bucles (for/while), condicionales (if/else), manejo de errores (try/catch/except).'),
    bullet('Genera un feedback simulado con secciones predefinidas que mencionan los elementos encontrados en el código.'),
    bullet('Devuelve el mismo formato JSON que la API real: {similarity_score, feedback, analysis}, por lo que el resto del sistema no necesita saber si está en modo demo o real.'),
    p(''),
);

// ─────────────────────────────────────────────────────────────
// 3.6 Lang / 3.7 Backup / 3.8 Styles
// ─────────────────────────────────────────────────────────────
children.push(
    h2('3.6 Carpeta lang/ — Internacionalización'),
    p(''),
    tbl2([
        ['Archivo', 'Propósito'],
        ['en/aiassignment.php', 'Strings en inglés. ~120 cadenas de texto: títulos, botones, mensajes de error, notificaciones, strings de privacidad.'],
        ['es/aiassignment.php', 'Strings en español. Traducción completa de todos los textos. Incluye strings de notificaciones, contador de caracteres y mensajes de plagio.'],
    ]),
    p(''),
    h2('3.7 Carpeta backup/ — Respaldo y Restauración'),
    p(''),
    tbl2([
        ['Archivo', 'Propósito'],
        ['backup_aiassignment_activity_task.class.php', 'Tarea de respaldo. Define qué datos incluir al hacer backup del curso en Moodle.'],
        ['backup_aiassignment_stepslib.php', 'Pasos del respaldo. Especifica cómo guardar las tablas del plugin en el archivo de backup.'],
        ['restore_aiassignment_activity_task.class.php', 'Tarea de restauración. Define cómo restaurar la actividad desde un backup de Moodle.'],
        ['restore_aiassignment_stepslib.php', 'Pasos de restauración. Especifica cómo recrear las tablas y datos desde el backup.'],
    ]),
    p(''),
    h2('3.8 Carpeta styles/ y pix/'),
    p(''),
    tbl2([
        ['Archivo', 'Propósito'],
        ['styles/dashboard.css', 'Estilos de todo el plugin. Define variables CSS (colores, sombras, radios), tarjetas de estadísticas, tablas, badges de calificación y plagio, botones, avatares con iniciales, gráficas, animaciones de entrada, responsive design y estilos de impresión (@media print).'],
        ['pix/icon.svg', 'Icono del plugin. Aparece en la lista de actividades de Moodle cuando el profesor agrega una tarea al curso.'],
        ['ast_analyzer.py', 'Analizador AST para Python. Recibe dos códigos en JSON base64, los parsea con ast.parse(), extrae métricas estructurales (funciones, bucles, condicionales, profundidad) y devuelve JSON con el score de similitud. Se ejecuta como proceso hijo desde PHP con proc_open().'],
    ]),
    sep(),
    pb(),
);

// ════════════════════════════════════════════════════════════
// 4. DEMO STANDALONE
// ════════════════════════════════════════════════════════════
children.push(
    h1('4. Demos Independientes — demo-standalone/'),
    p('Prototipos funcionales de las APIs desarrollados antes de integrarlas al plugin. Permiten probar cada servicio de forma aislada.'),
    p(''),
    tbl2([
        ['Archivo', 'Propósito'],
        ['server.js', 'Servidor Express con endpoints para probar todas las APIs: /evaluate (Judge0), /scan (VirusTotal), /search (GitHub), /compare-ast (Python AST).'],
        ['plugin-funcional.html/js/css', 'Demo completa del plugin funcionando sin Moodle. Incluye formulario de envío, evaluación simulada y visualización de resultados.'],
        ['services/ast_comparator.js', 'Servicio Node.js que compara dos códigos Python usando el script Python como proceso hijo.'],
        ['services/judge0_service.js', 'Cliente de la API Judge0 para ejecutar código en múltiples lenguajes y obtener el resultado.'],
        ['services/virustotal_service.js', 'Cliente de VirusTotal para escanear archivos y detectar código malicioso.'],
        ['services/github_service.js', 'Cliente de GitHub API para buscar código similar en repositorios públicos.'],
        ['services/python_ast_service.py', 'Versión standalone del analizador AST. Idéntico a ast_analyzer.py del plugin.'],
        ['test-*.js', 'Scripts de prueba para cada API. Ejecutar con: node demo-standalone/test-judge0.js'],
    ]),
    sep(),
    pb(),
);

// ════════════════════════════════════════════════════════════
// 5. DOCUMENTACIÓN
// ════════════════════════════════════════════════════════════
children.push(
    h1('5. Documentación — docs/'),
    h2('5.1 Documentación Técnica (docs/tecnica/)'),
    p(''),
    tbl2([
        ['Archivo', 'Propósito'],
        ['DETECCION_PLAGIO_AUTOMATICA.md', 'Documentación completa del sistema de plagio: 3 capas, parámetros, fórmulas matemáticas, umbrales, técnicas de ofuscación detectadas y flujo completo de una comparación.'],
        ['ARQUITECTURA_COMPLETA.md', 'Estructura completa del proyecto con descripción de cada archivo.'],
        ['CLASES_E_INTERFACES.md', 'Diagrama de clases del sistema con métodos y propiedades.'],
        ['COMPARACION_AST.md', 'Explicación detallada del análisis AST para Python.'],
        ['DIRECTORIO_PROYECTO.md', 'Árbol de directorios con descripción de cada carpeta.'],
        ['TECNOLOGIAS_PROYECTO.md', 'Stack tecnológico completo con versiones y justificación de cada elección.'],
        ['APIS_UTILES_PROYECTO.md', 'APIs evaluadas para el proyecto: Judge0, VirusTotal, GitHub, OpenAI.'],
        ['dbdiagram-code.dbml', 'Código DBML para generar diagrama ER de la BD en dbdiagram.io.'],
        ['diagrama-bd.html', 'Visualización HTML interactiva del diagrama de base de datos.'],
    ]),
    p(''),
    h2('5.2 Guías de Instalación (docs/instalacion/)'),
    p(''),
    tbl2([
        ['Archivo', 'Propósito'],
        ['INSTALACION_RAPIDA.md', 'Guía rápida de instalación en 5 pasos para usuarios con Moodle ya instalado.'],
        ['GUIA_INSTALACION_MOODLE_LOCAL.md', 'Instalación completa de Moodle en local con XAMPP desde cero.'],
        ['CONFIGURAR_API_KEY.md', 'Cómo obtener y configurar la API Key de OpenAI paso a paso.'],
        ['GUIA_PRUEBAS_PLUGIN.md', 'Casos de prueba manuales para validar todas las funcionalidades del plugin.'],
        ['FASE1_APIS.md', 'Documentación de la fase 1 del proyecto: evaluación y selección de APIs.'],
    ]),
    p(''),
    h2('5.3 Documentación de Usuario (docs/usuario/)'),
    p(''),
    tbl2([
        ['Archivo', 'Propósito'],
        ['GUIA_RAPIDA.md', 'Guía rápida de 1 página para profesores y estudiantes.'],
        ['CASOS_PRUEBA_MANUAL.md', 'Casos de prueba paso a paso con resultados esperados.'],
        ['MODO_DEMO_VS_REAL.md', 'Diferencias entre modo demo (sin API) y modo real con OpenAI.'],
    ]),
    p(''),
    h2('5.4 Documentos Principales'),
    p(''),
    tbl2([
        ['Archivo', 'Propósito'],
        ['MANUAL_USUARIO_AI_ASSIGNMENT.docx', 'Manual de usuario completo en Word. Portada, índice, guías paso a paso, tablas de parámetros, FAQ y solución de problemas. Generado con scripts/generar-manual-word.js.'],
        ['ARQUITECTURA_PROYECTO.docx', 'Este documento. Arquitectura técnica completa del proyecto.'],
    ]),
    sep(),
    pb(),
);

// ════════════════════════════════════════════════════════════
// 6. SCRIPTS
// ════════════════════════════════════════════════════════════
children.push(
    h1('6. Scripts SQL y Utilidades — scripts/'),
    p(''),
    tbl2([
        ['Archivo', 'Propósito'],
        ['inscribir-30-alumnos.sql', 'Script de prueba principal. Crea 30 usuarios (est01-est30), los inscribe al curso "test" e inserta envíos con 5 grupos de plagio: Grupo A-B (plagio directo), C (sospechoso), D (código muerto), E (originales). Compatible con MySQL Workbench.'],
        ['schema-moodle.sql', 'Esquema completo de las tablas de Moodle relevantes para el plugin (mdl_user, mdl_course, mdl_enrol, etc.).'],
        ['datos-prueba-plagio.sql', 'Datos de prueba específicos para validar la detección de plagio con casos conocidos.'],
        ['insertar-alumnos-prueba.sql', 'Script simple con 5 alumnos de prueba para pruebas rápidas.'],
        ['crear-zip-moodle.js', 'Script Node.js que empaqueta moodle-plugin/ en dist/mod_aiassignment.zip. Ejecutar: node scripts/crear-zip-moodle.js'],
        ['generar-manual-word.js', 'Script Node.js que genera el manual de usuario en Word usando la librería docx. Ejecutar: node scripts/generar-manual-word.js'],
        ['generar-arquitectura-word.js', 'Este script. Genera el documento de arquitectura en Word.'],
        ['verificar-openai.js', 'Script para probar la conexión con OpenAI API y verificar que la API Key funciona.'],
        ['iniciar-ast-python.bat', 'Script batch para Windows que inicia el servidor Python AST en segundo plano.'],
    ]),
    sep(),
    pb(),
);

// ════════════════════════════════════════════════════════════
// 7. ARCHIVOS DE CONFIGURACIÓN
// ════════════════════════════════════════════════════════════
children.push(
    h1('7. Archivos de Configuración'),
    p(''),
    tbl2([
        ['Archivo', 'Propósito'],
        ['.env', 'Variables de entorno: API Keys de OpenAI, Judge0, VirusTotal, GitHub. NO se sube a Git (está en .gitignore). Usar .env.example como plantilla.'],
        ['.env.example', 'Plantilla del archivo .env con todas las variables necesarias y valores de ejemplo.'],
        ['.gitignore', 'Archivos excluidos de Git: node_modules/, .env, dist/, archivos temporales de PHP y Python.'],
        ['package.json', 'Dependencias Node.js: docx (generar Word), express (servidor demo). Ejecutar npm install para instalar.'],
        ['package-lock.json', 'Lockfile de npm con versiones exactas de todas las dependencias para reproducibilidad.'],
    ]),
    sep(),
    pb(),
);

// ════════════════════════════════════════════════════════════
// 8. FLUJO DE DATOS
// ════════════════════════════════════════════════════════════
children.push(
    h1('8. Flujo de Datos del Sistema'),
    h2('8.1 Flujo de Envío del Estudiante'),
    p(''),
    tbl2([
        ['Paso', 'Descripción'],
        ['1. Acceso', 'Estudiante abre view.php — ve el enunciado, documentación y formulario de envío'],
        ['2. Validación', 'submit.php valida: longitud mínima (10 chars), máxima (10,000), estructura de código, caracteres sospechosos, límite de intentos, duplicados y cooldown de 5 segundos'],
        ['3. Guardado', 'Se inserta en mdl_aiassignment_submissions con status="pending"'],
        ['4. Evaluación IA', 'ai_evaluator::evaluate() construye el prompt, llama a OpenAI con reintentos automáticos y obtiene {similarity_score, feedback, analysis}'],
        ['5. Persistencia', 'Se guarda en mdl_aiassignment_evaluations y se actualiza la submission con status="evaluated" y score=X'],
        ['6. Calificaciones', 'aiassignment_update_grades() actualiza el libro de calificaciones de Moodle'],
        ['7. Notificación', 'Se envía mensaje al estudiante con su calificación y feedback'],
        ['8. Respuesta', 'Redirección a view.php con mensaje de éxito'],
    ]),
    p(''),
    h2('8.2 Flujo de Análisis de Plagio'),
    p(''),
    tbl2([
        ['Paso', 'Descripción'],
        ['1. Inicio', 'Profesor abre plagiarism_report.php — ve botones ⚡ Rápido y 🧠 Completo con tiempo estimado'],
        ['2. AJAX', 'JavaScript llama a plagiarism_ajax.php vía fetch() con AbortController (timeout 6 min)'],
        ['3. Caché', 'plagiarism_detector verifica caché: si no hay envíos nuevos, devuelve resultado guardado instantáneamente'],
        ['4. Comparaciones', 'Para cada par (i,j) de envíos: compare_code(código1, código2, $nosem)'],
        ['5. Capa Léxica', 'Normaliza identificadores, tokeniza, calcula Jaccard de bigramas + LCS ratio → score_léxico'],
        ['6. Capa Estructural', 'Detecta lenguaje, usa AST real (Python) o regex (otros) → score_estructural'],
        ['7. Capa Semántica', 'Si promedio capas 1+2 está entre 20-85% Y modo completo: llama a OpenAI → score_semántico'],
        ['8. Score Final', 'score = léxica×0.35 + estructural×0.30 + semántica×0.35 + boost_ofuscación'],
        ['9. Persistencia', 'Guarda similarity_score en mdl_aiassignment_evaluations para cada usuario'],
        ['10. Respuesta', 'Devuelve JSON con ranking, comparaciones, matriz. JavaScript renderiza los resultados sin recargar la página'],
    ]),
    p(''),
    h2('8.3 Flujo de Calificación Manual'),
    p(''),
    tbl2([
        ['Paso', 'Descripción'],
        ['1. Acceso', 'Profesor abre submission.php — ve el código, evaluación de la IA y formulario de calificación manual'],
        ['2. Historial', 'manual_grade.php lee el ai_analysis JSON y agrega la entrada al array grade_history'],
        ['3. Actualización', 'Se actualiza mdl_aiassignment_submissions con el nuevo score y feedback'],
        ['4. Calificaciones', 'aiassignment_update_grades() sincroniza con el libro de calificaciones de Moodle'],
        ['5. Confirmación', 'Redirección a submission.php con mensaje de éxito y el historial visible'],
    ]),
    p(''),
    h2('8.4 Flujo de Detección de Técnicas de Ofuscación'),
    p('Después de calcular los scores de las 3 capas, el detector ejecuta una fase adicional de identificación de técnicas de ofuscación. Cada técnica detectada incrementa el score final en 5 puntos:'),
    p(''),
    tbl3([
        ['Técnica', 'Condición de Detección', 'Boost Aplicado'],
        ['Renombrado de variables', 'Score léxico normalizado (con sustitución de identificadores) > 60% Y Jaccard literal (sin normalizar, comparando nombres reales) < 40%', '+5 puntos al score final'],
        ['Cambio de tipo de bucle', 'Número de bucles (for + while) diferente entre los dos códigos Y score estructural > 55% (la lógica es similar aunque el tipo de bucle cambió)', '+5 puntos al score final'],
        ['Reordenación de bloques', 'Jaccard de tokens ordenados alfabéticamente > 85% (mismos tokens) Y LCS ratio < 70% (orden diferente)', '+5 puntos al score final'],
        ['Inserción de código muerto', 'Diferencia de tamaño entre los dos códigos > 30% Y score léxico > 55% (el núcleo del código es similar pero uno tiene mucho más código)', '+5 puntos al score final'],
    ]),
    p(''),
    note('El score ajustado nunca supera 100: score_ajustado = min(100, score_final + técnicas_detectadas × 5). Con 4 técnicas detectadas y score_final = 85, el resultado sería min(100, 85 + 20) = 100.'),
    p(''),
    sep(),
    pb(),
);

// ════════════════════════════════════════════════════════════
// 9. TECNOLOGÍAS
// ════════════════════════════════════════════════════════════
children.push(
    h1('9. Tecnologías Utilizadas'),
    p(''),
    tbl4([
        ['Tecnología', 'Versión', 'Uso en el Proyecto', 'Justificación de la Elección'],
        ['PHP', '7.4+', 'Backend del plugin, lógica de negocio, queries a BD, integración con Moodle', 'Requerido por Moodle. No hay alternativa: todos los plugins de Moodle deben estar escritos en PHP para integrarse con el núcleo del sistema.'],
        ['MySQL / MariaDB', '5.7+ / 10.4+', 'Base de datos con 3 tablas y 15 índices optimizados', 'Base de datos estándar de Moodle. El plugin usa la API de base de datos de Moodle ($DB) para compatibilidad con PostgreSQL también.'],
        ['OpenAI GPT-4o-mini', 'API v1', 'Evaluación automática de código y análisis semántico de plagio', 'Mejor relación costo/calidad para análisis de código. GPT-4o-mini cuesta ~10x menos que GPT-4o con resultados comparables para evaluación de código de nivel universitario.'],
        ['Python', '3.8+', 'Análisis AST real para código Python usando ast.parse()', 'Única forma de hacer análisis estructural real de código Python sin ejecutarlo. El módulo ast de Python es parte de la librería estándar, no requiere instalación adicional.'],
        ['JavaScript ES6', 'Nativo', 'AJAX con fetch(), gráficas Chart.js, búsqueda en tiempo real, filtros, ordenamiento', 'Nativo en todos los navegadores modernos. No requiere transpilación ni bundler. Moodle ya incluye soporte para ES6 en sus páginas.'],
        ['Chart.js', '4.x', 'Gráficas de barras, línea, scatter y dona en dashboard y reportes', 'Ya incluido en Moodle como dependencia del núcleo. No requiere instalar dependencias adicionales ni cargar scripts externos. Ligero y con buena documentación.'],
        ['Moodle', '4.0+', 'Plataforma LMS, sistema de permisos, libro de calificaciones, notificaciones, backup', 'Plataforma objetivo del proyecto. El plugin aprovecha toda la infraestructura existente de Moodle en lugar de reimplementarla.'],
        ['Node.js', '18+', 'Scripts de generación (ZIP, Word), servidor de demos standalone', 'Permite usar la librería docx para generar documentos Word y archiver para crear ZIPs. No se usa en producción, solo en desarrollo.'],
        ['docx (npm)', '8.x', 'Generación de documentos Word (.docx) desde JavaScript', 'Única librería madura para generar .docx desde Node.js sin depender de Microsoft Office. API declarativa que facilita la generación programática de documentos complejos.'],
        ['Express.js', '4.x', 'Servidor HTTP para demos independientes de las APIs', 'Framework minimalista para Node.js. Suficiente para los endpoints de prueba de las demos. No se usa en el plugin de Moodle.'],
    ]),
    sep(),
    pb(),
);

// ════════════════════════════════════════════════════════════
// 10. PATRONES DE DISEÑO
// ════════════════════════════════════════════════════════════
children.push(
    h1('10. Patrones de Diseño Aplicados'),
    p(''),
    tbl2([
        ['Patrón', 'Aplicación en el Proyecto'],
        ['MVC (Model-View-Controller)', 'Moodle separa vistas (archivos .php raíz), lógica de negocio (classes/) y acceso a datos (lib.php + DB API de Moodle)'],
        ['Repository Pattern', 'lib.php actúa como capa de acceso a datos con funciones aiassignment_get_* que encapsulan todas las queries SQL'],
        ['Strategy Pattern', 'plagiarism_detector usa diferentes estrategias de análisis según el lenguaje detectado: AST real para Python, regex enriquecido para Java/JS/C++/PHP, genérico para otros'],
        ['Cache-Aside', 'El reporte de plagio verifica la caché de Moodle antes de calcular. Si no hay envíos nuevos, devuelve el resultado guardado sin llamar a la API'],
        ['Observer Pattern', 'Eventos de Moodle (submission_created, submission_graded, course_module_viewed) permiten que otros plugins reaccionen a las acciones del plugin'],
        ['Template Method', 'ai_evaluator::evaluate() define el flujo general (validar → construir prompt → llamar API → parsear respuesta) y delega los detalles a métodos privados según el tipo de problema'],
        ['Facade Pattern', 'plagiarism_ajax.php actúa como fachada que simplifica la interfaz del detector de plagio para el frontend JavaScript'],
    ]),
    sep(),
    pb(),
);

// ════════════════════════════════════════════════════════════
// 11. MÉTRICAS
// ════════════════════════════════════════════════════════════
children.push(
    h1('11. Métricas del Proyecto'),
    p(''),
    tbl2([
        ['Métrica', 'Valor'],
        ['Archivos PHP', '28 archivos'],
        ['Archivos JavaScript', '8 archivos'],
        ['Archivos SQL', '6 archivos'],
        ['Archivos Python', '2 archivos'],
        ['Líneas de código PHP', '~4,500 líneas'],
        ['Líneas de código JavaScript', '~800 líneas'],
        ['Líneas de código Python', '~200 líneas'],
        ['Tablas de base de datos', '3 tablas'],
        ['Índices de base de datos', '15 índices'],
        ['Capacidades (permisos)', '5 capacidades'],
        ['Eventos de Moodle', '3 eventos'],
        ['Strings de idioma', '~120 strings (español + inglés)'],
        ['Páginas del plugin', '14 páginas PHP'],
        ['Funciones en lib.php', '~20 funciones'],
        ['Tamaño del ZIP instalable', '159.8 KB'],
        ['Documentos generados', '2 archivos Word'],
    ]),
    p(''),
    h2('Métricas de Rendimiento'),
    p('Las siguientes métricas fueron medidas en un entorno local con Moodle 4.1, MySQL 8.0, PHP 8.1 y 30 alumnos inscritos en el curso de prueba:'),
    p(''),
    tbl2([
        ['Operación', 'Tiempo / Costo'],
        ['Tiempo de carga del dashboard', '~200 ms (con índices de BD activos)'],
        ['Tiempo de análisis de plagio — Modo Rápido (30 alumnos)', '~20 segundos (sin llamadas a OpenAI)'],
        ['Tiempo de análisis de plagio — Modo Completo (30 alumnos)', '~3-5 minutos (con llamadas a OpenAI para pares sospechosos)'],
        ['Queries por carga del dashboard', '8 queries (optimizado desde 15+ queries originales)'],
        ['Queries por carga de submissions (20 registros)', '3 queries (1 para datos, 1 para total, 1 para similarity scores)'],
        ['Tamaño de caché del reporte de plagio', '~50-200 KB según número de alumnos y comparaciones'],
        ['Tiempo de evaluación individual (modo real)', '~2-5 segundos por envío (depende de la API de OpenAI)'],
        ['Tiempo de evaluación individual (modo demo)', '< 50 ms (sin llamadas externas)'],
        ['Queries por envío de estudiante', '4 queries (validación, insert, update, grade_update)'],
    ]),
    p(''),
    note('El dashboard pasó de 15+ queries a 8 queries consolidadas gracias al uso de SUM(CASE WHEN) y COUNT(DISTINCT) en queries únicas. Esto redujo el tiempo de carga de ~800ms a ~200ms en el entorno de prueba.'),
    p(''),
    sep(),
    pb(),
);

// ════════════════════════════════════════════════════════════
// 12. CUMPLIMIENTO MOODLE
// ════════════════════════════════════════════════════════════
children.push(
    h1('12. Cumplimiento de Estándares Moodle'),
    p(''),
    tbl2([
        ['Estándar', 'Estado'],
        ['Estructura de carpetas estándar (db/, lang/, classes/, backup/)', '✅ Implementado'],
        ['Archivo version.php con metadatos correctos', '✅ Implementado'],
        ['Funciones requeridas en lib.php (_add, _update, _delete, _supports)', '✅ Implementado'],
        ['Sistema de capacidades (permisos) definido en db/access.php', '✅ Implementado'],
        ['Eventos de Moodle para logs de actividad', '✅ Implementado'],
        ['Integración con libro de calificaciones (grade_update)', '✅ Implementado'],
        ['Backup y restauración de actividades', '✅ Implementado'],
        ['Cumplimiento GDPR con privacy/provider.php', '✅ Implementado'],
        ['Internacionalización (inglés + español)', '✅ Implementado'],
        ['Responsive design con CSS moderno', '✅ Implementado'],
        ['Accesibilidad básica (labels, ARIA, contraste)', '✅ Implementado'],
        ['Caché de Moodle (cache::make)', '✅ Implementado'],
        ['Sistema de mensajes de Moodle (message_send)', '✅ Implementado'],
        ['Índices de BD para rendimiento', '✅ Implementado'],
        ['Tests automatizados (PHPUnit)', '❌ Pendiente'],
    ]),
    p(''),
    note('El único estándar pendiente son los tests automatizados. Para una tesis de licenciatura esto es aceptable, pero sería el siguiente paso para llevar el plugin a producción real.'),
    p(''),
    new Paragraph({
        children: [new TextRun({
            text: 'Plugin AI Assignment v1.5.0 — Documentación Técnica — Equipo 8 — Tesis de Licenciatura — Abril 2026',
            size: 18, color: C.gray, italics: true,
        })],
        alignment: AlignmentType.CENTER,
        spacing: { before: 400 },
    }),
);

// ════════════════════════════════════════════════════════════
// GENERAR DOCUMENTO
// ════════════════════════════════════════════════════════════
const doc = new Document({
    creator: 'AI Assignment Plugin — Equipo 8',
    title: 'Arquitectura y Estructura del Proyecto — AI Assignment para Moodle',
    description: 'Documentación técnica completa de la arquitectura del plugin mod_aiassignment',
    styles: {
        default: {
            document: { run: { font: 'Calibri', size: 22, color: C.black } },
        },
        paragraphStyles: [
            { id: 'Heading1', name: 'Heading 1',
              run: { font: 'Calibri', size: 36, bold: true, color: C.dark },
              paragraph: { spacing: { before: 480, after: 200 } } },
            { id: 'Heading2', name: 'Heading 2',
              run: { font: 'Calibri', size: 28, bold: true, color: C.primary },
              paragraph: { spacing: { before: 360, after: 160 } } },
            { id: 'Heading3', name: 'Heading 3',
              run: { font: 'Calibri', size: 24, bold: true, color: C.dark },
              paragraph: { spacing: { before: 240, after: 120 } } },
        ],
    },
    sections: [{
        properties: {
            page: {
                margin: {
                    top:    convertInchesToTwip(1),
                    right:  convertInchesToTwip(1),
                    bottom: convertInchesToTwip(1),
                    left:   convertInchesToTwip(1.2),
                },
            },
        },
        headers: {
            default: new Header({
                children: [new Paragraph({
                    children: [new TextRun({
                        text: 'Arquitectura del Proyecto — Plugin AI Assignment para Moodle',
                        size: 18, color: C.gray,
                    })],
                    border: { bottom: { style: BorderStyle.SINGLE, size: 1, color: 'e5e7eb' } },
                })],
            }),
        },
        footers: {
            default: new Footer({
                children: [new Paragraph({
                    children: [
                        new TextRun({ text: 'Página ', size: 18, color: C.gray }),
                        new TextRun({ children: [PageNumber.CURRENT], size: 18, color: C.gray }),
                        new TextRun({ text: ' de ', size: 18, color: C.gray }),
                        new TextRun({ children: [PageNumber.TOTAL_PAGES], size: 18, color: C.gray }),
                        new TextRun({ text: '   |   Equipo 8 — Tesis de Licenciatura — Abril 2026', size: 18, color: C.gray }),
                    ],
                    alignment: AlignmentType.CENTER,
                })],
            }),
        },
        children,
    }],
});

const outPath = path.join(__dirname, '..', 'docs', 'ARQUITECTURA_PROYECTO.docx');
Packer.toBuffer(doc).then(buf => {
    fs.writeFileSync(outPath, buf);
    console.log(`✅ Documento generado: ${outPath}`);
    console.log(`📄 Tamaño: ${Math.round(buf.length / 1024)} KB`);
    console.log(`📋 Secciones: Portada, Índice, Visión General, Directorios, Plugin (8 subsecciones con detalle expandido), Demos, Docs, Scripts, Config, Flujos de Datos (4 flujos), Tecnologías (con justificación), Patrones, Métricas (con rendimiento), Cumplimiento Moodle`);
}).catch(e => console.error('❌ Error:', e.message));
