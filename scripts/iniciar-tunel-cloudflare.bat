@echo off
chcp 65001 >nul
title Túnel Cloudflare — Moodle Tesis

echo.
echo ╔══════════════════════════════════════════════════════╗
echo ║     TÚNEL CLOUDFLARE PARA MOODLE (TESTING)          ║
echo ╚══════════════════════════════════════════════════════╝
echo.

:: ── 1. Verificar que cloudflared está instalado ──────────────
where cloudflared >nul 2>&1
if %errorlevel% neq 0 (
    echo [!] cloudflared no está instalado.
    echo.
    echo Descargando cloudflared...
    powershell -Command "Invoke-WebRequest -Uri 'https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-windows-amd64.exe' -OutFile 'cloudflared.exe'"
    if exist cloudflared.exe (
        echo [OK] cloudflared descargado en la carpeta actual.
        set CLOUDFLARED=cloudflared.exe
    ) else (
        echo [ERROR] No se pudo descargar cloudflared.
        echo Descárgalo manualmente desde:
        echo https://github.com/cloudflare/cloudflared/releases
        pause
        exit /b 1
    )
) else (
    set CLOUDFLARED=cloudflared
)

:: ── 2. Verificar que XAMPP/Apache está corriendo ─────────────
echo [*] Verificando que Apache está corriendo...
powershell -Command "try { $r = Invoke-WebRequest -Uri 'http://localhost' -TimeoutSec 3 -UseBasicParsing; Write-Host '[OK] Apache está corriendo' } catch { Write-Host '[!] Apache NO está corriendo - inicia XAMPP primero' }"

echo.
echo [*] Verificando que Moodle responde...
powershell -Command "try { $r = Invoke-WebRequest -Uri 'http://localhost/moodle' -TimeoutSec 5 -UseBasicParsing; Write-Host '[OK] Moodle está corriendo en http://localhost/moodle' } catch { Write-Host '[!] Moodle NO responde en http://localhost/moodle' }"

echo.
echo ══════════════════════════════════════════════════════
echo  INICIANDO TÚNEL...
echo  La URL pública aparecerá en unos segundos.
echo  Copia la URL https://xxxx.trycloudflare.com
echo  y actualiza wwwroot en Moodle.
echo ══════════════════════════════════════════════════════
echo.

:: ── 3. Iniciar el túnel ──────────────────────────────────────
%CLOUDFLARED% tunnel --url http://localhost:80

pause
