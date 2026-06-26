# IEEE 829 — Documento 7: Reporte de Incidentes de Prueba
## Plugin mod_aiassignment para Moodle 4.0+

---

**Identificador del documento:** RI-AIASSIGNMENT-2026-007  
**Versión:** 1.0  
**Fecha:** Junio 2026  
**Estado:** Final — Todos los incidentes resueltos  
**Autores:** López Payán Kevin Ricardo, Flores Guevara Angel Gabriel  
**Director:** Herman Geovany Ayala Zúñiga  
**Institución:** Universidad Autónoma de Sinaloa — Facultad de Ingeniería Mochis  

---

## 1. Identificador del Reporte de Incidentes

**RI-AIASSIGNMENT-2026-007** — Reporte de Incidentes de Prueba del Plugin mod_aiassignment v2.4.0.

---

## 2. Resumen de Incidentes

| ID | Título | Severidad | Prioridad | Estado | Versión Detectada | Versión Corregida |
|----|--------|-----------|-----------|--------|-------------------|-------------------|
| INC-001 | `eval_cache::invalidate()` — Método no implementado | Media | Alta | ✅ Resuelto | v2.3.0 | v2.4.0 |
| INC-002 | `corrupted_archive_structure` — Error al descomprimir ZIP | Baja | Media | ✅ Resuelto | v2.3.0 | v2.4.0 |
| INC-003 | `comparisons.length` undefined — Error JavaScript en dashboard | Media | Alta | ✅ Resuelto | v2.3.0 | v2.4.0 |

---

## Incidente INC-001

### Encabezado

| Campo | Valor |
|-------|-------|
| **Identificador** | INC-001 |
| **Título** | `eval_cache::invalidate()` — Método no implementado en v2.3.0 |
| **Fecha de detección** | 2026-04-01 |
| **Detectado por** | López Payán Kevin Ricardo |
| **Fase de prueba** | PP-001 — Configuración del entorno |
| **Caso de prueba relacionado** | TC-002 (Evaluación automática con IA) |
| **Severidad** | Media |
| **Prioridad** | Alta |
| **Estado** | ✅ Resuelto |

### Descripción del Incidente

Durante la ejecución del procedimiento PP-001 (configuración del entorno), al intentar forzar la re-evaluación de un envío desde el panel de acciones en lote (`bulk_actions.php`), el sistema lanzó un error fatal de PHP:

```
Fatal error: Call to undefined method mod_aiassignment\eval_cache::invalidate()
in /path/to/moodle/mod/aiassignment/bulk_actions.php on line 87
```

### Pasos para Reproducir

1. Instalar el plugin v2.3.0 en Moodle
2. Crear una actividad AI Assignment con al menos un envío evaluado
3. Iniciar sesión como profesor
4. Navegar a la lista de envíos
5. Seleccionar un envío con checkbox
6. En "Acciones en lote", seleccionar "Re-evaluar con IA"
7. Confirmar la acción

**Resultado obtenido:** Error fatal de PHP — método `invalidate()` no definido  
**Resultado esperado:** El envío es re-evaluado y la caché anterior es invalidada

### Análisis de Causa Raíz

La clase `eval_cache` en v2.3.0 solo tenía implementados los métodos `get()`, `set()` y `make_key()`. El método `invalidate()` fue referenciado en `bulk_actions.php` durante el desarrollo de la funcionalidad de re-evaluación masiva, pero nunca fue implementado en la clase `eval_cache`.

**Código en v2.3.0 (con el bug):**
```php
// En bulk_actions.php línea 87 — llamada al método inexistente:
eval_cache::invalidate($submission->answer, $assignment->solution, $assignment->type);
// ↑ Este método no existía en eval_cache.php
```

**Clase eval_cache en v2.3.0 (incompleta):**
```php
class eval_cache {
    public static function get(string $answer, string $solution, string $type): ?array { ... }
    public static function set(string $answer, string $solution, string $type, array $result): void { ... }
    private static function make_key(...): string { ... }
    // ← FALTABA: invalidate(), invalidate_assignment(), get_stats()
}
```

