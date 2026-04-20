# 🧪 GUÍA DE PRUEBAS MANUAL DEL PLUGIN

**Plugin:** mod_aiassignment v1.0.0  
**URL Moodle:** http://localhost  
**Fecha:** 12 de Marzo de 2026

---

## ✅ CHECKLIST DE PRUEBAS

### 1️⃣ VERIFICAR INSTALACIÓN

- [ ] Ir a: `Site administration → Plugins → Plugins overview`
- [ ] Buscar "AI Assignment" en la lista
- [ ] Verificar que aparezca con versión v1.0.0
- [ ] Estado debe ser "Standard"

**URL Directa:** http://localhost/admin/plugins.php

---

### 2️⃣ CONFIGURAR API KEY

- [ ] Ir a: `Site administration → Plugins → Activity modules → AI Assignment`
- [ ] Configurar:
  - **OpenAI API Key:** [Tu API Key] o dejar vacío
  - **OpenAI Model:** gpt-4o-mini
  - **Demo Mode:** ✅ Activar (para pruebas sin API)
  - **Max Response Time:** 30
- [ ] Clic en "Save changes"

**URL Directa:** http://localhost/admin/settings.php?section=modsettingaiassignment

---

### 3️⃣ CREAR ACTIVIDAD DE PRUEBA

#### Paso 1: Acceder al Curso
- [ ] Ir a "Dashboard" o "My courses"
- [ ] Seleccionar cualquier curso
- [ ] Clic en "Turn editing on"

#### Paso 2: Agregar Actividad
- [ ] Clic en "Add an activity or resource"
- [ ] Buscar y seleccionar "AI Assignment"
- [ ] Clic en "Add"

#### Paso 3: Configurar la Actividad
```
Nombre: Prueba de Factorial
Descripción: Implementa una función que calcule el factorial de un número

Tipo de problema: Programación

Solución de referencia:
def factorial(n):
    if n <= 1:
        return 1
    return n * factorial(n-1)

Documentación adicional:
El factorial de n (n!) es el producto de todos los enteros positivos menores o iguales a n.
Ejemplo: 5! = 5 × 4 × 3 × 2 × 1 = 120

Casos de prueba:
factorial(0) = 1
factorial(1) = 1
factorial(5) = 120
factorial(10) = 3628800

Calificación máxima: 100
Intentos máximos: 3
```

- [ ] Clic en "Save and display"

---

### 4️⃣ PROBAR ENVÍO COMO ESTUDIANTE

#### Paso 1: Cambiar a Vista de Estudiante
- [ ] En la actividad, cambiar rol a "Student"
- [ ] O acceder con cuenta de estudiante

#### Paso 2: Enviar Respuesta
- [ ] Ver el formulario de envío
- [ ] Escribir una respuesta (ejemplo):

```python
def factorial(n):
    result = 1
    for i in range(1, n + 1):
        result *= i
    return result
```

- [ ] Clic en "Submit"

#### Paso 3: Verificar Evaluación
- [ ] Esperar 5-10 segundos
- [ ] Verificar que aparezca:
  - ✅ Calificación (0-100)
  - ✅ Feedback de IA
  - ✅ Análisis detallado
- [ ] La calificación debe estar entre 70-100 para código correcto

---

### 5️⃣ VERIFICAR LIBRO DE CALIFICACIONES

- [ ] Ir al curso
- [ ] Clic en "Grades" en el menú
- [ ] Verificar que aparezca "Prueba de Factorial"
- [ ] Comprobar que la calificación se haya sincronizado
- [ ] La calificación debe coincidir con la del envío

**URL:** http://localhost/grade/report/grader/index.php?id=[COURSE_ID]

---

### 6️⃣ PROBAR DASHBOARD (Como Profesor)

#### Paso 1: Acceder al Dashboard
- [ ] Volver a rol de profesor
- [ ] Acceder a la actividad "Prueba de Factorial"
- [ ] Clic en botón "Dashboard" (arriba)

#### Paso 2: Verificar Estadísticas
- [ ] **Total de envíos:** Debe mostrar 1 o más
- [ ] **Promedio de calificaciones:** Debe mostrar el promedio
- [ ] **Estudiantes activos:** Debe mostrar cantidad
- [ ] **Evaluaciones pendientes:** Debe ser 0 si todo se evaluó

#### Paso 3: Verificar Gráficos
- [ ] **Envíos recientes:** Lista de últimos envíos
- [ ] **Distribución de calificaciones:** Gráfico de barras
- [ ] **Mejores estudiantes:** Top performers

---

### 7️⃣ PROBAR VISTA DE ENVÍOS

