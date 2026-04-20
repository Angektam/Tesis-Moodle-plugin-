<?php
/**
 * Script de prueba simple para el evaluador de IA
 * No requiere Moodle instalado
 */

// Cargar variables de entorno
if (file_exists(__DIR__ . '/.env')) {
    $lines = file(__DIR__ . '/.env', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
    foreach ($lines as $line) {
        if (strpos(trim($line), '#') === 0) continue;
        list($key, $value) = explode('=', $line, 2);
        $_ENV[trim($key)] = trim($value);
    }
}

// Verificar API key
if (empty($_ENV['OPENAI_API_KEY']) || $_ENV['OPENAI_API_KEY'] === 'sk-your-api-key-here') {
    die("❌ ERROR: Por favor configura tu OPENAI_API_KEY en el archivo .env\n\n" .
        "1. Edita el archivo .env\n" .
        "2. Reemplaza 'sk-your-api-key-here' con tu API key real de OpenAI\n" .
        "3. Guarda el archivo y vuelve a ejecutar este script\n\n" .
        "Obtén tu API key en: https://platform.openai.com/api-keys\n");
}

echo "╔══════════════════════════════════════════════════════════════╗\n";
echo "║  PRUEBA DEL EVALUADOR DE IA - AI ASSIGNMENT PLUGIN          ║\n";
echo "╚══════════════════════════════════════════════════════════════╝\n\n";

/**
 * Función para evaluar usando OpenAI
 */
function evaluate_with_ai($student_answer, $teacher_solution, $type = 'programming') {
    $api_key = $_ENV['OPENAI_API_KEY'];
    $model = $_ENV['OPENAI_MODEL'] ?? 'gpt-4o-mini';
    
    // Preparar prompts
    if ($type === 'programming') {
        $system_prompt = 'Eres un asistente experto en evaluación de código de programación. ' .
                        'Tu tarea es comparar la respuesta de un estudiante con la solución del profesor ' .
                        'y proporcionar una evaluación justa y constructiva. ' .
                        'Debes responder ÚNICAMENTE en formato JSON con esta estructura exacta: ' .
                        '{"similarity_score": número entre 0 y 100, "feedback": "texto breve", "analysis": "análisis detallado"}';
        
        $user_prompt = "Compara estas dos soluciones de programación:\n\n" .
                      "SOLUCIÓN DEL PROFESOR:\n{$teacher_solution}\n\n" .
                      "RESPUESTA DEL ESTUDIANTE:\n{$student_answer}\n\n" .
                      "Evalúa:\n" .
                      "1. Funcionalidad (¿hace lo que debe hacer?)\n" .
                      "2. Estilo y claridad del código\n" .
                      "3. Buenas prácticas\n" .
                      "4. Eficiencia\n\n" .
                      "Proporciona un similarity_score (0-100), feedback breve y analysis detallado en JSON.";
    } else {
        $system_prompt = 'Eres un asistente experto en evaluación de problemas matemáticos. ' .
                        'Tu tarea es comparar la respuesta de un estudiante con la solución del profesor ' .
                        'y proporcionar una evaluación justa y constructiva. ' .
                        'Debes responder ÚNICAMENTE en formato JSON con esta estructura exacta: ' .
                        '{"similarity_score": número entre 0 y 100, "feedback": "texto breve", "analysis": "análisis detallado"}';
        
        $user_prompt = "Compara estas dos soluciones matemáticas:\n\n" .
                      "SOLUCIÓN DEL PROFESOR:\n{$teacher_solution}\n\n" .
                      "RESPUESTA DEL ESTUDIANTE:\n{$student_answer}\n\n" .
                      "Evalúa:\n" .
                      "1. Corrección de la respuesta\n" .
                      "2. Método utilizado\n" .
                      "3. Claridad de la explicación\n" .
                      "4. Pasos mostrados\n\n" .
                      "Proporciona un similarity_score (0-100), feedback breve y analysis detallado en JSON.";
    }
    
    // Preparar datos para la API
    $data = [
        'model' => $model,
        'messages' => [
            ['role' => 'system', 'content' => $system_prompt],
            ['role' => 'user', 'content' => $user_prompt]
        ],
        'temperature' => 0.3,
        'response_format' => ['type' => 'json_object']
    ];
    
    // Llamar a la API usando file_get_contents
    $options = [
        'http' => [
            'method' => 'POST',
            'header' => [
                'Content-Type: application/json',
                'Authorization: Bearer ' . $api_key
            ],
            'content' => json_encode($data),
            'ignore_errors' => true
        ]
    ];
    
    $context = stream_context_create($options);
    $response = file_get_contents('https://api.openai.com/v1/chat/completions', false, $context);
    
    if ($response === false) {
        throw new Exception('Error al conectar con OpenAI API');
    }
    
    $result = json_decode($response, true);
    
    // Verificar si hay error en la respuesta
    if (isset($result['error'])) {
        throw new Exception('OpenAI API Error: ' . ($result['error']['message'] ?? 'Unknown error'));
    }
    
    if (!isset($result['choices'][0]['message']['content'])) {
        throw new Exception('Invalid API response');
    }
    
    $content = json_decode($result['choices'][0]['message']['content'], true);
    
    if (!isset($content['similarity_score']) || !isset($content['feedback']) || !isset($content['analysis'])) {
        throw new Exception('Invalid evaluation format');
    }
    
    return [
        'similarity_score' => floatval($content['similarity_score']),
        'feedback' => $content['feedback'],
        'analysis' => $content['analysis']
    ];
}

/**
 * Función para mostrar resultados
 */
function display_result($test_name, $result) {
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n";
    echo "📝 {$test_name}\n";
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n";
    
    $score = $result['similarity_score'];
    $emoji = $score >= 90 ? '🌟' : ($score >= 70 ? '✅' : ($score >= 50 ? '⚠️' : '❌'));
    
    echo "{$emoji} PUNTUACIÓN: {$score}/100\n\n";
    echo "💬 FEEDBACK:\n{$result['feedback']}\n\n";
    echo "📊 ANÁLISIS DETALLADO:\n{$result['analysis']}\n\n";
}

// ============================================================================
// CASOS DE PRUEBA
// ============================================================================

echo "🧪 Ejecutando casos de prueba...\n\n";

// Caso 1: Problema de Programación - Solución Correcta
try {
    echo "1️⃣  Probando: Problema de Programación (Solución Correcta)\n";
    
    $teacher_solution = <<<'CODE'
def factorial(n):
    if n == 0 or n == 1:
        return 1
    return n * factorial(n - 1)
CODE;
    
    $student_answer = <<<'CODE'
def factorial(n):
    if n <= 1:
        return 1
    return n * factorial(n - 1)
CODE;
    
    $result = evaluate_with_ai($student_answer, $teacher_solution, 'programming');
    display_result('Problema de Programación - Solución Correcta', $result);
    
} catch (Exception $e) {
    echo "❌ Error: " . $e->getMessage() . "\n\n";
}

// Caso 2: Problema Matemático - Solución Correcta
try {
    echo "2️⃣  Probando: Problema Matemático (Solución Correcta)\n";
    
    $teacher_solution = "La derivada de f(x) = x² + 3x es f'(x) = 2x + 3";
    $student_answer = "f'(x) = 2x + 3";
    
    $result = evaluate_with_ai($student_answer, $teacher_solution, 'math');
    display_result('Problema Matemático - Solución Correcta', $result);
    
} catch (Exception $e) {
    echo "❌ Error: " . $e->getMessage() . "\n\n";
}

// Caso 3: Problema de Programación - Solución Incorrecta
try {
    echo "3️⃣  Probando: Problema de Programación (Solución Incorrecta)\n";
    
    $teacher_solution = <<<'CODE'
def es_par(n):
    return n % 2 == 0
CODE;
    
    $student_answer = <<<'CODE'
def es_par(n):
    return n % 2 == 1
CODE;
    
    $result = evaluate_with_ai($student_answer, $teacher_solution, 'programming');
    display_result('Problema de Programación - Solución Incorrecta', $result);
    
} catch (Exception $e) {
    echo "❌ Error: " . $e->getMessage() . "\n\n";
}

echo "╔══════════════════════════════════════════════════════════════╗\n";
echo "║  ✅ PRUEBAS COMPLETADAS                                      ║\n";
echo "╚══════════════════════════════════════════════════════════════╝\n\n";

echo "📌 SIGUIENTE PASO:\n";
echo "   Para instalar el plugin en Moodle:\n";
echo "   1. Ejecuta: crear-zip-plugin.bat (Windows) o ./crear-zip-plugin.sh (Linux/Mac)\n";
echo "   2. Sube el archivo aiassignment.zip en Moodle\n";
echo "   3. Configura tu API key en la configuración del plugin\n\n";
echo "📖 Documentación: moodle-plugin/INSTALACION_DESDE_INTERFAZ.md\n\n";
