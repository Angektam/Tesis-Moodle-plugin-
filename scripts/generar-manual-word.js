/**
 * Generador del Manual de Usuario — Plugin AI Assignment para Moodle
 * Ejecutar: node scripts/generar-manual-word.js
 * Genera: docs/MANUAL_USUARIO_AI_ASSIGNMENT.docx
 */

const {
    Document, Packer, Paragraph, TextRun, HeadingLevel,
    AlignmentType, Table, TableRow, TableCell, WidthType,
    BorderStyle, ShadingType, PageBreak, NumberFormat,
    Header, Footer, PageNumber, Tab, TabStopType, TabStopLeader,
    LevelFormat, convertInchesToTwip
} = require('docx');
const fs = require('fs');
const path = require('path');

// ── Helpers de estilo ─────────────────────────────────────────
const COLOR = {
    primary:   '1a73e8',
    danger:    'dc3545',
    success:   '28a745',
    warning:   'ffc107',
    gray:      '6b7280',
    lightgray: 'f3f4f6',
    black:     '111827',
    white:     'ffffff',
};

const h1 = (text) => new Paragraph({
    text,
    heading: HeadingLevel.HEADING_1,
    spacing: { before: 400, after: 200 },
    run: { color: COLOR.primary, bold: true, size: 32 },
});

const h2 = (text) => new Paragraph({
    text,
    heading: HeadingLevel.HEADING_2,
    spacing: { before: 300, after: 150 },
    run: { color: COLOR.primary, bold: true, size: 26 },
});

const h3 = (text) => new Paragraph({
    text,
    heading: HeadingLevel.HEADING_3,
    spacing: { before: 200, after: 100 },
    run: { color: COLOR.black, bold: true, size: 22 },
});

const p = (text, opts = {}) => new Paragraph({
    children: [new TextRun({ text, size: 22, color: COLOR.black, ...opts })],
    spacing: { before: 80, after: 80 },
    alignment: AlignmentType.JUSTIFIED,
});

const bullet = (text) => new Paragraph({
    children: [new TextRun({ text, size: 22, color: COLOR.black })],
    bullet: { level: 0 },
    spacing: { before: 60, after: 60 },
});

const note = (text, color = COLOR.primary) => new Paragraph({
    children: [
        new TextRun({ text: '💡 Nota: ', bold: true, size: 20, color }),
        new TextRun({ text, size: 20, color }),
    ],
    spacing: { before: 100, after: 100 },
    indent: { left: 360 },
    border: { left: { style: BorderStyle.SINGLE, size: 6, color } },
});

const warning = (text) => note(text, COLOR.danger);

const step = (num, text) => new Paragraph({
    children: [
        new TextRun({ text: `${num}. `, bold: true, size: 22, color: COLOR.primary }),
        new TextRun({ text, size: 22, color: COLOR.black }),
    ],
    spacing: { before: 80, after: 80 },
    indent: { left: 360 },
});

const pageBreak = () => new Paragraph({ children: [new PageBreak()] });

const separator = () => new Paragraph({
    border: { bottom: { style: BorderStyle.SINGLE, size: 2, color: COLOR.lightgray } },
    spacing: { before: 200, after: 200 },
});

const tableRow2 = (col1, col2, header = false) => new TableRow({
    children: [
        new TableCell({
            children: [new Paragraph({
                children: [new TextRun({ text: col1, bold: header, size: 20,
                    color: header ? COLOR.white : COLOR.black })],
            })],
            shading: header ? { fill: COLOR.primary, type: ShadingType.CLEAR } :
                              { fill: 'f8f9fa', type: ShadingType.CLEAR },
            width: { size: 30, type: WidthType.PERCENTAGE },
        }),
        new TableCell({
            children: [new Paragraph({
                children: [new TextRun({ text: col2, bold: header, size: 20,
                    color: header ? COLOR.white : COLOR.black })],
            })],
            shading: header ? { fill: COLOR.primary, type: ShadingType.CLEAR } :
                              { fill: COLOR.white, type: ShadingType.CLEAR },
            width: { size: 70, type: WidthType.PERCENTAGE },
        }),
    ],
});

const table2 = (rows) => new Table({
    rows: rows.map((r, i) => tableRow2(r[0], r[1], i === 0)),
    width: { size: 100, type: WidthType.PERCENTAGE },
    margins: { top: 80, bottom: 80, left: 120, right: 120 },
});

const tableRow3 = (c1, c2, c3, header = false) => new TableRow({
    children: [c1, c2, c3].map((text, idx) => new TableCell({
        children: [new Paragraph({
            children: [new TextRun({ text, bold: header, size: 20,
                color: header ? COLOR.white : COLOR.black })],
        })],
        shading: header ? { fill: COLOR.primary, type: ShadingType.CLEAR } :
                          { fill: idx % 2 === 0 ? 'f8f9fa' : COLOR.white, type: ShadingType.CLEAR },
        width: { size: 33, type: WidthType.PERCENTAGE },
    })),
});

