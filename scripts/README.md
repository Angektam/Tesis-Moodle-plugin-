# 🛠️ Scripts de Utilidad

Scripts para facilitar el desarrollo, instalación y despliegue del proyecto.

---

## 📜 Scripts Disponibles

### 🔧 Instalación y Configuración

#### crear-zip-plugin.bat / crear-zip-plugin.sh
Crea un archivo ZIP del plugin listo para instalar en Moodle.

**Uso:**
```bash
# Windows
crear-zip-plugin.bat

# Linux/Mac
./crear-zip-plugin.sh
```

**Salida:**
- `../dist/aiassignment.zip` - Plugin empaquetado

**Qué hace:**
1. Copia archivos del plugin a carpeta temporal
2. Excluye archivos innecesarios (.md, demos, etc.)
3. Crea ZIP con estructura correcta
4. Mueve ZIP a carpeta dist/

---

#### iniciar-plugin.bat
Inicia el servidor de desarrollo del plugin.

**Uso:**
```bash
# Windows
iniciar-plugin.bat
```

**Qué hace:**
1. Verifica que existe .env
2. Instala dependencias si es necesario
3. Inicia servidor Node.js
4. Abre navegador en http://localhost:5000

---

#### habilitar-extensiones-php.bat
Habilita extensiones PHP necesarias para Moodle.

**Uso:**
```bash
# Windows (como Administrador)
habilitar-extensiones-php.bat
```

**Extensiones que habilita:**
- `extension=curl`
- `extension=fileinfo`
- `extension=gd`
- `extension=intl`
- `extension=mbstring`
- `extension=mysqli`
- `extension=openssl`
- `extension=zip`

**Qué hace:**
1. Busca php.ini
2. Descomenta extensiones necesarias
3. Reinicia servidor PHP (si está corriendo)

---

## 🚀 Flujos de Trabajo Comunes

### Instalar Plugin en Moodle

```bash
# 1. Crear ZIP
scripts/crear-zip-plugin.bat

# 2. Ir a Moodle
# Site administration → Plugins → Install plugins

# 3. Subir archivo
# dist/aiassignment.zip

# 4. Seguir asistente de instalación
```

---

### Desarrollo Local

```bash
# 1. Iniciar servidor de desarrollo
scripts/iniciar-plugin.bat

# 2. Abrir navegador
# http://localhost:5000

# 3. Hacer cambios en código

# 4. Recargar navegador para ver cambios
```

---

### Preparar para Producción

```bash
# 1. Crear ZIP del plugin
scripts/crear-zip-plugin.bat

# 2. Verificar que se creó correctamente
ls -la ../dist/aiassignment.zip

# 3. Probar instalación en Moodle de prueba

# 4. Si todo funciona, instalar en producción
```

---

## 📝 Crear Nuevos Scripts

### Plantilla Básica (Windows .bat)

```batch
@echo off
echo ========================================
echo Nombre del Script
echo ========================================
echo.

REM Tu código aquí

echo.
echo ========================================
echo Completado!
echo ========================================
pause
```

### Plantilla Básica (Linux/Mac .sh)

```bash
#!/bin/bash

echo "========================================"
echo "Nombre del Script"
echo "========================================"
echo

# Tu código aquí

echo
echo "========================================"
echo "Completado!"
echo "========================================"
```

---

## 🔍 Detalles de Implementación

### crear-zip-plugin.bat

```batch
@echo off
echo Creando ZIP del plugin...

REM Crear carpeta temporal
mkdir temp_plugin

REM Copiar archivos necesarios
xcopy ..\moodle-plugin\* temp_plugin\ /E /I /Y

REM Excluir archivos innecesarios
del /Q temp_plugin\*.md
del /Q temp_plugin\demo*.html
del /Q temp_plugin\test*.php

REM Crear ZIP
powershell Compress-Archive -Path temp_plugin\* -DestinationPath ..\dist\aiassignment.zip -Force

REM Limpiar
rmdir /S /Q temp_plugin

echo ZIP creado en dist/aiassignment.zip
pause
```

### crear-zip-plugin.sh

```bash
#!/bin/bash

echo "Creando ZIP del plugin..."

# Crear carpeta temporal
mkdir -p temp_plugin

# Copiar archivos necesarios
cp -r ../moodle-plugin/* temp_plugin/

# Excluir archivos innecesarios
rm -f temp_plugin/*.md
rm -f temp_plugin/demo*.html
rm -f temp_plugin/test*.php

# Crear ZIP
cd temp_plugin
zip -r ../../dist/aiassignment.zip . -x "*.md" "demo*" "test*"
cd ..

# Limpiar
rm -rf temp_plugin

echo "ZIP creado en dist/aiassignment.zip"
```

---

## 🐛 Solución de Problemas

### Error: "No se puede crear el ZIP"

**Causa:** Falta PowerShell o zip

**Solución:**
```bash
# Windows: Instalar PowerShell 5.0+
# Linux/Mac: Instalar zip
sudo apt-get install zip  # Ubuntu/Debian
brew install zip          # macOS
```

---

### Error: "Permiso denegado"

**Causa:** Script no tiene permisos de ejecución

**Solución:**
```bash
# Linux/Mac
chmod +x crear-zip-plugin.sh
chmod +x iniciar-plugin.sh
```

---

### Error: "PHP no encontrado"

**Causa:** PHP no está en PATH

**Solución:**
```bash
# Windows: Agregar PHP a PATH
# Panel de Control → Sistema → Variables de entorno
# Agregar: C:\php a PATH

# Linux/Mac: Instalar PHP
sudo apt-get install php  # Ubuntu/Debian
brew install php          # macOS
```

---

## 📚 Documentación Relacionada

- [../docs/instalacion/INSTALACION_RAPIDA.md](../docs/instalacion/INSTALACION_RAPIDA.md)
- [../docs/instalacion/COMO_EMPEZAR.md](../docs/instalacion/COMO_EMPEZAR.md)
- [../moodle-plugin/INSTALACION.md](../moodle-plugin/INSTALACION.md)

---

## 🎯 Scripts Futuros (Planeados)

- [ ] `test-plugin.bat` - Ejecutar pruebas automatizadas
- [ ] `deploy-production.bat` - Desplegar a producción
- [ ] `backup-database.bat` - Hacer backup de BD
- [ ] `update-plugin.bat` - Actualizar plugin en Moodle
- [ ] `check-requirements.bat` - Verificar requisitos del sistema

---

**Parte del Proyecto de Tesis**
**Fecha:** Marzo 2026
