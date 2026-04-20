# 🌐 Guía para Probar en Moodle Demo

## Acceso a Moodle Demo

**URL:** https://moodle.org/demo

Moodle ofrece instancias de demostración que se reinician cada hora. Puedes usar estas para probar tu plugin.

## ⚠️ Limitaciones de la Demo

Las demos públicas de Moodle tienen restricciones:
- ❌ **No puedes instalar plugins** (requiere acceso de administrador al servidor)
- ❌ No tienes acceso SSH/FTP
- ❌ Se reinician cada hora
- ✅ Puedes explorar la interfaz
- ✅ Puedes ver cómo funcionan otros plugins similares

## 🎯 Alternativas para Probar con Archivos Reales

### Opción 1: Entorno de Prueba Local (Recomendado) ✅

Ya tienes un entorno completo en `test-environment/`:

```bash
cd test-environment
php check-setup.php
php demo-visual.php
```

**Ventajas:**
- ✅ Pruebas inmediatas sin instalar Moodle
- ✅ 18 casos de prueba reales
- ✅ Reportes automáticos
- ✅ Iteración rápida

### Opción 2: Instalar Moodle Localmente

Para probar el plugin completo en Moodle:

#### Windows (XAMPP)

1. **Instalar XAMPP**
   - Descarga: https://www.apachefriends.org/
   - Instala Apache, MySQL, PHP

2. **Descargar Moodle**
   ```bash
   cd C:\xampp\htdocs
   git clone https://github.com/moodle/moodle.git
   cd moodle
   git checkout MOODLE_404_STABLE
   ```

3. **Instalar el Plugin**
   ```bash
   # Copiar tu plugin
   xcopy /E /I moodle-plugin C:\xampp\htdocs\moodle\mod\aiassignment
   ```

4. **Configurar Moodle**
   - Inicia XAMPP (Apache + MySQL)
   - Visita: http://localhost/moodle
   - Sigue el instalador

5. **Instalar el Plugin**
   - Ve a: Site administration → Notifications
   - Moodle detectará el nuevo plugin
   - Configura tu OPENAI_API_KEY

#### Linux/Mac (Docker) 🐳

```bash
# Crear docker-compose.yml
cat > docker-compose.yml << 'EOF'
version: '3'
services:
  moodle:
    image: bitnami/moodle:latest
    ports:
      - "8080:8080"
    environment:
      - MOODLE_USERNAME=admin
      - MOODLE_PASSWORD=admin123
      - MOODLE_EMAIL=admin@example.com
    volumes:
      - ./moodle-plugin:/bitnami/moodle/mod/aiassignment
EOF

# Iniciar
docker-compose up -d

# Acceder
# http://localhost:8080
# Usuario: admin
# Contraseña: admin123
```

### Opción 3: Moodle en la Nube (Gratis)

#### MoodleCloud (Gratis hasta 50 usuarios)
1. Regístrate en: https://moodle.com/cloud/
2. Crea tu sitio gratuito
3. **Limitación:** No puedes instalar plugins personalizados en el plan gratuito

#### AWS/DigitalOcean (Requiere pago)
- Instala Moodle en un servidor VPS
- Tendrás control completo para instalar plugins

### Opción 4: Bitnami Moodle Stack (Más Fácil)

**Windows/Mac/Linux:**

1. Descarga Bitnami Moodle Stack:
   https://bitnami.com/stack/moodle/installer

2. Instala siguiendo el wizard

3. Copia tu plugin:
   ```bash
   # Windows
   xcopy /E /I moodle-plugin "C:\Bitnami\moodle-X.X.X\apps\moodle\htdocs\mod\aiassignment"
   
   # Linux/Mac
   cp -r moodle-plugin /opt/bitnami/moodle/mod/aiassignment
   ```

4. Accede a tu Moodle local y configura el plugin

## 🧪 Flujo de Prueba Recomendado

