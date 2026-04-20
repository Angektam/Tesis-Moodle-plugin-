# 🔑 Configurar API Key de OpenAI

## ⚠️ Problema Actual

La API key anterior ya no es válida. Necesitas configurar una nueva.

---

## 📝 Pasos Rápidos

### 1. Obtener API Key

Ve a: **https://platform.openai.com/api-keys**

- Inicia sesión en tu cuenta de OpenAI
- Click en "Create new secret key"
- Copia la key (empieza con `sk-proj-...`)

### 2. Configurar en el Proyecto

Edita el archivo `.env` en la raíz del proyecto:

```env
OPENAI_API_KEY=sk-proj-TU-API-KEY-AQUI
OPENAI_MODEL=gpt-4o-mini
```

**Reemplaza** `sk-proj-TU-API-KEY-AQUI` con tu API key real.

### 3. Iniciar el Servidor

```cmd
npm start
```

### 4. Abrir el Plugin

Abre tu navegador en:
```
http://localhost:3000/plugin-funcional.html
```

---

## ✅ Verificación

Si todo está bien, verás:

```
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║   🚀 SERVIDOR BACKEND INICIADO                              ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝

✅ Servidor corriendo en: http://localhost:3000
```

---

## ❌ Si ves un error

### Error: "API KEY NO CONFIGURADA"

**Solución:**
1. Verifica que el archivo `.env` existe
2. Verifica que tiene tu API key
3. Verifica que no hay espacios extra
4. Reinicia el servidor

### Error: "Incorrect API key provided"

**Solución:**
1. La API key es incorrecta o fue revocada
2. Crea una nueva en https://platform.openai.com/api-keys
3. Actualiza el archivo `.env`
4. Reinicia el servidor

### Error: "Cannot find module"

**Solución:**
```cmd
npm install
npm start
```

---

## 💡 Consejos de Seguridad

✅ **SÍ hacer:**
- Guardar la API key en el archivo `.env`
- Mantener el archivo `.env` privado
- Revocar keys si las expones accidentalmente
- Usar keys diferentes para desarrollo y producción

❌ **NO hacer:**
- Compartir tu API key públicamente
- Subirla a GitHub (el `.env` está en `.gitignore`)
- Usar la misma key en múltiples proyectos públicos
- Dejar keys en el código fuente

---

## 🔄 Flujo Completo

```
1. Obtener API key de OpenAI
   ↓
2. Editar .env con tu API key
   ↓
3. npm start
   ↓
4. Abrir http://localhost:3000/plugin-funcional.html
   ↓
5. ¡Usar el plugin!
```

---

## 📞 Recursos

- **OpenAI API Keys**: https://platform.openai.com/api-keys
- **Documentación OpenAI**: https://platform.openai.com/docs
- **Precios**: https://openai.com/pricing

---

## 💰 Costos

El modelo `gpt-4o-mini` es muy económico:

- **Input**: $0.150 por 1M tokens (~750,000 palabras)
- **Output**: $0.600 por 1M tokens (~750,000 palabras)

Una evaluación típica usa ~500 tokens = $0.0003 (menos de 1 centavo)

---

¡Listo! Una vez configurada tu API key, el plugin funcionará perfectamente. 🚀
