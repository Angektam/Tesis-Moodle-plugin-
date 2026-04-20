# 📊 Resumen del Proyecto

## Sistema de Evaluación de Tareas con IA + Detección de Plagio

### 🎯 Objetivo del Proyecto

**Desarrollo de un plugin prototipo en la plataforma Moodle que proporcione:**
1. Evaluación automática de tareas con IA
2. Detección de plagio de código fuente con IA

**Para:** Incrementar la eficiencia en la evaluación y detección de trabajos escolares duplicados en entornos educativos.

---

## ✨ Funcionalidades Implementadas

### 1. Evaluación Automática con IA

- ✅ Evaluación de problemas de matemáticas
- ✅ Evaluación de código de programación
- ✅ Feedback automático y constructivo
- ✅ Análisis detallado de respuestas
- ✅ Scores automáticos (0-100%)
- ✅ Múltiples intentos configurables

### 2. Detección de Plagio con IA 🆕

- ✅ Análisis semántico de código
- ✅ Detección de similitud estructural
- ✅ Detección de similitud lógica
- ✅ Identificación de patrones únicos compartidos
- ✅ Reportes completos con visualización
- ✅ Identificación de usuarios sospechosos
- ✅ Matriz de comparaciones detalladas

### 3. Interfaz de Usuario

- ✅ Dashboard para profesores
- ✅ Vista de envíos y calificaciones
- ✅ Reporte de plagio interactivo
- ✅ Interfaz responsive
- ✅ Soporte multiidioma (ES/EN)

---

## 📁 Estructura del Proyecto

```
proyecto/
├── moodle-plugin/                    Plugin para Moodle
│   ├── classes/
│   │   ├── ai_evaluator.php        Evaluador de IA
│   │   └── plagiarism_detector.php  🆕 Detector de plagio
│   ├── plagiarism_report.php        🆕 Reporte de plagio
│   ├── DETECCION_PLAGIO.md          🆕 Documentación
│   └── [otros archivos del plugin]
│
├── test-environment/                 Entorno de prueba
│   ├── test-runner.php              Suite de pruebas
│   ├── test-plagiarism.php          🆕 Pruebas de plagio
│   └── [18 casos de prueba]
│
├── server/                           Backend standalone
├── client/                           Frontend standalone
│
└── Documentación/
    ├── README.md                     Documentación principal
    ├── FUNCIONALIDAD_PLAGIO.md      🆕 Especificación plagio
    ├── COMO_EMPEZAR.md              Guía de inicio
    ├── INSTALACION_RAPIDA.md        Instalación rápida
    └── [más documentación]
```

---

## 🔧 Tecnologías Utilizadas

### Backend
- **PHP 7.4+** - Lenguaje del plugin
- **Moodle 3.9+** - Plataforma LMS
- **OpenAI API** - Inteligencia artificial
- **SQLite/MySQL** - Base de datos

### Frontend
- **React + TypeScript** - Interfaz web standalone
- **Moodle UI** - Interfaz del plugin
- **Bootstrap** - Estilos

### IA
- **OpenAI GPT-4o-mini** - Evaluación y detección de plagio
- **Análisis semántico** - Comprensión de código
- **Análisis estructural** - Patrones de código

---

## 📊 Métricas del Proyecto

### Código Desarrollado

| Componente | Archivos | Líneas de Código |
|------------|----------|------------------|
| Plugin Moodle | 25+ | ~3,500 |
| Detector de Plagio | 2 | ~550 |
| Servidor Standalone | 15+ | ~2,000 |
| Cliente Web | 20+ | ~2,500 |
| Tests | 8 | ~1,000 |
| **Total** | **70+** | **~9,550** |

### Documentación

| Tipo | Archivos | Páginas |
|------|----------|---------|
| Guías de Usuario | 8 | ~40 |
| Documentación Técnica | 12 | ~60 |
| Guías de Instalación | 5 | ~25 |
| **Total** | **25** | **~125** |

### Casos de Prueba

