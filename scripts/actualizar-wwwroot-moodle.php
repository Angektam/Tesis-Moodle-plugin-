<?php
/**
 * Actualiza el wwwroot de Moodle para usar con el túnel de Cloudflare.
 * Ejecutar: php scripts/actualizar-wwwroot-moodle.php https://xxxx.trycloudflare.com
 *
 * También actualiza config.php si se proporciona la ruta de Moodle.
 * Uso: php scripts/actualizar-wwwroot-moodle.php https://xxxx.trycloudflare.com [/ruta/moodle]
 */

$new_url    = $argv[1] ?? null;
$moodle_dir = $argv[2] ?? null;

echo "\n🌐 ACTUALIZAR WWWROOT DE MOODLE\n";
echo str_repeat('─', 50) . "\n\n";

if (!$new_url) {
    echo "Uso: php scripts/actualizar-wwwroot-moodle.php <URL>\n";
    echo "Ejemplo: php scripts/actualizar-wwwroot-moodle.php https://abc123.trycloudflare.com\n\n";
    echo "La URL la obtienes al ejecutar: scripts/iniciar-tunel-cloudflare.bat\n";
    exit(1);
}

// Validar formato de URL
if (!filter_var($new_url, FILTER_VALIDATE_URL)) {
    echo "❌ URL inválida: $new_url\n";
    exit(1);
}

// Quitar slash final
$new_url = rtrim($new_url, '/');

echo "Nueva URL: $new_url\n\n";

// ── 1. Actualizar en la base de datos ────────────────────────
function cargarEnv() {
    $env = [];
    if (file_exists(__DIR__ . '/../.env')) {
        foreach (file(__DIR__ . '/../.env', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES) as $line) {
            if (strpos(trim($line), '#') === 0 || !strpos($line, '=')) continue;
            [$k, $v] = explode('=', $line, 2);
            $env[trim($k)] = trim($v);
        }
    }
    return $env;
}

$env = cargarEnv();

try {
    $pdo = new PDO(
        "mysql:host={$env['DB_HOST']};dbname={$env['DB_NAME']};charset=utf8mb4",
        $env['DB_USER'], $env['DB_PASS']
    );
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // Actualizar wwwroot en mdl_config
    $stmt = $pdo->prepare("UPDATE mdl_config SET value = ? WHERE name = 'wwwroot'");
    $stmt->execute([$new_url . '/moodle']);

    if ($stmt->rowCount() > 0) {
        echo "✅ BD actualizada: wwwroot = {$new_url}/moodle\n";
    } else {
        // Insertar si no existe
        $pdo->prepare("INSERT INTO mdl_config (name, value) VALUES ('wwwroot', ?)")
            ->execute([$new_url . '/moodle']);
        echo "✅ BD actualizada (insertado): wwwroot = {$new_url}/moodle\n";
    }

    // Limpiar caché de Moodle en BD
    $pdo->exec("DELETE FROM mdl_cache_flags WHERE flagtype = 'sessioncache'");
    echo "✅ Caché de sesión limpiada\n";

} catch (PDOException $e) {
    echo "⚠️  No se pudo actualizar la BD: " . $e->getMessage() . "\n";
    echo "   Actualiza manualmente en Moodle:\n";
    echo "   Administración del sitio → General → Dirección web\n";
}

// ── 2. Actualizar config.php si se proporcionó la ruta ───────
if ($moodle_dir) {
    $config_path = rtrim($moodle_dir, '/') . '/config.php';
    if (file_exists($config_path)) {
        $content = file_get_contents($config_path);
        $content = preg_replace(
            "/\\\$CFG->wwwroot\s*=\s*'[^']*';/",
            "\$CFG->wwwroot = '{$new_url}/moodle';",
            $content
        );
        file_put_contents($config_path, $content);
        echo "✅ config.php actualizado\n";
    } else {
        echo "⚠️  No se encontró config.php en: $config_path\n";
    }
}

echo "\n";
echo "══════════════════════════════════════════════════\n";
echo "✨ Listo. Comparte esta URL con tus usuarios:\n\n";
echo "   🌐 {$new_url}/moodle\n\n";
echo "   Usuario admin:      admin / Admin123!\n";
echo "   Estudiantes:        est01-est30 / Test1234!\n";
echo "══════════════════════════════════════════════════\n\n";
echo "⚠️  IMPORTANTE:\n";
echo "   - Esta URL cambia cada vez que reinicias el túnel\n";
echo "   - Vuelve a ejecutar este script con la nueva URL\n";
echo "   - Mantén el túnel abierto mientras lo uses\n\n";
