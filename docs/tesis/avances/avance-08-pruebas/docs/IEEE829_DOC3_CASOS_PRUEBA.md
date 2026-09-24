# Documento 3 — Especificación de Casos de Prueba (IEEE 829)
# AI Assignment Plugin v2.5.0

---

## CP-01: Evaluación de código correcto en modo demo

**ID:** CP-01
**Referencia diseño:** DD-01
**Prioridad:** Alta

**Precondiciones:**
- Plugin instalado en Moodle
- Modo demo activado (`demo_mode = 1` en configuración)

**Entradas:**
```
studentanswer = "def factorial(n):\n    if n <= 1:\n        return 1\n    return n * factorial(n - 1)\n\nprint(factorial(5))"
teachersolution = "def factorial(n):\n    if n <= 1:\n        return 1\n    return n * factorial(n - 1)"
type = "programming"
```

**Pasos:**
1. Llamar a `ai_evaluator::evaluate($studentanswer, $teachersolution, 'programming')`
2. Verificar la estructura del resultado

**Salida esperada:**
```json
{
  "similarity_score": [55, 95],
  "feedback": "string no vacío",
  "confidence": 60,
  "errors": []
}
```

**Resultado real:** similarity_score = 84.0, feedback = "Buen código...", confidence = 60 ✅
**Estado:** PASS

---

## CP-02: Evaluación con código vacío

**ID:** CP-02
**Referencia diseño:** DD-05
**Prioridad:** Alta

**Precondiciones:** Plugin instalado

**Entradas:**
```
code = ""
```

**Pasos:**
1. Llamar a `security::sanitize_code("")`
2. Verificar que se lanza excepción

**Salida esperada:** Excepción `moodle_exception` con código `answerrequired`

**Resultado real:** Excepción lanzada correctamente ✅
**Estado:** PASS

---

## CP-03: Detección de XSS en código

**ID:** CP-03
**Referencia diseño:** DD-05
**Prioridad:** Alta

**Entradas:**
```
code = '<script>alert("xss")</script>'
```

**Pasos:**
1. Llamar a `security::sanitize_code($code)`

**Salida esperada:** Excepción `moodle_exception` con código `answerforbidden`

**Resultado real:** Excepción lanzada correctamente ✅
**Estado:** PASS

---

## CP-04: Similitud léxica — código idéntico

**ID:** CP-04
**Referencia diseño:** DD-02
**Prioridad:** Alta

**Entradas:**
```python
code1 = "def factorial(n):\n    if n <= 1:\n        return 1\n    return n * factorial(n - 1)"
code2 = code1  # idéntico
```

**Pasos:**
1. Llamar a `lexical_analyzer::similarity($code1, $code2)`
2. Verificar score

**Salida esperada:** score ≥ 90%

**Resultado real:** score = 100% ✅
**Estado:** PASS

---

## CP-05: Similitud léxica — renombrado de variables

**ID:** CP-05
**Referencia diseño:** DD-02
**Prioridad:** Alta

**Entradas:**
```python
code1 = "def factorial(n):\n    if n <= 1:\n        return 1\n    return n * factorial(n - 1)"
code2 = "def calc_fact(num):\n    if num <= 1:\n        return 1\n    return num * calc_fact(num - 1)"
```

**Pasos:**
1. Llamar a `lexical_analyzer::similarity($code1, $code2)`
2. Verificar que score > 60% (normalización detecta el renombrado)

**Salida esperada:** score ≥ 60%

**Resultado real:** score = 87.3% ✅
**Estado:** PASS

---

## CP-06: Similitud léxica — código completamente diferente

**ID:** CP-06
**Referencia diseño:** DD-02
**Prioridad:** Alta

**Entradas:**
```
code1 = "def factorial(n):\n    if n <= 1: return 1\n    return n * factorial(n-1)"
code2 = "SELECT nombre FROM estudiantes WHERE calificacion >= 70 ORDER BY nombre;"
```

**Pasos:**
1. Llamar a `lexical_analyzer::similarity($code1, $code2)`

**Salida esperada:** score ≤ 30%

**Resultado real:** score = 9.8% ✅
**Estado:** PASS

---

## CP-07: Detección de renombrado de variables

**ID:** CP-07
**Referencia diseño:** DD-04
**Prioridad:** Alta

**Entradas:**
```
code1 = "def factorial(n):\n    if n <= 1: return 1\n    return n * factorial(n-1)"
code2 = "def calc_fact(num):\n    if num <= 1: return 1\n    return num * calc_fact(num-1)"
lex = ['score' => 87.3, 'jaccard' => 30.1]
struct = ['score' => 91.2, 'features1' => ['loops' => 0], 'features2' => ['loops' => 0]]
```

**Pasos:**
1. Llamar a `obfuscation_detector::detect($code1, $code2, $lex, $struct)`
2. Verificar que "Renombrado de variables/funciones" está en el resultado

**Salida esperada:** Array contiene "Renombrado de variables/funciones"

**Resultado real:** ["Renombrado de variables/funciones"] ✅
**Estado:** PASS

---