- **18 casos** de evaluación automática
- **4 casos** de detección de plagio
- **Cobertura**: Matemáticas y Programación

---

## 🎓 Casos de Uso

### Para Profesores

1. **Crear Tareas**
   - Definir problemas de matemáticas o programación
   - Establecer solución de referencia
   - Configurar intentos máximos

2. **Revisar Envíos**
   - Ver todos los envíos de estudiantes
   - Revisar evaluaciones automáticas
   - Re-evaluar si es necesario

3. **Detectar Plagio**
   - Ejecutar análisis de plagio
   - Revisar pares sospechosos
   - Identificar patrones de colaboración indebida

4. **Analizar Estadísticas**
   - Dashboard con métricas
   - Distribución de calificaciones
   - Estudiantes destacados

### Para Estudiantes

1. **Enviar Respuestas**
   - Escribir solución al problema
   - Enviar para evaluación automática
   - Recibir feedback inmediato

2. **Ver Retroalimentación**
   - Score automático
   - Comentarios constructivos
   - Análisis detallado

3. **Mejorar Soluciones**
   - Múltiples intentos (si está configurado)
   - Aprender de la retroalimentación
   - Mejorar calificación

---

## 🚀 Formas de Uso

### Opción 1: Plugin de Moodle (Recomendado)

```bash
# Crear ZIP
crear-zip-plugin.bat

# Instalar en Moodle
Site administration → Plugins → Install plugins
```

**Ventajas:**
- Integración nativa con Moodle
- Usa roles y permisos de Moodle
- Listo para producción

### Opción 2: Servidor Standalone

```bash
npm run install:all
npm run dev
```

**Ventajas:**
- Independiente de Moodle
- Interfaz moderna
- Fácil de demostrar

### Opción 3: Entorno de Prueba

```bash
cd test-environment
php demo-visual.php
```

**Ventajas:**
- No requiere instalación
- Pruebas inmediatas
- 18 casos de prueba incluidos

---

## 📈 Ventajas Competitivas

### vs. Evaluación Manual

| Aspecto | Manual | Con IA |
|---------|--------|--------|
| Tiempo por envío | 10-15 min | 10-30 seg |
| Consistencia | Variable | Alta |
| Feedback | Limitado | Detallado |
| Escalabilidad | Baja | Alta |
| Disponibilidad | Horario | 24/7 |

### vs. Detectores de Plagio Tradicionales

| Característica | Tradicional | Con IA |
|----------------|-------------|--------|
| Similitud textual | ✅ | ✅ |
| Similitud semántica | ❌ | ✅ |
| Similitud estructural | Limitada | ✅ |
| Similitud lógica | ❌ | ✅ |
| Detecta refactorización | ❌ | ✅ |
| Falsos positivos | Altos | Bajos |

---

## 💰 Costos de Operación

### Con OpenAI gpt-4o-mini

**Evaluación Automática:**
- Por evaluación: ~$0.001-0.002
- 100 evaluaciones: ~$0.10-0.20

**Detección de Plagio:**
- 10 estudiantes (45 comparaciones): ~$0.01
- 30 estudiantes (435 comparaciones): ~$0.09
- 50 estudiantes (1,225 comparaciones): ~$0.25

**Total estimado por curso (30 estudiantes, 10 tareas):**
- Evaluaciones: ~$6-12
- Detección de plagio: ~$0.90
- **Total: ~$7-13 por curso/semestre**

---

## 🔒 Seguridad y Privacidad

### Datos Protegidos
- ✅ Contraseñas hasheadas con bcrypt
- ✅ Autenticación JWT
- ✅ Validación de entrada
- ✅ Protección de rutas por rol

### Privacidad con OpenAI
- ✅ Solo se envía código/respuestas
- ❌ NO se envían nombres de estudiantes
- ❌ NO se envían identificadores personales
- ❌ NO se almacenan datos en OpenAI

### Cumplimiento
- ✅ GDPR compatible
- ✅ Privacy API de Moodle implementada
- ✅ Logs de auditoría

