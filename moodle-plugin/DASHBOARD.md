# Dashboard del Profesor - AI Assignment

## 📊 Descripción

El Dashboard es una interfaz moderna y visual centralizada a nivel de curso que permite a los profesores monitorear el rendimiento de todos los estudiantes en todas las tareas AI Assignment del curso, ver estadísticas en tiempo real y gestionar los envíos de manera eficiente.

## ✨ Características Principales

### Dashboard Único por Curso
- **Un solo dashboard** para todas las tareas AI Assignment del curso
- Acceso desde cualquier tarea del curso
- Vista consolidada de todas las actividades

### 1. Tarjetas de Estadísticas Rápidas

Cuatro tarjetas principales que muestran métricas clave del curso completo:

- **Total de Tareas**: Número de actividades AI Assignment en el curso
- **Promedio de Calificaciones**: Calificación promedio de todos los envíos evaluados
- **Estudiantes Activos**: Número de estudiantes que han enviado al menos una respuesta
- **Evaluaciones Pendientes**: Envíos que aún no han sido evaluados

Cada tarjeta tiene:
- Animación al cargar
- Efecto hover con elevación
- Código de colores distintivo
- Icono representativo

### 2. Resumen de Tareas

Tabla que muestra todas las tareas AI Assignment del curso con:

- **Nombre de la tarea**: Con enlace a la actividad
- **Tipo**: Matemáticas o Programación
- **Envíos**: Número total de envíos recibidos
- **Promedio**: Calificación promedio con código de colores
- **Acciones**: Botón para ver todos los envíos de esa tarea

### 3. Envíos Recientes

Tabla interactiva que muestra los últimos 15 envíos de todas las tareas con:

- **Tarea**: Nombre de la tarea
- **Avatar del estudiante**: Foto de perfil (Gravatar o foto de Moodle)
- **Nombre completo**: Del estudiante que envió
- **Fecha y hora**: Cuándo se realizó el envío
- **Calificación**: Con código de colores:
  - 🟢 Verde (90-100%): Excelente
  - 🔵 Azul (80-89%): Bueno
  - 🟡 Amarillo (70-79%): Promedio
  - 🔴 Rojo (0-69%): Necesita mejorar
- **Acciones**: Botón para ver detalles del envío

Características:
- Efecto hover en las filas
- Responsive (se adapta a móviles)
- Muestra actividad reciente de todo el curso

### 4. Mejores Estudiantes (Top Performers)

Lista de los 10 mejores estudiantes basada en el promedio de sus calificaciones en todas las tareas:

- **Ranking**: Posición del estudiante (1-10)
  - Top 3 con badge dorado especial
- **Avatar**: Foto del estudiante
- **Nombre**: Nombre completo
- **Número de envíos**: Total de respuestas enviadas
- **Promedio**: Calificación promedio con código de colores

Características:
- Animación escalonada al cargar
- Efecto hover con desplazamiento
- Badge especial para top 3
- Muestra rendimiento global del estudiante

## 🎨 Diseño

### Paleta de Colores

```css
Primario (Azul):    #007bff
Éxito (Verde):      #28a745
Info (Cian):        #17a2b8
Advertencia (Amarillo): #ffc107
Peligro (Rojo):     #dc3545
Fondo:              #f5f5f5
Blanco:             #ffffff
Texto:              #333333
```

### Tipografía

- Títulos: 28px, peso 600
- Subtítulos: 20px, peso 600
- Números grandes: 36px, peso 700
- Texto normal: 14px

### Espaciado

- Padding de secciones: 25px
- Gap entre elementos: 20px
- Border radius: 12px
- Sombras suaves: 0 2px 8px rgba(0,0,0,0.1)

## 📱 Responsive

El dashboard se adapta a diferentes tamaños de pantalla:

### Desktop (>1024px)
- Layout de 2 columnas (2fr + 1fr)
- Tarjetas en grid de 4 columnas
- Tabla completa

### Tablet (768px - 1024px)
- Layout de 1 columna
- Tarjetas en grid adaptativo
- Tabla con scroll horizontal si es necesario

### Mobile (<768px)
- Layout de 1 columna
- Tarjetas apiladas verticalmente
- Tabla simplificada
- Fuentes más pequeñas

## 🚀 Acceso al Dashboard

### Para Profesores

1. Entrar a cualquier actividad AI Assignment del curso
2. Ver el botón "Dashboard" en la parte superior
3. Click para acceder al dashboard del curso completo

O directamente:
```
/mod/aiassignment/dashboard.php?courseid=[course_id]
```

### Permisos Requeridos

- `mod/aiassignment:grade` - Capacidad de calificar

Solo los usuarios con esta capacidad pueden ver el dashboard.

## 🔧 Archivos del Dashboard

