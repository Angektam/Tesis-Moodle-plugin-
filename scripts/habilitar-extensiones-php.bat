@echo off
echo ============================================================
echo   HABILITANDO EXTENSIONES DE PHP NECESARIAS
echo ============================================================
echo.

set PHP_INI="C:\Program Files\php-8.4.13-nts-Win32-vs17-x64\php.ini"

echo Verificando archivo php.ini...
if not exist %PHP_INI% (
    echo ERROR: No se encontro php.ini en %PHP_INI%
    pause
    exit /b 1
)

echo.
echo Creando backup de php.ini...
copy %PHP_INI% "%PHP_INI%.backup" >nul
echo Backup creado: %PHP_INI%.backup

echo.
echo Habilitando extensiones necesarias...
echo.

REM Habilitar OpenSSL
powershell -Command "(Get-Content %PHP_INI%) -replace ';extension=openssl', 'extension=openssl' | Set-Content %PHP_INI%"
echo [OK] extension=openssl

REM Habilitar cURL
powershell -Command "(Get-Content %PHP_INI%) -replace ';extension=curl', 'extension=curl' | Set-Content %PHP_INI%"
echo [OK] extension=curl

echo.
echo ============================================================
echo   EXTENSIONES HABILITADAS CORRECTAMENTE
echo ============================================================
echo.
echo Ahora puedes ejecutar: php test-plugin.php
echo.
pause
