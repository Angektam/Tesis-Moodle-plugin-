# Documento 6 — Log de Pruebas (IEEE 829)
# AI Assignment Plugin v2.5.0

---

## 1. Identificador
**ID:** LG-AIASSIGNMENT-2026-01
**Fecha de ejecución:** Mayo 2026
**Tester:** Kevin Ricardo López Payán / Angel Gabriel Flores Guevara

---

## 2. Registro de Ejecución de Casos de Prueba

| ID Caso | Descripción | Fecha | Tester | Resultado | Incidente |
|---------|-------------|-------|--------|-----------|-----------|
| CP-01 | Evaluación código correcto modo demo | 06/05/2026 | Kevin | ✅ PASS | — |
| CP-02 | Evaluación código vacío | 06/05/2026 | Kevin | ✅ PASS | — |
| CP-03 | Detección XSS en código | 06/05/2026 | Kevin | ✅ PASS | — |
| CP-04 | Similitud léxica código idéntico | 06/05/2026 | Angel | ✅ PASS | — |
| CP-05 | Similitud léxica renombrado variables | 06/05/2026 | Angel | ✅ PASS | — |
| CP-06 | Similitud léxica código diferente | 06/05/2026 | Angel | ✅ PASS | — |
| CP-07 | Detección renombrado variables | 07/05/2026 | Kevin | ✅ PASS | — |
| CP-08 | Detección código muerto | 07/05/2026 | Kevin | ✅ PASS | — |
| CP-09 | AST Python misma estructura | 07/05/2026 | Angel | ✅ PASS | — |
| CP-10 | AST Python código con error sintaxis | 07/05/2026 | Angel | ✅ PASS | — |
| CP-11 | Caché de evaluaciones | 08/05/2026 | Kevin | ✅ PASS | — |
| CP-12 | Rate limiting OpenAI | 08/05/2026 | Kevin | ✅ PASS | — |
| CP-13 | Rendimiento 30 alumnos modo rápido | 08/05/2026 | Angel | ✅ PASS | — |
| CP-14 | Precisión global detector plagio | 08/05/2026 | Ambos | ✅ PASS | — |
| CP-15 | Usabilidad Score SUS | 10/05/2026 | Ambos | ✅ PASS | — |

---

## 3. Resultados Detallados

### Sesión 1 — 06/05/2026 (Pruebas unitarias)

**Inicio:** 09:00 | **Fin:** 11:30 | **Duración:** 2.5 horas

**Comando ejecutado:**
```bash
vendor/bin/phpunit mod/aiassignment/tests/
```

**Resultado:**
```
PHPUnit 9.5.0

security_test .............. 12 tests, 12 assertions
ai_evaluator_test .......... 13 tests, 13 assertions
plagiarism_lexical_test .... 16 tests, 16 assertions
plagiarism_structural_test . 14 tests, 14 assertions
obfuscation_detector_test ..  7 tests,  7 assertions

Time: 4.82 seconds
OK (62 tests, 62 assertions)
```

**Observaciones:** Todos los tests pasaron. Tiempo total 4.82 segundos.

---

### Sesión 2 — 08/05/2026 (Experimento 30 alumnos)

**Inicio:** 10:00 | **Fin:** 10:35 | **Duración:** 35 minutos

**Datos cargados:** 30 alumnos, 30 envíos, 30 evaluaciones

**Análisis de plagio ejecutado:**
- Modo: Rápido (sin IA)
- Tiempo: **18.4 segundos**
- Comparaciones: 435
- Pares sospechosos: 20 (grupos A, B, D)
- Similitud máxima: 91.0%

**Verificación de precisión:**

| Grupo | Alumnos | Veredicto esperado | Veredicto sistema | Correcto |
|-------|---------|-------------------|-------------------|----------|
| A (est01-08) | 8 | Plagio | Plagio | ✅ 7/7 |
| B (est09-14) | 6 | Plagio | Plagio | ✅ 5/5 |
| C (est15-18) | 4 | Sospechoso/Original | Sospechoso/Original | ✅ 4/4 |
| D (est19-22) | 4 | Plagio | Plagio | ✅ 4/4 |
| E (est23-30) | 8 | Original | Original | ✅ 8/8 |

**Precisión total: 28/28 = 100%**

---

### Sesión 3 — 10/05/2026 (Encuesta SUS)

**Participantes:** 6 (1 profesor + 5 alumnos)

| Participante | Rol | Score SUS |
|-------------|-----|-----------|
| Yobani Martínez | Profesor | 82.5 |
| Kevin López (alumno01) | Alumno | 85.0 |
| Angel Flores (alumno02) | Alumno | 80.0 |
| María García (alumno03) | Alumno | 77.5 |
| Carlos Hernández (alumno04) | Alumno | 82.5 |
| Sofía Ramírez (alumno05) | Alumno | 87.5 |
| **Promedio** | | **82.5** |

**Clasificación:** Bueno (grado B) — percentil 85

---

## 4. Resumen de la Sesión

| Métrica | Valor |
|---------|-------|
| Total casos ejecutados | 15 |
| Casos PASS | 15 |
| Casos FAIL | 0 |
| Incidentes reportados | 0 |
| Cobertura de pruebas | 100% de casos planificados |