const table3 = (rows) => new Table({
    rows: rows.map((r, i) => tableRow3(r[0], r[1], r[2], i === 0)),
    width: { size: 100, type: WidthType.PERCENTAGE },
    margins: { top: 80, bottom: 80, left: 120, right: 120 },
});

// ── Contenido del documento ───────────────────────────────────
const sections = [];

// ════════════════════════════════════════════════════════════
// PORTADA
// ════════════════════════════════════════════════════════════
sections.push(
    new Paragraph({
        children: [new TextRun({ text: '', size: 22 })],
        spacing: { before: 1200 },
    }),
    new Paragraph({
        children: [new TextRun({
            text: 'MANUAL DE USUARIO',
            bold: true, size: 52, color: COLOR.primary,
        })],
        alignment: AlignmentType.CENTER,
        spacing: { before: 200, after: 100 },
    }),
    new Paragraph({
        children: [new TextRun({
            text: 'Plugin AI Assignment para Moodle',
            bold: true, size: 36, color: COLOR.black,
        })],
        alignment: AlignmentType.CENTER,
        spacing: { before: 100, after: 100 },
    }),
    new Paragraph({
        children: [new TextRun({
            text: 'Sistema de Evaluación Automática y Detección de Plagio con IA',
            size: 26, color: COLOR.gray, italics: true,
        })],
        alignment: AlignmentType.CENTER,
        spacing: { before: 100, after: 600 },
    }),
    new Paragraph({
        children: [new TextRun({ text: 'Versión 1.3.0', size: 22, color: COLOR.gray })],
        alignment: AlignmentType.CENTER,
        spacing: { before: 100, after: 60 },
    }),
    new Paragraph({
        children: [new TextRun({ text: 'Abril 2026', size: 22, color: COLOR.gray })],
        alignment: AlignmentType.CENTER,
        spacing: { before: 60, after: 60 },
    }),
    new Paragraph({
        children: [new TextRun({ text: 'Equipo 8 — Tesis de Licenciatura', size: 22, color: COLOR.gray })],
        alignment: AlignmentType.CENTER,
        spacing: { before: 60, after: 60 },
    }),
    pageBreak(),
);

// ════════════════════════════════════════════════════════════
// ÍNDICE
// ════════════════════════════════════════════════════════════
sections.push(
    h1('Índice de Contenidos'),
    ...[
        ['1.', 'Introducción', '3'],
        ['2.', 'Requisitos del Sistema', '3'],
        ['3.', 'Instalación del Plugin', '4'],
        ['4.', 'Configuración Inicial', '5'],
        ['5.', 'Guía para el Profesor', '6'],
        ['  5.1', 'Crear una Tarea con IA', '6'],
        ['  5.2', 'Ver Envíos de Estudiantes', '7'],
        ['  5.3', 'Dashboard del Curso', '8'],
        ['  5.4', 'Detección de Plagio', '9'],
        ['  5.5', 'Calificación Manual', '11'],
        ['  5.6', 'Solicitar Re-envío', '12'],
        ['  5.7', 'Reporte del Curso', '12'],
        ['  5.8', 'Estadísticas por Alumno', '13'],
        ['6.', 'Guía para el Estudiante', '14'],
        ['  6.1', 'Enviar una Respuesta', '14'],
        ['  6.2', 'Ver Resultados de Evaluación', '15'],
        ['7.', 'Parámetros de Detección de Plagio', '16'],
        ['8.', 'Preguntas Frecuentes', '18'],
        ['9.', 'Solución de Problemas', '19'],
    ].map(([num, title, page]) => new Paragraph({
        children: [
            new TextRun({ text: `${num}  ${title}`, size: 22, color: COLOR.black }),
            new TextRun({ text: `  .....  ${page}`, size: 22, color: COLOR.gray }),
        ],
        spacing: { before: 60, after: 60 },
        indent: { left: num.startsWith('  ') ? 360 : 0 },
    })),
    pageBreak(),
);

// ════════════════════════════════════════════════════════════
// 1. INTRODUCCIÓN
// ════════════════════════════════════════════════════════════
sections.push(
    h1('1. Introducción'),
    p('El plugin AI Assignment es un módulo de actividad para Moodle que permite a los profesores crear tareas de programación o matemáticas evaluadas automáticamente mediante Inteligencia Artificial (OpenAI GPT). Además, incluye un sistema avanzado de detección de plagio en código fuente que analiza los envíos de los estudiantes en tres capas: léxica, estructural y semántica.'),
    p(''),
    h2('Características principales'),
    bullet('Evaluación automática de código con IA (OpenAI GPT-4o-mini)'),
    bullet('Detección de plagio en 3 capas con análisis AST para Python'),
    bullet('Dashboard del profesor con estadísticas en tiempo real'),
    bullet('Reporte de plagio con matriz de similitud y gráficas'),
    bullet('Calificación manual para sobrescribir la nota de la IA'),
    bullet('Solicitud de re-envío con notificación al estudiante'),
    bullet('Exportación de reportes a CSV y PDF'),
    bullet('Historial de intentos con gráfica de evolución'),
    separator(),
);

