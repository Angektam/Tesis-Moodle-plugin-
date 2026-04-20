const express = require('express');
const cors = require('cors');

const app = express();
const PORT = 3000;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.static('.'));

console.log(`
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║   🚀 SERVIDOR DEMO (SIN OPENAI)                             ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝

⚠️  MODO DEMO: Evaluación simulada (sin OpenAI)

Este servidor simula las respuestas de IA para que puedas
probar el plugin sin necesidad de créditos de OpenAI.

✅ Servidor corriendo en: http://localhost:${PORT}
✅ Plugin disponible en: http://localhost:${PORT}/plugin-funcional.html

📝 Endpoints disponibles:
   POST /api/evaluate  - Evaluar código (simulado)
   POST /api/compare   - Comparar similitud (simulado)

⚡ Presiona Ctrl+C para detener el servidor
`);

// Función para simular evaluación de código
function simulateEvaluation(studentAnswer, teacherSolution) {
    // Análisis básico del código
    const studentLines = studentAnswer.trim().split('\n').length;
    const teacherLines = teacherSolution.trim().split('\n').length;
    
    // Calcular similitud básica
    const lengthDiff = Math.abs(studentLines - teacherLines);
    let baseScore = 85;
    
    // Penalizar por diferencias grandes
    if (lengthDiff > 5) baseScore -= 20;
    else if (lengthDiff > 2) baseScore -= 10;
    
    // Verificar palabras clave comunes
    const studentWords = studentAnswer.toLowerCase();
    const teacherWords = teacherSolution.toLowerCase();
    
    const keywords = ['def', 'function', 'return', 'if', 'else', 'for', 'while', 'class'];
    let matchedKeywords = 0;
    
    keywords.forEach(keyword => {
        if (studentWords.includes(keyword) && teacherWords.includes(keyword)) {
            matchedKeywords++;
        }
    });
    
    baseScore += matchedKeywords * 2;
    
    // Limitar entre 0 y 100
    const score = Math.max(0, Math.min(100, baseScore));
    
    // Generar feedback basado en el score
    let feedback, analysis;
    
    if (score >= 90) {
        feedback = "¡Excelente trabajo! Tu código es muy similar a la solución esperada. Muestra un buen entendimiento del problema.";
        analysis = "Tu solución demuestra:\n• Correcta implementación de la lógica\n• Buen uso de estructuras de control\n• Código limpio y legible\n\nÁreas de mejora:\n• Considera agregar comentarios para mayor claridad";
    } else if (score >= 70) {
        feedback = "Buen trabajo. Tu código está en el camino correcto, aunque hay algunas diferencias con la solución esperada.";
        analysis = "Tu solución muestra:\n• Comprensión básica del problema\n• Uso adecuado de sintaxis\n\nÁreas de mejora:\n• Revisa la lógica en algunos casos\n• Considera optimizar el código\n• Agrega validaciones de entrada";
    } else if (score >= 50) {
        feedback = "Tu código tiene algunos problemas. Revisa la lógica y compárala con la solución esperada.";
        analysis = "Aspectos a mejorar:\n• La lógica no coincide completamente con lo esperado\n• Faltan algunos casos importantes\n• Considera revisar la estructura del código\n\nSugerencias:\n• Revisa los casos base\n• Verifica las condiciones\n• Prueba con diferentes entradas";
    } else {
        feedback = "Tu código necesita mejoras significativas. Te recomiendo revisar la solución esperada y entender la lógica.";
        analysis = "Problemas detectados:\n• La implementación no coincide con lo esperado\n• Posibles errores de lógica\n• Estructura incorrecta\n\nRecomendaciones:\n• Revisa los conceptos básicos\n• Compara tu código línea por línea con la solución\n• Practica con ejemplos similares";
    }
    
    return {
        score: Math.round(score),
        feedback: feedback,
        analysis: analysis
    };
}

// Función para simular comparación de similitud
function simulateSimilarity(answer1, answer2) {
    // Normalizar los códigos
    const normalize = (code) => code.toLowerCase().replace(/\s+/g, '').replace(/[^a-z0-9]/g, '');
    
    const norm1 = normalize(answer1);
    const norm2 = normalize(answer2);
    
    // Calcular similitud simple
    if (norm1 === norm2) return 95 + Math.floor(Math.random() * 5);
    
    // Calcular similitud por caracteres comunes
    let matches = 0;
    const minLen = Math.min(norm1.length, norm2.length);
    
    for (let i = 0; i < minLen; i++) {
        if (norm1[i] === norm2[i]) matches++;
    }
    
    const similarity = Math.round((matches / Math.max(norm1.length, norm2.length)) * 100);
    
    // Agregar algo de variación
    return Math.max(0, Math.min(100, similarity + Math.floor(Math.random() * 10 - 5)));
}

// Endpoint para evaluar código
app.post('/api/evaluate', async (req, res) => {
    try {
        const { studentAnswer, teacherSolution } = req.body;
        
        if (!studentAnswer || !teacherSolution) {
            return res.status(400).json({ error: 'Faltan parámetros requeridos' });
        }
        
        console.log('📝 Evaluando código (modo demo)...');
        
        // Simular delay de API
        await new Promise(resolve => setTimeout(resolve, 1000));
        
        const result = simulateEvaluation(studentAnswer, teacherSolution);
        
        console.log(`✅ Evaluación completada: ${result.score}%`);
        
        res.json(result);
        
    } catch (error) {
        console.error('❌ Error:', error);
        res.status(500).json({ error: error.message });
    }
});

// Endpoint para comparar similitud
app.post('/api/compare', async (req, res) => {
    try {
        const { answer1, answer2 } = req.body;
        
        if (!answer1 || !answer2) {
            return res.status(400).json({ error: 'Faltan parámetros requeridos' });
        }
        
        console.log('🔍 Comparando similitud (modo demo) - Detección automática...');
        
        // Simular delay de API
        await new Promise(resolve => setTimeout(resolve, 500));
        
        const similarity = simulateSimilarity(answer1, answer2);
        
        const level = similarity >= 70 ? '⚠️  ALTA' : similarity >= 40 ? '⚡ MEDIA' : '✅ BAJA';
        console.log(`${level} Similitud: ${similarity}%`);
        
        res.json({ similarity });
        
    } catch (error) {
        console.error('❌ Error:', error);
        res.status(500).json({ error: error.message });
    }
});

app.listen(PORT, () => {
    console.log(`
🎯 Servidor listo para recibir peticiones
📍 URL: http://localhost:${PORT}
    `);
});
