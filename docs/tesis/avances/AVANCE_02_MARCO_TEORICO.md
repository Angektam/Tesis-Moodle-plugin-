# Avance 2 — Marco Teórico

| Campo | Detalle |
|---|---|
| **Número de Avance** | 2 de 10 |
| **Título** | Marco Teórico |
| **Fecha** | Septiembre 2026 |
| **Universidad** | Universidad Autónoma de Sinaloa — Facultad de Informática Mazatlán (FIM) |
| **Autor** | Ángel Flores |
| **Versión del Plugin** | v2.5.1 |

---

## 1. Inteligencia Artificial Aplicada a la Educación

La inteligencia artificial (IA) en el ámbito educativo ha evolucionado desde sistemas expertos basados en reglas hacia modelos de aprendizaje profundo y procesamiento de lenguaje natural (PLN) capaces de comprender, generar y evaluar texto y código con un nivel de sofisticación sin precedentes. En la literatura se distinguen al menos tres aplicaciones principales de la IA en entornos de aprendizaje:

**Tutoría inteligente (Intelligent Tutoring Systems, ITS)**: Sistemas que modelan el conocimiento del estudiante y adaptan la dificultad de los ejercicios en tiempo real. Ejemplos clásicos incluyen LISP Tutor y Carnegie Learning. En programación, herramientas como Codex de OpenAI han demostrado capacidad para explicar errores de compilación y sugerir correcciones con alta precisión.

**Evaluación automática de código (Automated Code Assessment, ACA)**: Subsistema de IA orientado a calificar soluciones de programación sin intervención humana. Los enfoques actuales se dividen en: (a) evaluación por casos de prueba (Judge0, Codeforces Judge), que verifica la corrección funcional del programa; y (b) evaluación holística mediante LLM, que analiza calidad de código, legibilidad, eficiencia algorítmica y documentación. El plugin `mod_aiassignment` implementa ambos enfoques de forma complementaria.

**Detección de conductas académicas deshonestas**: Uso de algoritmos de similitud y modelos de IA para identificar plagio, uso de herramientas de generación automática de código (como GitHub Copilot) y otros comportamientos contrarios a la integridad académica.

Para este trabajo, el componente central de evaluación automática se sustenta en el modelo **GPT-4o-mini de OpenAI**, lanzado en julio de 2024, que ofrece una ventana de contexto de 128,000 tokens y capacidad multimodal a un costo de $0.15 USD por millón de tokens de entrada. Su rendimiento en benchmarks de comprensión de código (HumanEval: 87.2%) lo posiciona como la opción más costo-eficiente para evaluación académica a escala.

---

## 2. Detección de Plagio en Código Fuente

La detección de plagio en programación se aborda desde tres enfoques principales, cada uno con diferentes niveles de resistencia a las técnicas de ofuscación más comunes:

### 2.1 Métodos Léxicos

El análisis léxico opera sobre la representación más superficial del código: los tokens. Un tokenizador descompone el código fuente en unidades mínimas (identificadores, palabras reservadas, operadores, literales) y elimina elementos no semánticos como comentarios y espacios en blanco. Sobre la secuencia de tokens resultante se aplican métricas de similitud.

La **normalización de identificadores** es un paso previo fundamental: todos los nombres de variables, funciones y clases se sustituyen por un identificador genérico (`VAR_0`, `FUNC_0`, etc.), neutralizando la técnica de ofuscación más común (renombrar variables). En `plagiarism_detector.php`, este proceso se implementa en el método `normalizeIdentifiers()` aplicando expresiones regulares específicas por lenguaje.

El coeficiente de **Jaccard** sobre bigramas de tokens es la métrica primaria de la capa léxica:

```
J(A, B) = |A ∩ B| / |A ∪ B|
```

Donde A y B son los conjuntos de bigramas (pares consecutivos de tokens) de dos fragmentos de código. Un valor de Jaccard ≥ 0.7 indica alta similitud léxica. Esta métrica es resistente a reordenamientos locales y adición de instrucciones, pero vulnerable a refactorizaciones estructurales profundas.

La **Subsecuencia Común Más Larga** (LCS, Longest Common Subsequence) complementa a Jaccard detectando similitudes en fragmentos no contiguos:

```
LCS(X, Y): max k tal que existen i1 < i2 < ... < ik y j1 < j2 < ... < jk
           con X[ia] = Y[ja] para todo a en [1,k]
```

En la implementación actual, LCS se calcula con programación dinámica en O(m×n) donde m y n son las longitudes de las secuencias de tokens.

### 2.2 Métodos Estructurales

El análisis estructural examina la organización del código más allá de su representación textual. La herramienta principal es el **Árbol de Sintaxis Abstracta** (AST, descrito en la sección 3). A partir del AST se extraen métricas estructurales invariantes a cambios superficiales: número y profundidad de funciones, tipos de estructuras de control, patrones de llamadas, complejidad ciclomática y huella de estructura de bloques.

