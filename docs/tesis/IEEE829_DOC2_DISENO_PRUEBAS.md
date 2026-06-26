# Documento 2 — Especificación del Diseño de Pruebas (IEEE 829)
# AI Assignment Plugin v2.5.0

---

## 1. Identificador
**ID:** DD-AIASSIGNMENT-2026-01
**Referencia al Plan:** PP-AIASSIGNMENT-2026-01

---

## 2. Características a Probar

### DD-01: Evaluación automática con IA

**Qué se prueba:** El método `ai_evaluator::evaluate()` debe recibir el código del alumno y la solución del profesor, llamar a OpenAI GPT-4o-mini y devolver un score entre 0 y 100 con feedback en español.

**Criterio de éxito:** El score devuelto está en el rango [0, 100], el feedback no está vacío, y la confianza es un entero entre 0 y 100.

**Técnica:** Prueba de caja negra con entradas controladas. Se usa modo demo para evitar llamadas reales a la API.

---

### DD-02: Detección de plagio — Capa Léxica

**Qué se prueba:** El método `lexical_analyzer::similarity()` debe calcular similitud entre dos fragmentos de código usando Jaccard sobre bigramas, LCS ratio y Levenshtein normalizado.

**Criterio de éxito:**
- Código idéntico → score ≥ 90%
- Código con variables renombradas → score ≥ 60% (normalización activa)
- Código completamente diferente → score ≤ 30%

**Técnica:** Prueba de caja blanca con pares de código conocidos.

---

### DD-03: Detección de plagio — Capa Estructural (AST)

**Qué se prueba:** El script `ast_analyzer.py` debe parsear código Python con `ast.parse()` y extraer métricas estructurales (funciones, bucles, condicionales, profundidad).

**Criterio de éxito:**
- Código con misma estructura pero variables renombradas → similitud ≥ 80%
- Código con diferente estructura (for vs while) → similitud entre 50-80%
- Código con algoritmo completamente diferente → similitud ≤ 40%

**Técnica:** Prueba de integración PHP→Python con proceso hijo.

---

### DD-04: Detección de técnicas de ofuscación

**Qué se prueba:** El método `obfuscation_detector::detect()` debe identificar correctamente las 6 técnicas de ofuscación.

**Criterio de éxito:** Cada técnica de ofuscación presente en el código debe ser detectada. Cada técnica detectada suma +5 al score final.

**Técnica:** Prueba de caja blanca con casos diseñados específicamente para cada técnica.

---

### DD-05: Seguridad — Sanitización de entradas

**Qué se prueba:** El método `security::sanitize_code()` debe rechazar entradas maliciosas y aceptar código legítimo.

**Criterio de éxito:**
- Código con `<script>` → excepción lanzada
- Código con null bytes → eliminados
- Código Python legítimo → aceptado sin modificación
- Código vacío → excepción lanzada

**Técnica:** Prueba de valores límite y casos de error.

---

### DD-06: Rendimiento del análisis de plagio

**Qué se prueba:** El tiempo de ejecución del análisis de plagio con 30 alumnos en modo rápido debe ser ≤ 60 segundos.

**Criterio de éxito:** Tiempo medido ≤ 60 segundos para 435 comparaciones en modo rápido.

**Técnica:** Prueba de rendimiento con cronómetro.

---

### DD-07: Usabilidad — Encuesta SUS

**Qué se prueba:** La percepción de usabilidad del sistema por parte de profesores y alumnos.

**Criterio de éxito:** Score SUS promedio ≥ 70 puntos (clasificación "Aceptable" o superior).

**Técnica:** Encuesta estandarizada SUS de 10 preguntas aplicada a 6 participantes.

---

## 3. Refinamientos de Prueba

### Refinamiento para DD-02 (Capa Léxica)

Los pares de código para probar la capa léxica se clasifican en 4 categorías:

| Categoría | Descripción | Score esperado |
|-----------|-------------|----------------|
| Idéntico | Mismo código sin cambios | ≥ 90% |
| Renombrado | Variables/funciones con nombres diferentes | 60-90% |
| Sospechoso | Misma lógica, diferente estructura | 40-70% |
| Original | Algoritmo completamente diferente | ≤ 30% |

### Refinamiento para DD-04 (Ofuscación)

Cada técnica tiene una señal matemática específica:

| Técnica | Señal de detección |
|---------|-------------------|
| Renombrado | Jaccard normalizado > 60% Y Jaccard literal < 40% |
| Cambio de bucle | Nº bucles diferente Y score estructural > 55% |
| Reordenación | Jaccard ordenado > 85% Y LCS < 70% |
| Código muerto | Diferencia tamaño > 30% Y similitud léxica > 55% |
| Operadores equiv. | Jaccard operadores normalizados > 80% Y Jaccard literal < 60% |
| Comentarios falsos | Diferencia ratio comentarios > 20% Y similitud > 50% |
