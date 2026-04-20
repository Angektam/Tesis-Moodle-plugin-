# 🚀 Fase 1: Implementación de APIs Críticas

## Judge0 CE + GitHub API + VirusTotal

Guía paso a paso para implementar las 3 APIs más importantes del proyecto.

---

## 📋 Requisitos Previos

- Node.js 18+
- Cuenta en RapidAPI (para Judge0)
- GitHub Personal Access Token
- Cuenta en VirusTotal
- OpenAI API Key (ya configurada)

---

## 1️⃣ Judge0 CE - Ejecución de Código

### Paso 1: Obtener API Key

1. Ir a [RapidAPI Judge0](https://rapidapi.com/judge0-official/api/judge0-ce)
2. Crear cuenta gratuita
3. Suscribirse al plan gratuito (50 requests/día)
4. Copiar tu API Key

### Paso 2: Configurar Variables de Entorno

```bash
# Agregar a .env
JUDGE0_API_KEY=tu-rapidapi-key-aqui
JUDGE0_API_HOST=judge0-ce.p.rapidapi.com
JUDGE0_API_URL=https://judge0-ce.p.rapidapi.com
```

### Paso 3: Instalar Dependencias

```bash
npm install node-fetch@2.7.0
```

### Paso 4: Probar Conexión

```bash
node demo-standalone/test-judge0.js
```

---

## 2️⃣ GitHub API - Detección de Plagio Externo

### Paso 1: Crear Personal Access Token

1. Ir a [GitHub Settings > Developer settings > Personal access tokens](https://github.com/settings/tokens)
2. Click "Generate new token (classic)"
3. Seleccionar scopes:
   - `public_repo` (acceso a repos públicos)
   - `read:user` (leer info de usuario)
4. Copiar el token (solo se muestra una vez)

### Paso 2: Configurar Variables de Entorno

```bash
# Agregar a .env
GITHUB_TOKEN=ghp_tu-token-aqui
GITHUB_API_URL=https://api.github.com
```

### Paso 3: Probar Conexión

```bash
node demo-standalone/test-github.js
```

---

## 3️⃣ VirusTotal - Seguridad

### Paso 1: Obtener API Key

1. Ir a [VirusTotal](https://www.virustotal.com/)
2. Crear cuenta gratuita
3. Ir a tu perfil > API Key
4. Copiar tu API Key

### Paso 2: Configurar Variables de Entorno

```bash
# Agregar a .env
VIRUSTOTAL_API_KEY=tu-virustotal-key-aqui
VIRUSTOTAL_API_URL=https://www.virustotal.com/api/v3
```

### Paso 3: Probar Conexión

```bash
node demo-standalone/test-virustotal.js
```

---

## 📝 Archivo .env Completo

```env
# OpenAI (Ya configurado)
OPENAI_API_KEY=sk-...

# Judge0 CE
JUDGE0_API_KEY=tu-rapidapi-key
JUDGE0_API_HOST=judge0-ce.p.rapidapi.com
JUDGE0_API_URL=https://judge0-ce.p.rapidapi.com

# GitHub API
GITHUB_TOKEN=ghp_tu-token
GITHUB_API_URL=https://api.github.com

# VirusTotal
VIRUSTOTAL_API_KEY=tu-virustotal-key
VIRUSTOTAL_API_URL=https://www.virustotal.com/api/v3

# Servidor
PORT=5000
```

---

## 🧪 Scripts de Prueba

### Test Judge0

```bash
# Ejecutar código Python
node demo-standalone/test-judge0.js python "print('Hello World')"

# Ejecutar código JavaScript
node demo-standalone/test-judge0.js javascript "console.log('Hello World')"
```

### Test GitHub

```bash
# Buscar código similar
node demo-standalone/test-github.js "function factorial(n)"

# Buscar en lenguaje específico
node demo-standalone/test-github.js "def factorial" python
```

### Test VirusTotal

```bash
# Escanear archivo
node demo-standalone/test-virustotal.js archivo.py

# Escanear URL
node demo-standalone/test-virustotal.js https://example.com
```

---

## 🔧 Integración con el Sistema

### 1. Evaluación con Ejecución de Código

```javascript
// Antes (solo IA)
const evaluation = await evaluateWithAI(code);

// Después (IA + Ejecución)
const aiEvaluation = await evaluateWithAI(code);
const executionResult = await executeCode(code, testCases);
const finalScore = (aiEvaluation.score + executionResult.score) / 2;
```

### 2. Detección de Plagio Externo

```javascript
// Buscar código similar en GitHub
const similarCode = await searchGitHub(studentCode);
if (similarCode.length > 0) {
  // Alertar posible plagio externo
  flagPlagiarism(submission, similarCode);
}
```

### 3. Escaneo de Seguridad

```javascript
// Antes de guardar archivo
const scanResult = await scanFile(uploadedFile);
if (scanResult.malicious) {
  // Rechazar archivo
  throw new Error('Archivo malicioso detectado');
}
```

---

## 📊 Límites de Rate

### Judge0 (Plan Gratuito)
- 50 requests/día
- 1 request cada 2 segundos
- **Recomendación**: Cachear resultados

### GitHub API
- 5,000 requests/hora (autenticado)
- 60 requests/hora (sin autenticar)
- **Recomendación**: Usar autenticación

### VirusTotal (Plan Gratuito)
- 4 requests/minuto
- 500 requests/día
- **Recomendación**: Escanear solo archivos sospechosos

---

## 💰 Costos Estimados

### Escenario: 30 estudiantes, 10 tareas

**Judge0**:
- Plan gratuito: 50 requests/día
- Necesario: ~300 ejecuciones/mes
- **Costo**: $0 (gratis) o $10/mes (plan básico)

**GitHub API**:
- Plan gratuito: 5,000 requests/hora
- Necesario: ~100 búsquedas/mes
- **Costo**: $0 (gratis)

**VirusTotal**:
- Plan gratuito: 500 requests/día
- Necesario: ~50 escaneos/mes
- **Costo**: $0 (gratis)

**Total Fase 1**: $0-10/mes

---

## 🎯 Funcionalidades Nuevas

### 1. Ejecución Automática de Código
- ✅ Validar que el código funciona
- ✅ Probar con casos de prueba
- ✅ Detectar errores de runtime
- ✅ Medir tiempo de ejecución

### 2. Detección de Plagio Externo
- ✅ Buscar código en GitHub
- ✅ Comparar con repos públicos
- ✅ Identificar fuentes
- ✅ Generar reportes

### 3. Seguridad Mejorada
- ✅ Escanear archivos subidos
- ✅ Detectar malware
- ✅ Proteger el sistema
- ✅ Logs de seguridad

---

## 🐛 Solución de Problemas

### Error: "API Key inválida"
```bash
# Verificar que las keys están en .env
cat .env | grep API_KEY

# Verificar que .env se carga
node -e "require('dotenv').config(); console.log(process.env.JUDGE0_API_KEY)"
```

### Error: "Rate limit exceeded"
```bash
# Implementar caché
# Ver: demo-standalone/services/cache.js
```

### Error: "Network timeout"
```bash
# Aumentar timeout
# Ver: demo-standalone/services/config.js
```

---

## 📚 Documentación de Referencia

- [Judge0 Docs](https://ce.judge0.com/)
- [GitHub API Docs](https://docs.github.com/en/rest)
- [VirusTotal API Docs](https://developers.virustotal.com/reference/overview)

---

## ✅ Checklist de Implementación

### Configuración
- [ ] Obtener Judge0 API Key
- [ ] Obtener GitHub Token
- [ ] Obtener VirusTotal API Key
- [ ] Configurar .env
- [ ] Instalar dependencias

### Testing
- [ ] Probar Judge0
- [ ] Probar GitHub API
- [ ] Probar VirusTotal
- [ ] Verificar límites de rate

### Integración
- [ ] Crear servicios
- [ ] Integrar con evaluador
- [ ] Integrar con detector de plagio
- [ ] Agregar escaneo de seguridad

### Documentación
- [ ] Actualizar README
- [ ] Documentar nuevas funcionalidades
- [ ] Crear guías de usuario

---

## 🚀 Siguiente Paso

Una vez completada la Fase 1, continuar con:
- **Fase 2**: Sendgrid + Google Analytics
- **Fase 3**: Roboflow + Auth0

---

**Guía creada:** Marzo 6, 2026
**Tiempo estimado:** 2-3 horas
**Dificultad:** Media
