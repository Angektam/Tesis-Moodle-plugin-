# Sistema de Evaluación de Tareas con IA + Detección de Plagio

## 🎯 Proyecto de Tesis

**"Desarrollo de un plugin prototipo en la plataforma Moodle que proporcione la detección de plagio de código fuente con IA en entornos educativos, para incrementar la eficiencia en la detección de trabajos escolares duplicados."**

---

Sistema web y plugin para Moodle que combina evaluación automática de tareas con detección avanzada de plagio de código fuente utilizando inteligencia artificial.

## 📋 Descripción

Este sistema permite a los maestros crear problemas con sus soluciones, y a los alumnos enviar sus respuestas. La IA compara automáticamente las respuestas de los alumnos con las soluciones del maestro, proporcionando retroalimentación y calificaciones.

### Características principales

- **Autenticación de usuarios**: Sistema de registro y login para maestros y alumnos
- **Gestión de problemas**: Los maestros pueden crear, editar y eliminar problemas
- **Envío de respuestas**: Los alumnos pueden enviar sus soluciones
- **Evaluación automática con IA**: Comparación inteligente de respuestas usando OpenAI
- **Detección de plagio con IA**: 🆕 Análisis semántico para detectar código duplicado
- **Sistema de Entrenamiento**: 🆕 Base de conocimiento local para evaluar sin gastar API
- **Retroalimentación detallada**: Análisis y comentarios sobre las respuestas
- **Interfaz moderna**: Diseño responsive y fácil de usar

## 🛠️ Tecnologías Utilizadas

### Backend
- **Node.js** con **Express**
- **TypeScript**
- **SQLite** (base de datos)
- **OpenAI API** (evaluación con IA)
- **JWT** (autenticación)
- **bcryptjs** (hash de contraseñas)

### Frontend
- **React** con **TypeScript**
- **Vite** (build tool)
- **React Router** (navegación)
- **Axios** (peticiones HTTP)
- **React Hot Toast** (notificaciones)

## 📦 Instalación

### Requisitos previos
- Node.js (v18 o superior)
- npm o yarn
- Cuenta de OpenAI con API key

### Pasos de instalación

1. **Clonar o descargar el proyecto**

2. **Instalar dependencias**
```bash
npm run install:all
```

3. **Configurar variables de entorno**

   En la carpeta `server`, crear un archivo `.env` basado en `.env.example`:
```bash
cd server
cp .env.example .env
```

   Editar `.env` y agregar tu API key de OpenAI:
```
PORT=5000
JWT_SECRET=tu-secret-key-muy-segura-cambiar-en-produccion
OPENAI_API_KEY=tu-api-key-de-openai-aqui
```

4. **Inicializar la base de datos**

   La base de datos se creará automáticamente al iniciar el servidor.

## 🚀 Uso

### Opción 1: Plugin de Moodle (Recomendado)

```bash
# Windows
scripts\crear-zip-plugin.bat

# Linux/Mac
./scripts/crear-zip-plugin.sh

# Luego instalar en Moodle:
# Site administration → Plugins → Install plugins
```

### Opción 2: Demo Standalone

```bash
npm install
npm run demo

# Abre http://localhost:3000
```

### Opción 3: Servidor de Desarrollo

```bash
cd demo-standalone
node server.js

# Abre http://localhost:5000
```

## 📁 Estructura del Proyecto

