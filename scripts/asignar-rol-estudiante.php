<?php
/**
 * Asignar rol de estudiante a nivel de sistema a todos los usuarios de prueba
 * Ejecutar: php scripts/asignar-rol-estudiante.php
 */

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
$host = $env['DB_HOST'] ?? 'localhost';
$dbname = $env['DB_NAME'] ?? 'moodle';
$user = $env['DB_USER'] ?? 'root';
$pass = $env['DB_PASS'] ?? '';

try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8mb4", $user, $pass);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    echo "👥 Asignando rol de estudiante a usuarios de prueba...\n\n";
    
    // Obtener el ID del rol de estudiante (student)
    $stmt = $pdo->query("SELECT id FROM mdl_role WHERE shortname = 'student' LIMIT 1");
    $rolEstudiante = $stmt->fetch(PDO::FETCH_ASSOC);
    
    if (!$rolEstudiante) {
        echo "❌ No se encontró el rol 'student' en la base de datos\n";
        exit(1);
    }
    
    $rolId = $rolEstudiante['id'];
    echo "✓ Rol de estudiante encontrado (ID: $rolId)\n\n";
    
    // Obtener el contexto del sistema (contextlevel = 10)
    $stmt = $pdo->query("SELECT id FROM mdl_context WHERE contextlevel = 10 LIMIT 1");
    $contextoSistema = $stmt->fetch(PDO::FETCH_ASSOC);
    $contextId = $contextoSistema['id'];
    
    echo "✓ Contexto del sistema: $contextId\n\n";
    
    // Obtener todos los usuarios que no son admin ni guest
    $stmt = $pdo->query("
        SELECT id, username, firstname, lastname 
        FROM mdl_user 
        WHERE username NOT IN ('admin', 'guest') 
        AND deleted = 0
        ORDER BY id
    ");
    $usuarios = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    $asignados = 0;
    $yaExistian = 0;
    
    foreach ($usuarios as $usuario) {
        // Verificar si ya tiene el rol asignado
        $stmt = $pdo->prepare("
            SELECT id FROM mdl_role_assignments 
            WHERE userid = ? AND roleid = ? AND contextid = ?
        ");
        $stmt->execute([$usuario['id'], $rolId, $contextId]);
        
        if ($stmt->fetch()) {
            $yaExistian++;
            echo "⚪ {$usuario['username']} ya tiene rol de estudiante\n";
        } else {
            // Asignar el rol
            $stmt = $pdo->prepare("
                INSERT INTO mdl_role_assignments 
                (roleid, contextid, userid, timemodified, modifierid) 
                VALUES (?, ?, ?, ?, 2)
            ");
            $stmt->execute([$rolId, $contextId, $usuario['id'], time()]);
            $asignados++;
            echo "✅ {$usuario['username']} → rol de estudiante asignado\n";
        }
    }
    
    echo "\n📊 Resumen:\n";
    echo "   • Usuarios procesados: " . count($usuarios) . "\n";
    echo "   • Roles asignados: $asignados\n";
    echo "   • Ya tenían rol: $yaExistian\n";
    echo "\n✨ ¡Listo! Ahora los usuarios deberían aparecer en el buscador.\n";
    
} catch (PDOException $e) {
    echo "❌ Error: " . $e->getMessage() . "\n";
    exit(1);
}
