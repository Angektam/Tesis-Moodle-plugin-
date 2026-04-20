# 📦 Instalación del Plugin desde la Interfaz de Moodle

## Método Recomendado: Instalación desde ZIP ⭐

Esta es la forma más fácil de instalar el plugin sin necesidad de acceso FTP o SSH.

---

## Paso 1: Crear el Archivo ZIP

### Opción A: Desde Windows

```bash
# Abre PowerShell en la carpeta del proyecto
cd moodle-plugin

# Crear ZIP (requiere 7-Zip o WinRAR)
# Con 7-Zip:
7z a -tzip aiassignment.zip *

# O manualmente:
# 1. Selecciona todos los archivos dentro de moodle-plugin/
# 2. Click derecho → Enviar a → Carpeta comprimida
# 3. Renombra a aiassignment.zip
```

### Opción B: Desde Linux/Mac

```bash
cd moodle-plugin
zip -r aiassignment.zip . -x "*.git*" -x "*.md" -x "demo*.html" -x "vista-previa*.html"
```

### Opción C: Script Automático

Crea este script en la raíz del proyecto:

**crear-zip.bat** (Windows):
```batch
@echo off
echo Creando ZIP del plugin...
cd moodle-plugin
powershell Compress-Archive -Path * -DestinationPath ../aiassignment.zip -Force
cd ..
echo.
echo ZIP creado: aiassignment.zip
echo Listo para instalar en Moodle
pause
```

**crear-zip.sh** (Linux/Mac):
```bash
#!/bin/bash
echo "Creando ZIP del plugin..."
cd moodle-plugin
zip -r ../aiassignment.zip . -x "*.git*" -x "*.md" -x "demo*.html" -x "vista-previa*.html"
cd ..
echo ""
echo "ZIP creado: aiassignment.zip"
echo "Listo para instalar en Moodle"
```

---

## Paso 2: Instalar desde Moodle

### 2.1 Acceder como Administrador

1. Inicia sesión en tu Moodle como **administrador**
2. Asegúrate de tener permisos de administrador del sitio

### 2.2 Ir a Instalación de Plugins

**Ruta:** Site administration → Plugins → Install plugins

O directamente:
```
https://tu-moodle.com/admin/tool/installaddon/index.php
```

### 2.3 Subir el ZIP

1. Haz clic en **"Choose a file"** o **"Elegir un archivo"**
2. Selecciona el archivo `aiassignment.zip`
3. Haz clic en **"Install plugin from the ZIP file"**

### 2.4 Validación Automática

Moodle validará el plugin automáticamente:

✅ **Validaciones que debe pasar:**
- Estructura de archivos correcta
- version.php presente y válido
- Tipo de plugin correcto (mod)
- No hay conflictos con plugins existentes

⚠️ **Si hay advertencias:**
- Lee los mensajes cuidadosamente
- Generalmente son solo avisos, no errores críticos
- Puedes continuar si solo son advertencias

### 2.5 Confirmar Instalación

1. Revisa la información del plugin:
   - **Nombre:** AI Assignment
   - **Tipo:** Activity module
   - **Versión:** (la que está en version.php)

2. Haz clic en **"Continue"** o **"Continuar"**

3. Moodle extraerá los archivos a:
   ```
   /ruta/a/moodle/mod/aiassignment/
   ```

### 2.6 Actualizar Base de Datos

1. Moodle te redirigirá a: **Site administration → Notifications**

2. Verás un mensaje indicando que hay actualizaciones pendientes

3. Haz clic en **"Upgrade Moodle database now"**

4. Moodle ejecutará:
   - Creación de tablas (desde db/install.xml)
   - Instalación de capacidades (desde db/access.php)
   - Registro de strings de idioma

5. Espera a que termine (puede tomar 10-30 segundos)

6. Verás un mensaje de éxito: ✅ **"Success"**

---

## Paso 3: Configurar el Plugin

### 3.1 Acceder a Configuración

**Ruta:** Site administration → Plugins → Activity modules → AI Assignment

O directamente:
```
https://tu-moodle.com/admin/settings.php?section=modsettingaiassignment
```

### 3.2 Configurar API Key

1. **OpenAI API Key** (requerido)
   - Pega tu API key de OpenAI
   - Formato: `sk-...`
   - Obtén una en: https://platform.openai.com/api-keys

2. **OpenAI Model** (opcional)
   - Por defecto: `gpt-4o-mini`
   - Otras opciones: `gpt-4`, `gpt-3.5-turbo`
   - Recomendado: `gpt-4o-mini` (mejor relación calidad/precio)

3. Haz clic en **"Save changes"**

---

## Paso 4: Verificar Instalación

### 4.1 Verificar en Lista de Plugins

1. Ve a: **Site administration → Plugins → Plugins overview**
2. Busca "AI Assignment" en la lista
3. Debe aparecer con estado: ✅ **Enabled**

### 4.2 Verificar Permisos

1. Ve a: **Site administration → Users → Permissions → Define roles**
2. Edita el rol "Teacher"
3. Busca capacidades que empiecen con `mod/aiassignment:`
4. Deben estar presentes:
   - `mod/aiassignment:addinstance`
   - `mod/aiassignment:view`
   - `mod/aiassignment:submit`
   - `mod/aiassignment:grade`

### 4.3 Probar en un Curso

1. Ve a cualquier curso (o crea uno de prueba)
2. Activa la edición: **"Turn editing on"**
3. Haz clic en **"Add an activity or resource"**
4. Busca **"AI Assignment"** en la lista
5. Debe aparecer con el icono del plugin

---

## Paso 5: Primera Prueba

### 5.1 Crear una Actividad