### Solución Implementada

Se implementó el método `invalidate()` en la clase `eval_cache` en v2.4.0:

```php
/**
 * Invalida la caché para un envío específico (forzar re-evaluación).
 */
public static function invalidate(string $answer, string $solution, string $type): void {
    $cache = \cache::make('mod_aiassignment', 'evaluations');
    $key   = self::make_key($answer, $solution, $type);
    $cache->delete($key);
}

/**
 * Invalida caché para un assignment específico (cuando cambia la solución).
 */
public static function invalidate_assignment(int $assignmentid): void {
    $cache = \cache::make('mod_aiassignment', 'evaluations');
    $cache->purge();
}
```

### Verificación de la Corrección

```bash
# Test PHPUnit que verifica la corrección:
vendor/bin/phpunit --filter test_cache_invalidation mod/aiassignment/tests/ai_evaluator_test.php

# Resultado esperado:
# OK (1 test, 3 assertions)
```

**Resultado de la verificación:** ✅ Test pasa correctamente. La re-evaluación masiva funciona sin errores.

### Impacto

- **Funcionalidad afectada:** Acciones en lote — Re-evaluación masiva
- **Usuarios afectados:** Profesores que intentaran usar la re-evaluación masiva
- **Datos afectados:** Ninguno (el error ocurría antes de modificar datos)
- **Workaround disponible:** Re-evaluar envíos individualmente desde la vista del envío

---

## Incidente INC-002

### Encabezado

| Campo | Valor |
|-------|-------|
| **Identificador** | INC-002 |
| **Título** | `corrupted_archive_structure` — Error al descomprimir el ZIP del plugin |
| **Fecha de detección** | 2026-04-02 |
| **Detectado por** | Flores Guevara Angel Gabriel |
| **Fase de prueba** | PP-001 — Configuración del entorno |
| **Caso de prueba relacionado** | PP-001 Paso 1 (instalación del plugin) |
| **Severidad** | Baja |
| **Prioridad** | Media |
| **Estado** | ✅ Resuelto |

### Descripción del Incidente

Al intentar instalar el plugin desde el archivo `aiassignment.zip` (versión anterior) en Moodle, el instalador de plugins mostró el siguiente error:

```
Error: The zip file is corrupted or has an invalid structure.
Expected directory: mod/aiassignment/
Found: aiassignment/
```

El error ocurría porque el archivo ZIP tenía una estructura de directorios incorrecta. Moodle espera que el ZIP contenga una carpeta con el nombre del plugin (`aiassignment/`) directamente en la raíz, pero el ZIP generado tenía una carpeta adicional de nivel superior.

### Pasos para Reproducir

1. Descargar el archivo `aiassignment.zip` (versión con el bug)
2. En Moodle: Administración del sitio → Plugins → Instalar plugins
3. Subir el archivo ZIP
4. Hacer clic en "Instalar plugin desde el archivo ZIP"

**Resultado obtenido:** Error `corrupted_archive_structure`  
**Resultado esperado:** Plugin instalado correctamente

### Análisis de Causa Raíz

El script de generación del ZIP (`scripts/generar-zip.js`) usaba el comando:
```bash
# Comando incorrecto (genera estructura anidada):
zip -r aiassignment.zip moodle-plugin/
# Resultado: aiassignment.zip/moodle-plugin/aiassignment/...
```

Moodle requiere que el ZIP tenga la estructura:
```
aiassignment.zip
└── aiassignment/          ← directorio raíz debe ser el nombre del plugin
    ├── lib.php
    ├── mod_form.php
    ├── version.php
    └── ...
```

### Solución Implementada

Se corrigió el script de generación del ZIP para producir la estructura correcta:

```bash
# Comando correcto:
cd moodle-plugin && zip -r ../aiassignment_final.zip . --exclude "*.git*" --exclude "tests/*"
# Resultado: aiassignment_final.zip/lib.php, aiassignment_final.zip/mod_form.php, ...
```

