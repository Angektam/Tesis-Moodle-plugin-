# Avance 7 — Funcionalidades Avanzadas del Plugin

| Campo | Detalle |
|---|---|
| **Número de Avance** | 7 de 10 |
| **Título** | Funcionalidades Avanzadas del Plugin |
| **Fecha** | Septiembre 2026 |
| **Universidad** | Universidad Autónoma de Sinaloa — Facultad de Informática Mazatlán (FIM) |
| **Autor** | Ángel Flores |
| **Versión del Plugin** | v2.5.1 |

---

## 1. Dashboard del Profesor

El dashboard del profesor es la interfaz central de gestión y está implementado en `dashboard.php` con los gráficos renderizados mediante **Chart.js 4.x** a través de los módulos AMD `amd/src/dashboard.js`. La interfaz está dividida en dos secciones: tarjetas de estadísticas rápidas y gráficas analíticas.

### 1.1 Cinco Tarjetas de Estadísticas

| Tarjeta | Métrica | Actualización |
|---|---|---|
| **Total de entregas** | Número de submissions recibidas / total de alumnos inscritos | Tiempo real (AJAX) |
| **Promedio del grupo** | Media aritmética de calificaciones evaluadas por IA | Tiempo real |
| **Posibles plagios** | Pares con score de plagio ≥ umbral configurado (default 75%) | Al completar análisis |
| **Pendientes de revisión** | Evaluaciones con `confidence < 0.70` o marcadas por docente | Tiempo real |
| **Tiempo promedio de entrega** | Media del tiempo entre apertura de actividad y submission | Por actividad |

### 1.2 Cuatro Gráficas Chart.js

1. **Histograma de calificaciones** (`bar chart`): Distribución de calificaciones del grupo en intervalos de 1 punto. Permite identificar de un vistazo si la distribución es normal, bimodal o sesgada.

2. **Gráfica de actividad temporal** (`line chart`): Número de entregas por hora desde la apertura de la actividad. Útil para identificar si los estudiantes entregan en el último momento.

3. **Radar de criterios de rúbrica** (`radar chart`): Promedio del grupo en cada uno de los 4 criterios de evaluación (funcionalidad, estilo, eficiencia, documentación). Permite al docente identificar qué aspectos requieren refuerzo pedagógico.

4. **Mapa de calor de plagio** (`custom heatmap`): Visualización matricial de los scores de similitud entre todos los pares de estudiantes, con colores escalonados según el nivel de similitud.

---

## 2. Sistema de Deadline y Fechas de Apertura

La gestión temporal de actividades es una funcionalidad crítica para el control académico. El plugin implementa dos campos de fecha en `mdl_aiassignment`: `timeopen` (fecha de apertura) y `duedate` (fecha límite de entrega).

### 2.1 Cuenta Regresiva en Tiempo Real

El módulo AMD `amd/src/countdown.js` implementa una cuenta regresiva en tiempo real que se muestra al estudiante en la vista de la actividad. El cálculo se realiza en el cliente (JavaScript) basado en el `duedate` pasado como variable desde PHP mediante `$PAGE->requires->js_call_amd()`.

```javascript
// amd/src/countdown.js — actualización cada segundo
function updateCountdown(duedate) {
    const now = Math.floor(Date.now() / 1000);
    const remaining = duedate - now;
    
    if (remaining <= 0) {
        document.getElementById('countdown').textContent = 'Plazo vencido';
        document.getElementById('submit-btn').disabled = true;
        return;
    }
    
    const hours = Math.floor(remaining / 3600);
    const minutes = Math.floor((remaining % 3600) / 60);
    const seconds = remaining % 60;
    
    document.getElementById('countdown').textContent = 
        `${hours}h ${minutes}m ${seconds}s restantes`;
    
    if (remaining < 3600) {
        document.getElementById('countdown').classList.add('warning'); // Rojo
    }
}
setInterval(() => updateCountdown(duedateTimestamp), 1000);
```

### 2.2 Manejo del Cierre de Actividad

Cuando `duedate` ha pasado, el servidor verifica en `submission_handler.php` que el timestamp de envío sea anterior al deadline. Las entregas tardías se marcan con el campo `late_submission = 1` en `mdl_aiassignment_submissions`. El profesor puede configurar si se permiten entregas tardías y con qué penalización porcentual.

---

## 3. Validación de Lenguaje Requerido por Tarea (`required_language`)

Esta funcionalidad, introducida en la versión 2.4.0, permite al profesor especificar qué lenguaje de programación debe usar el estudiante para resolver una tarea específica. El campo `required_language` en `mdl_aiassignment` puede tomar valores: `null` (cualquier lenguaje) o uno de los 10 soportados (`python`, `java`, `javascript`, `cpp`, `php`, `sql`, `typescript`, `ruby`, `go`, `rust`).

### 3.1 Forzado del Lenguaje en el Editor

