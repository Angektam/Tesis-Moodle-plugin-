# IEEE 829 — Documento 2: Especificación de Diseño de Pruebas
## Plugin mod_aiassignment para Moodle 4.0+

---

**Identificador del documento:** EDP-AIASSIGNMENT-2026-002  
**Versión:** 1.0  
**Fecha:** Junio 2026  
**Estado:** Aprobado  
**Autores:** López Payán Kevin Ricardo, Flores Guevara Angel Gabriel  
**Director:** Herman Geovany Ayala Zúñiga  
**Institución:** Universidad Autónoma de Sinaloa — Facultad de Ingeniería Mochis  
**Referencia al Plan:** PP-AIASSIGNMENT-2026-001  

---

## 1. Identificador de la Especificación de Diseño

**EDP-AIASSIGNMENT-2026-002** — Especificación de Diseño de Pruebas del Plugin mod_aiassignment v2.4.0.

---

## 2. Características a Probar

Esta especificación cubre el diseño de pruebas para las siguientes características identificadas en el Plan de Pruebas (PP-AIASSIGNMENT-2026-001):

| ID Característica | Descripción | Prioridad |
|-------------------|-------------|-----------|
| F-001 | Envío de código con validación de seguridad | Alta |
| F-002 | Evaluación automática con OpenAI GPT-4o-mini | Alta |
| F-003 | Detección de plagio — copia directa | Alta |
| F-004 | Detección de plagio — renombrado de variables | Alta |
| F-005 | Detección de plagio — cambio de tipo de bucle | Alta |
| F-006 | Detección de plagio — inserción de código muerto | Alta |
| F-007 | Clasificación correcta de código original | Alta |
| F-008 | Carga del dashboard con estadísticas | Media |
| F-009 | Acciones en lote (re-evaluación masiva) | Media |
| F-010 | Encuesta SUS y cálculo del score | Media |
| F-011 | Rate limiting de la API | Alta |
| F-012 | Sanitización de entradas (seguridad) | Alta |

---

## 3. Refinamiento del Enfoque

### 3.1 Diseño del Experimento Controlado

El núcleo del diseño de pruebas es un **experimento controlado** con 30 envíos de código Python organizados en 5 grupos con ground truth conocido. Este diseño permite calcular métricas objetivas de precisión (accuracy, precision, recall, F1-score) del detector de plagio.

**Fundamento metodológico:** El diseño sigue la metodología de Gutiérrez (2026) para evaluación de detectores de plagio académico, que establece que una muestra mínima de 30 casos con distribución balanceada entre plagio directo, sospechoso y original es suficiente para obtener resultados estadísticamente significativos en sistemas de detección de plagio de código fuente.

**Distribución de los 30 envíos:**

```
┌─────────────────────────────────────────────────────────────┐
│              DISEÑO DEL EXPERIMENTO CONTROLADO              │
├──────────┬──────────┬──────────────────────┬────────────────┤
│  Grupo   │ Alumnos  │ Tipo de código       │ Veredicto      │
│          │          │                      │ esperado       │
├──────────┼──────────┼──────────────────────┼────────────────┤
│ Grupo A  │ est01-08 │ Factorial recursivo  │ PLAGIO         │
│          │          │ + renombrado         │ (score ≥ 75%)  │
├──────────┼──────────┼──────────────────────┼────────────────┤
│ Grupo B  │ est09-14 │ Bubble sort          │ PLAGIO         │
│          │          │ + renombrado + swap  │ (score ≥ 75%)  │
├──────────┼──────────┼──────────────────────┼────────────────┤
│ Grupo C  │ est15-18 │ Factorial/sort       │ SOSPECHOSO     │
│          │          │ + cambio de bucle    │ (50-74%)       │
├──────────┼──────────┼──────────────────────┼────────────────┤
│ Grupo D  │ est19-22 │ Factorial            │ PLAGIO         │
│          │          │ + código muerto      │ (score ≥ 75%)  │
├──────────┼──────────┼──────────────────────┼────────────────┤
│ Grupo E  │ est23-30 │ Algoritmos distintos │ ORIGINAL       │
│          │          │ (sin ofuscación)     │ (score < 50%)  │
└──────────┴──────────┴──────────────────────┴────────────────┘
```