// ════════════════════════════════════════════════════════════
// 2. REQUISITOS
// ════════════════════════════════════════════════════════════
sections.push(
    h1('2. Requisitos del Sistema'),
    table2([
        ['Componente', 'Requisito'],
        ['Moodle', 'Versión 4.0 o superior'],
        ['PHP', 'Versión 7.4 o superior'],
        ['Base de datos', 'MySQL 5.7+ o MariaDB 10.4+'],
        ['OpenAI API Key', 'Cuenta en platform.openai.com (para evaluación con IA)'],
        ['Python (opcional)', 'Python 3.8+ para análisis AST de código Python'],
        ['Navegador', 'Chrome, Firefox, Edge o Safari actualizados'],
    ]),
    p(''),
    note('El plugin puede funcionar en Modo Demo sin API Key de OpenAI. En este modo la evaluación es simulada y no requiere conexión a internet.'),
    separator(),
    pageBreak(),
);

// ════════════════════════════════════════════════════════════
// 3. INSTALACIÓN
// ════════════════════════════════════════════════════════════
sections.push(
    h1('3. Instalación del Plugin'),
    h2('3.1 Instalación desde la interfaz de Moodle'),
    step(1, 'Inicia sesión en Moodle como Administrador del sitio.'),
    step(2, 'Ve a: Administración del sitio → Plugins → Instalar plugins.'),
    step(3, 'Haz clic en "Seleccionar un archivo" y sube el archivo mod_aiassignment.zip.'),
    step(4, 'Haz clic en "Instalar plugin desde el archivo ZIP".'),
    step(5, 'Moodle verificará el plugin. Haz clic en "Continuar".'),
    step(6, 'Revisa la información del plugin y haz clic en "Actualizar base de datos de Moodle ahora".'),
    step(7, 'Espera a que termine la instalación y haz clic en "Continuar".'),
    p(''),
    note('Si ya tienes una versión anterior instalada, Moodle detectará la actualización automáticamente y te pedirá confirmar la migración de la base de datos.'),
    p(''),
    h2('3.2 Verificar la instalación'),
    p('Después de instalar, ve a Administración del sitio → Plugins → Módulos de actividad y verifica que "AI Assignment" aparece en la lista con estado "Habilitado".'),
    separator(),
);

// ════════════════════════════════════════════════════════════
// 4. CONFIGURACIÓN INICIAL
// ════════════════════════════════════════════════════════════
sections.push(
    h1('4. Configuración Inicial'),
    p('Antes de usar el plugin, el administrador debe configurar la API Key de OpenAI.'),
    p(''),
    h2('4.1 Configurar la API Key de OpenAI'),
    step(1, 'Ve a: Administración del sitio → Plugins → Módulos de actividad → AI Assignment.'),
    step(2, 'En el campo "Clave API de OpenAI", ingresa tu API Key (comienza con sk-...).'),
    step(3, 'Selecciona el modelo de OpenAI (recomendado: gpt-4o-mini).'),
    step(4, 'Haz clic en "Guardar cambios".'),
    p(''),
    h2('4.2 Parámetros de configuración disponibles'),
    table2([
        ['Parámetro', 'Descripción'],
        ['Clave API de OpenAI', 'Tu API Key de OpenAI. Obtenla en platform.openai.com/api-keys'],
        ['Modelo de OpenAI', 'Modelo a usar: gpt-4o-mini (rápido/económico) o gpt-4o (más potente)'],
        ['Modo demostración', 'Activa evaluación simulada sin necesidad de API Key'],
        ['Umbral de plagio (%)', 'Porcentaje mínimo para considerar plagio probable. Por defecto: 75%'],
        ['Reintentos OpenAI', 'Número de reintentos automáticos si la API falla. Por defecto: 2'],
        ['Longitud máxima de envío', 'Máximo de caracteres permitidos por envío. Por defecto: 10,000'],
    ]),
    p(''),
    warning('Nunca compartas tu API Key. Si la expones accidentalmente, revócala inmediatamente en platform.openai.com.'),
    separator(),
    pageBreak(),
);

