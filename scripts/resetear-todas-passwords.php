<?php
/**
 * Resetear contraseñas de TODOS los usuarios de prueba con hash bcrypt
 * compatible con Moodle 4.x
 * Ejecutar: php scripts/resetear-todas-passwords.php
 */

function cargarEnv() {
    $env = [];
    $lines = file(__DIR__ . '/../.env', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
    foreach ($lines as $line) {
        if (strpos(trim($line), '#') === 0) continue;
        if (!strpos($line, '=')) continue;
        list($key, $value) = explode('=', $line, 2);
        $env[trim($key)] = trim($value);
    }
    return $env;
}

$env = cargarEnv();
$pdo = new PDO(
    "mysql:host={$env['DB_HOST']};dbname={$env['DB_NAME']};charset=utf8mb4",
    $env['DB_USER'], $env['DB_PASS']
);
$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

// Todos los usuarios con su contraseña deseada
$usuarios = [];

// est01 - est30 → Test1234!
for ($i = 1; $i <= 30; $i++) {
    $usuarios[] = ['username' => sprintf('est%02d', $i), 'password' => 'Test1234!'];
}

// alumno_c1 - alumno_c5 → Test1234!
for ($i = 1; $i <= 5; $i++) {
    $usuarios[] = ['username' => "alumno_c$i", 'password' => 'Test1234!'];
}

// alumno1 - alumno5 → Test1234!  (unificamos contraseña)
for ($i = 1; $i <= 5; $i++) {
    $usuarios[] = ['username' => "alumno$i", 'password' => 'Test1234!'];
}

// estudiante1 - estudiante3 → Test1234!
for ($i = 1; $i <= 3; $i++) {
    $usuarios[] = ['username' => "estudiante$i", 'password' => 'Test1234!'];
}

// admin
$usuarios[] = ['username' => 'admin', 'password' => 'Admin123!'];

echo "🔐 Reseteando contraseñas con bcrypt (compatible Moodle 4.x)...\n\n";

$stmt = $pdo->prepare('UPDATE mdl_user SET password = ? WHERE username = ?');
$ok = 0; $skip = 0;

foreach ($usuarios as $u) {
    $hash = password_hash($u['password'], PASSWORD_BCRYPT, ['cost' => 10]);
    $stmt->execute([$hash, $u['username']]);
    if ($stmt->rowCount() > 0) {
        echo "✅ {$u['username']}\n";
        $ok++;
    } else {
        echo "⚠️  {$u['username']} no encontrado\n";
        $skip++;
    }
}

echo "\n✅ Actualizados: $ok  |  ⚠️  No encontrados: $skip\n";
echo "\n📋 Contraseñas:\n";
echo "   Todos los estudiantes → Test1234!\n";
echo "   admin                 → Admin123!\n";
echo "\n✨ Listo. Ahora puedes iniciar sesión en Moodle.\n";
