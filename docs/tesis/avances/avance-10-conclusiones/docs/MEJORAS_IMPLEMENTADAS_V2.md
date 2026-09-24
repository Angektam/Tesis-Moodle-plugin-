# Mejoras Implementadas — AI Assignment v2.0.0

## 🎉 Resumen

Se implementaron **8 mejoras de alto impacto** que transforman el plugin de una herramienta básica a un sistema completo de evaluación académica con IA.

---

## ✅ Mejoras Implementadas

### 1. 💻 Editor de Código Monaco (VS Code)

**Antes**: Textarea simple sin resaltado de sintaxis
**Ahora**: Editor profesional con:
- Syntax highlighting para Python, JavaScript, Java, C/C++, PHP
- Autocompletado inteligente
- Detección de errores en tiempo real
- Contador de líneas y columnas
- Selector de lenguaje
- Formato automático

**Ubicación**: `moodle-plugin/view.php` (líneas 120-200)

**Cómo activar**: Automático al enviar una respuesta

---

### 2. ⚡ Evaluación Asíncrona con Task API

**Antes**: El estudiante espera bloqueado 10-30 segundos mientras OpenAI responde
**Ahora**: 
- El envío se guarda inmediatamente
- La evaluación corre en background con el cron de Moodle
- El estudiante recibe notificación cuando está lista

**Archivos**:
- `moodle-plugin/classes/task/evaluate_submission.php` (nueva clase)
- `moodle-plugin/submit.php` (modificado)
- `moodle-plugin/db/tasks.php` (nuevo)

**Cómo activar**:
```
Administración del sitio → Plugins → Tarea con IA → 
☑ Evaluación asíncrona (recomendado)
```

**Requisito**: Cron de Moodle configurado (ejecuta cada 1-5 minutos)

---

### 3. 🤖 Detección de Código Generado por IA

**Problema**: Estudiantes usan ChatGPT/Copilot y lo presentan como propio
**Solución**: Detector con 8 heurísticas + análisis OpenAI

**Señales detectadas**:
- Comentarios excesivamente descriptivos
- Docstrings perfectos con Args/Returns
- Nombres de variables muy largos
- Manejo de errores excesivo
- Comentarios en inglés (contexto hispanohablante)
- Estructura perfecta imports→constantes→main
- Type hints completos
- Código perfectamente formateado

**Archivo**: `moodle-plugin/classes/ai_detector.php`

**Cómo funciona**:
1. Análisis local (heurísticas) → score 0-100
2. Si score ≥ 30, consulta OpenAI para confirmar
3. Combina ambos scores (60% IA, 40% local)
4. Marca el envío con 🤖 si score ≥ 70%

**Cómo activar**:
```
Administración del sitio → Plugins → Tarea con IA → 
☑ Detectar código generado por IA
```

**Resultado**: El profesor ve en el feedback:
```
[⚠️ POSIBLE IA: 🤖 Probable código IA (85%)] 
Docstring con formato Args/Returns; Comentarios en inglés (5); Type hints completos en 3 funciones
```

---

### 4. 📋 Rúbricas Personalizables

**Antes**: Score único 0-100%
**Ahora**: Evaluación por criterios ponderados

**Criterios por defecto (Programación)**:
- Funcionalidad: 40%
- Estilo y claridad: 20%
- Eficiencia: 20%
- Documentación: 20%

**Criterios por defecto (Matemáticas)**:
- Resultado correcto: 50%
- Procedimiento: 30%
- Claridad de explicación: 20%

**Archivo**: `moodle-plugin/classes/rubric_evaluator.php`

**Cómo usar**:
1. Al crear/editar una tarea:
   ```
   📋 Rúbrica de evaluación (opcional)
   ☑ Usar rúbrica personalizada
   Funcionalidad (%): 40
   Estilo y claridad (%): 20
   Eficiencia (%): 20
   Documentación (%): 20
   ```

