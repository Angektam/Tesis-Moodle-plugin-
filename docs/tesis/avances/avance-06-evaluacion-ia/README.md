# Avance 6 — Sistema de Evaluación Automática con IA

**Plugin:** mod_aiassignment v2.5.1 | **Universidad:** UAS-FIM | **Autor:** Ángel Flores | **Sep 2026**

## Contenido de esta carpeta

```
avance-06-evaluacion-ia/
├── README.md
├── docs/
│   ├── EVALUACION_IA.md           ← Documento del avance (prompts, JSON, caché, rate limit)
│   ├── COMO_FUNCIONA_IA.md        ← Explicación del sistema de evaluación
│   └── APIS_UTILES_PROYECTO.md    ← APIs externas: OpenAI, Judge0, GitHub
├── codigo/
│   ├── ai_evaluator.php           ← Evaluador principal: 6 tipos, prompts, rate limit
│   ├── ai_detector.php            ← Detector de código generado por IA (ChatGPT/Copilot)
│   ├── complexity_analyzer.php    ← Complejidad ciclomática de McCabe
│   ├── rubric_evaluator.php       ← Evaluación con rúbrica personalizada (4 criterios)
│   ├── eval_cache.php             ← Caché de evaluaciones por hash SHA-256
│   ├── hint_generator.php         ← Pistas progresivas con IA (3 niveles)
│   ├── reevaluate.php             ← Re-evaluar una submission existente
│   ├── judge0_service_demo.js     ← Demo del servicio Judge0 (Node.js standalone)
│   ├── github_service_demo.js     ← Demo del servicio GitHub (Node.js standalone)
│   └── verificar-openai.js        ← Script para verificar configuración de OpenAI
```

## Qué demuestra este avance

### Los 6 tipos de problema con prompts especializados

| Tipo | Prompt evalúa | Archivo |
|---|---|---|
| `programming` | Corrección funcional, calidad, eficiencia, buenas prácticas | `ai_evaluator.php` |
| `math` | Resultado correcto, procedimiento, notación | `ai_evaluator.php` |
| `essay` | Contenido, argumentación, estructura, originalidad | `ai_evaluator.php` |
| `sql` | Corrección semántica, eficiencia, seguridad SQL injection | `ai_evaluator.php` |
| `pseudocode` | Corrección lógica, claridad, completitud | `ai_evaluator.php` |
| `debugging` | Identificación de bugs, corrección, explicación | `ai_evaluator.php` |

### JSON de respuesta de la evaluación
```json
{
  "similarity_score": 78.5,
  "feedback": "El código implementa correctamente el algoritmo...",
  "confidence": 92,
  "errors": [
    { "line": "función principal", "issue": "Falta manejo de n=0", "suggestion": "Añadir if n==0: return 1" }
  ]
}
```

### Sistema de caché
- Clave: `hash(studentCode + teacherSolution + type + rubric)`
- Resultado: segunda evaluación del mismo código → **instantánea, sin llamar a OpenAI**
- TTL: configurable (30 días por defecto)

### Rate limiting
- Límite: 100 llamadas/hora (configurable en settings.php)
- Al superar: submissions se encolan → procesamiento diferido con cron Moodle
