# Vista Previa del Plugin AI Assignment

## 🎨 Cómo se verá el plugin en Moodle

### 1. Vista del Profesor - Crear Tarea

Cuando un profesor agrega la actividad "AI Assignment", verá este formulario:

```
┌─────────────────────────────────────────────────────────────┐
│ Agregar AI Assignment                                        │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│ General                                                      │
│ ─────────────────────────────────────────────────────────   │
│                                                              │
│ Nombre de la tarea: *                                       │
│ ┌──────────────────────────────────────────────────────┐   │
│ │ Resolver Ecuación Cuadrática                         │   │
│ └──────────────────────────────────────────────────────┘   │
│                                                              │
│ Descripción:                                                │
│ ┌──────────────────────────────────────────────────────┐   │
│ │ Resuelve la siguiente ecuación cuadrática:           │   │
│ │ x² - 5x + 6 = 0                                      │   │
│ │ Muestra todos los pasos de tu solución.             │   │
│ └──────────────────────────────────────────────────────┘   │
│                                                              │
│ Configuración del problema                                  │
│ ─────────────────────────────────────────────────────────   │
│                                                              │
│ Tipo de problema: *                                         │
│ ┌──────────────────────────────────────────────────────┐   │
│ │ ▼ Matemáticas                                        │   │
│ └──────────────────────────────────────────────────────┘   │
│                                                              │
│ Solución de referencia: * [?]                               │
│ ┌──────────────────────────────────────────────────────┐   │
│ │ x² - 5x + 6 = 0                                      │   │
│ │ Factorizando: (x - 2)(x - 3) = 0                    │   │
│ │ Por lo tanto: x = 2 o x = 3                         │   │
│ └──────────────────────────────────────────────────────┘   │
│                                                              │
│ Documentación adicional: [?]                                │
│ ┌──────────────────────────────────────────────────────┐   │
│ │ Recuerda usar la fórmula general o factorización    │   │
│ └──────────────────────────────────────────────────────┘   │
│                                                              │
│ Casos de prueba: [?]                                        │
│ ┌──────────────────────────────────────────────────────┐   │
│ │ Verifica: (2)² - 5(2) + 6 = 0 ✓                     │   │
│ │ Verifica: (3)² - 5(3) + 6 = 0 ✓                     │   │
│ └──────────────────────────────────────────────────────┘   │
│                                                              │
│ Configuración de calificación                               │
│ ─────────────────────────────────────────────────────────   │
│                                                              │
│ Calificación: ┌────┐                                        │
│               │100 │ / 100                                  │
│               └────┘                                         │
│                                                              │
│ Intentos máximos: [?]                                       │
│ ┌────┐ (0 = ilimitado)                                     │
│ │ 3  │                                                      │
│ └────┘                                                      │
│                                                              │
│ [Guardar y mostrar] [Guardar y regresar] [Cancelar]        │
└─────────────────────────────────────────────────────────────┘
```

### 2. Vista del Estudiante - Ver Tarea

Cuando un estudiante accede a la tarea:

