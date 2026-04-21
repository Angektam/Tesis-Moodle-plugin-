<?php
// This file is part of Moodle - http://moodle.org/

defined('MOODLE_INTERNAL') || die();

// General
$string['modulename']             = 'Tarea con IA';
$string['modulenameplural']       = 'Tareas con IA';
$string['modulename_help']        = 'El módulo Tarea con IA permite a los profesores crear tareas evaluadas automáticamente mediante inteligencia artificial.';
$string['pluginname']             = 'Tarea con IA';
$string['pluginadministration']   = 'Administración de Tarea con IA';

// Capacidades
$string['aiassignment:addinstance'] = 'Agregar una nueva Tarea con IA';
$string['aiassignment:view']        = 'Ver Tarea con IA';
$string['aiassignment:submit']      = 'Enviar respuesta';
$string['aiassignment:grade']       = 'Calificar envíos';
$string['aiassignment:viewgrades']  = 'Ver calificaciones';

// Formulario de creación
$string['assignmentname']      = 'Nombre de la tarea';
$string['problemsettings']     = 'Configuración del problema';
$string['problemtype']         = 'Tipo de problema';
$string['problemtype_help']    = 'Seleccione el tipo de problema: Matemáticas o Programación';
$string['math']                = 'Matemáticas';
$string['programming']         = 'Programación';
$string['solution']            = 'Solución de referencia';
$string['solution_help']       = 'Ingrese la solución correcta que usará la IA para comparar las respuestas de los estudiantes';
$string['documentation']       = 'Documentación adicional';
$string['documentation_help']  = 'Información adicional opcional para los estudiantes';
$string['testcases']           = 'Casos de prueba';
$string['testcases_help']      = 'Casos de prueba o ejemplos opcionales';
$string['gradesettings']       = 'Configuración de calificación';
$string['maxattempts']         = 'Intentos máximos';
$string['maxattempts_help']    = 'Número máximo de intentos permitidos. 0 = ilimitado';

// Vista del estudiante
$string['problemdescription']  = 'Descripción del problema';
$string['type']                = 'Tipo';
$string['submitanswer']        = 'Enviar tu respuesta';
$string['submit']              = 'Enviar';
$string['attemptsremaining']   = 'Intentos restantes: {$a}';
$string['maxattemptsreached']  = 'Has alcanzado el número máximo de intentos';
$string['yoursubmissions']     = 'Tus envíos';
$string['submitted']           = 'Enviado';
$string['feedback']            = 'Retroalimentación';
$string['viewdetails']         = 'Ver detalles';
$string['pendingevaluation']   = 'Pendiente de evaluación...';
$string['allsubmissions']      = 'Todos los envíos';
$string['viewallsubmissions']  = 'Ver todos los envíos';
$string['nosubmission']        = 'Sin envíos aún';

// Envío
$string['submissionsaved']     = 'Tu respuesta ha sido enviada y será evaluada automáticamente';
$string['submissionfailed']    = 'Error al enviar la respuesta';
$string['answerrequired']         = 'La respuesta es obligatoria';
$string['answertoolong']          = 'La respuesta es demasiado larga (máximo {$a} caracteres)';
$string['answertooshort']         = 'La respuesta es demasiado corta. Mínimo {$a} caracteres';
$string['answerforbidden']        = 'La respuesta contiene contenido no permitido';
$string['waitbetweensubmissions'] = 'Por favor espera al menos {$a} segundos entre envíos';
$string['duplicateanswer']        = 'Esta respuesta es idéntica a tu envío anterior. Por favor modifícala';

// Evaluación
$string['score']               = 'Calificación';
$string['aifeedback']          = 'Retroalimentación de la IA';
$string['aianalysis']          = 'Análisis detallado';
$string['evaluating']          = 'Evaluando con IA...';
$string['evaluationfailed']    = 'La evaluación automática falló';

// Configuración del plugin (admin)
$string['openaiapikey']           = 'Clave API de OpenAI';
$string['openaiapikey_desc']      = 'Ingrese su clave API de OpenAI para la evaluación automática. Obténgala en https://platform.openai.com/api-keys';
$string['openaimodel']            = 'Modelo de OpenAI';
$string['openaimodel_desc']       = 'Seleccione el modelo de OpenAI a usar (predeterminado: gpt-4o-mini)';
$string['demomode']               = 'Modo demostración';
$string['demomode_desc']          = 'Activa el modo demo para probar sin API de OpenAI (usa evaluación simulada)';
$string['maxresponsetime']        = 'Tiempo máximo de respuesta';
$string['maxresponsetime_desc']   = 'Tiempo máximo en segundos para esperar la respuesta de la API de OpenAI (predeterminado: 30)';
$string['noapikey']               = 'Clave API de OpenAI no configurada. Configúrela en los ajustes del plugin o active el modo demostración.';