### 3.2 Diseño de Pruebas Unitarias PHPUnit

Las pruebas unitarias se organizan en 5 archivos de test que corresponden a las clases críticas del sistema:

| Archivo de Test | Clase Bajo Prueba | Tests | Cobertura |
|-----------------|-------------------|-------|-----------|
| `test_security.php` | `security.php` | 12 | Sanitización, rate limiting, tokens |
| `test_ai_evaluator.php` | `ai_evaluator.php` | 13 | Modo demo, tipos de problemas, caché |
| `test_lexical_analyzer.php` | `lexical_analyzer.php` | 16 | Jaccard, LCS, Levenshtein, normalización |
| `test_structural_analyzer.php` | `structural_analyzer.php` | 14 | Detección de lenguaje, features |
| `test_obfuscation_detector.php` | `obfuscation_detector.php` | 7 | Renombrado, código muerto, operadores |
| **Total** | | **62** | |

### 3.3 Diseño de la Evaluación de Usabilidad

La evaluación de usabilidad utiliza el **System Usability Scale (SUS)** de Brooke (1986), un instrumento validado internacionalmente con 10 ítems en escala Likert de 5 puntos. Se aplica a:

- 1 profesor (maestro01 / Yobani Martínez Ramírez)
- 5 alumnos (alumno01-alumno05)

**Fórmula de cálculo del score SUS:**
```
Score = (Σ ajustes) × 2.5

Donde:
- Ítems impares (1,3,5,7,9): ajuste = valor_marcado - 1
- Ítems pares (2,4,6,8,10): ajuste = 5 - valor_marcado
```

**Escala de interpretación:**
- ≥ 85: Excelente (Grado A)
- 70-84: Bueno (Grado B)
- 50-69: Aceptable (Grado C)
- < 50: Deficiente (Grado D/F)

---

## 4. Identificación de Casos de Prueba

### 4.1 Suite de Pruebas ST-001: Detección de Plagio

| ID Caso | Descripción | Técnica de Diseño |
|---------|-------------|-------------------|
| TC-001 | Envío de código por alumno | Caja negra — flujo normal |
| TC-002 | Evaluación automática con IA | Caja negra — integración API |
| TC-003 | Plagio por copia directa | Caja negra — partición de equivalencia |
| TC-004 | Plagio por renombrado de variables | Caja negra — partición de equivalencia |
| TC-005 | Plagio por cambio de bucle | Caja negra — partición de equivalencia |
| TC-006 | Plagio por inserción de código muerto | Caja negra — partición de equivalencia |
| TC-007 | Código original sin plagio | Caja negra — valor límite |

### 4.2 Suite de Pruebas ST-002: Interfaz y Usabilidad

| ID Caso | Descripción | Técnica de Diseño |
|---------|-------------|-------------------|
| TC-008 | Carga del dashboard con estadísticas | Caja negra — flujo normal |
| TC-009 | Acción en lote: re-evaluación masiva | Caja negra — flujo normal |
| TC-010 | Envío y cálculo de encuesta SUS | Caja negra — flujo normal |

### 4.3 Suite de Pruebas ST-003: Seguridad y Robustez

| ID Caso | Descripción | Técnica de Diseño |
|---------|-------------|-------------------|
| TC-011 | Sanitización de código con XSS | Caja blanca — análisis de código |
| TC-012 | Rate limiting de envíos | Caja blanca — análisis de código |
| TC-013 | Validación de API key de OpenAI | Caja blanca — análisis de código |
| TC-014 | Acceso no autorizado a submission | Caja blanca — análisis de código |

### 4.4 Suite de Pruebas ST-004: Rendimiento

| ID Caso | Descripción | Técnica de Diseño |
|---------|-------------|-------------------|
| TC-015 | Tiempo de análisis modo rápido (30 alumnos) | Medición de rendimiento |
| TC-016 | Tiempo de carga del dashboard | Medición de rendimiento |
| TC-017 | Tiempo de evaluación individual | Medición de rendimiento |

