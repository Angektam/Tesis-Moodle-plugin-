# Diferencias entre "Plugin" y "Mod" en Moodle

## 🤔 Aclaración Importante

**"Mod" ES un tipo de "Plugin"**

En Moodle, **"plugin"** es el término general para cualquier extensión, y **"mod"** es un tipo específico de plugin.

```
Plugin (término general)
├── mod (Activity modules)
├── repository (Repository plugins)
├── block (Block plugins)
├── theme (Theme plugins)
├── local (Local plugins)
└── ... (muchos más tipos)
```

## 📊 Comparación Detallada

### 1. TERMINOLOGÍA

| Término | Significado |
|---------|-------------|
| **Plugin** | Cualquier extensión de Moodle (término genérico) |
| **Mod** | Plugin de tipo "Activity Module" (tipo específico) |
| **Repository** | Plugin de tipo "Repository" (tipo específico) |

**Analogía:**
- "Plugin" = "Vehículo" (genérico)
- "Mod" = "Automóvil" (específico)
- "Repository" = "Motocicleta" (específico)

---

## 🎯 Nuestros Dos Plugins

### Plugin 1: Activity Module (mod)
**Nombre:** `mod_aiassignment`
**Ubicación:** `moodle/mod/aiassignment/`
**Tipo de plugin:** Activity Module

### Plugin 2: Repository
**Nombre:** `repository_aisolutions`
**Ubicación:** `moodle/repository/aisolutions/`
**Tipo de plugin:** Repository

---

## 📋 Diferencias Técnicas

### UBICACIÓN EN EL SISTEMA

#### Activity Module (mod)
```
moodle/
└── mod/
    └── aiassignment/
        ├── version.php
        ├── lib.php
        ├── mod_form.php
        ├── view.php
        └── ...
```

#### Repository Plugin
```
moodle/
└── repository/
    └── aisolutions/
        ├── version.php
        ├── lib.php (clase repository_aisolutions)
        └── ...
```

---

### COMPONENTE EN version.php

#### Activity Module (mod)
```php
$plugin->component = 'mod_aiassignment';
```

#### Repository Plugin
```php
$plugin->component = 'repository_aisolutions';
```

---

### CLASE PRINCIPAL EN lib.php

#### Activity Module (mod)
```php
// Funciones globales
function aiassignment_add_instance($data) { }
function aiassignment_update_instance($data) { }
function aiassignment_delete_instance($id) { }
function aiassignment_supports($feature) { }
```

#### Repository Plugin
```php
// Clase que extiende repository
class repository_aisolutions extends repository {
    public function get_listing($path = '') { }
    public function search($search_text) { }
    public function get_file($source) { }
}
```

---

### ARCHIVOS PRINCIPALES

#### Activity Module (mod)
```
✅ lib.php              - Funciones del módulo
✅ mod_form.php         - Formulario de configuración
✅ view.php             - Vista principal
✅ submit.php           - Procesar envíos
✅ index.php            - Lista de instancias
✅ grade.php            - Calificaciones
```

#### Repository Plugin
```
✅ lib.php              - Clase repository_aisolutions
❌ mod_form.php         - NO existe
❌ view.php             - NO existe
❌ submit.php           - NO existe
❌ grade.php            - NO existe
```

---

### BASE DE DATOS

#### Activity Module (mod)
```sql
-- Tabla principal
mdl_aiassignment (
    id, course, name, intro, type, solution, grade, ...
)

-- Tabla de envíos
mdl_aiassignment_submissions (
    id, assignment, userid, answer, score, ...
)

-- Tabla de evaluaciones
mdl_aiassignment_evaluations (
    id, submission, similarity_score, ai_feedback, ...
)
```

#### Repository Plugin
```sql
-- Tabla de archivos/soluciones
mdl_repository_aisolutions (
    id, userid, title, content, type, ai_score, ...
)
```

---

### CAPACIDADES (PERMISOS)

#### Activity Module (mod)
```php
'mod/aiassignment:addinstance'  // Crear actividad
'mod/aiassignment:view'         // Ver actividad
'mod/aiassignment:submit'       // Enviar respuesta
'mod/aiassignment:grade'        // Calificar
'mod/aiassignment:viewgrades'   // Ver calificaciones
```

#### Repository Plugin
```php
'repository/aisolutions:view'   // Ver repositorio
```

---

### STRINGS DE IDIOMA

#### Activity Module (mod)
```
lang/en/aiassignment.php
lang/es/aiassignment.php
```

#### Repository Plugin
```
lang/en/repository_aisolutions.php
lang/es/repository_aisolutions.php
```

---

## 🎨 Diferencias de Interfaz de Usuario

### Activity Module (mod)

#### Dónde aparece:
```
Curso > Activar edición > Agregar una actividad o recurso
└── AI Assignment ⭐
```

#### Qué ve el profesor:
1. Formulario para crear tarea
2. Configurar problema y solución
3. Ver todos los envíos de estudiantes
4. Calificar manualmente (opcional)

#### Qué ve el estudiante:
1. Descripción del problema
2. Formulario para enviar respuesta (texto)
3. Ver sus envíos previos
4. Ver calificaciones y retroalimentación

