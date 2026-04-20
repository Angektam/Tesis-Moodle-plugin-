# 🤖 Cómo Funciona la Evaluación con IA

## 📋 Descripción General

El sistema utiliza **OpenAI GPT** para comparar automáticamente la respuesta de un estudiante con la solución del profesor, proporcionando una calificación y retroalimentación detallada.

## 🔄 Flujo del Proceso

```
┌─────────────────┐
│   Estudiante    │
│  envía respuesta│
└────────┬────────┘
         │
         ▼
┌─────────────────────────┐
│   submit.php            │
│  (Recibe el envío)      │
└────────┬────────────────┘
         │
         ▼
┌─────────────────────────┐
│  ai_evaluator.php       │
│  evaluate()             │
└────────┬────────────────┘
         │
         ▼
┌─────────────────────────┐
│  Preparar Prompts       │
│  - System Prompt        │
│  - User Prompt          │
└────────┬────────────────┘
         │
         ▼
┌─────────────────────────┐
│  OpenAI API             │
│  (GPT-4o-mini)          │
└────────┬────────────────┘
         │
         ▼
┌─────────────────────────┐
│  Respuesta JSON         │
│  - similarity_score     │
│  - feedback             │
│  - analysis             │
└────────┬────────────────┘
         │
         ▼
┌─────────────────────────┐
│  Guardar en BD          │
│  - Evaluación           │
│  - Actualizar nota      │
└─────────────────────────┘
```

## 🧠 Componentes Principales

### 1. Clase `ai_evaluator`

Ubicación: `moodle-plugin/classes/ai_evaluator.php`

Esta clase maneja toda la lógica de evaluación con IA.

#### Método Principal: `evaluate()`

```php
public static function evaluate($studentanswer, $teachersolution, $type)
```

**Parámetros:**
- `$studentanswer`: La respuesta enviada por el estudiante
- `$teachersolution`: La solución correcta del profesor
- `$type`: Tipo de problema ('math' o 'programming')

**Retorna:**
```php
array(
    'similarity_score' => 85.5,  // Calificación 0-100
    'feedback' => 'Buena solución...',  // Retroalimentación breve
    'analysis' => 'Análisis detallado...'  // Análisis completo
)
```

## 📝 Sistema de Prompts

### System Prompt (Instrucciones para la IA)

Define el rol y comportamiento de la IA:

#### Para Programación:
```
Eres un asistente experto en evaluación de código de programación.
Tu tarea es comparar la respuesta de un estudiante con la solución del profesor
y proporcionar una evaluación justa y constructiva.
Debes responder ÚNICAMENTE en formato JSON con esta estructura exacta:
{"similarity_score": número entre 0 y 100, "feedback": "texto breve", "analysis": "análisis detallado"}
```

#### Para Matemáticas:
```
Eres un asistente experto en evaluación de problemas matemáticos.
Tu tarea es comparar la respuesta de un estudiante con la solución del profesor
y proporcionar una evaluación justa y constructiva.
Debes responder ÚNICAMENTE en formato JSON con esta estructura exacta:
{"similarity_score": número entre 0 y 100, "feedback": "texto breve", "analysis": "análisis detallado"}
```

### User Prompt (Contenido a Evaluar)

#### Para Programación:
```
Compara estas dos soluciones de programación:

SOLUCIÓN DEL PROFESOR:
[código del profesor]

RESPUESTA DEL ESTUDIANTE:
[código del estudiante]

Evalúa:
1. Funcionalidad (¿hace lo que debe hacer?)
2. Estilo y claridad del código
3. Buenas prácticas
4. Eficiencia

Proporciona un similarity_score (0-100), feedback breve y analysis detallado en JSON.
```

#### Para Matemáticas:
```
Compara estas dos soluciones matemáticas:

SOLUCIÓN DEL PROFESOR:
[solución del profesor]

RESPUESTA DEL ESTUDIANTE:
[respuesta del estudiante]

Evalúa:
1. Corrección de la respuesta
2. Método utilizado
3. Claridad de la explicación
4. Pasos mostrados

Proporciona un similarity_score (0-100), feedback breve y analysis detallado en JSON.
```

## 🔌 Llamada a la API de OpenAI

### Configuración de la Petición

```php
$data = array(
    'model' => 'gpt-4o-mini',  // Modelo de IA
    'messages' => array(
        array('role' => 'system', 'content' => $systemprompt),
        array('role' => 'user', 'content' => $userprompt)
    ),
    'temperature' => 0.3,  // Baja temperatura = más consistente
    'response_format' => array('type' => 'json_object')  // Forzar JSON
);
```