En `ast_analyzer.py`, se computan 12 características estructurales para Python que se representan como un vector de features. La similitud entre dos vectores se calcula con **similitud coseno**:

```
cos(A, B) = (A · B) / (||A|| × ||B||)
```

Donde A·B es el producto punto y ||A|| la norma euclidiana. Esta métrica es robusta ante diferencias de escala (programas de distinto tamaño) y captura similitudes estructurales aunque el texto sea completamente diferente.

### 2.3 Métodos Semánticos con IA

El análisis semántico evalúa el significado y la intención del código. Mediante ingeniería de prompts, se solicita al modelo GPT-4o-mini que analice dos fragmentos de código en paralelo y determine: (a) si implementan el mismo algoritmo, (b) el grado de similitud conceptual, y (c) las diferencias funcionales reales. Este análisis es altamente resistente a la ofuscación estructural profunda pero tiene un costo computacional mayor, por lo que se activa condicionalmente cuando el score combinado de las capas léxica y estructural se encuentra en la zona de incertidumbre (entre 20% y 85%).

---

## 3. AST — Árbol de Sintaxis Abstracta

El **Árbol de Sintaxis Abstracta** es una representación jerárquica del código fuente que captura su estructura lógica sin incluir detalles sintácticos superficiales como paréntesis, punto y coma o comentarios. Cada nodo del árbol representa una construcción del lenguaje: declaración de función, bloque condicional, bucle, expresión aritmética, etc.

Para Python, la biblioteca estándar proporciona `ast.parse()` que genera un AST completo y navegable. El archivo `ast_analyzer.py` del plugin implementa la clase `ASTComparator` que utiliza `ast.walk()` para recorrer el árbol y extraer una representación serializable que se compara entre pares de submissions:

```python
import ast

def extract_ast_features(code: str) -> dict:
    tree = ast.parse(code)
    features = {
        'function_count': 0,
        'loop_types': [],
        'max_depth': 0,
        'node_sequence': []
    }
    for node in ast.walk(tree):
        if isinstance(node, ast.FunctionDef):
            features['function_count'] += 1
        if isinstance(node, (ast.For, ast.While)):
            features['loop_types'].append(type(node).__name__)
        features['node_sequence'].append(type(node).__name__)
    return features
```

El sequence de tipos de nodos (`node_sequence`) es la representación central para la comparación estructural: dos programas con secuencias de nodos AST similares implementan estructuras algorítmicas equivalentes independientemente de los identificadores utilizados.

---

## 4. Algoritmos de Similitud

| Algoritmo | Tipo | Complejidad | Uso en el Plugin | Resistencia a Ofuscación |
|---|---|---|---|---|
| Jaccard sobre bigramas | Léxico | O(n) | Capa 1 — peso 35% | Media |
| LCS (Longest Common Subsequence) | Léxico | O(m×n) | Capa 1 — complemento | Media-Alta |
| Coseno sobre vectores AST | Estructural | O(k) | Capa 2 — peso 30% | Alta |
| Distancia de edición (Levenshtein) | Léxico | O(m×n) | Normalización de tokens | Baja |
| Similitud semántica GPT | Semántico | O(1) API | Capa 3 — peso 35% | Muy Alta |

La **fórmula de score final** implementada en `plagiarism_detector.php` combina las tres capas:

```php
$finalScore = ($lexicalScore * 0.35) + ($structuralScore * 0.30) + ($semanticScore * 0.35);
```

Donde cada score es un valor en el rango [0, 1]. Los umbrales de clasificación son: < 0.40 sin similitud sospechosa, 0.40–0.59 similitud baja, 0.60–0.74 similitud media, 0.75–0.84 similitud alta, ≥ 0.85 plagio muy probable.

---

## 5. Moodle: Arquitectura de Plugins Tipo `mod`

Moodle es el sistema de gestión del aprendizaje de código abierto más utilizado globalmente, con más de 300 millones de usuarios según datos de 2024. Su arquitectura modular define múltiples tipos de plugins; el tipo **`mod`** (módulo de actividad) es el que permite crear nuevos tipos de actividades que los profesores pueden agregar a sus cursos.

Un plugin tipo `mod` sigue una estructura de directorio estricta:

```
mod/aiassignment/
├── version.php          # Metadatos del plugin y versión BD
├── mod_form.php         # Formulario de creación/edición de actividad
├── lib.php              # Funciones requeridas por el API de Moodle
├── view.php             # Página principal de la actividad
├── index.php            # Índice de todas las instancias en un curso
├── db/
│   ├── install.xml      # Esquema inicial de base de datos
│   └── upgrade.php      # Migraciones de versiones anteriores
├── classes/             # Clases PHP con namespace mod_aiassignment
├── lang/es/             # Cadenas de internacionalización
└── amd/src/             # Módulos JavaScript (AMD/RequireJS)
```