---

## 📚 Documentación Disponible

### Para Usuarios
- `COMO_EMPEZAR.md` - Guía de inicio
- `INSTALACION_RAPIDA.md` - Instalación en 10 minutos
- `moodle-plugin/MANUAL_USUARIO.md` - Manual completo
- `moodle-plugin/DETECCION_PLAGIO.md` - Guía de plagio

### Para Desarrolladores
- `FUNCIONALIDAD_PLAGIO.md` - Especificación técnica
- `moodle-plugin/COMPONENTES.md` - Arquitectura
- `moodle-plugin/COMO_FUNCIONA_IA.md` - Funcionamiento IA

### Para Instalación
- `GUIA_INSTALACION_MOODLE_LOCAL.md` - Instalar Moodle
- `moodle-plugin/INSTALACION_DESDE_INTERFAZ.md` - Instalar plugin
- `test-environment/GUIA_USO.md` - Usar entorno de prueba

---

## 🎯 Resultados Esperados

### Eficiencia
- **90% reducción** en tiempo de evaluación
- **80% reducción** en tiempo de detección de plagio
- **24/7 disponibilidad** de evaluación automática

### Calidad
- **Feedback consistente** para todos los estudiantes
- **Análisis detallado** de cada respuesta
- **Detección precisa** de similitudes sospechosas

### Escalabilidad
- Soporta **cientos de estudiantes** simultáneamente
- **Sin límite** de evaluaciones
- **Crecimiento lineal** de costos

---

## 🔮 Trabajo Futuro

### Mejoras Planificadas

**Evaluación:**
- [ ] Ejecución de código para validar programas
- [ ] Soporte para múltiples archivos
- [ ] Tests unitarios automáticos
- [ ] Análisis de complejidad algorítmica

**Detección de Plagio:**
- [ ] Caché de resultados
- [ ] Exportar reporte a PDF
- [ ] Visualización código lado a lado
- [ ] Detección de fuentes externas (internet)
- [ ] Comparación con años anteriores

**General:**
- [ ] Dashboard con gráficas avanzadas
- [ ] Notificaciones en tiempo real
- [ ] Exportación de calificaciones
- [ ] Soporte para más tipos de problemas
- [ ] Integración con otros LMS

---

## 📞 Soporte y Contacto

### Documentación
- Todas las guías están en el repositorio
- Ejemplos de uso incluidos
- Scripts de prueba disponibles

### Recursos
- **Entorno de prueba**: `test-environment/`
- **Casos de ejemplo**: 22 casos incluidos
- **Scripts de instalación**: Automatizados

---

## ✅ Estado del Proyecto

### Completado ✅
- [x] Evaluación automática con IA
- [x] Detección de plagio con IA
- [x] Plugin completo para Moodle
- [x] Servidor standalone
- [x] Entorno de prueba
- [x] Documentación completa
- [x] Internacionalización (ES/EN)
- [x] Scripts de instalación
- [x] Casos de prueba

### Listo para ✅
- [x] Instalación en Moodle
- [x] Pruebas con usuarios reales
- [x] Despliegue en producción
- [x] Uso en cursos reales

---

## 🏆 Conclusión

El proyecto ha cumplido exitosamente con el objetivo de desarrollar un plugin prototipo para Moodle que proporciona:

1. **Evaluación automática** de tareas matemáticas y de programación usando IA
2. **Detección de plagio** de código fuente con análisis semántico avanzado

El sistema está **completo, documentado y listo para uso en producción**, ofreciendo una solución moderna y eficiente para la gestión de tareas en entornos educativos.

---

**Proyecto desarrollado como tesis:**
*"Desarrollo de un plugin prototipo en la plataforma Moodle que proporcione la detección de plagio de código fuente con IA en entornos educativos, para incrementar la eficiencia en la detección de trabajos escolares duplicados."*

**Fecha:** Febrero 2026
**Estado:** ✅ Completado
