# Detección de Plagio Automática — Parámetros y Metodología

**Plugin:** mod_aiassignment  
**Archivo principal:** `moodle-plugin/classes/plagiarism_detector.php`

---

## Arquitectura: Análisis en 3 Capas

El sistema compara cada par de envíos usando tres capas independientes. El resultado final es una puntuación ponderada de las tres.

```
score_final = (léxica × 0.35) + (estructural × 0.30) + (semántica × 0.35)
```

---

## Capa 1 — Análisis Léxico (peso: 35%)

Compara los tokens del código después de normalizar identificadores. Es resistente al renombrado de variables y funciones.

### Proceso de normalización
Antes de comparar, el código pasa por estas transformaciones:
- Elimina comentarios (`//`, `/* */`, `#`)
- Reemplaza strings literales por `"STR"`
- Reemplaza números por `NUM`
- Normaliza espacios en blanco

### Parámetros calculados

| Parámetro | Descripción | Rango |
|---|---|---|
| **Jaccard de bigramas** | Proporción de pares de tokens consecutivos en común entre los dos códigos | 0–100% |
| **LCS ratio** | Longest Common Subsequence normalizada — longitud de la secuencia común de tokens | 0–100% |
| **Score léxico** | Promedio de Jaccard + LCS | 0–100% |
| `tokens1` / `tokens2` | Número de tokens en cada código | entero |
| `norm1` / `norm2` | Código normalizado (para inspección) | texto |

### Fórmula
```
jaccard = intersección(bigramas1, bigramas2) / unión(bigramas1, bigramas2)
lcs     = LCS(tokens1, tokens2) / max(len1, len2)
score_léxico = (jaccard + lcs) / 2
```

> Para arrays de más de 300 tokens, LCS se aproxima con Jaccard para evitar timeout.

---

## Capa 2 — Análisis Estructural (peso: 30%)

Compara la estructura del código: flujo de control, complejidad ciclomática y patrones de anidamiento.

### Motor de análisis
- **Python:** usa AST real a través de `ast_analyzer.py` (proceso hijo)
- **Java, JavaScript, C/C++, PHP:** análisis con regex enriquecido por lenguaje
- **Genérico:** métricas básicas con regex

### Parámetros universales

| Parámetro | Descripción |
|---|---|
| `functions` | Número de funciones/métodos definidos |
| `loops` | Número de bucles (`for`, `while`, `do`) |
| `conditionals` | Número de condicionales (`if`, `elif`, `switch`) |
| `returns` | Número de sentencias `return` |
| `recursion` | Si hay recursión (heurística: función que se llama a sí misma) |
| `nested_depth` | Profundidad máxima de anidamiento (llaves/indentación) |
| `operators_count` | Cantidad de operadores aritméticos, lógicos y de comparación |
| `control_sequence` | Secuencia ordenada de estructuras de control (Jaccard) |

### Parámetros adicionales por lenguaje