## CP-08: Detección de inserción de código muerto

**ID:** CP-08
**Referencia diseño:** DD-04
**Prioridad:** Alta

**Entradas:**
```python
code1 = "def factorial(n):\n    if n <= 1: return 1\n    return n * factorial(n-1)"
code2 = "def factorial(n):\n    x = 0\n    y = 1\n    z = n + 0\n    if z <= 1: return 1\n    return z * factorial(z-1)"
```

**Pasos:**
1. Calcular similitud léxica y estructural
2. Llamar a `obfuscation_detector::detect()`

**Salida esperada:** Array contiene "Posible inserción de código muerto o padding"

**Resultado real:** ["Posible inserción de código muerto o padding"] ✅
**Estado:** PASS

---

## CP-09: Análisis AST Python — misma estructura

**ID:** CP-09
**Referencia diseño:** DD-03
**Prioridad:** Alta

**Entradas:**
```python
code1 = "def factorial(n):\n    if n <= 1:\n        return 1\n    return n * factorial(n - 1)"
code2 = "def calc_fact(num):\n    if num <= 1:\n        return 1\n    return num * calc_fact(num - 1)"
```

**Pasos:**
1. Ejecutar `python ast_analyzer.py <payload_base64>`
2. Verificar similitud estructural

**Salida esperada:** similarity ≥ 80%

**Resultado real:** similarity = 91.2% ✅
**Estado:** PASS

---

## CP-10: Análisis AST Python — código con error de sintaxis

**ID:** CP-10
**Referencia diseño:** DD-03
**Prioridad:** Media

**Entradas:**
```python
code1 = "def factorial(n  # código con error de sintaxis"
code2 = "def factorial(n):\n    return 1"
```

**Pasos:**
1. Ejecutar `python ast_analyzer.py <payload_base64>`
2. Verificar que devuelve resultado sin crash

**Salida esperada:** JSON con similarity = 0 o fallback a regex, sin excepción

**Resultado real:** Fallback a análisis regex, similarity = 12% ✅
**Estado:** PASS

---

## CP-11: Caché de evaluaciones

**ID:** CP-11
**Referencia diseño:** DD-01
**Prioridad:** Media

**Precondiciones:** Primera evaluación ya ejecutada y guardada en caché

**Entradas:** Mismo código y solución que CP-01

**Pasos:**
1. Llamar a `ai_evaluator::evaluate()` con los mismos parámetros
2. Verificar que `from_cache = true` en el resultado

**Salida esperada:** `from_cache = true`, mismo score que la primera evaluación

**Resultado real:** from_cache = true, score = 84.0 ✅
**Estado:** PASS

---

## CP-12: Rate limiting de OpenAI

**ID:** CP-12
**Referencia diseño:** DD-01
**Prioridad:** Media

**Precondiciones:** Contador de llamadas en caché = 100 (límite alcanzado)

**Pasos:**
1. Simular que el contador de llamadas llegó al límite
2. Intentar llamar a `ai_evaluator::evaluate()` en modo real

**Salida esperada:** Excepción `openai_rate_exceeded`

**Resultado real:** Excepción lanzada correctamente ✅
**Estado:** PASS

---

## CP-13: Rendimiento — análisis de plagio 30 alumnos modo rápido

**ID:** CP-13
**Referencia diseño:** DD-06
**Prioridad:** Alta

**Precondiciones:** 30 alumnos con envíos cargados en BD (inscribir-30-alumnos.sql)

**Pasos:**
1. Registrar tiempo de inicio
2. Ejecutar `plagiarism_detector::generate_plagiarism_report($assignmentid, true)`
3. Registrar tiempo de fin
4. Calcular duración

**Salida esperada:** Duración ≤ 60 segundos, 435 comparaciones realizadas

**Resultado real:** 18.4 segundos, 435 comparaciones ✅
**Estado:** PASS

---

## CP-14: Precisión global del detector de plagio

**ID:** CP-14
**Referencia diseño:** DD-02, DD-03, DD-04
**Prioridad:** Alta

**Precondiciones:** 30 alumnos con grupos de plagio conocido (A-E)

**Pasos:**
1. Ejecutar análisis de plagio completo
2. Comparar veredictos del sistema con veredictos esperados
3. Calcular precisión, recall y F1

**Salida esperada:**
- Precisión ≥ 80%
- Falsos positivos ≤ 10%

**Resultado real:**
- Precisión = 100% (28/28 correctos)
- Falsos positivos = 0%
- F1-Score = 100% ✅

**Estado:** PASS

---

## CP-15: Usabilidad — Score SUS

**ID:** CP-15
**Referencia diseño:** DD-07
**Prioridad:** Media

**Participantes:** 1 profesor (Yobani) + 5 alumnos (alumno01-05)

**Pasos:**
1. Cada participante usa el plugin durante 1 semana
2. Completar encuesta SUS de 10 preguntas
3. Calcular score promedio

**Salida esperada:** Score SUS promedio ≥ 70

**Resultado real:** Score promedio = 82.5 (Bueno, grado B) ✅
**Estado:** PASS
