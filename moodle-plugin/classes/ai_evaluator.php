<?php
// This file is part of Moodle - http://moodle.org/

namespace mod_aiassignment;

defined('MOODLE_INTERNAL') || die();

/**
 * Servicio de evaluación con IA usando OpenAI
 */
class ai_evaluator {

    /**
     * Evalúa una respuesta de estudiante usando OpenAI
     *
     * @param string $studentanswer Respuesta del estudiante
     * @param string $teachersolution Solución del profesor
     * @param string $type Tipo de problema (math o programming)
     * @return array Resultado de la evaluación
     */
    public static function evaluate($studentanswer, $teachersolution, $type) {
        global $CFG;

        // Verificar si está en modo demo
        $demomode = get_config('mod_aiassignment', 'demo_mode');
        if ($demomode) {
            return self::demo_evaluate($studentanswer, $teachersolution, $type);
        }

        // Obtener API key de la configuración
        $apikey = get_config('mod_aiassignment', 'openai_api_key');
        if (empty($apikey)) {
            throw new \moodle_exception('noapikey', 'mod_aiassignment');
        }

        $model = get_config('mod_aiassignment', 'openai_model');
        if (empty($model)) {
            $model = 'gpt-4o-mini';
        }

        // Preparar el prompt según el tipo
        $systemprompt = self::get_system_prompt($type);
        $userprompt = self::get_user_prompt($studentanswer, $teachersolution, $type);

        // Llamar a OpenAI API
        try {
            $result = self::call_openai_api($apikey, $model, $systemprompt, $userprompt);
            return $result;
        } catch (\Exception $e) {
            debugging('OpenAI API Error: ' . $e->getMessage(), DEBUG_DEVELOPER);
            throw new \moodle_exception('evaluationfailed', 'mod_aiassignment', '', null, $e->getMessage());
        }
    }

    /**
     * Evaluación simulada para modo demo (sin OpenAI API)
     *
     * @param string $studentanswer
     * @param string $teachersolution
     * @param string $type
     * @return array
     */
    private static function demo_evaluate($studentanswer, $teachersolution, $type) {
        // Calcular similitud básica por longitud y palabras clave
        $score = self::calculate_demo_score($studentanswer, $teachersolution, $type);
        
        $feedback = self::generate_demo_feedback($score, $type);
        $analysis = self::generate_demo_analysis($studentanswer, $type, $score);

        return array(
            'similarity_score' => $score,
            'feedback' => $feedback,
            'analysis' => $analysis
        );
    }

    /**
     * Calcula un puntaje demo basado en similitud simple
     */
    private static function calculate_demo_score($studentanswer, $teachersolution, $type) {
        $studentlen = strlen(trim($studentanswer));
        $teacherlen = strlen(trim($teachersolution));
        
        // Puntaje base por longitud similar
        $lengthratio = min($studentlen, $teacherlen) / max($studentlen, $teacherlen, 1);
        $basescore = $lengthratio * 50;
        
        // Palabras clave para programación
        if ($type === 'programming') {
            $keywords = array('def', 'function', 'return', 'if', 'for', 'while', 'class');
            $keywordcount = 0;
            foreach ($keywords as $keyword) {
                if (stripos($studentanswer, $keyword) !== false) {
                    $keywordcount++;
                }
            }
            $basescore += ($keywordcount * 5);
        }
        
        // Bonus si contiene palabras de la solución
        $teacherwords = str_word_count(strtolower($teachersolution), 1);
        $studentwords = str_word_count(strtolower($studentanswer), 1);
        $commonwords = count(array_intersect($teacherwords, $studentwords));
        $basescore += min($commonwords * 2, 30);
        
        // Normalizar entre 60-95 para respuestas razonables
        $score = min(95, max(60, $basescore));
        
        return round($score, 2);
    }

    /**
     * Genera feedback demo
     */
    private static function generate_demo_feedback($score, $type) {
        if ($score >= 90) {
            return 'Excelente trabajo. La solución es correcta y bien estructurada.';
        } else if ($score >= 80) {
            return 'Muy bien. La solución es correcta, aunque podría mejorarse en algunos aspectos.';
        } else if ($score >= 70) {
            return 'Bien. La solución funciona pero hay áreas de mejora en la implementación.';
        } else {
            return 'La solución necesita mejoras. Revisa la lógica y la estructura del código.';
        }
    }

    /**
     * Genera análisis demo
     */
    private static function generate_demo_analysis($studentanswer, $type, $score) {
        $analysis = "MODO DEMO - Evaluación Simulada\n\n";
        
        if ($type === 'programming') {
            $analysis .= "Análisis del código:\n";
            $analysis .= "- Longitud de la respuesta: " . strlen($studentanswer) . " caracteres\n";
            $analysis .= "- Estructura: " . ($score >= 80 ? "Adecuada" : "Necesita mejoras") . "\n";
            $analysis .= "- Sintaxis: " . ($score >= 70 ? "Correcta" : "Revisar") . "\n";
            $analysis .= "- Lógica: " . ($score >= 75 ? "Funcional" : "Necesita revisión") . "\n\n";
            $analysis .= "Nota: Esta es una evaluación simulada. Para evaluación real con IA, ";
            $analysis .= "configura tu OpenAI API Key en la configuración del plugin.";
        } else {
            $analysis .= "Análisis de la solución matemática:\n";
            $analysis .= "- Desarrollo: " . ($score >= 80 ? "Completo" : "Incompleto") . "\n";
            $analysis .= "- Procedimiento: " . ($score >= 75 ? "Correcto" : "Revisar pasos") . "\n";
            $analysis .= "- Resultado: " . ($score >= 70 ? "Adecuado" : "Verificar") . "\n\n";
            $analysis .= "Nota: Esta es una evaluación simulada. Para evaluación real con IA, ";
            $analysis .= "configura tu OpenAI API Key en la configuración del plugin.";
        }
        
        return $analysis;
    }

