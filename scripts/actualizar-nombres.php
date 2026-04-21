<?php
/**
 * Actualizar nombres únicos para todos los usuarios de prueba
 * Ejecutar: php scripts/actualizar-nombres.php
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

$usuarios = [
    // est01 - est30
    'est01' => ['Carlos',     'García'],
    'est02' => ['María',      'López'],
    'est03' => ['Pedro',      'Martínez'],
    'est04' => ['Ana',        'Rodríguez'],
    'est05' => ['Luis',       'Hernández'],
    'est06' => ['Sofía',      'Jiménez'],
    'est07' => ['Diego',      'Torres'],
    'est08' => ['Valentina',  'Flores'],
    'est09' => ['Andrés',     'Vargas'],
    'est10' => ['Camila',     'Reyes'],
    'est11' => ['Sebastián',  'Cruz'],
    'est12' => ['Isabella',   'Morales'],
    'est13' => ['Mateo',      'Ortiz'],
    'est14' => ['Lucía',      'Mendoza'],
    'est15' => ['Nicolás',    'Castillo'],
    'est16' => ['Gabriela',   'Ramos'],
    'est17' => ['Felipe',     'Gutiérrez'],
    'est18' => ['Daniela',    'Sánchez'],
    'est19' => ['Tomás',      'Ramírez'],
    'est20' => ['Valeria',    'Núñez'],
    'est21' => ['Emilio',     'Peña'],
    'est22' => ['Renata',     'Aguilar'],
    'est23' => ['Joaquín',    'Medina'],
    'est24' => ['Mariana',    'Vega'],
    'est25' => ['Rodrigo',    'Herrera'],
    'est26' => ['Natalia',    'Ríos'],
    'est27' => ['Alejandro',  'Mora'],
    'est28' => ['Paula',      'Delgado'],
    'est29' => ['Ignacio',    'Fuentes'],
    'est30' => ['Catalina',   'Espinoza'],
    // alumno_c1 - alumno_c5
    'alumno_c1' => ['Juan',     'Pérez'],
    'alumno_c2' => ['Laura',    'González'],
    'alumno_c3' => ['Miguel',   'Ramírez'],
    'alumno_c4' => ['Sofía',    'Torres'],   // diferente apellido que est06
    'alumno_c5' => ['Carlos',   'Mendoza'],  // diferente apellido que est01
    // alumno1 - alumno5
    'alumno1'   => ['Roberto',  'Salinas'],
    'alumno2'   => ['Patricia', 'Guerrero'],
    'alumno3'   => ['Fernando', 'Ibáñez'],
    'alumno4'   => ['Claudia',  'Paredes'],
    'alumno5'   => ['Héctor',   'Villanueva'],
    // estudiante1 - estudiante3
    'estudiante1' => ['Ximena',  'Contreras'],
    'estudiante2' => ['Arturo',  'Domínguez'],
    'estudiante3' => ['Beatriz', 'Escobar'],
];

echo "✏️  Actualizando nombres únicos...\n\n";

$stmt = $pdo->prepare('UPDATE mdl_user SET firstname = ?, lastname = ? WHERE username = ?');
$ok = 0;

foreach ($usuarios as $username => [$firstname, $lastname]) {
    $stmt->execute([$firstname, $lastname, $username]);
    if ($stmt->rowCount() > 0) {
        echo "✅ $username → $firstname $lastname\n";
        $ok++;
    } else {
        echo "⚠️  $username no encontrado\n";
    }
}

echo "\n✅ $ok usuarios actualizados.\n";
