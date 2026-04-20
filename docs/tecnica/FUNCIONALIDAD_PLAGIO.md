# 🔍 Funcionalidad de Detección de Plagio con IA

## Resumen Ejecutivo

Se ha implementado un sistema completo de detección de plagio de código fuente utilizando inteligencia artificial (OpenAI) que permite a los profesores identificar similitudes sospechosas entre envíos de estudiantes.

## 🎯 Objetivo

**Incrementar la eficiencia en la detección de trabajos escolares duplicados** mediante análisis semántico, estructural y lógico de código fuente, superando las limitaciones de los detectores tradicionales basados en coincidencias textuales.

## ✨ Características Principales

### 1. Análisis Inteligente con IA

- **Similitud Semántica**: Detecta código con el mismo significado pero diferente sintaxis
- **Similitud Estructural**: Identifica patrones de estructura de control similares
- **Similitud Lógica**: Reconoce el mismo enfoque algorítmico
- **Patrones Únicos**: Detecta comentarios, errores o estilos compartidos

### 2. Múltiples Niveles de Análisis

| Nivel | Score | Descripción |
|-------|-------|-------------|
| Original | 0-30% | Soluciones independientes |
| Similar | 31-60% | Enfoque similar, probablemente independiente |
| Sospechoso | 61-79% | Requiere revisión manual |
| Plagio | 80-100% | Alta probabilidad de copia |

### 3. Reportes Completos

- **Resumen Estadístico**: Total de comparaciones, pares sospechosos, mayor similitud
- **Usuarios Sospechosos**: Estudiantes con múltiples coincidencias
- **Comparaciones Detalladas**: Matriz completa de similitudes
- **Código de Colores**: Visualización intuitiva de resultados

## 📁 Archivos Creados

### Código Principal

1. **`moodle-plugin/classes/plagiarism_detector.php`**
   - Clase principal del detector de plagio
   - Métodos de comparación con IA
   - Generación de reportes
   - ~350 líneas de código

2. **`moodle-plugin/plagiarism_report.php`**
   - Interfaz web para profesores
   - Visualización de resultados
   - Selección de problemas
   - ~200 líneas de código

### Documentación

3. **`moodle-plugin/DETECCION_PLAGIO.md`**
   - Guía completa de uso
   - Explicación del funcionamiento
   - Casos de uso y ejemplos
   - Preguntas frecuentes

4. **`FUNCIONALIDAD_PLAGIO.md`** (este archivo)
   - Resumen ejecutivo
   - Especificaciones técnicas
   - Guía de implementación

### Pruebas

5. **`test-environment/test-plagiarism.php`**
   - Script de prueba del detector
   - 4 casos de ejemplo
   - Demostración visual

### Internacionalización

6. **Cadenas de idioma agregadas:**
   - `moodle-plugin/lang/es/aiassignment.php` (+20 cadenas)
   - `moodle-plugin/lang/en/aiassignment.php` (+20 cadenas)

## 🔧 Implementación Técnica

### Arquitectura

```
┌─────────────────────────────────────────────────────────┐
│                    Interfaz Web                         │
│              (plagiarism_report.php)                    │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│              Detector de Plagio                         │
│         (plagiarism_detector.php)                       │
│                                                          │
│  • detect_plagiarism($submissionid)                    │
│  • analyze_all_submissions($problemid)                 │
│  • generate_plagiarism_report($problemid)              │
│  • compare_submissions($answer1, $answer2)             │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│                  OpenAI API                             │
│              (gpt-4o-mini)                              │
│                                                          │
│  Analiza similitudes y genera veredicto                │
└─────────────────────────────────────────────────────────┘
```

### Flujo de Trabajo

```
1. Profesor accede al reporte de plagio
   ↓
2. Selecciona un problema para analizar
   ↓
3. Sistema obtiene todos los envíos
   ↓
4. Compara cada par de envíos usando IA
   ↓
5. Calcula scores de similitud
   ↓
6. Identifica pares sospechosos
   ↓
7. Genera reporte visual
   ↓
8. Profesor revisa resultados
```

### Métodos Principales

#### `detect_plagiarism($submissionid)`
Compara un envío específico con todos los demás del mismo problema.

**Retorna:**
```php
[
    'has_plagiarism' => bool,
    'plagiarism_count' => int,
    'highest_similarity' => float,
    'comparisons' => array,
    'suspicious_submissions' => array
]
```

#### `analyze_all_submissions($problemid)`
Genera matriz de similitud completa para todos los envíos.

**Retorna:**
```php
[
    'total_submissions' => int,
    'total_comparisons' => int,
    'suspicious_pairs' => array,
    'matrix' => array
]
```

#### `generate_plagiarism_report($problemid)`
Genera reporte completo con usuarios sospechosos.

**Retorna:**
```php
[
    'total_submissions' => int,
    'total_comparisons' => int,
    'suspicious_pairs_count' => int,
    'suspicious_users' => array,
    'detailed_comparisons' => array,
    'highest_similarity' => float
]
```

