# Documento 5 — Reporte de Transmisión de Ítems de Prueba (IEEE 829)
# AI Assignment Plugin v2.5.0

---

## 1. Identificador
**ID:** TR-AIASSIGNMENT-2026-01
**Fecha:** Mayo 2026

---

## 2. Ítems Transmitidos para Prueba

Los siguientes ítems han sido preparados y están listos para ser probados:

| ID | Ítem | Ubicación | Versión | Estado |
|----|------|-----------|---------|--------|
| IT-01 | Plugin ZIP instalable | `dist/mod_aiassignment.zip` | 2.5.0 | ✅ Listo |
| IT-02 | Script de datos de prueba 30 alumnos | `scripts/inscribir-30-alumnos.sql` | 1.0 | ✅ Listo |
| IT-03 | Script de datos de prueba 150 alumnos | `scripts/test-150-alumnos-6-salones.sql` | 1.0 | ✅ Listo |
| IT-04 | Tests unitarios PHPUnit | `moodle-plugin/tests/` | 1.0 | ✅ Listo |
| IT-05 | Encuesta SUS integrada | `moodle-plugin/sus_survey.php` | 1.0 | ✅ Listo |
| IT-06 | Entorno Moodle en Hostinger | `tesis-moodle-ppp.20millonesenorillasuas.com` | 4.4 | ✅ Listo |
| IT-07 | Usuarios de prueba | `scripts/registrar-maestro-y-5-alumnos.sql` | 1.0 | ✅ Listo |

---

## 3. Ubicación de los Ítems

**Repositorio GitHub:** `https://github.com/Angektam/Tesis-Moodle-plugin-`

**Servidor de pruebas:** `https://tesis-moodle-ppp.20millonesenorillasuas.com`

**Base de datos:** phpMyAdmin → `u698086472_56pkq` (prefijo `oy1n_`)

---

## 4. Aprobación para Liberación

Los ítems listados han sido revisados y se aprueba su uso en las pruebas.

| Ítem | Aprobado por | Fecha |
|------|-------------|-------|
| Plugin ZIP | Kevin López | 14/05/2026 |
| Scripts SQL | Angel Flores | 14/05/2026 |
| Tests PHPUnit | Kevin López | 14/05/2026 |
| Entorno Moodle | Angel Flores | 14/05/2026 |

---

## 5. Notas

- El plugin requiere que la tabla `oy1n_aiassignment` ya exista en la BD antes de ejecutar los scripts SQL de datos de prueba.
- Los usuarios de prueba usan contraseña `Test1234!` con hash bcrypt precomputado.
- El modo demo debe estar activado para pruebas sin API Key de OpenAI.
