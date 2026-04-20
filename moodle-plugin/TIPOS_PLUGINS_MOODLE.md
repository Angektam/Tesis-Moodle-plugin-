# Tipos de Plugins en Moodle

## 🔍 Diferencia entre Tipos de Plugins

### 📚 Nuestro Plugin: **mod** (Activity Module)
**Ubicación:** `moodle/mod/aiassignment/`
**Propósito:** Agregar nuevas actividades a los cursos
**Ejemplos:** Forum, Quiz, Assignment, Workshop
**Nuestro caso:** AI Assignment (evaluación con IA)

### 📁 Repository Plugin (el enlace que compartiste)
**Ubicación:** `moodle/repository/`
**Propósito:** Conectar con sistemas de almacenamiento de archivos
**Ejemplos:** Google Drive, Dropbox, OneDrive, Local files
**Uso:** Subir/descargar archivos desde fuentes externas

---

## 📋 Tipos de Plugins en Moodle

### 1. **mod** - Activity Modules ⭐ (Nuestro tipo)
**Ruta:** `moodle/mod/[pluginname]/`
**Propósito:** Actividades que los profesores agregan a los cursos
**Ejemplos:**
- `mod_forum` - Foros de discusión
- `mod_quiz` - Cuestionarios
- `mod_assign` - Tareas
- `mod_aiassignment` - ⭐ Nuestro plugin

**Características:**
- Aparecen en "Agregar una actividad"
- Tienen calificaciones
- Pueden tener envíos de estudiantes
- Se integran con el libro de calificaciones

**Documentación oficial:**
https://moodledev.io/docs/apis/plugintypes/mod

---

### 2. **repository** - Repository Plugins
**Ruta:** `moodle/repository/[pluginname]/`
**Propósito:** Conectar con sistemas de archivos externos
**Ejemplos:**
- `repository_googledrive` - Google Drive
- `repository_dropbox` - Dropbox
- `repository_filesystem` - Sistema de archivos local

**Uso:** Cuando un usuario hace clic en "Agregar archivo" en Moodle

**Documentación oficial:**
https://moodledev.io/docs/apis/plugintypes/repository

---

### 3. **block** - Block Plugins
**Ruta:** `moodle/blocks/[pluginname]/`
**Propósito:** Bloques que se agregan a las columnas laterales
**Ejemplos:**
- `block_calendar_month` - Calendario
- `block_recent_activity` - Actividad reciente
- `block_navigation` - Navegación

---

### 4. **theme** - Theme Plugins
**Ruta:** `moodle/theme/[pluginname]/`
**Propósito:** Cambiar la apariencia de Moodle
**Ejemplos:**
- `theme_boost` - Tema predeterminado
- `theme_classic` - Tema clásico

---

### 5. **local** - Local Plugins
**Ruta:** `moodle/local/[pluginname]/`
**Propósito:** Funcionalidades personalizadas que no encajan en otros tipos
**Ejemplos:**
- Integraciones personalizadas
- Reportes personalizados
- Herramientas administrativas

---

### 6. **auth** - Authentication Plugins
**Ruta:** `moodle/auth/[pluginname]/`
**Propósito:** Métodos de autenticación
**Ejemplos:**
- `auth_ldap` - LDAP
- `auth_oauth2` - OAuth2
- `auth_saml2` - SAML2

---

### 7. **enrol** - Enrolment Plugins
**Ruta:** `moodle/enrol/[pluginname]/`
**Propósito:** Métodos de inscripción a cursos
**Ejemplos:**
- `enrol_manual` - Inscripción manual
- `enrol_self` - Auto-inscripción
- `enrol_paypal` - PayPal

---

### 8. **filter** - Filter Plugins
**Ruta:** `moodle/filter/[pluginname]/`
**Propósito:** Filtrar y transformar contenido
**Ejemplos:**
- `filter_mathjaxloader` - Renderizar fórmulas matemáticas
- `filter_emoticon` - Convertir texto en emoticonos

---

### 9. **editor** - Text Editor Plugins
**Ruta:** `moodle/lib/editor/[pluginname]/`
**Propósito:** Editores de texto
**Ejemplos:**
- `editor_atto` - Editor Atto
- `editor_tiny` - Editor TinyMCE

---

