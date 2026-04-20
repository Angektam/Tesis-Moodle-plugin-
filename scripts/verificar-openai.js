#!/usr/bin/env node

/**
 * Script para verificar la configuración de OpenAI API
 * Prueba la conexión y hace una evaluación de ejemplo
 */

require('dotenv').config();

const OPENAI_API_KEY = process.env.OPENAI_API_KEY;
const OPENAI_MODEL = process.env.OPENAI_MODEL || 'gpt-4o-mini';

console.log('\n🔍 Verificando configuración de OpenAI...\n');

// Verificar que existe la API key
if (!OPENAI_API_KEY) {
    console.error('❌ ERROR: OPENAI_API_KEY no está configurada en .env');
    console.log('\n📝 Pasos para configurar:');
    console.log('1. Ve a https://platform.openai.com/api-keys');
    console.log('2. Crea una nueva API key');
    console.log('3. Agrégala al archivo .env:');
    console.log('   OPENAI_API_KEY=sk-proj-tu-api-key-aqui\n');
    process.exit(1);
}

// Verificar formato de la API key
if (!OPENAI_API_KEY.startsWith('sk-')) {
    console.error('❌ ERROR: La API key no tiene el formato correcto');
    console.log('   Debe empezar con "sk-"\n');
    process.exit(1);
}

console.log('✅ API Key encontrada');
console.log(`✅ Modelo: ${OPENAI_MODEL}`);
console.log(`✅ Key: ${OPENAI_API_KEY.substring(0, 20)}...${OPENAI_API_KEY.substring(OPENAI_API_KEY.length - 4)}\n`);

// Probar conexión con OpenAI
async function testOpenAI() {
    console.log('🧪 Probando conexión con OpenAI API...\n');

    const url = 'https://api.openai.com/v1/chat/completions';
    
    const data = {
        model: OPENAI_MODEL,
        messages: [
            {
                role: 'system',
                content: 'Eres un asistente que evalúa código. Responde en JSON con: {"score": número, "feedback": "texto"}'
            },
            {
                role: 'user',
                content: 'Evalúa este código Python:\n\ndef factorial(n):\n    if n <= 1:\n        return 1\n    return n * factorial(n-1)'
            }
        ],
        temperature: 0.3,
        max_tokens: 500,
        response_format: { type: 'json_object' }
    };

    try {
        const fetch = (await import('node-fetch')).default;
        
        const response = await fetch(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${OPENAI_API_KEY}`
            },
            body: JSON.stringify(data)
        });

        if (!response.ok) {
            const error = await response.json();
            throw new Error(error.error?.message || 'Error desconocido');
        }

        const result = await response.json();
        
        console.log('✅ Conexión exitosa con OpenAI API\n');
        console.log('📊 Respuesta de prueba:');
        console.log('─────────────────────────────────────');
        
        const content = JSON.parse(result.choices[0].message.content);
        console.log(JSON.stringify(content, null, 2));
        
        console.log('─────────────────────────────────────\n');
        console.log('💰 Uso de tokens:');
        console.log(`   Prompt: ${result.usage.prompt_tokens} tokens`);
        console.log(`   Respuesta: ${result.usage.completion_tokens} tokens`);
        console.log(`   Total: ${result.usage.total_tokens} tokens\n`);
        
        // Calcular costo aproximado (gpt-4o-mini)
        const inputCost = (result.usage.prompt_tokens / 1000000) * 0.150;
        const outputCost = (result.usage.completion_tokens / 1000000) * 0.600;
        const totalCost = inputCost + outputCost;
        
        console.log('💵 Costo estimado de esta prueba:');
        console.log(`   $${totalCost.toFixed(6)} USD\n`);
        
        console.log('✅ TODO FUNCIONA CORRECTAMENTE');
        console.log('🚀 El plugin está listo para usar evaluación con IA real\n');
        
        return true;
        
    } catch (error) {
        console.error('❌ ERROR al conectar con OpenAI:\n');
        console.error(`   ${error.message}\n`);
        
        if (error.message.includes('Incorrect API key')) {
            console.log('💡 Solución:');
            console.log('   1. Verifica que tu API key sea válida');
            console.log('   2. Ve a https://platform.openai.com/api-keys');
            console.log('   3. Crea una nueva key si es necesario');
            console.log('   4. Actualiza el archivo .env\n');
        } else if (error.message.includes('insufficient_quota')) {
            console.log('💡 Solución:');
            console.log('   1. Tu cuenta no tiene créditos');
            console.log('   2. Ve a https://platform.openai.com/account/billing');
            console.log('   3. Agrega un método de pago\n');
        } else if (error.message.includes('rate_limit')) {
            console.log('💡 Solución:');
            console.log('   Has excedido el límite de requests');
            console.log('   Espera unos minutos e intenta de nuevo\n');
        }
        
        return false;
    }
}

// Ejecutar prueba
testOpenAI().then(success => {
    process.exit(success ? 0 : 1);
});
