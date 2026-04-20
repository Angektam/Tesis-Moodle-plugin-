# 🎮 Demo Standalone - Sistema de Evaluación con IA

Aplicación demo independiente del sistema de evaluación de tareas con IA y detección de plagio.

## 🚀 Inicio Rápido

### 1. Configurar API Key

```bash
# Desde la raíz del proyecto
cp .env.example .env
# Edita .env y agrega tu OPENAI_API_KEY
```

### 2. Instalar Dependencias

```bash
# Desde la raíz del proyecto
npm install
```

### 3. Iniciar Servidor

```bash
# Opción 1: Servidor completo
node server.js

# Opción 2: Servidor demo (datos de prueba)
node server-demo.js

# Opción 3: Servidor simple
node server-simple.js
```

### 4. Abrir en Navegador

```
http://localhost:5000
```

---

## 📁 Archivos

### Servidores

- **server.js** - Servidor completo con todas las funcionalidades
- **server-demo.js** - Servidor con datos de prueba precargados
- **server-simple.js** - Servidor minimalista para pruebas rápidas

### Interfaz

- **plugin-funcional.html** - Interfaz principal del sistema
- **plugin-funcional.js** - Lógica de la aplicación
- **plugin-funcional.css** - Estilos de la interfaz

### Pruebas

- **test-plugin-automatico.html** - Pruebas automatizadas
- **test-plugin.php** - Pruebas PHP (requiere servidor PHP)

---

## 🎯 Funcionalidades

### 1. Evaluación Automática
- Crear problemas de matemáticas o programación
- Enviar respuestas de estudiantes
- Evaluación automática con IA
- Feedback detallado

### 2. Detección de Plagio
- Análisis de similitud entre envíos
- Detección semántica, estructural y lógica
- Reportes visuales de plagio
- Identificación de usuarios sospechosos

### 3. Sistema de Entrenamiento
- Base de conocimiento local
- Ejemplos de código bueno y malo
- Evaluación sin gastar API
- Importar/Exportar datos

---

## 🔧 Configuración

### Variables de Entorno (.env)

```env
PORT=5000
OPENAI_API_KEY=tu-api-key-aqui
```

### Puertos

- **5000** - Puerto por defecto del servidor
- Puedes cambiar el puerto en el archivo .env

---

## 📊 Modos de Operación

### Modo Demo (server-demo.js)

- Datos de prueba precargados
- 3 problemas de ejemplo
- 5 estudiantes ficticios
- 10 envíos de muestra
- Ideal para demostración

### Modo Real (server.js)

- Base de datos vacía
- Crear tus propios problemas
- Agregar estudiantes reales
- Evaluaciones reales con API
- Ideal para producción

### Modo Simple (server-simple.js)

- Funcionalidad mínima
- Solo evaluación básica
- Sin base de datos
- Ideal para pruebas rápidas

---

## 🧪 Casos de Prueba

### Problema de Matemáticas

**Problema:** Calcula el factorial de 5

**Solución Correcta:**
```
5! = 5 × 4 × 3 × 2 × 1 = 120
```

**Solución Incorrecta:**
```
5! = 5 + 4 + 3 + 2 + 1 = 15
```

### Problema de Programación

**Problema:** Escribe una función que calcule el factorial

**Solución Correcta (Python):**
```python
def factorial(n):
    if n <= 1:
        return 1
    return n * factorial(n - 1)
```

**Solución Incorrecta:**
```python
def factorial(n):
    return n + n - 1
```

---

## 🔍 Detección de Plagio

### Ejemplo de Plagio

**Envío 1:**
```python
def suma(a, b):
    return a + b
```

**Envío 2 (Plagio):**
```python
def sumar(x, y):
    return x + y
```

El sistema detectará:
- Similitud semántica: 95%
- Similitud estructural: 90%
- Similitud lógica: 100%

---

## 📝 Notas

### Diferencias con Plugin Moodle

| Característica | Demo Standalone | Plugin Moodle |
|----------------|-----------------|---------------|
| Instalación | Simple (npm install) | Requiere Moodle |
| Autenticación | Básica | Moodle completo |
| Base de datos | SQLite/Memoria | MySQL/PostgreSQL |
| Usuarios | Simulados | Reales de Moodle |
| Ideal para | Demos y pruebas | Producción |

### Limitaciones

- No tiene sistema de roles completo
- No integra con cursos de Moodle
- Base de datos simple
- Sin notificaciones
- Sin backup/restore

### Ventajas

- Fácil de instalar
- No requiere Moodle
- Ideal para demostración
- Rápido de probar
- Portátil

---

## 🚀 Despliegue

### Local

```bash
node server.js
```

### Producción (Heroku)

```bash
# Crear app
heroku create mi-app-evaluacion

# Configurar variables
heroku config:set OPENAI_API_KEY=tu-api-key

# Desplegar
git push heroku main
```

### Producción (Docker)

```dockerfile
FROM node:18
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 5000
CMD ["node", "server.js"]
```

---

## 📚 Documentación Relacionada

- [../docs/usuario/GUIA_RAPIDA.md](../docs/usuario/GUIA_RAPIDA.md) - Guía rápida
- [../docs/usuario/CASOS_PRUEBA_MANUAL.md](../docs/usuario/CASOS_PRUEBA_MANUAL.md) - Casos de prueba
- [../docs/usuario/MODO_DEMO_VS_REAL.md](../docs/usuario/MODO_DEMO_VS_REAL.md) - Diferencias
- [../docs/tecnica/FUNCIONALIDAD_PLAGIO.md](../docs/tecnica/FUNCIONALIDAD_PLAGIO.md) - Especificación técnica

---

## 🐛 Solución de Problemas

### Error: "Cannot find module 'express'"
```bash
npm install
```

### Error: "OPENAI_API_KEY no encontrada"
```bash
# Verifica que .env existe y tiene la API key
cat ../.env
```

### Error: "Port 5000 already in use"
```bash
# Cambia el puerto en .env
PORT=3000
```

### Error: "fetch is not defined"
```bash
# Actualiza Node.js a v18+
node --version
```

---

## 📞 Soporte

Para más ayuda, consulta:
- [../README.md](../README.md) - README principal
- [../docs/INDICE_DOCUMENTACION.md](../docs/INDICE_DOCUMENTACION.md) - Índice de documentación

---

**Parte del Proyecto de Tesis**
**Fecha:** Marzo 2026
