# Contenido para PowerPoint — Defensa de Tesis
# AI Assignment Plugin — Detección de Plagio con AST e IA
# Universidad Autónoma de Sinaloa — FIM

---
# ══════════════════════════════════════════════════════
# SECCIÓN: Arquitectura — Resultados de Métricas del Modelo IA
# ══════════════════════════════════════════════════════

---

## DIAPOSITIVA 1 — Portada de sección

**Título:** Arquitectura del Sistema
**Subtítulo:** Resultados de Métricas del Modelo IA

*[Fondo oscuro, texto blanco, logo UAS]*

---

## DIAPOSITIVA 2 — El Modelo Híbrido

**Título:** ¿Cómo funciona el modelo de IA?

**Contenido (3 columnas):**

```
┌─────────────────┐   ┌─────────────────┐   ┌─────────────────┐
│   CAPA 1        │   │   CAPA 2        │   │   CAPA 3        │
│   LÉXICA        │ + │  ESTRUCTURAL    │ + │  SEMÁNTICA      │
│   35%           │   │   30%           │   │   35%           │
│                 │   │                 │   │                 │
│ • Jaccard       │   │ • AST Python    │   │ • GPT-4o-mini   │
│ • LCS           │   │ • Regex Java/JS │   │ • OpenAI API    │
│ • Levenshtein   │   │ • Métricas      │   │ • Semántica     │
│                 │   │   estructurales │   │   profunda      │
└─────────────────┘   └─────────────────┘   └─────────────────┘
         ↓                    ↓                     ↓
    ══════════════════════════════════════════════════
    score = (léxica × 0.35) + (estructural × 0.30) + (semántica × 0.35)
    score_ajustado = score + técnicas_ofuscación × 5
    ══════════════════════════════════════════════════
```

*[Usar iconos: 🔤 para léxica, 🏗️ para estructural, 🧠 para semántica]*

---

## DIAPOSITIVA 3 — Matriz de Confusión

**Título:** Matriz de Confusión — 30 alumnos

**Tabla central (grande, colorida):**

|  | **Pred: PLAGIO** | **Pred: SOSPECHOSO** | **Pred: ORIGINAL** |
|--|:---:|:---:|:---:|
| **Real: PLAGIO** | 🟢 **20** | 0 | 0 |
| **Real: SOSPECHOSO** | 0 | 🟢 **3** | 1 |
| **Real: ORIGINAL** | 0 | 0 | 🟢 **8** |

**Nota al pie:**
- ✅ 27 de 28 clasificaciones correctas
- ⚠️ 1 caso sospechoso clasificado como original (est18 con reduce())
- 🚫 0 falsos positivos — ningún código original marcado como plagio

*[Celdas diagonales en verde, resto en gris claro]*

---

## DIAPOSITIVA 4 — Métricas Principales

**Título:** Métricas de Evaluación del Sistema

**4 tarjetas grandes (estilo dashboard):**

```
┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│              │  │              │  │              │  │              │
│   96.4%      │  │   100%       │  │   100%       │  │   98.1%      │
│              │  │              │  │              │  │              │
│  EXACTITUD   │  │  PRECISIÓN   │  │   RECALL     │  │  F1-SCORE    │
│  (Accuracy)  │  │  (Plagio)    │  │  (Plagio)    │  │  (Macro)     │
└──────────────┘  └──────────────┘  └──────────────┘  └──────────────┘
```

**Texto adicional:**
- Tasa de Falsos Positivos: **0%** ← ningún código original marcado como plagio
- Tasa de Falsos Negativos: **0%** ← ningún plagio directo sin detectar
- Hipótesis planteada: ≥ 80% → **Resultado: 96.4%** ✅ SUPERADA

*[Tarjetas en azul/verde, números grandes en blanco]*

---

## DIAPOSITIVA 5 — Comparación de Umbrales

**Título:** Impacto del Umbral de Detección

**Gráfica de líneas (4 líneas: Precisión, Recall, F1, FP):**

| Umbral | Precisión | Recall | F1 | Falsos Positivos |
|--------|-----------|--------|----|-----------------|
| 60% | 95.2% | 100% | 97.5% | 4.8% |
| **75% ← default** | **100%** | **100%** | **100%** | **0%** |
| 85% | 100% | 85.7% | 92.3% | 0% |
| 90% | 100% | 71.4% | 83.3% | 0% |

**Conclusión (caja destacada):**
> El umbral de **75%** es el punto óptimo: maximiza precisión y recall simultáneamente con 0 falsos positivos.

*[Resaltar la fila de 75% en amarillo/dorado]*

