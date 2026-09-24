# Avance 10 — Conclusiones y Trabajo Futuro

| Campo | Detalle |
|---|---|
| **Número de Avance** | 10 de 10 |
| **Título** | Conclusiones y Trabajo Futuro |
| **Fecha** | Septiembre 2026 |
| **Universidad** | Universidad Autónoma de Sinaloa — Facultad de Informática Mazatlán (FIM) |
| **Autor** | Ángel Flores |
| **Versión del Plugin** | v2.5.1 |

---

## 1. Conclusiones por Objetivo Específico

### OE-1: Motor de Detección de Plagio Multicapa

**Objetivo**: Diseñar e implementar un motor de detección de plagio multicapa que combine análisis léxico (35%), estructural AST (30%) y semántico IA (35%), capaz de detectar al menos 6 técnicas de ofuscación.

**Conclusión**: El objetivo fue alcanzado completamente. El motor implementado en `plagiarism_detector.php` detecta las 6 técnicas de ofuscación planteadas: renombrado de identificadores (neutralizado por la normalización previa a la tokenización), inserción de código muerto (ignorado por el AST), reordenamiento de bloques (detectado por LCS), cambio de tipo de bucle (detectado por la capa semántica), refactorización de funciones (detectado por similitud estructural AST) y sustitución de estructuras de datos (detectado por la capa semántica de GPT-4o-mini). La arquitectura de pesos ponderados con activación condicional del componente semántico demostró ser tanto eficaz (96.4% de exactitud) como eficiente en costos (~$0.02 por análisis de grupo).

### OE-2: Integración con OpenAI GPT-4o-mini para Evaluación Automática

**Objetivo**: Integrar el plugin con OpenAI GPT-4o-mini para evaluar 6 tipos de problemas con retroalimentación estructurada en JSON.

**Conclusión**: La integración con GPT-4o-mini fue implementada exitosamente en `ai_evaluator.php` para los 6 tipos de problemas (programming, math, essay, sql, pseudocode, debugging). El sistema de prompts especializados por tipo, combinado con la respuesta en JSON estricto mediante `response_format: json_object`, garantiza retroalimentación consistente y parseable. El sistema de caché por hash SHA-256 y el rate limiting con ventana deslizante hacen la integración robusta para uso en producción. Las pruebas unitarias con mocks (14 tests en `ai_evaluator_test.php`) y el modo demo sin API garantizan que el plugin funcione incluso sin acceso a OpenAI.

### OE-3: Dashboard Interactivo con Chart.js

**Objetivo**: Desarrollar un dashboard con 5 tarjetas de estadísticas, 4 gráficas Chart.js, y capacidades de exportación en CSV y PDF.

**Conclusión**: El dashboard implementado en `dashboard.php` con módulos AMD supera los requerimientos del objetivo. Las 5 tarjetas de estadísticas (entregas, promedio, plagios, pendientes, tiempo promedio) se actualizan en tiempo real mediante polling AJAX. Las 4 gráficas Chart.js (histograma de calificaciones, actividad temporal, radar de criterios, mapa de calor de plagio) proveen una visión analítica completa del grupo. La exportación CSV es instantánea; la exportación HTML/PDF genera reportes completos con evidencias para procesos académicos formales. En la evaluación SUS, las tarjetas del dashboard recibieron las valoraciones más positivas entre todos los componentes del sistema.

### OE-4: Funcionalidades Avanzadas de Seguridad Académica

**Objetivo**: Implementar modo examen, behavior tracker, validación de lenguaje requerido y versionado de entregas.

**Conclusión**: Todas las funcionalidades de seguridad académica fueron implementadas en la versión 2.5.1. La validación de lenguaje requerido (`required_language`) opera en doble capa (cliente y servidor), siendo resistente a manipulación del DOM. El modo examen con detección de cambios de pestaña y bloqueo de copiar/pegar provee un ambiente más controlado para evaluaciones en línea. El behavior tracker genera datos de contexto valiosos para la interpretación de resultados. El sistema de versionado de submissions preserva el historial completo de entregas de cada estudiante.

### OE-5: Validación con Experimento Controlado

**Objetivo**: Validar el sistema con 30 estudiantes de la FIM-UAS, midiendo precisión de detección, tiempo de procesamiento y SUS.

**Conclusión**: El experimento controlado fue completado con 30 estudiantes distribuidos en 5 grupos (A–E) con condiciones experimentales que cubren los principales escenarios de plagio y similitud legítima. Los resultados (96.4% exactitud, 100% precisión, 42 segundos de procesamiento, SUS 82.5) superaron todas las metas planteadas en las hipótesis de trabajo. El diseño experimental con 5 grupos y 3 problemas de complejidad variable provee un benchmark reproducible que puede ser utilizado en futuras investigaciones sobre detección de plagio en código.

