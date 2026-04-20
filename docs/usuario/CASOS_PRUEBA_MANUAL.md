# 🧪 Casos de Prueba Manual - AI Assignment Plugin

## 📋 Guía de Pruebas Manuales

Esta guía te ayudará a probar manualmente todas las funcionalidades del plugin.

---

## ✅ PRUEBA 1: Crear Tarea de Programación

### Objetivo
Verificar que se pueden crear tareas de programación correctamente.

### Pasos
1. Abre `plugin-funcional.html`
2. Ve a la pestaña "Profesor"
3. Completa el formulario:
   - **Nombre**: Función Factorial
   - **Descripción**: Implementa una función que calcule el factorial de un número
   - **Tipo**: Programación
   - **Solución**:
   ```python
   def factorial(n):
       if n == 0 or n == 1:
           return 1
       return n * factorial(n - 1)
   ```
4. Click en "Crear Tarea"

### Resultado Esperado
- ✅ Mensaje de éxito: "Tarea creada exitosamente"
- ✅ La tarea aparece en la pestaña "Estudiante"

---

## ✅ PRUEBA 2: Crear Tarea de Matemáticas

### Objetivo
Verificar que se pueden crear tareas de matemáticas correctamente.

### Pasos
1. Ve a la pestaña "Profesor"
2. Completa el formulario:
   - **Nombre**: Ecuación Cuadrática
   - **Descripción**: Resuelve la ecuación x² - 5x + 6 = 0
   - **Tipo**: Matemáticas
   - **Solución**:
   ```
   x² - 5x + 6 = 0
   Factorización: (x - 2)(x - 3) = 0
   Por lo tanto: x = 2 o x = 3
   
   Verificación:
   Para x = 2: (2)² - 5(2) + 6 = 4 - 10 + 6 = 0 ✓
   Para x = 3: (3)² - 5(3) + 6 = 9 - 15 + 6 = 0 ✓
   ```
3. Click en "Crear Tarea"

### Resultado Esperado
- ✅ Mensaje de éxito
- ✅ La tarea aparece en la lista

---

## ✅ PRUEBA 3: Enviar Respuesta Correcta (Programación)

### Objetivo
Verificar que la IA evalúa correctamente una respuesta correcta.

### Pasos
1. Ve a la pestaña "Estudiante"
2. Click en "Enviar Respuesta" en la tarea "Función Factorial"
3. Escribe tu respuesta:
   ```python
   def factorial(n):
       if n <= 1:
           return 1
       return n * factorial(n - 1)
   ```
4. Click en "Enviar"
5. Espera la evaluación (5-10 segundos)

### Resultado Esperado
- ✅ Notificación: "Evaluando con IA..."
- ✅ Notificación: "Evaluación completada!"
- ✅ Redirección automática a "Resultados"
- ✅ Calificación alta (70-100%)
- ✅ Feedback positivo de la IA
- ✅ Análisis detallado visible

---

## ✅ PRUEBA 4: Enviar Respuesta Incorrecta (Programación)

### Objetivo
Verificar que la IA detecta errores en el código.

### Pasos
1. Ve a "Estudiante"
2. Click en "Enviar Respuesta" en "Función Factorial"
3. Escribe una respuesta con error:
   ```python
   def factorial(n):
       return n * factorial(n - 1)  # Falta caso base
   ```
4. Click en "Enviar"

### Resultado Esperado
- ✅ Calificación baja (0-50%)
- ✅ Feedback indicando el error
- ✅ Análisis mencionando la falta del caso base

---

## ✅ PRUEBA 5: Enviar Respuesta Correcta (Matemáticas)

### Objetivo
Verificar evaluación de problemas matemáticos.

### Pasos
1. Ve a "Estudiante"
2. Click en "Enviar Respuesta" en "Ecuación Cuadrática"
3. Escribe tu respuesta:
   ```
   Usando la fórmula general:
   x = (-b ± √(b²-4ac)) / 2a
   x = (5 ± √(25-24)) / 2
   x = (5 ± 1) / 2
   
   Soluciones:
   x₁ = (5 + 1) / 2 = 3
   x₂ = (5 - 1) / 2 = 2
   ```
4. Click en "Enviar"

### Resultado Esperado
- ✅ Calificación alta (70-100%)
- ✅ Feedback reconociendo el método correcto
- ✅ Análisis positivo

---

## ✅ PRUEBA 6: Enviar Respuesta Parcialmente Correcta

### Objetivo
Verificar que la IA da calificaciones intermedias.

### Pasos
1. Ve a "Estudiante"
2. Envía una respuesta a "Ecuación Cuadrática":
   ```
   x² - 5x + 6 = 0
   (x - 2)(x - 3) = 0
   x = 2 o x = 3
   ```
   (Sin verificación ni explicación del método)
4. Click en "Enviar"

### Resultado Esperado
- ✅ Calificación media (60-80%)
- ✅ Feedback sugiriendo agregar verificación
- ✅ Reconocimiento de la respuesta correcta

---

## ✅ PRUEBA 7: Ver Múltiples Envíos

### Objetivo
Verificar que se muestran todos los envíos.

