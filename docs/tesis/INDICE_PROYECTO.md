# 📑 Índice Maestro del Proyecto

## Proyecto de Tesis: Detección de Plagio de Código Fuente con IA en Moodle

---

## 🎯 Documentos Principales (LEER PRIMERO)

### 1. Documento de Tesis
📄 **`TESIS_DETECCION_PLAGIO.md`** ⭐⭐⭐
- Documento principal del proyecto de tesis
- Objetivos, metodología, resultados
- Análisis completo de la funcionalidad de plagio
- **EMPEZAR AQUÍ para entender el proyecto**

### 2. Resumen Ejecutivo
📄 **`RESUMEN_PROYECTO.md`**
- Resumen completo del proyecto
- Métricas y estadísticas
- Estado y entregables

### 3. Funcionalidad Principal
📄 **`FUNCIONALIDAD_PLAGIO.md`**
- Especificación técnica del detector de plagio
- Arquitectura y algoritmos
- Casos de uso y ejemplos

---

## 📚 Documentación por Categoría

### A. Detección de Plagio (Tema Principal)

| Documento | Descripción | Audiencia |
|-----------|-------------|-----------|
| `TESIS_DETECCION_PLAGIO.md` | Documento principal de tesis | Todos |
| `FUNCIONALIDAD_PLAGIO.md` | Especificación técnica | Técnica |
| `moodle-plugin/DETECCION_PLAGIO.md` | Guía de uso | Profesores |
| `test-environment/test-plagiarism.php` | Pruebas | Desarrolladores |

### B. Instalación y Configuración

| Documento | Descripción | Tiempo |
|-----------|-------------|--------|
| `INSTALACION_RAPIDA.md` | Instalación en 10 minutos | 10 min |
| `moodle-plugin/INSTALACION_DESDE_INTERFAZ.md` | Instalación detallada | 15 min |
| `GUIA_INSTALACION_MOODLE_LOCAL.md` | Instalar Moodle localmente | 30-60 min |
| `COMO_EMPEZAR.md` | Elegir método de instalación | 5 min |

### C. Uso del Sistema

| Documento | Descripción | Audiencia |
|-----------|-------------|-----------|
| `moodle-plugin/MANUAL_USUARIO.md` | Manual completo | Profesores/Estudiantes |
| `moodle-plugin/DETECCION_PLAGIO.md` | Usar detector de plagio | Profesores |
| `moodle-plugin/COMO_FUNCIONA_IA.md` | Cómo funciona la IA | Todos |

### D. Desarrollo y Pruebas

| Documento | Descripción | Audiencia |
|-----------|-------------|-----------|
| `test-environment/GUIA_USO.md` | Usar entorno de pruebas | Desarrolladores |
| `test-environment/INICIO_RAPIDO.md` | Pruebas rápidas | Desarrolladores |
| `moodle-plugin/COMPONENTES.md` | Arquitectura del plugin | Desarrolladores |

### E. Referencia Rápida

| Documento | Descripción |
|-----------|-------------|
| `README.md` | Descripción general del proyecto |
| `LEEME.txt` | Bienvenida visual |
| `RESUMEN_PROYECTO.md` | Resumen ejecutivo |

---

## 🗂️ Estructura del Repositorio

