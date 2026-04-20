@echo off
chcp 65001 >nul
cls
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                                                              ║
echo ║   🚀 INICIANDO PLUGIN FUNCIONAL                             ║
echo ║                                                              ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

REM Verificar si Node.js está instalado
where node >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ❌ ERROR: Node.js no está instalado
    echo.
    echo Por favor instala Node.js desde: https://nodejs.org/
    echo.
    pause
    exit /b 1
)

echo ✅ Node.js detectado
echo.
echo 🔧 Iniciando servidor...
echo.

REM Iniciar el servidor
node server-simple.js

pause