```
proyecto-tesis-plagio-ia/
│
├── 📁 docs/                           # Documentación completa
│   ├── tesis/                         # Documentos de tesis
│   ├── instalacion/                   # Guías de instalación
│   ├── usuario/                       # Manuales de usuario
│   └── tecnica/                       # Documentación técnica
│
├── 📁 moodle-plugin/                  # Plugin principal para Moodle
│   ├── classes/                       # Clases PHP
│   │   ├── ai_evaluator.php          # Evaluador de IA
│   │   └── plagiarism_detector.php   # Detector de plagio
│   ├── db/                            # Esquema de base de datos
│   ├── lang/                          # Traducciones (ES/EN)
│   └── [otros archivos del plugin]
│
├── 📁 entrenamiento-ia/               # Sistema de entrenamiento IA
│   ├── ejemplos-codigo/               # Ejemplos de código
│   └── ejemplos-entrenamiento.json   # Base de conocimiento
│
├── 📁 demo-standalone/                # Aplicación demo independiente
│   ├── server.js                      # Servidor Node.js
│   ├── plugin-funcional.html         # Interfaz demo
│   └── [archivos de demo]
│
├── 📁 scripts/                        # Scripts de utilidad
│   ├── crear-zip-plugin.bat          # Crear ZIP del plugin
│   └── [otros scripts]
│
├── 📁 dist/                           # Archivos compilados
│   └── aiassignment.zip               # Plugin empaquetado
│
├── .env                               # Configuración
├── package.json                       # Dependencias
├── README.md                          # Este archivo
└── LEEME.txt                          # Bienvenida
```

## 🔐 Roles de Usuario

### Maestro
- Crear, editar y eliminar problemas
- Ver todos los envíos de los alumnos
- Evaluar manualmente envíos (opcional)
- Ver estadísticas

### Alumno
- Ver problemas disponibles
- Enviar respuestas
- Ver retroalimentación y calificaciones
- Ver historial de envíos

## 🤖 Evaluación con IA

El sistema utiliza OpenAI GPT-4o-mini para comparar las respuestas de los alumnos con las soluciones del maestro. La evaluación considera:

- **Para problemas matemáticos**: Corrección, método utilizado, claridad
- **Para programación**: Funcionalidad, estilo, buenas prácticas, eficiencia

La IA genera:
- Un score de similitud (0-100%)
- Retroalimentación breve y constructiva
- Análisis detallado de la comparación

## 🔍 Detección de Plagio con IA 🆕

Sistema avanzado de detección de plagio que analiza similitudes entre envíos de estudiantes:

- **Similitud Semántica**: Detecta código con el mismo significado pero diferente sintaxis
- **Similitud Estructural**: Identifica patrones de estructura similares
- **Similitud Lógica**: Reconoce el mismo enfoque algorítmico
- **Reportes Completos**: Visualización de pares sospechosos y usuarios con múltiples coincidencias

**Documentación:** `docs/tecnica/DETECCION_PLAGIO_AUTOMATICA.md` y `docs/tecnica/FUNCIONALIDAD_PLAGIO.md`

## 🧠 Sistema de Entrenamiento de IA 🆕

Base de conocimiento local para mejorar evaluaciones sin gastar consultas de API:

- **Evaluación Híbrida**: Primero busca en base local, luego usa API si es necesario
- **Ahorro de Costos**: Hasta 80% menos en gastos de OpenAI
- **Tres Tipos de Ejemplos**: Código bueno, malo y patrones de plagio
- **Importar/Exportar**: Comparte bases de conocimiento con colegas
- **Evaluaciones Instantáneas**: 10x más rápido que usar API

**Documentación:** `entrenamiento-ia/ENTRENAMIENTO_IA.md` y `entrenamiento-ia/INICIO_RAPIDO_ENTRENAMIENTO.md`  
**Ejemplos predefinidos:** `entrenamiento-ia/ejemplos-entrenamiento.json` (15 ejemplos listos para importar)

## 📝 API Endpoints

### Autenticación
- `POST /api/auth/register` - Registro de usuario
- `POST /api/auth/login` - Inicio de sesión

### Problemas
- `GET /api/problems` - Listar todos los problemas
- `GET /api/problems/:id` - Obtener un problema
- `POST /api/problems` - Crear problema (maestro)
- `PUT /api/problems/:id` - Actualizar problema (maestro)
- `DELETE /api/problems/:id` - Eliminar problema (maestro)