| Lenguaje | Parámetros extra |
|---|---|
| **Python** | `list_compr` (comprensiones de lista), `decorators`, `with_stmts` |
| **Java** | `classes`, `interfaces`, `exceptions` (try/catch/throw) |
| **JavaScript** | `arrow_fns`, `promises` (async/await/.then), `callbacks` |
| **C/C++** | `pointers`, `structs`, `includes` (#include) |

### Fórmula
```
Para cada métrica m:
    sim_m = 1 - |val1_m - val2_m| / max(val1_m, val2_m)

score_estructural = promedio(sim_m para todas las métricas) × 100
```

---

## Capa 3 — Análisis Semántico con IA (peso: 35%)

OpenAI GPT analiza si la lógica de los dos códigos es equivalente, aunque se vean diferentes superficialmente.

### Modelo usado
Configurable desde Administración del sitio. Por defecto: `gpt-4o-mini`.

### Parámetros que devuelve la IA

| Parámetro | Descripción | Rango |
|---|---|---|
| `similarity_score` | Porcentaje de similitud semántica | 0–100 |
| `analysis` | Explicación en español (máx. 3 oraciones) | texto |
| `techniques_found` | Lista de técnicas de ofuscación detectadas | array |
| `verdict` | Veredicto preliminar de la IA | `original` / `sospechoso` / `plagio` |

### Optimización de llamadas a la API
El sistema **omite la llamada a OpenAI** automáticamente cuando:
- El promedio de léxica + estructural es **> 85%** (plagio obvio, no necesita confirmación)
- El promedio de léxica + estructural es **< 20%** (claramente original)
- Se activa el **Modo Rápido** (`nosem=1`)

En esos casos, el score final se calcula solo con léxica (55%) + estructural (45%).

---

## Detección de Técnicas de Ofuscación

El sistema detecta automáticamente 4 técnicas comunes:

| Técnica | Condición de detección |
|---|---|
| **Renombrado de variables/funciones** | Score léxico normalizado > 60% pero Jaccard de tokens literales < 40% |
| **Cambio de tipo de bucle** | Número de bucles diferente entre los dos códigos pero score estructural > 55% |
| **Reordenación de sentencias** | Jaccard de tokens ordenados > 85% pero LCS < 70% |
| **Inserción de código muerto** | Diferencia de tamaño > 30% pero score léxico > 55% |

Cada técnica detectada agrega **+5 puntos** al score final (boost de ofuscación):

```
score_ajustado = min(100, score_final + técnicas_detectadas × 5)
```

---

## Umbrales de Decisión

| Rango | Veredicto | Color en UI |
|---|---|---|
| ≥ 75% | 🔴 Plagio probable | Rojo (`#dc3545`) |
| 50–74% | 🟡 Sospechoso | Amarillo (`#856404`) |
| < 50% | 🟢 Original | Verde (`#155724`) |

> El umbral de 75% es **configurable** desde:  
> Administración del sitio → Plugins → Módulos de actividad → AI Assignment → **Umbral de plagio (%)**

---

## Caché del Reporte

Para evitar recalcular con cada visita, el reporte se guarda en caché de Moodle (`mod_aiassignment/plagiarism`).

- La caché se invalida automáticamente cuando hay un envío nuevo
- Se mantiene separada para modo rápido (`_fast`) y modo completo (`_full`)
- Se puede forzar recálculo con el parámetro `force=1` en la URL

---

## Modos de Análisis

### ⚡ Modo Rápido (`nosem=1`)
- Solo capas léxica + estructural
- Sin llamadas a OpenAI
- Tiempo estimado: ~50ms por par de envíos
- Con 30 alumnos (435 pares): ~20 segundos

### 🧠 Modo Completo (`nosem=0`)
- Las 3 capas incluyendo OpenAI
- Tiempo estimado: ~2s por par (dependiendo de la API)
- Con 30 alumnos: ~15 minutos (sin optimización de caché)
- Con optimización automática (omitir IA en casos obvios): ~3-5 minutos

---

## Flujo Completo de una Comparación

```
1. Recibir código1 y código2
2. Normalizar identificadores en ambos
3. Tokenizar ambos códigos
4. Calcular Jaccard de bigramas + LCS → score_léxico
5. Detectar lenguaje (Python/Java/JS/C++/PHP/genérico)
6. Extraer métricas estructurales por lenguaje
7. Comparar métricas → score_estructural
8. Si (léxica+estructural)/2 entre 20-85% Y modo completo:
   → Llamar a OpenAI → score_semántico
   Sino: score_semántico = 0 (omitido)
9. score_final = léxica×0.35 + estructural×0.30 + semántica×0.35
10. Detectar técnicas de ofuscación → boost
11. score_ajustado = score_final + técnicas×5
12. Veredicto: plagio/sospechoso/original según umbrales
```

---

## Almacenamiento en Base de Datos

Los resultados se guardan en `mdl_aiassignment_evaluations`:

| Campo | Descripción |
|---|---|
| `submission` | FK a la submission analizada |
| `similarity_score` | Score máximo de plagio detectado (0–100) |
| `ai_feedback` | Feedback textual |
| `ai_analysis` | JSON con estado de revisión (`plagiarism_status`, `reviewed_by`, `reviewed_at`) |
| `timecreated` | Timestamp del análisis |
