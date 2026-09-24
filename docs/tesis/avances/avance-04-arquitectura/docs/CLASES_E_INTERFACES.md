# Clases del Proyecto

## PHP — namespace `mod_aiassignment`

### `plagiarism_detector`
**Archivo:** `moodle-plugin/classes/plagiarism_detector.php`

Detecta plagio de código fuente usando análisis en 3 capas ponderadas.

| Constante | Valor | Descripción |
|-----------|-------|-------------|
| `THRESHOLD_HIGH` | 75 | Plagio probable |
| `THRESHOLD_MEDIUM` | 50 | Sospechoso |
| `THRESHOLD_LOW` | 30 | Original |
| `WEIGHT_LEXICAL` | 0.35 | Peso capa léxica |
| `WEIGHT_STRUCTURAL` | 0.30 | Peso capa estructural |
| `WEIGHT_SEMANTIC` | 0.35 | Peso capa semántica |

**Métodos públicos:**

| Método | Descripción |
|--------|-------------|
| `detect_plagiarism(int $submissionid): array` | Compara un envío contra todos los demás del mismo assignment |
| `generate_plagiarism_report(int $assignmentid): array` | Genera reporte completo de todos los envíos |
| `compare_code(string $code1, string $code2): array` | Compara dos fragmentos y devuelve score ponderado por capa |

**Métodos privados (núcleo):**

| Método | Capa |
|--------|------|
| `lexical_similarity` | Capa 1: Jaccard de bigramas + LCS sobre tokens normalizados |
| `normalize_identifiers` | Reemplaza VAR/FUNC para resistir renombrado |
| `tokenize` | Divide código en tokens |
| `bigrams` | Genera bigramas de tokens |
| `jaccard` | Índice de Jaccard entre arrays |
| `lcs_ratio` | Longest Common Subsequence normalizado |
| `structural_similarity` | Capa 2: AST Python o regex fallback |
| `is_python` | Detecta si el código es Python |
| `call_python_ast_service` | Llama a `ast_analyzer.py` via `proc_open` |
| `find_python` | Detecta ejecutable Python disponible |
| `extract_structural_features` | Extrae métricas estructurales con regex |
| `semantic_similarity_ai` | Capa 3: Análisis semántico con OpenAI |
| `detect_obfuscation_techniques` | Detecta renombrado, reordenación, código muerto, cambio de bucle |
| `get_verdict` | Devuelve `original` / `sospechoso` / `plagio` |

---

### `ai_evaluator`
**Archivo:** `moodle-plugin/classes/ai_evaluator.php`

Evalúa respuestas de estudiantes comparándolas con la solución del profesor usando OpenAI.

**Métodos públicos:**

| Método | Descripción |
|--------|-------------|
| `evaluate(string $studentanswer, string $teachersolution, string $type): array` | Evalúa una respuesta. Soporta tipos `math` y `programming`. Si `demo_mode` está activo, usa evaluación simulada. |

**Métodos privados:**

| Método | Descripción |
|--------|-------------|
| `demo_evaluate` | Evaluación simulada sin API key |
| `calculate_demo_score` | Score por similitud de longitud y palabras clave |
| `generate_demo_feedback` | Feedback textual según score |
| `generate_demo_analysis` | Análisis detallado simulado |
| `get_system_prompt` | Prompt de sistema según tipo (`math` / `programming`) |
| `get_user_prompt` | Prompt de usuario con ambas soluciones |
| `call_openai_api` | Llamada HTTP a `gpt-4o-mini` con `response_format: json_object` |

**Retorno de `evaluate`:**
```json
{
  "similarity_score": 87.5,
  "feedback": "Muy bien...",
  "analysis": "Análisis detallado..."
}
```

---

### `event\course_module_viewed`
**Archivo:** `moodle-plugin/classes/event/course_module_viewed.php`
**Extiende:** `\core\event\course_module_viewed`

Evento Moodle disparado cuando un usuario visualiza la actividad.

| Propiedad | Valor |
|-----------|-------|
| `objecttable` | `aiassignment` |
| `crud` | `r` (read) |
| `edulevel` | `LEVEL_PARTICIPATING` |

---

### `event\submission_created`
**Archivo:** `moodle-plugin/classes/event/submission_created.php`
**Extiende:** `\core\event\base`

Evento disparado al crear un nuevo envío.

| Propiedad | Valor |
|-----------|-------|
| `objecttable` | `aiassignment_submissions` |
| `crud` | `c` (create) |
| `edulevel` | `LEVEL_PARTICIPATING` |

---

### `event\submission_graded`
**Archivo:** `moodle-plugin/classes/event/submission_graded.php`
**Extiende:** `\core\event\base`

Evento disparado al calificar un envío.

| Propiedad | Valor |
|-----------|-------|
| `objecttable` | `aiassignment_submissions` |
| `crud` | `u` (update) |
| `edulevel` | `LEVEL_TEACHING` |

---

### `privacy\provider`
**Archivo:** `moodle-plugin/classes/privacy/provider.php`

Cumplimiento GDPR. Implementa las interfaces de privacidad de Moodle (`metadata\provider`, `plugin\provider`, `core_userlist_provider`).

