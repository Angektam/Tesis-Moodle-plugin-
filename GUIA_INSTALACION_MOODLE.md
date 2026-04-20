# 📦 Guía de Instalación del Plugin en Moodle

## ✅ Plugin Listo para Instalar

**Archivo:** `dist/mod_aiassignment.zip`  
**Tamaño:** ~109 KB  
**Fecha:** Marzo 10, 2026

---

## 🚀 Instalación Paso a Paso

### Opción 1: Instalación desde la Interfaz de Moodle (Recomendado)

#### Paso 1: Acceder a Moodle
1. Abre tu navegador
2. Ve a tu instalación de Moodle
3. Inicia sesión como **administrador**

#### Paso 2: Ir a Instalación de Plugins
1. Click en el menú de administración (esquina superior derecha)
2. Navega a: **Site administration** → **Plugins** → **Install plugins**
3. O usa la URL directa: `http://tu-moodle.com/admin/tool/installaddon/`

#### Paso 3: Subir el Plugin
1. En la sección "Install plugin from ZIP file"
2. Click en **"Choose a file"**
3. Selecciona el archivo: `dist/mod_aiassignment.zip`
4. Click en **"Install plugin from the ZIP file"**

#### Paso 4: Validación
Moodle validará el plugin y mostrará:
- ✅ Nombre del plugin: **AI Assignment**
- ✅ Tipo: Activity module (mod)
- ✅ Versión: 2026031000
- ✅ Requiere: Moodle 3.9+

Click en **"Continue"**

#### Paso 5: Actualizar Base de Datos
1. Moodle mostrará las tablas que se crearán:
   - `mdl_aiassignment`
   - `mdl_aiassignment_submissions`
2. Click en **"Upgrade Moodle database now"**
3. Espera a que termine (5-10 segundos)

#### Paso 6: Configurar API Key
1. Después de la instalación, serás redirigido a la configuración
2. O ve a: **Site administration** → **Plugins** → **Activity modules** → **AI Assignment**
3. Ingresa tu **OpenAI API Key**
4. (Opcional) Cambia el modelo (default: gpt-4o-mini)
5. Click en **"Save changes"**

#### Paso 7: Verificar Instalación
1. Ve a cualquier curso
2. Click en **"Turn editing on"**
3. Click en **"Add an activity or resource"**
4. Deberías ver **"AI Assignment"** en la lista
5. ✅ ¡Plugin instalado correctamente!

---

### Opción 2: Instalación Manual (Avanzado)

#### Requisitos
- Acceso SSH o FTP al servidor
- Permisos de escritura en la carpeta de Moodle

#### Pasos
1. Descomprime `mod_aiassignment.zip`
2. Sube la carpeta `moodle-plugin` a: `/ruta/a/moodle/mod/aiassignment`
3. Asegúrate de que los permisos sean correctos:
   ```bash
   chmod -R 755 /ruta/a/moodle/mod/aiassignment
   chown -R www-data:www-data /ruta/a/moodle/mod/aiassignment
   ```
4. Ve a: **Site administration** → **Notifications**
5. Moodle detectará el nuevo plugin
6. Click en **"Upgrade Moodle database now"**
7. Configura la API Key (ver Paso 6 arriba)

---

## 🧪 Prueba del Plugin

### Crear una Tarea de Prueba

1. **Ir a un curso**
   - Entra a cualquier curso como profesor
   - Click en "Turn editing on"

2. **Agregar actividad**
   - Click en "Add an activity or resource"
   - Selecciona "AI Assignment"
   - Click en "Add"

3. **Configurar la tarea**
   ```
   Nombre: Factorial en Python
   Descripción: Implementa una función factorial recursiva
   Tipo de problema: Programación
   Lenguaje: Python
   Solución del profesor:
   
   def factorial(n):
       if n <= 1:
           return 1
       return n * factorial(n - 1)
   ```

4. **Guardar**
   - Click en "Save and display"

5. **Probar como estudiante**
   - Cambia a rol de estudiante
   - Envía una solución
   - Verifica que recibas evaluación automática con AST

---

## 🔧 Configuración Avanzada

### Configurar API Keys

**OpenAI API Key** (Requerido)
```
Site administration → Plugins → Activity modules → AI Assignment
→ OpenAI API Key: sk-...
```

**Judge0 API Key** (Opcional - para ejecución de código)
```
→ Judge0 API Key: tu-api-key
→ Judge0 API URL: https://judge0-ce.p.rapidapi.com
```

**GitHub API Token** (Opcional - para detección de plagio externo)
```
→ GitHub Token: ghp_...
```