La **API de Moodle** expone funciones estándar que todo plugin `mod` debe implementar: `aiassignment_add_instance()`, `aiassignment_update_instance()`, `aiassignment_delete_instance()`, `aiassignment_get_coursemodule_info()`, entre otras. El acceso a la base de datos se realiza exclusivamente mediante el objeto `$DB` global de Moodle, que abstrae las diferencias entre MySQL, PostgreSQL y MariaDB.

---

## 6. OpenAI GPT-4o-mini para Evaluación de Código

GPT-4o-mini es un modelo multimodal de la familia GPT-4 optimizado para eficiencia operativa. Sus características relevantes para este proyecto son:

- **Ventana de contexto**: 128,000 tokens de entrada / 16,384 tokens de salida
- **Soporte de JSON estructurado**: mediante `response_format: { type: "json_object" }` garantiza respuestas parseable sin post-procesamiento
- **Conocimiento de lenguajes de programación**: entrenado en repositorios públicos de GitHub, con fuerte comprensión de Python, Java, JavaScript, C++, PHP y SQL
- **Costo** (2024): $0.15/M tokens entrada, $0.60/M tokens salida

El plugin envía al modelo prompts especializados por tipo de problema. Para evaluación de código de programación, el prompt incluye: el enunciado del problema, el código del estudiante, la rúbrica de evaluación y las instrucciones para generar la respuesta en JSON con los campos `similarity_score`, `feedback`, `errors`, `suggestions` y `confidence_level`.

---

## 7. Trabajos Relacionados

| Herramienta | Institución/Empresa | Método | Integración Moodle | Costo | Limitaciones |
|---|---|---|---|---|---|
| **MOSS** | Stanford University | Fingerprinting (Winnowing) | No nativa (línea de comandos) | Gratuita | Sin UI, sin reporte en LMS, servidores externos |
| **JPlag** | KIT Karlsruhe | Token-based comparison | No nativa | Gratuita (open source) | Instalación separada, sin IA semántica |
| **Copyleaks** | Copyleaks Inc. | NLP + ML | Plugin oficial Moodle (limitado) | Comercial ($) | Costo por documento, privacidad de datos |
| **DOLOS** | Universidad de Gante | Fingerprinting + graph | No nativa | Gratuita (investigación) | Sin evaluación automática |
| **CodeGrade** | CodeGrade B.V. | Ejecución + rúbricas | Integración LTI | Comercial ($$) | Sin detección de plagio multicapa |
| **mod_aiassignment** | UAS-FIM (este trabajo) | Léxico + AST + GPT-4o | Nativa (plugin mod) | Gratuita (open source) | Requiere API key OpenAI |

MOSS utiliza el algoritmo Winnowing para generar huellas digitales (fingerprints) de código mediante k-gramas de tokens, logrando buena resistencia a cambios locales pero sin capacidad semántica. JPlag aplica comparación por tokens con normalización de identificadores similar a la capa léxica de este plugin, pero sin las capas estructural ni semántica. Ninguna de estas herramientas ofrece retroalimentación automática al estudiante, funcionalidad que distingue fundamentalmente a `mod_aiassignment`.

---

## 8. Marco Conceptual — Definiciones Clave

| Término | Definición en el Contexto del Plugin |
|---|---|
| **Plagio de código** | Entrega de código fuente ajeno como propio, con o sin modificaciones superficiales, sin atribución correcta |
| **Ofuscación de código** | Técnica de modificación superficial del código para evitar detección (renombrar variables, refactorizar, insertar código muerto) |
| **Token** | Unidad léxica mínima del código fuente: identificador, palabra reservada, operador, literal numérico o de cadena |
| **AST (Abstract Syntax Tree)** | Representación árbol del código fuente que captura su estructura lógica sin detalles sintácticos |
| **Similitud léxica** | Grado de coincidencia entre dos fragmentos de código a nivel de secuencias de tokens normalizados |
| **Similitud estructural** | Grado de equivalencia entre las estructuras de control, funciones y flujo de dos programas |
| **Similitud semántica** | Grado de equivalencia en el significado y propósito algorítmico de dos fragmentos de código |
| **LLM (Large Language Model)** | Modelo de lenguaje de gran escala entrenado en corpus masivos, capaz de comprensión y generación de texto y código |
| **Rate limiting** | Restricción del número de llamadas a una API en un período de tiempo para controlar el uso y costo |
| **SUS (System Usability Scale)** | Escala estandarizada de 10 ítems para medir la usabilidad percibida de un sistema, con puntuación de 0 a 100 |
| **PHPUnit** | Framework de pruebas unitarias para PHP, adoptado como estándar oficial en el ecosistema Moodle |
| **Plugin mod** | Tipo de plugin Moodle que añade un nuevo tipo de actividad educativa a la plataforma |

---

*Fin del Avance 2 — Siguiente: Metodología de Desarrollo*
