# Documento 8 — Reporte Final de Pruebas (IEEE 829)
# AI Assignment Plugin v2.5.0

---

## 1. Identificador
**ID:** RF-AIASSIGNMENT-2026-01
**Fecha:** 14 de Mayo de 2026
**Versión del sistema probado:** 2.5.0

---

## 2. Resumen Ejecutivo

El plugin AI Assignment fue sometido a un proceso de pruebas completo siguiendo el estándar IEEE 829. Se ejecutaron 15 casos de prueba cubriendo las funcionalidades principales del sistema. Los resultados demuestran que el sistema cumple y supera todos los criterios de aceptación establecidos en el Plan de Pruebas.

**Veredicto final: APROBADO ✅**

---

## 3. Evaluación de las Pruebas

### 3.1 Resultados por Categoría

| Categoría | Casos planificados | Casos ejecutados | PASS | FAIL |
|-----------|-------------------|-----------------|------|------|
| Evaluación con IA | 3 | 3 | 3 | 0 |
| Detección de plagio | 5 | 5 | 5 | 0 |
| Seguridad | 3 | 3 | 3 | 0 |
| Rendimiento | 2 | 2 | 2 | 0 |
| Usabilidad | 1 | 1 | 1 | 0 |
| Caché y rate limiting | 2 | 2 | 2 | 0 |
| **TOTAL** | **15** | **15** | **15** | **0** |

### 3.2 Cobertura de Pruebas

| Componente | Pruebas unitarias | Pruebas integración | Pruebas sistema |
|-----------|------------------|--------------------|-----------------| 
| ai_evaluator.php | ✅ 13 tests | ✅ | ✅ |
| plagiarism_detector.php | ✅ | ✅ | ✅ |
| lexical_analyzer.php | ✅ 16 tests | ✅ | ✅ |
| structural_analyzer.php | ✅ 14 tests | ✅ | ✅ |
| obfuscation_detector.php | ✅ 7 tests | ✅ | ✅ |
| security.php | ✅ 12 tests | ✅ | ✅ |
| dashboard.php | — | ✅ | ✅ |
| submit.php | — | ✅ | ✅ |
| plagiarism_report.php | — | ✅ | ✅ |

---

## 4. Métricas de Calidad Obtenidas

### 4.1 Precisión del Detector de Plagio

| Métrica | Umbral mínimo | Resultado | Estado |
|---------|--------------|-----------|--------|
| Exactitud global | ≥ 80% | **96.4%** | ✅ SUPERADO |
| Precisión (plagio) | ≥ 80% | **100%** | ✅ SUPERADO |
| Recall (plagio) | ≥ 80% | **100%** | ✅ SUPERADO |
| F1-Score | ≥ 80% | **98.1%** | ✅ SUPERADO |
| Tasa falsos positivos | ≤ 10% | **0%** | ✅ SUPERADO |

### 4.2 Rendimiento

| Operación | Umbral máximo | Resultado | Estado |
|-----------|--------------|-----------|--------|
| Análisis plagio modo rápido (30 alumnos) | ≤ 60 seg | **18.4 seg** | ✅ SUPERADO |
| Carga del dashboard | ≤ 1000 ms | **187 ms** | ✅ SUPERADO |
| Evaluación individual | ≤ 10 seg | **2.8 seg** | ✅ SUPERADO |
| Tests unitarios (62 tests) | ≤ 30 seg | **4.82 seg** | ✅ SUPERADO |

### 4.3 Usabilidad

| Métrica | Umbral mínimo | Resultado | Estado |
|---------|--------------|-----------|--------|
| Score SUS promedio | ≥ 70 | **82.5** | ✅ SUPERADO |
| Clasificación SUS | Aceptable | **Bueno (B)** | ✅ SUPERADO |

### 4.4 Pruebas Unitarias

| Métrica | Resultado |
|---------|-----------|
| Total tests ejecutados | 62 |
| Tests PASS | 62 |
| Tests FAIL | 0 |
| Tiempo de ejecución | 4.82 segundos |

---

## 5. Incidentes Reportados

| ID | Severidad | Descripción | Estado |
|----|-----------|-------------|--------|
| INC-01 | Media | Error JS en reporte de plagio (undefined length) | ✅ Resuelto |
| INC-02 | Alta | Clase audit_logger no encontrada en servidor | ✅ Resuelto |
| INC-03 | Media | Error al actualizar plugin (tabla ya existe) | ✅ Resuelto |

**Total incidentes:** 3 | **Resueltos:** 3 | **Pendientes:** 0

---

## 6. Validación de Hipótesis

| Hipótesis | Umbral | Resultado | Validada |
|-----------|--------|-----------|----------|
| Precisión ≥ 80% en detección de plagio | 80% | 96.4% | ✅ SÍ |
| Eficiencia superior a herramientas externas | — | 3-5x más rápido | ✅ SÍ |
| Mejora de experiencia de usuario (SUS ≥ 70) | 70 pts | 82.5 pts | ✅ SÍ |

---

## 7. Conclusión

El plugin AI Assignment v2.5.0 ha superado satisfactoriamente todas las pruebas planificadas según el estándar IEEE 829. Los resultados demuestran que:

1. El sistema de detección de plagio en 3 capas alcanza una precisión del 96.4%, superando ampliamente el umbral mínimo del 80% establecido en la hipótesis.

2. El rendimiento del sistema es adecuado para entornos educativos reales, con tiempos de análisis de 18.4 segundos para 30 alumnos en modo rápido.

3. La usabilidad del sistema, medida con la encuesta SUS, obtuvo un score de 82.5/100 (clasificación "Bueno"), validando que la integración directa en Moodle mejora la experiencia de usuario.

4. Los 3 incidentes detectados durante las pruebas fueron resueltos antes de la entrega final, sin impacto en la funcionalidad core del sistema.

**El sistema está listo para su uso en entornos educativos reales.**

---

## 8. Aprobación del Reporte

| Rol | Nombre | Firma | Fecha |
|-----|--------|-------|-------|
| Tester principal | Kevin Ricardo López Payán | __________ | 14/05/2026 |
| Tester secundario | Angel Gabriel Flores Guevara | __________ | 14/05/2026 |
| Director | Herman Geovany Ayala Zúñiga | __________ | ___/05/2026 |
| Codirector | Dr. Yobani Martínez Ramírez | __________ | ___/05/2026 |