```
┌─────────────────────────────────────────────────────────────┐
│ Curso: Matemáticas 101 > Resolver Ecuación Cuadrática      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│ Resolver Ecuación Cuadrática                                │
│ ═══════════════════════════════════════════════════════════ │
│                                                              │
│ Resuelve la siguiente ecuación cuadrática:                  │
│ x² - 5x + 6 = 0                                             │
│ Muestra todos los pasos de tu solución.                     │
│                                                              │
├─────────────────────────────────────────────────────────────┤
│ Descripción del problema                                    │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│ Tipo: Matemáticas                                           │
│                                                              │
│ Documentación                                               │
│ ┌──────────────────────────────────────────────────────┐   │
│ │ Recuerda usar la fórmula general o factorización    │   │
│ └──────────────────────────────────────────────────────┘   │
│                                                              │
│ Casos de prueba                                             │
│ ┌──────────────────────────────────────────────────────┐   │
│ │ Verifica: (2)² - 5(2) + 6 = 0 ✓                     │   │
│ │ Verifica: (3)² - 5(3) + 6 = 0 ✓                     │   │
│ └──────────────────────────────────────────────────────┘   │
│                                                              │
├─────────────────────────────────────────────────────────────┤
│ Enviar tu respuesta                                         │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│ Intentos restantes: 3                                       │
│                                                              │
│ ┌──────────────────────────────────────────────────────┐   │
│ │                                                      │   │
│ │ Escribe tu respuesta aquí...                        │   │
│ │                                                      │   │
│ │                                                      │   │
│ │                                                      │   │
│ │                                                      │   │
│ │                                                      │   │
│ │                                                      │   │
│ │                                                      │   │
│ │                                                      │   │
│ └──────────────────────────────────────────────────────┘   │
│                                                              │
│                          [Enviar]                           │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### 3. Vista del Estudiante - Después de Enviar

Después de que el estudiante envía su respuesta:

```
┌─────────────────────────────────────────────────────────────┐
│ ✓ Tu respuesta ha sido enviada y será evaluada             │
│   automáticamente                                           │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│ Tus envíos                                                  │
│ ═══════════════════════════════════════════════════════════ │
│                                                              │
│ ┌──────────────────────────────────────────────────────┐   │
│ │ Envío #1                                             │   │
│ │ ─────────────────────────────────────────────────    │   │
│ │                                                      │   │
│ │ Enviado: 6 de febrero de 2026, 10:30 AM            │   │
│ │                                                      │   │
│ │ Calificación: 85%                                   │   │
│ │ ████████████████████░░░░░░░░                        │   │
│ │                                                      │   │
│ │ Retroalimentación:                                  │   │
│ │ Tu solución es correcta. Has identificado          │   │
│ │ correctamente las raíces x=2 y x=3. El método      │   │
│ │ de factorización está bien aplicado. Podrías       │   │
│ │ mejorar mostrando la verificación de las           │   │
│ │ soluciones.                                         │   │
│ │                                                      │   │
│ │ [Ver detalles]                                      │   │
│ └──────────────────────────────────────────────────────┘   │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### 4. Vista Detallada del Envío

Al hacer clic en "Ver detalles":

```
┌─────────────────────────────────────────────────────────────┐
│ Detalle del Envío                                           │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│ Información del Envío                                       │
│ ─────────────────────────────────────────────────────────   │
│                                                              │
│ Estudiante: Juan Pérez                                      │
│ Fecha: 6 de febrero de 2026, 10:30 AM                      │
│ Intento: 1 de 3                                             │
│                                                              │
│ Tu Respuesta                                                │
│ ─────────────────────────────────────────────────────────   │
│ ┌──────────────────────────────────────────────────────┐   │
│ │ x² - 5x + 6 = 0                                      │   │
│ │ Factorizando: (x - 2)(x - 3) = 0                    │   │
│ │ x - 2 = 0  →  x = 2                                 │   │
│ │ x - 3 = 0  →  x = 3                                 │   │
│ │ Las soluciones son x = 2 y x = 3                    │   │
│ └──────────────────────────────────────────────────────┘   │
│                                                              │
│ Evaluación                                                  │
│ ─────────────────────────────────────────────────────────   │
│                                                              │
│ Calificación: 85/100                                        │
│ ████████████████████░░░░░░░░                                │
│                                                              │
│ 📝 Retroalimentación de IA                                  │
│ ┌──────────────────────────────────────────────────────┐   │
│ │ Tu solución es correcta. Has identificado          │   │
│ │ correctamente las raíces x=2 y x=3. El método      │   │
│ │ de factorización está bien aplicado. Podrías       │   │
│ │ mejorar mostrando la verificación de las           │   │
│ │ soluciones.                                         │   │
│ └──────────────────────────────────────────────────────┘   │
│                                                              │
│ 🔍 Análisis Detallado                                       │
│ ┌──────────────────────────────────────────────────────┐   │
│ │ Aspectos Positivos:                                 │   │
│ │ • Identificación correcta de las raíces             │   │
│ │ • Uso apropiado del método de factorización         │   │
│ │ • Presentación clara de los pasos                   │   │
│ │                                                      │   │
│ │ Áreas de Mejora:                                    │   │
│ │ • Agregar verificación sustituyendo en la          │   │
│ │   ecuación original                                 │   │
│ │ • Mencionar que estas son las únicas soluciones    │   │
│ │   reales                                            │   │
│ └──────────────────────────────────────────────────────┘   │
│                                                              │
│ [← Volver]                                                  │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### 5. Vista del Profesor - Dashboard

El profesor puede ver todos los envíos:

```
┌─────────────────────────────────────────────────────────────┐
│ Resolver Ecuación Cuadrática - Todos los Envíos            │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│ Filtros: [Todos] [Evaluados] [Pendientes]                  │
│                                                              │
│ ┌──────────────────────────────────────────────────────┐   │
│ │ Estudiante      │ Fecha      │ Intento │ Calif. │    │   │
│ │─────────────────┼────────────┼─────────┼────────┤    │   │
│ │ Juan Pérez      │ 06/02 10:30│   1/3   │  85%   │ 👁  │   │
│ │ María García    │ 06/02 11:15│   2/3   │  92%   │ 👁  │   │
│ │ Pedro López     │ 06/02 12:00│   1/3   │  78%   │ 👁  │   │
│ │ Ana Martínez    │ 06/02 13:45│   3/3   │  95%   │ 👁  │   │
│ │ Carlos Ruiz     │ 06/02 14:20│   1/3   │ Pend.  │ 👁  │   │
│ └──────────────────────────────────────────────────────┘   │
│                                                              │
│ Estadísticas:                                               │
│ • Total de envíos: 5                                        │
│ • Promedio: 87.5%                                           │
│ • Evaluados: 4                                              │
│ • Pendientes: 1                                             │
│                                                              │
│ [Exportar calificaciones] [Actualizar]                      │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### 6. Integración con Libro de Calificaciones