### Pasos
1. Realiza 3-4 envíos diferentes
2. Ve a la pestaña "Resultados"

### Resultado Esperado
- ✅ Todos los envíos visibles
- ✅ Ordenados del más reciente al más antiguo
- ✅ Cada uno muestra:
  - Nombre de la tarea
  - Fecha y hora
  - Calificación
  - Barra de progreso
  - Feedback
  - Análisis (expandible)
  - Respuesta (expandible)

---

## ✅ PRUEBA 8: Detección de Plagio - Alta Similitud

### Objetivo
Verificar que la IA detecta código muy similar.

### Pasos
1. Crea una tarea de programación
2. Envía la primera respuesta:
   ```python
   def suma(a, b):
       return a + b
   ```
3. Envía la segunda respuesta (muy similar):
   ```python
   def suma(x, y):
       return x + y
   ```
4. Ve a la pestaña "Plagio"
5. Click en "Analizar Similitudes"

### Resultado Esperado
- ✅ Análisis completado
- ✅ Similitud alta (70-100%)
- ✅ Comparación lado a lado
- ✅ Clasificación como "Alta"
- ✅ Barra de progreso roja

---

## ✅ PRUEBA 9: Detección de Plagio - Baja Similitud

### Objetivo
Verificar que la IA distingue código diferente.

### Pasos
1. Envía dos respuestas completamente diferentes:
   
   **Respuesta 1:**
   ```python
   def factorial(n):
       if n == 0:
           return 1
       return n * factorial(n - 1)
   ```
   
   **Respuesta 2:**
   ```python
   def fibonacci(n):
       if n <= 1:
           return n
       return fibonacci(n-1) + fibonacci(n-2)
   ```
2. Ve a "Plagio"
3. Click en "Analizar Similitudes"

### Resultado Esperado
- ✅ Similitud baja (0-40%)
- ✅ Clasificación como "Baja"
- ✅ Barra de progreso verde

---

## ✅ PRUEBA 10: Persistencia de Datos

### Objetivo
Verificar que los datos se guardan correctamente.

### Pasos
1. Crea 2 tareas
2. Envía 3 respuestas
3. Cierra el navegador
4. Abre nuevamente `plugin-funcional.html`

### Resultado Esperado
- ✅ Todas las tareas siguen ahí
- ✅ Todos los envíos siguen ahí
- ✅ Las evaluaciones se mantienen

---

## ✅ PRUEBA 11: Interfaz Responsive

### Objetivo
Verificar que funciona en diferentes tamaños de pantalla.

### Pasos
1. Abre el plugin
2. Redimensiona la ventana del navegador
3. Prueba en modo móvil (F12 → Toggle device toolbar)

### Resultado Esperado
- ✅ La interfaz se adapta correctamente
- ✅ Los botones son accesibles
- ✅ El texto es legible
- ✅ Las tablas/cards se reorganizan

---

## ✅ PRUEBA 12: Manejo de Errores

### Objetivo
Verificar que se manejan errores correctamente.

### Pasos
1. Intenta enviar una respuesta vacía
2. Intenta analizar plagio sin envíos suficientes

### Resultado Esperado
- ✅ Mensaje de advertencia para respuesta vacía
- ✅ Mensaje informativo si no hay suficientes envíos
- ✅ No se rompe la aplicación

---

## 📊 Checklist de Pruebas

Marca cada prueba al completarla:

- [ ] Prueba 1: Crear tarea de programación
- [ ] Prueba 2: Crear tarea de matemáticas
- [ ] Prueba 3: Respuesta correcta (programación)
- [ ] Prueba 4: Respuesta incorrecta (programación)
- [ ] Prueba 5: Respuesta correcta (matemáticas)
- [ ] Prueba 6: Respuesta parcialmente correcta
- [ ] Prueba 7: Ver múltiples envíos
- [ ] Prueba 8: Plagio - Alta similitud
- [ ] Prueba 9: Plagio - Baja similitud
- [ ] Prueba 10: Persistencia de datos
- [ ] Prueba 11: Interfaz responsive
- [ ] Prueba 12: Manejo de errores

---

## 🐛 Reporte de Bugs

Si encuentras algún problema, anota:

1. **Qué estabas haciendo**: 
2. **Qué esperabas que pasara**: 
3. **Qué pasó realmente**: 
4. **Mensaje de error** (si hay): 
5. **Navegador y versión**: 

---

## 💡 Consejos para Pruebas

1. **Abre la consola del navegador** (F12) para ver errores
2. **Prueba con diferentes tipos de código** (Python, JavaScript, Java, etc.)
3. **Prueba con diferentes problemas matemáticos** (álgebra, cálculo, geometría)
4. **Experimenta con respuestas creativas** para ver cómo responde la IA
5. **Verifica los tiempos de respuesta** de la API

---

## ✅ Criterios de Éxito

El plugin pasa todas las pruebas si:

- ✅ Todas las funcionalidades básicas funcionan
- ✅ La evaluación con IA es precisa
- ✅ La detección de plagio funciona correctamente
- ✅ Los datos persisten correctamente
- ✅ La interfaz es usable y responsive
- ✅ Los errores se manejan apropiadamente

---

¡Buena suerte con las pruebas! 🚀
