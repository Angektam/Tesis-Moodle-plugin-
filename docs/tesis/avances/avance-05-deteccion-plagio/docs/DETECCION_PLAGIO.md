# 🔍 Detección de Plagio con IA

## Descripción

El plugin incluye un sistema avanzado de detección de plagio que utiliza inteligencia artificial para comparar envíos de estudiantes y detectar similitudes sospechosas en código fuente.

## Características

### ✨ Análisis Inteligente

- **Similitud Semántica**: Detecta código con el mismo significado pero diferente sintaxis
- **Similitud Estructural**: Identifica estructuras de control y patrones similares
- **Similitud Lógica**: Reconoce el mismo enfoque de solución
- **Patrones Únicos**: Detecta comentarios, errores o estilos compartidos

### 📊 Tipos de Análisis

1. **Análisis Individual**: Compara un envío específico con todos los demás
2. **Análisis Completo**: Compara todos los envíos entre sí (matriz de similitud)
3. **Reporte de Usuarios Sospechosos**: Identifica estudiantes con múltiples coincidencias

### 🎯 Niveles de Similitud

| Score | Nivel | Descripción |
|-------|-------|-------------|
| 0-30% | Original | Solución única e independiente |
| 31-60% | Similar | Enfoque similar, probablemente independiente |
| 61-79% | Sospechoso | Similitudes significativas, requiere revisión |
| 80-100% | Plagio | Alta probabilidad de copia |

## Cómo Usar

### Para Profesores

#### 1. Acceder al Reporte de Plagio

```
Actividad AI Assignment → Ver envíos → Reporte de Plagio
```

O directamente desde el menú de la actividad.

#### 2. Seleccionar Problema

- Elige el problema que deseas analizar
- Verás el número de envíos disponibles para comparación

#### 3. Iniciar Análisis

- Click en "Iniciar Análisis de Plagio"
- El sistema comparará todos los envíos usando IA
- Esto puede tomar 1-2 minutos dependiendo del número de envíos

#### 4. Revisar Resultados

El reporte incluye:

**Resumen:**
- Total de envíos analizados
- Total de comparaciones realizadas
- Número de pares sospechosos
- Mayor similitud encontrada

**Usuarios Sospechosos:**
- Lista de estudiantes con múltiples coincidencias
- Número de coincidencias por estudiante
- Con quién coinciden

**Comparaciones Detalladas:**
- Tabla con todas las comparaciones
- Scores de similitud
- Veredicto (original/sospechoso/plagio)
- Código de colores:
  - 🟢 Verde: Original (0-60%)
  - 🟡 Amarillo: Sospechoso (61-79%)
  - 🔴 Rojo: Plagio (80-100%)

## Cómo Funciona

### Proceso de Detección

1. **Recopilación**: Obtiene todos los envíos del problema
2. **Comparación por Pares**: Compara cada envío con todos los demás
3. **Análisis con IA**: OpenAI analiza las similitudes
4. **Clasificación**: Asigna score y veredicto
5. **Reporte**: Genera visualización de resultados

### Análisis de IA

La IA evalúa:

```
1. Similitud Estructural
   - Nombres de variables
   - Estructura de control (if, for, while)
   - Organización del código

2. Similitud Lógica
   - Mismo enfoque de solución
   - Mismos algoritmos
   - Misma secuencia de pasos

3. Similitud Semántica
   - Mismo significado con diferente sintaxis
   - Equivalencias lógicas
   - Transformaciones equivalentes

4. Patrones Únicos
   - Comentarios idénticos
   - Errores compartidos
   - Estilos inusuales comunes
   - Variables con nombres peculiares
```

### Ejemplo de Análisis

**Código A:**
```python
def suma(a, b):
    # Sumar dos numeros
    resultado = a + b
    return resultado
```

**Código B:**
```python
def suma(x, y):
    # Sumar dos numeros
    res = x + y
    return res
```

**Resultado:**
- Similarity Score: 85%
- Verdict: Plagio
- Razón: Estructura idéntica, comentario idéntico (incluso con el mismo error ortográfico), solo cambian nombres de variables

## Casos de Uso

### 1. Detección Preventiva

Ejecuta el análisis después de la fecha límite para identificar posibles casos de plagio antes de calificar.

### 2. Investigación de Sospecha

Si sospechas de un estudiante específico, el análisis mostrará con quién tiene similitudes.

### 3. Análisis de Patrones

Identifica grupos de estudiantes que pueden estar colaborando indebidamente.

### 4. Evidencia Documentada

El reporte proporciona evidencia objetiva basada en IA para casos de integridad académica.

## Limitaciones

### ⚠️ Consideraciones Importantes

1. **Falsos Positivos**: Problemas simples pueden tener soluciones naturalmente similares
2. **Contexto**: La IA no conoce el contexto (¿se permitió colaboración?)
3. **Complemento**: Debe usarse junto con juicio humano, no como única evidencia
4. **Costo**: Cada comparación consume tokens de OpenAI

