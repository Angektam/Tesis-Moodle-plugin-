# Avance 1 — Introducción y Planteamiento del Problema

| Campo | Detalle |
|---|---|
| **Número de Avance** | 1 de 10 |
| **Título** | Introducción y Planteamiento del Problema |
| **Fecha** | Septiembre 2026 |
| **Universidad** | Universidad Autónoma de Sinaloa — Facultad de Informática Mazatlán (FIM) |
| **Autor** | Ángel Flores |
| **Versión del Plugin** | v2.5.1 |

---

## 1. Contexto General

El crecimiento acelerado de la educación en línea durante la última década ha transformado radicalmente la forma en que se imparten y evalúan los cursos de programación en universidades y tecnológicos. Plataformas de gestión del aprendizaje (LMS, por sus siglas en inglés) como Moodle se han consolidado como el estándar en gran parte de América Latina, incluyendo las instituciones de educación superior en el estado de Sinaloa. Sin embargo, este desplazamiento hacia los entornos virtuales ha traído consigo una problemática que los docentes de programación enfrentan de forma cotidiana: la práctica del plagio de código fuente entre estudiantes.

El plagio en programación difiere sustancialmente del plagio de texto convencional. Un estudiante puede renombrar variables, reorganizar bloques de código, añadir comentarios irrelevantes o cambiar el orden de las instrucciones para burlar revisiones superficiales, mientras la lógica algorítmica subyacente permanece idéntica. Este fenómeno, conocido como ofuscación intencional de código, invalida los métodos de detección basados únicamente en comparación literal de cadenas de texto.

En el contexto de la Facultad de Informática Mazatlán (FIM) de la Universidad Autónoma de Sinaloa, los docentes de asignaturas como Programación Orientada a Objetos, Estructura de Datos, Algoritmos y Programación Web reportan que entre el 20% y el 40% de las entregas en entornos de evaluación en línea presentan similitudes sospechosas que no pueden verificarse de forma eficiente con las herramientas actualmente disponibles en la plataforma Moodle institucional.

---

## 2. Planteamiento del Problema

Moodle, en su versión estándar, no ofrece ningún mecanismo nativo para la evaluación automática de código fuente ni para la detección de plagio entre entregas de programación. Los plugins existentes en el mercado (MOSS de Stanford, JPlag, Copyleaks) presentan limitaciones críticas para el contexto académico institucional:

- **MOSS (Measure Of Software Similarity)**: Herramienta externa desarrollada por Stanford University que requiere subir los archivos a servidores externos mediante línea de comandos. No tiene integración directa con Moodle, no genera reportes visuales dentro de la plataforma, y los resultados pueden tardar horas en entornos de alta demanda.
- **JPlag**: Sistema de detección de plagio académico que opera de forma independiente y tampoco cuenta con integración nativa en Moodle 4.x. Requiere instalación separada y exportación manual de archivos.
- **Copyleaks**: Ofrece una API comercial con costos variables por volumen de uso, lo que representa una barrera económica para instituciones públicas como la UAS.

El problema central se formula de la siguiente manera:

> **¿Es posible desarrollar un plugin para Moodle 4.0+ que integre detección automática de plagio multicapa e inteligencia artificial para la evaluación de código fuente, superando las limitaciones de las herramientas externas existentes en precisión, usabilidad y costo para contextos educativos universitarios en México?**

Esta problemática abarca tres dimensiones:

1. **Técnica**: La ausencia de un sistema integrado en Moodle que analice similitudes léxicas, estructurales y semánticas del código fuente de forma simultánea.
2. **Pedagógica**: La falta de retroalimentación automatizada de calidad que guíe al estudiante hacia la corrección de errores sin necesidad de intervención inmediata del docente.
3. **Administrativa**: La inexistencia de reportes consolidados que permitan al docente visualizar en tiempo real el estado de las entregas, detectar patrones de plagio y exportar evidencias para procedimientos académicos formales.

---

## 3. Justificación

La necesidad de desarrollar el plugin `mod_aiassignment` para Moodle se sustenta en múltiples argumentos:

**Desde la perspectiva institucional**, la Universidad Autónoma de Sinaloa ha invertido recursos significativos en infraestructura Moodle. Desarrollar un plugin que se integre nativamente en esta plataforma aprovecha dicha inversión sin requerir licencias adicionales ni infraestructura externa.

**Desde la perspectiva tecnológica**, la disponibilidad de modelos de lenguaje de gran escala como OpenAI GPT-4o-mini, con costos operativos de aproximadamente $0.15 USD por millón de tokens de entrada, hace técnica y económicamente viable la evaluación semántica de código a escala universitaria. Un grupo escolar promedio de 30 estudiantes genera un costo de evaluación inferior a $0.05 USD por tarea.

**Desde la perspectiva académica**, la integridad académica es un pilar de la formación universitaria. Contar con evidencias objetivas y verificables de similitud de código fortalece los procesos de evaluación y reduce la subjetividad en la detección de conductas deshonestas.

**Desde la perspectiva del aprendizaje**, un sistema de retroalimentación automática inmediata ha demostrado en múltiples estudios reducir el tiempo de aprendizaje y mejorar la comprensión de conceptos de programación al permitir ciclos de corrección más rápidos.

---

## 4. Objetivos

### 4.1 Objetivo General