---

## 5. Criterios de Aprobación/Rechazo por Suite

### 5.1 Suite ST-001 — Detección de Plagio

**Criterio de aprobación:**
- Precisión global ≥ 80% (mínimo) / ≥ 95% (objetivo)
- Tasa de falsos positivos ≤ 10% (mínimo) / 0% (objetivo)
- Todos los casos de plagio directo detectados (score ≥ 75%)
- Todos los casos originales clasificados correctamente

**Criterio de rechazo:**
- Precisión global < 80%
- Tasa de falsos positivos > 10%
- Cualquier caso de plagio directo no detectado

### 5.2 Suite ST-002 — Interfaz y Usabilidad

**Criterio de aprobación:**
- Score SUS promedio ≥ 70 puntos
- Dashboard carga correctamente con datos reales
- Acciones en lote ejecutan sin errores

**Criterio de rechazo:**
- Score SUS promedio < 70 puntos
- Dashboard no carga o muestra datos incorrectos

### 5.3 Suite ST-003 — Seguridad

**Criterio de aprobación:**
- 100% de los tests de seguridad PHPUnit pasan
- Ningún vector de ataque XSS/inyección tiene éxito
- Rate limiting funciona correctamente

**Criterio de rechazo:**
- Cualquier vulnerabilidad de seguridad explotable

### 5.4 Suite ST-004 — Rendimiento

**Criterio de aprobación:**
- Análisis modo rápido (30 alumnos) ≤ 60 segundos
- Dashboard carga en ≤ 500 ms
- Evaluación individual ≤ 10 segundos

**Criterio de rechazo:**
- Análisis modo rápido > 120 segundos
- Dashboard no carga en tiempo razonable

---

## 6. Especificación de Datos de Prueba

### 6.1 Código Base del Experimento (Grupo A — Factorial Recursivo)

**Código original (est01):**
```python
def factorial(n):
    if n == 0 or n == 1:
        return 1
    return n * factorial(n - 1)

resultado = factorial(5)
print(resultado)
```

**Variante con renombrado (est02):**
```python
def calcular_factorial(numero):
    if numero == 0 or numero == 1:
        return 1
    return numero * calcular_factorial(numero - 1)

res = calcular_factorial(5)
print(res)
```

**Variante con renombrado agresivo (est04):**
```python
def f(x):
    if x == 0 or x == 1:
        return 1
    return x * f(x - 1)

r = f(5)
print(r)
```

### 6.2 Código Base del Experimento (Grupo B — Bubble Sort)

**Código original (est09):**
```python
def bubble_sort(lista):
    n = len(lista)
    for i in range(n):
        for j in range(0, n-i-1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]
    return lista

numeros = [64, 34, 25, 12, 22, 11, 90]
print(bubble_sort(numeros))
```

**Variante con renombrado (est10):**
```python
def ordenar_burbuja(arreglo):
    tam = len(arreglo)
    for i in range(tam):
        for j in range(0, tam-i-1):
            if arreglo[j] > arreglo[j+1]:
                arreglo[j], arreglo[j+1] = arreglo[j+1], arreglo[j]
    return arreglo

datos = [64, 34, 25, 12, 22, 11, 90]
print(ordenar_burbuja(datos))
```

### 6.3 Código del Experimento (Grupo C — Cambio de Bucle)

**Variante con while (est15):**
```python
def factorial_while(n):
    resultado = 1
    while n > 1:
        resultado *= n
        n -= 1
    return resultado

print(factorial_while(5))
```

**Variante con for (est16):**
```python
def factorial_for(n):
    resultado = 1
    for i in range(2, n + 1):
        resultado *= i
    return resultado

print(factorial_for(5))
```

### 6.4 Código del Experimento (Grupo D — Código Muerto)

