@echo off
chcp 65001 >nul
cls
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                                                              ║
echo ║   Crear ZIP del Plugin para Instalación en Moodle          ║
echo ║                                                              ║
╚══════════════════════════════════════════════════════════════╝
echo.

REM Verificar si existe la carpeta moodle-plugin
if not exist "moodle-plugin" (
    echo ERROR: No se encontró la carpeta moodle-plugin
    echo Asegúrate de ejecutar este script desde la raíz del proyecto
    pause
    exit /b 1
)

echo Creando archivo ZIP...
echo.

REM Eliminar ZIP anterior si existe
if exist "aiassignment.zip" (
    del aiassignment.zip
    echo ZIP anterior eliminado
)

REM Crear ZIP usando PowerShell
cd moodle-plugin
powershell -Command "Compress-Archive -Path * -DestinationPath ../aiassignment.zip -Force"
cd ..

if exist "aiassignment.zip" (
    echo.
    echo ╔══════════════════════════════════════════════════════════════╗
    echo ║                                                              ║
    echo ║   ✓ ZIP CREADO EXITOSAMENTE                                ║
    echo ║                                                              ║
    echo ╚══════════════════════════════════════════════════════════════╝
    echo.
    echo Archivo: aiassignment.zip
    echo Ubicación: %CD%\aiassignment.zip
    echo.
    echo SIGUIENTE PASO:
    echo 1. Inicia sesión en Moodle como administrador
    echo 2. Ve a: Site administration → Plugins → Install plugins
    echo 3. Sube el archivo aiassignment.zip
    echo 4. Sigue las instrucciones en pantalla
    echo.
    echo Documentación: moodle-plugin\INSTALACION_DESDE_INTERFAZ.md
) else (
    echo.
    echo ERROR: No se pudo crear el archivo ZIP
    echo Verifica que PowerShell esté disponible
)

echo.
pause