**Métodos:**

| Método | Descripción |
|--------|-------------|
| `get_metadata(collection): collection` | Declara tablas y servicios externos que almacenan datos de usuario (`aiassignment_submissions`, `aiassignment_evaluations`, OpenAI) |
| `get_contexts_for_userid(int $userid): contextlist` | Retorna contextos con datos del usuario |
| `get_users_in_context(userlist)` | Lista usuarios con datos en un contexto |
| `export_user_data(approved_contextlist)` | Exporta todos los datos del usuario |
| `delete_data_for_all_users_in_context(context)` | Elimina todos los datos de un contexto |
| `delete_data_for_user(approved_contextlist)` | Elimina datos de un usuario específico |
| `delete_data_for_users(approved_userlist)` | Elimina datos de múltiples usuarios |

---

## Python

### `ASTHandler` (servidor HTTP)
**Archivo:** `demo-standalone/services/python_ast_service.py`
**Extiende:** `BaseHTTPRequestHandler`

Servidor HTTP que expone el comparador AST en `http://localhost:5001`.

| Endpoint | Método | Descripción |
|----------|--------|-------------|
| `/compare` | POST | Recibe `{code1, code2}`, devuelve similitud AST |
| `/health` | GET | Estado del servicio |

> `ast_analyzer.py` no define clases — usa funciones sueltas invocadas por PHP via `proc_open`.

---

## JavaScript

### `ASTComparator`
**Archivo:** `demo-standalone/services/ast_comparator.js`

Compara código fuente usando AST. Soporta JavaScript (acorn), Python (microservicio) y otros lenguajes (análisis estructural).

**Métodos principales:**

| Método | Descripción |
|--------|-------------|
| `compare(code1, code2, language): Promise` | Punto de entrada. Delega según lenguaje |
| `comparePython(code1, code2)` | Llama al microservicio Python en `localhost:5001` |
| `compareJavaScript(code1, code2)` | Parsea con `acorn` y extrae features del AST |
| `compareStructural(code1, code2, language)` | Fallback por tokens y palabras clave |
| `extractFeatures(ast)` | Extrae `nodeTypes`, `functions`, `loops`, `conditionals`, `operators` |
| `calculateSimilarity(f1, f2)` | Score ponderado: estructura 30%, nodeTypes 25%, numérico 20%, operadores 15%, tamaño 10% |

---

### `GitHubService`
**Archivo:** `demo-standalone/services/github_service.js`

Busca código similar en GitHub para detectar plagio externo.

**Métodos:**

| Método | Descripción |
|--------|-------------|
| `searchCode(query, language, maxResults)` | Búsqueda de código en GitHub API |
| `getFileContent(owner, repo, path)` | Obtiene contenido de un archivo (decodifica base64) |
| `detectExternalPlagiarism(code, language, threshold)` | Extrae fragmentos y los busca en GitHub |
| `extractCodeFragments(code, minLength)` | Divide el código en fragmentos significativos (máx. 5) |
| `calculateSimilarityScore(results, totalFragments)` | Ratio de fragmentos encontrados |
| `checkRateLimit()` | Verifica límites de la API de GitHub |
| `searchRepositories(query, maxResults)` | Busca repositorios por query |

---

### `Judge0Service`
**Archivo:** `demo-standalone/services/judge0_service.js`

Ejecuta código en múltiples lenguajes usando Judge0 CE (RapidAPI).

**Lenguajes soportados:** JavaScript, Python, Java, C++, C, C#, PHP, Ruby, Go, Rust, TypeScript, Kotlin, Swift.

**Métodos:**

| Método | Descripción |
|--------|-------------|
| `executeCode(sourceCode, language, stdin, expectedOutput)` | Ejecuta código y retorna resultado |
| `createSubmission(sourceCode, languageId, stdin)` | Crea submission en Judge0 (base64) |
| `getSubmission(token)` | Obtiene resultado por token |
| `waitForResult(token, maxAttempts)` | Polling hasta que el status > 2 |
| `validateOutput(actual, expected)` | Compara output esperado vs real |
| `executeWithTestCases(sourceCode, language, testCases)` | Ejecuta contra múltiples casos de prueba y calcula score |
| `getSupportedLanguages()` | Lista de lenguajes disponibles |

---

### `VirusTotalService`
**Archivo:** `demo-standalone/services/virustotal_service.js`

Escanea archivos, URLs y código contra malware usando VirusTotal API v3.

**Métodos:**

| Método | Descripción |
|--------|-------------|
| `scanFile(filePath)` | Sube y escanea un archivo (máx. 32MB) |
| `scanUrl(url)` | Escanea una URL |
| `getAnalysis(analysisId)` | Obtiene resultado de un análisis |
| `waitForAnalysis(analysisId, maxAttempts)` | Polling hasta `status === 'completed'` |
| `parseAnalysisResult(analysis)` | Extrae stats: `malicious`, `suspicious`, `undetected`, `harmless` |
| `scanCode(code, filename)` | Escanea código como archivo temporal |
| `isFileSafe(filePath, threshold)` | Retorna `{safe, warning?, details}` |
| `getDomainReputation(domain)` | Reputación y categorías de un dominio |
