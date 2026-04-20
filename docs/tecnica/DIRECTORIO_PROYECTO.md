# Directorio del Proyecto — mod_aiassignment

```
aiassignment/
│
├── .env                          # Variables de entorno (API keys, config local)
├── .env.example                  # Plantilla de variables de entorno
├── package.json                  # Dependencias Node.js (express, acorn, node-fetch…)
│
├── moodle-plugin/                # Plugin Moodle (mod_aiassignment)
│   │
│   ├── version.php               # Versión y metadatos del plugin
│   ├── lib.php                   # Funciones obligatorias de Moodle (callbacks)
│   ├── mod_form.php              # Formulario de creación/edición de actividad
│   ├── view.php                  # Vista principal de la actividad
│   ├── index.php                 # Listado de actividades en el curso
│   ├── submit.php                # Procesa el envío del estudiante
│   ├── submission.php            # Vista de un envío individual
│   ├── submissions.php           # Lista de envíos (vista profesor)
│   ├── dashboard.php             # Dashboard de estadísticas
│   ├── plagiarism_report.php     # Reporte de plagio de un assignment
│   ├── reevaluate.php            # Re-evalúa un envío con IA
│   ├── settings.php              # Configuración global del plugin (admin)
│   ├── ide_stubs.php             # Stubs para autocompletado IDE
│   ├── ast_analyzer.py           # Analizador AST Python (llamado por PHP via proc_open)
│   │
│   ├── classes/                  # Clases PHP del plugin
│   │   ├── plagiarism_detector.php   ← clase plagiarism_detector
│   │   ├── ai_evaluator.php          ← clase ai_evaluator
│   │   ├── event/
│   │   │   ├── course_module_viewed.php  ← clase event\course_module_viewed
│   │   │   ├── submission_created.php    ← clase event\submission_created
│   │   │   └── submission_graded.php     ← clase event\submission_graded
│   │   └── privacy/
│   │       └── provider.php             ← clase privacy\provider
│   │
│   ├── amd/src/
│   │   └── dashboard.js          # Módulo AMD para el dashboard (Moodle JS)
│   │
│   ├── backup/moodle2/           # Backup/restore del plugin
│   │   ├── backup_aiassignment_activity_task.class.php
│   │   ├── backup_aiassignment_stepslib.php
│   │   ├── restore_aiassignment_activity_task.class.php
│   │   └── restore_aiassignment_stepslib.php
│   │
│   ├── db/
│   │   ├── install.xml           # Definición de tablas (XMLDB)
│   │   └── access.php            # Capacidades y permisos
│   │
│   ├── lang/
│   │   ├── en/aiassignment.php   # Cadenas en inglés
│   │   └── es/aiassignment.php   # Cadenas en español
│   │
│   ├── pix/
│   │   └── icon.svg              # Icono del plugin
│   │
│   └── styles/
│       └── dashboard.css         # Estilos del dashboard
│
├── demo-standalone/              # Servidor Express independiente (sin Moodle)
│   │
│   ├── server.js                 # Servidor principal Express
│   ├── server-demo.js            # Servidor en modo demo
│   ├── server-simple.js          # Servidor simplificado
│   ├── plugin-funcional.html     # UI del plugin en HTML estático
│   ├── plugin-funcional.js       # Lógica frontend del demo
│   ├── plugin-funcional.css      # Estilos del demo
│   │
│   ├── services/                 # Servicios de integración con APIs externas
│   │   ├── ast_comparator.js         ← clase ASTComparator
│   │   ├── github_service.js         ← clase GitHubService
│   │   ├── judge0_service.js         ← clase Judge0Service
│   │   ├── virustotal_service.js     ← clase VirusTotalService
│   │   └── python_ast_service.py     ← clase ASTHandler (servidor HTTP AST)
│   │
│   └── test-*.js / test-*.html   # Scripts de prueba por servicio
│
├── scripts/                      # Scripts de utilidad
│   ├── schema-moodle.sql         # Esquema completo de la BD
│   ├── datos-prueba-plagio.sql   # 5 alumnos con casos de plagio
│   ├── insertar-alumnos-prueba.sql  # Inserción de alumnos de prueba
│   ├── test-masivo-30-alumnos.sql   # Test masivo con 30 alumnos
│   ├── crear-zip-moodle.js       # Genera el .zip para instalar en Moodle
│   ├── verificar-openai.js       # Verifica conexión con OpenAI
│   ├── iniciar-ast-python.bat    # Inicia el servicio Python AST
│   ├── iniciar-plugin.bat        # Inicia el servidor demo
│   ├── crear-zip-plugin.bat/.sh  # Empaqueta el plugin
│   └── habilitar-extensiones-php.bat
│
├── docs/                         # Documentación
│   ├── tecnica/
│   │   ├── CLASES_E_INTERFACES.md    # Documentación de clases del proyecto
│   │   ├── DIRECTORIO_PROYECTO.md    # Este archivo
│   │   ├── ESTRUCTURA_BD.md
│   │   ├── COMPARACION_AST.md
│   │   ├── DETECCION_PLAGIO_AUTOMATICA.md
│   │   ├── FUNCIONALIDAD_PLAGIO.md
│   │   ├── APIS_UTILES_PROYECTO.md
│   │   ├── TECNOLOGIAS_PROYECTO.md
│   │   ├── MOODLE_PLUGIN_PLAN.md
│   │   ├── DIFERENCIAS_PLUGIN_VS_MOD.md
│   │   ├── dbdiagram-code.dbml       # Diagrama de BD (dbdiagram.io)
│   │   └── diagrama-bd.html          # Diagrama de BD visual
│   ├── instalacion/
│   │   ├── INSTALACION_RAPIDA.md
│   │   ├── COMO_EMPEZAR.md
│   │   ├── CONFIGURAR_API_KEY.md
│   │   ├── FASE1_APIS.md
│   │   ├── GUIA_INSTALACION_MOODLE_LOCAL.md
│   │   ├── GUIA_PRUEBAS_PLUGIN.md
│   │   ├── INICIAR_SERVIDOR.md
│   │   └── INSTRUCCIONES_PLUGIN_FUNCIONAL.md
│   ├── tesis/
│   │   ├── TESIS_DETECCION_PLAGIO.md
│   │   ├── RESUMEN_PROYECTO.md
│   │   └── INDICE_PROYECTO.md
│   └── usuario/
│       ├── GUIA_RAPIDA.md
│       ├── CASOS_PRUEBA_MANUAL.md
│       └── MODO_DEMO_VS_REAL.md
│
└── dist/                         # Artefactos de distribución
    ├── aiassignment.zip
    └── mod_aiassignment.zip
```

## Clases definidas

| Clase | Archivo | Lenguaje |
|-------|---------|----------|
| `plagiarism_detector` | `moodle-plugin/classes/plagiarism_detector.php` | PHP |
| `ai_evaluator` | `moodle-plugin/classes/ai_evaluator.php` | PHP |
| `event\course_module_viewed` | `moodle-plugin/classes/event/course_module_viewed.php` | PHP |
| `event\submission_created` | `moodle-plugin/classes/event/submission_created.php` | PHP |
| `event\submission_graded` | `moodle-plugin/classes/event/submission_graded.php` | PHP |
| `privacy\provider` | `moodle-plugin/classes/privacy/provider.php` | PHP |
| `ASTHandler` | `demo-standalone/services/python_ast_service.py` | Python |
| `ASTComparator` | `demo-standalone/services/ast_comparator.js` | JavaScript |
| `GitHubService` | `demo-standalone/services/github_service.js` | JavaScript |
| `Judge0Service` | `demo-standalone/services/judge0_service.js` | JavaScript |
| `VirusTotalService` | `demo-standalone/services/virustotal_service.js` | JavaScript |
