# Plan de Implementación: Plugin de Moodle para Evaluación con IA

## Tipo de Plugin
**mod_aiassignment** - Módulo de actividad para evaluación automática con IA

## Estructura del Plugin

```
moodle/
└── mod/
    └── aiassignment/
        ├── version.php              # Información de versión
        ├── lib.php                  # Funciones principales del módulo
        ├── mod_form.php             # Formulario de configuración
        ├── view.php                 # Vista principal para estudiantes
        ├── index.php                # Lista de instancias
        ├── lang/
        │   ├── en/
        │   │   └── aiassignment.php # Strings en inglés
        │   └── es/
        │       └── aiassignment.php # Strings en español
        ├── db/
        │   ├── install.xml          # Esquema de base de datos
        │   ├── access.php           # Capacidades y permisos
        │   └── upgrade.php          # Scripts de actualización
        ├── classes/
        │   ├── ai_evaluator.php     # Servicio de evaluación con IA
        │   ├── submission.php       # Manejo de envíos
        │   └── output/
        │       └── renderer.php     # Renderizado de vistas
        ├── templates/                # Plantillas Mustache
        │   ├── view_assignment.mustache
        │   ├── submission_form.mustache
        │   └── evaluation_result.mustache
        ├── styles.css               # Estilos CSS
        ├── pix/
        │   └── icon.png            # Icono del módulo
        └── backup/                  # Sistema de backup/restore
            └── moodle2/
```

## Características Principales

### Para Profesores
1. **Crear Problemas/Tareas**
   - Título y descripción
   - Tipo: Matemáticas o Programación
   - Solución de referencia
   - Documentación adicional
   - Casos de prueba

2. **Configuración de Evaluación**
   - Umbral de aprobación
   - Intentos permitidos
   - Fechas de entrega
   - Configuración de OpenAI API

3. **Revisión de Envíos**
   - Ver todos los envíos de estudiantes
   - Calificaciones automáticas de IA
   - Retroalimentación generada
   - Opción de calificación manual
   - Exportar calificaciones al libro de calificaciones de Moodle

### Para Estudiantes
1. **Ver Tarea**
   - Descripción del problema
   - Documentación
   - Fecha límite
   - Intentos restantes

2. **Enviar Respuesta**
   - Editor de texto/código
   - Vista previa
   - Confirmación de envío

3. **Ver Resultados**
   - Calificación (0-100)
   - Retroalimentación de IA
   - Análisis detallado
   - Historial de intentos

## Tablas de Base de Datos

### mdl_aiassignment
```sql
CREATE TABLE mdl_aiassignment (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    course BIGINT NOT NULL,
    name VARCHAR(255) NOT NULL,
    intro TEXT,
    introformat SMALLINT,
    type VARCHAR(20),              -- 'math' o 'programming'
    solution TEXT,                 -- Solución de referencia
    documentation TEXT,
    test_cases TEXT,
    grade BIGINT DEFAULT 100,      -- Calificación máxima
    timemodified BIGINT,
    timecreated BIGINT
);
```

### mdl_aiassignment_submissions
```sql
CREATE TABLE mdl_aiassignment_submissions (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    assignment BIGINT NOT NULL,    -- FK a mdl_aiassignment
    userid BIGINT NOT NULL,        -- FK a mdl_user
    answer TEXT,
    status VARCHAR(20),            -- 'pending', 'evaluated'
    score DECIMAL(10,5),           -- 0-100
    feedback TEXT,
    ai_analysis TEXT,
    attempt SMALLINT DEFAULT 1,
    timecreated BIGINT,
    timemodified BIGINT
);
```

### mdl_aiassignment_evaluations
```sql
CREATE TABLE mdl_aiassignment_evaluations (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    submission BIGINT NOT NULL,    -- FK a mdl_aiassignment_submissions
    similarity_score DECIMAL(10,5),
    ai_feedback TEXT,
    ai_analysis TEXT,
    timecreated BIGINT
);
```

## Integración con Moodle

### 1. Sistema de Calificaciones
```php
// Actualizar calificación en el libro de calificaciones
aiassignment_update_grades($aiassignment, $userid);
```

