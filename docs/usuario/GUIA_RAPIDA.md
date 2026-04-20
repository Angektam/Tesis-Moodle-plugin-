# Guía Rápida de Uso

## 🚀 Inicio Rápido

### 1. Configuración Inicial

```bash
# Instalar todas las dependencias
npm run install:all

# Configurar variables de entorno
cd server
cp .env.example .env
# Editar .env y agregar tu OPENAI_API_KEY
```

### 2. Ejecutar en Desarrollo

```bash
# Desde la raíz del proyecto
npm run dev
```

Esto iniciará:
- **Backend**: http://localhost:5000
- **Frontend**: http://localhost:3000

## 👨‍🏫 Para Maestros

### Crear un Problema

1. Inicia sesión como maestro
2. Ve a "Crear Problema"
3. Completa el formulario:
   - **Título**: Nombre descriptivo del problema
   - **Tipo**: Matemáticas o Programación
   - **Descripción**: Explica qué debe resolver el alumno
   - **Documentación**: Información adicional (opcional)
   - **Solución**: La respuesta correcta (será usada por la IA para comparar)
   - **Casos de Prueba**: Ejemplos (opcional)

### Ver Envíos de Alumnos

1. Ve a tu Dashboard
2. Haz clic en un problema
3. Verás todos los envíos de los alumnos
4. Puedes forzar una re-evaluación si es necesario

## 👨‍🎓 Para Alumnos

### Resolver un Problema

1. Inicia sesión como alumno
2. Ve a "Problemas"
3. Selecciona un problema
4. Lee la descripción y documentación
5. Escribe tu respuesta en el área de texto
6. Haz clic en "Enviar Respuesta"

### Ver Resultados

1. Ve a "Mis Envíos"
2. Verás todos tus envíos con su estado
3. Haz clic en "Ver detalles" para ver:
   - Tu respuesta
   - Calificación (porcentaje)
   - Retroalimentación de la IA
   - Análisis detallado

## 🤖 Cómo Funciona la Evaluación con IA

Cuando un alumno envía una respuesta:

1. El sistema obtiene la solución del maestro
2. Envía ambas respuestas a OpenAI GPT-4o-mini
3. La IA compara y analiza:
   - **Matemáticas**: Corrección, método, claridad
   - **Programación**: Funcionalidad, estilo, buenas prácticas
4. Genera:
   - Score de similitud (0-100%)
   - Retroalimentación breve
   - Análisis detallado

## 📝 Ejemplos de Problemas

### Problema Matemático

**Título**: Resolver ecuación cuadrática

**Descripción**: 
Resuelve la ecuación: x² - 5x + 6 = 0
Muestra todos los pasos de tu solución.

**Solución**:
x² - 5x + 6 = 0
(x - 2)(x - 3) = 0
x = 2 o x = 3

### Problema de Programación

**Título**: Función para calcular factorial

**Descripción**:
Escribe una función en Python que calcule el factorial de un número n.
La función debe manejar el caso cuando n = 0.

**Solución**:
```python
def factorial(n):
    if n == 0:
        return 1
    result = 1
    for i in range(1, n + 1):
        result *= i
    return result
```

## ⚠️ Solución de Problemas Comunes

### La evaluación no funciona

- Verifica que tu `OPENAI_API_KEY` sea válida
- Revisa la consola del servidor para ver errores
- Asegúrate de tener créditos en tu cuenta de OpenAI

### No puedo iniciar sesión

- Verifica que el servidor esté corriendo
- Revisa la consola del navegador para errores
- Asegúrate de haber registrado una cuenta

### Los problemas no se muestran

- Verifica que hayas creado problemas como maestro
- Revisa la consola del navegador
- Asegúrate de estar autenticado

## 🔧 Comandos Útiles

```bash
# Desarrollo
npm run dev              # Iniciar todo en desarrollo
npm run dev:server       # Solo backend
npm run dev:client       # Solo frontend

# Producción
npm run build            # Compilar todo
cd server && npm start   # Iniciar servidor compilado
```

## 📚 Recursos Adicionales

- [Documentación de OpenAI](https://platform.openai.com/docs)
- [React Documentation](https://react.dev)
- [Express Documentation](https://expressjs.com)