Cuando `required_language` no es null, el módulo `amd/src/editor.js` configura el Monaco Editor para usar ese lenguaje fijo y deshabilita el selector de lenguaje del formulario:

```javascript
// Si hay lenguaje requerido, deshabilitar el selector
if (requiredLanguage) {
    monaco.editor.setModelLanguage(editor.getModel(), requiredLanguage);
    document.getElementById('language-selector').disabled = true;
    document.getElementById('language-selector').value = requiredLanguage;
    document.getElementById('lang-locked-notice').style.display = 'block';
}
```

### 3.2 Validación en Cliente y Servidor

La validación opera en dos niveles para garantizar integridad:

**Cliente (JavaScript)**: Antes de habilitar el botón de envío, se verifica que el valor del selector de lenguaje coincida con `required_language`. Si no coincide (por inspección de elementos o manipulación del DOM), el botón permanece deshabilitado y se muestra un aviso.

**Servidor (PHP)**: En `submission_handler.php`, después de verificar el CSRF token, se comprueba:

```php
$requiredLanguage = $DB->get_field('aiassignment', 'required_language', ['id' => $assignmentId]);
if ($requiredLanguage && $submittedLanguage !== $requiredLanguage) {
    throw new \moodle_exception('invalidlanguage', 'mod_aiassignment',
        '', ['required' => $requiredLanguage, 'submitted' => $submittedLanguage]);
}
```

Esta doble validación previene envíos de lenguaje incorrecto independientemente de si la validación del lado cliente fue evitada.

---

## 4. Editor Monaco con Fallback a Textarea

El editor de código es uno de los elementos más importantes de la experiencia del usuario. El plugin usa **Monaco Editor v0.44** (el editor que impulsa VS Code) cargado desde CDN con `integrity` hash para seguridad.

### 4.1 Carga con Fallback

El módulo `amd/src/editor.js` intenta cargar Monaco de forma asíncrona. Si la carga falla después de 5 segundos (timeout), o si el navegador no soporta los Web Workers requeridos por Monaco, se activa automáticamente el fallback:

```javascript
const monacoTimeout = setTimeout(() => {
    console.warn('Monaco Editor failed to load, activating textarea fallback');
    activateFallbackEditor();
}, 5000);

require(['vs/editor/editor.main'], function() {
    clearTimeout(monacoTimeout);
    initMonacoEditor();
});

function activateFallbackEditor() {
    const textarea = document.getElementById('code-fallback-textarea');
    textarea.style.display = 'block';
    document.getElementById('monaco-container').style.display = 'none';
    // Activar CodeMirror como alternativa ligera
    CodeMirror.fromTextArea(textarea, { mode: currentLanguage, lineNumbers: true });
}
```

El fallback de primer nivel es **CodeMirror** (más liviano). Si tampoco está disponible, se presenta un `<textarea>` simple con estilos CSS que imitan un editor de código (fondo oscuro, fuente monoespaciada).

---

## 5. Modo Examen: Seguridad Académica

El modo examen se activa cuando el profesor habilita la opción `exam_mode = 1` en la configuración de la actividad. Este modo activa una serie de controles de seguridad implementados en `amd/src/exam_security.js`:

- **Detección de cambio de pestaña**: Listener en `document.addEventListener('visibilitychange')`. Cada cambio se registra con timestamp en `localStorage` y se reporta al servidor vía AJAX al momento de la entrega.
- **Bloqueo de copiar/pegar**: Se interceptan los eventos `copy`, `cut` y `paste` en el área del editor. El pegado de código es bloqueado con una notificación visual, pero el pegado de texto corto (< 20 caracteres) está permitido para no bloquear el tecleo normal de identificadores.
- **Prevención de menú contextual**: `contextmenu` bloqueado dentro del área del editor.
- **Detección de herramientas de desarrollo**: Verificación periódica de cambios en el tamaño de la ventana que puedan indicar apertura de DevTools.

---

## 6. Behavior Tracker: Análisis de Comportamiento

El módulo `amd/src/behavior_tracker.js` recopila métricas de comportamiento durante la sesión de escritura de código, almacenadas en `mdl_aiassignment_behavior`. Estas métricas ayudan al docente a interpretar los resultados de evaluación:

| Métrica | Descripción | Interpretación |
|---|---|---|
| `typing_speed_avg` | Palabras por minuto promedio | Muy alta (>120 wpm en código) puede indicar pegado disfrazado |
| `paste_ratio` | Ratio de caracteres pegados vs escritos | >0.5 con modo examen activo es sospechoso |
| `focus_changes` | Número de veces que se perdió el foco en la página | >5 en actividad corta puede indicar consulta externa |
| `session_duration` | Tiempo total desde carga de página hasta envío | Tiempo muy corto puede indicar código preparado |
| `edit_pattern` | Secuencia de ráfagas de edición (JSON comprimido) | Patrón irregular puede sugerir copia parcial |

Estas métricas son **indicativas, no probatorias**. Se presentan como contexto adicional en el panel de detalle de una submission para que el docente tome decisiones informadas.

