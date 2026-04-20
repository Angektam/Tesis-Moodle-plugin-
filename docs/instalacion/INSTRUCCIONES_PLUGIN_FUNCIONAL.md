# 🚀 Plugin Funcional - AI Assignment

## ✨ Versión Funcional Completa

Esta es una versión completamente funcional del plugin que NO requiere Moodle instalado. Funciona con un servidor local Node.js y se conecta a la API de OpenAI para evaluaciones reales.

## 📋 Requisitos

✅ **Node.js** instalado (descarga desde https://nodejs.org/)
✅ **Navegador web** moderno (Chrome, Firefox, Edge)
✅ **Conexión a internet** (para la API de OpenAI)

## 🚀 Inicio Rápido

### Opción 1: Usar el script automático (Windows)

1. Doble click en `iniciar-plugin.bat`
2. El servidor se iniciará automáticamente
3. Abre tu navegador en: http://localhost:3000

### Opción 2: Inicio manual

```bash
# Iniciar el servidor
node server-simple.js

# Abrir en el navegador
# http://localhost:3000
```

## 📋 Características

✅ **Crear Tareas** - Los profesores pueden crear problemas de programación o matemáticas
✅ **Enviar Respuestas** - Los estudiantes pueden enviar sus soluciones
✅ **Evaluación con IA Real** - Usa OpenAI GPT-4o-mini para evaluar automáticamente
✅ **Detección de Plagio** - Analiza similitudes entre envíos con IA
✅ **Almacenamiento Local** - Guarda todo en localStorage del navegador
✅ **Interfaz Moderna** - Diseño responsive y profesional

## 🎯 Cómo Usar

### 1. Iniciar el Servidor

**Windows:**
```bash
iniciar-plugin.bat
```

**Linux/Mac:**
```bash
node server-simple.js
```

### 2. Abrir la Aplicación

Abre tu navegador en: **http://localhost:3000**

### 3. Como Profesor (Pestaña "Profesor")

1. Completa el formulario:
   - **Nombre de la tarea**: Ej: "Factorial en Python"
   - **Descripción**: Instrucciones para los estudiantes
   - **Tipo**: Programación o Matemáticas
   - **Solución de referencia**: La solución correcta

2. Click en "Crear Tarea"

**Ejemplo de tarea de programación:**
```python
def factorial(n):
    if n == 0 or n == 1:
        return 1
    return n * factorial(n - 1)
```

**Ejemplo de tarea de matemáticas:**
```
Resolver: x² - 5x + 6 = 0
Solución: x = 2 o x = 3
Factorización: (x-2)(x-3) = 0
```

### 3. Como Estudiante (Pestaña "Estudiante")

1. Ve a la pestaña "Estudiante"
2. Verás las tareas disponibles
3. Click en "Enviar Respuesta"
4. Escribe tu solución
5. Click en "Enviar"
6. ¡La IA evaluará tu respuesta en tiempo real!

### 4. Ver Resultados (Pestaña "Resultados")

- Verás todos tus envíos
- Calificación automática (0-100%)
- Feedback de la IA
- Análisis detallado
- Tu respuesta completa

### 5. Detección de Plagio (Pestaña "Plagio")

1. Necesitas al menos 2 envíos para el mismo problema
2. Click en "Analizar Similitudes"
3. La IA comparará todos los pares de envíos
4. Verás:
   - Porcentaje de similitud
   - Comparación lado a lado
   - Clasificación por nivel (Alta/Media/Baja)

## 🔑 Configuración de API Key

La API key ya está configurada en `server-simple.js`. Si quieres cambiarla:

1. Abre `server-simple.js`
2. Busca la línea: `const API_KEY = '...'`
3. Reemplaza con tu nueva API key
4. Reinicia el servidor

⚠️ **IMPORTANTE**: Recuerda revocar la API key actual y crear una nueva.

## 💾 Almacenamiento

Todo se guarda en localStorage del navegador:
- **Tareas creadas**: Persisten entre sesiones
- **Envíos**: Se mantienen guardados
- **Evaluaciones**: Almacenadas localmente

Para borrar todos los datos:
```javascript
localStorage.clear()
```

## 🧪 Casos de Prueba Sugeridos

### Programación - Factorial
**Solución correcta:**
```python
def factorial(n):
    if n == 0:
        return 1
    return n * factorial(n - 1)
```

**Respuesta estudiante (correcta):**
```python
def factorial(n):
    if n <= 1:
        return 1
    return n * factorial(n - 1)
```

**Respuesta estudiante (incorrecta):**
```python
def factorial(n):
    return n * factorial(n - 1)  # Falta caso base
```

### Matemáticas - Ecuación Cuadrática
**Solución correcta:**
```
x² - 5x + 6 = 0
Factorización: (x-2)(x-3) = 0
x = 2 o x = 3
```

**Respuesta estudiante (correcta):**
```
Usando la fórmula general:
x = (5 ± √(25-24)) / 2
x = (5 ± 1) / 2
x = 3 o x = 2
```

## 🎨 Personalización

### Cambiar colores
Edita `plugin-funcional.css` y modifica las variables de color.

### Cambiar modelo de IA
En `plugin-funcional.js`, cambia:
```javascript
const API_MODEL = 'gpt-4o-mini';  // Puedes usar gpt-4o, gpt-4-turbo, etc.
```

## 🐛 Solución de Problemas

### Error: "Node.js no está instalado"
- Descarga e instala Node.js desde: https://nodejs.org/
- Reinicia tu terminal/cmd después de instalar

### Error: "Puerto 3000 ya está en uso"
- Cierra otras aplicaciones que usen el puerto 3000
- O cambia el puerto en `server-simple.js`: `const PORT = 3001;`

### Error: "Failed to fetch" o "CORS"
- Asegúrate de que el servidor esté corriendo
- Verifica que estés accediendo a http://localhost:3000 (no file://)
- Revisa la consola del servidor para ver errores

### Error: "API key inválida"
- Verifica que la API key en `server-simple.js` sea correcta
- Asegúrate de que la key no haya sido revocada
- Verifica que tengas créditos en tu cuenta de OpenAI

### La evaluación tarda mucho
- Es normal, la API de OpenAI puede tardar 5-10 segundos
- Espera a que aparezca la notificación de "Evaluación completada"
- Revisa la consola del servidor para ver el progreso

## 📊 Limitaciones

- Solo funciona con conexión a internet (necesita API de OpenAI)
- Los datos se guardan solo en tu navegador
- No hay autenticación de usuarios (es una demo)
- La API de OpenAI tiene límites de uso según tu plan

## 🚀 Próximos Pasos

Para usar esto en producción:
1. Instala el plugin completo en Moodle
2. Configura una base de datos real
3. Implementa autenticación de usuarios
4. Agrega más validaciones y seguridad

## 📖 Documentación Adicional

- `moodle-plugin/INSTALACION_DESDE_INTERFAZ.md` - Instalar en Moodle
- `RESUMEN_PRUEBA.md` - Resumen de opciones de prueba
- `moodle-plugin/MANUAL_USUARIO.md` - Manual completo

## ✅ Checklist de Prueba

- [ ] Crear una tarea de programación
- [ ] Crear una tarea de matemáticas
- [ ] Enviar una respuesta correcta
- [ ] Enviar una respuesta incorrecta
- [ ] Ver los resultados y feedback
- [ ] Crear múltiples envíos para el mismo problema
- [ ] Ejecutar análisis de plagio
- [ ] Verificar que los datos persisten al recargar

---

¡Disfruta probando el plugin funcional! 🎉
