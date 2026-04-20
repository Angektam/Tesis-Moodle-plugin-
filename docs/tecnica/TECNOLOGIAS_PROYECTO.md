# 💻 Lenguajes y Tecnologías del Proyecto

## Sistema de Evaluación de Tareas con IA + Detección de Plagio

Documentación completa de todas las tecnologías, lenguajes y herramientas utilizadas.

---

## 📊 Resumen Ejecutivo

### Stack Principal

```
Frontend:  HTML5 + CSS3 + JavaScript (Vanilla)
Backend:   PHP 7.4+ (Plugin Moodle) + Node.js 18+ (Demo)
Database:  MySQL/PostgreSQL (Moodle) + SQLite (Demo)
IA:        OpenAI GPT-4o-mini
Platform:  Moodle 3.9+
```

---

## 🎯 Lenguajes de Programación

### 1. PHP 7.4+ ⭐⭐⭐⭐⭐
**Uso**: Plugin principal de Moodle

**Archivos**:
- `moodle-plugin/classes/*.php` - Clases principales
- `moodle-plugin/lib.php` - Funciones del plugin
- `moodle-plugin/*.php` - Páginas y controladores

**Características utilizadas**:
- POO (Programación Orientada a Objetos)
- Namespaces
- Traits
- Type hinting
- Error handling con try-catch
- cURL para APIs externas

**Ejemplo**:
```php
class ai_evaluator {
    private $api_key;
    
    public function __construct() {
        $this->api_key = get_config('aiassignment', 'openai_api_key');
    }
    
    public function evaluate_submission(object $submission): array {
        // Lógica de evaluación
    }
}
```

**Versión mínima**: PHP 7.4
**Versión recomendada**: PHP 8.0+

---

### 2. JavaScript (ES6+) ⭐⭐⭐⭐⭐
**Uso**: Frontend interactivo y servidor Node.js

**Archivos**:
- `demo-standalone/*.js` - Servidor y servicios
- `moodle-plugin/amd/src/*.js` - Módulos AMD para Moodle
- `demo-standalone/services/*.js` - Servicios de APIs

**Características utilizadas**:
- Async/Await
- Promises
- Arrow functions
- Template literals
- Destructuring
- Modules (CommonJS y ES6)
- Fetch API
- Classes

**Ejemplo**:
```javascript
class Judge0Service {
    async executeCode(sourceCode, language, stdin = '') {
        const response = await fetch(this.apiUrl, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ source_code: sourceCode })
        });
        return await response.json();
    }
}
```

**Versión**: ES6+ (ECMAScript 2015+)
**Runtime**: Node.js 18+

---

### 3. HTML5 ⭐⭐⭐⭐
**Uso**: Estructura de páginas web

**Archivos**:
- `demo-standalone/*.html` - Páginas demo
- `moodle-plugin/*.php` - Templates con HTML

**Características utilizadas**:
- Semantic HTML
- Forms con validación
- Canvas (para gráficos)
- Local Storage
- Custom data attributes

**Ejemplo**:
```html
<form id="submission-form" method="post">
    <textarea name="code" required 
              placeholder="Escribe tu código aquí..."></textarea>
    <button type="submit">Enviar</button>
</form>
```

---

### 4. CSS3 ⭐⭐⭐⭐
**Uso**: Estilos y diseño responsive

**Archivos**:
- `moodle-plugin/styles/*.css` - Estilos del plugin
- `demo-standalone/*.css` - Estilos demo

**Características utilizadas**:
- Flexbox
- Grid Layout
- Media queries (responsive)
- CSS Variables
- Animations
- Transitions

**Ejemplo**:
```css
:root {
    --primary-color: #007bff;
    --success-color: #28a745;
}

.submission-card {
    display: flex;
    flex-direction: column;
    gap: 1rem;
    padding: 1.5rem;
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

@media (max-width: 768px) {
    .submission-card {
        padding: 1rem;
    }
}
```

---

### 5. SQL ⭐⭐⭐⭐
**Uso**: Base de datos

**Archivos**:
- `moodle-plugin/db/install.xml` - Esquema de BD

**Dialectos**:
- MySQL 5.7+
- PostgreSQL 10+
- SQLite 3 (demo)