// ════════════════════════════════════════════════════════════
// 5. GUÍA PARA EL PROFESOR
// ════════════════════════════════════════════════════════════
sections.push(
    h1('5. Guía para el Profesor'),
    h2('5.1 Crear una Tarea con IA'),
    p('Para agregar una nueva tarea al curso:'),
    step(1, 'Activa el "Modo de edición" en tu curso.'),
    step(2, 'Haz clic en "Añadir una actividad o recurso".'),
    step(3, 'Selecciona "Tarea con IA" de la lista.'),
    step(4, 'Completa el formulario con los siguientes campos:'),
    p(''),
    table2([
        ['Campo', 'Descripción'],
        ['Nombre de la tarea', 'Título que verán los estudiantes'],
        ['Descripción', 'Enunciado del problema (visible para estudiantes)'],
        ['Tipo de problema', 'Programación o Matemáticas'],
        ['Solución de referencia', 'La solución correcta que usará la IA para comparar (NO visible para estudiantes)'],
        ['Documentación adicional', 'Información extra opcional para los estudiantes'],
        ['Casos de prueba', 'Ejemplos de entrada/salida opcionales'],
        ['Intentos máximos', 'Número máximo de envíos permitidos (0 = ilimitado)'],
    ]),
    step(5, 'Haz clic en "Guardar y mostrar".'),
    p(''),
    note('La solución de referencia es confidencial. Los estudiantes nunca la ven. Solo la usa la IA internamente para evaluar.'),
    p(''),
    h2('5.2 Ver Envíos de Estudiantes'),
    p('Desde la tarea, haz clic en "Ver todos los envíos" o accede desde el Dashboard.'),
    p('La tabla de envíos muestra:'),
    bullet('Nombre del estudiante'),
    bullet('Fecha y hora de envío'),
    bullet('Número de intento'),
    bullet('Estado: Evaluado / Pendiente / Re-envío solicitado'),
    bullet('Calificación asignada por la IA (0-100%)'),
    bullet('Porcentaje de plagio detectado (rojo ≥75%, amarillo 50-74%, verde <50%)'),
    p(''),
    p('Puedes buscar un estudiante específico usando el campo de búsqueda en tiempo real. La tabla también tiene paginación de 20 registros por página.'),
    p(''),
    note('Haz clic en el botón "Ver" de cualquier envío para ver el código completo, la evaluación de la IA y las opciones de gestión.'),
    separator(),
);

// ── 5.3 Dashboard ─────────────────────────────────────────────
sections.push(
    h2('5.3 Dashboard del Curso'),
    p('El Dashboard es el panel de control principal del profesor. Accede desde cualquier tarea → botón "Panel de control".'),
    p(''),
    h3('Tarjetas de estadísticas'),
    table2([
        ['Tarjeta', 'Qué muestra'],
        ['Total de Tareas', 'Número de tareas AI Assignment en el curso'],
        ['Promedio General', 'Calificación promedio de todos los envíos evaluados'],
        ['Estudiantes Activos', 'Número de estudiantes que han enviado al menos una vez'],
        ['Evaluaciones Pendientes', 'Envíos que aún no han sido evaluados por la IA'],
        ['Alertas de Plagio 🔴', 'Número de alumnos con similitud ≥ 75%. Clic para ir al reporte'],
    ]),
    p(''),
    h3('Secciones del Dashboard'),
    bullet('Resumen de Tareas: tabla con todas las tareas, número de envíos, promedio y accesos rápidos'),
    bullet('Envíos Recientes: últimos 15 envíos con calificación y % de plagio. Filtrable por tarea'),
    bullet('Distribución de Calificaciones: gráfica de barras con rangos 90-100, 80-89, 70-79, 60-69, <60'),
    bullet('Top Estudiantes: ranking de los 8 mejores alumnos con medallas de oro/plata/bronce'),
    bullet('Alumnos en Riesgo: tabla de alumnos con plagio ≥ 75% y acceso directo a sus envíos'),
    bullet('Actividad últimos 7 días: gráfica de línea con envíos por día'),
    bullet('Correlación Plagio vs Calificación: scatter plot para análisis de la tesis'),
    p(''),
    note('El botón "📊 Reporte del Curso" genera un reporte completo exportable a CSV o imprimible como PDF.'),
    separator(),
);