### Parámetros Importantes

- **model**: `gpt-4o-mini` - Modelo rápido y económico
- **temperature**: `0.3` - Baja para respuestas más consistentes y predecibles
- **response_format**: `json_object` - Garantiza respuesta en JSON válido

### Endpoint

```
POST https://api.openai.com/v1/chat/completions
```

### Headers

```
Content-Type: application/json
Authorization: Bearer [API_KEY]
```

## 📊 Respuesta de la IA

### Formato JSON

```json
{
  "similarity_score": 85.5,
  "feedback": "Tu solución es correcta y bien estructurada. El código es claro y sigue buenas prácticas. Podrías mejorar la eficiencia usando un algoritmo más optimizado.",
  "analysis": "Análisis detallado:\n\n1. Funcionalidad: ✓ Correcto\n   - El código produce el resultado esperado\n   - Maneja correctamente los casos edge\n\n2. Estilo: ✓ Bueno\n   - Nombres de variables descriptivos\n   - Indentación correcta\n   - Comentarios útiles\n\n3. Buenas prácticas: ✓ Muy bueno\n   - Validación de entrada\n   - Manejo de errores\n   - Código modular\n\n4. Eficiencia: ⚠ Mejorable\n   - Complejidad O(n²) podría ser O(n log n)\n   - Uso de memoria aceptable\n\nSugerencias:\n- Considera usar un algoritmo de ordenamiento más eficiente\n- Podrías extraer la lógica de validación a una función separada"
}
```

## 🎯 Criterios de Evaluación

### Para Código de Programación

1. **Funcionalidad (40%)**
   - ¿El código hace lo que debe hacer?
   - ¿Produce el resultado correcto?
   - ¿Maneja casos especiales?

2. **Estilo y Claridad (25%)**
   - Nombres de variables descriptivos
   - Indentación y formato
   - Comentarios útiles
   - Legibilidad

3. **Buenas Prácticas (20%)**
   - Validación de entrada
   - Manejo de errores
   - Código modular
   - Principios SOLID

4. **Eficiencia (15%)**
   - Complejidad temporal
   - Uso de memoria
   - Optimización

### Para Problemas Matemáticos

1. **Corrección (50%)**
   - ¿La respuesta es correcta?
   - ¿El resultado final es el esperado?

2. **Método (25%)**
   - ¿El método usado es apropiado?
   - ¿Es eficiente?
   - ¿Es elegante?

3. **Claridad (15%)**
   - ¿La explicación es clara?
   - ¿Se entiende el razonamiento?

4. **Pasos (10%)**
   - ¿Se muestran los pasos?
   - ¿El proceso es lógico?
   - ¿Hay justificación?

## 💾 Almacenamiento de Resultados

### Tabla: `mdl_aiassignment_evaluations`

```sql
CREATE TABLE mdl_aiassignment_evaluations (
    id BIGINT PRIMARY KEY,
    submissionid BIGINT,           -- ID del envío
    grade DECIMAL(10,5),            -- similarity_score (0-100)
    feedback TEXT,                  -- Retroalimentación breve
    analysis TEXT,                  -- Análisis detallado
    timecreated BIGINT              -- Timestamp
);
```

### Actualización de Calificación

Después de evaluar, se actualiza la calificación en el libro de calificaciones de Moodle:

```php
// Actualizar submission
$submission->score = $evaluation['similarity_score'];
$submission->feedback = $evaluation['feedback'];
$submission->status = 'evaluated';
$DB->update_record('aiassignment_submissions', $submission);

// Actualizar gradebook
aiassignment_grade_item_update($aiassignment, $grade);
```

## 🔒 Seguridad y Privacidad

### API Key

- Almacenada en configuración de Moodle (encriptada)
- No se expone al cliente
- Solo accesible por el servidor

### Datos Enviados a OpenAI

Según la política de privacidad implementada:

```php
$string['privacy:metadata:openai'] = 'AI Assignment sends data to OpenAI for evaluation';
$string['privacy:metadata:openai:answer'] = 'The student answer sent to OpenAI for evaluation';
$string['privacy:metadata:openai:solution'] = 'The teacher solution sent to OpenAI for comparison';
```

### Cumplimiento GDPR

