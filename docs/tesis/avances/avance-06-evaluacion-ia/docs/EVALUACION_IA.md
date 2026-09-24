# Avance 6 — Sistema de Evaluación Automática con IA

| Campo | Detalle |
|---|---|
| **Número de Avance** | 6 de 10 |
| **Título** | Sistema de Evaluación Automática con Inteligencia Artificial |
| **Fecha** | Septiembre 2026 |
| **Universidad** | Universidad Autónoma de Sinaloa — Facultad de Informática Mazatlán (FIM) |
| **Autor** | Ángel Flores |
| **Versión del Plugin** | v2.5.1 |

---

## 1. Arquitectura del Evaluador: `ai_evaluator.php`

La clase `AIEvaluator` en `ai_evaluator.php` es el componente central del sistema de evaluación automática. Gestiona el ciclo completo de evaluación: construcción del prompt, comunicación con la API de OpenAI, parseo de la respuesta, almacenamiento en caché y persistencia del resultado. La clase sigue el patrón de diseño **Strategy** para los 6 tipos de problemas soportados, permitiendo que cada tipo tenga su propio sistema de construcción de prompts sin modificar la clase base.

La clase expone el método principal:

```php
/**
 * Evalúa una submission de estudiante contra un enunciado dado.
 *
 * @param int    $submissionId ID de la submission en mdl_aiassignment_submissions
 * @param string $problemType  Tipo: programming|math|essay|sql|pseudocode|debugging
 * @param string $rubricJson   JSON de la rúbrica de evaluación (4 criterios)
 * @param bool   $useCache     Si true, busca resultado en caché antes de llamar API
 * @return array Resultado de evaluación con scores, feedback y metadata
 */
public function evaluate(int $submissionId, string $problemType,
                         string $rubricJson = '', bool $useCache = true): array
```

La instancia de `AIEvaluator` accede a la API key de OpenAI mediante `get_config('mod_aiassignment', 'openai_api_key')`, nunca mediante variables de entorno o archivos de configuración externos, siguiendo las buenas prácticas de seguridad de Moodle.

---

## 2. Los 6 Tipos de Problemas con Prompts Especializados

### 2.1 `programming` — Código de Programación

El prompt especializado para código fuente incluye el enunciado del problema, el código del estudiante, los lenguajes de programación relevantes y los criterios de la rúbrica. GPT-4o-mini evalúa: correctitud funcional (¿resuelve el problema?), calidad del código (estructura, legibilidad), eficiencia algorítmica (análisis de complejidad implícito) y documentación.

```
[SYSTEM] You are an expert programming instructor evaluating student code submissions.
Evaluate strictly based on the provided rubric. Be fair but rigorous.
Always respond in valid JSON format.

[USER] PROBLEM STATEMENT: {problem_statement}
LANGUAGE: {language}
STUDENT CODE:
```{student_code}```
RUBRIC: {rubric_json}

Evaluate this submission and respond with the JSON structure provided.
```

### 2.2 `math` — Problemas Matemáticos

Para problemas de matemáticas (fórmulas, demostraciones, cálculos numéricos), el prompt instruye al modelo a verificar la corrección matemática, el proceso de resolución y la presentación. Se incluye instrucción específica para reconocer diferentes notaciones equivalentes.

### 2.3 `essay` — Ensayos y Respuestas Abiertas

El evaluador de ensayos analiza: coherencia argumentativa, uso de terminología técnica correcta, profundidad de análisis y estructura de la respuesta. El prompt incluye una lista de conceptos clave esperados que el docente define al crear la actividad.

### 2.4 `sql` — Consultas SQL

Evaluación especializada para SQL que verifica: corrección semántica de la consulta (¿obtiene los datos correctos?), eficiencia (¿usa índices?, ¿evita SELECT *?), manejo de JOINs y subconsultas, y buenas prácticas de nomenclatura. El prompt incluye el esquema de la base de datos de referencia.

### 2.5 `pseudocode` — Pseudocódigo y Algoritmos

Para pseudocódigo, el evaluador verifica la corrección lógica del algoritmo independientemente del lenguaje, la claridad de las instrucciones y la completitud del algoritmo (manejo de casos borde, terminación).

### 2.6 `debugging` — Depuración de Código