**Variante con código muerto (est19):**
```python
def factorial(n):
    # Variable auxiliar innecesaria
    contador = 0
    resultado_temporal = None
    
    if n == 0 or n == 1:
        return 1
    
    # Código muerto: nunca se ejecuta
    if False:
        print("esto nunca pasa")
    
    return n * factorial(n - 1)

x = factorial(5)
print(x)
```

### 6.5 Código del Experimento (Grupo E — Código Original)

**Selection sort (est23):**
```python
def selection_sort(arr):
    n = len(arr)
    for i in range(n):
        min_idx = i
        for j in range(i+1, n):
            if arr[j] < arr[min_idx]:
                min_idx = j
        arr[i], arr[min_idx] = arr[min_idx], arr[i]
    return arr
```

**Memoización (est27):**
```python
from functools import lru_cache

@lru_cache(maxsize=None)
def factorial_memo(n):
    if n <= 1:
        return 1
    return n * factorial_memo(n - 1)
```

---

## 7. Especificación del Entorno de Prueba

### 7.1 Configuración del Servidor

```
Servidor:     Hostinger Business Hosting
URL:          https://[dominio-hostinger]/moodle/
PHP:          8.1.x
MySQL:        8.0.x (prefijo de tablas: oy1n_)
Python:       3.8+ (disponible en servidor)
Moodle:       4.0+ (versión estable)
Plugin:       mod_aiassignment v2.4.0
```

### 7.2 Configuración del Plugin para Pruebas

```
Umbral de detección de plagio:  75%
Modo de análisis por defecto:   Rápido (sin OpenAI)
Rate limit OpenAI:              100 llamadas/hora
Caché de evaluaciones:          Habilitada (TTL 24h)
Modo demo:                      Deshabilitado (usar API real)
```

### 7.3 Usuarios de Prueba

| Usuario | Rol | Contraseña | Propósito |
|---------|-----|-----------|-----------|
| maestro01 | Profesor | Test@2026! | Ejecutar análisis de plagio, ver dashboard |
| alumno01 | Estudiante | Test@2026! | Enviar código, responder SUS |
| alumno02 | Estudiante | Test@2026! | Enviar código, responder SUS |
| alumno03 | Estudiante | Test@2026! | Enviar código, responder SUS |
| alumno04 | Estudiante | Test@2026! | Enviar código, responder SUS |
| alumno05 | Estudiante | Test@2026! | Enviar código, responder SUS |

---

## 8. Procedimientos de Prueba Asociados

| Suite | Procedimiento | Documento |
|-------|--------------|-----------|
| ST-001 | Procedimiento de Detección de Plagio | PP-AIASSIGNMENT-2026-004 §3 |
| ST-002 | Procedimiento de Interfaz y Usabilidad | PP-AIASSIGNMENT-2026-004 §4 |
| ST-003 | Procedimiento de Seguridad PHPUnit | PP-AIASSIGNMENT-2026-004 §2 |
| ST-004 | Procedimiento de Medición de Rendimiento | PP-AIASSIGNMENT-2026-004 §5 |

---

## 9. Trazabilidad de Requisitos

| Requisito | Característica | Caso de Prueba | Suite |
|-----------|---------------|----------------|-------|
| REQ-001: Evaluación automática | F-002 | TC-002 | ST-001 |
| REQ-002: Detección de plagio ≥ 80% | F-003 a F-007 | TC-003 a TC-007 | ST-001 |
| REQ-003: 0% falsos positivos | F-007 | TC-007 | ST-001 |
| REQ-004: Dashboard funcional | F-008 | TC-008 | ST-002 |
| REQ-005: Acciones en lote | F-009 | TC-009 | ST-002 |
| REQ-006: SUS ≥ 70 | F-010 | TC-010 | ST-002 |
| REQ-007: Seguridad XSS | F-012 | TC-011 | ST-003 |
| REQ-008: Rate limiting | F-011 | TC-012 | ST-003 |
| REQ-009: Rendimiento modo rápido | — | TC-015 | ST-004 |

---

*Documento elaborado conforme al estándar IEEE 829-2008.*  
*Universidad Autónoma de Sinaloa — Facultad de Ingeniería Mochis — 2026*
