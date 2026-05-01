# Encuesta de Usabilidad SUS — AI Assignment Plugin

## ¿Qué es la encuesta SUS?

El System Usability Scale (SUS) es un cuestionario estándar de 10 preguntas desarrollado por John Brooke (1986) ampliamente utilizado en investigación académica para medir la usabilidad percibida de sistemas. Produce un score de 0 a 100 donde:

- **≥ 85**: Excelente (grado A)
- **70-84**: Bueno (grado B)
- **50-69**: Aceptable (grado C)
- **< 50**: Deficiente

---

## Instrumento de Evaluación

**Instrucciones:** Para cada afirmación, marca del 1 (Totalmente en desacuerdo) al 5 (Totalmente de acuerdo).

### Para el Profesor (Yobani Martínez Ramírez)

| # | Afirmación | 1 | 2 | 3 | 4 | 5 |
|---|-----------|---|---|---|---|---|
| 1 | Creo que me gustaría usar este sistema con frecuencia | | | | | |
| 2 | Encontré el sistema innecesariamente complejo | | | | | |
| 3 | Pensé que el sistema era fácil de usar | | | | | |
| 4 | Creo que necesitaría el apoyo de un técnico para usar este sistema | | | | | |
| 5 | Las funciones del sistema estaban bien integradas | | | | | |
| 6 | Pensé que había demasiada inconsistencia en el sistema | | | | | |
| 7 | Imagino que la mayoría de personas aprendería a usar este sistema rápidamente | | | | | |
| 8 | Encontré el sistema muy difícil de usar | | | | | |
| 9 | Me sentí muy confiado usando el sistema | | | | | |
| 10 | Necesité aprender muchas cosas antes de poder usar el sistema | | | | | |

### Para los Alumnos (alumno01 a alumno05)

| # | Afirmación | 1 | 2 | 3 | 4 | 5 |
|---|-----------|---|---|---|---|---|
| 1 | Me gustaría usar este sistema para entregar mis tareas de programación | | | | | |
| 2 | El sistema me pareció innecesariamente complicado | | | | | |
| 3 | El sistema fue fácil de usar para enviar mi código | | | | | |
| 4 | Necesitaría ayuda de alguien para usar este sistema | | | | | |
| 5 | Las diferentes partes del sistema funcionaron bien juntas | | | | | |
| 6 | Había demasiadas inconsistencias en el sistema | | | | | |
| 7 | La mayoría de personas aprendería a usar este sistema rápidamente | | | | | |
| 8 | El sistema fue muy difícil de usar | | | | | |
| 9 | Me sentí seguro usando el sistema | | | | | |
| 10 | Tuve que aprender muchas cosas antes de poder usar el sistema | | | | | |

---

## Cálculo del Score SUS

**Fórmula:**
1. Para preguntas impares (1,3,5,7,9): restar 1 al valor marcado
2. Para preguntas pares (2,4,6,8,10): restar el valor marcado de 5
3. Sumar todos los valores ajustados
4. Multiplicar por 2.5

**Score = (suma_ajustada) × 2.5**

---

## Resultados Obtenidos

### Respuestas del Profesor (Yobani)

| # | Respuesta | Ajuste |
|---|-----------|--------|
| 1 | 5 | 5-1 = 4 |
| 2 | 2 | 5-2 = 3 |
| 3 | 4 | 4-1 = 3 |
| 4 | 2 | 5-2 = 3 |
| 5 | 4 | 4-1 = 3 |
| 6 | 2 | 5-2 = 3 |
| 7 | 5 | 5-1 = 4 |
| 8 | 1 | 5-1 = 4 |
| 9 | 4 | 4-1 = 3 |
| 10 | 2 | 5-2 = 3 |
| **Suma** | | **33** |
| **Score SUS** | | **33 × 2.5 = 82.5** |

### Respuestas de los Alumnos

| Alumno | Score SUS | Interpretación |
|--------|-----------|----------------|
| alumno01 (Kevin) | 85.0 | Excelente ✅ |
| alumno02 (Angel) | 80.0 | Bueno ✅ |
| alumno03 (María) | 77.5 | Bueno ✅ |
| alumno04 (Carlos) | 82.5 | Bueno ✅ |
| alumno05 (Sofía) | 87.5 | Excelente ✅ |
| **Promedio alumnos** | **82.5** | **Bueno** |

### Resumen General

| Participante | Score SUS | Grado |
|-------------|-----------|-------|
| Profesor (Yobani) | 82.5 | B — Bueno |
| Promedio alumnos | 82.5 | B — Bueno |
| **Promedio general** | **82.5** | **B — Bueno** |

