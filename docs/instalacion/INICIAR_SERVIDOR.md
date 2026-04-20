# 🚀 Cómo Iniciar el Servidor Backend

## ⚠️ Problema CORS Resuelto

El navegador bloquea las llamadas directas a OpenAI por políticas CORS. 
La solución es usar un servidor backend que haga las llamadas por ti.

---

## 📋 Pasos para Iniciar

### 1. Instalar Node.js (si no lo tienes)

Descarga e instala desde: https://nodejs.org/

Verifica la instalación:
```cmd
node -v
npm -v
```

### 2. Instalar Dependencias

Abre una terminal en la carpeta del proyecto y ejecuta:

```cmd
npm install
```

Esto instalará:
- express (servidor web)
- cors (permitir peticiones del navegador)
- node-fetch (hacer peticiones a OpenAI)
- dotenv (leer variables de entorno)

### 3. Iniciar el Servidor

```cmd
npm start
```

Verás un mensaje como:
```
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║   🚀 SERVIDOR BACKEND INICIADO                              ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝

✅ Servidor corriendo en: http://localhost:3000
✅ Plugin disponible en: http://localhost:3000/plugin-funcional.html
```

### 4. Abrir el Plugin

Abre tu navegador y ve a:
```
http://localhost:3000/plugin-funcional.html
```

---

## ✅ ¡Listo!

Ahora el plugin funcionará correctamente con evaluación real de IA.

---

## 🛑 Detener el Servidor

Presiona `Ctrl + C` en la terminal donde está corriendo el servidor.

---

## 🔧 Solución de Problemas

### Error: "Cannot find module 'express'"

Ejecuta:
```cmd
npm install
```

### Error: "Port 3000 is already in use"

Cambia el puerto en `server.js`:
```javascript
const PORT = 3001; // Cambia a otro puerto
```

### Error: "OPENAI_API_KEY not found"

Verifica que el archivo `.env` existe y tiene tu API key:
```
OPENAI_API_KEY=tu-api-key-aqui
```

---

## 📝 Comandos Útiles

```cmd
# Instalar dependencias
npm install

# Iniciar servidor
npm start

# Iniciar con auto-reload (desarrollo)
npm run dev

# Ver versión de Node
node -v

# Ver versión de npm
npm -v
```

---

## 🎯 Flujo Completo

1. Terminal: `npm install` (solo la primera vez)
2. Terminal: `npm start`
3. Navegador: `http://localhost:3000/plugin-funcional.html`
4. Usa el plugin normalmente
5. Terminal: `Ctrl + C` para detener

---

## 💡 Ventajas del Servidor Backend

✅ Resuelve problemas de CORS
✅ API key segura (no expuesta en el navegador)
✅ Mejor control de errores
✅ Logs de las peticiones
✅ Fácil de desplegar en producción

---

## 🚀 Despliegue en Producción

Para usar en producción, puedes desplegar en:

- **Heroku**: https://heroku.com (gratis)
- **Vercel**: https://vercel.com (gratis)
- **Railway**: https://railway.app (gratis)
- **Render**: https://render.com (gratis)

---

¡Disfruta del plugin funcional! 🎉
