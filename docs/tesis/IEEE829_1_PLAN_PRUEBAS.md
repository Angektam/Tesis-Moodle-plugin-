# IEEE 829 — Documento 1: Plan de Pruebas
## Plugin mod_aiassignment para Moodle 4.0+

---

**Identificador del documento:** PP-AIASSIGNMENT-2026-001  
**Versión:** 1.0  
**Fecha:** Junio 2026  
**Estado:** Aprobado  
**Autores:** López Payán Kevin Ricardo, Flores Guevara Angel Gabriel  
**Director:** Herman Geovany Ayala Zúñiga  
**Institución:** Universidad Autónoma de Sinaloa — Facultad de Ingeniería Mochis  

---

## Historial de Revisiones

| Versión | Fecha | Autor | Descripción |
|---------|-------|-------|-------------|
| 0.1 | Marzo 2026 | López Payán K.R. | Borrador inicial |
| 0.2 | Abril 2026 | Flores Guevara A.G. | Revisión de alcance y criterios |
| 1.0 | Junio 2026 | López Payán K.R. | Versión final aprobada |

---

## 1. Identificador del Plan de Pruebas

**PP-AIASSIGNMENT-2026-001** — Plan de Pruebas del Sistema de Detección de Plagio y Evaluación Automática con IA para el Plugin mod_aiassignment v2.4.0.

---

## 2. Referencias

| Documento | Identificador |
|-----------|---------------|
| Especificación de Requisitos del Software | ERS-AIASSIGNMENT-2026 |
| Documento de Arquitectura del Sistema | ARQ-AIASSIGNMENT-2026 |
| Manual de Usuario del Plugin | MU-AIASSIGNMENT-2026 |
| IEEE Std 829-2008 — Standard for Software Test Documentation | IEEE 829-2008 |
| IEEE Std 730-2014 — Software Quality Assurance | IEEE 730-2014 |
| Moodle 4.0 Plugin Development Guidelines | MOODLE-DEV-4.0 |
| OpenAI API Reference — GPT-4o-mini | OPENAI-API-2024 |

---

## 3. Introducción

### 3.1 Propósito del Plan

Este Plan de Pruebas define la estrategia, alcance, recursos, cronograma y criterios de aceptación para la verificación y validación del plugin **mod_aiassignment** versión 2.4.0. El plugin implementa un sistema de evaluación automática de código con inteligencia artificial y detección de plagio en tres capas (léxica, estructural y semántica) integrado nativamente en la plataforma Moodle 4.0+.

El plan cubre las pruebas unitarias automatizadas (PHPUnit), las pruebas de integración con la API de OpenAI, el experimento controlado de validación del detector de plagio con 30 alumnos, y la evaluación de usabilidad mediante la escala SUS (System Usability Scale).

### 3.2 Alcance del Sistema Bajo Prueba

El sistema bajo prueba es el plugin **mod_aiassignment** v2.4.0, un módulo de actividad para Moodle que proporciona:

- **Evaluación automática con IA:** Calificación de código Python y otros lenguajes usando OpenAI GPT-4o-mini con retroalimentación detallada en español.
- **Detección de plagio en 3 capas:** Análisis léxico (Jaccard + LCS + Levenshtein), análisis estructural (AST Python + regex), análisis semántico (GPT-4o-mini).
- **Dashboard del profesor:** Panel con estadísticas en tiempo real, gráficas Chart.js, ranking de alumnos y alertas de plagio.
- **Acciones en lote:** Re-evaluación masiva, confirmación/descarte de plagio para múltiples envíos.
- **Versionado de submissions:** Historial completo de cambios por envío.
- **Sistema de auditoría:** Registro de todas las acciones del profesor con IP y timestamp.
- **Encuesta SUS integrada:** Evaluación de usabilidad directamente en la plataforma.

### 3.3 Hipótesis a Validar

| ID | Hipótesis | Criterio de Aceptación |
|----|-----------|----------------------|
| H1 | El sistema detecta plagio con precisión ≥ 80% | Accuracy ≥ 80% en experimento controlado |
| H2 | El sistema es más eficiente que herramientas externas | Flujo completo ≤ tiempo de MOSS/JPlag |
| H3 | La integración en Moodle mejora la experiencia de usuario | Score SUS ≥ 70 puntos |

---

## 4. Elementos de Prueba

Los siguientes componentes del plugin son objeto de prueba:

| ID | Componente | Archivo | Tipo de Prueba |
|----|-----------|---------|----------------|
| IT-001 | Analizador léxico | `classes/plagiarism/lexical_analyzer.php` | Unitaria + Integración |
| IT-002 | Analizador estructural | `classes/plagiarism/structural_analyzer.php` | Unitaria + Integración |
| IT-003 | Analizador semántico | `classes/plagiarism/semantic_analyzer.php` | Integración |
| IT-004 | Detector de ofuscación | `classes/plagiarism/obfuscation_detector.php` | Unitaria |
| IT-005 | Evaluador de IA | `classes/ai_evaluator.php` | Unitaria + Integración |
| IT-006 | Caché de evaluaciones | `classes/eval_cache.php` | Unitaria |
| IT-007 | Módulo de seguridad | `classes/security.php` | Unitaria |
| IT-008 | Detector de plagio (orquestador) | `classes/plagiarism_detector.php` | Integración |
| IT-009 | Analizador AST Python | `ast_analyzer.py` | Unitaria |
| IT-010 | Dashboard del profesor | `dashboard.php` | Sistema |
| IT-011 | Acciones en lote | `bulk_actions.php` | Sistema |
| IT-012 | Encuesta SUS | Tabla `aiassignment_sus_surveys` | Sistema |
| IT-013 | Versionado de submissions | `classes/submission_versioner.php` | Integración |
| IT-014 | Sistema de auditoría | `classes/audit_logger.php` | Integración |

---

## 5. Características a Probar

### 5.1 Funcionalidades Críticas (Prioridad Alta)

- **F-001:** Envío de código por parte del alumno con validación de seguridad
- **F-002:** Evaluación automática con OpenAI GPT-4o-mini
- **F-003:** Detección de plagio por copia directa (score ≥ 75%)
- **F-004:** Detección de plagio con renombrado de variables
- **F-005:** Detección de plagio con cambio de tipo de bucle
- **F-006:** Detección de plagio con inserción de código muerto
- **F-007:** Clasificación correcta de código original (0% falsos positivos)
- **F-008:** Rate limiting para protección de la API de OpenAI

### 5.2 Funcionalidades Importantes (Prioridad Media)

- **F-009:** Carga del dashboard con estadísticas correctas
- **F-010:** Acciones en lote (re-evaluación masiva)
- **F-011:** Versionado automático de submissions
- **F-012:** Registro de auditoría de acciones del profesor
- **F-013:** Encuesta SUS y cálculo del score

### 5.3 Funcionalidades Secundarias (Prioridad Baja)

- **F-014:** Exportación de reportes en CSV/XLSX/PDF
- **F-015:** Notificaciones en tiempo real
- **F-016:** Procesamiento asíncrono de tareas

---

## 6. Características que No Se Probarán

| Característica | Justificación |
|----------------|---------------|
| Infraestructura de Moodle (core) | Fuera del alcance del plugin |
| Rendimiento de la API de OpenAI | Dependencia externa no controlable |
| Compatibilidad con Moodle < 4.0 | Fuera del alcance declarado |
| Pruebas de penetración exhaustivas | Requieren equipo especializado externo |
| Pruebas de carga con > 100 alumnos | Limitación del entorno de prueba en Hostinger |

---

## 7. Enfoque de Pruebas

### 7.1 Estrategia General

Se adopta un enfoque de pruebas en cuatro niveles:

**Nivel 1 — Pruebas Unitarias (PHPUnit):**  
62 tests automatizados que validan las clases core del sistema de forma aislada. Se ejecutan con `vendor/bin/phpunit` en el entorno de desarrollo. Cobertura objetivo: 80% de las clases críticas.

**Nivel 2 — Pruebas de Integración:**  
Validación de la interacción entre componentes: PHP ↔ Python AST, PHP ↔ OpenAI API, Plugin ↔ Base de datos MySQL. Se ejecutan en el entorno de Hostinger con datos reales.

**Nivel 3 — Experimento Controlado de Validación:**  
Experimento con 30 envíos de código Python distribuidos en 5 grupos con niveles de plagio conocidos (ground truth). Mide la precisión del detector de plagio contra el estándar de oro definido por los investigadores.

**Nivel 4 — Evaluación de Usabilidad (SUS):**  
Aplicación de la encuesta System Usability Scale a 6 participantes (1 profesor + 5 alumnos) después de una semana de uso real del sistema.

### 7.2 Técnicas de Prueba

