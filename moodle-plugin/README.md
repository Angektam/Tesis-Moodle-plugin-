# AI Assignment - Plugin de Moodle

Plugin de Moodle para evaluación automática de tareas usando Inteligencia Artificial (OpenAI).

## Características

- ✅ Evaluación automática con IA (OpenAI GPT)
- ✅ Soporte para problemas de matemáticas y programación
- ✅ Retroalimentación detallada para estudiantes
- ✅ Integración con el libro de calificaciones de Moodle
- ✅ Control de intentos máximos
- ✅ Multilenguaje (Español e Inglés)

## Requisitos

- Moodle 4.0 o superior
- PHP 7.4 o superior
- Cuenta de OpenAI con API key

## Instalación

### Método 1: Instalación Manual

1. Descarga o clona este repositorio
2. Copia la carpeta `moodle-plugin` a `[moodle]/mod/aiassignment`
3. Visita la página de notificaciones de Moodle (Site administration → Notifications)
4. Sigue el proceso de instalación

### Método 2: Instalación desde ZIP

1. Comprime la carpeta `moodle-plugin` como `aiassignment.zip`
2. En Moodle, ve a Site administration → Plugins → Install plugins
3. Sube el archivo ZIP
4. Sigue el proceso de instalación

## Configuración

1. Ve a Site administration → Plugins → Activity modules → AI Assignment
2. Ingresa tu **OpenAI API Key**
3. (Opcional) Cambia el modelo de OpenAI (predeterminado: gpt-4o-mini)
4. Guarda los cambios

## Uso

### Para Profesores

1. En tu curso, activa la edición
2. Agrega una actividad → AI Assignment
3. Completa el formulario:
   - **Nombre**: Título de la tarea
   - **Descripción**: Instrucciones para los estudiantes
   - **Tipo**: Matemáticas o Programación
   - **Solución de referencia**: La solución correcta
   - **Documentación**: Información adicional (opcional)
   - **Casos de prueba**: Ejemplos (opcional)
   - **Calificación máxima**: Puntos (predeterminado: 100)
   - **Intentos máximos**: 0 = ilimitado
4. Guarda y muestra la actividad

### Para Estudiantes

1. Accede a la actividad AI Assignment
2. Lee el problema y la documentación
3. Escribe tu respuesta en el área de texto
4. Haz clic en "Enviar"
5. Recibe evaluación automática con:
   - Calificación (0-100%)
   - Retroalimentación breve
   - Análisis detallado

## Estructura del Plugin

```
moodle-plugin/
├── version.php              # Información de versión
├── lib.php                  # Funciones principales
├── mod_form.php             # Formulario de configuración
├── view.php                 # Vista principal
├── submit.php               # Procesamiento de envíos
├── settings.php             # Configuración del plugin
├── db/
│   ├── install.xml          # Esquema de base de datos
│   └── access.php           # Permisos y capacidades
├── lang/
│   ├── en/
│   │   └── aiassignment.php # Strings en inglés
│   └── es/
│       └── aiassignment.php # Strings en español
└── classes/
    └── ai_evaluator.php     # Servicio de evaluación con IA
```

## Tablas de Base de Datos

### mdl_aiassignment
Almacena las instancias de tareas con IA

### mdl_aiassignment_submissions
Almacena los envíos de los estudiantes

### mdl_aiassignment_evaluations
Almacena las evaluaciones detalladas de IA

## Permisos

- `mod/aiassignment:addinstance` - Crear nueva tarea
- `mod/aiassignment:view` - Ver tarea
- `mod/aiassignment:submit` - Enviar respuesta
- `mod/aiassignment:grade` - Calificar envíos
- `mod/aiassignment:viewgrades` - Ver calificaciones

## Eventos

- `submission_created` - Cuando un estudiante envía una respuesta
- `submission_graded` - Cuando una respuesta es calificada

## Solución de Problemas

### Error: "No API key configured"
- Ve a la configuración del plugin y agrega tu OpenAI API key

### La evaluación falla
- Verifica que tu API key sea válida
- Verifica que tengas créditos en tu cuenta de OpenAI
- Revisa los logs de Moodle para más detalles

### Los estudiantes no pueden enviar
- Verifica que tengan el permiso `mod/aiassignment:submit`
- Verifica que no hayan alcanzado el máximo de intentos

## Desarrollo

### Próximas Características

- [ ] Evaluación asíncrona con tareas programadas
- [ ] Soporte para múltiples archivos
- [ ] Comparación entre envíos de estudiantes
- [ ] Exportación de resultados
- [ ] Dashboard con estadísticas
- [ ] Soporte para más tipos de problemas

## Licencia

GPL v3 (compatible con Moodle)

## Autor

Sistema de Evaluación de Tareas con IA

## Soporte

Para reportar problemas o sugerencias, crea un issue en el repositorio.
