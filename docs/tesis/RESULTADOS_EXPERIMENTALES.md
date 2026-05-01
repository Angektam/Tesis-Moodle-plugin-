# Resultados Experimentales — AI Assignment Plugin v2.4.0

## Experimento de Validación del Sistema de Detección de Plagio

### Diseño del Experimento

Se diseñó un experimento controlado con 30 envíos de código Python distribuidos en 5 grupos con niveles de plagio conocidos, siguiendo la metodología de Gutiérrez (2026) que utiliza muestras con 10 originales, 10 con modificaciones mínimas y 10 con plagio estructural.

**Tarea evaluada:** Implementación de algoritmos de ordenamiento y cálculo factorial en Python.

**Umbral de detección configurado:** 75% (valor por defecto del sistema).

---

### Grupos de Prueba

| Grupo | Alumnos | Tipo de código | Técnica de ofuscación |
|-------|---------|----------------|----------------------|
| A | est01-est08 | Factorial recursivo | Renombrado de variables/funciones |
| B | est09-est14 | Bubble sort | Renombrado + cambio de swap |
| C | est15-est18 | Factorial/sort variante | Cambio de tipo de bucle (for↔while) |
| D | est19-est22 | Factorial con ruido | Inserción de código muerto |
| E | est23-est30 | Algoritmos distintos | Sin ofuscación (originales) |

---

### Resultados por Grupo

#### Grupo A — Plagio por renombrado (8 alumnos)

| Par comparado | Similitud léxica | Similitud estructural | Score final | Veredicto |
|---------------|------------------|-----------------------|-------------|-----------|
| est01 vs est02 | 87.3% | 91.2% | **91.0%** | 🔴 Plagio |
| est01 vs est03 | 85.1% | 90.8% | **89.4%** | 🔴 Plagio |
| est01 vs est04 | 79.6% | 88.3% | **84.2%** | 🔴 Plagio |
| est01 vs est05 | 82.4% | 89.1% | **86.1%** | 🔴 Plagio |
| est01 vs est06 | 86.7% | 90.5% | **88.9%** | 🔴 Plagio |
| est01 vs est07 | 78.2% | 87.9% | **83.4%** | 🔴 Plagio |
| est01 vs est08 | 83.9% | 89.7% | **87.1%** | 🔴 Plagio |

**Detección:** 7/7 pares detectados correctamente → **100% de precisión**

Técnicas detectadas automáticamente: "Renombrado de variables/funciones" en todos los pares.

---

#### Grupo B — Plagio en bubble sort (6 alumnos)

| Par comparado | Score final | Veredicto |
|---------------|-------------|-----------|
| est09 vs est10 | **88.4%** | 🔴 Plagio |
| est09 vs est11 | **90.1%** | 🔴 Plagio |
| est09 vs est12 | **81.7%** | 🔴 Plagio |
| est09 vs est13 | **80.3%** | 🔴 Plagio |
| est09 vs est14 | **86.2%** | 🔴 Plagio |

**Detección:** 5/5 pares detectados → **100% de precisión**

---

#### Grupo C — Código sospechoso (4 alumnos)

| Par comparado | Score final | Veredicto esperado | Veredicto sistema |
|---------------|-------------|-------------------|-------------------|
| est15 vs est01 | **58.3%** | 🟡 Sospechoso | 🟡 Sospechoso ✅ |
| est16 vs est01 | **55.1%** | 🟡 Sospechoso | 🟡 Sospechoso ✅ |
| est17 vs est09 | **52.4%** | 🟡 Sospechoso | 🟡 Sospechoso ✅ |
| est18 vs est01 | **48.7%** | 🟢 Original | 🟢 Original ✅ |

**Detección:** 4/4 clasificados correctamente → **100% de precisión**

---

#### Grupo D — Código muerto (4 alumnos)

| Par comparado | Score final | Veredicto |
|---------------|-------------|-----------|
| est19 vs est01 | **77.4%** | 🔴 Plagio |
| est20 vs est09 | **76.8%** | 🔴 Plagio |
| est21 vs est01 | **80.2%** | 🔴 Plagio |
| est22 vs est01 | **75.6%** | 🔴 Plagio |

**Detección:** 4/4 detectados → **100% de precisión**

Técnica detectada: "Posible inserción de código muerto o padding" en todos los pares.

---

#### Grupo E — Código original (8 alumnos)

| Alumno | Score máximo vs cualquier otro | Veredicto |
|--------|-------------------------------|-----------|
| est23 (selection sort) | 11.2% | 🟢 Original ✅ |
| est24 (insertion sort) | 9.4% | 🟢 Original ✅ |
| est25 (math.prod) | 14.1% | 🟢 Original ✅ |
| est26 (merge sort) | 7.3% | 🟢 Original ✅ |
| est27 (memoización) | 16.8% | 🟢 Original ✅ |
| est28 (quick sort) | 8.1% | 🟢 Original ✅ |
| est29 (stack) | 13.2% | 🟢 Original ✅ |
| est30 (counting sort) | 10.4% | 🟢 Original ✅ |

**Falsos positivos:** 0/8 → **0% tasa de falsos positivos**

---

### Resumen de Precisión Global

| Métrica | Valor |
|---------|-------|
| Casos de plagio directo detectados | 16/16 (100%) |
| Casos sospechosos clasificados correctamente | 3/4 (75%) |
| Casos originales sin falsos positivos | 8/8 (100%) |
| **Precisión global del sistema** | **27/28 = 96.4%** |
| Falsos positivos | 0 |
| Falsos negativos | 1 (est18 clasificado como original siendo sospechoso) |

> **Conclusión:** El sistema supera la hipótesis planteada del 80% de precisión, alcanzando un 96.4% en el experimento controlado con 30 alumnos.

---

### Tiempos de Procesamiento

| Operación | Tiempo medido | Condición |
|-----------|---------------|-----------|
| Análisis de plagio — Modo Rápido (30 alumnos) | **18.4 segundos** | Sin OpenAI, solo léxico+estructural |
| Análisis de plagio — Modo Completo (30 alumnos) | **4 min 12 seg** | Con OpenAI para pares sospechosos |
| Carga del dashboard (30 alumnos) | **187 ms** | Con índices de BD activos |
| Evaluación individual de un envío | **2.8 segundos** | Con OpenAI GPT-4o-mini |
| Evaluación individual — modo demo | **< 50 ms** | Sin API externa |

**Comparación con herramientas externas:**

| Herramienta | Flujo completo (30 alumnos) | Integración con Moodle |
|-------------|----------------------------|------------------------|
| **AI Assignment (modo rápido)** | **~18 segundos** | ✅ Nativa |
| MOSS (Stanford) | ~5-10 min (subida manual + espera) | ❌ Externa |
| JPlag | ~2-3 min (instalación + ejecución local) | ❌ Externa |
| Copyleaks | ~3-5 min (subida manual) | ❌ Externa (de pago) |

> **Conclusión:** El plugin es significativamente más eficiente en el flujo completo porque elimina los pasos de exportar trabajos, subir a herramienta externa y volver a Moodle. El tiempo de análisis en modo rápido (18 segundos) es comparable o superior a las herramientas externas.

---

### Validación de la Hipótesis

| Hipótesis | Resultado | Estado |
|-----------|-----------|--------|
| Precisión ≥ 80% | 96.4% obtenido | ✅ **VALIDADA** |
| Eficiencia superior a herramientas externas | Flujo 3-5x más rápido por integración nativa | ✅ **VALIDADA** |
| Mejora de experiencia de usuario | Ver resultados encuesta SUS | ✅ **VALIDADA** |
