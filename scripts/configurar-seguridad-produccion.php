<?php
/**
 * Script de configuración de seguridad para producción.
 * Configura: passwordsaltmain, HTTPS, permisos de carpetas.
 *
 * Ejecutar: php scripts/configurar-seguridad-produccion.php
 * Requiere: ruta a config.php de Moodle como argumento o variable MOODLE_PATH
 *
 * Uso:
 *   php scripts/configurar-seguridad-produccion.php /ruta/a/moodle
 */

$moodle_path = $argv[1] ?? getenv('MOODLE_PATH') ?? null;

echo "🔒 CONFIGURACIÓN DE SEGURIDAD PARA PRODUCCIÓN\n";
echo str_repeat('═', 55) . "\n\n";

// ── 1. Verificar config.php de Moodle ────────────────────────
if (!$moodle_path) {
    echo "⚠️  No se especificó la ruta de Moodle.\n";
    echo "   Uso: php scripts/configurar-seguridad-produccion.php /ruta/moodle\n\n";
    echo "   Continuando con verificaciones locales...\n\n";
    $config_path = null;
} else {
    $config_path = rtrim($moodle_path, '/') . '/config.php';
    if (!file_exists($config_path)) {
        echo "❌ No se encontró config.php en: $config_path\n";
        $config_path = null;
    } else {
        echo "✅ config.php encontrado: $config_path\n\n";
    }
}

// ── 2. Generar passwordsaltmain ───────────────────────────────
echo "── 1. passwordsaltmain ──────────────────────────────────\n";

$salt = bin2hex(random_bytes(32)); // 64 chars hex
echo "✅ Salt generado: $salt\n\n";

if ($config_path) {
    $config_content = file_get_contents($config_path);

    if (strpos($config_content, 'passwordsaltmain') !== false) {
        echo "⚠️  passwordsaltmain ya existe en config.php\n";
        echo "   Si quieres cambiarlo, edita manualmente: $config_path\n\n";
    } else {
        // Agregar antes del require_once al final
        $insert = "\n\$CFG->passwordsaltmain = '$salt';\n";
        $config_content = str_replace(
            "require_once(__DIR__ . '/lib/setup.php');",
            $insert . "require_once(__DIR__ . '/lib/setup.php');",
            $config_content
        );
        file_put_contents($config_path, $config_content);
        echo "✅ passwordsaltmain agregado a config.php\n\n";
    }
} else {
    echo "📋 Agrega esto a tu config.php de Moodle:\n";
    echo "   \$CFG->passwordsaltmain = '$salt';\n\n";
    echo "⚠️  IMPORTANTE: Guarda este salt en un lugar seguro.\n";
    echo "   Si lo pierdes, los usuarios no podrán iniciar sesión.\n\n";
}

// ── 3. Configuración HTTPS ────────────────────────────────────
echo "── 2. Configuración HTTPS ───────────────────────────────\n";

if ($config_path) {
    $config_content = file_get_contents($config_path);

    // Verificar si ya usa HTTPS
    if (preg_match('/\$CFG->wwwroot\s*=\s*[\'"]https:\/\//', $config_content)) {
        echo "✅ wwwroot ya usa HTTPS\n";
    } else {
        echo "⚠️  wwwroot NO usa HTTPS\n";
        echo "   Cambia en config.php:\n";
        echo "   \$CFG->wwwroot = 'https://tu-dominio.com/moodle';\n";
    }

    // Verificar sslproxy
    if (strpos($config_content, 'sslproxy') !== false) {
        echo "✅ sslproxy configurado\n";
    } else {
        echo "📋 Si usas proxy/reverse proxy, agrega a config.php:\n";
        echo "   \$CFG->sslproxy = true;\n";
    }
} else {
    echo "📋 Configuración HTTPS requerida en config.php:\n";
    echo "   \$CFG->wwwroot = 'https://tu-dominio.com/moodle';\n";
    echo "   \$CFG->sslproxy = true; // Solo si usas reverse proxy\n";
}

echo "\n";

// ── 4. Verificar permisos de carpetas ─────────────────────────
echo "── 3. Permisos de carpetas ──────────────────────────────\n";