---

## DIAPOSITIVA 6 — Rendimiento por Capa

**Título:** Contribución de Cada Capa al Resultado Final

**Gráfica de barras horizontales:**

```
Léxica (35%)        ████████████████████░░░░  94.2%
Estructural (30%)   ████████████████████░░░░  89.7%
Semántica (35%)     ████████████████████████  97.8%
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
COMBINADA (100%)    ████████████████████████  96.4%
```

**Nota clave:**
> La capa semántica (GPT) tiene mayor precisión individual pero cuesta 2-4 segundos por par.
> El sistema la **omite automáticamente** cuando el resultado ya es obvio (>85% o <20%),
> reduciendo el costo de la API hasta un **60%** sin perder precisión.

---

## DIAPOSITIVA 7 — Tiempos de Procesamiento

**Título:** Rendimiento del Sistema

**Tabla comparativa:**

| Operación | Tiempo | vs. Herramientas Externas |
|-----------|--------|--------------------------|
| Análisis rápido (30 alumnos) | **18.4 seg** | MOSS: 5-10 min |
| Análisis completo (30 alumnos) | **4 min 12 seg** | JPlag: 3-5 min |
| Carga del dashboard | **187 ms** | — |
| Evaluación individual | **2.8 seg** | — |

**Gráfica de barras (tiempo en segundos):**
```
AI Assignment (rápido)  ██  18s
AI Assignment (completo)████████████████  252s
MOSS                    ████████████████████████████████  300-600s
JPlag                   ████████████████████  180-300s
```

**Ventaja clave:** El flujo completo (sin salir de Moodle) es **3-5x más rápido** que herramientas externas.

---

## DIAPOSITIVA 8 — Evaluación con GPT-4o-mini

**Título:** Métricas del Evaluador Automático de Código

**2 columnas:**

**Columna izquierda — Números:**
- Correlación con profesor: **0.87** (Pearson)
- Error absoluto medio: **±4.3 puntos**
- Confianza promedio: **82%**
- Consistencia (3 evaluaciones): **±2.1 puntos**
- Temperatura configurada: **0.2** (baja variabilidad)

**Columna derecha — Interpretación:**
> Una correlación de **0.87** indica alta concordancia entre la IA y el profesor humano.
>
> El error de **±4.3 puntos** es aceptable para evaluación automática de primer nivel.
>
> La temperatura **0.2** garantiza resultados consistentes entre evaluaciones del mismo código.

---

## DIAPOSITIVA 9 — Validación de Hipótesis

**Título:** Validación de las 3 Hipótesis

**Tabla con semáforos:**

| Hipótesis | Mínimo | Obtenido | Estado |
|-----------|--------|----------|--------|
| Precisión en detección de plagio ≥ 80% | 80% | **96.4%** | 🟢 SUPERADA +16.4% |
| Eficiencia superior a herramientas externas | — | **3-5x más rápido** | 🟢 VALIDADA |
| Mejora de experiencia de usuario | — | **SUS: 82.5/100** | 🟢 VALIDADA |

**Mensaje final de la diapositiva:**
> Las **3 hipótesis** fueron validadas con evidencia cuantitativa y cualitativa.

---

# ══════════════════════════════════════════════════════
# SECCIÓN: Código Fuente Desarrollado — Parte 1
# ══════════════════════════════════════════════════════

---

## DIAPOSITIVA 10 — Portada de sección

**Título:** Código Fuente Desarrollado
**Subtítulo:** Parte 1 — Sistema de Detección de Plagio

*[Fondo oscuro con código de fondo semitransparente]*

---

## DIAPOSITIVA 11 — Estructura del Proyecto

**Título:** Organización del Código Fuente

**Árbol de directorios (2 columnas):**

```
moodle-plugin/              42 archivos PHP
├── classes/                Lógica de negocio
│   ├── ai_evaluator.php    Evaluación con GPT
│   ├── plagiarism_detector.php  Orquestador 3 capas
│   ├── plagiarism/         Capas especializadas
│   │   ├── lexical_analyzer.php
│   │   ├── structural_analyzer.php
│   │   ├── semantic_analyzer.php
│   │   └── obfuscation_detector.php
│   ├── submission_versioner.php
│   └── audit_logger.php
├── db/                     Base de datos
│   ├── install.xml         9 tablas
│   └── upgrade.php         Migraciones
└── ast_analyzer.py         AST Python
```

**Métricas del código:**
- 42 archivos PHP · ~6,500 líneas
- 2 archivos Python · ~200 líneas
- 62 tests PHPUnit · 5 archivos
- 9 tablas BD · 20+ índices

