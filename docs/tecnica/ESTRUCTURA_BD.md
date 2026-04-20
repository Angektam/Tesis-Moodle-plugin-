# Estructura de Base de Datos

Este documento describe la estructura de la base de datos SQLite utilizada en el sistema.

## Tablas

### users
Almacena información de usuarios (maestros y alumnos).

| Campo | Tipo | Descripción |
|-------|------|-------------|
| id | INTEGER PRIMARY KEY | ID único del usuario |
| email | TEXT UNIQUE | Email del usuario (único) |
| password | TEXT | Contraseña hasheada |
| name | TEXT | Nombre completo |
| role | TEXT | Rol: 'teacher' o 'student' |
| created_at | DATETIME | Fecha de creación |

### problems
Almacena los problemas creados por los maestros.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| id | INTEGER PRIMARY KEY | ID único del problema |
| teacher_id | INTEGER | ID del maestro que creó el problema |
| title | TEXT | Título del problema |
| description | TEXT | Descripción del problema |
| type | TEXT | Tipo: 'math' o 'programming' |
| solution | TEXT | Solución correcta del maestro |
| documentation | TEXT | Documentación adicional (opcional) |
| test_cases | TEXT | Casos de prueba (opcional) |
| created_at | DATETIME | Fecha de creación |

**Relaciones:**
- `teacher_id` → `users.id`

### submissions
Almacena las respuestas enviadas por los alumnos.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| id | INTEGER PRIMARY KEY | ID único del envío |
| problem_id | INTEGER | ID del problema |
| student_id | INTEGER | ID del alumno |
| answer | TEXT | Respuesta del alumno |
| status | TEXT | Estado: 'pending' o 'evaluated' |
| score | REAL | Calificación (0-100) |
| feedback | TEXT | Retroalimentación breve |
| evaluated_at | DATETIME | Fecha de evaluación |
| created_at | DATETIME | Fecha de creación |

**Relaciones:**
- `problem_id` → `problems.id`
- `student_id` → `users.id`

### evaluations
Almacena el historial detallado de evaluaciones con IA.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| id | INTEGER PRIMARY KEY | ID único de la evaluación |
| submission_id | INTEGER | ID del envío evaluado |
| similarity_score | REAL | Score de similitud (0-100) |
| ai_feedback | TEXT | Retroalimentación de la IA |
| ai_analysis | TEXT | Análisis detallado de la IA |
| created_at | DATETIME | Fecha de evaluación |

**Relaciones:**
- `submission_id` → `submissions.id`

## Diagrama de Relaciones

```
users (maestros)
  │
  └─── problems
         │
         └─── submissions (de alumnos)
                │
                └─── evaluations
```

## Consultas Útiles

### Obtener todos los problemas con información del maestro
```sql
SELECT p.*, u.name as teacher_name
FROM problems p
JOIN users u ON p.teacher_id = u.id
ORDER BY p.created_at DESC;
```

### Obtener envíos de un alumno con información del problema
```sql
SELECT s.*, p.title as problem_title, p.type as problem_type
FROM submissions s
JOIN problems p ON s.problem_id = p.id
WHERE s.student_id = ?
ORDER BY s.created_at DESC;
```

### Obtener envíos de un problema con información del alumno
```sql
SELECT s.*, u.name as student_name, u.email as student_email
FROM submissions s
JOIN users u ON s.student_id = u.id
WHERE s.problem_id = ?
ORDER BY s.created_at DESC;
```

### Obtener evaluación completa de un envío
```sql
SELECT s.*, e.similarity_score, e.ai_feedback, e.ai_analysis
FROM submissions s
LEFT JOIN evaluations e ON s.id = e.submission_id
WHERE s.id = ?
ORDER BY e.created_at DESC
LIMIT 1;
```

## Índices Recomendados

Para mejorar el rendimiento, se pueden agregar índices:

```sql
CREATE INDEX idx_problems_teacher ON problems(teacher_id);
CREATE INDEX idx_submissions_student ON submissions(student_id);
CREATE INDEX idx_submissions_problem ON submissions(problem_id);
CREATE INDEX idx_submissions_status ON submissions(status);
CREATE INDEX idx_evaluations_submission ON evaluations(submission_id);
```

## Notas

- La base de datos se crea automáticamente al iniciar el servidor
- Los datos se almacenan en `server/data/database.sqlite`
- SQLite es adecuado para desarrollo y proyectos pequeños
- Para producción, considera migrar a PostgreSQL o MySQL
