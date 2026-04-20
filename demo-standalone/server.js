const express = require('express');
const cors = require('cors');
const fetch = require('node-fetch');
require('dotenv').config();
const ASTComparator = require('./services/ast_comparator');

const app = express();
const PORT = 3000;
const astComparator = new ASTComparator();

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.static('demo-standalone'));
app.use(express.static('.'));

// API Key
const API_KEY = process.env.OPENAI_API_KEY;

if (!API_KEY || API_KEY === 'sk-your-api-key-here') {
    console.error(`
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║   ❌ ERROR: API KEY NO CONFIGURADA                          ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝

⚠️  No se encontró una API key válida de OpenAI.

📝 SOLUCIÓN:

1. Edita el archivo .env en la raíz del proyecto
2. Agrega tu API key:
   OPENAI_API_KEY=tu-api-key-aqui
3. Reinicia el servidor: npm start

🔑 Obtén tu API key en:
   https://platform.openai.com/api-keys

    `);
    process.exit(1);
}

// Endpoint para evaluar código usando AST + IA
app.post('/api/evaluate', async (req, res) => {
    try {
        const { studentAnswer, teacherSolution, language = 'javascript' } = req.body;
        
        // PASO 1: Análisis estructural con AST
        const astResult = await astComparator.compare(studentAnswer, teacherSolution, language);
        
        // PASO 2: Generar feedback basado en similitud AST
        let feedback = '';
        let analysis = '';
        let useAI = false;
        
        if (astResult.similarity >= 90) {
            // Código casi idéntico o muy similar
            feedback = '✅ Excelente! Tu solución es estructuralmente muy similar a la solución correcta.';
            analysis = `Análisis estructural (AST): ${astResult.similarity}% de similitud. ` +
                      `Tu código sigue la misma lógica y estructura que la solución del profesor. ` +
                      `Funciones: ${astResult.details?.code2_features?.functions || 0}, ` +
                      `Loops: ${astResult.details?.code2_features?.loops || 0}, ` +
                      `Condicionales: ${astResult.details?.code2_features?.conditionals || 0}.`;
        } else if (astResult.similarity >= 70) {
            // Buena similitud, pero con diferencias
            feedback = '✅ Muy bien! Tu solución es correcta aunque con algunas diferencias estructurales.';
            analysis = `Análisis estructural (AST): ${astResult.similarity}% de similitud. ` +
                      `Tu código logra el objetivo pero con un enfoque ligeramente diferente. ` +
                      `Esto puede ser por diferente estilo de programación o algoritmo alternativo.`;
        } else if (astResult.similarity >= 50) {
            // Similitud media - necesita revisión con IA
            useAI = true;
        } else if (astResult.similarity >= 30) {
            // Baja similitud
            feedback = '⚠️ Tu solución tiene diferencias significativas con la solución esperada.';
            analysis = `Análisis estructural (AST): ${astResult.similarity}% de similitud. ` +
                      `Tu código usa un enfoque muy diferente. Revisa si cumple con los requisitos del problema.`;
        } else {
            // Muy diferente o posible error
            feedback = '❌ Tu solución es muy diferente a la esperada o puede tener errores.';
            analysis = `Análisis estructural (AST): ${astResult.similarity}% de similitud. ` +
                      `Tu código tiene una estructura completamente diferente. Verifica la lógica y los requisitos.`;
        }
        
        // PASO 3: Si necesita análisis de IA (casos ambiguos)
        if (useAI) {
            const systemPrompt = `Eres un experto en evaluación de código. El análisis AST detectó ${astResult.similarity}% de similitud estructural.
            
Debes responder ÚNICAMENTE en formato JSON:
{
  "similarity_score": número entre 0 y 100,
  "feedback": "texto breve y constructivo (2-3 líneas)",
  "analysis": "análisis detallado del código"
}`;
            
            const userPrompt = `Análisis AST previo: ${astResult.similarity}% similitud estructural.

SOLUCIÓN DEL PROFESOR:
\`\`\`
${teacherSolution}
\`\`\`

RESPUESTA DEL ESTUDIANTE:
\`\`\`
${studentAnswer}
\`\`\`

Evalúa:
1. ¿El código funciona correctamente?
2. ¿Hay errores de lógica?
3. ¿Es un enfoque válido aunque diferente?

Responde SOLO en JSON.`;
            
            const response = await fetch('https://api.openai.com/v1/chat/completions', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${API_KEY}`
                },
                body: JSON.stringify({
                    model: 'gpt-4o-mini',
                    messages: [
                        { role: 'system', content: systemPrompt },
                        { role: 'user', content: userPrompt }
                    ],
                    temperature: 0.3,
                    response_format: { type: 'json_object' }
                })
            });
            
            const data = await response.json();
            
            if (!response.ok) {
                throw new Error(data.error?.message || 'Error en OpenAI API');
            }
            
            const result = JSON.parse(data.choices[0].message.content);
            
            // Combinar AST + IA (60% AST, 40% IA)
            const combinedScore = Math.round(astResult.similarity * 0.6 + result.similarity_score * 0.4);
            
            return res.json({
                score: combinedScore,
                feedback: result.feedback,
                analysis: `${result.analysis}\n\nAnálisis AST: ${astResult.similarity}% similitud estructural.`,
                method: 'hybrid',
                ast_similarity: astResult.similarity,
                ai_similarity: result.similarity_score
            });
        }
        
        // PASO 4: Retornar resultado AST (casos claros)
        res.json({
            score: astResult.similarity,
            feedback: feedback,
            analysis: analysis,
            method: 'ast',
            ast_details: astResult.details
        });
        
    } catch (error) {
        console.error('Error:', error);
        res.status(500).json({ error: error.message });
    }
});

// Endpoint para comparar similitud (plagio) usando AST
app.post('/api/compare', async (req, res) => {
    try {
        const { answer1, answer2, language = 'javascript' } = req.body;
        
        // Validar entrada
        if (!answer1 || !answer2) {
            return res.status(400).json({ 
                error: 'Se requieren ambos códigos para comparar',
                similarity: 0,
                method: 'error'
            });
        }

        if (typeof answer1 !== 'string' || typeof answer2 !== 'string') {
            return res.status(400).json({ 
                error: 'Los códigos deben ser texto',
                similarity: 0,
                method: 'error'
            });
        }

        // Validar que no estén vacíos (después de trim)
        if (answer1.trim().length === 0 || answer2.trim().length === 0) {
            return res.status(400).json({ 
                error: 'Los códigos no pueden estar vacíos',
                similarity: 0,
                method: 'error'
            });
        }
        
        // Comparación usando AST (Abstract Syntax Tree)
        const astResult = await astComparator.compare(answer1, answer2, language);
        
        // Si la similitud AST es muy alta, retornar directamente
        if (astResult.similarity >= 85) {
            return res.json({
                similarity: astResult.similarity,
                method: 'ast',
                confidence: 'high',
                details: astResult.details,
                message: 'Similitud estructural muy alta detectada por análisis AST'
            });
        }
        
        // Para similitudes medias, complementar con análisis de IA
        if (astResult.similarity >= 50) {
            const prompt = `Analiza la similitud semántica entre estos dos códigos. 
El análisis AST detectó ${astResult.similarity}% de similitud estructural.

Considera:
- Estructura y lógica similar
- Mismo enfoque algorítmico
- Nombres de variables diferentes pero misma funcionalidad
- Código idéntico o casi idéntico

Responde SOLO con un número del 0 al 100 indicando el porcentaje de similitud:
- 0-30: Códigos completamente diferentes
- 31-60: Algunas similitudes pero enfoques distintos
- 61-85: Muy similares, posible colaboración
- 86-100: Prácticamente idénticos, alta probabilidad de plagio

CÓDIGO 1:
\`\`\`
${answer1}
\`\`\`

CÓDIGO 2:
\`\`\`
${answer2}
\`\`\`

Responde SOLO con el número (ejemplo: 75)`;
            
            const response = await fetch('https://api.openai.com/v1/chat/completions', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${API_KEY}`
                },
                body: JSON.stringify({
                    model: 'gpt-4o-mini',
                    messages: [{ role: 'user', content: prompt }],
                    temperature: 0.3
                })
            });
            
            const data = await response.json();
            
            if (!response.ok) {
                throw new Error(data.error?.message || 'Error en OpenAI API');
            }
            
            const content = data.choices[0].message.content;
            const aiSimilarity = parseInt(content.match(/\d+/)[0]);
            
            // Combinar resultados (70% AST, 30% IA)
            const combinedSimilarity = Math.round(astResult.similarity * 0.7 + aiSimilarity * 0.3);
            
            return res.json({
                similarity: combinedSimilarity,
                method: 'hybrid',
                confidence: 'medium',
                details: {
                    ast_similarity: astResult.similarity,
                    ai_similarity: aiSimilarity,
                    ast_method: astResult.method,
                    ...astResult.details
                },
                message: 'Análisis combinado: AST + IA'
            });
        }
        
        // Para similitudes bajas, retornar resultado AST
        res.json({
            similarity: astResult.similarity,
            method: 'ast',
            confidence: 'high',
            details: astResult.details,
            message: 'Similitud baja detectada por análisis AST'
        });
        
    } catch (error) {
        console.error('Error:', error);
        res.status(500).json({ error: error.message });
    }
});

app.listen(PORT, () => {
    console.log(`
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║   🚀 SERVIDOR BACKEND INICIADO                              ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝

✅ Servidor corriendo en: http://localhost:${PORT}
✅ Plugin disponible en: http://localhost:${PORT}/plugin-funcional.html

📝 Endpoints disponibles:
   POST /api/evaluate  - Evaluar código con IA
   POST /api/compare   - Comparar similitud (AST + IA)

🌳 Detección de plagio con AST (Abstract Syntax Trees)
⚡ Presiona Ctrl+C para detener el servidor
    `);
});
