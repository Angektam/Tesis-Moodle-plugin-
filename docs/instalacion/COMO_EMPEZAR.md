# 🚀 ¿Cómo Empezar?

## Tienes 3 Opciones

### 🧪 Opción 1: Entorno de Prueba (Recomendado para empezar)

**Tiempo:** 5 minutos  
**Dificultad:** ⭐ Muy fácil  
**Requiere:** PHP + API Key de OpenAI

```bash
# 1. Configurar
cp .env.example .env
# Edita .env con tu OPENAI_API_KEY

# 2. Probar
cd test-environment
php check-setup.php
php demo-visual.php
```

**Ventajas:**
- ✅ No necesitas instalar Moodle
- ✅ Pruebas inmediatas
- ✅ 18 casos de prueba reales
- ✅ Reportes automáticos

**Documentación:**
- `test-environment/INICIO_RAPIDO.md`
- `test-environment/GUIA_USO.md`

---

### 🌐 Opción 2: Servidor Web Standalone

**Tiempo:** 10 minutos  
**Dificultad:** ⭐⭐ Fácil  
**Requiere:** Node.js + API Key de OpenAI

```bash
# 1. Instalar dependencias
npm run install:all

# 2. Configurar
cd server
cp .env.example .env
# Edita .env con tu OPENAI_API_KEY

# 3. Iniciar
cd ..
npm run dev
```

**Acceso:**
- Frontend: http://localhost:3000
- Backend: http://localhost:5000

**Ventajas:**
- ✅ Interfaz web completa
- ✅ Sistema independiente de Moodle
- ✅ Base de datos SQLite
- ✅ Autenticación de usuarios

**Documentación:**
- `README.md` (sección "Instalación")
- `USUARIOS_PRUEBA.md`

---

### 🎓 Opción 3: Plugin de Moodle

**Tiempo:** 10-60 minutos (según método)  
**Dificultad:** ⭐⭐ Fácil a Media  
**Requiere:** Moodle instalado + API Key de OpenAI

#### 3A. Instalar desde la Interfaz de Moodle ⭐ (Más Fácil)

**Tiempo:** 10 minutos  
**No requiere acceso SSH/FTP**

```bash
# 1. Crear ZIP del plugin
# Windows:
crear-zip-plugin.bat

# Linux/Mac:
./crear-zip-plugin.sh

# 2. Instalar en Moodle
# - Inicia sesión como administrador
# - Site administration → Plugins → Install plugins
# - Sube aiassignment.zip
# - Sigue las instrucciones

# 3. Configurar API Key
# Site administration → Plugins → Activity modules → AI Assignment
```

#### 3B. Instalación Manual (Requiere acceso al servidor)

**Recomendado: Bitnami Moodle Stack**

```bash
# 1. Descargar e instalar Bitnami Moodle
# https://bitnami.com/stack/moodle/installer

# 2. Copiar plugin
# Windows:
xcopy /E /I moodle-plugin "C:\Bitnami\moodle-X.X.X\apps\moodle\htdocs\mod\aiassignment"

# Linux/Mac:
sudo cp -r moodle-plugin /opt/bitnami/moodle/apps/moodle/htdocs/mod/aiassignment

# 3. Activar en Moodle
# Site administration → Notifications → Upgrade database

# 4. Configurar API Key
# Site administration → Plugins → Activity modules → AI Assignment
```

**Ventajas:**
- ✅ Integración completa con Moodle
- ✅ Usa roles y permisos de Moodle
- ✅ Gestión de cursos nativa
- ✅ Listo para producción

**Documentación:**
- `moodle-plugin/INSTALACION_DESDE_INTERFAZ.md` ⭐ Instalación fácil
- `GUIA_INSTALACION_MOODLE_LOCAL.md` - Instalar Moodle
- `moodle-plugin/INSTALACION.md` - Instalación manual
- `moodle-plugin/MANUAL_USUARIO.md` - Guía de uso

#### 3C. Explorar Moodle Demo (Solo visualización)

**URL:** https://moodle.org/demo

⚠️ **Limitación:** No puedes instalar plugins en la demo pública

**Útil para:**
- Ver cómo funciona Moodle
- Explorar actividades similares
- Familiarizarte con la interfaz

**Documentación:**
- `moodle-plugin/PRUEBA_EN_DEMO_MOODLE.md`

---

## 🎯 ¿Cuál Elegir?

### Para Desarrollo y Pruebas Rápidas
```
→ Opción 1: Entorno de Prueba
```
- Más rápido
- Sin instalaciones complejas
- Ideal para validar el evaluador de IA

### Para Demostración o Uso Independiente
```
→ Opción 2: Servidor Web Standalone
```
- Interfaz completa
- Sistema independiente
- Fácil de mostrar a otros

### Para Integración con Moodle Existente
```
→ Opción 3: Plugin de Moodle
```
- Integración nativa
- Usa infraestructura de Moodle
- Producción

---

## 📊 Comparación Rápida