| Técnica | Aplicación |
|---------|-----------|
| Caja blanca (White-box) | Tests unitarios PHPUnit con acceso al código fuente |
| Caja negra (Black-box) | Pruebas de sistema desde la interfaz de Moodle |
| Pruebas de regresión | Ejecución de suite completa tras cada cambio |
| Pruebas de límite | Valores extremos: código vacío, código de 10,000 chars, score 0% y 100% |
| Pruebas de equivalencia | Particiones: plagio directo, sospechoso, original |
| Pruebas de usabilidad | Encuesta SUS con usuarios reales |

### 7.3 Herramientas de Prueba

| Herramienta | Versión | Propósito |
|-------------|---------|-----------|
| PHPUnit | 9.5+ | Tests unitarios automatizados |
| Moodle Test Framework | 4.0+ | Integración con Moodle para tests |
| phpMyAdmin | 5.x | Verificación de datos en BD |
| Postman | 10.x | Pruebas de endpoints AJAX |
| Chrome DevTools | 120+ | Pruebas de interfaz y rendimiento |
| Python 3.8+ | 3.8+ | Ejecución del analizador AST |

---

## 8. Criterios de Éxito y Fracaso

### 8.1 Criterios de Éxito (Entrada a Pruebas)

- El plugin está instalado y activo en Moodle 4.0+ en Hostinger
- La API key de OpenAI está configurada y tiene crédito disponible
- Los 6 usuarios de prueba están creados (maestro01, alumno01-05)
- El curso de prueba tiene al menos una actividad AI Assignment configurada
- El entorno Python 3.8+ está disponible en el servidor

### 8.2 Criterios de Aceptación (Salida de Pruebas)

| Criterio | Umbral Mínimo | Umbral Objetivo |
|----------|--------------|-----------------|
| Precisión del detector de plagio | ≥ 80% | ≥ 95% |
| Tasa de falsos positivos | ≤ 10% | 0% |
| Score SUS promedio | ≥ 70 puntos | ≥ 80 puntos |
| Tests PHPUnit pasando | ≥ 90% (56/62) | 100% (62/62) |
| Tiempo de análisis modo rápido (30 alumnos) | ≤ 60 segundos | ≤ 30 segundos |
| Tiempo de carga del dashboard | ≤ 500 ms | ≤ 200 ms |

### 8.3 Criterios de Suspensión

Las pruebas se suspenderán si:
- La API de OpenAI no responde durante más de 30 minutos
- Se detecta corrupción de datos en la base de datos
- El servidor de Hostinger presenta caídas recurrentes
- Se descubre una vulnerabilidad de seguridad crítica que requiera corrección inmediata

### 8.4 Criterios de Reanudación

Las pruebas se reanudarán cuando:
- El problema que causó la suspensión haya sido resuelto y documentado
- El entorno de prueba haya sido restaurado a un estado conocido
- El director de tesis haya aprobado la reanudación

---

## 9. Entregables de Prueba

| Entregable | Documento IEEE 829 | Responsable | Fecha |
|-----------|-------------------|-------------|-------|
| Plan de Pruebas | Documento 1 (este documento) | López Payán K.R. | Marzo 2026 |
| Especificación de Diseño de Pruebas | Documento 2 | Flores Guevara A.G. | Abril 2026 |
| Especificación de Casos de Prueba | Documento 3 | López Payán K.R. | Abril 2026 |
| Especificación de Procedimientos de Prueba | Documento 4 | Flores Guevara A.G. | Mayo 2026 |
| Reporte de Transmisión de Elementos | Documento 5 | López Payán K.R. | Mayo 2026 |
| Log de Pruebas | Documento 6 | Flores Guevara A.G. | Junio 2026 |
| Reporte de Incidentes | Documento 7 | López Payán K.R. | Junio 2026 |
| Reporte Final de Pruebas | Documento 8 | López Payán K.R. | Junio 2026 |

---

## 10. Tareas de Prueba

| ID | Tarea | Responsable | Duración | Dependencias |
|----|-------|-------------|----------|--------------|
| T-001 | Configurar entorno de prueba en Hostinger | López Payán K.R. | 2 días | — |
| T-002 | Crear usuarios de prueba (maestro01, alumno01-05) | Flores Guevara A.G. | 1 día | T-001 |
| T-003 | Ejecutar suite PHPUnit (62 tests) | López Payán K.R. | 1 día | T-001 |
| T-004 | Preparar 30 envíos del experimento controlado | Flores Guevara A.G. | 3 días | T-002 |
| T-005 | Ejecutar experimento de detección de plagio | López Payán K.R. | 2 días | T-004 |
| T-006 | Aplicar encuesta SUS a participantes | Flores Guevara A.G. | 1 día | T-002 |
| T-007 | Medir tiempos de procesamiento | López Payán K.R. | 1 día | T-005 |
| T-008 | Documentar incidentes encontrados | Flores Guevara A.G. | 2 días | T-003, T-005 |
| T-009 | Elaborar reporte final | López Payán K.R. | 3 días | T-008 |