### Ajustar Configuración

**Modelo de IA**
- Default: `gpt-4o-mini` (recomendado, económico)
- Alternativas: `gpt-4`, `gpt-3.5-turbo`

**Umbral de Plagio**
- Default: 85% (alta similitud = plagio)
- Rango: 60-95%

**Método de Comparación**
- ✅ AST (Abstract Syntax Trees) - Recomendado
- Híbrido (AST + IA)
- Solo IA

---

## 📊 Características del Plugin

### ✅ Evaluación Automática
- Compara código del estudiante vs solución del profesor
- Usa AST para análisis estructural
- Feedback instantáneo y constructivo
- Calificación automática (0-100)

### ✅ Detección de Plagio
- Compara entre estudiantes
- Análisis con AST (inmune a cambios cosméticos)
- Reportes detallados de similitud
- Búsqueda en GitHub (opcional)

### ✅ Dashboard para Profesores
- Vista de todas las entregas
- Estadísticas de plagio
- Gráficos de rendimiento
- Exportar resultados

### ✅ Soporte Multi-lenguaje
- JavaScript, Python, Java, C++, C
- Más de 60 lenguajes con Judge0
- Detección automática de lenguaje

---

## 🐛 Solución de Problemas

### Error: "Plugin not found"
**Causa:** Carpeta mal ubicada  
**Solución:**
```bash
# Verificar ubicación
ls /ruta/a/moodle/mod/aiassignment/version.php

# Debe existir el archivo version.php
```

### Error: "Database error"
**Causa:** Problema con install.xml  
**Solución:**
1. Ve a: Site administration → Development → XMLDB editor
2. Verifica la estructura de las tablas
3. Ejecuta manualmente las queries SQL si es necesario

### Error: "No API key configured"
**Causa:** Falta configurar OpenAI API Key  
**Solución:**
1. Ve a la configuración del plugin
2. Agrega tu API key
3. Guarda cambios

### Error: "Permission denied"
**Causa:** Permisos incorrectos  
**Solución:**
```bash
chmod -R 755 /ruta/a/moodle/mod/aiassignment
chown -R www-data:www-data /ruta/a/moodle/mod/aiassignment
```

### Plugin no aparece en la lista
**Causa:** Caché de Moodle  
**Solución:**
1. Site administration → Development → Purge all caches
2. Refresca la página
3. Ve a Notifications para forzar actualización

---

## 🔄 Actualización del Plugin

### Actualizar a Nueva Versión

1. **Descargar nueva versión**
   - Obtén el nuevo archivo ZIP

2. **Desinstalar versión anterior** (opcional)
   - Site administration → Plugins → Activity modules → AI Assignment
   - Click en "Uninstall"
   - Confirma (los datos se conservan)

3. **Instalar nueva versión**
   - Sigue los pasos de instalación normales
   - Moodle detectará que es una actualización

4. **Actualizar base de datos**
   - Site administration → Notifications
   - Click en "Upgrade Moodle database now"

---

## 📚 Recursos Adicionales

### Documentación
- `moodle-plugin/README.md` - Documentación completa
- `moodle-plugin/MANUAL_USUARIO.md` - Manual para profesores
- `docs/tecnica/COMPARACION_AST.md` - Cómo funciona AST

### Soporte
- Revisa los logs: Site administration → Reports → Logs
- Modo debug: Site administration → Development → Debugging

### Comunidad
- Foro de Moodle: https://moodle.org/mod/forum/
- Documentación de desarrollo: https://moodledev.io/

---

## ✅ Checklist de Instalación

- [ ] Descargar `dist/mod_aiassignment.zip`
- [ ] Iniciar sesión como administrador en Moodle
- [ ] Ir a Site administration → Plugins → Install plugins
- [ ] Subir el archivo ZIP
- [ ] Validar y continuar
- [ ] Actualizar base de datos
- [ ] Configurar OpenAI API Key
- [ ] Crear tarea de prueba
- [ ] Probar como estudiante
- [ ] Verificar evaluación automática
- [ ] Verificar detección de plagio

---

## 🎉 ¡Listo!

Tu plugin está instalado y funcionando con:
- ✅ Evaluación automática con AST
- ✅ Detección de plagio estructural
- ✅ Feedback instantáneo
- ✅ Dashboard para profesores

**Siguiente paso:** Crea tu primera tarea y prueba el sistema.

---

**Fecha:** Marzo 10, 2026  
**Versión del Plugin:** 2026031000  
**Moodle requerido:** 3.9+  
**PHP requerido:** 7.4+
