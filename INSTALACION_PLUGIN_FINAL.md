# 🚀 INSTALACIÓN DEL PLUGIN - INSTRUCCIONES FINALES

**Plugin:** mod_aiassignment v1.0.0  
**Archivo:** `dist/mod_aiassignment.zip` (109 KB)  
**Estado:** ✅ LISTO PARA INSTALAR

---

## ✅ ESTRUCTURA DEL ZIP VERIFICADA

El archivo ZIP contiene la estructura correcta requerida por Moodle:

```
mod_aiassignment.zip
└── aiassignment/
    ├── version.php
    ├── lib.php
    ├── mod_form.php
    ├── view.php
    ├── index.php
    ├── settings.php
    ├── db/
    ├── lang/
    ├── classes/
    ├── backup/
    └── ... (todos los archivos del plugin)
```

---

## 📋 PASOS DE INSTALACIÓN

### Método 1: Instalación desde la Interfaz Web (Recomendado)

1. **Acceder como Administrador**
   - Iniciar sesión en Moodle con cuenta de administrador

2. **Ir a Instalación de Plugins**
   - Navegar a: `Site administration → Plugins → Install plugins`
   - O usar la URL: `http://tu-moodle/admin/tool/installaddon/index.php`

3. **Subir el Archivo ZIP**
   - Hacer clic en "Choose a file" o arrastrar el archivo
   - Seleccionar: `dist/mod_aiassignment.zip`
   - Hacer clic en "Install plugin from the ZIP file"

4. **Validación Automática**
   - Moodle validará el paquete
   - Verificará la estructura
   - Mostrará información del plugin

5. **Confirmar Instalación**
   - Revisar la información mostrada
   - Hacer clic en "Continue"
   - Seguir el asistente de instalación

6. **Actualizar Base de Datos**
   - Moodle creará las tablas automáticamente
   - Hacer clic en "Upgrade Moodle database now"
   - Esperar a que complete

7. **Finalizar**
   - Hacer clic en "Continue"
   - El plugin estará instalado y listo

---

### Método 2: Instalación Manual (Servidor)

1. **Extraer el ZIP**
   ```bash
   unzip mod_aiassignment.zip
   ```

2. **Copiar al Directorio de Moodle**
   ```bash
   cp -r aiassignment /ruta/a/moodle/mod/
   ```

3. **Establecer Permisos**
   ```bash
   chown -R www-data:www-data /ruta/a/moodle/mod/aiassignment
   chmod -R 755 /ruta/a/moodle/mod/aiassignment
   ```

4. **Acceder a Moodle**
   - Ir a: `Site administration → Notifications`
   - Moodle detectará el nuevo plugin
   - Hacer clic en "Upgrade Moodle database now"

---

## ⚙️ CONFIGURACIÓN POST-INSTALACIÓN

### 1. Configurar API Key de OpenAI

1. Ir a: `Site administration → Plugins → Activity modules → AI Assignment`

2. Configurar los siguientes campos:
   - **OpenAI API Key:** Tu clave de API de OpenAI
   - **OpenAI Model:** Seleccionar modelo (recomendado: gpt-4o-mini)
   - **Demo Mode:** Desactivar para producción (activar solo para pruebas)
   - **Max Response Time:** 30 segundos (por defecto)

3. Hacer clic en "Save changes"

### 2. Verificar Permisos

1. Ir a: `Site administration → Users → Permissions → Define roles`

2. Verificar que los roles tengan las capacidades apropiadas:
   - **Student:** `mod/aiassignment:view`, `mod/aiassignment:submit`
   - **Teacher:** Todas las capacidades
   - **Manager:** Todas las capacidades

---

## 🧪 PRUEBA RÁPIDA

### Crear una Tarea de Prueba

1. **Entrar a un Curso**
   - Acceder a cualquier curso como profesor

2. **Activar Edición**
   - Hacer clic en "Turn editing on"

3. **Agregar Actividad**
   - Hacer clic en "Add an activity or resource"
   - Seleccionar "AI Assignment"