### 📝 Recomendaciones

- **Problemas Complejos**: Funciona mejor con problemas que admiten múltiples soluciones
- **Revisión Manual**: Siempre revisa manualmente los casos sospechosos
- **Contexto Educativo**: Considera el nivel del curso y las instrucciones dadas
- **Comunicación**: Habla con los estudiantes antes de tomar acciones

## Configuración

### Requisitos

- OpenAI API Key configurada
- Modelo recomendado: `gpt-4o-mini` (mejor relación calidad/precio)
- Al menos 2 envíos para comparar

### Permisos

Solo usuarios con capacidad `mod/aiassignment:grade` pueden:
- Ver el reporte de plagio
- Ejecutar análisis
- Ver comparaciones detalladas

## Costos

### Estimación de Tokens

Para cada comparación:
- Prompt del sistema: ~200 tokens
- Dos códigos a comparar: ~500-2000 tokens (depende del tamaño)
- Respuesta: ~300 tokens
- **Total por comparación**: ~1000-2500 tokens

### Ejemplo de Costos

Con 10 estudiantes:
- Comparaciones necesarias: 45 (10 × 9 / 2)
- Tokens estimados: 45,000-112,500
- Costo con gpt-4o-mini: ~$0.01-$0.02

Con 30 estudiantes:
- Comparaciones necesarias: 435
- Tokens estimados: 435,000-1,087,500
- Costo con gpt-4o-mini: ~$0.09-$0.22

## Privacidad

### Datos Enviados a OpenAI

- Código fuente de los estudiantes
- NO se envían nombres ni identificadores personales
- Solo se envía el contenido de las respuestas

### Almacenamiento

- Los resultados se generan en tiempo real
- No se almacenan en la base de datos (opcional: agregar caché)
- Los profesores pueden ejecutar el análisis cuando lo necesiten

## Mejoras Futuras

### Posibles Extensiones

- [ ] Caché de resultados para evitar re-análisis
- [ ] Exportar reporte a PDF
- [ ] Visualización de código lado a lado
- [ ] Detección de plagio de fuentes externas (internet)
- [ ] Análisis de evolución (comparar intentos del mismo estudiante)
- [ ] Integración con sistema de integridad académica de Moodle
- [ ] Análisis de similitud con soluciones de años anteriores

## Preguntas Frecuentes

### ¿Puede detectar código copiado de internet?

No directamente. El sistema compara envíos entre estudiantes. Para detectar código de internet, necesitarías comparar con una base de datos de código público.

### ¿Qué pasa si dos estudiantes tienen la misma solución correcta?

La IA considera esto. Si la solución es la forma natural y obvia de resolver el problema, el score será más bajo. Busca patrones únicos compartidos que indiquen copia.

### ¿Funciona con otros lenguajes además de Python?

Sí, funciona con cualquier lenguaje de programación. La IA de OpenAI entiende múltiples lenguajes.

### ¿Puedo usar esto como evidencia de plagio?

Debe ser parte de la evidencia, no la única. Siempre revisa manualmente y habla con los estudiantes involucrados.

### ¿Cuánto tiempo toma el análisis?

Depende del número de envíos:
- 10 estudiantes: ~1-2 minutos
- 30 estudiantes: ~5-10 minutos
- 50 estudiantes: ~15-20 minutos

## Soporte Técnico

### Problemas Comunes

**"No hay envíos para comparar"**
- Necesitas al menos 2 envíos

**"Error en detección de plagio"**
- Verifica tu API Key de OpenAI
- Verifica que tengas créditos disponibles
- Revisa los logs de Moodle

**"El análisis toma mucho tiempo"**
- Es normal con muchos envíos
- Considera analizar en horarios de baja actividad

## Ejemplo de Uso

### Escenario: Tarea de Programación

1. **Contexto**: 25 estudiantes, tarea de implementar búsqueda binaria
2. **Acción**: Profesor ejecuta análisis de plagio
3. **Resultado**: 
   - 3 pares con similitud > 80%
   - 2 estudiantes aparecen en múltiples coincidencias
4. **Seguimiento**: 
   - Revisión manual de los códigos
   - Entrevista con estudiantes
   - Decisión basada en evidencia completa

## Conclusión

La detección de plagio con IA es una herramienta poderosa que complementa el juicio del profesor. Úsala de manera responsable, considerando el contexto educativo y siempre dando oportunidad a los estudiantes de explicar sus soluciones.

---

**Documentación relacionada:**
- `COMO_FUNCIONA_IA.md` - Cómo funciona la evaluación con IA
- `MANUAL_USUARIO.md` - Guía completa del plugin
- `classes/plagiarism_detector.php` - Código fuente del detector