---

## 7. Sistema de Versionado de Submissions

Cada vez que un estudiante reenvía código para la misma actividad, se crea un nuevo registro en `mdl_aiassignment_submissions` con el campo `version` incrementado. El campo `is_latest = 1` solo está activo en la versión más reciente. Esto permite:

- El profesor puede ver el historial completo de versiones de un estudiante.
- Las evaluaciones de versiones anteriores se conservan para comparación.
- La detección de plagio opera sobre la versión más reciente por defecto, pero puede configurarse para incluir versiones anteriores.

---

## 8. Auditoría: Registro de Acciones del Profesor

Todas las acciones del profesor que modifican datos se registran en `mdl_aiassignment_logs` mediante el método `logAction()` en `security.php`:

```php
public static function logAction(string $action, int $targetId, array $details = []): void {
    global $DB, $USER;
    $DB->insert_record('aiassignment_logs', [
        'userid'     => $USER->id,
        'action'     => $action,  // 'grade_override', 'plagiarism_dismiss', etc.
        'target_id'  => $targetId,
        'details'    => json_encode($details),
        'timeaction' => time(),
        'ip_address' => getremoteaddr()
    ]);
}
```

Las acciones registradas incluyen: calificación manual, anulación de evaluación IA, marcar/desmarcar plagio, modificación de rúbrica, exportación de datos y cambios en configuración de la actividad.

---

## 9. Notificaciones en Tiempo Real con Polling AJAX

El sistema de notificaciones usa polling AJAX cada 30 segundos (configurable). El endpoint `ajax/notifications.php` retorna el estado de las evaluaciones pendientes, nuevas entregas y alertas de plagio completadas. El módulo `amd/src/notifications.js` actualiza el badge de notificaciones y el panel sin recargar la página.

---

## 10. Ejecución de Código Real con Judge0 API

La integración con **Judge0 Community Edition v1.13** permite ejecutar el código del estudiante en un sandbox seguro con soporte para 10 lenguajes. El flujo de ejecución en `code_executor.php` es:

1. POST a `https://judge0-ce.p.rapidapi.com/submissions` con el código codificado en Base64 y el `language_id` de Judge0.
2. Polling del endpoint `GET /submissions/{token}` hasta que el estado sea `Accepted` (3), `Wrong Answer` (4), `Time Limit Exceeded` (5) u otro estado terminal.
3. Comparación del stdout con los casos de prueba definidos por el profesor.
4. Retorno del resultado al frontend con stdout, stderr, tiempo de ejecución (ms) y memoria usada (KB).

---

## 11. Peer Review Anónimo

Los profesores pueden activar la función de peer review donde cada estudiante evalúa el código de 2–3 compañeros de forma anónima. Los criterios de evaluación son los mismos de la rúbrica del profesor. Las evaluaciones de pares se promedian y contribuyen hasta un porcentaje configurable (0–30%) de la calificación final. La identidad de los revisores se mantiene oculta hasta que el profesor decide revelarla o al cierre de la actividad.

---

## 12. Pistas Progresivas con IA: `hint_generator.php`

El sistema de pistas progresivas permite al estudiante solicitar ayuda sin revelar la solución completa. La clase `HintGenerator` implementa 3 niveles de pistas para cada tipo de problema:

- **Nivel 1**: Pista conceptual (qué concepto aplicar, sin detalles de implementación)
- **Nivel 2**: Pista estructural (qué estructura de datos o función usar, con ejemplo mínimo)
- **Nivel 3**: Pista de código (fragmento de código de ejemplo con gap que el estudiante debe completar)

Cada pista consumida se registra en `mdl_aiassignment_hints` con los tokens usados. El docente puede configurar el número máximo de pistas permitidas por nivel.

---

## 13. Exportación de Calificaciones

El sistema de exportación está implementado en `grade_exporter.php` y soporta tres formatos:

| Formato | Contenido | Uso |
|---|---|---|
| **CSV** | Nombre, email, calificación, scores por criterio, feedback resumido | Importar a Excel, Google Sheets o al libro de calificaciones de Moodle |
| **XLSX** | Igual que CSV pero con formato de tabla, colores por rango y gráfica incluida | Reporte para dirección académica |
| **PDF** | Reporte individual por estudiante con código, retroalimentación completa y scores | Entrega de evidencias para archivo académico |

---

## 14. Encuesta SUS Integrada

Al finalizar la actividad, los estudiantes pueden responder la encuesta SUS de 10 ítems directamente dentro del plugin, sin salir de Moodle. Las respuestas se almacenan en `mdl_aiassignment_sus` y el score SUS se calcula automáticamente con la fórmula estándar:

```
SUS = ((suma_impares - 5) + (25 - suma_pares)) × 2.5
```

El promedio de scores SUS del grupo se muestra en el dashboard del docente como indicador de usabilidad percibida del sistema.

---

*Fin del Avance 7 — Siguiente: Pruebas y Resultados*