Las calificaciones se sincronizan automáticamente:

```
┌─────────────────────────────────────────────────────────────┐
│ Libro de Calificaciones - Matemáticas 101                  │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│ Estudiante      │ Tarea 1 │ AI Assignment │ Examen │ Total │
│─────────────────┼─────────┼───────────────┼────────┼───────┤
│ Juan Pérez      │   90    │      85       │   88   │  87.7 │
│ María García    │   85    │      92       │   90   │  89.0 │
│ Pedro López     │   88    │      78       │   85   │  83.7 │
│ Ana Martínez    │   92    │      95       │   94   │  93.7 │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### 7. Configuración del Plugin (Admin)

Vista de administrador:

```
┌─────────────────────────────────────────────────────────────┐
│ Administración del Sitio > Plugins > AI Assignment          │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│ Configuración de OpenAI                                     │
│ ─────────────────────────────────────────────────────────   │
│                                                              │
│ Clave API de OpenAI: *                                      │
│ ┌──────────────────────────────────────────────────────┐   │
│ │ sk-proj-••••••••••••••••••••••••••••••••••••••••    │   │
│ └──────────────────────────────────────────────────────┘   │
│ ℹ️ Ingrese su clave API de OpenAI para la evaluación       │
│    automática                                               │
│                                                              │
│ Modelo de OpenAI:                                           │
│ ┌──────────────────────────────────────────────────────┐   │
│ │ gpt-4o-mini                                          │   │
│ └──────────────────────────────────────────────────────┘   │
│ ℹ️ Seleccione el modelo de OpenAI a usar                   │
│    (predeterminado: gpt-4o-mini)                            │
│                                                              │
│ [Guardar cambios]                                           │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## 🎯 Flujo Completo de Uso

### Paso 1: Profesor crea la tarea
1. Agrega actividad "AI Assignment"
2. Configura problema, solución, documentación
3. Establece calificación máxima e intentos
4. Guarda

### Paso 2: Estudiante resuelve
1. Accede a la tarea
2. Lee el problema y documentación
3. Escribe su respuesta
4. Envía

### Paso 3: Evaluación automática
1. Sistema envía a OpenAI
2. IA compara con solución del profesor
3. Genera calificación y retroalimentación
4. Actualiza libro de calificaciones

### Paso 4: Estudiante ve resultados
1. Ve su calificación
2. Lee retroalimentación
3. Revisa análisis detallado
4. Puede intentar de nuevo (si tiene intentos)

### Paso 5: Profesor revisa
1. Ve todos los envíos
2. Puede revisar evaluaciones
3. Puede re-evaluar manualmente si es necesario
4. Exporta calificaciones

## 🎨 Estilos y Apariencia

El plugin usa los estilos nativos de Moodle, por lo que se adaptará automáticamente al tema que tengas instalado:

- **Tema Boost** (predeterminado): Diseño moderno y limpio
- **Tema Classic**: Diseño tradicional
- **Temas personalizados**: Se adapta automáticamente

## 📱 Responsive

El plugin es completamente responsive y funciona en:
- 💻 Escritorio
- 📱 Tablets
- 📱 Móviles

## ♿ Accesibilidad

- Cumple con estándares WCAG 2.1
- Compatible con lectores de pantalla
- Navegación por teclado
- Alto contraste disponible
