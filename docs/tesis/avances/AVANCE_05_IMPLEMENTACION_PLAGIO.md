# Avance 5 — Implementación del Sistema de Detección de Plagio

| Campo | Detalle |
|---|---|
| **Número de Avance** | 5 de 10 |
| **Título** | Implementación del Sistema de Detección de Plagio |
| **Fecha** | Septiembre 2026 |
| **Universidad** | Universidad Autónoma de Sinaloa — Facultad de Informática Mazatlán (FIM) |
| **Autor** | Ángel Flores |
| **Versión del Plugin** | v2.5.1 |

---

## 1. Descripción General de las 3 Capas

El motor de detección de plagio del plugin `mod_aiassignment` está implementado en la clase `PlagiarismDetector` del archivo `plagiarism_detector.php`. El diseño multicapa responde a una necesidad fundamental: ningún método individual de detección de similitud es suficientemente robusto frente a todas las técnicas de ofuscación conocidas. La combinación ponderada de tres enfoques complementarios (léxico, estructural y semántico) maximiza tanto la sensibilidad (recall) como la especificidad (precisión) del sistema.

La fórmula de score final implementada en el método `calculateFinalScore()` es:

```php
/**
 * Calcula el score final ponderado de similitud entre dos submissions.
 *
 * @param float $lexical   Score léxico [0, 1]
 * @param float $structural Score estructural [0, 1]
 * @param float $semantic  Score semántico [0, 1], puede ser -1 si se omitió
 * @return float Score final ponderado [0, 1]
 */
public function calculateFinalScore(float $lexical, float $structural, float $semantic): float {
    if ($semantic === -1.0) {
        // Si la capa semántica se omitió, redistribuir pesos
        return ($lexical * 0.50) + ($structural * 0.50);
    }
    return ($lexical * 0.35) + ($structural * 0.30) + ($semantic * 0.35);
}
```

---

## 2. Capa 1 — Análisis Léxico (Peso: 35%)

### 2.1 Normalización de Identificadores

El método `normalizeIdentifiers(string $code, string $language): string` es el primer paso del análisis léxico. Elimina todos los comentarios (línea y bloque), normaliza espacios y saltos de línea, y reemplaza sistemáticamente los nombres de variables, funciones y clases por tokens genéricos (`VAR_N`, `FUNC_N`, `CLASS_N`). Esta normalización neutraliza la técnica de ofuscación más común: renombrar identificadores.

```php
// Ejemplo de normalización en Python
// Código original:
def calcular_suma(numeros):
    total = 0
    for num in numeros:
        total += num
    return total

// Código normalizado:
def FUNC_0(VAR_0):
    VAR_1 = 0
    for VAR_2 in VAR_0:
        VAR_1 += VAR_2
    return VAR_1
```

Para cada lenguaje soportado, se aplican expresiones regulares específicas. En PHP, se utiliza la extensión `tokenizer` para una tokenización más precisa. En Python y Java se aplican patrones regex con lookahead/lookbehind para respetar el contexto de las keywords reservadas.

### 2.2 Coeficiente de Jaccard sobre Bigramas

Tras normalización, se genera la secuencia de tokens y se extraen todos los bigramas (pares consecutivos). El coeficiente de Jaccard mide la proporción de bigramas compartidos sobre el total de bigramas únicos de ambas secuencias:

```php
public function jaccardBigrams(array $tokens1, array $tokens2): float {
    $bigrams1 = $this->extractBigrams($tokens1);
    $bigrams2 = $this->extractBigrams($tokens2);
    
    $intersection = count(array_intersect($bigrams1, $bigrams2));
    $union = count(array_unique(array_merge($bigrams1, $bigrams2)));
    
    if ($union === 0) return 0.0;
    return $intersection / $union;
}
```

Los bigramas son más informativos que los unigramas porque capturan el contexto local del código: la secuencia `[IF, CONDITION]` tiene un significado distinto a `[ASSIGN, IF]`, y el Jaccard sobre bigramas detecta estas diferencias.

### 2.3 Subsecuencia Común Más Larga (LCS)

El algoritmo LCS implementado en `calculateLCS()` usa programación dinámica con complejidad O(m×n). La similitud LCS normalizada es `lcs_length / max(len(seq1), len(seq2))`. LCS detecta bloques de código que aparecen en el mismo orden relativo aunque no sean consecutivos, siendo útil para detectar reestructuraciones de bloques de código.

