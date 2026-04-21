<?php
/**
 * Script para resetear contraseñas de usuarios de prueba en Moodle
 * Ejecutar: php scripts/resetear-passwords.php
 */

// Cargar configuración de .env
function cargarEnv() {
    $env = [];
    if (file_exists(__DIR__ . '/../.env')) {
        $lines = file(__DIR__ . '/../.env', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
        foreach ($lines as $line) {
            if (strpos(trim($line), '#') === 0) continue;
            list($key, $value) = explode('=', $line, 2);
            $env[trim($key)] = trim($value);
        }
    }
    return $env;
}

$env = cargarEnv();

// Configuración de base de datos
$host = $env['DB_HOST'] ?? 'localhost';
$dbname = $env['DB_NAME'] ?? 'moodle';
$user = $env['DB_USER'] ?? 'root';
$pass = $env['DB_PASS'] ?? '';

try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8mb4", $user, $pass);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    echo "🔐 Reseteando contraseñas de usuarios de prueba...\n\n";
    
    $usuarios = [
        ['username' => 'admin', 'password' => 'Admin123!'],
        ['username' => 'estudiante1', 'password' => 'estudiante1'],
        ['username' => 'estudiante2', 'password' => 'estudiante2'],
        ['username' => 'estudiante3', 'password' => 'estudiante3'],
        ['username' => 'alumno1', 'password' => 'alumno1'],
        ['username' => 'alumno2', 'password' => 'alumno2'],
        ['username' => 'alumno3', 'password' => 'alumno3'],
        ['username' => 'alumno4', 'password' => 'alumno4'],
        ['username' => 'alumno5', 'password' => 'alumno5']
    ];
    
    $stmt = $pdo->prepare('UPDATE mdl_user SET password = ? WHERE username = ?');
    
    foreach ($usuarios as $usuario) {
        // Generar hash bcrypt compatible con Moodle
        $hash = password_hash($usuario['password'], PASSWORD_BCRYPT);
        
        $stmt->execute([$hash, $usuario['username']]);
        
        if ($stmt->rowCount() > 0) {
            echo "✅ " . str_pad($usuario['username'], 15) . " → contraseña: " . $usuario['password'] . "\n";
        } else {
            echo "⚠️  Usuario '{$usuario['username']}' no encontrado\n";
        }
    }
    
    echo "\n📋 Resumen de credenciales:\n\n";
    echo "┌─────────────────┬─────────────────┐\n";
    echo "│ Usuario         │ Contraseña      │\n";
    echo "├─────────────────┼─────────────────┤\n";
    foreach ($usuarios as $u) {
        echo "│ " . str_pad($u['username'], 15) . " │ " . str_pad($u['password'], 15) . " │\n";
    }
    echo "└─────────────────┴─────────────────┘\n";
    
    echo "\n✨ ¡Listo! Ahora puedes iniciar sesión con estas credenciales.\n";
    
} catch (PDOException $e) {
    echo "❌ Error de conexión: " . $e->getMessage() . "\n";
    exit(1);
}