    /**
     * Obtiene el prompt del sistema según el tipo de problema
     *
     * @param string $type
     * @return string
     */
    private static function get_system_prompt($type) {
        if ($type === 'programming') {
            return 'Eres un asistente experto en evaluación de código de programación. ' .
                   'Tu tarea es comparar la respuesta de un estudiante con la solución del profesor ' .
                   'y proporcionar una evaluación justa y constructiva. ' .
                   'Debes responder ÚNICAMENTE en formato JSON con esta estructura exacta: ' .
                   '{"similarity_score": número entre 0 y 100, "feedback": "texto breve", "analysis": "análisis detallado"}';
        } else {
            return 'Eres un asistente experto en evaluación de problemas matemáticos. ' .
                   'Tu tarea es comparar la respuesta de un estudiante con la solución del profesor ' .
                   'y proporcionar una evaluación justa y constructiva. ' .
                   'Debes responder ÚNICAMENTE en formato JSON con esta estructura exacta: ' .
                   '{"similarity_score": número entre 0 y 100, "feedback": "texto breve", "analysis": "análisis detallado"}';
        }
    }

    /**
     * Obtiene el prompt del usuario
     *
     * @param string $studentanswer
     * @param string $teachersolution
     * @param string $type
     * @return string
     */
    private static function get_user_prompt($studentanswer, $teachersolution, $type) {
        if ($type === 'programming') {
            return "Compara estas dos soluciones de programación:\n\n" .
                   "SOLUCIÓN DEL PROFESOR:\n{$teachersolution}\n\n" .
                   "RESPUESTA DEL ESTUDIANTE:\n{$studentanswer}\n\n" .
                   "Evalúa:\n" .
                   "1. Funcionalidad (¿hace lo que debe hacer?)\n" .
                   "2. Estilo y claridad del código\n" .
                   "3. Buenas prácticas\n" .
                   "4. Eficiencia\n\n" .
                   "Proporciona un similarity_score (0-100), feedback breve y analysis detallado en JSON.";
        } else {
            return "Compara estas dos soluciones matemáticas:\n\n" .
                   "SOLUCIÓN DEL PROFESOR:\n{$teachersolution}\n\n" .
                   "RESPUESTA DEL ESTUDIANTE:\n{$studentanswer}\n\n" .
                   "Evalúa:\n" .
                   "1. Corrección de la respuesta\n" .
                   "2. Método utilizado\n" .
                   "3. Claridad de la explicación\n" .
                   "4. Pasos mostrados\n\n" .
                   "Proporciona un similarity_score (0-100), feedback breve y analysis detallado en JSON.";
        }
    }

    /**
     * Llama a la API de OpenAI con reintentos automáticos (mejora #9)
     *
     * @param string $apikey
     * @param string $model
     * @param string $systemprompt
     * @param string $userprompt
     * @return array
     */
    private static function call_openai_api($apikey, $model, $systemprompt, $userprompt) {
        $url = 'https://api.openai.com/v1/chat/completions';

        $data = array(
            'model' => $model,
            'messages' => array(
                array('role' => 'system', 'content' => $systemprompt),
                array('role' => 'user', 'content' => $userprompt)
            ),
            'temperature' => 0.3,
            'response_format' => array('type' => 'json_object')
        );

        $options = array(
            'CURLOPT_RETURNTRANSFER' => true,
            'CURLOPT_HTTPHEADER' => array(
                'Content-Type: application/json',
                'Authorization: Bearer ' . $apikey
            ),
            'CURLOPT_POST' => true,
            'CURLOPT_POSTFIELDS' => json_encode($data)
        );

        // Reintentos automáticos: hasta N intentos con pausa de 2s entre ellos
        $maxretries = (int)(get_config('mod_aiassignment', 'openai_retries') ?: 2);
        $lasterror  = null;
        for ($attempt = 1; $attempt <= $maxretries; $attempt++) {
            try {
                $curl     = new \curl();
                $response = $curl->post($url, json_encode($data), $options);

                if ($curl->get_errno()) {
                    throw new \Exception('cURL Error: ' . $curl->error);
                }

                $result = json_decode($response, true);

                if (isset($result['error'])) {
                    // Error 429 (rate limit) o 5xx → reintentar
                    $code = $result['error']['code'] ?? '';
                    if ($attempt < $maxretries && in_array($code, ['rate_limit_exceeded', 'server_error'])) {
                        sleep(2);
                        continue;
                    }
                    throw new \Exception('OpenAI API Error: ' . $result['error']['message']);
                }

                if (!isset($result['choices'][0]['message']['content'])) {
                    throw new \Exception('Invalid API response');
                }

                $content = json_decode($result['choices'][0]['message']['content'], true);

                if (!isset($content['similarity_score']) || !isset($content['feedback']) || !isset($content['analysis'])) {
                    throw new \Exception('Invalid evaluation format');
                }

                return array(
                    'similarity_score' => floatval($content['similarity_score']),
                    'feedback'         => $content['feedback'],
                    'analysis'         => $content['analysis']
                );

            } catch (\Exception $e) {
                $lasterror = $e;
                if ($attempt < $maxretries) {
                    sleep(2);
                }
            }
        }

        throw $lasterror;
    }
}
