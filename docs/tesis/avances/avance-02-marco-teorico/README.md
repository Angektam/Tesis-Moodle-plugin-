# Avance 2 — Marco Teórico

**Plugin:** mod_aiassignment v2.5.1 | **Universidad:** UAS-FIM | **Autor:** Ángel Flores | **Sep 2026**

## Contenido de esta carpeta

```
avance-02-marco-teorico/
├── README.md
├── docs/
│   ├── MARCO_TEORICO.md          ← Documento del avance (AST, Jaccard, LCS, GPT)
│   ├── DETECCION_PLAGIO.md       ← Documentación técnica del sistema de plagio
│   └── COMO_FUNCIONA_IA.md       ← Explicación de la evaluación con IA
└── codigo/
    ├── ast_analyzer.py           ← Analizador AST real con ast.parse() de Python
    ├── plagiarism_detector.php   ← Motor de detección multicapa (3 capas ponderadas)
    └── security.php              ← Capa de seguridad: detect_language(), sanitización
```

## Qué demuestra este avance

- **AST real:** `ast_analyzer.py` usa `ast.parse()` de Python estándar — sin dependencias externas
- **Jaccard + LCS:** implementados en `plagiarism_detector.php` métodos `jaccard()` y `lcs_ratio()`
- **Similitud coseno:** en `ast_analyzer.py` función `cosine()`
- **Detección de lenguaje:** `security.php::detect_language()` detecta Python, Java, JS, C++, PHP, SQL, TS, Ruby, Go, Rust

## Conceptos del marco teórico → código real

| Concepto teórico | Dónde está en el código |
|---|---|
| AST (Abstract Syntax Tree) | `ast_analyzer.py` — `extract_features()` |
| Jaccard sobre bigramas | `plagiarism_detector.php` — `jaccard()` |
| LCS (Longest Common Subsequence) | `plagiarism_detector.php` — `lcs_ratio()` |
| Similitud coseno | `ast_analyzer.py` — `cosine()` |
| Normalización léxica | `plagiarism_detector.php` — `normalize_identifiers()` |
| 3 capas ponderadas | `plagiarism_detector.php` — `compare_code()` |
