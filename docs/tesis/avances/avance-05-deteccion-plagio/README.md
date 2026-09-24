# Avance 5 — Implementación del Sistema de Detección de Plagio

**Plugin:** mod_aiassignment v2.5.1 | **Universidad:** UAS-FIM | **Autor:** Ángel Flores | **Sep 2026**

## Contenido de esta carpeta

```
avance-05-deteccion-plagio/
├── README.md
├── docs/
│   ├── IMPLEMENTACION_PLAGIO.md       ← Documento del avance (3 capas + ofuscación)
│   ├── DETECCION_PLAGIO.md            ← Documentación técnica del sistema
│   ├── COMPARACION_AST.md             ← Cómo funciona la comparación AST
│   ├── FUNCIONALIDAD_PLAGIO.md        ← Funcionalidad completa del sistema
│   └── DETECCION_PLAGIO_AUTOMATICA.md ← Detección automática y ofuscación
├── codigo/
│   ├── plagiarism_detector.php    ← Motor principal: 3 capas, caché, reporte masivo
│   ├── ast_analyzer.py            ← AST real con ast.parse(), Jaccard, coseno
│   ├── plagiarism_report.php      ← UI del reporte: exportar CSV/PDF, matriz de similitud
│   ├── plagiarism_ajax.php        ← Endpoint AJAX para análisis en background
│   ├── mark_plagiarism.php        ← Confirmar/descartar plagio
│   └── ast_comparator_demo.js     ← Demo standalone del comparador AST (Node.js)
└── bd/
    └── datos-prueba-plagio.sql    ← Datos SQL para probar detección de plagio
```

## Qué demuestra este avance

### Las 3 capas en código real

**Capa 1 — Léxica (35%)** → `plagiarism_detector.php`
```php
// Normalizar: reemplazar nombres de variables por VAR_n
private static function normalize_identifiers(string $code): string { ... }
// Jaccard sobre bigramas de tokens
private static function jaccard(array $a, array $b): float { ... }
// LCS ratio (Longest Common Subsequence)
private static function lcs_ratio(array $a, array $b): float { ... }
```

**Capa 2 — Estructural (30%)** → `ast_analyzer.py`
```python
# AST real de Python
tree = ast.parse(code)
# Extrae: funciones, bucles, condicionales, profundidad, recursión
features = extract_features(code)
# Similitud coseno entre vectores de features
similarity = cosine(f1["node_types"], f2["node_types"])
```

**Capa 3 — Semántica (35%)** → `plagiarism_detector.php`
```php
// Solo se activa cuando score combinado está entre 20% y 85%
if ($lex_struct_avg > 85 || $lex_struct_avg < 20) {
    // Omitir IA (resultado obvio) — ahorra ~60% del costo API
}
// Llama a OpenAI GPT-4o-mini con prompt especializado
$sem = self::semantic_similarity_ai($code1, $code2);
```

### 6 Técnicas de ofuscación detectadas
| # | Técnica | Score bonus |
|---|---|---|
| 1 | Renombrado de variables | Detectado por normalización léxica |
| 2 | Cambio de tipo de bucle (for↔while↔recursión) | +5 puntos |
| 3 | Reordenación de sentencias | +5 puntos |
| 4 | Inserción de código muerto | +5 puntos |
| 5 | Cambio operadores equivalentes (i++ ↔ i+=1) | +5 puntos |
| 6 | Comentarios falsos | +5 puntos |