### OE-6: Documentación IEEE 829 y Suite PHPUnit

**Objetivo**: Documentar el plugin bajo IEEE 829 y generar 62 tests PHPUnit.

**Conclusión**: La documentación completa bajo IEEE 829 consta de 8 documentos (Plan de Pruebas, Diseño de Pruebas, Casos de Prueba, Procedimientos, Reporte de Transmisión, Log de Pruebas, Reporte de Incidentes y Reporte Final). Los 62 tests PHPUnit distribuidos en 5 archivos de prueba pasan al 100% en el ambiente Moodle 4.1 con PHP 8.1. El código del plugin sigue los estándares PSR-2 y Moodle Coding Style verificados con las herramientas de análisis estático de Moodle (`moodle-cs`).

---

## 2. Conclusión General

El desarrollo del plugin `mod_aiassignment` versión 2.5.1 para Moodle demuestra que es técnica y económicamente viable construir un sistema integrado de evaluación automática y detección de plagio de código fuente con inteligencia artificial en el contexto de una plataforma LMS de código abierto como Moodle. La combinación de métodos clásicos de análisis de código (tokenización, LCS, análisis AST) con capacidades modernas de inteligencia artificial (GPT-4o-mini) en una arquitectura multicapa ponderada produjo un sistema con una exactitud de 96.4% en detección de plagio, superando en más de 16 puntos porcentuales el umbral mínimo planteado, con cero falsos positivos en el experimento controlado.

La integración nativa en Moodle, la retroalimentación automática al estudiante y el dashboard analítico para el docente convierten al plugin en una herramienta pedagógica activa que no solo detecta conductas deshonestas, sino que apoya el proceso de aprendizaje mediante retroalimentación oportuna y específica. El score SUS de 82.5/100 confirma que el sistema es adoptable por docentes con diferentes niveles de competencia tecnológica, sin requerir capacitación técnica especializada.

---

## 3. Aportaciones al Campo de la IA en Educación

Este trabajo contribuye al campo de la inteligencia artificial aplicada a la educación (AIEd) en los siguientes aspectos:

1. **Evidencia empírica** de la efectividad del enfoque híbrido (métodos clásicos + LLM) para detección de plagio de código, con resultados que superan los métodos puramente basados en tokens o puramente basados en IA.

2. **Metodología de activación condicional** del componente LLM basada en zona de incertidumbre del score combinado, que balancea precisión y costo operativo. Esta metodología es generalizable a otros sistemas híbridos de análisis de similitud.

3. **Marco de evaluación automática** con rúbrica personalizable y 6 tipos de problemas, que puede servir como modelo de referencia para el diseño de sistemas similares en otros LMS (Canvas, Blackboard, Open edX).

4. **Dataset de validación** del experimento controlado (30 estudiantes, 5 grupos, 3 problemas, 75 pares de código con etiquetas ground truth) que puede ser utilizado como benchmark público en futuras investigaciones.

---

## 4. Aportaciones a la Comunidad Moodle

1. **Primer plugin mod para Moodle 4.0+** que combina detección de plagio multicapa con evaluación automática de IA en un único módulo de actividad integrado.

2. **Arquitectura de referencia** para la integración de APIs de LLM (OpenAI, posiblemente otros) en plugins Moodle, incluyendo gestión de API keys, rate limiting, caché, reintentos y modo demo para desarrollo.

3. **Suite de tests PHPUnit** como modelo para pruebas de plugins Moodle con componentes de IA, incluyendo estrategias de mocking de APIs externas.

4. **Componentes reutilizables**: Las clases `PlagiarismDetector`, `AIEvaluator`, `SecurityHelper` y `BehaviorTracker` están diseñadas para ser potencialmente extraídas como plugins independientes o librerías compartidas en la comunidad Moodle.

---

## 5. Recomendaciones para Instituciones que Adopten el Plugin

1. **Configurar el rate limiting** según el tamaño de los grupos: grupos de más de 60 estudiantes requieren aumentar el límite a 200+ llamadas/hora o escalar el plan de OpenAI.

2. **Establecer política institucional de umbrales**: Se recomienda usar el umbral de 75% como estándar para "posible plagio que requiere revisión" y 85% para "plagio probable". Ningún score automático debe ser sancionatorio sin revisión docente.

3. **Mantener modo demo disponible** para que los estudiantes practiquen con el sistema antes de evaluaciones formales, reduciendo la ansiedad tecnológica.

4. **Usar la validación de lenguaje requerido** (`required_language`) en todas las actividades de evaluación formal para prevenir entregas en lenguaje incorrecto.

5. **Revisar manualmente** todos los casos con `confidence < 0.70` en la evaluación IA, ya que el sistema los marca específicamente para evitar calificaciones incorrectas automáticas.