// Eventos
$string['eventsubmissioncreated'] = 'Envío creado';
$string['eventsubmissiongraded']  = 'Envío calificado';
$string['eventcoursemoduleviewed']= 'Módulo del curso visto';

// Página de envíos (profesor)
$string['student']             = 'Estudiante';
$string['attempt']             = 'Intento';
$string['status']              = 'Estado';
$string['actions']             = 'Acciones';
$string['evaluated']           = 'Evaluado';
$string['pending']             = 'Pendiente';
$string['flagged']             = 'Marcado';
$string['nosubmissions']       = 'No hay envíos aún';
$string['statistics']          = 'Estadísticas';
$string['totalsubmissions']    = 'Total de envíos';
$string['averagescore']        = 'Promedio';
$string['backtosubmissions']   = 'Volver a envíos';

// Detalle de envío
$string['submissiondetails']   = 'Detalles del envío';
$string['submissioninfo']      = 'Información del envío';
$string['youranswer']          = 'Tu respuesta';
$string['evaluation']          = 'Evaluación';
$string['reevaluate']          = 'Re-evaluar';
$string['reevaluate_help']     = 'Esto volverá a evaluar el envío con la IA. La calificación anterior será reemplazada.';

// Página índice
$string['submissions']         = 'Envíos';

// Panel de control (dashboard)
$string['dashboard']           = 'Panel de control';
$string['activestudents']      = 'Estudiantes activos';
$string['pendingevaluations']  = 'Evaluaciones pendientes';
$string['recentsubmissions']   = 'Envíos recientes';
$string['submittedon']         = 'Enviado el';
$string['grade']               = 'Calificación';
$string['view']                = 'Ver';
$string['gradedistribution']   = 'Distribución de calificaciones';
$string['topperformers']       = 'Mejores estudiantes';
$string['nodataavailable']     = 'No hay datos disponibles aún';
$string['averagegrade']        = 'Promedio de calificaciones';
$string['totalassignments']    = 'Total de tareas';
$string['assignmentsoverview'] = 'Resumen de tareas';
$string['assignment']          = 'Tarea';
$string['viewsubmissions']     = 'Ver envíos';
$string['noassignments']       = 'No hay Tareas con IA en este curso aún';
$string['assignmentname']      = 'Nombre de la tarea';

// Detección de plagio
$string['plagiarismreport']           = 'Reporte de plagio';
$string['selectproblemforplagiarism'] = 'Selecciona un problema para analizar plagio:';
$string['analyzeplagiarism']          = 'Analizar plagio';
$string['plagiarismanalysisinfo']     = 'Este análisis usa IA para comparar todos los envíos y detectar posible plagio. Analiza similitudes semánticas, estructurales y lógicas.';
$string['analyzingplagiarism']        = 'Analizando envíos en busca de plagio... Esto puede tomar unos momentos.';
$string['summary']                    = 'Resumen';
$string['totalcomparisons']           = 'Total de comparaciones';
$string['suspiciouspairs']            = 'Pares sospechosos';
$string['highestsimilarity']          = 'Mayor similitud';
$string['suspicioususers']            = 'Usuarios sospechosos';
$string['suspiciousmatches']          = 'Coincidencias sospechosas';
$string['matchedwith']                = 'Coincide con';
$string['detailedcomparisons']        = 'Comparaciones detalladas';
$string['similarity']                 = 'Similitud';
$string['verdict']                    = 'Veredicto';
$string['startanalysis']              = 'Iniciar análisis de plagio';
$string['needmoreusers']              = 'Se necesitan envíos de al menos 2 estudiantes distintos para analizar plagio';
$string['plagiarismdetectionerror']   = 'Error en la detección de plagio';
$string['plagiarismdetectionfailed']  = 'Falló la detección de plagio';
$string['noproblems']                 = 'No hay problemas disponibles';

// Notificaciones (mejora #3)
$string['notif_graded_subject']  = 'Tu tarea "{$a}" ha sido evaluada';
$string['notif_graded_body']     = "Tu tarea \"{$a->assignment}\" ha sido evaluada.\n\nCalificación: {$a->score}%\n\nRetroalimentación: {$a->feedback}";
$string['notif_graded_small']    = 'Calificación recibida: {$a}%';

// Contador de caracteres (mejora #6)
$string['characters']            = 'caracteres';