1. En un curso, agrega una actividad "AI Assignment"
2. Configura:
   - **Name:** "Prueba de Evaluación IA"
   - **Description:** "Problema de prueba"
   - **Problem type:** Mathematics
   - **Problem statement:** "Resuelve: 2x + 5 = 13"
   - **Teacher solution:** "x = 4"
3. Guarda

### 5.2 Probar como Estudiante

1. Enroll un usuario como estudiante (o usa otro navegador)
2. Accede a la actividad
3. Envía una respuesta: "2x = 8, x = 4"
4. Verifica que recibas:
   - Score automático
   - Feedback de la IA
   - Análisis detallado

### 5.3 Revisar como Profesor

1. Vuelve como profesor
2. Ve a la actividad
3. Haz clic en "View submissions"
4. Debes ver:
   - Lista de envíos
   - Scores automáticos
   - Opción de revisar manualmente

---

## 🔧 Solución de Problemas

### Error: "Plugin validation failed"

**Causa:** Estructura de archivos incorrecta

**Solución:**
```bash
# Verifica que el ZIP contenga:
aiassignment.zip
├── version.php
├── lib.php
├── view.php
├── mod_form.php
├── db/
│   ├── install.xml
│   └── access.php
├── lang/
│   └── en/
│       └── aiassignment.php
└── classes/
    └── ai_evaluator.php

# NO debe contener una carpeta extra:
# ❌ aiassignment.zip/moodle-plugin/version.php
# ✅ aiassignment.zip/version.php
```

**Recrear ZIP correctamente:**
```bash
# Asegúrate de estar DENTRO de moodle-plugin/
cd moodle-plugin
zip -r ../aiassignment.zip .
```

### Error: "Cannot install plugin"

**Causa:** Permisos insuficientes

**Solución:**
1. Verifica que eres administrador del sitio
2. Verifica permisos de escritura en el servidor:
   ```bash
   # Linux/Mac
   sudo chown -R www-data:www-data /var/www/moodle/mod/
   sudo chmod -R 755 /var/www/moodle/mod/
   ```

### Error: "Plugin already exists"

**Causa:** Ya existe una versión del plugin

**Solución:**
1. Ve a: Site administration → Plugins → Plugins overview
2. Busca "AI Assignment"
3. Haz clic en "Uninstall"
4. Confirma la desinstalación
5. Vuelve a instalar el ZIP

### Error: "Database error during installation"

**Causa:** Problema con install.xml

**Solución:**
1. Verifica que `db/install.xml` esté bien formateado
2. Revisa los logs: Site administration → Reports → Logs
3. Busca el error específico
4. Corrige el archivo y vuelve a crear el ZIP

### Advertencia: "Missing language strings"

**Causa:** Faltan traducciones

**Solución:**
- Es solo una advertencia, no un error
- El plugin funcionará correctamente
- Puedes agregar las traducciones después

### Error: "No API key configured"

**Causa:** No has configurado la API key

**Solución:**
1. Ve a: Site administration → Plugins → Activity modules → AI Assignment
2. Ingresa tu OpenAI API Key
3. Guarda cambios

---

## 📋 Checklist de Instalación

### Antes de Instalar
- [ ] Tengo acceso de administrador en Moodle
- [ ] Tengo una API Key de OpenAI
- [ ] He creado el archivo ZIP correctamente
- [ ] El ZIP contiene todos los archivos necesarios

### Durante la Instalación
- [ ] Subí el ZIP desde Site administration → Plugins → Install plugins
- [ ] Moodle validó el plugin sin errores críticos
- [ ] Actualicé la base de datos
- [ ] Vi el mensaje de éxito

### Después de Instalar
- [ ] Configuré la OpenAI API Key
- [ ] Verifiqué que el plugin aparece en la lista
- [ ] Probé crear una actividad en un curso
- [ ] Envié una respuesta de prueba
- [ ] Recibí evaluación automática

---

## 🎯 Ventajas de Instalar desde la Interfaz

✅ **No necesitas acceso SSH/FTP**
✅ **Validación automática** del plugin
✅ **Instalación guiada** paso a paso
✅ **Actualización de BD automática**
✅ **Rollback fácil** si algo sale mal
✅ **Logs detallados** de la instalación

---

## 🔄 Actualizar el Plugin

Para actualizar a una nueva versión:

1. **Incrementa la versión** en `version.php`:
   ```php
   $plugin->version = 2024011602; // Incrementa este número
   ```

2. **Crea un nuevo ZIP** con los archivos actualizados

3. **Desinstala la versión anterior:**
   - Site administration → Plugins → Plugins overview
   - Busca "AI Assignment"
   - Uninstall

4. **Instala el nuevo ZIP** siguiendo los pasos anteriores

**Nota:** La desinstalación NO borra los datos de las actividades existentes si tienes configurado el backup correctamente.

---

## 📞 Siguiente Paso

Una vez instalado:

1. Lee `MANUAL_USUARIO.md` para aprender a usar el plugin
2. Crea problemas de prueba
3. Prueba el flujo completo profesor/estudiante
4. Revisa `COMPONENTES.md` para entender la arquitectura

---

## 💡 Consejo Pro

**Antes de instalar en producción:**

1. Prueba en el entorno de prueba local:
   ```bash
   cd test-environment
   php test-runner.php
   ```

2. Instala en un Moodle de desarrollo primero

3. Prueba con usuarios reales

4. Verifica que los scores sean justos

5. Ajusta los prompts si es necesario

6. Luego instala en producción

---

¡Listo! Ahora puedes instalar el plugin directamente desde la interfaz de Moodle sin necesidad de acceso al servidor. 🚀