| Característica | Entorno Prueba | Servidor Web | Plugin Moodle |
|----------------|----------------|--------------|---------------|
| **Tiempo setup** | 5 min | 10 min | 30-60 min |
| **Dificultad** | ⭐ | ⭐⭐ | ⭐⭐⭐ |
| **Requiere Moodle** | ❌ | ❌ | ✅ |
| **Interfaz web** | ❌ | ✅ | ✅ |
| **Casos de prueba** | ✅ 18 casos | ❌ | ❌ |
| **Reportes JSON** | ✅ | ❌ | ❌ |
| **Autenticación** | ❌ | ✅ | ✅ (Moodle) |
| **Base de datos** | ❌ | SQLite | MySQL/PostgreSQL |
| **Producción** | ❌ | ✅ | ✅ |

---

## 🔄 Flujo Recomendado

```
1. Entorno de Prueba (5 min)
   ↓
   Validar que el evaluador funciona correctamente
   ↓
2. Servidor Web (10 min) [Opcional]
   ↓
   Ver la interfaz completa y demostrar
   ↓
3. Plugin Moodle (30-60 min)
   ↓
   Integrar en Moodle para producción
```

---

## 📚 Documentación por Opción

### Opción 1: Entorno de Prueba
```
test-environment/
├── LEEME_PRIMERO.txt      ⭐ Empieza aquí
├── INICIO_RAPIDO.md       📖 Guía de 5 minutos
├── GUIA_USO.md           📘 Manual completo
├── EJEMPLOS_SALIDA.md    📊 Ver ejemplos
└── ESTRUCTURA.md         🗺️  Mapa del entorno
```

### Opción 2: Servidor Web
```
README.md                  📖 Instalación y uso
USUARIOS_PRUEBA.md        👥 Usuarios de prueba
server/                   🔧 Código del backend
client/                   🎨 Código del frontend
```

### Opción 3: Plugin Moodle
```
GUIA_INSTALACION_MOODLE_LOCAL.md  📖 Instalar Moodle
moodle-plugin/
├── INSTALACION.md        📘 Instalar plugin
├── MANUAL_USUARIO.md     👤 Guía de uso
├── COMPONENTES.md        🔧 Arquitectura
└── PRUEBA_EN_DEMO_MOODLE.md  🌐 Demo online
```

---

## 🆘 Ayuda Rápida

### Problemas con API Key
```bash
# Verifica que .env existe y tiene tu key
cat .env | grep OPENAI_API_KEY
```

### Problemas con PHP
```bash
# Verifica versión (requiere 7.4+)
php -v

# Verifica extensiones
php -m | grep curl
php -m | grep json
```

### Problemas con Node.js
```bash
# Verifica versión (requiere 18+)
node -v
npm -v
```

### Problemas con Moodle
```bash
# Revisa logs de Moodle
# Site administration → Reports → Logs

# Verifica permisos de archivos
ls -la /ruta/a/moodle/mod/aiassignment
```

---

## 🎓 Recursos Adicionales

### Documentación del Proyecto
- `README.md` - Visión general
- `ESTRUCTURA_BD.md` - Esquema de base de datos
- `GUIA_RAPIDA.md` - Referencia rápida

### Documentación de Moodle
- https://docs.moodle.org/
- https://moodledev.io/
- https://docs.moodle.org/dev/Activity_modules

### OpenAI
- https://platform.openai.com/docs
- https://platform.openai.com/api-keys

---

## ✅ Checklist de Inicio

### Antes de Empezar
- [ ] Tengo una API Key de OpenAI
- [ ] Tengo PHP instalado (para Opción 1 o 3)
- [ ] Tengo Node.js instalado (para Opción 2)
- [ ] He leído este documento

### Opción 1: Entorno de Prueba
- [ ] Copié .env.example a .env
- [ ] Configuré OPENAI_API_KEY
- [ ] Ejecuté check-setup.php
- [ ] Probé demo-visual.php
- [ ] Revisé los resultados

### Opción 2: Servidor Web
- [ ] Instalé dependencias (npm run install:all)
- [ ] Configuré .env en server/
- [ ] Inicié el servidor (npm run dev)
- [ ] Accedí a http://localhost:3000
- [ ] Probé crear problemas y enviar respuestas

### Opción 3: Plugin Moodle
- [ ] Instalé Moodle localmente
- [ ] Copié el plugin a mod/aiassignment
- [ ] Actualicé la base de datos
- [ ] Configuré API Key en Moodle
- [ ] Creé un curso de prueba
- [ ] Agregué actividad AI Assignment
- [ ] Probé como estudiante

---

## 🚀 ¡Empieza Ahora!

**Recomendación:** Empieza con la Opción 1 (Entorno de Prueba)

```bash
cd test-environment
cat LEEME_PRIMERO.txt
php demo-visual.php
```

**Tiempo total:** 5 minutos para ver el evaluador en acción

¡Buena suerte! 🎉