6. **Capacitar brevemente a los docentes** en la interpretación del reporte de plagio: explicar que el score es una señal, no una sentencia, y que el desglose por capas (léxica, estructural, semántica) ayuda a entender el tipo de similitud detectada.

---

## 6. Trabajo Futuro — 8 Mejoras Propuestas

| # | Mejora | Descripción | Impacto esperado | Dificultad |
|---|---|---|---|---|
| 1 | **AST nativo para Java y JavaScript** | Integrar JavaParser (Java) y Babel/acorn (JavaScript) para reemplazar las heurísticas actuales en estos lenguajes | Aumentar precisión estructural en Java y JS del ~75% al ~95% estimado | Alta |
| 2 | **LLM open-source local** | Soporte para Code Llama 70B o Mistral Code ejecutados localmente via Ollama, eliminando dependencia de OpenAI | Costo cero para evaluación semántica, privacidad total de datos | Alta |
| 3 | **Detección de plagio cross-language** | Usar embeddings de código (UniXcoder, CodeBERT) para comparar implementaciones del mismo algoritmo en diferentes lenguajes | Detectar plagio entre Python y Java, por ejemplo | Muy Alta |
| 4 | **Análisis longitudinal de aprendizaje** | Módulo de seguimiento del progreso del estudiante a lo largo del semestre, comparando evolución de errores y mejoras entre submissions | Herramienta de intervención temprana para docentes | Media |
| 5 | **Integración con GitHub Classroom** | Importar automáticamente repositorios de GitHub Classroom como submissions en `mod_aiassignment` | Ampliar el mercado objetivo del plugin a usuarios de GitHub Education | Media |
| 6 | **Evaluación multimodal** | Soporte para evaluación de diagramas UML, diseños de bases de datos y wireframes mediante visión computacional (GPT-4o vision) | Cubrir más tipos de entregables académicos | Alta |
| 7 | **Plugin de Moodle Mobile** | Interfaz nativa en la app Moodle Mobile para ver retroalimentación y entregar código desde dispositivos móviles | Accesibilidad para estudiantes sin computadora de escritorio | Media |
| 8 | **Sistema de apelaciones** | Flujo formal dentro del plugin para que el estudiante conteste un reporte de plagio con evidencia, y el docente resuelva con trazabilidad completa | Proceso justo y documentado para procedimientos académicos formales | Media-Alta |

---

## 7. Reflexión Final del Autor

El desarrollo del plugin `mod_aiassignment` fue un proceso de aprendizaje profundo en múltiples dimensiones simultáneas: la complejidad de construir software de calidad para un ecosistema maduro como Moodle, la fascinación de aplicar modelos de lenguaje de gran escala a un problema pedagógico concreto, y el desafío de diseñar sistemas justos que sirvan al aprendizaje sin convertirse en instrumentos punitivos.

La lección más importante del proyecto es que la tecnología por sí sola no resuelve el problema del plagio académico. Un sistema de detección puede ser extremadamente preciso —como lo demuestra el 96.4% de exactitud con cero falsos positivos— y aun así ser inútil si no está acompañado de una cultura académica que valore la integridad intelectual y que use la tecnología como apoyo pedagógico, no como sustituto de la relación docente-estudiante.

El feedback automático de GPT-4o-mini, cuando está bien diseñado, no reemplaza al profesor: le libera tiempo para lo que realmente importa — explicar conceptos complejos, motivar a los estudiantes que luchan, y reconocer el trabajo original de aquellos que realmente aprenden. Esa es la visión con la que fue construido este plugin, y con la que espero que sea usado.

La inteligencia artificial en educación no debe ser un juez. Debe ser un tutor.

---

| Documento | Estado |
|---|---|
| AVANCE_01_INTRODUCCION_PROBLEMA.md | ✅ Completo |
| AVANCE_02_MARCO_TEORICO.md | ✅ Completo |
| AVANCE_03_METODOLOGIA.md | ✅ Completo |
| AVANCE_04_ARQUITECTURA_SISTEMA.md | ✅ Completo |
| AVANCE_05_IMPLEMENTACION_PLAGIO.md | ✅ Completo |
| AVANCE_06_EVALUACION_IA.md | ✅ Completo |
| AVANCE_07_FUNCIONALIDADES_AVANZADAS.md | ✅ Completo |
| AVANCE_08_PRUEBAS_RESULTADOS.md | ✅ Completo |
| AVANCE_09_VALIDACION_HIPOTESIS.md | ✅ Completo |
| AVANCE_10_CONCLUSIONES.md | ✅ Completo |

---

*Fin del Avance 10 — Fin de la serie de avances de tesis*

*Plugin AI Assignment para Moodle v2.5.1 — Universidad Autónoma de Sinaloa, FIM — Ángel Flores — Septiembre 2026*