// ── 5.4 Detección de Plagio ────────────────────────────────────
sections.push(
    h2('5.4 Detección de Plagio'),
    p('El sistema analiza todos los envíos entre sí para detectar similitudes sospechosas. Accede desde:'),
    bullet('Dashboard → botón "🔍 Plagio" en la tabla de tareas'),
    bullet('Lista de envíos → botón "🔍 Iniciar análisis de plagio"'),
    p(''),
    h3('Modos de análisis'),
    table3([
        ['Modo', 'Descripción', 'Tiempo estimado (30 alumnos)'],
        ['⚡ Modo Rápido', 'Análisis léxico + estructural sin IA. Detecta copias directas y renombrado de variables.', '~20 segundos'],
        ['🧠 Modo Completo', 'Las 3 capas incluyendo OpenAI. Detecta también reescrituras lógicas y ofuscación avanzada.', '~3-5 minutos'],
    ]),
    p(''),
    h3('Resultados del reporte'),
    p('El reporte muestra:'),
    bullet('Tarjetas resumen: total envíos, comparaciones realizadas, pares sospechosos, similitud máxima'),
    bullet('Ranking de alumnos: ordenado de mayor a menor % de plagio con barra visual'),
    bullet('Matriz de similitud: tabla NxN con colores (verde/amarillo/rojo) para ver de un vistazo qué pares son sospechosos'),
    bullet('Comparaciones detalladas: cada par con score por capa, técnicas detectadas y análisis de la IA'),
    p(''),
    h3('Acciones sobre un caso de plagio'),
    p('En cada comparación detallada puedes:'),
    bullet('Ver código lado a lado: expandir para comparar el código de ambos alumnos'),
    bullet('✅ Confirmar plagio: marca el caso como plagio confirmado (queda registrado)'),
    bullet('❌ Falso positivo: descarta el caso si la similitud es coincidencia'),
    p(''),
    h3('Exportar resultados'),
    p('Haz clic en "⬇️ Exportar a CSV" para descargar el reporte completo en formato Excel-compatible con todos los pares, scores por capa y técnicas detectadas.'),
    p(''),
    note('El sistema usa caché inteligente: si no hay envíos nuevos desde el último análisis, muestra el resultado guardado instantáneamente. Usa "Forzar nuevo análisis" para recalcular.'),
    separator(),
);

// ── 5.5 Calificación Manual ────────────────────────────────────
sections.push(
    h2('5.5 Calificación Manual'),
    p('Si la IA asigna una calificación incorrecta, el profesor puede sobrescribirla:'),
    step(1, 'Abre el envío del estudiante (botón "Ver" en la lista de envíos).'),
    step(2, 'Desplázate hasta la sección "✏️ Calificación Manual".'),
    step(3, 'Ingresa el nuevo valor (0-100) en el campo de calificación.'),
    step(4, 'Opcionalmente, escribe un comentario explicando el cambio.'),
    step(5, 'Haz clic en "💾 Guardar calificación".'),
    p(''),
    p('La calificación se actualiza inmediatamente en el libro de calificaciones de Moodle y el estudiante puede verla en su historial de envíos.'),
    separator(),
);

// ── 5.6 Solicitar Re-envío ─────────────────────────────────────
sections.push(
    h2('5.6 Solicitar Re-envío'),
    p('Cuando se detecta plagio o la solución es incorrecta, puedes pedir al estudiante que envíe una nueva versión:'),
    step(1, 'Abre el envío del estudiante.'),
    step(2, 'Desplázate hasta "📝 Solicitar Re-envío al Estudiante".'),
    step(3, 'Escribe el motivo (opcional pero recomendado). Ejemplo: "Se detectó plagio. Por favor envía una solución original."'),
    step(4, 'Haz clic en "📩 Solicitar Re-envío" y confirma.'),
    p(''),
    p('El sistema automáticamente:'),
    bullet('Marca el envío como "Re-envío solicitado" en la lista'),
    bullet('Envía una notificación por Moodle al estudiante con el motivo'),
    bullet('Permite al estudiante enviar una nueva versión aunque haya alcanzado el límite de intentos'),
    p(''),
    note('También puedes solicitar re-envío directamente desde la lista de envíos con el botón 📩 sin necesidad de abrir el detalle.'),
    separator(),
);

// ── 5.7 Reporte del Curso ──────────────────────────────────────
sections.push(
    h2('5.7 Reporte del Curso'),
    p('El reporte del curso consolida todas las estadísticas en un solo documento. Accede desde Dashboard → "📊 Reporte del Curso".'),
    p(''),
    p('El reporte incluye:'),
    bullet('Resumen general: total de tareas, envíos, estudiantes activos, promedio, tasa de aprobación y alertas de plagio'),
    bullet('Distribución de calificaciones: gráfica de barras con porcentajes por rango'),
    bullet('Detalle por tarea: tabla con envíos y promedio de cada tarea'),
    p(''),
    p('Opciones de exportación:'),
    bullet('⬇️ Exportar CSV: descarga el reporte completo en formato Excel-compatible'),
    bullet('🖨️ Imprimir / PDF: abre el diálogo de impresión del navegador (selecciona "Guardar como PDF")'),
    separator(),
);

// ── 5.8 Estadísticas por Alumno ────────────────────────────────
sections.push(
    h2('5.8 Estadísticas por Alumno'),
    p('Para ver el historial completo de un alumno específico:'),
    step(1, 'Ve al Dashboard → sección "Top Estudiantes".'),
    step(2, 'Haz clic en el nombre de cualquier alumno.'),
    p(''),
    p('La página de estadísticas muestra:'),
    bullet('Tarjetas: total de envíos, promedio de calificaciones, plagio máximo detectado'),
    bullet('Gráfica de evolución: línea de progreso entre intentos (si tiene más de 1 envío evaluado)'),
    bullet('Historial completo: tabla con todas sus entregas, calificación, % de plagio y estado'),
    separator(),
    pageBreak(),
);