## 🎓 Casos de Uso

### 1. Detección Preventiva
Ejecutar análisis después de la fecha límite para identificar casos antes de calificar.

### 2. Investigación de Sospecha
Verificar si un estudiante específico tiene similitudes con otros.

### 3. Análisis de Patrones
Identificar grupos de estudiantes colaborando indebidamente.

### 4. Evidencia Documentada
Generar evidencia objetiva para casos de integridad académica.

## 📊 Ventajas sobre Detectores Tradicionales

| Característica | Detector Tradicional | Detector con IA |
|----------------|---------------------|-----------------|
| Similitud textual | ✅ | ✅ |
| Similitud semántica | ❌ | ✅ |
| Similitud estructural | Limitada | ✅ |
| Similitud lógica | ❌ | ✅ |
| Detecta refactorización | ❌ | ✅ |
| Entiende contexto | ❌ | ✅ |
| Falsos positivos | Altos | Bajos |
| Lenguajes soportados | Limitados | Todos |

## 💰 Costos Estimados

### Con gpt-4o-mini

| Estudiantes | Comparaciones | Tokens | Costo USD |
|-------------|---------------|--------|-----------|
| 10 | 45 | ~50K | $0.01 |
| 20 | 190 | ~200K | $0.04 |
| 30 | 435 | ~450K | $0.09 |
| 50 | 1,225 | ~1.2M | $0.25 |

**Nota**: Costos aproximados. Varían según longitud del código.

## 🔒 Privacidad y Seguridad

### Datos Enviados a OpenAI
- ✅ Código fuente de las respuestas
- ❌ NO se envían nombres de estudiantes
- ❌ NO se envían identificadores personales
- ❌ NO se almacenan datos en OpenAI

### Almacenamiento
- Los resultados se generan en tiempo real
- No se almacenan permanentemente (opcional: agregar caché)
- Solo profesores con permisos pueden acceder

## 🚀 Cómo Usar

### Para Profesores

1. **Acceder al reporte:**
   ```
   Actividad AI Assignment → Reporte de Plagio
   ```

2. **Seleccionar problema:**
   - Elige el problema a analizar
   - Verifica que haya al menos 2 envíos

3. **Iniciar análisis:**
   - Click en "Iniciar Análisis de Plagio"
   - Espera 1-10 minutos (según número de envíos)

4. **Revisar resultados:**
   - Resumen estadístico
   - Usuarios sospechosos
   - Comparaciones detalladas

5. **Tomar acción:**
   - Revisar manualmente casos sospechosos
   - Entrevistar estudiantes si es necesario
   - Documentar evidencia

### Para Probar

```bash
# Probar el detector sin Moodle
cd test-environment
php test-plagiarism.php
```

## 📋 Requisitos

### Técnicos
- Moodle 3.9 o superior
- PHP 7.4 o superior
- Extensión cURL habilitada
- OpenAI API Key

### Permisos
- Capacidad `mod/aiassignment:grade` para acceder al reporte

### Configuración
- API Key de OpenAI configurada
- Modelo recomendado: `gpt-4o-mini`

## ⚠️ Limitaciones

1. **Falsos Positivos**: Problemas simples pueden tener soluciones naturalmente similares
2. **Contexto**: La IA no conoce si se permitió colaboración
3. **Complemento**: Debe usarse junto con juicio humano
4. **Costo**: Cada comparación consume tokens de OpenAI
5. **Tiempo**: Análisis de muchos envíos puede tomar varios minutos

## 🔮 Mejoras Futuras

- [ ] Caché de resultados para evitar re-análisis
- [ ] Exportar reporte a PDF
- [ ] Visualización de código lado a lado
- [ ] Detección de plagio de fuentes externas
- [ ] Análisis de evolución temporal
- [ ] Integración con sistema de integridad académica
- [ ] Comparación con soluciones de años anteriores
- [ ] Análisis de patrones de colaboración

## 📚 Documentación Relacionada

- **`moodle-plugin/DETECCION_PLAGIO.md`** - Guía completa de uso
- **`moodle-plugin/COMO_FUNCIONA_IA.md`** - Funcionamiento de la IA
- **`moodle-plugin/MANUAL_USUARIO.md`** - Manual del plugin
- **`test-environment/test-plagiarism.php`** - Script de prueba

## 🎯 Conclusión

La funcionalidad de detección de plagio con IA proporciona una herramienta poderosa y moderna para mantener la integridad académica en cursos de programación. Su capacidad de detectar similitudes semánticas y estructurales la hace superior a los detectores tradicionales, mientras que su integración nativa con el plugin de evaluación automática ofrece una solución completa para la gestión de tareas de programación en Moodle.

---

**Desarrollado como parte del proyecto:**
*"Desarrollo de un plugin prototipo en la plataforma Moodle que proporcione la detección de plagio de código fuente con IA en entornos educativos, para incrementar la eficiencia en la detección de trabajos escolares duplicados."*