4. **Configurar la Tarea**
   ```
   Nombre: Prueba de Factorial
   Tipo: Programación
   Solución de referencia:
   def factorial(n):
       if n <= 1:
           return 1
       return n * factorial(n-1)
   
   Calificación máxima: 100
   Intentos máximos: 3
   ```

5. **Guardar y Mostrar**

### Probar como Estudiante

1. **Cambiar Rol**
   - Cambiar a vista de estudiante

2. **Enviar Respuesta**
   ```python
   def factorial(n):
       result = 1
       for i in range(1, n + 1):
           result *= i
       return result
   ```

3. **Verificar Evaluación**
   - Esperar evaluación automática (5-10 segundos)
   - Revisar calificación
   - Leer feedback de IA
   - Ver análisis detallado

---

## 📊 VERIFICAR INSTALACIÓN

### Checklist de Verificación

- [ ] Plugin aparece en lista de plugins instalados
- [ ] Opción "AI Assignment" disponible al agregar actividad
- [ ] Configuración de OpenAI accesible
- [ ] Se puede crear una tarea de prueba
- [ ] Estudiantes pueden enviar respuestas
- [ ] Evaluación automática funciona
- [ ] Calificaciones se registran en libro de calificaciones
- [ ] Dashboard muestra estadísticas

### Comandos de Verificación (CLI)

```bash
# Verificar que el plugin está instalado
php admin/cli/uninstall_plugins.php --show-all | grep aiassignment

# Verificar tablas de base de datos
mysql -u root -p moodle -e "SHOW TABLES LIKE 'mdl_aiassignment%';"

# Verificar permisos de archivos
ls -la /ruta/a/moodle/mod/aiassignment/
```

---

## 🔧 SOLUCIÓN DE PROBLEMAS

### Error: "The plugin ZIP package must contain just one directory"

**Solución:** El ZIP actual ya tiene la estructura correcta. Si persiste:
1. Extraer el ZIP
2. Verificar que contenga carpeta `aiassignment/`
3. Volver a comprimir solo esa carpeta

### Error: "Missing required files"

**Solución:** Verificar que existan:
- `aiassignment/version.php`
- `aiassignment/lib.php`
- `aiassignment/db/install.xml`
- `aiassignment/lang/en/aiassignment.php`

### Error: "OpenAI API Error"

**Solución:**
1. Verificar que la API Key sea válida
2. Verificar conexión a internet del servidor
3. Activar "Demo Mode" para pruebas sin API

### Error: "Permission denied"

**Solución:**
```bash
chown -R www-data:www-data /ruta/a/moodle/mod/aiassignment
chmod -R 755 /ruta/a/moodle/mod/aiassignment
```

---

## 📞 INFORMACIÓN ADICIONAL

### Requisitos del Sistema
- Moodle 4.0 o superior
- PHP 7.4 o superior
- MySQL 5.7+ / PostgreSQL 9.6+
- Extensión PHP cURL habilitada
- Acceso a internet (para OpenAI API)

### Obtener API Key de OpenAI
1. Ir a: https://platform.openai.com/
2. Crear cuenta o iniciar sesión
3. Ir a: API Keys
4. Crear nueva clave
5. Copiar y guardar la clave

### Costos de OpenAI
- **gpt-4o-mini:** ~$0.15 por 1M tokens (recomendado)
- **gpt-4o:** ~$2.50 por 1M tokens
- Estimado: ~$0.001-0.005 por evaluación

---

## ✅ RESUMEN

El plugin **mod_aiassignment v1.0.0** está listo para instalar:

- ✅ Archivo ZIP con estructura correcta
- ✅ 109 KB de tamaño
- ✅ Compatible con Moodle 4.0+
- ✅ Cumple con todos los estándares
- ✅ Documentación completa incluida

**Siguiente paso:** Subir `dist/mod_aiassignment.zip` a Moodle y seguir el asistente de instalación.

---

**¡Instalación lista! 🎉**
