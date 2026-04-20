# Usuarios de Prueba

Este documento contiene las credenciales de los usuarios de prueba creados automáticamente.

## 👥 Usuarios Disponibles

### 👨‍🏫 Maestro
- **Email**: `maestro@test.com`
- **Contraseña**: `123456`
- **Rol**: Maestro
- **Funciones**: Puede crear problemas, ver envíos de alumnos, evaluar respuestas

### 👨‍🎓 Alumno
- **Email**: `alumno@test.com`
- **Contraseña**: `123456`
- **Rol**: Alumno
- **Funciones**: Puede ver problemas, enviar respuestas, ver sus calificaciones

## 🚀 Crear Usuarios de Prueba

Para crear estos usuarios automáticamente, ejecuta:

```bash
cd server
npm run seed
```

Este script creará:
- ✅ Los dos usuarios de prueba (maestro y alumno)
- ✅ 2 problemas matemáticos de ejemplo
- ✅ 2 problemas de programación de ejemplo

## 📝 Problemas de Ejemplo Creados

### Problemas Matemáticos:
1. **Resolver Ecuación Cuadrática** - Resolver x² - 5x + 6 = 0
2. **Calcular Área de un Triángulo** - Calcular área con base y altura

### Problemas de Programación:
1. **Función para Calcular Factorial** - Crear función factorial en Python
2. **Función para Verificar Número Primo** - Crear función para verificar si un número es primo

## 🔐 Seguridad

⚠️ **IMPORTANTE**: Estos usuarios son solo para desarrollo y pruebas. 
- **NO** uses estas contraseñas en producción
- **NO** uses estos usuarios en un entorno público
- Cambia las contraseñas antes de desplegar a producción

## 🧪 Probar el Sistema

1. **Como Maestro**:
   - Inicia sesión con `maestro@test.com` / `123456`
   - Ve al Dashboard
   - Crea nuevos problemas o revisa los existentes
   - Ve los envíos de los alumnos

2. **Como Alumno**:
   - Inicia sesión con `alumno@test.com` / `123456`
   - Ve a "Problemas" para ver los problemas disponibles
   - Selecciona un problema y envía tu respuesta
   - Ve a "Mis Envíos" para ver tus calificaciones

## 🔄 Reiniciar Datos de Prueba

Si necesitas reiniciar los datos de prueba:

1. Elimina el archivo de base de datos:
```bash
rm server/data/database.sqlite
```

2. Ejecuta el seed nuevamente:
```bash
cd server
npm run seed
```

3. Reinicia el servidor:
```bash
npm run dev
```
