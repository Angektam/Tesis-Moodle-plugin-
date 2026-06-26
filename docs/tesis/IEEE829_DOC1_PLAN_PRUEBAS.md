# Documento 1 — Plan de Pruebas (IEEE 829)
# AI Assignment Plugin v2.5.0 — mod_aiassignment

---

## 1. Identificador del Plan de Pruebas
**ID:** PP-AIASSIGNMENT-2026-01
**Versión:** 1.0
**Fecha:** Mayo 2026
**Estado:** Aprobado

---

## 2. Introducción

Este documento describe el plan de pruebas para el plugin AI Assignment, un módulo de actividad para Moodle que evalúa automáticamente tareas de programación mediante inteligencia artificial y detecta plagio en código fuente usando análisis en tres capas: léxica, estructural y semántica.

El plan sigue el estándar IEEE 829-2008 para documentación de pruebas de software.

---

## 3. Ítems a Probar

| ID | Componente | Versión |
|----|-----------|---------|
| IT-01 | Módulo de evaluación automática (ai_evaluator.php) | 2.5.0 |
| IT-02 | Detector de plagio 3 capas (plagiarism_detector.php) | 2.5.0 |
| IT-03 | Analizador léxico (lexical_analyzer.php) | 2.5.0 |
| IT-04 | Analizador estructural AST Python (ast_analyzer.py) | 2.5.0 |
| IT-05 | Analizador semántico OpenAI (semantic_analyzer.php) | 2.5.0 |
| IT-06 | Detector de ofuscación (obfuscation_detector.php) | 2.5.0 |
| IT-07 | Dashboard del profesor (dashboard.php) | 2.5.0 |
| IT-08 | Formulario de envío del alumno (submit.php) | 2.5.0 |
| IT-09 | Reporte de plagio AJAX (plagiarism_report.php) | 2.5.0 |
| IT-10 | Sistema de seguridad (security.php) | 2.5.0 |
| IT-11 | Caché de evaluaciones (eval_cache.php) | 2.5.0 |
| IT-12 | Tarea asíncrona de evaluación (evaluate_submission.php) | 2.5.0 |
| IT-13 | Encuesta SUS (sus_survey.php) | 2.5.0 |
| IT-14 | Acciones en lote (bulk_actions.php) | 2.5.0 |

---

## 4. Características a Probar

| ID | Característica | Prioridad |
|----|---------------|-----------|
| CF-01 | Evaluación automática de código con OpenAI GPT-4o-mini | Alta |
| CF-02 | Detección de plagio en 3 capas (léxica + estructural + semántica) | Alta |
| CF-03 | Detección de 6 técnicas de ofuscación | Alta |
| CF-04 | Análisis AST real para código Python | Alta |
| CF-05 | Caché inteligente de evaluaciones y reportes | Media |
| CF-06 | Procesamiento asíncrono de evaluaciones | Media |
| CF-07 | Dashboard con estadísticas y gráficas | Media |
| CF-08 | Validación y sanitización de entradas (seguridad) | Alta |
| CF-09 | Rate limiting para llamadas a OpenAI | Media |
| CF-10 | Acciones en lote sobre submissions | Baja |
| CF-11 | Encuesta de usabilidad SUS | Baja |
| CF-12 | Notificaciones en tiempo real | Baja |

---

## 5. Características que NO se van a Probar

| Característica | Razón |
|---------------|-------|
| Integración con Turnitin/Copyleaks | No implementado en esta versión |
| Análisis AST para Java, JavaScript, C++ | Solo Python tiene AST real; otros usan regex |
| Pruebas de carga con >500 alumnos | Fuera del alcance del prototipo de tesis |
| Compatibilidad con Moodle < 4.0 | Requisito mínimo establecido en version.php |
| Pruebas de penetración (pentesting) | Requiere entorno especializado |

---

## 6. Enfoque de Pruebas

### 6.1 Estrategia General

Se aplicará una combinación de pruebas unitarias, de integración y de sistema:

- **Pruebas unitarias:** Validar cada clase y método de forma aislada usando PHPUnit. Se ejecutan sobre las clases core: `ai_evaluator`, `plagiarism_detector`, `lexical_analyzer`, `structural_analyzer`, `obfuscation_detector` y `security`.

- **Pruebas de integración:** Validar el flujo completo de envío → evaluación → almacenamiento → notificación. Se usan datos de prueba controlados en la base de datos.

- **Pruebas de sistema:** Validar el comportamiento del plugin instalado en Moodle con usuarios reales (maestro Yobani + 5 alumnos) en el entorno de Hostinger.

- **Pruebas de rendimiento:** Medir tiempos de respuesta con 30 alumnos (experimento controlado) y 150 alumnos (prueba de estrés).

- **Pruebas de usabilidad:** Aplicar la encuesta SUS a 6 participantes (1 profesor + 5 alumnos).