**Ejemplo**:
```sql
CREATE TABLE mdl_aiassignment_submissions (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    assignment_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    code TEXT NOT NULL,
    language VARCHAR(50),
    score DECIMAL(5,2),
    feedback TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (assignment_id) REFERENCES mdl_aiassignment(id),
    FOREIGN KEY (user_id) REFERENCES mdl_user(id)
);
```

---

### 6. JSON ⭐⭐⭐⭐
**Uso**: Configuración y datos

**Archivos**:
- `package.json` - Configuración Node.js
- `entrenamiento-ia/ejemplos-entrenamiento.json` - Datos de entrenamiento
- APIs responses

**Ejemplo**:
```json
{
  "name": "sistema-evaluacion-tareas-ia",
  "version": "2.0.0",
  "dependencies": {
    "express": "^4.18.2",
    "node-fetch": "^2.7.0"
  }
}
```

---

### 7. Markdown ⭐⭐⭐
**Uso**: Documentación

**Archivos**:
- `docs/**/*.md` - Toda la documentación
- `README.md` - Documentación principal

---

### 8. XML ⭐⭐⭐
**Uso**: Configuración de Moodle

**Archivos**:
- `moodle-plugin/db/install.xml` - Esquema de BD
- `moodle-plugin/version.php` - Metadatos del plugin

---

## 🛠️ Frameworks y Librerías

### Backend

#### 1. Moodle API ⭐⭐⭐⭐⭐
**Versión**: 3.9+
**Uso**: Plataforma base del plugin

**APIs utilizadas**:
- Core API
- Database API (XMLDB)
- File API
- Events API
- Privacy API
- Backup/Restore API

**Ejemplo**:
```php
global $DB, $USER, $CFG;

// Insertar registro
$record = new stdClass();
$record->name = 'Mi tarea';
$record->timecreated = time();
$id = $DB->insert_record('aiassignment', $record);

// Obtener registros
$submissions = $DB->get_records('aiassignment_submissions', 
    ['assignment_id' => $id]);
```

---

#### 2. Express.js ⭐⭐⭐⭐
**Versión**: 4.18+
**Uso**: Servidor web Node.js (demo)

**Características**:
- Routing
- Middleware
- Static files
- CORS

**Ejemplo**:
```javascript
const express = require('express');
const app = express();

app.use(express.json());
app.use(express.static('public'));

app.post('/api/evaluate', async (req, res) => {
    const result = await evaluateCode(req.body.code);
    res.json(result);
});

app.listen(5000);
```

---

### Frontend

#### 1. Vanilla JavaScript ⭐⭐⭐⭐
**Uso**: Sin frameworks, JavaScript puro

**Ventajas**:
- Sin dependencias
- Más rápido
- Más ligero
- Compatible con Moodle

**Ejemplo**:
```javascript
document.getElementById('submit-btn').addEventListener('click', async () => {
    const code = document.getElementById('code-input').value;
    const response = await fetch('/api/evaluate', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ code })
    });
    const result = await response.json();
    displayResult(result);
});
```

---

#### 2. Bootstrap (Opcional) ⭐⭐⭐
**Versión**: 4.6+ (incluido en Moodle)
**Uso**: Estilos y componentes

**Componentes utilizados**:
- Grid system
- Cards
- Buttons
- Forms
- Alerts
- Modals

---

## 🤖 APIs e Inteligencia Artificial

### 1. OpenAI API ⭐⭐⭐⭐⭐
**Modelo**: GPT-4o-mini
**Uso**: Evaluación de código y detección de plagio

**Características**:
- Análisis de código
- Generación de feedback
- Detección de similitudes
- Evaluación semántica

**Ejemplo**:
```javascript
const response = await fetch('https://api.openai.com/v1/chat/completions', {
    method: 'POST',
    headers: {
        'Authorization': `Bearer ${OPENAI_API_KEY}`,
        'Content-Type': 'application/json'
    },
    body: JSON.stringify({
        model: 'gpt-4o-mini',
        messages: [
            { role: 'system', content: 'Eres un evaluador de código...' },
            { role: 'user', content: `Evalúa este código: ${code}` }
        ]
    })
});
```

---

### 2. Judge0 CE API ⭐⭐⭐⭐⭐
**Uso**: Ejecución de código en 60+ lenguajes

**Lenguajes soportados**:
- Python, JavaScript, Java, C++, C, C#
- PHP, Ruby, Go, Rust, Kotlin, Swift
- Y 50+ más