```
moodle-plugin/
├── dashboard.php                    # Controlador principal (nivel curso)
├── styles/
│   └── dashboard.css               # Estilos CSS
├── amd/src/
│   └── dashboard.js                # JavaScript e interactividad
└── lang/
    ├── en/aiassignment.php         # Strings en inglés
    └── es/aiassignment.php         # Traducciones al español
```

## 📊 Funciones de Estadísticas (lib.php)

### Funciones Globales del Curso

#### `aiassignment_get_course_statistics($courseid)`
Obtiene estadísticas generales del curso:
- Total de envíos en todas las tareas
- Promedio de calificaciones global
- Estudiantes activos en el curso
- Evaluaciones pendientes totales

#### `aiassignment_get_course_recent_submissions($courseid, $limit)`
Obtiene los envíos más recientes de todas las tareas (por defecto 15).

#### `aiassignment_get_course_student_performance($courseid)`
Obtiene el rendimiento de cada estudiante en todas las tareas:
- Promedio de calificaciones global
- Número total de envíos
- Ordenado por promedio descendente

#### `aiassignment_get_assignments_overview($courseid)`
Obtiene resumen de todas las tareas del curso:
- Nombre y tipo de cada tarea
- Número de envíos por tarea
- Promedio de calificaciones por tarea

### Funciones por Tarea Individual

#### `aiassignment_get_statistics($assignmentid)`
Estadísticas de una tarea específica.

#### `aiassignment_get_recent_submissions($assignmentid, $limit)`
Envíos recientes de una tarea específica.

#### `aiassignment_get_student_performance($assignmentid)`
Rendimiento de estudiantes en una tarea específica.

#### `aiassignment_get_grade_class($grade)`
Retorna la clase CSS según la calificación:
- `grade-excellent` (90-100%)
- `grade-good` (80-89%)
- `grade-average` (70-79%)
- `grade-poor` (0-69%)

## 🎯 Casos de Uso

### 1. Monitoreo Global del Curso
El profesor entra al dashboard para ver rápidamente:
- ¿Cuántas tareas AI Assignment hay en el curso?
- ¿Cuál es el rendimiento general de los estudiantes?
- ¿Qué tareas tienen más actividad?

### 2. Identificar Estudiantes en Riesgo
Mirando la lista de mejores estudiantes, el profesor puede identificar:
- Estudiantes con bajo rendimiento global
- Estudiantes que necesitan ayuda adicional
- Estudiantes destacados para reconocimiento

### 3. Comparar Tareas
Ver el resumen de tareas para:
- Identificar tareas más difíciles (promedio bajo)
- Ver qué tareas tienen más participación
- Ajustar la dificultad de futuras tareas

### 4. Revisar Actividad Reciente
Ver los últimos envíos para:
- Monitorear actividad del curso
- Dar retroalimentación rápida
- Identificar problemas comunes

## 🔄 Actualizaciones en Tiempo Real

El dashboard NO se actualiza automáticamente. Para ver datos actualizados:
- Recargar la página (F5)
- Volver a entrar al dashboard

## 🎨 Personalización

### Cambiar Colores

Editar `styles/dashboard.css`:

```css
.stat-card-primary {
    color: #TU_COLOR;
}
```

### Cambiar Número de Envíos Recientes

Editar `dashboard.php`:

```php
$recent_submissions = aiassignment_get_course_recent_submissions($courseid, 20); // Cambiar de 15 a 20
```

### Cambiar Número de Top Performers

Editar `dashboard.php`:

```php
foreach (array_slice($student_performance, 0, 15) as $performance) // Cambiar de 10 a 15
```

## 🐛 Solución de Problemas

### El dashboard no carga
- Verificar que el usuario tenga el permiso `mod/aiassignment:grade`
- Verificar que el ID del curso sea correcto
- Revisar los logs de Moodle

### No hay datos
- Verificar que haya tareas AI Assignment en el curso
- Verificar que haya envíos en las tareas
- Verificar que los envíos estén evaluados

### Los estilos no se aplican
- Limpiar la caché de Moodle
- Verificar que `dashboard.css` esté en la ruta correcta
- Verificar permisos de archivos

## 📈 Ventajas del Dashboard Único

### Centralización
- Un solo lugar para ver todo
- No necesitas entrar a cada tarea individualmente
- Vista panorámica del curso completo

### Eficiencia
- Ahorra tiempo al profesor
- Identificación rápida de problemas
- Toma de decisiones informada

### Comparación
- Compara rendimiento entre tareas
- Identifica patrones globales
- Ve el progreso general del curso

## 📝 Diferencias con Dashboard Individual

### Antes (Dashboard por Tarea)
- Un dashboard por cada tarea
- Solo veías datos de esa tarea específica
- Necesitabas entrar a cada tarea para ver estadísticas