### Fase 1: Validación Rápida (Sin Moodle)
```bash
cd test-environment
php check-setup.php      # Verificar configuración
php manual-test.php      # Pruebas rápidas
php demo-visual.php      # Ver demostración
php interactive-test.php # Probar tus casos
php test-runner.php      # Suite completa
```

**Tiempo:** 10-15 minutos
**Resultado:** Validar que el evaluador funciona correctamente

### Fase 2: Instalación Local (Con Moodle)

**Opción A: XAMPP (Windows)**
- Tiempo de instalación: 30-45 minutos
- Dificultad: Media

**Opción B: Docker (Linux/Mac)**
- Tiempo de instalación: 10-15 minutos
- Dificultad: Baja (si tienes Docker)

**Opción C: Bitnami**
- Tiempo de instalación: 20-30 minutos
- Dificultad: Baja

### Fase 3: Pruebas en Moodle Real

1. Crear un curso de prueba
2. Agregar actividad "AI Assignment"
3. Crear problemas de ejemplo
4. Probar como estudiante
5. Revisar evaluaciones como profesor

## 📋 Checklist de Pruebas

### En Entorno de Prueba Local ✅
- [ ] Configurar API key
- [ ] Ejecutar check-setup.php
- [ ] Probar casos de programación
- [ ] Probar casos de matemáticas
- [ ] Verificar scores esperados
- [ ] Revisar feedback generado
- [ ] Agregar casos personalizados

### En Moodle Local (Cuando lo instales)
- [ ] Instalar plugin
- [ ] Configurar API key en Moodle
- [ ] Crear curso de prueba
- [ ] Agregar actividad AI Assignment
- [ ] Crear problema de programación
- [ ] Crear problema de matemáticas
- [ ] Enviar respuesta como estudiante
- [ ] Verificar evaluación automática
- [ ] Revisar como profesor
- [ ] Probar con múltiples estudiantes

## 🎓 Recursos de Aprendizaje

### Explorar Moodle Demo
Aunque no puedas instalar plugins, puedes:
1. Explorar la interfaz de Moodle
2. Ver cómo funcionan actividades similares (Quiz, Assignment)
3. Entender el flujo de trabajo profesor/estudiante
4. Familiarizarte con la navegación

### Documentación Oficial
- **Moodle Docs:** https://docs.moodle.org/
- **Plugin Development:** https://moodledev.io/
- **Activity Modules:** https://docs.moodle.org/dev/Activity_modules

## 💡 Recomendación

**Para desarrollo y pruebas iniciales:**
```
Usa test-environment/ → Es más rápido y eficiente
```

**Para pruebas de integración completa:**
```
Instala Moodle localmente → Bitnami es la opción más fácil
```

**Para producción:**
```
Servidor dedicado o MoodleCloud Premium
```

## 🚀 Siguiente Paso Inmediato

```bash
# 1. Prueba el entorno local primero
cd test-environment
php demo-visual.php

# 2. Si todo funciona bien, considera instalar Moodle local
# 3. Mientras tanto, explora https://moodle.org/demo para familiarizarte
```

## 📞 Soporte

Si necesitas ayuda:
1. Revisa `test-environment/GUIA_USO.md`
2. Ejecuta `check-setup.php` para diagnóstico
3. Consulta la documentación oficial de Moodle

## 🎯 Resumen

| Opción | Tiempo | Dificultad | Recomendado Para |
|--------|--------|------------|------------------|
| **test-environment/** | 5 min | Baja | ⭐ Desarrollo y pruebas rápidas |
| **Bitnami Stack** | 30 min | Baja | Pruebas de integración |
| **XAMPP** | 45 min | Media | Windows, control total |
| **Docker** | 15 min | Baja | Linux/Mac, desarrollo |
| **Moodle Demo** | 0 min | N/A | Solo exploración (no instalar) |

**Recomendación:** Empieza con `test-environment/` para validar el evaluador, luego instala Moodle localmente con Bitnami para pruebas completas.