**Ejemplo**:
```javascript
const submission = await fetch('https://judge0-ce.p.rapidapi.com/submissions', {
    method: 'POST',
    headers: {
        'X-RapidAPI-Key': JUDGE0_API_KEY,
        'Content-Type': 'application/json'
    },
    body: JSON.stringify({
        source_code: Buffer.from(code).toString('base64'),
        language_id: 71, // Python
        stdin: Buffer.from('5').toString('base64')
    })
});
```

---

### 3. GitHub API ⭐⭐⭐⭐
**Uso**: Búsqueda de código y detección de plagio externo

**Endpoints utilizados**:
- `/search/code` - Buscar código
- `/repos/{owner}/{repo}/contents/{path}` - Obtener contenido
- `/rate_limit` - Verificar límites

---

### 4. VirusTotal API ⭐⭐⭐⭐
**Uso**: Escaneo de seguridad de archivos

**Características**:
- Escaneo de archivos
- Escaneo de URLs
- Reputación de dominios
- 70+ motores antivirus

---

## 🗄️ Bases de Datos

### 1. MySQL ⭐⭐⭐⭐⭐
**Versión**: 5.7+
**Uso**: Base de datos principal de Moodle

**Características utilizadas**:
- InnoDB engine
- Foreign keys
- Transactions
- Indexes
- Full-text search

---

### 2. PostgreSQL ⭐⭐⭐⭐
**Versión**: 10+
**Uso**: Alternativa a MySQL para Moodle

---

### 3. SQLite ⭐⭐⭐
**Versión**: 3+
**Uso**: Base de datos para demo standalone

**Ventajas**:
- Sin servidor
- Archivo único
- Fácil de distribuir

---

## 🔧 Herramientas de Desarrollo

### 1. Node.js ⭐⭐⭐⭐⭐
**Versión**: 18+
**Uso**: Runtime de JavaScript

**Paquetes principales**:
```json
{
  "express": "^4.18.2",
  "node-fetch": "^2.7.0",
  "dotenv": "^16.3.1",
  "cors": "^2.8.5"
}
```

---

### 2. npm ⭐⭐⭐⭐⭐
**Versión**: 8+
**Uso**: Gestor de paquetes

**Scripts**:
```json
{
  "start": "node demo-standalone/server.js",
  "demo": "node demo-standalone/server-demo.js",
  "dev": "nodemon demo-standalone/server.js"
}
```

---

### 3. Git ⭐⭐⭐⭐⭐
**Uso**: Control de versiones

**Archivos**:
- `.gitignore` - Archivos ignorados
- `.git/` - Repositorio

---

### 4. Composer (Opcional) ⭐⭐⭐
**Uso**: Gestor de dependencias PHP

---

## 🌐 Protocolos y Estándares

### 1. HTTP/HTTPS ⭐⭐⭐⭐⭐
**Uso**: Comunicación cliente-servidor

**Métodos utilizados**:
- GET - Obtener datos
- POST - Crear/enviar datos
- PUT - Actualizar datos
- DELETE - Eliminar datos

---

### 2. REST API ⭐⭐⭐⭐⭐
**Uso**: Arquitectura de APIs

**Características**:
- Stateless
- JSON responses
- HTTP status codes
- Resource-based URLs

---

### 3. JSON ⭐⭐⭐⭐⭐
**Uso**: Formato de intercambio de datos

---

### 4. OAuth 2.0 ⭐⭐⭐
**Uso**: Autenticación con APIs externas (GitHub)

---

## 📦 Formatos de Archivo

### Código
- `.php` - PHP
- `.js` - JavaScript
- `.html` - HTML
- `.css` - CSS
- `.json` - JSON
- `.xml` - XML

### Documentación
- `.md` - Markdown
- `.txt` - Texto plano

### Configuración
- `.env` - Variables de entorno
- `.gitignore` - Git ignore
- `package.json` - Node.js config

### Datos
- `.sql` - Scripts SQL
- `.db` - SQLite database
- `.json` - Datos JSON

---

## 🔐 Seguridad

### 1. Encriptación
- **bcrypt** - Hash de contraseñas
- **HTTPS** - Comunicación segura
- **JWT** - Tokens de autenticación

### 2. Validación
- **Input validation** - PHP y JavaScript
- **SQL injection prevention** - Prepared statements
- **XSS prevention** - Escape de output