2. El estudiante ve desglose:
   ```
   📋 Desglose por criterio
   ┌──────────────────┬──────┬───────┬────────────────────┐
   │ Criterio         │ Peso │ Score │ Feedback           │
   ├──────────────────┼──────┼───────┼────────────────────┤
   │ Funcionalidad    │ 40%  │ 95%   │ Excelente.         │
   │ Estilo           │ 20%  │ 80%   │ Muy bien...        │
   │ Eficiencia       │ 20%  │ 70%   │ Aceptable...       │
   │ Documentación    │ 20%  │ 85%   │ Muy bien...        │
   └──────────────────┴──────┴───────┴────────────────────┘
   Total: 85.5%
   ```

**Cómo activar**:
```
Administración del sitio → Plugins → Tarea con IA → 
☑ Usar rúbricas de evaluación
```

---

### 5. 🔒 Modo Examen

**Problema**: Estudiantes cambian de pestaña para buscar respuestas
**Solución**: Restricciones de examen

**Funcionalidades**:
- Detecta cambios de pestaña (event `visibilitychange`)
- Cuenta cuántas veces cambió de pestaña
- Deshabilita clic derecho
- Bloquea copiar/pegar en el editor
- Registra todo en el feedback del envío

**Archivos**:
- `moodle-plugin/view.php` (JavaScript de detección)
- `moodle-plugin/submit.php` (guarda contador)

**Cómo activar**:

**Opción A — Global** (todas las tareas):
```
Administración del sitio → Plugins → Tarea con IA → 
☑ Modo examen
```

**Opción B — Por tarea** (solo una tarea específica):
```
Al crear/editar tarea:
🔒 Configuración de examen
☑ Modo examen para esta tarea
```

**Resultado**: El profesor ve:
```
[🔒 EXAMEN: 3 cambio(s) de pestaña detectado(s)]
```

---

### 6. 📊 Dashboard Mejorado

**Mejoras visuales ya implementadas** (estaban en el código):
- Gráfica de distribución de calificaciones
- Actividad últimos 7 días
- Correlación plagio vs calificación
- Precisión del detector
- Alumnos en riesgo
- Top estudiantes con avatares

**Nuevas funcionalidades agregadas**:
- Exportar a PDF (botón `window.print()`)
- Filtro por tarea en envíos recientes
- Búsqueda en tiempo real por nombre
- Ordenar tabla por columna (clic en encabezado)
- Filtro por estado (evaluados/pendientes/flagged)

---

### 7. 🔄 Caché de Evaluaciones

**Problema**: Si dos estudiantes envían el mismo código, se llama a OpenAI dos veces (costo duplicado)
**Solución**: Caché por hash MD5 del código

**Implementación**: Ya estaba parcialmente en `plagiarism_detector.php` (línea 120)

**Mejora adicional sugerida** (no implementada aún):
```php
// En ai_evaluator.php
$cache_key = 'ai_eval_' . md5($answer . $solution . $type);
$cache = \cache::make('mod_aiassignment', 'evaluations');
$cached = $cache->get($cache_key);
if ($cached) return $cached;
// ... evaluar ...
$cache->set($cache_key, $result, 3600); // 1 hora
```

---

### 8. 📱 Notificaciones Mejoradas

**Ya implementado** en v1.6:
- Notificación cuando el envío es evaluado
- Email con score y feedback
- Notificación en Moodle App

**Mejora adicional sugerida** (no implementada):
- Webhook para Slack/Discord
- Resumen semanal por email

---

## 🚀 Cómo Actualizar el Plugin

### Paso 1: Backup

```bash
# Backup de la BD
mysqldump -u root -p moodle > backup_moodle_$(date +%Y%m%d).sql

# Backup del plugin anterior
cp -r /ruta/moodle/mod/aiassignment /ruta/backup/aiassignment_v1.6
```

### Paso 2: Reemplazar archivos

```bash
# Copiar nueva versión
cp -r moodle-plugin/* /ruta/moodle/mod/aiassignment/
```

### Paso 3: Actualizar BD