Desarrollar, implementar y validar el plugin `mod_aiassignment` para Moodle 4.0+, un sistema integrado de evaluación automática y detección de plagio de código fuente mediante inteligencia artificial, que permita a los docentes de programación de la FIM-UAS gestionar, evaluar y monitorear las entregas de sus estudiantes con precisión superior al 90% en la detección de similitudes.

### 4.2 Objetivos Específicos

1. **OE-1**: Diseñar e implementar un motor de detección de plagio multicapa que combine análisis léxico (coeficiente de Jaccard sobre bigramas de tokens, con peso del 35%), análisis estructural mediante Abstract Syntax Tree — AST (con peso del 30%), y análisis semántico con OpenAI GPT-4o-mini (con peso del 35%), capaz de detectar al menos 6 técnicas de ofuscación de código.

2. **OE-2**: Integrar el plugin con la API de OpenAI GPT-4o-mini para evaluar automáticamente 6 tipos de problemas académicos (programación, matemáticas, ensayo, SQL, pseudocódigo y depuración), generando retroalimentación estructurada con puntuación de similitud, errores detectados, sugerencias y nivel de confianza en formato JSON.

3. **OE-3**: Desarrollar un dashboard interactivo para el profesor que visualice en tiempo real estadísticas de entrega, distribución de calificaciones, detección de plagio y actividad del grupo mediante 4 gráficas dinámicas con Chart.js, junto con capacidades de exportación de reportes en formatos CSV y PDF.

4. **OE-4**: Implementar funcionalidades avanzadas de seguridad académica, incluyendo modo examen con detección de cambios de pestaña, análisis de comportamiento de tipeo (behavior tracker), validación de lenguaje de programación requerido por tarea y sistema de versionado de entregas.

5. **OE-5**: Validar el sistema mediante un experimento controlado con 30 estudiantes de la FIM-UAS distribuidos en 5 grupos, midiendo precisión de detección de plagio, tiempo de procesamiento y usabilidad con la escala SUS (System Usability Scale).

6. **OE-6**: Documentar el plugin siguiendo los estándares de la comunidad Moodle (PSR-2, Moodle Coding Style) y las pautas de pruebas IEEE 829, generando 62 tests automatizados con PHPUnit que cubran los módulos críticos del sistema.

---

## 5. Hipótesis de Trabajo

**H1 — Precisión de detección**: El sistema de detección de plagio multicapa del plugin `mod_aiassignment`, al combinar análisis léxico, estructural y semántico con pesos ponderados (35%-30%-35%), alcanzará una precisión de exactitud igual o superior al 80% en la identificación correcta de pares de código plagiado y no plagiado en el experimento controlado con 30 estudiantes.

**H2 — Eficiencia comparativa**: El plugin `mod_aiassignment` procesará y entregará reportes de detección de plagio en un tiempo significativamente menor al requerido por herramientas externas como MOSS y JPlag para el mismo conjunto de entregas, debido a su arquitectura integrada en Moodle, sistema de caché inteligente y procesamiento por lotes, reduciendo el tiempo de respuesta al menos en un 50% respecto a dichas herramientas.

**H3 — Experiencia de usuario**: Los docentes de la FIM-UAS que utilicen el plugin `mod_aiassignment` reportarán una puntuación de usabilidad SUS (System Usability Scale) igual o superior a 70 puntos sobre 100, valor que según la literatura especializada corresponde al umbral de "buena usabilidad", evidenciando que la integración nativa en Moodle y el diseño del dashboard facilitan la adopción del sistema sin requerir capacitación técnica especializada.

---

## 6. Alcances

El presente trabajo de tesis comprende los siguientes alcances:

- Desarrollo completo del plugin `mod_aiassignment` versión 2.5.1, incluyendo 42 archivos PHP con aproximadamente 6,500 líneas de código y 9 tablas de base de datos MySQL.
- Soporte de 10 lenguajes de programación: Python, Java, JavaScript, C++, PHP, SQL, TypeScript, Ruby, Go y Rust.
- Integración funcional con Moodle 4.0, 4.1 y 4.3 sobre PHP 8.1+ y MySQL 8.0+.
- Experimento de validación con 30 estudiantes reales de la FIM-UAS en condiciones controladas.
- Documentación técnica completa bajo estándar IEEE 829 y manual de usuario.
- Suite de pruebas automatizadas con 62 tests PHPUnit distribuidos en 5 archivos de prueba.

## 7. Limitaciones

- El análisis AST estructural es nativo y de alta precisión únicamente para Python (mediante `ast.parse()` de la biblioteca estándar). Para otros lenguajes como Java, C++ y JavaScript se emplean heurísticas de extracción de características que, si bien funcionales, no alcanzan el mismo nivel de profundidad de análisis.
- El componente semántico de IA (OpenAI GPT-4o-mini) está sujeto a los límites de la API: 100 llamadas/hora en la configuración por defecto, lo que puede generar colas en grupos con más de 100 estudiantes si el rate limiting no se ajusta a nivel administrativo.
- El plugin requiere conexión a internet para las funcionalidades de IA (OpenAI y Judge0). En modo offline, opera únicamente con las capas léxica y estructural, reduciendo la cobertura del análisis semántico.
- El experimento controlado se realizó con estudiantes de una sola institución (FIM-UAS), por lo que la generalización de los resultados a otros contextos universitarios requiere estudios adicionales.
- La detección de plagio entre código en diferentes lenguajes de programación (por ejemplo, Python y Java que implementan el mismo algoritmo) está fuera del alcance de la versión 2.5.1.

---

*Fin del Avance 1 — Siguiente: Marco Teórico*