### 3. Autenticación
- **Moodle Auth** - Sistema de Moodle
- **JWT** - Demo standalone
- **OAuth** - APIs externas

---

## 📊 Comparación de Tecnologías

### Plugin Moodle vs Demo Standalone

| Aspecto | Plugin Moodle | Demo Standalone |
|---------|---------------|-----------------|
| Lenguaje Backend | PHP 7.4+ | Node.js 18+ |
| Base de Datos | MySQL/PostgreSQL | SQLite |
| Frontend | HTML + JS (Vanilla) | HTML + JS (Vanilla) |
| Autenticación | Moodle Auth | JWT |
| Deployment | Moodle Server | Cualquier servidor |
| Complejidad | Media-Alta | Baja-Media |

---

## 🎯 Requisitos del Sistema

### Servidor

#### Para Plugin Moodle:
- **PHP**: 7.4+ (recomendado 8.0+)
- **MySQL**: 5.7+ o PostgreSQL 10+
- **Apache/Nginx**: 2.4+
- **Moodle**: 3.9+
- **RAM**: 2GB mínimo, 4GB recomendado
- **Disco**: 500MB para plugin

#### Para Demo Standalone:
- **Node.js**: 18+
- **npm**: 8+
- **RAM**: 512MB mínimo
- **Disco**: 100MB

### Cliente (Navegador)

- **Chrome**: 90+
- **Firefox**: 88+
- **Safari**: 14+
- **Edge**: 90+
- **JavaScript**: Habilitado
- **Cookies**: Habilitadas

---

## 📈 Estadísticas del Proyecto

### Líneas de Código

```
PHP:        ~3,500 líneas
JavaScript: ~2,500 líneas
HTML:       ~1,500 líneas
CSS:        ~1,000 líneas
SQL:        ~500 líneas
JSON:       ~500 líneas
Markdown:   ~5,000 líneas
─────────────────────────
Total:      ~14,500 líneas
```

### Archivos por Tipo

```
.php:  25 archivos
.js:   20 archivos
.html: 10 archivos
.css:  5 archivos
.md:   30 archivos
.json: 5 archivos
.sql:  3 archivos
```

---

## 🚀 Tecnologías Futuras (Roadmap)

### Fase 2
- **TypeScript** - Tipado estático para JavaScript
- **React** - Framework frontend moderno
- **Redis** - Caché de alto rendimiento

### Fase 3
- **Docker** - Containerización
- **Kubernetes** - Orquestación
- **GraphQL** - API más flexible

### Fase 4
- **WebSockets** - Comunicación en tiempo real
- **PWA** - Progressive Web App
- **TensorFlow.js** - ML en el navegador

---

## 📚 Recursos de Aprendizaje

### PHP
- [PHP Manual](https://www.php.net/manual/es/)
- [Moodle Developer Docs](https://moodledev.io/)

### JavaScript
- [MDN Web Docs](https://developer.mozilla.org/)
- [Node.js Docs](https://nodejs.org/docs/)

### APIs
- [OpenAI API Docs](https://platform.openai.com/docs)
- [Judge0 Docs](https://ce.judge0.com/)
- [GitHub API Docs](https://docs.github.com/en/rest)

---

## ✅ Checklist de Tecnologías

### Instaladas
- [x] PHP 7.4+
- [x] Node.js 18+
- [x] MySQL/PostgreSQL
- [x] Git
- [x] npm

### Configuradas
- [x] OpenAI API
- [x] Judge0 API
- [x] GitHub API
- [x] VirusTotal API

### Dominadas
- [x] PHP básico
- [x] JavaScript ES6+
- [x] HTML5/CSS3
- [x] SQL
- [x] REST APIs

---

## 🎓 Conclusión

El proyecto utiliza un stack tecnológico moderno y robusto:

- **Backend sólido**: PHP para Moodle, Node.js para demo
- **Frontend simple**: HTML/CSS/JS vanilla (sin frameworks pesados)
- **APIs potentes**: OpenAI, Judge0, GitHub, VirusTotal
- **Base de datos flexible**: MySQL, PostgreSQL o SQLite
- **Bien documentado**: 30+ archivos Markdown

**Stack ideal para**:
- Proyectos educativos
- Integración con Moodle
- Evaluación automática
- Detección de plagio

---

**Documento creado:** Marzo 6, 2026
**Versión:** 2.0.0
**Última actualización:** Fase 1 APIs implementada