### 10. **qtype** - Question Type Plugins
**Ruta:** `moodle/question/type/[pluginname]/`
**Propósito:** Tipos de preguntas para cuestionarios
**Ejemplos:**
- `qtype_multichoice` - Opción múltiple
- `qtype_essay` - Ensayo
- `qtype_truefalse` - Verdadero/Falso

---

### 11. **report** - Report Plugins
**Ruta:** `moodle/report/[pluginname]/`
**Propósito:** Reportes y estadísticas
**Ejemplos:**
- `report_log` - Logs
- `report_stats` - Estadísticas

---

### 12. **tool** - Admin Tools
**Ruta:** `moodle/admin/tool/[pluginname]/`
**Propósito:** Herramientas administrativas
**Ejemplos:**
- `tool_dataprivacy` - Privacidad de datos
- `tool_mobile` - Configuración móvil

---

## 🎯 ¿Por qué nuestro plugin es "mod"?

Nuestro plugin **AI Assignment** es un **Activity Module (mod)** porque:

✅ **Es una actividad** que los profesores agregan a los cursos
✅ **Tiene envíos** de estudiantes
✅ **Genera calificaciones** que van al libro de calificaciones
✅ **Tiene una vista** para estudiantes y profesores
✅ **Se configura** por el profesor al crearlo

---

## 📊 Comparación: mod vs repository

| Característica | mod (Activity) | repository (Files) |
|----------------|----------------|-------------------|
| **Propósito** | Actividad educativa | Almacenamiento de archivos |
| **Ubicación** | `mod/` | `repository/` |
| **Aparece en** | "Agregar actividad" | "Selector de archivos" |
| **Calificaciones** | ✅ Sí | ❌ No |
| **Envíos** | ✅ Sí | ❌ No |
| **Ejemplo** | Quiz, Assignment | Google Drive, Dropbox |
| **Nuestro caso** | ✅ AI Assignment | ❌ No aplica |

---

## 🔗 Documentación Oficial de Moodle

### Para nuestro plugin (mod):
- **Plugin types - Activity modules:** https://moodledev.io/docs/apis/plugintypes/mod
- **Activity modules API:** https://moodledev.io/docs/apis/core/activity
- **Grading API:** https://moodledev.io/docs/apis/core/grading

### Otras referencias útiles:
- **Plugin types overview:** https://moodledev.io/docs/apis/plugintypes
- **Plugin development:** https://moodledev.io/docs/guides/plugintypes
- **Database API:** https://moodledev.io/docs/apis/core/dml
- **Events API:** https://moodledev.io/docs/apis/core/events

---

## 🚀 Si quisieras crear otros tipos de plugins

### Ejemplo 1: Repository Plugin para IA
Si quisieras crear un plugin para **almacenar archivos en un servicio de IA**:
- Tipo: `repository`
- Ubicación: `moodle/repository/aifiles/`
- Uso: Conectar con un servicio de almacenamiento basado en IA

### Ejemplo 2: Block Plugin para Estadísticas de IA
Si quisieras crear un **bloque lateral con estadísticas de IA**:
- Tipo: `block`
- Ubicación: `moodle/blocks/aistats/`
- Uso: Mostrar estadísticas de uso de IA en la barra lateral

### Ejemplo 3: Local Plugin para Integración
Si quisieras crear una **integración personalizada con servicios de IA**:
- Tipo: `local`
- Ubicación: `moodle/local/aiintegration/`
- Uso: Funcionalidades que no encajan en otros tipos

---

## ✅ Conclusión

Nuestro plugin **AI Assignment** es correctamente un **Activity Module (mod)** porque:

1. Es una actividad educativa
2. Los profesores lo agregan a sus cursos
3. Los estudiantes envían respuestas
4. Genera calificaciones automáticas
5. Se integra con el libro de calificaciones de Moodle

El enlace que compartiste sobre **repository plugins** es para un tipo diferente de plugin que se usa para conectar con sistemas de almacenamiento de archivos externos (como Google Drive, Dropbox, etc.), lo cual no es nuestro caso.

---

## 📚 Recursos Adicionales

### Documentación oficial de Activity Modules:
```
https://moodledev.io/docs/apis/plugintypes/mod
```

### Ejemplos de Activity Modules en Moodle:
- Forum: `moodle/mod/forum/`
- Assignment: `moodle/mod/assign/`
- Quiz: `moodle/mod/quiz/`
- Workshop: `moodle/mod/workshop/`

Puedes estudiar estos plugins para ver cómo implementan características similares.