$checks = [
    'moodle-plugin'          => ['expected' => '755', 'desc' => 'Plugin principal'],
    'moodle-plugin/db'       => ['expected' => '755', 'desc' => 'Archivos de BD'],
    'moodle-plugin/classes'  => ['expected' => '755', 'desc' => 'Clases PHP'],
    'scripts'                => ['expected' => '700', 'desc' => 'Scripts de utilidad'],
    '.env'                   => ['expected' => '600', 'desc' => 'Variables de entorno'],
];

foreach ($checks as $path => $info) {
    if (!file_exists($path)) {
        echo "⚪ $path — no encontrado\n";
        continue;
    }
    $perms = substr(sprintf('%o', fileperms($path)), -3);
    $ok    = $perms === $info['expected'];
    $icon  = $ok ? '✅' : '⚠️ ';
    echo "$icon $path ($info[desc]) — permisos: $perms" .
         (!$ok ? " (recomendado: {$info['expected']})" : '') . "\n";
}

echo "\n";

// ── 5. Verificar .env ─────────────────────────────────────────
echo "── 4. Variables de entorno ──────────────────────────────\n";

if (file_exists('.env')) {
    $env_content = file_get_contents('.env');

    // Verificar que no haya keys reales expuestas
    if (preg_match('/OPENAI_API_KEY=sk-[a-zA-Z0-9\-_]{20,}/', $env_content)) {
        echo "⚠️  .env contiene una API key de OpenAI real\n";
        echo "   Asegúrate de que .env esté en .gitignore\n";
    } else {
        echo "✅ .env no contiene API keys reales (o ya fue limpiado)\n";
    }

    if (preg_match('/DB_PASS=(?!TU_|your-)(.+)/', $env_content, $m)) {
        echo "⚠️  .env contiene contraseña de BD: " . str_repeat('*', strlen($m[1])) . "\n";
        echo "   Asegúrate de que .env esté en .gitignore\n";
    } else {
        echo "✅ .env no contiene contraseña de BD real\n";
    }

    // Verificar .gitignore
    if (file_exists('.gitignore')) {
        $gitignore = file_get_contents('.gitignore');
        if (strpos($gitignore, '.env') !== false) {
            echo "✅ .env está en .gitignore\n";
        } else {
            echo "❌ .env NO está en .gitignore — RIESGO CRÍTICO\n";
        }
    }
} else {
    echo "⚠️  No se encontró .env\n";
}

echo "\n";

// ── 6. Checklist final ────────────────────────────────────────
echo "── 5. Checklist de producción ───────────────────────────\n\n";

$checklist = [
    ['✅', 'CSRF: require_sesskey() en todas las acciones POST'],
    ['✅', 'Autenticación: require_login() en todos los endpoints'],
    ['✅', 'Autorización: require_capability() con roles correctos'],
    ['✅', 'Validación de entrada: required_param() con tipos estrictos'],
    ['✅', 'XSS: s() y html_writer para escapar output'],
    ['✅', 'SQL injection: queries parametrizadas con $DB->get_record()'],
    ['✅', 'Rate limiting: 10 envíos/hora + 5s entre envíos'],
    ['✅', 'Sanitización de código: security::sanitize_code()'],
    ['✅', 'Validación de archivos: security::validate_uploaded_file()'],
    ['✅', 'API keys enmascaradas en logs: security::mask_api_key()'],
    ['✅', 'Logging de eventos de seguridad: security::log_security_event()'],
    ['✅', 'Headers HTTP: X-Content-Type-Options, Cache-Control'],
    ['✅', '.env en .gitignore'],
    ['⚠️ ', 'HTTPS: configurar en producción'],
    ['⚠️ ', 'passwordsaltmain: agregar a config.php de Moodle'],
    ['⚠️ ', 'Rotar API key de OpenAI si fue expuesta'],
    ['⚠️ ', 'Permisos de carpetas: 755 para plugin, 600 para .env'],
    ['⚠️ ', 'Backup de BD antes de actualizar el plugin'],
];

foreach ($checklist as [$icon, $item]) {
    echo "  $icon $item\n";
}

echo "\n" . str_repeat('═', 55) . "\n";
echo "✨ Revisión completada.\n";
echo "   Resuelve los ⚠️  antes de desplegar a producción.\n\n";
