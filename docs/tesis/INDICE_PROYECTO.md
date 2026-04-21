# 📑 Índice del Proyecto — AI Assignment v2.2.0

## Proyecto de Tesis: Evaluación Automática y Detección de Plagio con IA en Moodle

---

## 🎯 Documentos Principales

| Documento | Descripción | Leer primero |
|-----------|-------------|:---:|
| `docs/tesis/TESIS_DETECCION_PLAGIO.md` | Documento completo de tesis | ⭐ |
| `docs/tesis/RESUMEN_FINAL.md` | Resumen ejecutivo y métricas | ⭐ |
| `USUARIOS_PRUEBA.md` | Credenciales de todos los usuarios | ⭐ |
| `moodle-plugin/README.md` | Descripción del plugin | |

---

## 📚 Documentación Técnica

| Documento | Descripción |
|-----------|-------------|
| `docs/tecnica/ARQUITECTURA_COMPLETA.md` | Arquitectura del sistema |
| `docs/tecnica/DETECCION_PLAGIO_AUTOMATICA.md` | Algoritmo de detección |
| `docs/tecnica/COMPARACION_AST.md` | Análisis AST con Python |
| `docs/tecnica/CLASES_E_INTERFACES.md` | Clases PHP del plugin |
| `docs/tecnica/ESTRUCTURA_BD.md` | Esquema de base de datos |
| `docs/tecnica/TECNOLOGIAS_PROYECTO.md` | Stack tecnológico |

---

## 📖 Guías de Instalación

| Documento | Descripción | Tiempo |
|-----------|-------------|--------|
| `docs/instalacion/INSTALACION_RAPIDA.md` | Instalación en 10 minutos | 10 min |
| `docs/instalacion/GUIA_INSTALACION_MOODLE_LOCAL.md` | Moodle local con XAMPP | 30-60 min |
| `docs/instalacion/INSTRUCCIONES_PLUGIN_FUNCIONAL.md` | Instalar el plugin | 15 min |
| `GUIA_INSTALACION_MOODLE.md` | Guía completa de Moodle | 60 min |

---

## 👤 Manuales de Usuario

| Documento | Audiencia |
|-----------|-----------|
| `moodle-plugin/MANUAL_USUARIO.md` | Profesores y estudiantes |
| `docs/usuario/GUIA_RAPIDA.md` | Inicio rápido |
| `docs/usuario/CASOS_PRUEBA_MANUAL.md` | Casos de prueba |
| `docs/usuario/MODO_DEMO_VS_REAL.md` | Diferencias demo/producción |

---

## 🗂️ Estructura del Repositorio

```
Tesis/
│
├── 📄 README.md                    Descripción general
├── 📄 USUARIOS_PRUEBA.md           Credenciales de prueba ⭐
├── 📄 LEEME.txt                    Bienvenida
│
├── 📁 moodle-plugin/               Plugin principal ⭐
│   ├── version.php                 v2.2.0
│   ├── view.php                    Vista estudiante (Monaco)
│   ├── submit.php                  Envío de respuestas
│   ├── dashboard.php               Dashboard con gráficas
│   ├── plagiarism_report.php       Reporte de plagio
│   ├── export_grades.php           Exportación CSV/Excel/PDF
│   ├── poll.php                    Notificaciones en tiempo real
│   ├── ast_analyzer.py             Análisis AST Python
│   └── classes/
│       ├── ai_evaluator.php        Evaluación con OpenAI
│       ├── plagiarism_detector.php Detección 3 capas
│       ├── complexity_analyzer.php Análisis O(n)
│       ├── code_executor.php       Ejecución con Judge0
│       ├── rubric_evaluator.php    Rúbricas
│       ├── ai_detector.php         Detecta código IA
│       ├── eval_cache.php          Caché
│       ├── security.php            Seguridad
│       ├── realtime_notifier.php   Notificaciones
│       └── multi_file_submission.php Múltiples archivos
│
├── 📁 dist/
│   └── mod_aiassignment.zip        ZIP listo para instalar ⭐
│
├── 📁 docs/
│   ├── tesis/                      Documentos de tesis
│   ├── tecnica/                    Documentación técnica
│   ├── instalacion/                Guías de instalación
│   └── usuario/                    Manuales de usuario
│
├── 📁 scripts/
│   ├── insertar-alumnos-prueba.sql Datos de prueba con plagio
│   ├── inscribir-30-alumnos.sql    30 alumnos con envíos
│   ├── resetear-todas-passwords.php Resetear contraseñas
│   └── configurar-seguridad-produccion.php Checklist seguridad
│
└── 📁 demo-standalone/             Demo sin Moodle
    ├── server.js                   Servidor Node.js
    └── services/                   Servicios externos
```

---

## 🚀 Inicio Rápido

### Instalar el plugin en Moodle
```
1. Ir a: Administración del sitio → Plugins → Instalar plugins
2. Subir: dist/mod_aiassignment.zip
3. Seguir el wizard de instalación
4. Configurar API key de OpenAI en los ajustes del plugin
```

### Crear datos de prueba
```sql
-- En phpMyAdmin → base de datos moodle → SQL:
-- 1. Ejecutar: scripts/insertar-alumnos-prueba.sql
-- 2. Ejecutar: scripts/inscribir-30-alumnos.sql
```

### Iniciar sesión
```
Admin:      admin / Admin123!
Estudiantes: est01 a est30 / Test1234!
Ver todos:  USUARIOS_PRUEBA.md
```

---

## 📈 Estado por Componente

| Componente | Estado | Versión |
|------------|--------|---------|
| Evaluación con IA | ✅ Completo | v2.2.0 |
| Detección de plagio | ✅ Completo | v2.2.0 |
| Editor Monaco | ✅ Completo | v2.2.0 |
| Dashboard + Gráficas | ✅ Completo | v2.2.0 |
| Exportación CSV/Excel/PDF | ✅ Completo | v2.2.0 |
| Rúbricas personalizables | ✅ Completo | v2.2.0 |
| Modo examen | ✅ Completo | v2.2.0 |
| Notificaciones en tiempo real | ✅ Completo | v2.2.0 |
| Múltiples archivos | ✅ Completo | v2.2.0 |
| Análisis de complejidad | ✅ Completo | v2.2.0 |
| Detección de código IA | ✅ Completo | v2.2.0 |
| Ejecución con Judge0 | ✅ Completo | v2.2.0 |
| Seguridad auditada | ✅ Completo | v2.2.0 |
| Despliegue en producción | ⏳ Pendiente | — |
| Pruebas con usuarios reales | ⏳ Pendiente | — |