---

## DIAPOSITIVA 12 — Fragmento 1: compare_code()

**Título:** Núcleo del Sistema — `compare_code()`
**Subtítulo:** `plagiarism_detector.php`

**Código (fuente monoespaciada, fondo oscuro):**

```php
public static function compare_code($code1, $code2, $nosem = false): array
{
    // CAPA 1: Léxica (35%)
    $lex = self::lexical_similarity($code1, $code2);

    // CAPA 2: Estructural (30%)
    $struct = self::structural_similarity($code1, $code2);

    // CAPA 3: Semántica — omitir si resultado es obvio
    $avg = ($lex['score'] + $struct['score']) / 2;
    $skip = $nosem || $avg > 85 || $avg < 20;

    if ($skip) {
        $final = $lex['score'] * 0.55 + $struct['score'] * 0.45;
    } else {
        $sem   = self::semantic_similarity_ai($code1, $code2);
        $final = $lex['score']    * 0.35
               + $struct['score'] * 0.30
               + $sem['score']    * 0.35;
    }

    // Detectar ofuscación y ajustar score
    $techniques = self::detect_obfuscation_techniques(...);
    return ['final_score' => $final, 'verdict' => ...];
}
```

**Nota al pie:**
> Omitir IA cuando avg >85% o <20% reduce el costo de la API hasta **60%** sin perder precisión.

---

## DIAPOSITIVA 13 — Fragmento 2: Normalización

**Título:** Resistencia al Renombrado de Variables
**Subtítulo:** `lexical_analyzer.php` — `normalize_identifiers()`

**2 columnas — Antes y Después:**

**ANTES (código original del alumno):**
```python
def calc_fact(num):
    if num == 0 or num == 1:
        return 1
    return num * calc_fact(num - 1)
```

**DESPUÉS (normalizado):**
```
def calc_fact(NUM):
    if NUM == NUM or NUM == NUM:
        return NUM
    return NUM * calc_fact(NUM - NUM)
```

**ORIGINAL del profesor (normalizado):**
```
def factorial(NUM):
    if NUM == NUM or NUM == NUM:
        return NUM
    return NUM * factorial(NUM - NUM)
```

**Resultado:** Jaccard = **87.3%** → 🔴 Plagio detectado

---

## DIAPOSITIVA 14 — Fragmento 3: AST Python

**Título:** Análisis de Árbol de Sintaxis Abstracta
**Subtítulo:** `ast_analyzer.py`

**Código Python (fondo oscuro):**

```python
import ast

def extract_features(code: str) -> dict:
    tree = ast.parse(code)  # ← árbol real, no regex
    return {
        'functions':    sum(1 for n in ast.walk(tree)
                           if isinstance(n, ast.FunctionDef)),
        'loops':        sum(1 for n in ast.walk(tree)
                           if isinstance(n, (ast.For, ast.While))),
        'conditionals': sum(1 for n in ast.walk(tree)
                           if isinstance(n, ast.If)),
        'returns':      sum(1 for n in ast.walk(tree)
                           if isinstance(n, ast.Return)),
        'depth':        max_nesting_depth(tree),
    }
```

**Ventaja clave (caja destacada):**
> `ast.parse()` construye el árbol real del código.
> Detecta que `for i in range(n)` y `while n > 0: n -= 1`
> tienen la **misma estructura lógica** aunque el texto sea diferente.

---

## DIAPOSITIVA 15 — Fragmento 4: Detección de Ofuscación

**Título:** Detección de 6 Técnicas de Ofuscación
**Subtítulo:** `obfuscation_detector.php`

**Lista con iconos (2 columnas):**

| Técnica | Cómo se detecta |
|---------|----------------|
| 🔄 Renombrado de variables | Jaccard normalizado alto + Jaccard literal bajo |
| 🔁 Cambio de tipo de bucle | Diferente nº de bucles + estructura similar |
| 🔀 Reordenación de sentencias | Tokens ordenados similares + LCS bajo |
| 💀 Inserción de código muerto | Diferencia de tamaño >30% + similitud alta |
| ➕ Cambio de operadores | i++ ↔ i+=1 ↔ i=i+1 normalizados iguales |
| 💬 Comentarios falsos | Ratio de comentarios inusualmente diferente |

**Efecto:** Cada técnica detectada suma **+5 puntos** al score final.

---

## DIAPOSITIVA 16 — Fragmento 5: Caché Inteligente

**Título:** Optimización — Caché Inteligente
**Subtítulo:** `plagiarism_detector.php`

**Diagrama de flujo:**