El **score léxico combinado** pondera ambas métricas:
```
lexical_score = 0.60 × jaccard_score + 0.40 × lcs_score
```

---

## 3. Capa 2 — Análisis Estructural AST (Peso: 30%)

### 3.1 Integración PHP–Python

El análisis estructural invoca `ast_analyzer.py` mediante `exec()` con `escapeshellarg()` para prevenir inyección de comandos. El script Python recibe el código como archivo temporal (para evitar problemas con caracteres especiales en argumentos), analiza con `ast.parse()` y retorna un JSON:

```python
# ast_analyzer.py — función principal de extracción de features
def extract_ast_features(source_code: str) -> dict:
    try:
        tree = ast.parse(source_code)
    except SyntaxError as e:
        return {"error": str(e), "features": None}
    
    visitor = ASTFeatureVisitor()
    visitor.visit(tree)
    
    return {
        "function_count": visitor.function_count,
        "class_count": visitor.class_count,
        "loop_count": visitor.loop_count,
        "conditional_count": visitor.conditional_count,
        "import_count": visitor.import_count,
        "max_nesting_depth": visitor.max_depth,
        "node_type_sequence": visitor.node_sequence,
        "function_names_normalized": visitor.func_names_normalized,
        "cyclomatic_complexity": visitor.cyclomatic_complexity,
        "has_recursion": visitor.has_recursion,
        "comprehension_count": visitor.comprehension_count,
        "exception_handling_count": visitor.exception_count
    }
```

### 3.2 Similitud Coseno sobre Vectores de Features

Los 12 features numéricos del AST se convierten en un vector y se calcula la similitud coseno entre los vectores de dos submissions. La similitud coseno es invariante a la escala (funciona para programas de diferentes tamaños) y captura la "forma" estructural del código:

```php
public function cosineSimilarity(array $vec1, array $vec2): float {
    $dotProduct = 0.0;
    $magnitude1 = 0.0;
    $magnitude2 = 0.0;
    
    foreach ($vec1 as $i => $val) {
        $dotProduct += $val * ($vec2[$i] ?? 0);
        $magnitude1 += $val * $val;
    }
    foreach ($vec2 as $val) {
        $magnitude2 += $val * $val;
    }
    
    $denominator = sqrt($magnitude1) * sqrt($magnitude2);
    return ($denominator > 0) ? $dotProduct / $denominator : 0.0;
}
```

Además del vector numérico, la secuencia de tipos de nodos AST (`node_type_sequence`) se compara con LCS normalizado para capturar el orden estructural del programa.

---

## 4. Capa 3 — Análisis Semántico con GPT-4o-mini (Peso: 35%)

### 4.1 Activación Condicional

La capa semántica es la más costosa (en tiempo y en tokens de API) y la más resistente a la ofuscación. Se activa únicamente cuando el score combinado de las capas 1 y 2 cae en la zona de incertidumbre:

```php
$combined = ($lexical * 0.5) + ($structural * 0.5);
if ($combined < 0.20) {
    return -1.0; // No plagio evidente → omitir semántica
}
if ($combined > 0.85) {
    return 1.0;  // Plagio muy probable → omitir semántica (confirmar)
}
// Zona de incertidumbre [0.20, 0.85]: invocar GPT
return $this->callSemanticAnalysis($code1, $code2);
```

### 4.2 Prompt Engineering para GPT

El prompt especializado de comparación semántica está diseñado para obtener respuestas deterministas en JSON:

```
You are an expert code plagiarism detector. Analyze the following two code snippets
and determine their semantic similarity.

CODE A:
```{code_a}```

CODE B:
```{code_b}```

Analyze strictly the algorithmic logic, data structures used, and problem-solving approach.
Ignore variable names, formatting, and comments.

Respond ONLY with a JSON object with this exact structure:
{
  "semantic_similarity": <float 0.0-1.0>,
  "same_algorithm": <boolean>,
  "explanation": "<brief explanation in one sentence>",
  "confidence": <float 0.0-1.0>
}
```

La temperatura se establece en `0.1` para maximizar la determinismo de las respuestas del modelo.

---

## 5. Detección de Técnicas de Ofuscación

