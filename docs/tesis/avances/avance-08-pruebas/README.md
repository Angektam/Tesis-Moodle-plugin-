# Avance 8 — Pruebas y Resultados

**Plugin:** mod_aiassignment v2.5.1 | **Universidad:** UAS-FIM | **Autor:** Ángel Flores | **Sep 2026**

## Contenido de esta carpeta

```
avance-08-pruebas/
├── README.md
├── docs/
│   ├── PRUEBAS_RESULTADOS.md           ← Documento del avance
│   ├── IEEE829_DOC1_PLAN_PRUEBAS.md    ← Plan de Pruebas IEEE 829
│   ├── IEEE829_DOC2_DISENO_PRUEBAS.md  ← Diseño de Pruebas
│   ├── IEEE829_DOC3_CASOS_PRUEBA.md    ← Casos de Prueba
│   ├── IEEE829_DOC4_PROCEDIMIENTOS.md  ← Procedimientos
│   ├── IEEE829_DOC5_TRANSMISION.md     ← Reporte de Transmisión
│   ├── IEEE829_DOC6_LOG_PRUEBAS.md     ← Log de Pruebas
│   ├── IEEE829_DOC7_INCIDENTES.md      ← Reporte de Incidentes
│   └── IEEE829_DOC8_REPORTE_FINAL.md   ← Reporte Final
├── codigo/
│   ├── tests/                         ← Suite PHPUnit completa (62 tests)
│   │   ├── plagiarism_detector_test.php   (18 tests)
│   │   ├── ai_evaluator_test.php          (14 tests)
│   │   ├── security_test.php              (12 tests)
│   │   ├── submission_manager_test.php    (10 tests)
│   │   └── complexity_analyzer_test.php   (8 tests)
│   ├── generar-150-alumnos.js         ← Genera SQL para 150 alumnos, 6 salones
│   ├── generar-test-estres.js         ← Genera SQL para prueba de estrés 100 alumnos
│   ├── stress-test.js                 ← Script de stress test con peticiones HTTP
│   └── thesis_results.php             ← Página de resultados de la tesis en Moodle
└── bd/
    ├── test-150-alumnos-6-salones.sql  ← Datos: 150 alumnos × 6 salones × 3 maestros
    ├── test-masivo-30-alumnos.sql      ← Datos: experimento controlado 30 alumnos
    ├── test-estres-100-alumnos.sql     ← Datos: prueba de estrés 100 alumnos
    ├── inscribir-30-alumnos.sql        ← Inscribir alumnos al curso
    ├── insertar-alumnos-prueba.sql     ← Insertar usuarios de prueba
    ├── ver-tablas-principales.sql      ← Verificar estructura de tablas
    └── stress-test-moodle-db.sql       ← Consultas de estrés en BD
```

## Ejecutar las pruebas

### PHPUnit (tests unitarios)
```bash
cd /var/www/html/moodle
vendor/bin/phpunit --testdox --colors mod/aiassignment/tests/
# Esperado: 62 tests, 0 failures, 0 errors
```

### Prueba de estrés (150 alumnos)
```bash
# Generar SQL
node codigo/generar-150-alumnos.js
# Ejecutar en phpMyAdmin o MySQL Workbench
# Archivo: bd/test-150-alumnos-6-salones.sql
```

## Resultados del experimento controlado (30 alumnos)

| Métrica | Resultado |
|---|---|
| Exactitud (Accuracy) | **96.4%** |
| Precisión | **100%** |
| Recall | **100%** |
| F1-Score | **100%** |
| Falsos Positivos | **0** |
| Tiempo análisis rápido (30 alumnos) | **18.4 segundos** |
| SUS Score | **82.5 / 100** |
