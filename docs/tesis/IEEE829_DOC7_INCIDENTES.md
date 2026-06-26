# Documento 7 — Reporte de Incidentes de Prueba (IEEE 829)
# AI Assignment Plugin v2.5.0

---

## Resumen

Durante la ejecución de las pruebas se registraron **3 incidentes** de severidad baja/media que fueron resueltos antes de la entrega final.

---

## INC-01: Error "Cannot read properties of undefined (reading 'length')"

**ID:** INC-01
**Fecha detectado:** 12/05/2026
**Severidad:** Media
**Estado:** ✅ Resuelto

**Descripción:**
Al ejecutar el análisis de plagio en el reporte, el JavaScript lanzaba el error `Cannot read properties of undefined (reading 'length')` cuando el array `data.comparisons` venía vacío o undefined desde la caché.

**Pasos para reproducir:**
1. Ejecutar análisis de plagio por primera vez (sin caché)
2. Abrir el reporte inmediatamente antes de que termine
3. El JavaScript intenta leer `data.comparisons.length` pero el objeto es undefined

**Causa raíz:**
El objeto `data` devuelto por el AJAX no tenía validación defensiva. Si `comparisons` era undefined (por caché vacía o error de red), el código JavaScript fallaba al intentar iterar.

**Solución aplicada:**
Se agregó validación defensiva al inicio de `renderResults()` en `plagiarism_report.php`:
```javascript
data.user_ranking  = data.user_ranking  || [];
data.comparisons   = data.comparisons   || [];
data.total_submissions  = data.total_submissions  || 0;
```

**Verificación:** El error no se reproduce después del fix. ✅

---

## INC-02: Error "Class mod_aiassignment\audit_logger not found"

**ID:** INC-02
**Fecha detectado:** 13/05/2026
**Severidad:** Alta
**Estado:** ✅ Resuelto

**Descripción:**
Al acceder a `bulk_actions.php`, Moodle lanzaba la excepción `Class "mod_aiassignment\audit_logger" not found`. El archivo `audit_logger.php` no estaba en el servidor de Hostinger porque la versión instalada era anterior a v2.4.0.

**Pasos para reproducir:**
1. Instalar el plugin en Hostinger con una versión anterior
2. Actualizar los archivos PHP manualmente sin incluir `audit_logger.php`
3. Intentar ejecutar acciones en lote

**Causa raíz:**
El servidor tenía una versión desactualizada del plugin. El archivo `audit_logger.php` fue creado en v2.4.0 pero no se subió al servidor durante la actualización manual.

**Solución aplicada:**
Se subió manualmente el archivo `audit_logger.php` al servidor en la ruta `public_html/mod/aiassignment/classes/` usando el File Browser de Hostinger.

**Verificación:** Las acciones en lote funcionan correctamente. ✅

---

## INC-03: Error "Table oy1n_aiassignment already exists" al actualizar

**ID:** INC-03
**Fecha detectado:** 14/05/2026
**Severidad:** Media
**Estado:** ✅ Resuelto

**Descripción:**
Al intentar actualizar el plugin desde la interfaz de Moodle, el proceso de upgrade fallaba con el error `DDL sql execution error: Table 'oy1n_aiassignment' already exists`. Moodle intentaba crear las tablas desde cero en lugar de ejecutar solo las migraciones nuevas.

**Pasos para reproducir:**
1. Borrar el registro de versión del plugin en la BD
2. Intentar actualizar desde Administración del sitio → Notificaciones

**Causa raíz:**
Al ejecutar `DELETE FROM oy1n_config_plugins WHERE plugin = 'mod_aiassignment'` para forzar la detección de actualización, Moodle perdió el registro de la versión instalada y trató la instalación como nueva.

**Solución aplicada:**
Se restauró el registro de versión con:
```sql
INSERT INTO oy1n_config_plugins (plugin, name, value)
VALUES ('mod_aiassignment', 'version', '2026042500')
ON DUPLICATE KEY UPDATE value = '2026042500';
```
Luego Moodle detectó correctamente que había una versión más nueva y ejecutó solo el `upgrade.php`.

**Verificación:** La actualización se completó correctamente. ✅

---

## Resumen de Incidentes

| ID | Severidad | Estado | Impacto |
|----|-----------|--------|---------|
| INC-01 | Media | Resuelto | Error visual en reporte de plagio |
| INC-02 | Alta | Resuelto | Acciones en lote no funcionaban |
| INC-03 | Media | Resuelto | Actualización del plugin fallaba |

**Total incidentes:** 3
**Resueltos:** 3
**Pendientes:** 0