// Privacidad
$string['privacy:metadata:aiassignment_submissions']                    = 'Información sobre los envíos de los usuarios para tareas con IA';
$string['privacy:metadata:aiassignment_submissions:userid']             = 'ID del usuario que realizó el envío';
$string['privacy:metadata:aiassignment_submissions:answer']             = 'Respuesta enviada por el usuario';
$string['privacy:metadata:aiassignment_submissions:status']             = 'Estado del envío (pendiente, evaluado o marcado)';
$string['privacy:metadata:aiassignment_submissions:score']              = 'Calificación recibida por el envío';
$string['privacy:metadata:aiassignment_submissions:feedback']           = 'Retroalimentación proporcionada para el envío';
$string['privacy:metadata:aiassignment_submissions:attempt']            = 'Número de intento';
$string['privacy:metadata:aiassignment_submissions:timecreated']        = 'Fecha de creación del envío';
$string['privacy:metadata:aiassignment_submissions:timemodified']       = 'Fecha de última modificación del envío';
$string['privacy:metadata:aiassignment_evaluations']                    = 'Información sobre las evaluaciones de IA de los envíos';
$string['privacy:metadata:aiassignment_evaluations:similarity_score']   = 'Puntaje de similitud calculado por la IA';
$string['privacy:metadata:aiassignment_evaluations:ai_feedback']        = 'Retroalimentación generada por la IA';
$string['privacy:metadata:aiassignment_evaluations:ai_analysis']        = 'Análisis detallado generado por la IA';
$string['privacy:metadata:aiassignment_evaluations:timecreated']        = 'Fecha de creación de la evaluación';
$string['privacy:metadata:core_grades']                                 = 'Tarea con IA almacena calificaciones en el libro de calificaciones';
$string['privacy:metadata:openai']                                      = 'Tarea con IA envía datos a OpenAI para evaluación';
$string['privacy:metadata:openai:answer']                               = 'Respuesta del estudiante enviada a OpenAI para evaluación';
$string['privacy:metadata:openai:solution']                             = 'Solución del profesor enviada a OpenAI para comparación';

// ── Mejoras v2.0 ──────────────────────────────────────────────────────────

// Editor de código
$string['codelanguage']          = 'Lenguaje';
$string['editorhint']            = '💡 El editor tiene resaltado de sintaxis';

// Evaluación asíncrona
$string['submissionqueued']      = '✅ Tu respuesta fue enviada. La evaluación estará lista en unos minutos.';
$string['asynceval_info']        = 'Tu envío está en cola para evaluación. Recibirás una notificación cuando esté listo.';

// Modo examen
$string['exammode_active']       = '🔒 Modo examen activo. Los cambios de pestaña serán registrados.';
$string['tabswitch_detected']    = '⚠️ Cambio de pestaña detectado ({$a} vez/veces). Esto será registrado.';
$string['exammode_label']        = 'Modo examen para esta tarea';
$string['exammode_desc']         = 'Detecta cambios de pestaña y restringe copiar/pegar';

// Detección de código IA
$string['aicode_detected']       = '🤖 Posible código generado por IA detectado ({$a}%)';
$string['aicode_label']          = 'Detectar código generado por IA';
$string['aicode_human']          = '✅ Probablemente escrito por humano';
$string['aicode_suspicious']     = '⚠️ Posiblemente asistido por IA';
$string['aicode_probable']       = '🤖 Probable código IA';

// Rúbricas
$string['rubric_funcionalidad']  = 'Funcionalidad (%)';
$string['rubric_estilo']         = 'Estilo y claridad (%)';
$string['rubric_eficiencia']     = 'Eficiencia (%)';
$string['rubric_documentacion']  = 'Documentación (%)';
$string['rubric_breakdown']      = 'Desglose por criterio';
$string['rubric_total']          = 'Total';
$string['use_rubric']            = 'Usar rúbrica personalizada';
$string['rubricsettings']        = 'Rúbrica de evaluación (opcional)';

// ── Mejoras v2.2 — Nuevos tipos, exportación, notificaciones ─────────────

// Nuevos tipos de problemas
$string['essay']       = 'Ensayo / Texto libre';
$string['sql']         = 'Consulta SQL';
$string['pseudocode']  = 'Pseudocódigo / Algoritmo';
$string['debugging']   = 'Depuración de código';

// Exportación
$string['export_csv']  = 'Exportar CSV';
$string['export_xlsx'] = 'Exportar Excel';
$string['export_pdf']  = 'Exportar PDF';
$string['export_grades'] = 'Exportar calificaciones';

// Notificaciones en tiempo real
$string['notif_evaluated_title'] = '✅ Tarea evaluada';
$string['notif_evaluated_body']  = '{$a->name}: {$a->score}%';
$string['notif_plagiarism_title']= '🚨 Alerta de plagio';
$string['notif_resubmit_title']  = '📩 Re-envío solicitado';

// Múltiples archivos
$string['multifile_label']  = 'Archivos adicionales (opcional)';
$string['multifile_hint']   = 'Máx. 10 archivos · 2MB c/u';
$string['multifile_drop']   = 'Arrastra archivos aquí o selecciona';