- Los usuarios son informados sobre el uso de IA
- Los datos se envían solo para evaluación
- OpenAI no almacena los datos (según su política)
- Los usuarios pueden solicitar eliminación de sus datos

## ⚙️ Configuración

### En Moodle Admin

1. Ir a: **Site administration → Plugins → Activity modules → AI Assignment**

2. Configurar:
   - **OpenAI API Key**: Tu clave de API
   - **OpenAI Model**: Modelo a usar (default: gpt-4o-mini)

### Modelos Disponibles

- `gpt-4o-mini` - Rápido y económico (recomendado)
- `gpt-4o` - Más potente pero más caro
- `gpt-4-turbo` - Balance entre velocidad y calidad
- `gpt-3.5-turbo` - Más económico pero menos preciso

## 💰 Costos Estimados

### Con gpt-4o-mini (Recomendado)

- **Input**: $0.150 / 1M tokens
- **Output**: $0.600 / 1M tokens

**Ejemplo por evaluación:**
- Prompt: ~500 tokens
- Respuesta: ~300 tokens
- Costo: ~$0.0003 (menos de 1 centavo)

**Para 1000 evaluaciones:** ~$0.30 USD

### Con gpt-4o

- **Input**: $2.50 / 1M tokens
- **Output**: $10.00 / 1M tokens

**Para 1000 evaluaciones:** ~$5.00 USD

## 🐛 Manejo de Errores

### Errores Comunes

1. **No API Key configurada**
```php
throw new \moodle_exception('noapikey', 'mod_aiassignment');
```

2. **Error de API**
```php
throw new \moodle_exception('evaluationfailed', 'mod_aiassignment', '', null, $e->getMessage());
```

3. **Respuesta inválida**
```php
throw new \Exception('Invalid evaluation format');
```

### Logging

```php
debugging('OpenAI API Error: ' . $e->getMessage(), DEBUG_DEVELOPER);
```

## 🧪 Ejemplo Completo

### Entrada

**Problema:** Escribe una función que sume dos números

**Solución del Profesor:**
```python
def suma(a, b):
    """Suma dos números"""
    return a + b
```

**Respuesta del Estudiante:**
```python
def sumar_numeros(num1, num2):
    # Esta función suma dos números
    resultado = num1 + num2
    return resultado
```

### Proceso

1. **System Prompt**: Define que es un evaluador de código
2. **User Prompt**: Envía ambos códigos con criterios
3. **OpenAI**: Analiza y compara
4. **Respuesta**:

```json
{
  "similarity_score": 92,
  "feedback": "Excelente solución. El código es correcto y bien documentado. Los nombres de variables son descriptivos.",
  "analysis": "Funcionalidad: ✓ Perfecto - La función suma correctamente.\nEstilo: ✓ Muy bueno - Nombres descriptivos y comentario útil.\nBuenas prácticas: ✓ Bueno - Uso de variable intermedia es válido aunque no necesario.\nEficiencia: ✓ Óptimo - Complejidad O(1)."
}
```

### Salida

- **Calificación**: 92/100
- **Feedback**: Mostrado al estudiante
- **Analysis**: Análisis detallado disponible
- **Gradebook**: Actualizado automáticamente

## 🎓 Ventajas del Sistema

1. **Evaluación Instantánea**: Los estudiantes reciben feedback inmediato
2. **Consistencia**: La IA evalúa con los mismos criterios siempre
3. **Escalabilidad**: Puede evaluar miles de envíos sin fatiga
4. **Retroalimentación Detallada**: Análisis completo de cada aspecto
5. **Ahorro de Tiempo**: Los profesores no necesitan revisar cada envío manualmente

## ⚠️ Limitaciones

1. **Requiere API Key**: Necesitas cuenta de OpenAI
2. **Costo por Uso**: Cada evaluación tiene un costo (mínimo)
3. **Dependencia Externa**: Requiere conexión a internet
4. **No 100% Perfecto**: La IA puede cometer errores ocasionales
5. **Contexto Limitado**: No entiende el contexto completo del curso

## 🔮 Mejoras Futuras

1. **Evaluación Asíncrona**: Procesar en segundo plano
2. **Múltiples Modelos**: Permitir elegir diferentes IAs
3. **Ejecución de Código**: Probar el código realmente
4. **Casos de Prueba**: Validar con tests automáticos
5. **Feedback Personalizado**: Adaptar según el nivel del estudiante

---

**Implementado por:** Kiro AI Assistant  
**Fecha:** 11 de Febrero de 2026  
**Versión:** 1.0.0
