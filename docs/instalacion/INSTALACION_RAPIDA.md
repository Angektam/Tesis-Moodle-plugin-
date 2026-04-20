# ⚡ Instalación Rápida del Plugin en Moodle

## 🎯 Método Más Fácil (10 minutos)

### Paso 1: Crear ZIP (2 minutos)

**Windows:**
```bash
crear-zip-plugin.bat
```

**Linux/Mac:**
```bash
./crear-zip-plugin.sh
```

Esto creará `aiassignment.zip` en la raíz del proyecto.

---

### Paso 2: Instalar en Moodle (3 minutos)

1. **Inicia sesión** en Moodle como administrador

2. **Ve a instalación de plugins:**
   ```
   Site administration → Plugins → Install plugins
   ```
   
   O directamente:
   ```
   https://tu-moodle.com/admin/tool/installaddon/index.php
   ```

3. **Sube el ZIP:**
   - Click en "Choose a file"
   - Selecciona `aiassignment.zip`
   - Click en "Install plugin from the ZIP file"

4. **Confirma la instalación:**
   - Revisa la información del plugin
   - Click en "Continue"

5. **Actualiza la base de datos:**
   - Moodle te redirigirá a Notifications
   - Click en "Upgrade Moodle database now"
   - Espera a que termine

---

### Paso 3: Configurar API Key (2 minutos)

1. **Ve a configuración:**
   ```
   Site administration → Plugins → Activity modules → AI Assignment
   ```

2. **Ingresa tu API Key:**
   - OpenAI API Key: `sk-...`
   - OpenAI Model: `gpt-4o-mini` (recomendado)

3. **Guarda cambios**

---

### Paso 4: Probar (3 minutos)

1. **Ve a un curso** (o crea uno de prueba)

2. **Activa la edición:** "Turn editing on"

3. **Agrega actividad:**
   - Click en "Add an activity or resource"
   - Selecciona "AI Assignment"

4. **Configura un problema simple:**
   - Name: "Prueba IA"
   - Problem type: Mathematics
   - Problem statement: "Resuelve: 2x + 5 = 13"
   - Teacher solution: "x = 4"
   - Guarda

5. **Prueba como estudiante:**
   - Accede a la actividad
   - Envía respuesta: "2x = 8, x = 4"
   - Verifica que recibas evaluación automática

---

## ✅ ¡Listo!

El plugin está instalado y funcionando. Ahora puedes:

- Crear más problemas
- Probar con diferentes tipos de respuestas
- Revisar evaluaciones como profesor
- Ajustar configuración según necesites

---

## 📚 Documentación Completa

Para más detalles, consulta:

- **Instalación detallada:** `moodle-plugin/INSTALACION_DESDE_INTERFAZ.md`
- **Manual de usuario:** `moodle-plugin/MANUAL_USUARIO.md`
- **Solución de problemas:** Ver sección en INSTALACION_DESDE_INTERFAZ.md

---

## 🔧 Solución de Problemas Rápida

### "Plugin validation failed"
```bash
# Asegúrate de estar DENTRO de moodle-plugin/ al crear el ZIP
cd moodle-plugin
zip -r ../aiassignment.zip .
```

### "No API key configured"
```
Site administration → Plugins → Activity modules → AI Assignment
→ Ingresa tu OpenAI API Key
```

### "Cannot install plugin"
- Verifica que eres administrador del sitio
- Verifica permisos de escritura en el servidor

---

## 🎓 Alternativas

### Si no tienes Moodle instalado:

**Opción 1: Entorno de Prueba (5 minutos)**
```bash
cd test-environment
php demo-visual.php
```

**Opción 2: Instalar Moodle Local (30 minutos)**
- Ver: `GUIA_INSTALACION_MOODLE_LOCAL.md`
- Recomendado: Bitnami Moodle Stack

---

## 📞 Ayuda

- **Documentación completa:** `moodle-plugin/INSTALACION_DESDE_INTERFAZ.md`
- **Guía de inicio:** `COMO_EMPEZAR.md`
- **Logs de Moodle:** Site administration → Reports → Logs
