# Guía de Instalación del Plugin AI Assignment

## Pasos para Instalar en Moodle

### 1. Preparar el Plugin

```bash
# Desde la raíz de tu proyecto
cd moodle-plugin
```

### 2. Copiar a Moodle

**Opción A: Instalación Manual**
```bash
# Copiar la carpeta completa a tu instalación de Moodle
cp -r moodle-plugin /ruta/a/tu/moodle/mod/aiassignment
```

**Opción B: Crear ZIP para instalación desde interfaz**
```bash
# Crear archivo ZIP
zip -r aiassignment.zip moodle-plugin/*
```

### 3. Instalar desde Moodle

1. Inicia sesión como administrador en Moodle
2. Ve a: **Site administration → Notifications**
3. Moodle detectará el nuevo plugin
4. Haz clic en **Upgrade Moodle database now**
5. Confirma la instalación

### 4. Configurar el Plugin

1. Ve a: **Site administration → Plugins → Activity modules → AI Assignment**
2. Ingresa tu **OpenAI API Key**
3. (Opcional) Cambia el modelo (predeterminado: gpt-4o-mini)
4. Guarda los cambios

### 5. Verificar Instalación

1. Ve a cualquier curso
2. Activa la edición
3. Agrega una actividad
4. Deberías ver **"AI Assignment"** en la lista

## Archivos Faltantes (Opcionales)

Para una instalación completa, considera agregar:

### 1. Eventos (classes/event/)
```
classes/event/course_module_viewed.php
classes/event/submission_created.php
classes/event/submission_graded.php
```

### 2. Icono del Plugin
```
pix/icon.png (16x16 o 24x24)
pix/icon.svg
```

### 3. Backup/Restore
```
backup/moodle2/backup_aiassignment_stepslib.php
backup/moodle2/restore_aiassignment_stepslib.php
```

### 4. Vista de Envíos para Profesores
```
submissions.php
submission.php (ver detalle individual)
```

## Solución de Problemas

### Error: "Plugin not found"
- Verifica que la carpeta esté en `moodle/mod/aiassignment`
- Verifica que todos los archivos estén presentes

### Error: "Database error"
- Verifica que `db/install.xml` esté correctamente formateado
- Revisa los logs de Moodle en Site administration → Reports → Logs

### Error: "No API key configured"
- Ve a la configuración del plugin y agrega tu OpenAI API key

## Prueba Rápida

1. Crea un curso de prueba
2. Agrega una actividad "AI Assignment"
3. Configura un problema simple:
   - Tipo: Matemáticas
   - Solución: "2 + 2 = 4"
4. Como estudiante, envía una respuesta
5. Verifica que recibas evaluación automática

## Desinstalación

1. Ve a: **Site administration → Plugins → Activity modules → AI Assignment**
2. Haz clic en **Uninstall**
3. Confirma la desinstalación
4. Elimina la carpeta `moodle/mod/aiassignment`

## Actualización

1. Reemplaza los archivos en `moodle/mod/aiassignment`
2. Incrementa el número de versión en `version.php`
3. Ve a Site administration → Notifications
4. Sigue el proceso de actualización
