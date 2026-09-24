# 📚 Índice de Documentación

## Proyecto de Tesis: Detección de Plagio de Código Fuente con IA en Moodle

---

## 🎯 Documentos por Categoría

### 📄 Documentos de Tesis

| Documento | Descripción | Tiempo de Lectura |
|-----------|-------------|-------------------|
| [TESIS_DETECCION_PLAGIO.md](tesis/TESIS_DETECCION_PLAGIO.md) | ⭐ Documento principal de tesis | 30 min |
| [RESUMEN_PROYECTO.md](tesis/RESUMEN_PROYECTO.md) | Resumen ejecutivo completo | 15 min |
| [INDICE_PROYECTO.md](tesis/INDICE_PROYECTO.md) | Índice maestro del proyecto | 10 min |
| [RESUMEN_FINAL.md](tesis/RESUMEN_FINAL.md) | Resumen final del proyecto | 10 min |
| [RESUMEN_PRUEBA.md](tesis/RESUMEN_PRUEBA.md) | Resultados de pruebas | 10 min |

### 🔧 Guías de Instalación

| Documento | Descripción | Tiempo |
|-----------|-------------|--------|
| [INSTALACION_RAPIDA.md](instalacion/INSTALACION_RAPIDA.md) | ⭐ Instalación en 10 minutos | 10 min |
| [COMO_EMPEZAR.md](instalacion/COMO_EMPEZAR.md) | Elegir método de instalación | 5 min |
| [CONFIGURAR_API_KEY.md](instalacion/CONFIGURAR_API_KEY.md) | Configurar OpenAI API Key | 5 min |
| [GUIA_INSTALACION_MOODLE_LOCAL.md](instalacion/GUIA_INSTALACION_MOODLE_LOCAL.md) | Instalar Moodle localmente | 30-60 min |
| [INICIAR_SERVIDOR.md](instalacion/INICIAR_SERVIDOR.md) | Iniciar servidor de desarrollo | 5 min |
| [INSTRUCCIONES_PHP.txt](instalacion/INSTRUCCIONES_PHP.txt) | Configurar PHP | 10 min |
| [INSTRUCCIONES_PLUGIN_FUNCIONAL.md](instalacion/INSTRUCCIONES_PLUGIN_FUNCIONAL.md) | Plugin funcional | 15 min |

### 👥 Manuales de Usuario

| Documento | Descripción | Audiencia |
|-----------|-------------|-----------|
| [GUIA_RAPIDA.md](usuario/GUIA_RAPIDA.md) | Guía rápida de uso | Todos |
| [CASOS_PRUEBA_MANUAL.md](usuario/CASOS_PRUEBA_MANUAL.md) | Casos de prueba manual | Profesores |
| [MODO_DEMO_VS_REAL.md](usuario/MODO_DEMO_VS_REAL.md) | Diferencias demo vs real | Todos |

### 🔬 Documentación Técnica

| Documento | Descripción | Audiencia |
|-----------|-------------|-----------|
| [FUNCIONALIDAD_PLAGIO.md](tecnica/FUNCIONALIDAD_PLAGIO.md) | ⭐ Especificación técnica de plagio | Desarrolladores |
| [DETECCION_PLAGIO_AUTOMATICA.md](tecnica/DETECCION_PLAGIO_AUTOMATICA.md) | Detección automática de plagio | Técnica |
| [ESTRUCTURA_BD.md](tecnica/ESTRUCTURA_BD.md) | Estructura de base de datos | Desarrolladores |
| [DIFERENCIAS_PLUGIN_VS_MOD.md](tecnica/DIFERENCIAS_PLUGIN_VS_MOD.md) | Plugin vs Módulo | Desarrolladores |
| [MOODLE_PLUGIN_PLAN.md](tecnica/MOODLE_PLUGIN_PLAN.md) | Plan del plugin Moodle | Desarrolladores |

---

## 🎓 Flujos de Lectura Recomendados

### Para Evaluadores de Tesis

```
1. tesis/TESIS_DETECCION_PLAGIO.md          (30 min)
   ↓
2. tecnica/FUNCIONALIDAD_PLAGIO.md          (15 min)
   ↓
3. ../moodle-plugin/DETECCION_PLAGIO.md     (10 min)
   ↓
4. Probar: ../demo-standalone/server.js
   ↓
5. tesis/RESUMEN_PROYECTO.md                (10 min)
```

### Para Profesores que Quieren Usar el Sistema

```
1. instalacion/COMO_EMPEZAR.md              (5 min)
   ↓
2. instalacion/INSTALACION_RAPIDA.md        (10 min)
   ↓
3. Instalar plugin en Moodle
   ↓
4. ../moodle-plugin/MANUAL_USUARIO.md       (15 min)
   ↓
5. ../moodle-plugin/DETECCION_PLAGIO.md     (10 min)
   ↓
6. Usar en curso real
```

### Para Desarrolladores

```
1. tesis/TESIS_DETECCION_PLAGIO.md          (30 min)
   ↓
2. tecnica/FUNCIONALIDAD_PLAGIO.md          (15 min)
   ↓
3. ../moodle-plugin/COMPONENTES.md          (10 min)
   ↓
4. Revisar código:
   - ../moodle-plugin/classes/plagiarism_detector.php
   - ../moodle-plugin/plagiarism_report.php
   ↓
5. Ejecutar demo
```

---

## 📂 Estructura de Carpetas

```
docs/
├── tesis/                  # Documentos de tesis
├── instalacion/            # Guías de instalación
├── usuario/                # Manuales de usuario
├── tecnica/                # Documentación técnica
└── INDICE_DOCUMENTACION.md # Este archivo
```

---

## 🚀 Inicio Rápido

### Opción 1: Leer Documentación (30 minutos)
```
1. tesis/TESIS_DETECCION_PLAGIO.md
2. tecnica/FUNCIONALIDAD_PLAGIO.md
3. ../moodle-plugin/DETECCION_PLAGIO.md
```

### Opción 2: Ver Demostración (5 minutos)
```bash
cd ../demo-standalone
node server.js
# Abre http://localhost:5000
```

### Opción 3: Instalar en Moodle (10 minutos)
```bash
# 1. Crear ZIP
cd ..
scripts/crear-zip-plugin.bat  # Windows
./scripts/crear-zip-plugin.sh # Linux/Mac

# 2. Instalar en Moodle
# Site administration → Plugins → Install plugins
# Sube dist/aiassignment.zip
```

---

## 📞 Ayuda Rápida

### Problemas de Instalación
→ Ver [instalacion/INSTALACION_RAPIDA.md](instalacion/INSTALACION_RAPIDA.md)

### Problemas de Uso
→ Ver [usuario/GUIA_RAPIDA.md](usuario/GUIA_RAPIDA.md)

### Problemas Técnicos
→ Ver [tecnica/FUNCIONALIDAD_PLAGIO.md](tecnica/FUNCIONALIDAD_PLAGIO.md)

### Preguntas sobre la Tesis
→ Ver [tesis/TESIS_DETECCION_PLAGIO.md](tesis/TESIS_DETECCION_PLAGIO.md)

---

**Proyecto de Tesis**
**Fecha:** Marzo 2026
**Estado:** ✅ Completado y Organizado