// ════════════════════════════════════════════════════════════
// 6. GUÍA PARA EL ESTUDIANTE
// ════════════════════════════════════════════════════════════
sections.push(
    h1('6. Guía para el Estudiante'),
    h2('6.1 Enviar una Respuesta'),
    step(1, 'Accede al curso en Moodle y haz clic en la tarea con IA.'),
    step(2, 'Lee el enunciado del problema y la documentación adicional si la hay.'),
    step(3, 'Escribe tu solución en el área de texto. El contador en la esquina inferior derecha muestra cuántos caracteres llevas (máximo 10,000).'),
    step(4, 'Haz clic en "Enviar".'),
    step(5, 'Verás el mensaje "⏳ Evaluando con IA... por favor espera." mientras la IA procesa tu código.'),
    step(6, 'En unos segundos recibirás tu calificación y retroalimentación.'),
    p(''),
    warning('No envíes código copiado de internet o de otros compañeros. El sistema detecta automáticamente similitudes con otros envíos del curso.'),
    p(''),
    h3('Consejos para obtener una buena calificación'),
    bullet('Escribe código funcional que resuelva el problema planteado'),
    bullet('Usa nombres de variables descriptivos'),
    bullet('Incluye comentarios explicando tu lógica'),
    bullet('Prueba tu código antes de enviarlo'),
    bullet('Si el sistema rechaza tu envío por "no parece código", asegúrate de incluir al menos una función, bucle o condicional'),
    separator(),
);

sections.push(
    h2('6.2 Ver Resultados de Evaluación'),
    p('Después de enviar, puedes ver tus resultados en cualquier momento:'),
    step(1, 'Accede a la tarea en Moodle.'),
    step(2, 'En la sección "Tus envíos" verás todos tus intentos con su calificación.'),
    step(3, 'Si tienes más de un intento evaluado, verás una gráfica de línea con tu evolución.'),
    step(4, 'Haz clic en "Ver detalles" para ver el análisis completo de la IA.'),
    p(''),
    h3('Secciones del detalle de evaluación'),
    table2([
        ['Sección', 'Descripción'],
        ['Calificación', 'Porcentaje asignado por la IA (0-100%) con barra de progreso'],
        ['Retroalimentación', 'Comentario breve de la IA sobre tu solución'],
        ['Análisis detallado', 'Análisis expandible por secciones: Funcionalidad, Estilo, Eficiencia, Buenas prácticas'],
    ]),
    p(''),
    h3('¿Qué hacer si recibes una calificación baja?'),
    bullet('Lee el análisis detallado de la IA para entender qué mejorar'),
    bullet('Si tienes intentos disponibles, corrige tu código y vuelve a enviar'),
    bullet('Si crees que la calificación es incorrecta, contacta a tu profesor para que la revise manualmente'),
    p(''),
    h3('Re-envío solicitado por el profesor'),
    p('Si recibes una notificación de "Re-envío solicitado", significa que el profesor ha pedido que envíes una nueva versión de tu trabajo. Verás un aviso en la tarea con el motivo. Puedes enviar aunque hayas alcanzado el límite de intentos.'),
    separator(),
    pageBreak(),
);