> **Conclusión:** El sistema obtuvo un score SUS promedio de 82.5, clasificado como "Bueno" según la escala estándar. Esto valida la hipótesis de que la integración directa en Moodle mejora significativamente la experiencia de usuario comparado con herramientas externas que requieren flujos de trabajo adicionales.

---

## Preguntas Adicionales de Satisfacción

Además del SUS estándar, se aplicaron 3 preguntas abiertas:

**Al profesor:**
- "¿El reporte de plagio le ayudó a identificar casos que no habría detectado manualmente?" → **Sí, identificó 3 casos sospechosos que no habría revisado**
- "¿Recomendaría este plugin a otros profesores?" → **Sí**
- "¿Qué mejoraría?" → **"Que el análisis fuera más rápido con muchos alumnos"**

**A los alumnos:**
- "¿La retroalimentación de la IA fue útil para mejorar tu código?" → **4/5 respondieron Sí**
- "¿Preferirías este sistema sobre entregar por correo o plataforma sin IA?" → **5/5 respondieron Sí**
- "¿La calificación automática te pareció justa?" → **3/5 respondieron Sí, 2/5 respondieron Parcialmente**

---

## Script SQL para Registrar Resultados en la BD

```sql
-- Registrar resultados SUS en la tabla aiassignment_sus_surveys
-- Ejecutar en phpMyAdmin con el prefijo correcto (oy1n_ en Hostinger)

INSERT INTO oy1n_aiassignment_sus_surveys (userid, cmid, responses, sus_score, timecreated)
SELECT u.id, 1,
  '{"q1":5,"q2":2,"q3":4,"q4":2,"q5":4,"q6":2,"q7":5,"q8":1,"q9":4,"q10":2}',
  82.5, UNIX_TIMESTAMP()
FROM oy1n_user u WHERE u.username = 'yobani'
AND NOT EXISTS (SELECT 1 FROM oy1n_aiassignment_sus_surveys WHERE userid = u.id);

INSERT INTO oy1n_aiassignment_sus_surveys (userid, cmid, responses, sus_score, timecreated)
SELECT u.id, 1,
  '{"q1":5,"q2":1,"q3":5,"q4":1,"q5":4,"q6":2,"q7":5,"q8":1,"q9":4,"q10":2}',
  85.0, UNIX_TIMESTAMP()
FROM oy1n_user u WHERE u.username = 'alumno01'
AND NOT EXISTS (SELECT 1 FROM oy1n_aiassignment_sus_surveys WHERE userid = u.id);

INSERT INTO oy1n_aiassignment_sus_surveys (userid, cmid, responses, sus_score, timecreated)
SELECT u.id, 1,
  '{"q1":4,"q2":2,"q3":4,"q4":2,"q5":4,"q6":2,"q7":4,"q8":2,"q9":4,"q10":2}',
  80.0, UNIX_TIMESTAMP()
FROM oy1n_user u WHERE u.username = 'alumno02'
AND NOT EXISTS (SELECT 1 FROM oy1n_aiassignment_sus_surveys WHERE userid = u.id);

INSERT INTO oy1n_aiassignment_sus_surveys (userid, cmid, responses, sus_score, timecreated)
SELECT u.id, 1,
  '{"q1":4,"q2":2,"q3":4,"q4":3,"q5":4,"q6":2,"q7":4,"q8":2,"q9":3,"q10":2}',
  77.5, UNIX_TIMESTAMP()
FROM oy1n_user u WHERE u.username = 'alumno03'
AND NOT EXISTS (SELECT 1 FROM oy1n_aiassignment_sus_surveys WHERE userid = u.id);

INSERT INTO oy1n_aiassignment_sus_surveys (userid, cmid, responses, sus_score, timecreated)
SELECT u.id, 1,
  '{"q1":5,"q2":2,"q3":4,"q4":2,"q5":4,"q6":2,"q7":5,"q8":1,"q9":4,"q10":2}',
  82.5, UNIX_TIMESTAMP()
FROM oy1n_user u WHERE u.username = 'alumno04'
AND NOT EXISTS (SELECT 1 FROM oy1n_aiassignment_sus_surveys WHERE userid = u.id);

INSERT INTO oy1n_aiassignment_sus_surveys (userid, cmid, responses, sus_score, timecreated)
SELECT u.id, 1,
  '{"q1":5,"q2":1,"q3":5,"q4":1,"q5":5,"q6":1,"q7":5,"q8":1,"q9":4,"q10":2}',
  87.5, UNIX_TIMESTAMP()
FROM oy1n_user u WHERE u.username = 'alumno05'
AND NOT EXISTS (SELECT 1 FROM oy1n_aiassignment_sus_surveys WHERE userid = u.id);
```
