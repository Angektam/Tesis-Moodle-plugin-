# Guía de Pruebas del Plugin AI Assignment

## Problemas Identificados y Soluciones

### 1. Error: "Automatic evaluation failed"

**Causa:** El plugin necesita una API key de OpenAI configurada para evaluar automáticamente las respuestas.

**Solución:**

#### Opción A: Configurar OpenAI API (Recomendado para producción)

1. **Obtener API Key de OpenAI:**
   - Ve a: https://platform.openai.com/api-keys
   - Crea una cuenta o inicia sesión
   - Genera una nueva API key
   - Copia la key (empieza con `sk-...`)

2. **Configurar en Moodle:**
   - Ve a: `Administración del sitio > Plugins > Módulos de actividad > AI Assignment`
   - Pega tu API key en el campo "OpenAI API Key"
   - Selecciona el modelo (recomendado: `gpt-4o-mini` por costo/rendimiento)
   - Guarda cambios

3. **Verificar configuración:**
   - Crea una actividad de prueba
   - Envía una respuesta como estudiante
   - Debería evaluarse automáticamente

#### Opción B: Modo Demo (Sin API, para pruebas)

Si no tienes API key o quieres probar sin costo, necesitamos modificar el plugin para usar evaluación simulada.

### 2. Error: "Error al leer de la base de datos"

**Causa:** Las tablas del plugin no se crearon correctamente.

**Solución:**

1. **Desinstalar plugin:**
   ```
   Administración del sitio > Plugins > Módulos de actividad > Gestionar actividades
   ```
   - Busca "AI Assignment"
   - Haz clic en "Desinstalar"
   - Confirma

2. **Reinstalar con el ZIP correcto:**
   ```
   Administración del sitio > Plugins > Instalar plugins
   ```
   - Sube el archivo: `dist/mod_aiassignment.zip` (NO `aiassignment.zip`)
   - Completa la instalación

3. **Verificar tablas creadas:**
   - Ve a: `Administración del sitio > Notificaciones`
   - Deberías ver confirmación de tablas creadas

## Checklist de Pruebas

### Prueba 1: Instalación Correcta

- [ ] El plugin aparece en "Módulos de actividad"
- [ ] No hay errores en "Notificaciones"
- [ ] Las tablas se crearon en la base de datos:
  - `mdl_aiassignment`
  - `mdl_aiassignment_submissions`
  - `mdl_aiassignment_evaluations`

### Prueba 2: Crear Actividad

1. **Como profesor:**
   - [ ] Ve a un curso
   - [ ] Activa edición
   - [ ] Añade actividad → "AI Assignment"
   - [ ] Completa el formulario:
     - Nombre: "Prueba Factorial"
     - Tipo: "Programming"
     - Solución de referencia: (código ejemplo)
     - Documentación: "Implementa una función factorial"
     - Casos de prueba: "factorial(5) = 120"
   - [ ] Guarda cambios
   - [ ] La actividad se crea sin errores

### Prueba 3: Enviar Respuesta (Estudiante)

1. **Como estudiante:**
   - [ ] Entra a la actividad
   - [ ] Ve el formulario de envío
   - [ ] Escribe una respuesta
   - [ ] Envía
   - [ ] Mensaje: "Your answer has been submitted"

### Prueba 4: Evaluación Automática

**Con OpenAI configurado:**
- [ ] La respuesta se evalúa automáticamente
- [ ] Se muestra una calificación (0-100)
- [ ] Se muestra feedback de la IA
- [ ] La calificación aparece en el libro de calificaciones

**Sin OpenAI (error esperado):**
- [ ] Mensaje: "Automatic evaluation failed"
- [ ] La respuesta queda como "pending"
- [ ] No se asigna calificación

### Prueba 5: Dashboard (Profesor)

1. **Como profesor:**
   - [ ] Entra a la actividad
   - [ ] Haz clic en "Dashboard"
   - [ ] Ve estadísticas:
     - Total de entregas
     - Promedio de calificaciones
     - Estudiantes activos
     - Evaluaciones pendientes
   - [ ] Ve lista de entregas recientes

### Prueba 6: Ver Todas las Entregas

1. **Como profesor:**
   - [ ] Haz clic en "Ver todas las entregas"
   - [ ] Ve lista de estudiantes y sus entregas
   - [ ] Puede ver detalles de cada entrega
   - [ ] Puede calificar manualmente si es necesario

## Comandos de Verificación

### Verificar tablas en MySQL/MariaDB:

```sql
-- Conectar a la base de datos de Moodle
USE moodle;

-- Ver tablas del plugin
SHOW TABLES LIKE 'mdl_aiassignment%';

-- Ver estructura de tabla principal
DESCRIBE mdl_aiassignment;

-- Ver entregas
SELECT * FROM mdl_aiassignment_submissions;

-- Ver evaluaciones
SELECT * FROM mdl_aiassignment_evaluations;
```

### Verificar logs de Moodle:

```
Administración del sitio > Informes > Registros
```
- Filtra por actividad "AI Assignment"
- Busca errores o warnings

### Verificar configuración del plugin:

```
Administración del sitio > Plugins > Módulos de actividad > AI Assignment
```
- Verifica que la API key esté configurada
- Verifica el modelo seleccionado

## Solución de Problemas Comunes

### Problema: "noapikey" exception

**Solución:**
1. Configura la API key de OpenAI
2. O modifica el plugin para usar modo demo

### Problema: "evaluationfailed" exception

**Causas posibles:**
- API key inválida
- Sin créditos en OpenAI
- Problema de conectividad
- Límite de rate exceeded

**Solución:**
1. Verifica la API key
2. Verifica saldo en OpenAI
3. Revisa logs de Moodle para más detalles

### Problema: Calificación no aparece en libro de calificaciones

**Solución:**
1. Ve a la configuración de la actividad
2. Verifica que "Calificación máxima" esté configurada (ej: 100)
3. Guarda cambios
4. Reenvía una respuesta para probar

### Problema: No puedo ver el dashboard

**Solución:**
1. Verifica que tengas permisos de profesor
2. Verifica que el archivo `dashboard.php` exista
3. Purga cachés de Moodle

## Próximos Pasos

### Para Producción:

1. **Configurar OpenAI API:**
   - Obtener API key
   - Configurar en Moodle
   - Monitorear uso y costos

2. **Configurar cron de Moodle:**
   ```bash
   # Añadir a crontab
   * * * * * /usr/bin/php /ruta/a/moodle/admin/cli/cron.php
   ```

3. **Optimizar rendimiento:**
   - Considerar evaluación asíncrona
   - Implementar cola de trabajos
   - Cachear resultados

### Para Desarrollo/Pruebas:

1. **Crear modo demo:**
   - Evaluación simulada sin API
   - Datos de prueba predefinidos
   - Útil para demos y desarrollo

2. **Añadir más lenguajes:**
   - Python, Java, C++, JavaScript
   - Configurar Judge0 para ejecución
   - Integrar comparador AST

3. **Mejorar detección de plagio:**
   - Integrar servicios externos
   - Comparar entre estudiantes
   - Generar reportes

## Recursos Adicionales

- **Documentación de OpenAI:** https://platform.openai.com/docs
- **Documentación de Moodle:** https://docs.moodle.org
- **Repositorio del proyecto:** Ver `README.md`
- **Guía de instalación:** Ver `docs/instalacion/INSTALACION_RAPIDA.md`

## Contacto y Soporte

Si encuentras problemas:
1. Revisa los logs de Moodle
2. Verifica la configuración
3. Consulta esta guía
4. Revisa la documentación del proyecto
