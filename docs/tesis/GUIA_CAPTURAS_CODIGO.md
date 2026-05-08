# Guía de Capturas de Código para PowerPoint
# Qué archivo abrir, qué líneas mostrar y cómo configurar el editor

---

## CONFIGURACIÓN RECOMENDADA DEL EDITOR (VS Code)

Antes de tomar capturas:
1. Tema: **One Dark Pro** o **GitHub Dark** (fondo oscuro, se ve profesional)
2. Fuente: **Fira Code** o **JetBrains Mono** tamaño 16-18px
3. Activar: **View → Appearance → Minimap** → desactivar (más limpio)
4. Activar: **View → Appearance → Breadcrumbs** → desactivar
5. Zoom: Ctrl + para agrandar hasta que el código llene bien la pantalla
6. Ocultar panel lateral: Ctrl+B

---

## CAPTURA 1 — Pesos de las 3 capas (constantes)

**Archivo:** `moodle-plugin/classes/plagiarism_detector.php`
**Líneas:** 24 a 45
**Qué muestra:** Los umbrales y pesos de cada capa

```
Línea 24:  const THRESHOLD_HIGH   = 75;
Línea 25:  const THRESHOLD_MEDIUM = 50;
Línea 26:  const THRESHOLD_LOW    = 30;
Línea 38:  const WEIGHT_LEXICAL    = 0.35;
Línea 40:  const WEIGHT_STRUCTURAL = 0.30;
Línea 41:  const WEIGHT_SEMANTIC   = 0.35;
```

**Título en PowerPoint:** "Pesos y Umbrales del Sistema"

---

## CAPTURA 2 — compare_code() completo

**Archivo:** `moodle-plugin/classes/plagiarism_detector.php`
**Líneas:** 226 a 270
**Qué muestra:** El método principal que orquesta las 3 capas

```
Línea 226: public static function compare_code(...)
Línea 229: // ── Capa 1: Léxica
Línea 230: $lex = self::lexical_similarity($code1, $code2);
Línea 233: // ── Capa 2: Estructural
Línea 234: $struct = self::structural_similarity($code1, $code2);
Línea 237: // ── Capa 3: Semántica (IA)
Línea 239: $lex_struct_avg = ($lex['score'] + $struct['score']) / 2;
Línea 240: $skip_sem = $nosem || $lex_struct_avg > 85 || $lex_struct_avg < 20;
Línea 242: if ($skip_sem) {
Línea 244:     $final = round($lex['score'] * 0.55 + $struct['score'] * 0.45, 2);
Línea 248: } else {
Línea 249:     $sem   = self::semantic_similarity_ai($code1, $code2);
Línea 250:     $final = round(
Línea 251:         $lex['score']    * self::WEIGHT_LEXICAL +
Línea 252:         $struct['score'] * self::WEIGHT_STRUCTURAL +
Línea 253:         $sem['score']    * self::WEIGHT_SEMANTIC, 2);
```

**Título en PowerPoint:** "Núcleo del Sistema — compare_code()"
**Resaltar:** líneas 239-240 (la lógica de omitir IA)

---

## CAPTURA 3 — normalize_identifiers()

**Archivo:** `moodle-plugin/classes/plagiarism/lexical_analyzer.php`
**Líneas:** 53 a 75
**Qué muestra:** Cómo se normalizan los identificadores

```
Línea 53:  public static function normalize_identifiers(string $code): string
Línea 55:  $code = preg_replace('/\/\*[\s\S]*?\*\//', '', $code);  // /* */
Línea 56:  $code = preg_replace('/\/\/[^\n]*/', '', $code);         // //
Línea 57:  $code = preg_replace('/#[^\n]*/', '', $code);            // #
Línea 60:  $code = preg_replace('/"[^"]*"/', '"STR"', $code);
Línea 61:  $code = preg_replace("/'[^']*'/", "'STR'", $code);
Línea 64:  $code = preg_replace('/\b\d+(\.\d+)?\b/', 'NUM', $code);
Línea 67:  $code = preg_replace('/\s+/', ' ', trim($code));
Línea 68:  return $code;
```

**Título en PowerPoint:** "Normalización — Resistencia al Renombrado"

---

## CAPTURA 4 — ast_analyzer.py

**Archivo:** `moodle-plugin/ast_analyzer.py`
**Líneas:** 1 a 50 (aproximadamente)
**Qué muestra:** El análisis AST real con Python

Abre el archivo y muestra la función `extract_features()` con `ast.parse()`.

**Título en PowerPoint:** "Análisis AST Real — Python"
**Resaltar:** la línea con `ast.parse(code)` y los `isinstance(n, ast.FunctionDef)`

---

## CAPTURA 5 — detect_obfuscation_techniques()

**Archivo:** `moodle-plugin/classes/plagiarism_detector.php`
**Líneas:** 736 a 800
**Qué muestra:** La detección de las 6 técnicas de ofuscación

```
Línea 736: private static function detect_obfuscation_techniques(...)
Línea 746: // Renombrado de variables
Línea 747: if ($lex['score'] > 60 && $raw_lex < 40) {
Línea 748:     $techniques[] = 'Renombrado de variables/funciones';
Línea 752: // Cambio de tipo de bucle
Línea 756: if ($loops1 !== $loops2 && $struct['score'] > 55) {
Línea 757:     $techniques[] = 'Cambio de tipo de bucle (for/while/recursión)';
Línea 761: // Reordenación de sentencias
Línea 767: if ($sorted_sim > 0.85 && $lex['lcs'] < 70) {
Línea 768:     $techniques[] = 'Reordenación de sentencias';
Línea 772: // Inserción de código muerto
Línea 776: if ($size_diff > 0.30 && $lex['score'] > 55) {
Línea 777:     $techniques[] = 'Posible inserción de código muerto';
```