---

## 11. Necesidades de Entorno

### 11.1 Hardware

| Recurso | Especificación | Proveedor |
|---------|---------------|-----------|
| Servidor web | Hostinger Business Hosting | Hostinger |
| CPU | 2 vCPU | Hostinger |
| RAM | 4 GB | Hostinger |
| Almacenamiento | 100 GB SSD | Hostinger |
| Ancho de banda | 100 Mbps | Hostinger |

### 11.2 Software

| Software | Versión | Propósito |
|----------|---------|-----------|
| Moodle | 4.0+ | Plataforma LMS |
| PHP | 8.1 | Lenguaje del plugin |
| MySQL | 8.0 | Base de datos (prefijo `oy1n_`) |
| Python | 3.8+ | Analizador AST |
| Apache/Nginx | 2.4+ | Servidor web |

### 11.3 Datos de Prueba

| Dato | Descripción |
|------|-------------|
| Usuarios | maestro01 (profesor), alumno01-alumno05 (estudiantes) |
| Curso | "Programación I — Pruebas AI Assignment" |
| Actividad | "Tarea: Algoritmos de Ordenamiento y Factorial" |
| Envíos | 30 envíos de código Python con ground truth conocido |
| API Key | OpenAI GPT-4o-mini con crédito suficiente para 500 llamadas |

---

## 12. Responsabilidades

| Rol | Persona | Responsabilidades |
|-----|---------|-------------------|
| Líder de Pruebas | López Payán Kevin Ricardo | Coordinación general, ejecución de PHPUnit, reporte final |
| Tester | Flores Guevara Angel Gabriel | Preparación de datos, pruebas de sistema, encuesta SUS |
| Director | Herman Geovany Ayala Zúñiga | Revisión y aprobación de documentos |
| Profesor participante | Yobani Martínez Ramírez | Participante en encuesta SUS, validación de resultados |
| Alumnos participantes | alumno01-alumno05 | Participantes en encuesta SUS y experimento |

---

## 13. Cronograma

| Fase | Actividad | Inicio | Fin | Estado |
|------|-----------|--------|-----|--------|
| Fase 1 | Preparación del entorno | 01/03/2026 | 07/03/2026 | ✅ Completado |
| Fase 2 | Pruebas unitarias PHPUnit | 08/03/2026 | 15/03/2026 | ✅ Completado |
| Fase 3 | Diseño del experimento | 16/03/2026 | 31/03/2026 | ✅ Completado |
| Fase 4 | Ejecución del experimento | 01/04/2026 | 30/04/2026 | ✅ Completado |
| Fase 5 | Encuesta SUS | 01/05/2026 | 15/05/2026 | ✅ Completado |
| Fase 6 | Análisis de resultados | 16/05/2026 | 31/05/2026 | ✅ Completado |
| Fase 7 | Documentación IEEE 829 | 01/06/2026 | 30/06/2026 | ✅ Completado |

---

## 14. Riesgos y Contingencias

| ID | Riesgo | Probabilidad | Impacto | Mitigación |
|----|--------|-------------|---------|-----------|
| R-001 | Indisponibilidad de la API de OpenAI | Media | Alto | Usar modo demo para pruebas que no requieran IA real |
| R-002 | Caída del servidor Hostinger | Baja | Alto | Respaldo local con XAMPP + Moodle |
| R-003 | Participantes no disponibles para SUS | Media | Medio | Programar sesiones con anticipación, tener participantes de respaldo |
| R-004 | Resultados del experimento por debajo del umbral | Baja | Alto | Ajustar pesos de las capas y umbral de detección |
| R-005 | Incompatibilidad de versiones PHP/Moodle | Baja | Medio | Probar en entorno local antes de subir a Hostinger |

---

## 15. Aprobaciones

| Rol | Nombre | Firma | Fecha |
|-----|--------|-------|-------|
| Autor | López Payán Kevin Ricardo | _________________ | Junio 2026 |
| Co-autor | Flores Guevara Angel Gabriel | _________________ | Junio 2026 |
| Director | Herman Geovany Ayala Zúñiga | _________________ | Junio 2026 |

---

*Documento elaborado conforme al estándar IEEE 829-2008 — Standard for Software and System Test Documentation.*  
*Universidad Autónoma de Sinaloa — Facultad de Ingeniería Mochis — 2026*