El tipo `debugging` presenta al estudiante código con errores que debe corregir. El evaluador verifica: ¿identificó todos los errores?, ¿las correcciones son correctas?, ¿no introdujo nuevos errores?, ¿explica por qué cada error era un problema?

---

## 3. Estructura del JSON de Respuesta

El plugin requiere que GPT-4o-mini retorne respuestas en formato JSON estrictamente estructurado, usando `response_format: { type: "json_object" }` de la API de OpenAI. La estructura completa del JSON de evaluación es:

```json
{
  "similarity_score": 0.78,
  "grade": 7.8,
  "feedback": "El código implementa correctamente el algoritmo de ordenamiento burbuja. La lógica principal es funcional y el resultado es correcto para todos los casos de prueba típicos.",
  "strengths": [
    "Implementación correcta del algoritmo base",
    "Uso apropiado de bucles anidados",
    "El código es legible y fácil de seguir"
  ],
  "errors": [
    {
      "type": "efficiency",
      "description": "El algoritmo no implementa la optimización de bandera que permite terminar anticipadamente cuando el arreglo ya está ordenado",
      "line_hint": 8,
      "severity": "minor"
    }
  ],
  "suggestions": [
    "Considera añadir una variable booleana 'swapped' para optimizar el caso donde el arreglo ya está parcialmente ordenado",
    "Añadir docstring a la función mejoraría la documentación del código"
  ],
  "rubric_scores": {
    "functionality": 0.90,
    "code_style": 0.75,
    "efficiency": 0.60,
    "documentation": 0.50
  },
  "confidence": 0.92,
  "ai_generated_probability": 0.15,
  "tokens_used": 847,
  "model": "gpt-4o-mini",
  "evaluation_time_ms": 1240
}
```

El campo `similarity_score` (0–1) se convierte a la escala de calificación configurada por el profesor (típicamente 0–10 o 0–100). El campo `confidence` indica la certeza del modelo en su evaluación; si es menor a 0.70, el sistema marca la evaluación para revisión manual por el docente.

---

## 4. Sistema de Caché de Evaluaciones

La caché de evaluaciones usa la misma tabla `mdl_aiassignment_cache` que la caché de plagio, pero con claves distintas. La clave de caché para una evaluación es el hash SHA-256 del concatenado: `hash(student_code + problem_statement + rubric_json)`. Esto garantiza que:

- El mismo código evaluado contra el mismo enunciado y rúbrica retorna el resultado cacheado.
- Si el docente modifica la rúbrica o el enunciado, se invalida automáticamente el caché (la clave cambia).
- Si el estudiante re-envía código idéntico, no se consume tokens de API.

El TTL (Time-To-Live) de la caché de evaluaciones es configurable por el administrador (por defecto: 30 días). Las evaluaciones se pueden forzar a recalcular desde el panel del profesor con un botón "Re-evaluar".

---

## 5. Rate Limiting Configurable

El sistema de rate limiting protege contra el consumo excesivo de tokens de la API de OpenAI. La configuración predeterminada es 100 llamadas por hora, ajustable desde `Site Administration > Plugins > Activity modules > AI Assignment > API Settings`.

La implementación usa una ventana de tiempo deslizante de 3,600 segundos:

```php
public function checkRateLimit(): bool {
    $windowStart = time() - 3600;
    $count = $DB->count_records_select(
        'aiassignment_cache',
        'cache_type = ? AND created_at > ?',
        ['api_call', $windowStart]
    );
    return $count < get_config('mod_aiassignment', 'rate_limit_per_hour');
}
```

Cuando se alcanza el límite, las evaluaciones pendientes se añaden a una cola de tareas Moodle (`\mod_aiassignment\task\adhoc_evaluate`) que se procesa en el siguiente cron cycle (cada 15 minutos por defecto en Moodle).

---

## 6. Reintentos con Backoff Exponencial

Las llamadas a la API de OpenAI pueden fallar por errores transitorios de red o errores 429 (too many requests). El método `callOpenAI()` implementa un sistema de reintentos con **backoff exponencial**:

```php
private function callOpenAI(array $messages, int $maxRetries = 3): ?array {
    for ($attempt = 0; $attempt <= $maxRetries; $attempt++) {
        try {
            $response = $this->httpPost($this->apiEndpoint, $messages);
            return $response;
        } catch (RateLimitException $e) {
            if ($attempt < $maxRetries) {
                $waitSeconds = pow(2, $attempt); // 1s, 2s, 4s
                sleep($waitSeconds);
            }
        } catch (NetworkException $e) {
            if ($attempt < $maxRetries) {
                sleep(pow(2, $attempt));
            }
        }
    }
    $this->logFailure($messages, 'Max retries exceeded');
    return null; // Retorna null → evaluación marcada para revisión manual
}
```

---

## 7. Evaluación con Rúbrica Personalizable

El profesor puede configurar una rúbrica de 4 criterios con pesos personalizables al crear la actividad desde `mod_form.php`. Los criterios predeterminados son:

| Criterio | Descripción | Peso por defecto |
|---|---|---|
| `functionality` | Corrección funcional: el código resuelve el problema planteado | 40% |
| `code_style` | Estilo y legibilidad: indentación, nombres significativos, estructura | 20% |
| `efficiency` | Eficiencia algorítmica: complejidad temporal/espacial, evitar redundancias | 25% |
| `documentation` | Documentación: comentarios, docstrings, claridad de la solución | 15% |

El score final ponderado se calcula en `calculateWeightedScore()`:

```php
$finalGrade = 0.0;
foreach ($rubricCriteria as $criterion => $weight) {
    $finalGrade += $rubricScores[$criterion] * $weight;
}
$finalGrade *= $this->maxGrade; // Escalar a la calificación máxima configurada
```

---

## 8. Detección de Código Generado por IA: `ai_detector.php`

La clase `AICodeDetector` en `ai_detector.php` analiza 8 señales estadísticas para estimar la probabilidad de que el código haya sido generado por herramientas de IA (ChatGPT, Copilot, etc.):

1. **Entropía de identificadores**: El código generado por IA tiende a usar nombres más consistentes y semánticamente correctos que el código escrito por estudiantes en prácticas iniciales.
2. **Distribución de longitud de líneas**: El código generado por LLMs tiene una distribución de longitud de líneas con menor varianza.
3. **Presencia de docstrings perfectos**: Documentación completa en funciones es inusual en entregas de estudiantes principiantes.
4. **Ratio comentario/código**: Los LLMs típicamente generan un ratio más alto.
5. **Consistencia de estilo**: Cero inconsistencias de estilo a lo largo del archivo.
6. **Vocabulario de identificadores**: Identificadores en inglés técnico correcto en código de estudiantes hispanohablantes puede ser señal de IA.
7. **Verificación GPT directa**: El mismo modelo GPT-4o-mini recibe el código con el prompt específico de detección.
8. **Complejidad ciclomática uniforme**: Funciones con complejidad muy uniforme son características de código generado.

El score de `ai_generated_probability` en el JSON de evaluación es informativo, no sancionador. Aparece en el dashboard del profesor para su criterio, sin afectar directamente la calificación.

---

## 9. Análisis de Complejidad Ciclomática: `complexity_analyzer.php`

La clase `ComplexityAnalyzer` calcula la complejidad ciclomática de McCabe para fragmentos de código. La complejidad ciclomática V(G) se define como:

```
V(G) = E - N + 2P
```

Donde E es el número de aristas del grafo de flujo, N el número de nodos y P el número de componentes conexas (típicamente 1 para una función). En la práctica, para código sin manejo de excepciones, equivale a:

```
V(G) = 1 + número de puntos de decisión (if, for, while, case, &&, ||)
```

El análisis de complejidad cumple dos propósitos en el plugin: (1) provee una de las features del vector AST para la capa estructural de plagio, y (2) aparece en el dashboard del profesor como indicador de la dificultad relativa del código del estudiante.

---

## 10. Modo Demo sin API

Para instituciones sin API key de OpenAI, el plugin incluye un **modo demo** que simula las respuestas de la IA con datos preprogramados basados en heurísticas locales. En modo demo, la evaluación analiza: presencia de estructuras de control esperadas, longitud mínima del código, cumplimiento de requisitos básicos de sintaxis, y genera feedback genérico pero informativo. El modo demo se activa automáticamente si `get_config('mod_aiassignment', 'openai_api_key')` está vacío.

---

*Fin del Avance 6 — Siguiente: Funcionalidades Avanzadas del Plugin*