---

### Repository Plugin

#### Dónde aparece:
```
Cualquier selector de archivos en Moodle
└── AI Solutions ⭐
```

#### Qué ve el usuario:
1. Lista de archivos/soluciones
2. Buscar archivos
3. Seleccionar archivo para usar
4. (No hay formularios de configuración complejos)

---

## 💡 Casos de Uso

### Activity Module (mod) - Para:

✅ **Crear tareas educativas**
```
Profesor crea: "Resolver ecuación cuadrática"
Estudiante envía: Su solución en texto
IA evalúa: Compara con solución del profesor
Resultado: Calificación automática
```

✅ **Evaluación automática**
```
Entrada: Respuesta del estudiante (texto)
Proceso: IA compara con solución de referencia
Salida: Calificación (0-100) + retroalimentación
```

✅ **Gestión de calificaciones**
```
Calificaciones → Libro de calificaciones de Moodle
Reportes → Estadísticas de rendimiento
Intentos → Control de intentos máximos
```

---

### Repository Plugin - Para:

✅ **Almacenar archivos**
```
Usuario sube: archivo.py
Sistema guarda: En base de datos
Usuario accede: Desde selector de archivos
```

✅ **Biblioteca de recursos**
```
Profesor sube: Soluciones de ejemplo
Estudiantes acceden: Desde cualquier actividad
Uso: Como referencia o plantilla
```

✅ **Análisis de archivos (opcional)**
```
Usuario sube: código.py
IA analiza: Calidad del código
Sistema guarda: Score y análisis
```

---

## 🔄 ¿Pueden trabajar juntos?

**¡SÍ! Pueden complementarse:**

### Escenario de uso combinado:

1. **Profesor usa Repository Plugin:**
   - Sube soluciones de ejemplo a `repository_aisolutions`
   - Organiza biblioteca de código reutilizable

2. **Profesor usa Activity Module:**
   - Crea tarea con `mod_aiassignment`
   - Puede referenciar archivos del repositorio
   - Configura evaluación automática

3. **Estudiante:**
   - Ve ejemplos desde el repositorio (opcional)
   - Envía su respuesta en la actividad
   - Recibe evaluación automática con IA

---

## 📊 Tabla Comparativa Completa

| Característica | Activity Module (mod) | Repository Plugin |
|----------------|----------------------|-------------------|
| **Ubicación** | `moodle/mod/` | `moodle/repository/` |
| **Componente** | `mod_aiassignment` | `repository_aisolutions` |
| **Aparece en** | "Agregar actividad" | Selector de archivos |
| **Propósito** | Actividad educativa | Almacenamiento de archivos |
| **Tipo de entrada** | Texto (respuestas) | Archivos |
| **Calificaciones** | ✅ Sí, automáticas | ❌ No |
| **Libro de calificaciones** | ✅ Integrado | ❌ No |
| **Envíos de estudiantes** | ✅ Sí | ❌ No |
| **Formulario de configuración** | ✅ Complejo (mod_form.php) | ❌ Mínimo |
| **Vista principal** | ✅ view.php | ❌ No tiene |
| **Evaluación con IA** | ✅ Automática | ⚠️ Opcional |
| **Control de intentos** | ✅ Sí | ❌ No |
| **Retroalimentación** | ✅ Detallada | ❌ No |
| **Permisos** | 5 capacidades | 1 capacidad |
| **Tablas de BD** | 3 tablas | 1 tabla |
| **Complejidad** | Alta | Media |
| **Casos de uso** | Tareas, exámenes, evaluaciones | Biblioteca, recursos, archivos |

---

## 🎯 ¿Cuál usar?

### Usa Activity Module (mod) si necesitas:
✅ Crear actividades educativas
✅ Que estudiantes envíen respuestas de texto
✅ Evaluación automática con IA
✅ Calificaciones en el libro de calificaciones
✅ Control de intentos y fechas límite
✅ Retroalimentación detallada

### Usa Repository Plugin si necesitas:
✅ Almacenar archivos de soluciones
✅ Biblioteca de código/documentos
✅ Compartir recursos entre cursos
✅ Analizar archivos con IA (opcional)
✅ Integración con selector de archivos

### Usa AMBOS si necesitas:
✅ Todo lo anterior
✅ Actividades educativas + biblioteca de recursos
✅ Evaluación automática + ejemplos de referencia

---

## 🚀 Recomendación para tu Proyecto

Para un **"Sistema de Evaluación de Tareas con IA"**, el **Activity Module (mod)** es la opción principal y correcta.

El **Repository Plugin** es opcional y complementario, útil solo si quieres agregar una biblioteca de soluciones.

---

## 📝 Resumen en una frase

**"Mod" es un tipo específico de "Plugin" para crear actividades educativas, mientras que "Repository" es otro tipo de "Plugin" para gestionar archivos.**

---

## 🔗 Documentación Oficial

### Activity Modules (mod):
https://moodledev.io/docs/apis/plugintypes/mod

### Repository Plugins:
https://moodledev.io/docs/apis/plugintypes/repository

### Todos los tipos de plugins:
https://moodledev.io/docs/apis/plugintypes