// ════════════════════════════════════════════════════════════
// 7. PARÁMETROS DE DETECCIÓN DE PLAGIO
// ════════════════════════════════════════════════════════════
sections.push(
    h1('7. Parámetros de Detección de Plagio'),
    p('El sistema usa tres capas de análisis para calcular el porcentaje de similitud entre dos envíos.'),
    p(''),
    h2('Fórmula del score final'),
    new Paragraph({
        children: [new TextRun({
            text: 'score_final = (léxica × 35%) + (estructural × 30%) + (semántica × 35%)',
            bold: true, size: 22, color: COLOR.primary,
            font: 'Courier New',
        })],
        alignment: AlignmentType.CENTER,
        spacing: { before: 200, after: 200 },
        border: {
            top: { style: BorderStyle.SINGLE, size: 2, color: COLOR.primary },
            bottom: { style: BorderStyle.SINGLE, size: 2, color: COLOR.primary },
        },
        indent: { left: 360, right: 360 },
    }),
    p(''),
    h2('Capa 1 — Análisis Léxico (35%)'),
    p('Compara los tokens del código después de normalizar identificadores. Resistente al renombrado de variables.'),
    table2([
        ['Parámetro', 'Descripción'],
        ['Jaccard de bigramas', 'Proporción de pares de tokens consecutivos en común'],
        ['LCS ratio', 'Longest Common Subsequence normalizada'],
        ['Score léxico', 'Promedio de Jaccard + LCS'],
    ]),
    p(''),
    h2('Capa 2 — Análisis Estructural (30%)'),
    p('Compara la estructura del código. Para Python usa AST real; para otros lenguajes usa análisis de patrones.'),
    table2([
        ['Parámetro', 'Descripción'],
        ['functions', 'Número de funciones/métodos definidos'],
        ['loops', 'Número de bucles (for, while, do)'],
        ['conditionals', 'Número de condicionales (if, elif, switch)'],
        ['returns', 'Número de sentencias return'],
        ['nested_depth', 'Profundidad máxima de anidamiento'],
        ['operators_count', 'Cantidad de operadores aritméticos y lógicos'],
        ['control_sequence', 'Orden de las estructuras de control (Jaccard)'],
    ]),
    p(''),
    h2('Capa 3 — Análisis Semántico con IA (35%)'),
    p('OpenAI GPT analiza si la lógica de los dos códigos es equivalente aunque se vean diferentes.'),
    table2([
        ['Parámetro', 'Descripción'],
        ['similarity_score', 'Porcentaje de similitud semántica (0-100)'],
        ['analysis', 'Explicación en español de las similitudes encontradas'],
        ['techniques_found', 'Lista de técnicas de ofuscación detectadas por la IA'],
        ['verdict', 'Veredicto: original / sospechoso / plagio'],
    ]),
    p(''),
    h2('Técnicas de ofuscación detectadas automáticamente'),
    table2([
        ['Técnica', 'Cómo se detecta'],
        ['Renombrado de variables/funciones', 'Score léxico normalizado alto pero Jaccard de tokens literales bajo'],
        ['Cambio de tipo de bucle (for↔while↔recursión)', 'Número de bucles diferente pero score estructural alto'],
        ['Reordenación de sentencias', 'Jaccard de tokens ordenados alto pero LCS bajo'],
        ['Inserción de código muerto', 'Diferencia de tamaño >30% pero score léxico alto'],
    ]),
    p(''),
    h2('Umbrales de decisión'),
    table3([
        ['Rango', 'Veredicto', 'Color en la interfaz'],
        ['≥ 75%', '🔴 Plagio probable', 'Rojo'],
        ['50 – 74%', '🟡 Sospechoso', 'Amarillo'],
        ['< 50%', '🟢 Original', 'Verde'],
    ]),
    p(''),
    note('El umbral del 75% es configurable desde Administración del sitio → Plugins → AI Assignment → Umbral de plagio (%).'),
    separator(),
    pageBreak(),
);

// ════════════════════════════════════════════════════════════
// 8. PREGUNTAS FRECUENTES
// ════════════════════════════════════════════════════════════
sections.push(
    h1('8. Preguntas Frecuentes'),
    h3('¿La solución de referencia es visible para los estudiantes?'),
    p('No. La solución de referencia solo la usa la IA internamente para comparar. Los estudiantes nunca pueden verla.'),
    p(''),
    h3('¿Qué pasa si la IA da una calificación incorrecta?'),
    p('El profesor puede sobrescribir la calificación manualmente desde el detalle del envío, sección "✏️ Calificación Manual".'),
    p(''),
    h3('¿El análisis de plagio compara con internet?'),
    p('No. El sistema solo compara los envíos entre los estudiantes del mismo curso y tarea. No busca en internet ni en bases de datos externas.'),
    p(''),
    h3('¿Cuánto cuesta usar la API de OpenAI?'),
    p('El costo depende del modelo y el número de tokens. Con gpt-4o-mini, evaluar 30 envíos cuesta aproximadamente $0.01-0.05 USD. El análisis de plagio completo (435 comparaciones) puede costar $0.50-2.00 USD dependiendo del tamaño del código.'),
    p(''),
    h3('¿Puedo usar el plugin sin API Key?'),
    p('Sí. Activa el "Modo demostración" en la configuración. La evaluación será simulada basada en similitud de texto simple, sin IA real.'),
    p(''),
    h3('¿Por qué el análisis de plagio tarda mucho?'),
    p('Con 30 alumnos se realizan 435 comparaciones. Usa el Modo Rápido (sin IA) para obtener resultados en ~20 segundos. El Modo Completo con OpenAI puede tardar varios minutos.'),
    p(''),
    h3('¿Qué lenguajes de programación soporta?'),
    p('El sistema soporta cualquier lenguaje de texto. Tiene análisis especializado para Python (AST real), Java, JavaScript, C/C++ y PHP. Para otros lenguajes usa análisis genérico.'),
    separator(),
);