**Título en PowerPoint:** "Detección de Técnicas de Ofuscación"

---

## CAPTURA 6 — get_verdict() con boost

**Archivo:** `moodle-plugin/classes/plagiarism_detector.php`
**Líneas:** 849 a 860
**Qué muestra:** Cómo cada técnica suma +5 puntos al score

```
Línea 849: private static function get_verdict(float $score, array $techniques): string
Línea 851: // Si hay técnicas de ofuscación detectadas, subir el nivel de alerta
Línea 852: $boost    = count($techniques) * 5;
Línea 853: $adjusted = min(100, $score + $boost);
Línea 855: if ($adjusted >= self::THRESHOLD_HIGH)   return 'plagio';
Línea 856: if ($adjusted >= self::THRESHOLD_MEDIUM) return 'sospechoso';
Línea 857: return 'original';
```

**Título en PowerPoint:** "Fórmula Final — Boost por Ofuscación"

---

## CAPTURA 7 — Caché inteligente

**Archivo:** `moodle-plugin/classes/plagiarism_detector.php`
**Líneas:** 100 a 130
**Qué muestra:** La validación de caché por timestamp

```
Línea 100: $cache_key = 'plagiarism_report_' . $assignmentid . ($nosem ? '_fast' : '_full');
Línea 101: $cache     = \cache::make('mod_aiassignment', 'plagiarism');
Línea 103: if (!$force) {
Línea 104:     $cached     = $cache->get($cache_key);
Línea 105:     $latest_sub = $DB->get_field_sql(
Línea 106:         "SELECT MAX(timecreated) FROM {aiassignment_submissions} WHERE assignment = :a",
Línea 107:         ['a' => $assignmentid]
Línea 108:     );
Línea 109:     if ($cached && isset($cached['generated_at']) && $cached['generated_at'] >= (int)$latest_sub) {
Línea 110:         $cached['from_cache'] = true;
Línea 111:         return $cached;
Línea 112:     }
```

**Título en PowerPoint:** "Caché Inteligente — Validación por Timestamp"
**Resaltar:** línea 109 (la condición clave)

---

## CAPTURA 8 — Query consolidada del dashboard

**Archivo:** `moodle-plugin/lib.php`
**Buscar:** función `aiassignment_get_course_statistics`
**Qué muestra:** El SUM(CASE WHEN) que reemplaza 5 queries

Busca en el archivo la función y muestra el SELECT con los SUM(CASE WHEN).

**Título en PowerPoint:** "Optimización BD — 5 queries → 1 query"

---

## CAPTURA 9 — Evaluación con OpenAI

**Archivo:** `moodle-plugin/classes/ai_evaluator.php`
**Buscar:** `call_openai_api` o `temperature`
**Líneas:** busca donde dice `'temperature' => 0.2`
**Qué muestra:** La configuración de la llamada a OpenAI

```php
$data = [
    'model'           => $model,
    'messages'        => [...],
    'temperature'     => 0.2,
    'response_format' => ['type' => 'json_object'],
];
```

**Título en PowerPoint:** "Evaluación con GPT-4o-mini"
**Resaltar:** `temperature => 0.2` y `response_format`

---

## CAPTURA 10 — Schema de la BD (install.xml)

**Archivo:** `moodle-plugin/db/install.xml`
**Líneas:** 1 a 60
**Qué muestra:** La definición de las tablas principales

Muestra las primeras tablas del XML con sus campos y claves foráneas.

**Título en PowerPoint:** "Esquema de Base de Datos"

---

## HERRAMIENTAS PARA CAPTURAS MÁS BONITAS

### Opción 1: Carbon (online, gratis)
1. Ve a **carbon.now.sh**
2. Pega el fragmento de código
3. Elige tema: **One Dark** o **Dracula**
4. Fuente: **Fira Code**
5. Descarga como PNG

### Opción 2: Ray.so (online, gratis)
1. Ve a **ray.so**
2. Pega el código
3. Elige color de fondo (azul o morado quedan bien)
4. Descarga como PNG

### Opción 3: VS Code directo
1. Selecciona las líneas
2. Clic derecho → **Copy as Image** (con extensión CodeSnap)
3. O usa la extensión **Polacode**

---

## ORDEN SUGERIDO EN EL POWERPOINT

| # Diapositiva | Captura | Título |
|---------------|---------|--------|
| 1 | Captura 1 | Pesos y umbrales del sistema |
| 2 | Captura 2 | Núcleo — compare_code() |
| 3 | Captura 3 | Normalización de identificadores |
| 4 | Captura 4 | Análisis AST con Python |
| 5 | Captura 5 | Detección de 6 técnicas de ofuscación |
| 6 | Captura 6 | Fórmula final con boost |
| 7 | Captura 7 | Caché inteligente |
| 8 | Captura 8 | Optimización de BD |
| 9 | Captura 9 | Evaluación con GPT-4o-mini |
| 10 | Captura 10 | Esquema de BD |