El archivo corregido se renombró a `aiassignment_final.zip` para distinguirlo de la versión con el bug.

### Verificación de la Corrección

```bash
# Verificar estructura del ZIP:
unzip -l aiassignment_final.zip | head -20
# Debe mostrar archivos directamente en la raíz, sin subdirectorio extra

# Instalar en Moodle de prueba:
# Administración del sitio → Plugins → Instalar plugins → Subir aiassignment_final.zip
# Resultado esperado: "Plugin instalado correctamente"
```

**Resultado de la verificación:** ✅ Plugin instalado correctamente desde `aiassignment_final.zip`.

### Impacto

- **Funcionalidad afectada:** Proceso de instalación del plugin
- **Usuarios afectados:** Administradores de Moodle que intentaran instalar el plugin
- **Datos afectados:** Ninguno
- **Workaround disponible:** Instalar manualmente copiando los archivos por FTP

---

## Incidente INC-003

### Encabezado

| Campo | Valor |
|-------|-------|
| **Identificador** | INC-003 |
| **Título** | `comparisons.length` undefined — Error JavaScript en el dashboard al cargar el reporte de plagio |
| **Fecha de detección** | 2026-04-03 |
| **Detectado por** | López Payán Kevin Ricardo |
| **Fase de prueba** | PP-001 — Configuración del entorno |
| **Caso de prueba relacionado** | TC-008 (Carga del dashboard) |
| **Severidad** | Media |
| **Prioridad** | Alta |
| **Estado** | ✅ Resuelto |

### Descripción del Incidente

Al cargar el dashboard del profesor después de ejecutar el análisis de plagio, la consola del navegador mostraba el siguiente error JavaScript:

```javascript
Uncaught TypeError: Cannot read properties of undefined (reading 'length')
    at renderPlagiarismChart (dashboard.js:247)
    at initDashboard (dashboard.js:89)
    at HTMLDocument.<anonymous> (dashboard.js:12)
```

El error causaba que la gráfica de "Precisión del detector de plagio" (dona) no se renderizara, aunque las otras 3 gráficas sí funcionaban correctamente.

### Pasos para Reproducir

1. Ejecutar el análisis de plagio en modo rápido
2. Navegar al dashboard del profesor
3. Abrir la consola del navegador (F12)
4. Observar el error en la consola
5. Verificar que la gráfica de dona no aparece

**Resultado obtenido:** Error JS, gráfica de dona no renderizada  
**Resultado esperado:** Las 4 gráficas se renderizan correctamente

### Análisis de Causa Raíz

En el archivo `amd/src/dashboard.js`, la función `renderPlagiarismChart()` intentaba acceder a `data.comparisons.length` sin verificar si `data.comparisons` existía:

```javascript
// Código con el bug (dashboard.js v2.3.0):
function renderPlagiarismChart(data) {
    // BUG: data.comparisons puede ser undefined si no hay análisis de plagio
    const total = data.comparisons.length;  // ← TypeError aquí
    const detected = data.comparisons.filter(c => c.score >= 75).length;
    // ...
}
```

El problema ocurría cuando el endpoint AJAX `/dashboard_data.php` retornaba `comparisons: null` en lugar de `comparisons: []` cuando no había análisis de plagio ejecutado aún.

### Solución Implementada

**Corrección en el backend** (`dashboard.php`): Asegurar que `comparisons` siempre sea un array:

```php
// En dashboard.php — asegurar array vacío en lugar de null:
$data['comparisons'] = $plagiarism_results ?? [];
```

**Corrección en el frontend** (`amd/src/dashboard.js`): Agregar verificación defensiva:

