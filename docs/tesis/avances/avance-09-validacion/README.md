# Avance 9 — Validación de Hipótesis y Discusión

**Plugin:** mod_aiassignment v2.5.1 | **Universidad:** UAS-FIM | **Autor:** Ángel Flores | **Sep 2026**

## Contenido de esta carpeta

```
avance-09-validacion/
├── README.md
├── docs/
│   ├── VALIDACION_HIPOTESIS.md    ← Documento del avance (H1, H2, H3 validadas)
│   ├── METRICAS_MODELO_IA.md      ← Métricas detalladas del modelo
│   ├── ENCUESTA_SUS.md            ← Resultados de la encuesta SUS
│   └── usuarios-prueba.csv        ← Datos de los 30 participantes del experimento
├── codigo/
│   ├── thesis_results.php         ← Página de resultados integrada en Moodle
│   ├── audit_logger.php           ← Sistema de auditoría (trazabilidad forense)
│   ├── student_stats.php          ← Estadísticas por alumno
│   ├── course_report.php          ← Reporte completo del curso
│   ├── verificar-usuarios.js      ← Verificar usuarios en BD
│   ├── verificar-usuarios-detalle.js ← Detalle de usuarios y permisos
│   └── check-users.js             ← Verificación rápida de usuarios
└── bd/
    ├── registrar-maestro-y-5-alumnos.sql  ← Script mínimo para prueba rápida
    └── inscribir-5-alumnos-c.sql          ← Inscribir 5 alumnos con rol correcto
```

## Hipótesis validadas

### H1 — Precisión ≥ 80%
> **Resultado: 96.4% de exactitud** (+16.4 puntos sobre el umbral)
- 0 falsos positivos en 30 alumnos
- 100% de precisión y recall con umbral 75%
- Superada con amplio margen

### H2 — Eficiencia superior a herramientas externas
> **Resultado: 3-5x más rápido que MOSS/JPlag**
- Análisis rápido: 18.4 segundos vs 5-10 minutos en MOSS
- Sin pasos manuales de exportación (integración nativa Moodle)
- Caché inteligente → segunda consulta instantánea

### H3 — SUS ≥ 70 (buena usabilidad)
> **Resultado: SUS 82.5/100** (+12.5 puntos sobre umbral)
- 8 evaluadores (profesores FIM-UAS)
- Clasificación: "Bueno" (escala Bangor et al. 2009)
- Items mejor valorados: integración natural en Moodle, claridad del dashboard

## Contribuciones originales

1. Arquitectura multicapa con activación condicional del LLM (zona de incertidumbre 20-85%)
2. Primera integración nativa en Moodle 4.0+ combinando plagio + evaluación automática
3. Sistema de behavior analytics en LMS
4. Experimento controlado reproducible con materiales públicos