El plugin detecta explícitamente 6 técnicas de ofuscación documentadas en la literatura de plagio de código:

| # | Técnica | Descripción | Capa que la detecta |
|---|---|---|---|
| 1 | **Renombrado de identificadores** | Variables `a`, `b`, `c` en lugar de `suma`, `total`, `resultado` | Léxica (normalización previa) |
| 2 | **Inserción de código muerto** | Bloques `if False:` o funciones nunca llamadas | Estructural (AST ignora ramas muertas) |
| 3 | **Reordenamiento de bloques** | Cambio del orden de funciones independientes | Léxica (LCS) + Estructural |
| 4 | **Cambio de tipo de bucle** | Convertir `for` → `while` con mismo comportamiento | Semántica (GPT detecta equivalencia) |
| 5 | **Refactorización de funciones** | Extraer bloques en funciones auxiliares | Estructural (AST de nodos) + Semántica |
| 6 | **Sustitución de estructuras de datos** | Lista → diccionario con misma lógica | Semántica (GPT) |

```php
// Ejemplo: detección de código muerto (Técnica 2)
// Código ofuscado:
def FUNC_0(VAR_0, VAR_1):
    if False:                     # Código muerto — no afecta AST funcional
        print("Debug")
    VAR_2 = VAR_0 + VAR_1         # Esta es la línea real
    return VAR_2

// El AST de ast.parse() NO incluye el bloque `if False` en el flujo funcional,
// por lo que la similitud estructural no se ve afectada por este ruido.
```

---

## 6. Sistema de Caché Inteligente

El sistema de caché almacena resultados de comparaciones ya calculadas en la tabla `mdl_aiassignment_cache`. La clave de caché es el hash SHA-256 del par de códigos normalizados (orden canónico: el hash menor primero), garantizando que el par (A, B) y el par (B, A) generen la misma clave:

```php
private function getCacheKey(string $code1, string $code2): string {
    $normalized1 = $this->normalizeIdentifiers($code1, $this->language);
    $normalized2 = $this->normalizeIdentifiers($code2, $this->language);
    
    $hash1 = hash('sha256', $normalized1);
    $hash2 = hash('sha256', $normalized2);
    
    // Orden canónico para simetría del par
    if ($hash1 > $hash2) { [$hash1, $hash2] = [$hash2, $hash1]; }
    
    return hash('sha256', $hash1 . '|' . $hash2);
}
```

La **validación por timestamp** garantiza que el caché se invalide cuando una submission es modificada. Si `submission.timemodified > cache.created_at`, el resultado cacheado se descarta y se recalcula. Esto previene que estudiantes que corrigen su código sigan siendo marcados con resultados de comparaciones anteriores.

---

## 7. Reporte Masivo O(n²/2) con Paginación

El método `generatePlagiarismReport(int $assignmentId, int $page = 0, int $perPage = 50): array` genera el reporte completo de todos los pares de submissions. Para N = 30 estudiantes, se calculan 30×29/2 = 435 comparaciones únicas. El proceso se ejecuta en background mediante una tarea Moodle programada (`\mod_aiassignment\task\run_plagiarism_check`) para no bloquear la interfaz del profesor.

Los resultados se ordenan por `final_score DESC` y se muestran con paginación de 50 registros por página. El dashboard incluye una vista de "heat map" donde cada celda de la matriz de similitud se colorea según el score (verde < 40%, amarillo 40-74%, rojo ≥ 75%).

---

## 8. Exportación de Reportes

El sistema soporta dos formatos de exportación del reporte de plagio:

**CSV**: Generado en `report_exporter.php` con columnas: Estudiante A, Estudiante B, Score Léxico, Score Estructural, Score Semántico, Score Final, Umbral, Sospechoso (sí/no). Se utiliza la API de Moodle (`\core\dataformat`) para garantizar codificación UTF-8 correcta en nombres de estudiantes con caracteres especiales.

**HTML/PDF**: Reporte visual con la matriz de similitud, fragmentos de código lado a lado con diferencias resaltadas, y timeline de submissions. El PDF se genera mediante `mPDF` (incluido en Moodle) o mediante la impresión del HTML desde el navegador con estilos `@media print` optimizados.

---

*Fin del Avance 5 — Siguiente: Sistema de Evaluación Automática con IA*
