const http = require('http');
const fs = require('fs');
const path = require('path');

const PORT = 3000;
const API_KEY = 'TU_API_KEY_AQUI';

const server = http.createServer(async (req, res) => {
    // CORS headers
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
    
    if (req.method === 'OPTIONS') {
        res.writeHead(200);
        res.end();
        return;
    }
    
    // Servir archivos estáticos
    if (req.method === 'GET') {
        let filePath = '.' + req.url;
        if (filePath === './') filePath = './plugin-funcional.html';
        
        const extname = path.extname(filePath);
        const contentTypes = {
            '.html': 'text/html',
            '.js': 'text/javascript',
            '.css': 'text/css',
            '.json': 'application/json'
        };
        
        const contentType = contentTypes[extname] || 'text/plain';
        
        fs.readFile(filePath, (err, content) => {
            if (err) {
                res.writeHead(404);
                res.end('File not found');
            } else {
                res.writeHead(200, { 'Content-Type': contentType });
                res.end(content, 'utf-8');
            }
        });
        return;
    }
    
    // API proxy para OpenAI
    if (req.method === 'POST' && req.url === '/api/evaluate') {
        let body = '';
        
        req.on('data', chunk => {
            body += chunk.toString();
        });
        
        req.on('end', async () => {
            try {
                const data = JSON.parse(body);
                
                const response = await fetch('https://api.openai.com/v1/chat/completions', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Authorization': `Bearer ${API_KEY}`
                    },
                    body: JSON.stringify(data)
                });
                
                const result = await response.json();
                
                res.writeHead(200, { 'Content-Type': 'application/json' });
                res.end(JSON.stringify(result));
                
            } catch (error) {
                res.writeHead(500, { 'Content-Type': 'application/json' });
                res.end(JSON.stringify({ error: error.message }));
            }
        });
    }
});

server.listen(PORT, () => {
    console.log(`
╔══════════════════════════════════════════════════════════════╗
║  🚀 SERVIDOR INICIADO                                        ║
╚══════════════════════════════════════════════════════════════╝

📍 URL: http://localhost:${PORT}

✅ Abre tu navegador en: http://localhost:${PORT}

⚡ El servidor está listo para recibir peticiones
🔑 API Key configurada
🤖 Proxy a OpenAI funcionando

Presiona Ctrl+C para detener el servidor
    `);
});