### Ahora (Dashboard del Curso)
- Un solo dashboard para todo el curso
- Ves datos de todas las tareas juntas
- Acceso desde cualquier tarea del curso
- Vista consolidada y comparativa

## 🎓 Inspiración

Este dashboard está inspirado en:
- [Alternate Admin for Moodle](https://github.com/ManuelGil/moodle-alternate-admin)
- Bootstrap 5 Admin Templates
- Modern SaaS dashboards
- Moodle Gradebook overview

## 📝 Licencia

GPL v3 (compatible con Moodle)

---

**Implementado por:** Kiro AI Assistant  
**Fecha:** 11 de Febrero de 2026  
**Versión:** 2.0.0 (Dashboard Único del Curso)


## ✨ Características

### 1. Tarjetas de Estadísticas Rápidas

Cuatro tarjetas principales que muestran métricas clave:

- **Total de Envíos**: Número total de respuestas enviadas por estudiantes
- **Promedio de Calificaciones**: Calificación promedio de todos los envíos evaluados
- **Estudiantes Activos**: Número de estudiantes que han enviado al menos una respuesta
- **Evaluaciones Pendientes**: Envíos que aún no han sido evaluados

Cada tarjeta tiene:
- Animación al cargar
- Efecto hover con elevación
- Código de colores distintivo
- Icono representativo

### 2. Envíos Recientes

Tabla interactiva que muestra los últimos 10 envíos con:

- **Avatar del estudiante**: Foto de perfil (Gravatar o foto de Moodle)
- **Nombre completo**: Del estudiante que envió
- **Fecha y hora**: Cuándo se realizó el envío
- **Número de intento**: Qué intento es (1, 2, 3, etc.)
- **Calificación**: Con código de colores:
  - 🟢 Verde (90-100%): Excelente
  - 🔵 Azul (80-89%): Bueno
  - 🟡 Amarillo (70-79%): Promedio
  - 🔴 Rojo (0-69%): Necesita mejorar
- **Acciones**: Botón para ver detalles del envío

Características:
- Efecto hover en las filas
- Enlace para ver todos los envíos
- Responsive (se adapta a móviles)

### 3. Distribución de Calificaciones

Gráfica de barras interactiva (Chart.js) que muestra:

- Distribución de calificaciones en rangos:
  - 90-100% (Verde)
  - 80-89% (Azul)
  - 70-79% (Amarillo)
  - 60-69% (Naranja)
  - 0-59% (Rojo)

Características:
- Animación suave al cargar
- Tooltips informativos al pasar el mouse
- Colores consistentes con el sistema de badges
- Responsive

### 4. Mejores Estudiantes (Top Performers)

Lista de los 5 mejores estudiantes basada en el promedio de sus calificaciones:

- **Ranking**: Posición del estudiante (1-5)
  - Top 3 con badge dorado especial
- **Avatar**: Foto del estudiante
- **Nombre**: Nombre completo
- **Promedio**: Calificación promedio con código de colores

Características:
- Animación escalonada al cargar
- Efecto hover con desplazamiento
- Badge especial para top 3

## 🎨 Diseño

### Paleta de Colores

```css
Primario (Azul):    #007bff
Éxito (Verde):      #28a745
Info (Cian):        #17a2b8
Advertencia (Amarillo): #ffc107
Peligro (Rojo):     #dc3545
Fondo:              #f5f5f5
Blanco:             #ffffff
Texto:              #333333
```

### Tipografía

- Títulos: 28px, peso 600
- Subtítulos: 20px, peso 600
- Números grandes: 36px, peso 700
- Texto normal: 14px

### Espaciado

- Padding de secciones: 25px
- Gap entre elementos: 20px
- Border radius: 12px
- Sombras suaves: 0 2px 8px rgba(0,0,0,0.1)

## 📱 Responsive

El dashboard se adapta a diferentes tamaños de pantalla:

### Desktop (>1024px)
- Layout de 2 columnas (2fr + 1fr)
- Tarjetas en grid de 4 columnas
- Tabla completa

### Tablet (768px - 1024px)
- Layout de 1 columna
- Tarjetas en grid adaptativo
- Tabla con scroll horizontal si es necesario

### Mobile (<768px)
- Layout de 1 columna
- Tarjetas apiladas verticalmente
- Tabla simplificada
- Fuentes más pequeñas

## 🚀 Acceso al Dashboard

### Para Profesores

1. Entrar a una actividad AI Assignment
2. Ver el botón "Dashboard" en la parte superior
3. Click para acceder

O directamente:
```
/mod/aiassignment/dashboard.php?id=[course_module_id]
```

### Permisos Requeridos

- `mod/aiassignment:grade` - Capacidad de calificar

Solo los usuarios con esta capacidad pueden ver el dashboard.

## 🔧 Archivos del Dashboard

```
moodle-plugin/
├── dashboard.php                    # Controlador principal
├── styles/
│   └── dashboard.css               # Estilos CSS
├── amd/src/
│   └── dashboard.js                # JavaScript e interactividad
└── lang/
    ├── en/aiassignment.php         # Strings en inglés
    └── es/aiassignment.php         # Strings en español
```

## 📊 Funciones de Estadísticas (lib.php)

### `aiassignment_get_statistics($assignmentid)`
Obtiene estadísticas generales:
- Total de envíos
- Promedio de calificaciones
- Estudiantes activos
- Evaluaciones pendientes

### `aiassignment_get_recent_submissions($assignmentid, $limit)`
Obtiene los envíos más recientes (por defecto 10).

### `aiassignment_get_student_performance($assignmentid)`
Obtiene el rendimiento de cada estudiante:
- Promedio de calificaciones
- Número de envíos
- Ordenado por promedio descendente

### `aiassignment_get_grade_distribution($assignmentid)`
Obtiene todas las calificaciones para la gráfica de distribución.

### `aiassignment_get_grade_class($grade)`
Retorna la clase CSS según la calificación:
- `grade-excellent` (90-100%)
- `grade-good` (80-89%)
- `grade-average` (70-79%)
- `grade-poor` (0-69%)

## 🎯 Casos de Uso

### 1. Monitoreo Rápido
El profesor entra al dashboard para ver rápidamente:
- ¿Cuántos estudiantes han participado?
- ¿Cuál es el rendimiento general?
- ¿Hay evaluaciones pendientes?

### 2. Identificar Estudiantes en Riesgo
Mirando la distribución de calificaciones y la lista de mejores estudiantes, el profesor puede identificar:
- Estudiantes con bajo rendimiento
- Estudiantes que necesitan ayuda adicional

### 3. Revisar Envíos Recientes
Ver los últimos envíos para:
- Dar retroalimentación rápida
- Identificar problemas comunes
- Responder preguntas

### 4. Análisis de Rendimiento
Usar las estadísticas para:
- Evaluar la dificultad del problema
- Ajustar la enseñanza
- Identificar áreas de mejora

## 🔄 Actualizaciones en Tiempo Real

El dashboard NO se actualiza automáticamente. Para ver datos actualizados:
- Recargar la página (F5)
- Volver a entrar al dashboard

## 🎨 Personalización

### Cambiar Colores

Editar `styles/dashboard.css`:

```css
.stat-card-primary {
    color: #TU_COLOR;
}
```

### Cambiar Número de Envíos Recientes

Editar `dashboard.php`:

```php
$recent_submissions = aiassignment_get_recent_submissions($aiassignment->id, 20); // Cambiar de 10 a 20
```

### Cambiar Número de Top Performers

Editar `dashboard.php`:

```php
foreach (array_slice($student_performance, 0, 10) as $performance) // Cambiar de 5 a 10
```

## 🐛 Solución de Problemas

### El dashboard no carga
- Verificar que el usuario tenga el permiso `mod/aiassignment:grade`
- Verificar que el ID del módulo sea correcto
- Revisar los logs de Moodle

### La gráfica no se muestra
- Verificar que Chart.js se cargue correctamente
- Verificar la consola del navegador para errores JavaScript
- Verificar que haya datos de calificaciones

### Los estilos no se aplican
- Limpiar la caché de Moodle
- Verificar que `dashboard.css` esté en la ruta correcta
- Verificar permisos de archivos

### No hay datos
- Verificar que haya envíos en la tarea
- Verificar que los envíos estén evaluados
- Verificar las consultas SQL en las funciones

## 📈 Mejoras Futuras

Posibles mejoras para el dashboard:

1. **Actualización en Tiempo Real**
   - WebSockets o polling para actualizar sin recargar

2. **Más Gráficas**
   - Gráfica de línea: Envíos por día
   - Gráfica de pastel: Tipos de errores comunes
   - Gráfica de área: Progreso de estudiantes

3. **Filtros**
   - Filtrar por fecha
   - Filtrar por estudiante
   - Filtrar por rango de calificación

4. **Exportación**
   - Exportar estadísticas a CSV
   - Exportar gráficas como imagen
   - Generar reportes PDF

5. **Comparación**
   - Comparar con otras tareas
   - Comparar con promedios del curso
   - Tendencias históricas

6. **Notificaciones**
   - Alertas de bajo rendimiento
   - Notificaciones de nuevos envíos
   - Recordatorios de evaluaciones pendientes

## 🎓 Inspiración

Este dashboard está inspirado en:
- [Alternate Admin for Moodle](https://github.com/ManuelGil/moodle-alternate-admin)
- Bootstrap 5 Admin Templates
- Modern dashboard designs

## 📝 Licencia

GPL v3 (compatible con Moodle)