### Envíos
- `POST /api/submissions` - Crear envío (alumno)
- `GET /api/submissions/my-submissions` - Mis envíos (alumno)
- `GET /api/submissions/problem/:problemId` - Envíos de un problema (maestro)

### Evaluaciones
- `POST /api/evaluations/submission/:submissionId` - Evaluar envío (maestro)
- `GET /api/evaluations/submission/:submissionId` - Obtener evaluación

## 🔒 Seguridad

- Contraseñas hasheadas con bcrypt
- Autenticación JWT
- Validación de entrada
- Protección de rutas por rol
- Variables de entorno para secretos

## 📄 Licencia

MIT

## 👨‍💻 Autor

Proyecto de tesis - Sistema de Evaluación de Tareas con IA

## 🐛 Solución de Problemas

### Error: "OPENAI_API_KEY no encontrada"
- Asegúrate de haber creado el archivo `.env` en la carpeta `server`
- Verifica que la API key sea válida

### Error: "Base de datos no inicializada"
- Verifica que la carpeta `server/data` exista
- El servidor creará automáticamente la base de datos al iniciar

### Error de CORS
- Asegúrate de que el proxy en `vite.config.ts` apunte al puerto correcto del servidor

## 🧪 Entorno de Prueba

Este proyecto incluye un entorno de prueba completo para validar el evaluador de IA con archivos reales.

### Configuración Rápida

1. **Configurar API Key**
```bash
cp .env.example .env
# Edita .env y agrega tu OPENAI_API_KEY
```

2. **Ejecutar demo**
```bash
cd demo-standalone
node server.js
```

3. **Abrir en navegador**
```
http://localhost:5000
```

### Documentación

- `demo-standalone/plugin-funcional.html` - Interfaz demo completa
- `docs/usuario/CASOS_PRUEBA_MANUAL.md` - Casos de prueba
- `docs/usuario/MODO_DEMO_VS_REAL.md` - Diferencias demo vs producción

## 🔌 Plugin para Moodle

El proyecto incluye un plugin completo para integrar el sistema en Moodle:

- **Ubicación**: `moodle-plugin/`
- **Tipo**: Activity Module (mod_aiassignment)

### 🚀 Instalación Rápida (Desde Interfaz de Moodle)

**Método más fácil - No requiere SSH/FTP:**

```bash
# 1. Crear ZIP
# Windows:
scripts\crear-zip-plugin.bat

# Linux/Mac:
./scripts/crear-zip-plugin.sh

# 2. Instalar en Moodle
# - Site administration → Plugins → Install plugins
# - Sube dist/aiassignment.zip
# - Configura tu API Key
```

**Documentación completa:**
- `docs/instalacion/INSTALACION_RAPIDA.md` ⭐ Instalación fácil
- `moodle-plugin/INSTALACION.md` - Instalación manual
- `docs/instalacion/GUIA_INSTALACION_MOODLE_LOCAL.md` - Instalar Moodle localmente

### Probar el Plugin

**Opción 1: Demo Standalone (Sin Moodle)** ⭐
```bash
cd demo-standalone
node server.js
# Abre http://localhost:5000
```

**Opción 2: Moodle Local**
- Ver `docs/instalacion/GUIA_INSTALACION_MOODLE_LOCAL.md` para instalar Moodle
- Recomendado: Bitnami Moodle Stack (30 minutos)

**Opción 3: Moodle Demo**
- https://moodle.org/demo (solo exploración, no puedes instalar plugins)
- Ver `moodle-plugin/PRUEBA_EN_DEMO_MOODLE.md`

## 🚧 Mejoras Futuras

- [ ] Ejecución de código para validar programas
- [ ] Soporte para múltiples archivos
- [ ] Dashboard con gráficas y estadísticas
- [ ] Notificaciones en tiempo real
- [ ] Exportación de calificaciones
- [ ] Soporte para más tipos de problemas