// ════════════════════════════════════════════════════════════
// 9. SOLUCIÓN DE PROBLEMAS
// ════════════════════════════════════════════════════════════
sections.push(
    h1('9. Solución de Problemas'),
    table3([
        ['Problema', 'Causa probable', 'Solución'],
        ['"Error al leer la base de datos"', 'Campos incorrectos en la BD después de actualizar', 'Reinstala el plugin desde el ZIP más reciente'],
        ['"API key no configurada"', 'No se ha ingresado la API Key de OpenAI', 'Ve a Administración → Plugins → AI Assignment y configura la API Key'],
        ['"La evaluación automática falló"', 'Error de conexión con OpenAI o límite de rate', 'El envío queda como Pendiente. Usa Re-evaluar desde el detalle del envío'],
        ['"Tu respuesta no parece código"', 'El texto enviado no tiene estructura de código', 'Asegúrate de incluir funciones, bucles o condicionales en tu código'],
        ['El análisis de plagio no termina', 'Timeout del servidor con muchos alumnos', 'Usa el Modo Rápido o aumenta el max_execution_time en PHP'],
        ['La columna Plagio muestra "-"', 'No se ha ejecutado el análisis de plagio', 'Ve al reporte de plagio y ejecuta el análisis'],
        ['El spinner de evaluación no desaparece', 'Error de JavaScript en el navegador', 'Recarga la página. El envío fue guardado aunque el spinner no desaparezca'],
    ]),
    p(''),
    h2('Contacto y soporte'),
    p('Para reportar errores o solicitar ayuda, contacta al equipo de desarrollo:'),
    bullet('Flores Guevara Angel Gabriel'),
    bullet('López Payán Kevin Ricardo'),
    p(''),
    new Paragraph({
        children: [new TextRun({
            text: 'Plugin AI Assignment v1.3.0 — Tesis de Licenciatura — Abril 2026',
            size: 18, color: COLOR.gray, italics: true,
        })],
        alignment: AlignmentType.CENTER,
        spacing: { before: 400 },
    }),
);

// ════════════════════════════════════════════════════════════
// GENERAR EL DOCUMENTO
// ════════════════════════════════════════════════════════════
const doc = new Document({
    creator: 'AI Assignment Plugin — Equipo 8',
    title: 'Manual de Usuario — AI Assignment para Moodle',
    description: 'Manual completo de uso del plugin de evaluación con IA y detección de plagio',
    styles: {
        default: {
            document: {
                run: { font: 'Calibri', size: 22, color: COLOR.black },
            },
        },
        paragraphStyles: [
            {
                id: 'Heading1',
                name: 'Heading 1',
                run: { font: 'Calibri', size: 32, bold: true, color: COLOR.primary },
                paragraph: { spacing: { before: 400, after: 200 } },
            },
            {
                id: 'Heading2',
                name: 'Heading 2',
                run: { font: 'Calibri', size: 26, bold: true, color: COLOR.primary },
                paragraph: { spacing: { before: 300, after: 150 } },
            },
            {
                id: 'Heading3',
                name: 'Heading 3',
                run: { font: 'Calibri', size: 22, bold: true, color: COLOR.black },
                paragraph: { spacing: { before: 200, after: 100 } },
            },
        ],
    },
    sections: [{
        properties: {
            page: {
                margin: {
                    top: convertInchesToTwip(1),
                    right: convertInchesToTwip(1),
                    bottom: convertInchesToTwip(1),
                    left: convertInchesToTwip(1.2),
                },
            },
        },
        headers: {
            default: new Header({
                children: [new Paragraph({
                    children: [
                        new TextRun({ text: 'Manual de Usuario — AI Assignment para Moodle', size: 18, color: COLOR.gray }),
                    ],
                    border: { bottom: { style: BorderStyle.SINGLE, size: 1, color: COLOR.lightgray } },
                })],
            }),
        },
        footers: {
            default: new Footer({
                children: [new Paragraph({
                    children: [
                        new TextRun({ text: 'Página ', size: 18, color: COLOR.gray }),
                        new TextRun({ children: [PageNumber.CURRENT], size: 18, color: COLOR.gray }),
                        new TextRun({ text: ' de ', size: 18, color: COLOR.gray }),
                        new TextRun({ children: [PageNumber.TOTAL_PAGES], size: 18, color: COLOR.gray }),
                        new TextRun({ text: '   |   Plugin AI Assignment v1.3.0', size: 18, color: COLOR.gray }),
                    ],
                    alignment: AlignmentType.CENTER,
                })],
            }),
        },
        children: sections,
    }],
});

const outputPath = path.join(__dirname, '..', 'docs', 'MANUAL_USUARIO_AI_ASSIGNMENT.docx');
Packer.toBuffer(doc).then(buffer => {
    fs.writeFileSync(outputPath, buffer);
    const kb = Math.round(buffer.length / 1024);
    console.log(`✅ Manual generado: ${outputPath}`);
    console.log(`📄 Tamaño: ${kb} KB`);
    console.log(`📋 Secciones: Portada, Índice, Introducción, Requisitos, Instalación, Configuración, Guía Profesor (8 secciones), Guía Estudiante, Parámetros de Plagio, FAQ, Solución de Problemas`);
}).catch(err => {
    console.error('❌ Error:', err.message);
});