```
proyecto/
│
├── 📄 TESIS_DETECCION_PLAGIO.md        ⭐ DOCUMENTO PRINCIPAL
├── 📄 FUNCIONALIDAD_PLAGIO.md          ⭐ ESPECIFICACIÓN TÉCNICA
├── 📄 RESUMEN_PROYECTO.md              Resumen ejecutivo
├── 📄 README.md                        Descripción general
├── 📄 LEEME.txt                        Bienvenida
├── 📄 INDICE_PROYECTO.md               Este archivo
│
├── 📁 moodle-plugin/                   ⭐ PLUGIN PRINCIPAL
│   ├── classes/
│   │   ├── plagiarism_detector.php    ⭐ Detector de plagio
│   │   └── ai_evaluator.php           Evaluador automático
│   ├── plagiarism_report.php          ⭐ Interfaz de plagio
│   ├── DETECCION_PLAGIO.md            ⭐ Guía de uso
│   ├── MANUAL_USUARIO.md              Manual completo
│   ├── INSTALACION_DESDE_INTERFAZ.md  Instalación fácil
│   └── [otros archivos del plugin]
│
├── 📁 test-environment/                Entorno de pruebas
│   ├── test-plagiarism.php            ⭐ Pruebas de plagio
│   ├── test-runner.php                Suite completa
│   ├── GUIA_USO.md                    Guía de pruebas
│   └── [casos de prueba]
│
├── 📁 server/                          Backend standalone (opcional)
├── 📁 client/                          Frontend standalone (opcional)
│
└── 📁 Documentación/
    ├── INSTALACION_RAPIDA.md           Instalación en 10 min
    ├── COMO_EMPEZAR.md                 Guía de inicio
    ├── GUIA_INSTALACION_MOODLE_LOCAL.md
    └── [más documentación]
```

---

## 🎓 Flujo de Lectura Recomendado

### Para Evaluadores de Tesis

```
1. TESIS_DETECCION_PLAGIO.md          (30 min)
   ↓
2. FUNCIONALIDAD_PLAGIO.md            (15 min)
   ↓
3. moodle-plugin/DETECCION_PLAGIO.md  (10 min)
   ↓
4. Probar: test-environment/test-plagiarism.php
   ↓
5. RESUMEN_PROYECTO.md                (10 min)
```

### Para Profesores que Quieren Usar el Sistema

```
1. COMO_EMPEZAR.md                    (5 min)
   ↓
2. INSTALACION_RAPIDA.md              (10 min)
   ↓
3. Instalar plugin en Moodle
   ↓
4. moodle-plugin/MANUAL_USUARIO.md    (15 min)
   ↓
5. moodle-plugin/DETECCION_PLAGIO.md  (10 min)
   ↓
6. Usar en curso real
```

### Para Desarrolladores

```
1. TESIS_DETECCION_PLAGIO.md          (30 min)
   ↓
2. FUNCIONALIDAD_PLAGIO.md            (15 min)
   ↓
3. moodle-plugin/COMPONENTES.md       (10 min)
   ↓
4. Revisar código:
   - plagiarism_detector.php
   - plagiarism_report.php
   ↓
5. test-environment/GUIA_USO.md       (10 min)
   ↓
6. Ejecutar pruebas
```

---

## 📊 Componentes del Sistema

### 1. Detector de Plagio (Principal) ⭐

**Archivos clave:**
- `moodle-plugin/classes/plagiarism_detector.php`
- `moodle-plugin/plagiarism_report.php`
- `moodle-plugin/lang/*/aiassignment.php` (cadenas de plagio)

**Documentación:**
- `TESIS_DETECCION_PLAGIO.md`
- `FUNCIONALIDAD_PLAGIO.md`
- `moodle-plugin/DETECCION_PLAGIO.md`

**Pruebas:**
- `test-environment/test-plagiarism.php`

### 2. Evaluador Automático (Complementario)

**Archivos clave:**
- `moodle-plugin/classes/ai_evaluator.php`
- `moodle-plugin/view.php`
- `moodle-plugin/submit.php`

**Documentación:**
- `moodle-plugin/COMO_FUNCIONA_IA.md`
- `moodle-plugin/MANUAL_USUARIO.md`

**Pruebas:**
- `test-environment/test-runner.php`
- 18 casos de prueba en `test-environment/test-cases/`

### 3. Interfaz de Usuario

**Archivos clave:**
- `moodle-plugin/view.php` - Vista principal
- `moodle-plugin/submissions.php` - Lista de envíos
- `moodle-plugin/plagiarism_report.php` - Reporte de plagio
- `moodle-plugin/dashboard.php` - Dashboard

**Documentación:**
- `moodle-plugin/MANUAL_USUARIO.md`

### 4. Servidor Standalone (Opcional)

**Archivos:**
- `server/` - Backend Node.js
- `client/` - Frontend React

**Documentación:**
- `README.md` (sección "Servidor Web Standalone")