- [ ] En la actividad, clic en "View all submissions"
- [ ] Verificar tabla con:
  - Nombre del estudiante
  - Número de intento
  - Calificación
  - Estado (Evaluated/Pending)
  - Fecha de envío
- [ ] Clic en "View" de un envío
- [ ] Verificar detalles completos:
  - Respuesta del estudiante
  - Calificación
  - Feedback
  - Análisis de IA

---

### 8️⃣ PROBAR MÚLTIPLES INTENTOS

- [ ] Como estudiante, enviar otra respuesta diferente
- [ ] Verificar que se permita (si no se alcanzó el máximo)
- [ ] Comprobar que aparezcan ambos intentos en el historial
- [ ] La calificación final debe ser la mejor de todos los intentos

---

### 9️⃣ PROBAR DETECCIÓN DE PLAGIO

#### Requisito: Al menos 2 envíos de diferentes estudiantes

#### Paso 1: Crear Segundo Envío
- [ ] Acceder como otro estudiante (o crear cuenta)
- [ ] Enviar una respuesta similar a la primera
- [ ] Esperar evaluación

#### Paso 2: Analizar Plagio
- [ ] Como profesor, ir a la actividad
- [ ] Clic en "Plagiarism Report"
- [ ] Seleccionar la actividad "Prueba de Factorial"
- [ ] Clic en "Analyze Plagiarism"
- [ ] Esperar análisis (10-30 segundos)

#### Paso 3: Revisar Reporte
- [ ] **Resumen:**
  - Total de comparaciones
  - Pares sospechosos
  - Mayor similitud
- [ ] **Usuarios Sospechosos:** Lista de estudiantes
- [ ] **Comparaciones Detalladas:** Tabla con porcentajes
- [ ] **Veredicto:** Clasificación (No suspicious, Suspicious, Highly suspicious)

---

### 🔟 PROBAR DIFERENTES TIPOS DE RESPUESTAS

#### Respuesta Correcta (Debe obtener 90-100)
```python
def factorial(n):
    if n <= 1:
        return 1
    return n * factorial(n-1)
```

#### Respuesta Alternativa Correcta (Debe obtener 80-95)
```python
def factorial(n):
    result = 1
    for i in range(1, n + 1):
        result *= i
    return result
```

#### Respuesta Parcialmente Correcta (Debe obtener 50-70)
```python
def factorial(n):
    # Falta manejo de caso base
    return n * factorial(n-1)
```

#### Respuesta Incorrecta (Debe obtener 0-40)
```python
def factorial(n):
    return n + n
```

---

## 📊 RESULTADOS ESPERADOS

### Evaluación Automática
- ⏱️ Tiempo de respuesta: 5-10 segundos
- 📊 Calificación: 0-100
- 💬 Feedback: Texto descriptivo
- 📝 Análisis: Detalles técnicos

### Libro de Calificaciones
- ✅ Sincronización automática
- ✅ Calificación visible para estudiantes
- ✅ Actualización en tiempo real

### Dashboard
- 📈 Estadísticas actualizadas
- 📊 Gráficos interactivos
- 📋 Lista de envíos recientes

### Detección de Plagio
- 🔍 Análisis de similitud
- ⚠️ Identificación de pares sospechosos
- 📊 Porcentajes de similitud

---

## ❌ PROBLEMAS COMUNES

### "OpenAI API Error"
**Solución:** Activar "Demo Mode" en configuración

### "Permission denied"
**Solución:** Verificar que el usuario tenga el rol apropiado

### "No se muestra la actividad"
**Solución:** Verificar que el plugin esté instalado correctamente

### "Evaluación pendiente por mucho tiempo"
**Solución:** 
1. Verificar API Key
2. Activar Demo Mode
3. Revisar logs de Moodle

---

## 📝 REGISTRO DE PRUEBAS

| Prueba | Estado | Notas |
|--------|--------|-------|
| 1. Instalación verificada | ⬜ |  |
| 2. Configuración completada | ⬜ |  |
| 3. Actividad creada | ⬜ |  |
| 4. Envío realizado | ⬜ |  |
| 5. Evaluación automática | ⬜ |  |
| 6. Libro de calificaciones | ⬜ |  |
| 7. Dashboard funcional | ⬜ |  |
| 8. Vista de envíos | ⬜ |  |
| 9. Múltiples intentos | ⬜ |  |
| 10. Detección de plagio | ⬜ |  |

---

## ✅ CONCLUSIÓN

Una vez completadas todas las pruebas, el plugin estará completamente verificado y listo para uso en producción.

**Documentación adicional:**
- INSTALACION_PLUGIN_FINAL.md
- PLUGIN_VERIFICACION_FINAL.md
- CUMPLIMIENTO_ESTANDARES_MOODLE.md