### 2. Eventos de Moodle
```php
// Disparar eventos
\mod_aiassignment\event\submission_created::create()->trigger();
\mod_aiassignment\event\submission_graded::create()->trigger();
```

### 3. Capacidades (Permisos)
```php
$capabilities = [
    'mod/aiassignment:addinstance',      // Crear instancia
    'mod/aiassignment:view',             // Ver actividad
    'mod/aiassignment:submit',           // Enviar respuesta
    'mod/aiassignment:grade',            // Calificar
    'mod/aiassignment:viewgrades',       // Ver calificaciones
];
```

### 4. Backup y Restore
Implementar sistema de backup/restore para migración de cursos.

## Configuración de OpenAI

### Opción 1: Configuración Global (Admin)
```php
// settings.php
$settings->add(new admin_setting_configtext(
    'aiassignment/openai_api_key',
    get_string('openai_api_key', 'aiassignment'),
    get_string('openai_api_key_desc', 'aiassignment'),
    '',
    PARAM_TEXT
));
```

### Opción 2: Por Instancia
Permitir que cada profesor configure su propia API key.

## Flujo de Trabajo

### Profesor
1. Agrega actividad "AI Assignment" al curso
2. Configura el problema y solución
3. Establece fechas y parámetros
4. Guarda la actividad

### Estudiante
1. Accede a la actividad
2. Lee el problema
3. Escribe su respuesta
4. Envía
5. Recibe evaluación automática con IA
6. Ve retroalimentación y calificación

### Sistema
1. Recibe envío del estudiante
2. Llama a OpenAI API con:
   - Solución del profesor
   - Respuesta del estudiante
   - Tipo de problema
3. Procesa respuesta de IA
4. Guarda evaluación
5. Actualiza calificación en Moodle
6. Notifica al estudiante

## Archivos Clave a Crear

### 1. version.php
```php
<?php
defined('MOODLE_INTERNAL') || die();

$plugin->component = 'mod_aiassignment';
$plugin->version = 2024020600;
$plugin->requires = 2022041900; // Moodle 4.0
$plugin->maturity = MATURITY_STABLE;
$plugin->release = 'v1.0';
```

### 2. lib.php (funciones principales)
- `aiassignment_add_instance()`
- `aiassignment_update_instance()`
- `aiassignment_delete_instance()`
- `aiassignment_user_outline()`
- `aiassignment_user_complete()`
- `aiassignment_update_grades()`

### 3. mod_form.php (formulario de configuración)
Formulario para que el profesor configure la tarea.

### 4. view.php (vista principal)
Vista que ven los estudiantes para enviar respuestas.

### 5. classes/ai_evaluator.php
Servicio que se conecta con OpenAI (reutilizar tu código actual).

## Ventajas de esta Implementación

✅ **Integración nativa** con Moodle
✅ **Usa el sistema de calificaciones** de Moodle
✅ **Permisos y roles** de Moodle
✅ **Backup/restore** automático
✅ **Notificaciones** del sistema
✅ **Reportes** integrados
✅ **Multilenguaje** nativo
✅ **Responsive** con tema de Moodle

## Próximos Pasos

1. **Crear estructura básica** del plugin
2. **Migrar lógica de backend** actual a clases de Moodle
3. **Adaptar frontend** a plantillas Mustache
4. **Implementar formularios** con Moodle Forms API
5. **Configurar base de datos** con install.xml
6. **Probar en Moodle local**
7. **Empaquetar y distribuir**

## Recursos Útiles

- **Documentación oficial**: https://docs.moodle.org/dev/
- **Plugin skeleton generator**: https://moodle.org/plugins/tool_pluginskel
- **Ejemplos de plugins**: https://github.com/moodle/moodle/tree/master/mod
- **Foros de desarrollo**: https://moodle.org/mod/forum/view.php?id=55

## Compatibilidad

- **Moodle 4.0+** (LTS)
- **PHP 7.4+**
- **MySQL/PostgreSQL**
- **OpenAI API**

## Licencia

GPL v3 (compatible con Moodle)