### 6.2 Criterios de Éxito

| Métrica | Umbral mínimo |
|---------|--------------|
| Precisión de detección de plagio | ≥ 80% |
| Tasa de falsos positivos | ≤ 10% |
| Tiempo de análisis modo rápido (30 alumnos) | ≤ 60 segundos |
| Score SUS de usabilidad | ≥ 70 puntos |
| Cobertura de pruebas unitarias | ≥ 70% de las clases core |

---

## 7. Criterios de Entrada y Salida

### Criterios de Entrada (para iniciar las pruebas)
- Plugin instalado correctamente en Moodle 4.0+
- Base de datos con tablas creadas (install.xml ejecutado)
- API Key de OpenAI configurada o modo demo activado
- Usuarios de prueba creados (maestro01, alumno01-05)
- Script de datos de prueba ejecutado (inscribir-30-alumnos.sql)

### Criterios de Salida (para finalizar las pruebas)
- Todos los casos de prueba de prioridad Alta ejecutados
- Precisión de detección ≥ 80% validada
- Score SUS ≥ 70 obtenido
- Incidentes críticos resueltos
- Reporte de pruebas generado

---

## 8. Tareas de Prueba

| ID | Tarea | Responsable | Duración |
|----|-------|-------------|----------|
| TP-01 | Configurar entorno de pruebas | Kevin López | 1 día |
| TP-02 | Ejecutar pruebas unitarias PHPUnit | Angel Flores | 2 días |
| TP-03 | Ejecutar experimento controlado 30 alumnos | Kevin López | 1 día |
| TP-04 | Ejecutar prueba de estrés 150 alumnos | Angel Flores | 1 día |
| TP-05 | Aplicar encuesta SUS | Ambos | 1 día |
| TP-06 | Documentar resultados e incidentes | Ambos | 1 día |
| TP-07 | Generar reporte final | Kevin López | 1 día |

---

## 9. Requerimientos de Ambiente

| Componente | Especificación |
|-----------|---------------|
| Servidor | Hostinger — PHP 8.1, MySQL 8.0 |
| Moodle | Versión 4.4 (Build 20240422) |
| Python | 3.8+ (para análisis AST) |
| OpenAI API | GPT-4o-mini, temperatura 0.2 |
| Navegador | Chrome 120+, Firefox 120+ |
| Base de datos | MySQL con prefijo oy1n_ |
| Datos de prueba | 30 alumnos con plagio conocido (inscribir-30-alumnos.sql) |

---

## 10. Responsabilidades

| Rol | Persona | Responsabilidad |
|-----|---------|----------------|
| Tester principal | Kevin Ricardo López Payán | Pruebas unitarias, experimento controlado |
| Tester secundario | Angel Gabriel Flores Guevara | Pruebas de integración, encuesta SUS |
| Director | Herman Geovany Ayala Zúñiga | Revisión y aprobación del plan |
| Codirector | Dr. Yobani Martínez Ramírez | Validación de resultados |

---

## 11. Planificación

| Actividad | Fecha inicio | Fecha fin |
|-----------|-------------|-----------|
| Preparación del entorno | 01/05/2026 | 02/05/2026 |
| Pruebas unitarias | 03/05/2026 | 05/05/2026 |
| Experimento 30 alumnos | 06/05/2026 | 07/05/2026 |
| Prueba de estrés 150 alumnos | 08/05/2026 | 08/05/2026 |
| Encuesta SUS | 09/05/2026 | 10/05/2026 |
| Análisis de resultados | 11/05/2026 | 12/05/2026 |
| Reporte final | 13/05/2026 | 14/05/2026 |

---

## 12. Riesgos y Contingencias

| Riesgo | Probabilidad | Impacto | Contingencia |
|--------|-------------|---------|-------------|
| API de OpenAI no disponible | Media | Alto | Usar modo demo para pruebas sin API |
| Timeout en análisis de plagio con muchos alumnos | Alta | Medio | Usar modo rápido (sin IA) |
| Python no disponible en Hostinger | Alta | Medio | El sistema usa fallback con regex |
| Límite de cuota de OpenAI agotado | Media | Alto | Configurar rate limiting (100 llamadas/hora) |
| Error en instalación del plugin | Baja | Alto | Subir archivos manualmente por File Browser |

---

## 13. Aprobación

| Rol | Nombre | Firma | Fecha |
|-----|--------|-------|-------|
| Director de tesis | Herman Geovany Ayala Zúñiga | __________ | ___/___/2026 |
| Codirector | Dr. Yobani Martínez Ramírez | __________ | ___/___/2026 |
| Autor 1 | Kevin Ricardo López Payán | __________ | ___/___/2026 |
| Autor 2 | Angel Gabriel Flores Guevara | __________ | ___/___/2026 |