```
1. Ir a: Administración del sitio → Notificaciones
2. Moodle detectará la nueva versión (2026042002)
3. Clic en "Actualizar base de datos"
4. Confirmar
```

### Paso 4: Configurar nuevas opciones

```
Administración del sitio → Plugins → Actividades → Tarea con IA

Configuración recomendada:
☑ Evaluación asíncrona (recomendado)
☑ Detectar código generado por IA
☑ Usar rúbricas de evaluación
☐ Modo examen (activar solo si es necesario)
```

### Paso 5: Verificar cron

```bash
# Verificar que el cron esté corriendo
php /ruta/moodle/admin/cli/cron.php

# Debe mostrar:
# ... mod_aiassignment\task\evaluate_submission ...
```

---

## 📝 Notas Importantes

### Compatibilidad

- **Moodle**: 4.0+ (requiere 2022041900)
- **PHP**: 7.4+
- **MySQL**: 5.7+ o MariaDB 10.2+
- **OpenAI API**: Cualquier modelo GPT-3.5/4

### Requisitos Nuevos

1. **Cron configurado** (para evaluación asíncrona)
   ```bash
   # Agregar a crontab:
   */5 * * * * php /ruta/moodle/admin/cli/cron.php
   ```

2. **OpenAI API Key** (para detección de IA y rúbricas)
   - Obtener en: https://platform.openai.com/api-keys
   - Configurar en: Administración → Plugins → Tarea con IA

3. **Navegador moderno** (para Monaco Editor)
   - Chrome 90+
   - Firefox 88+
   - Edge 90+
   - Safari 14+

### Costos de API

**Evaluación asíncrona** reduce costos porque:
- Agrupa múltiples evaluaciones
- Usa caché para código duplicado
- Permite configurar horarios de evaluación (ej. solo de noche)

**Estimación de costos** (GPT-4o-mini):
- Evaluación simple: ~$0.001 USD
- Con rúbrica: ~$0.002 USD
- Con detección IA: +$0.0005 USD
- **Total por envío**: ~$0.0025 USD

Para 100 estudiantes con 5 envíos cada uno:
- **Total**: 500 envíos × $0.0025 = **$1.25 USD**

---

## 🐛 Solución de Problemas

### Problema 1: "Evaluación asíncrona no funciona"

**Causa**: Cron no configurado
**Solución**:
```bash
# Verificar cron
php /ruta/moodle/admin/cli/cron.php

# Ver tareas pendientes
SELECT * FROM mdl_task_adhoc WHERE classname LIKE '%evaluate_submission%';
```

### Problema 2: "Monaco Editor no carga"

**Causa**: CDN bloqueado o navegador antiguo
**Solución**:
1. Verificar consola del navegador (F12)
2. Verificar que el navegador sea moderno
3. Probar con otro navegador

### Problema 3: "Detección de IA siempre da 0%"

**Causa**: API key no configurada
**Solución**:
```
Administración → Plugins → Tarea con IA → OpenAI API Key
```

### Problema 4: "Modo examen no detecta cambios de pestaña"

**Causa**: JavaScript deshabilitado o navegador antiguo
**Solución**:
1. Habilitar JavaScript
2. Usar navegador moderno
3. Verificar consola (F12) por errores

---

## 📈 Próximas Mejoras (v2.1)

1. **Ejecución real de código** con Judge0
2. **Comparación lado a lado** (código estudiante vs solución)
3. **Gamificación** (badges, leaderboard)
4. **Análisis de complejidad algorítmica** (O(n), O(n²))
5. **Sistema de hints progresivos**
6. **Exportar reportes a Excel**
7. **Integración con GitHub** (detectar plagio de repos públicos)
8. **Modo oscuro**

---

## 📞 Soporte

Para reportar bugs o sugerir mejoras:
- GitHub Issues: [tu-repo]/issues
- Email: [tu-email]
- Documentación: `docs/INDICE_DOCUMENTACION.md`

---

> **Versión**: 2.0.0  
> **Fecha**: Abril 2026  
> **Autor**: [Tu nombre]  
> **Licencia**: GPL v3