```javascript
// Código corregido (dashboard.js v2.4.0):
function renderPlagiarismChart(data) {
    // Verificación defensiva: usar array vacío si comparisons es undefined/null
    const comparisons = data.comparisons || [];
    const total = comparisons.length;
    const detected = comparisons.filter(c => c.score >= 75).length;
    const suspicious = comparisons.filter(c => c.score >= 50 && c.score < 75).length;
    const original = comparisons.filter(c => c.score < 50).length;
    
    if (total === 0) {
        // Mostrar mensaje "Sin datos de plagio aún"
        showEmptyState('plagiarism-chart', 'No hay análisis de plagio ejecutado');
        return;
    }
    
    // Renderizar gráfica de dona con Chart.js
    new Chart(document.getElementById('plagiarism-chart'), {
        type: 'doughnut',
        data: {
            labels: ['Plagio', 'Sospechoso', 'Original'],
            datasets: [{
                data: [detected, suspicious, original],
                backgroundColor: ['#dc3545', '#ffc107', '#28a745']
            }]
        }
    });
}
```

### Verificación de la Corrección

```javascript
// Prueba manual en consola del navegador:
// 1. Navegar al dashboard sin análisis de plagio ejecutado
// 2. Verificar que NO hay errores en consola
// 3. Verificar que aparece el mensaje "Sin datos de plagio aún"
// 4. Ejecutar análisis de plagio
// 5. Recargar el dashboard
// 6. Verificar que la gráfica de dona se renderiza correctamente
```

**Resultado de la verificación:** ✅ Las 4 gráficas se renderizan correctamente en todos los escenarios.

### Impacto

- **Funcionalidad afectada:** Gráfica de dona "Precisión del detector de plagio" en el dashboard
- **Usuarios afectados:** Profesores que accedieran al dashboard antes de ejecutar el análisis de plagio
- **Datos afectados:** Ninguno (solo afectaba la visualización)
- **Workaround disponible:** Ejecutar el análisis de plagio antes de abrir el dashboard

---

## 3. Análisis de Tendencias de Incidentes

### Distribución por Severidad

| Severidad | Cantidad | Porcentaje |
|-----------|----------|-----------|
| Crítica | 0 | 0% |
| Alta | 0 | 0% |
| Media | 2 | 67% |
| Baja | 1 | 33% |
| **Total** | **3** | **100%** |

### Distribución por Componente

| Componente | Incidentes |
|-----------|-----------|
| Backend PHP (`eval_cache.php`) | 1 (INC-001) |
| Proceso de instalación (ZIP) | 1 (INC-002) |
| Frontend JavaScript (`dashboard.js`) | 1 (INC-003) |

### Tiempo de Resolución

| ID | Fecha Detección | Fecha Resolución | Tiempo de Resolución |
|----|----------------|-----------------|---------------------|
| INC-001 | 2026-04-01 | 2026-04-01 | 2 horas |
| INC-002 | 2026-04-02 | 2026-04-02 | 1 hora |
| INC-003 | 2026-04-03 | 2026-04-03 | 3 horas |

**Tiempo promedio de resolución: 2 horas**

### Observaciones

1. Los 3 incidentes fueron detectados durante la fase de configuración del entorno (PP-001), antes de ejecutar las pruebas formales. Esto indica que el proceso de revisión de código previo a las pruebas fue efectivo.

2. Ningún incidente afectó la funcionalidad core del sistema (detección de plagio, evaluación con IA). Los 3 incidentes eran en funcionalidades secundarias o de infraestructura.

3. Los 3 incidentes fueron resueltos el mismo día de su detección, sin impacto en el cronograma de pruebas.

4. No se detectaron incidentes de seguridad durante las pruebas.

---

## 4. Estado Final

**Total de incidentes reportados:** 3  
**Incidentes resueltos:** 3 (100%)  
**Incidentes pendientes:** 0  
**Incidentes críticos:** 0  

**Conclusión:** Todos los incidentes detectados durante las pruebas han sido resueltos en la versión v2.4.0 del plugin. El sistema está listo para su uso en producción.

---

*Documento elaborado conforme al estándar IEEE 829-2008.*  
*Universidad Autónoma de Sinaloa — Facultad de Ingeniería Mochis — 2026*