```
¿Hay caché guardada?
        │
        ├── NO → Calcular 435 comparaciones → Guardar en caché
        │
        └── SÍ → ¿Hay envíos nuevos desde la caché?
                        │
                        ├── SÍ → Recalcular → Guardar nueva caché
                        │
                        └── NO → Retornar caché ← INSTANTÁNEO ⚡
```

**Código clave:**
```php
// Validar por timestamp, no por TTL fijo
if ($cached && $cached['generated_at'] >= $latest_submission) {
    return $cached; // ← retorno instantáneo
}
```

**Impacto:** De **4 minutos** a **instantáneo** en consultas repetidas.

---

## DIAPOSITIVA 17 — Fragmento 6: Query Consolidada

**Título:** Optimización de Base de Datos
**Subtítulo:** `lib.php` — Dashboard del Profesor

**Antes vs Después:**

**❌ ANTES — 5 queries separadas (~800ms):**
```sql
SELECT COUNT(*) FROM aiassignment WHERE course = ?;
SELECT COUNT(*) FROM submissions WHERE assignment IN (...);
SELECT AVG(score) FROM submissions WHERE ...;
SELECT COUNT(DISTINCT userid) FROM submissions WHERE ...;
SELECT COUNT(*) FROM submissions WHERE status = 'flagged';
```

**✅ DESPUÉS — 1 query consolidada (~187ms):**
```sql
SELECT
    COUNT(DISTINCT a.id)                              AS total_tareas,
    COUNT(s.id)                                       AS total_envios,
    AVG(s.score)                                      AS promedio,
    COUNT(DISTINCT s.userid)                          AS alumnos_activos,
    SUM(CASE WHEN s.status='flagged' THEN 1 ELSE 0 END) AS alertas
FROM aiassignment a
LEFT JOIN submissions s ON s.assignment = a.id
WHERE a.course = ?
```

**Resultado:** Tiempo de carga del dashboard: **800ms → 187ms** (4.3x más rápido)

---

## DIAPOSITIVA 18 — Resumen del Código Desarrollado

**Título:** Resumen — Código Fuente Parte 1

**Tabla de componentes:**

| Componente | Archivo | Líneas | Función |
|-----------|---------|--------|---------|
| Orquestador plagio | `plagiarism_detector.php` | ~860 | Coordina 3 capas |
| Análisis léxico | `lexical_analyzer.php` | ~180 | Jaccard + LCS + Levenshtein |
| Análisis estructural | `structural_analyzer.php` | ~200 | AST + regex por lenguaje |
| Análisis semántico | `semantic_analyzer.php` | ~90 | GPT-4o-mini + rate limiting |
| Detector ofuscación | `obfuscation_detector.php` | ~120 | 6 técnicas |
| Evaluador IA | `ai_evaluator.php` | ~380 | GPT + reintentos + caché |
| AST Python | `ast_analyzer.py` | ~120 | ast.parse() real |

**Mensaje final:**
> **6,500+ líneas** de código PHP + Python que implementan un sistema de detección de plagio
> más avanzado que la mayoría de herramientas académicas disponibles.

---

## NOTAS PARA EL PRESENTADOR

### Preguntas frecuentes del jurado y respuestas:

**P: ¿Por qué 3 capas y no solo una?**
R: Cada capa detecta un tipo diferente de plagio. La léxica detecta renombrado, la estructural detecta cambio de bucles, la semántica detecta reescrituras lógicas. Ninguna por sí sola cubre todos los casos.

**P: ¿Por qué GPT-4o-mini y no un modelo propio?**
R: Entrenar un modelo propio requeriría miles de pares de código etiquetados. GPT-4o-mini con ingeniería de prompts especializada logra 97.8% de precisión en la capa semántica sin ese costo de entrenamiento.

**P: ¿El 100% de precisión no es sospechoso?**
R: Es el resultado del experimento controlado con 30 alumnos. El diseño controlado es la metodología estándar (Gutiérrez, 2026). En producción real con técnicas más sofisticadas, la precisión podría ser menor — por eso la sección de limitaciones lo menciona explícitamente.

**P: ¿Funciona con otros lenguajes además de Python?**
R: Sí. Python tiene AST real. Java, JavaScript, C++ y PHP usan análisis estructural con regex enriquecido. La capa semántica (GPT) funciona con cualquier lenguaje.

**P: ¿Qué pasa si la API de OpenAI falla?**
R: El sistema tiene reintentos automáticos con backoff exponencial. Si falla definitivamente, el envío queda como "pendiente" y el alumno no ve un error — puede re-evaluarse después.
