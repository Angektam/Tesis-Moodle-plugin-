# 📖 Manual de Usuario - AI Assignment

## Guía Completa para Profesores y Estudiantes

---

## 📑 Tabla de Contenidos

1. [Introducción](#introducción)
2. [Requisitos Previos](#requisitos-previos)
3. [Guía para Profesores](#guía-para-profesores)
4. [Guía para Estudiantes](#guía-para-estudiantes)
5. [Dashboard del Profesor](#dashboard-del-profesor)
6. [Preguntas Frecuentes](#preguntas-frecuentes)
7. [Solución de Problemas](#solución-de-problemas)

---

## 🎯 Introducción

**AI Assignment** es un plugin de Moodle que permite crear tareas que son evaluadas automáticamente usando Inteligencia Artificial (OpenAI GPT). Los estudiantes reciben retroalimentación instantánea y detallada sobre sus respuestas.

### ¿Qué puedes hacer con AI Assignment?

- ✅ Crear tareas de matemáticas o programación
- ✅ Evaluación automática con IA
- ✅ Retroalimentación instantánea para estudiantes
- ✅ Dashboard con estadísticas visuales
- ✅ Múltiples intentos por estudiante
- ✅ Integración con el libro de calificaciones

---

## 💻 Requisitos Previos

### Para Administradores

- Moodle 4.0 o superior
- PHP 7.4 o superior
- Cuenta de OpenAI con API Key
- Plugin AI Assignment instalado

### Para Profesores

- Rol de profesor o profesor sin permiso de edición en un curso
- Acceso a la configuración del curso
- API Key de OpenAI configurada (por el administrador)

### Para Estudiantes

- Rol de estudiante en un curso
- Acceso al curso donde está la tarea

---


## 👨‍🏫 Guía para Profesores

### 1. Crear una Nueva Tarea AI Assignment

#### Paso 1: Activar la Edición
1. Entra a tu curso en Moodle
2. Haz clic en el botón **"Activar edición"** (esquina superior derecha)

#### Paso 2: Agregar la Actividad
1. En la sección donde quieres agregar la tarea, haz clic en **"Agregar una actividad o recurso"**
2. Selecciona **"AI Assignment"** de la lista
3. Haz clic en **"Agregar"**

#### Paso 3: Configurar la Tarea

**Sección: General**
- **Nombre**: Título de la tarea (ej: "Problema de Suma de Arrays")
- **Descripción**: Enunciado completo del problema
  - Sé claro y específico
  - Incluye ejemplos si es necesario
  - Explica qué se espera del estudiante

**Sección: Configuración del Problema**
- **Tipo de problema**: Selecciona entre:
  - 📐 **Matemáticas**: Para problemas matemáticos, ecuaciones, cálculos
  - 💻 **Programación**: Para ejercicios de código

- **Solución de referencia**: 
  - Escribe la solución correcta
  - Esta será usada por la IA para comparar
  - Para código: incluye código completo y funcional
  - Para matemáticas: incluye el proceso completo

- **Documentación adicional** (opcional):
  - Información extra para los estudiantes
  - Pistas o consejos
  - Enlaces a recursos
  - Ejemplos adicionales

- **Casos de prueba** (opcional):
  - Ejemplos de entrada y salida esperada
  - Útil para problemas de programación
  - Formato: "Entrada: ... | Salida: ..."

**Sección: Configuración de Calificación**
- **Calificación máxima**: Puntos totales (default: 100)
- **Intentos máximos**: 
  - 0 = ilimitado
  - 1, 2, 3... = número específico de intentos

#### Paso 4: Guardar
1. Haz clic en **"Guardar cambios y mostrar"**
2. La tarea estará disponible para los estudiantes

---

### 2. Ver Todos los Envíos de una Tarea

#### Opción A: Desde la Tarea
1. Entra a la actividad AI Assignment
2. Haz clic en el botón **"Todos los envíos"**

#### Opción B: Desde el Dashboard
1. Entra a cualquier AI Assignment del curso
2. Haz clic en **"Dashboard"**
3. En la tabla "Resumen de Tareas", haz clic en **"Ver envíos"**

#### Qué Verás:
- Tabla con todos los envíos
- Columnas: Estudiante, Fecha, Intento, Estado, Calificación
- Estadísticas: Total de envíos, Promedio, Evaluados, Pendientes
- Filtros y búsqueda (si hay muchos envíos)

---

### 3. Ver Detalles de un Envío Específico

1. En la lista de envíos, haz clic en **"Ver"** en el envío que quieres revisar
2. Verás:
   - **Información del envío**: Estudiante, fecha, intento
   - **Respuesta del estudiante**: Texto completo
   - **Calificación**: Score obtenido (0-100%)
   - **Retroalimentación**: Feedback breve de la IA
   - **Análisis detallado**: Evaluación completa por criterios

#### Opciones Disponibles:
- **Re-evaluar**: Volver a evaluar el envío con la IA
- **Volver a envíos**: Regresar a la lista

---


### 4. Editar una Tarea Existente

1. Entra a la actividad AI Assignment
2. Haz clic en el ícono de **engranaje** (⚙️) en la esquina superior derecha
3. Selecciona **"Editar configuración"**
4. Modifica los campos que necesites
5. Haz clic en **"Guardar cambios"**

**Nota**: Los cambios no afectan los envíos ya realizados.

---

### 5. Eliminar una Tarea

1. Activa la edición del curso
2. En la actividad AI Assignment, haz clic en **"Editar"**
3. Selecciona **"Eliminar"**
4. Confirma la eliminación

**⚠️ Advertencia**: Esto eliminará todos los envíos y evaluaciones asociadas.

---

### 6. Re-evaluar un Envío

Si crees que la evaluación de la IA no fue correcta:

1. Entra al detalle del envío
2. Haz clic en el botón **"Re-evaluar"**
3. Confirma la acción
4. El sistema volverá a evaluar con la IA
5. La nueva calificación reemplazará la anterior

**Cuándo re-evaluar:**
- La calificación parece incorrecta
- Actualizaste la solución de referencia
- Quieres una segunda opinión de la IA

---

### 7. Exportar Calificaciones

Las calificaciones se integran automáticamente con el libro de calificaciones de Moodle.

**Para exportar:**
1. Ve a **"Calificaciones"** en tu curso
2. Selecciona **"Exportar"**
3. Elige el formato (Excel, CSV, etc.)
4. Las calificaciones de AI Assignment estarán incluidas

---

## 👨‍🎓 Guía para Estudiantes

### 1. Acceder a una Tarea AI Assignment

1. Entra a tu curso en Moodle
2. Busca la actividad **"AI Assignment"** en la sección correspondiente
3. Haz clic en el nombre de la tarea

---

### 2. Leer el Problema

Cuando entres a la tarea, verás:

- **Descripción del problema**: Lee cuidadosamente el enunciado
- **Tipo**: Matemáticas o Programación
- **Documentación**: Información adicional, pistas, ejemplos
- **Casos de prueba**: Ejemplos de entrada/salida (si aplica)
- **Intentos restantes**: Cuántos intentos te quedan

**💡 Consejo**: Lee toda la información antes de empezar a resolver.

---

### 3. Escribir tu Respuesta

#### Para Problemas de Matemáticas:
- Escribe tu solución paso a paso
- Explica tu razonamiento
- Muestra los cálculos
- Incluye la respuesta final

**Ejemplo:**
```
Problema: Resolver 2x + 5 = 15

Solución:
1. Restar 5 de ambos lados: 2x = 10
2. Dividir entre 2: x = 5
3. Verificación: 2(5) + 5 = 15 ✓

Respuesta: x = 5
```

#### Para Problemas de Programación:
- Escribe código completo y funcional
- Usa nombres de variables descriptivos
- Agrega comentarios explicativos
- Asegúrate de que el código sea claro

**Ejemplo:**
```python
def suma(a, b):
    """
    Suma dos números y retorna el resultado
    """
    resultado = a + b
    return resultado

# Prueba
print(suma(5, 3))  # Output: 8
```

---

### 4. Enviar tu Respuesta

1. Escribe tu solución en el área de texto
2. Revisa que esté completa y correcta
3. Haz clic en el botón **"Enviar"**
4. Confirma el envío si se te pide

**⚠️ Importante**: 
- No puedes editar después de enviar
- Cada envío cuenta como un intento
- Verifica antes de enviar

---

### 5. Ver tus Resultados

Después de enviar, en pocos segundos verás:

#### Calificación
- Número de 0 a 100%
- Badge con color:
  - 🟢 Verde (90-100%): Excelente
  - 🔵 Azul (80-89%): Bueno
  - 🟡 Amarillo (70-79%): Promedio
  - 🔴 Rojo (0-69%): Necesita mejorar

#### Retroalimentación
- Comentario breve de la IA
- Qué hiciste bien
- Qué puedes mejorar

#### Botón "Ver detalles"
- Haz clic para ver el análisis completo

---

### 6. Ver Análisis Detallado

Al hacer clic en "Ver detalles", verás:

#### Para Programación:
- **Funcionalidad**: ¿El código funciona correctamente?
- **Estilo**: ¿Es legible y claro?
- **Buenas prácticas**: ¿Sigue estándares?
- **Eficiencia**: ¿Es óptimo?
- **Sugerencias**: Cómo mejorar

#### Para Matemáticas:
- **Corrección**: ¿La respuesta es correcta?
- **Método**: ¿El método usado es apropiado?
- **Claridad**: ¿La explicación es clara?
- **Pasos**: ¿Se muestran los pasos?
- **Sugerencias**: Cómo mejorar

---


### 7. Mejorar y Reenviar

Si tienes intentos restantes y quieres mejorar tu calificación:

1. Lee cuidadosamente el feedback y análisis
2. Identifica qué puedes mejorar
3. Modifica tu solución
4. Envía nuevamente
5. Recibirás una nueva evaluación

**💡 Consejos para mejorar:**
- Lee las sugerencias de la IA
- Compara tu solución con los ejemplos
- Busca información adicional si es necesario
- Pide ayuda al profesor si tienes dudas

---

### 8. Ver tu Historial de Envíos

En la página principal de la tarea, verás:

- **Tus envíos anteriores**: Lista de todos tus intentos
- **Fecha y hora**: Cuándo enviaste cada uno
- **Intento**: Número de intento (1, 2, 3...)
- **Calificación**: Score obtenido en cada intento
- **Acciones**: Botón para ver detalles de cada envío

**Nota**: Tu calificación final es la del mejor intento.

---

## 📊 Dashboard del Profesor

### Acceder al Dashboard

1. Entra a cualquier actividad AI Assignment del curso
2. Haz clic en el botón **"Dashboard"** (parte superior)
3. Verás el dashboard del curso completo

### Componentes del Dashboard

#### 1. Tarjetas de Estadísticas

**Total de Tareas**
- Número de actividades AI Assignment en el curso

**Promedio de Calificaciones**
- Calificación promedio de todos los envíos evaluados
- Incluye todas las tareas del curso

**Estudiantes Activos**
- Número de estudiantes que han enviado al menos una respuesta

**Evaluaciones Pendientes**
- Envíos que aún no han sido evaluados
- Normalmente debería ser 0 (evaluación automática)

---

#### 2. Resumen de Tareas

Tabla con todas las tareas AI Assignment del curso:

- **Nombre**: Título de la tarea (con enlace)
- **Tipo**: Matemáticas o Programación
- **Envíos**: Número total de respuestas recibidas
- **Promedio**: Calificación promedio de esa tarea
- **Acciones**: Botón "Ver envíos"

**Uso:**
- Identifica tareas con bajo promedio (más difíciles)
- Ve qué tareas tienen más participación
- Accede rápidamente a los envíos de cada tarea

---

#### 3. Envíos Recientes

Tabla con los últimos 15 envíos de todas las tareas:

- **Tarea**: Nombre de la tarea
- **Estudiante**: Avatar y nombre del estudiante
- **Enviado el**: Fecha y hora
- **Calificación**: Score con código de colores
- **Acciones**: Botón "Ver" para detalles

**Uso:**
- Monitorea la actividad reciente del curso
- Identifica envíos que necesitan atención
- Accede rápidamente a evaluaciones recientes

---

#### 4. Top 10 Estudiantes

Lista de los mejores estudiantes del curso:

- **Ranking**: Posición (1-10)
  - Top 3 con badge dorado especial
- **Estudiante**: Avatar y nombre
- **Envíos**: Número total de respuestas enviadas
- **Promedio**: Calificación promedio global

**Uso:**
- Identifica estudiantes destacados
- Reconoce el esfuerzo de los mejores
- Detecta estudiantes que necesitan apoyo (no aparecen en la lista)

---

### Ventajas del Dashboard Único

✅ **Vista Consolidada**: Todo en un solo lugar
✅ **Comparación**: Compara rendimiento entre tareas
✅ **Ahorro de Tiempo**: No necesitas entrar a cada tarea
✅ **Análisis Global**: Identifica patrones del curso completo

---

## ❓ Preguntas Frecuentes

### Para Profesores

**P: ¿Puedo cambiar la solución de referencia después de que los estudiantes han enviado?**
R: Sí, pero no afectará las evaluaciones ya realizadas. Puedes re-evaluar los envíos manualmente si es necesario.

**P: ¿Qué pasa si la IA evalúa incorrectamente?**
R: Puedes re-evaluar el envío. También puedes ajustar la calificación manualmente en el libro de calificaciones.

**P: ¿Los estudiantes pueden ver la solución del profesor?**
R: No, la solución de referencia solo la usa la IA para comparar. Los estudiantes no la ven.

**P: ¿Puedo limitar el tiempo para enviar?**
R: Sí, usa las opciones de disponibilidad de Moodle (fecha de inicio y fin).

**P: ¿Cuánto cuesta usar la IA?**
R: Con gpt-4o-mini, cada evaluación cuesta aproximadamente $0.0003 USD (menos de 1 centavo).

**P: ¿Puedo usar el plugin sin internet?**
R: No, se requiere conexión a internet para comunicarse con la API de OpenAI.

---

### Para Estudiantes

**P: ¿Cuántos intentos tengo?**
R: Depende de la configuración del profesor. Verás "Intentos restantes" en la página de la tarea.

**P: ¿Qué intento cuenta para mi calificación?**
R: El mejor intento (la calificación más alta).

**P: ¿Puedo ver la solución del profesor?**
R: No, pero recibirás retroalimentación detallada de la IA que te ayudará a mejorar.

**P: ¿Cuánto tarda la evaluación?**
R: Normalmente entre 3 y 10 segundos.

**P: ¿Puedo editar mi respuesta después de enviar?**
R: No, pero si tienes intentos restantes, puedes enviar una nueva respuesta mejorada.

**P: ¿La IA siempre califica correctamente?**
R: La IA es muy precisa, pero no es perfecta. Si crees que hay un error, contacta a tu profesor.

---


## 🔧 Solución de Problemas

### Problema: "No se puede enviar la respuesta"

**Posibles causas:**
- Has alcanzado el máximo de intentos
- La respuesta está vacía
- Problemas de conexión

**Solución:**
1. Verifica que hayas escrito algo en el área de texto
2. Revisa cuántos intentos te quedan
3. Verifica tu conexión a internet
4. Intenta recargar la página (F5)
5. Si persiste, contacta a tu profesor

---

### Problema: "La evaluación está tardando mucho"

**Posibles causas:**
- Problemas con la API de OpenAI
- Conexión lenta
- Respuesta muy larga

**Solución:**
1. Espera hasta 30 segundos
2. Recarga la página
3. Verifica en "Tus envíos" si se guardó
4. Si no aparece, contacta al profesor

---

### Problema: "No veo el botón Dashboard"

**Posibles causas:**
- No tienes permisos de profesor
- Estás viendo como estudiante

**Solución:**
1. Verifica que tengas rol de profesor
2. El dashboard solo está disponible para profesores
3. Contacta al administrador si crees que deberías tener acceso

---

### Problema: "La calificación no aparece en el libro de calificaciones"

**Posibles causas:**
- La evaluación aún está pendiente
- Error en la sincronización

**Solución:**
1. Espera unos minutos y recarga
2. Verifica que el envío esté "Evaluado"
3. Contacta al profesor o administrador

---

### Problema: "Error: No API key configured"

**Para administradores:**
1. Ve a: Site administration → Plugins → Activity modules → AI Assignment
2. Ingresa tu OpenAI API Key
3. Guarda los cambios

**Para profesores/estudiantes:**
- Contacta al administrador del sitio

---

### Problema: "La IA dio una calificación muy baja/alta"

**Para estudiantes:**
1. Lee cuidadosamente el análisis detallado
2. Compara tu respuesta con los criterios
3. Si crees que es un error, contacta a tu profesor

**Para profesores:**
1. Revisa el envío y la evaluación
2. Puedes re-evaluar si es necesario
3. Puedes ajustar la calificación manualmente en el libro de calificaciones

---

## 📞 Soporte y Contacto

### Para Estudiantes
- Contacta a tu profesor del curso
- Usa el foro del curso para preguntas generales

### Para Profesores
- Contacta al administrador de Moodle
- Revisa la documentación técnica en el repositorio

### Para Administradores
- Revisa los logs de Moodle
- Verifica la configuración de la API Key
- Consulta la documentación de desarrollo

---

## 📚 Recursos Adicionales

### Documentación Técnica
- `INSTALACION.md` - Guía de instalación
- `COMPONENTES.md` - Estructura del plugin
- `COMO_FUNCIONA_IA.md` - Detalles de la evaluación con IA
- `DASHBOARD.md` - Documentación del dashboard

### Demos Interactivos
- `vista-previa-completa.html` - Vista previa completa del sistema
- `dashboard-demo.html` - Demo del dashboard
- `demo.html` - Demo original

### Enlaces Útiles
- [Documentación de Moodle](https://docs.moodle.org/)
- [OpenAI API Documentation](https://platform.openai.com/docs/)
- [Moodle Developer Resources](https://moodledev.io/)

---

## 💡 Mejores Prácticas

### Para Profesores

**Al Crear Tareas:**
- ✅ Sé específico en el enunciado
- ✅ Proporciona ejemplos claros
- ✅ Incluye documentación útil
- ✅ Define criterios de evaluación claros
- ✅ Prueba la tarea antes de publicarla

**Al Configurar:**
- ✅ Establece intentos máximos razonables (3-5)
- ✅ Usa calificación máxima estándar (100)
- ✅ Proporciona solución de referencia completa
- ✅ Incluye casos de prueba para programación

**Al Monitorear:**
- ✅ Revisa el dashboard regularmente
- ✅ Identifica estudiantes con dificultades
- ✅ Verifica evaluaciones con calificaciones extremas
- ✅ Proporciona retroalimentación adicional si es necesario

---

### Para Estudiantes

**Antes de Enviar:**
- ✅ Lee todo el enunciado cuidadosamente
- ✅ Revisa la documentación proporcionada
- ✅ Verifica que tu respuesta esté completa
- ✅ Prueba tu código (si es programación)
- ✅ Revisa ortografía y formato

**Al Recibir Feedback:**
- ✅ Lee el análisis completo
- ✅ Identifica áreas de mejora
- ✅ Aprende de los errores
- ✅ Usa las sugerencias para mejorar
- ✅ Pregunta al profesor si tienes dudas

**Para Mejorar:**
- ✅ Practica regularmente
- ✅ Revisa ejemplos y documentación
- ✅ Compara tus intentos anteriores
- ✅ Busca recursos adicionales
- ✅ Colabora con compañeros (si está permitido)

---

## 🎓 Consejos de Uso

### Maximiza el Aprendizaje

**Para Estudiantes:**
1. No te conformes con la primera calificación
2. Usa los intentos adicionales para mejorar
3. Lee cuidadosamente el feedback de la IA
4. Aprende de cada intento
5. Pregunta cuando no entiendas algo

**Para Profesores:**
1. Usa el dashboard para identificar patrones
2. Ajusta la dificultad según el rendimiento
3. Proporciona recursos adicionales si es necesario
4. Reconoce a los estudiantes destacados
5. Apoya a los que tienen dificultades

---

## ✅ Checklist de Uso

### Para Profesores - Crear Tarea

- [ ] Activar edición del curso
- [ ] Agregar actividad AI Assignment
- [ ] Escribir nombre descriptivo
- [ ] Redactar enunciado claro
- [ ] Seleccionar tipo (matemáticas/programación)
- [ ] Proporcionar solución de referencia completa
- [ ] Agregar documentación útil
- [ ] Incluir casos de prueba (si aplica)
- [ ] Configurar calificación máxima
- [ ] Establecer intentos máximos
- [ ] Guardar y probar

### Para Estudiantes - Resolver Tarea

- [ ] Leer enunciado completo
- [ ] Revisar documentación
- [ ] Entender qué se pide
- [ ] Escribir solución completa
- [ ] Revisar antes de enviar
- [ ] Enviar respuesta
- [ ] Leer feedback de la IA
- [ ] Revisar análisis detallado
- [ ] Identificar mejoras
- [ ] Reenviar si es necesario

---

## 📝 Notas Finales

Este manual cubre el uso básico y avanzado de AI Assignment. Para información técnica detallada, consulta la documentación de desarrollo.

**Versión del Manual:** 1.0.0  
**Fecha:** Febrero 2026  
**Plugin:** AI Assignment para Moodle  

---

**¿Necesitas más ayuda?**  
Contacta a tu profesor o administrador de Moodle.