---

## 🎯 Objetivos del Proyecto

### Objetivo Principal ✅
Desarrollar un plugin prototipo para Moodle que detecte plagio de código fuente con IA.

### Objetivos Específicos ✅
1. ✅ Implementar detector de plagio con análisis semántico
2. ✅ Integrar nativamente con Moodle
3. ✅ Validar efectividad con casos reales
4. ✅ Documentar completamente

---

## 📈 Métricas del Proyecto

### Código
- **70+ archivos** de código
- **~9,550 líneas** de código
- **2 componentes principales**: Detector de plagio + Evaluador

### Documentación
- **25 documentos** de ayuda
- **~125 páginas** de documentación
- **Bilingüe**: Español e Inglés

### Pruebas
- **22 casos de prueba** incluidos
- **4 casos** específicos de plagio
- **Scripts automatizados** de prueba

---

## 🚀 Inicio Rápido

### Opción 1: Ver Demostración (5 minutos)
```bash
cd test-environment
php test-plagiarism.php
```

### Opción 2: Instalar en Moodle (10 minutos)
```bash
# 1. Crear ZIP
crear-zip-plugin.bat  # Windows
./crear-zip-plugin.sh # Linux/Mac

# 2. Instalar en Moodle
Site administration → Plugins → Install plugins
```

### Opción 3: Leer Documentación (30 minutos)
```
1. TESIS_DETECCION_PLAGIO.md
2. FUNCIONALIDAD_PLAGIO.md
3. moodle-plugin/DETECCION_PLAGIO.md
```

---

## 📞 Ayuda y Soporte

### Problemas de Instalación
→ Ver `INSTALACION_RAPIDA.md`
→ Ver `moodle-plugin/INSTALACION_DESDE_INTERFAZ.md`

### Problemas de Uso
→ Ver `moodle-plugin/MANUAL_USUARIO.md`
→ Ver `moodle-plugin/DETECCION_PLAGIO.md`

### Problemas Técnicos
→ Ver `FUNCIONALIDAD_PLAGIO.md`
→ Ver `moodle-plugin/COMPONENTES.md`

### Preguntas sobre la Tesis
→ Ver `TESIS_DETECCION_PLAGIO.md`
→ Ver `RESUMEN_PROYECTO.md`

---

## ✅ Estado del Proyecto

- ✅ **Completado**: Todas las funcionalidades implementadas
- ✅ **Documentado**: 25 documentos de ayuda
- ✅ **Probado**: 22 casos de prueba
- ✅ **Listo para producción**: Instalable y usable
- ✅ **Nueva funcionalidad (Marzo 2026)**: Sistema de Entrenamiento de IA

### 🧠 Sistema de Entrenamiento de IA (Nuevo)

**Archivos:**
- `ENTRENAMIENTO_IA.md` - Documentación completa
- `ejemplos-entrenamiento.json` - 15 ejemplos predefinidos
- `plugin-funcional.html` - Nueva pestaña "Entrenamiento"
- `plugin-funcional.js` - Funcionalidad de entrenamiento

**Características:**
- ✅ Base de conocimiento local con ejemplos de código
- ✅ Evaluación sin gastar consultas de API
- ✅ Tres tipos de ejemplos: buenos, malos y patrones de plagio
- ✅ Exportar/Importar datos de entrenamiento
- ✅ Estadísticas en tiempo real
- ✅ Evaluación híbrida (local + API)

**Beneficios:**
- 💰 Ahorro de hasta 80% en costos de API
- ⚡ Evaluaciones instantáneas (sin esperar API)
- 📚 Base de conocimiento reutilizable
- 🎯 Evaluaciones más consistentes

---

## 🏆 Conclusión

Este proyecto ha desarrollado exitosamente un **plugin prototipo para Moodle que detecta plagio de código fuente utilizando inteligencia artificial**, cumpliendo con todos los objetivos planteados.

**Para empezar, lee:** `TESIS_DETECCION_PLAGIO.md`

---

**Proyecto de Tesis**
**Fecha:** Febrero 2026
**Estado:** ✅ Completado
