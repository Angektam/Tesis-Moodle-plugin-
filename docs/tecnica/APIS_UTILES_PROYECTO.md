# 🔌 APIs Útiles para el Proyecto

## Sistema de Evaluación de Tareas con IA + Detección de Plagio

Análisis de APIs públicas que pueden mejorar y extender las funcionalidades del proyecto.

---

## 🎯 APIs Altamente Recomendadas

### 1. Programming & Development

#### **Judge0 CE** ⭐⭐⭐⭐⭐
- **URL**: https://judge0.com/
- **Descripción**: Sistema de ejecución de código en línea
- **Autenticación**: API Key
- **HTTPS**: Sí
- **Uso en el proyecto**:
  - Ejecutar código de estudiantes automáticamente
  - Validar que el código funciona correctamente
  - Probar con casos de prueba
  - Soporta 60+ lenguajes de programación
- **Beneficio**: Pasar de evaluación estática a evaluación dinámica

```javascript
// Ejemplo de uso
const response = await fetch('https://api.judge0.com/submissions', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'X-RapidAPI-Key': 'tu-api-key'
  },
  body: JSON.stringify({
    source_code: codigo_estudiante,
    language_id: 71, // Python
    stdin: "5\n",
    expected_output: "120"
  })
});
```

---

#### **Hackerearth** ⭐⭐⭐⭐
- **URL**: https://www.hackerearth.com/docs/wiki/developers/v4/
- **Descripción**: Compilar y ejecutar código en varios lenguajes
- **Autenticación**: API Key
- **HTTPS**: Sí
- **Uso en el proyecto**:
  - Alternativa a Judge0
  - Compilación y ejecución de código
  - Detección de errores de compilación
- **Beneficio**: Backup para ejecución de código

---

#### **KONTESTS** ⭐⭐⭐
- **URL**: https://kontests.net/api
- **Descripción**: Información sobre competencias de programación
- **Autenticación**: No
- **HTTPS**: Sí
- **Uso en el proyecto**:
  - Mostrar competencias próximas a estudiantes
  - Motivar participación en competencias
  - Integrar calendario de eventos
- **Beneficio**: Gamificación y motivación

---

### 2. Education & Learning

#### **Kaggle** ⭐⭐⭐⭐
- **URL**: https://www.kaggle.com/docs/api
- **Descripción**: Datasets y notebooks de ciencia de datos
- **Autenticación**: API Key
- **HTTPS**: Sí
- **Uso en el proyecto**:
  - Importar datasets para problemas de programación
  - Ejemplos de código de la comunidad
  - Casos de uso reales
- **Beneficio**: Contenido educativo de calidad

---

#### **GitHub** ⭐⭐⭐⭐⭐
- **URL**: https://docs.github.com/en/rest
- **Descripción**: Acceso a repositorios, código y usuarios
- **Autenticación**: OAuth
- **HTTPS**: Sí
- **Uso en el proyecto**:
  - Detectar plagio comparando con repos públicos
  - Importar ejemplos de código
  - Integración con GitHub Classroom
  - Análisis de código similar en GitHub
- **Beneficio**: Detección de plagio externo

```javascript
// Buscar código similar en GitHub
const searchCode = async (query) => {
  const response = await fetch(
    `https://api.github.com/search/code?q=${encodeURIComponent(query)}`,
    {
      headers: {
        'Authorization': `token ${GITHUB_TOKEN}`,
        'Accept': 'application/vnd.github.v3+json'
      }
    }
  );
  return response.json();
};
```

---

### 3. Text Analysis & NLP

#### **Perspective** ⭐⭐⭐⭐
- **URL**: https://perspectiveapi.com/
- **Descripción**: Análisis de toxicidad y sentimiento en texto
- **Autenticación**: API Key
- **HTTPS**: Sí
- **Uso en el proyecto**:
  - Detectar comentarios inapropiados en código
  - Análisis de sentimiento en respuestas
  - Moderación de contenido
- **Beneficio**: Ambiente de aprendizaje seguro

---

#### **Cloudmersive NLP** ⭐⭐⭐
- **URL**: https://cloudmersive.com/nlp-api
- **Descripción**: Procesamiento de lenguaje natural
- **Autenticación**: API Key
- **HTTPS**: Sí
- **Uso en el proyecto**:
  - Análisis de similitud de texto
  - Detección de lenguaje
  - Extracción de entidades
- **Beneficio**: Mejorar detección de plagio

---

### 4. Data Validation

#### **Postman Echo** ⭐⭐⭐
- **URL**: https://www.postman.com/postman/workspace/published-postman-templates/documentation/631643-f695cab7-6878-eb55-7943-ad88e1ccfd65
- **Descripción**: Servidor de prueba para APIs
- **Autenticación**: No
- **HTTPS**: Sí
- **Uso en el proyecto**:
  - Probar integraciones
  - Validar requests/responses
  - Debugging de APIs
- **Beneficio**: Desarrollo y testing

---

### 5. Machine Learning

#### **Roboflow Universe** ⭐⭐⭐⭐
- **URL**: https://universe.roboflow.com/
- **Descripción**: Modelos de visión por computadora pre-entrenados
- **Autenticación**: API Key
- **HTTPS**: Sí
- **Uso en el proyecto**:
  - Detectar capturas de pantalla vs código escrito
  - Análisis de imágenes en envíos
  - Detección de trampas visuales
- **Beneficio**: Seguridad adicional

---

#### **Imagga** ⭐⭐⭐
- **URL**: https://imagga.com/
- **Descripción**: Reconocimiento de imágenes y tagging
- **Autenticación**: API Key
- **HTTPS**: Sí
- **Uso en el proyecto**:
  - Clasificación de imágenes en envíos
  - Detección de contenido inapropiado
  - Análisis de diagramas
- **Beneficio**: Soporte multimedia

---

### 6. Security & Anti-Malware

#### **VirusTotal** ⭐⭐⭐⭐
- **URL**: https://www.virustotal.com/gui/home/upload
- **Descripción**: Análisis de archivos y URLs
- **Autenticación**: API Key
- **HTTPS**: Sí
- **Uso en el proyecto**:
  - Escanear archivos subidos por estudiantes
  - Detectar código malicioso
  - Proteger el sistema
- **Beneficio**: Seguridad del sistema

---

### 7. Email & Notifications

#### **Sendgrid** ⭐⭐⭐⭐
- **URL**: https://sendgrid.com/docs/api-reference/
- **Descripción**: Servicio de envío de emails
- **Autenticación**: API Key
- **HTTPS**: Sí
- **Uso en el proyecto**:
  - Notificaciones de calificaciones
  - Alertas de plagio detectado
  - Recordatorios de tareas
- **Beneficio**: Comunicación automatizada

---

### 8. Cloud Storage

#### **Imgur** ⭐⭐⭐
- **URL**: https://apidocs.imgur.com/
- **Descripción**: Hosting de imágenes
- **Autenticación**: OAuth
- **HTTPS**: Sí
- **Uso en el proyecto**:
  - Almacenar capturas de pantalla
  - Diagramas y gráficos
  - Imágenes en problemas
- **Beneficio**: Storage gratuito

---

### 9. Analytics & Tracking

#### **Google Analytics** ⭐⭐⭐⭐
- **URL**: https://developers.google.com/analytics
- **Descripción**: Análisis de uso y comportamiento
- **Autenticación**: OAuth
- **HTTPS**: Sí
- **Uso en el proyecto**:
  - Métricas de uso del sistema
  - Comportamiento de estudiantes
  - Estadísticas de profesores
- **Beneficio**: Insights de uso

---

### 10. Testing & Mocking

#### **Mockaroo** ⭐⭐⭐⭐
- **URL**: https://www.mockaroo.com/
- **Descripción**: Generador de datos de prueba
- **Autenticación**: API Key
- **HTTPS**: Sí
- **Uso en el proyecto**:
  - Generar datos de prueba
  - Poblar base de datos de desarrollo
  - Testing automatizado
- **Beneficio**: Desarrollo más rápido

---

## 🎨 APIs para Mejorar UX

### 1. **Unsplash** ⭐⭐⭐
- **Descripción**: Imágenes de alta calidad gratuitas
- **Uso**: Ilustraciones para problemas, fondos, avatares
- **Beneficio**: Interfaz más atractiva

### 2. **Giphy** ⭐⭐⭐
- **Descripción**: GIFs animados
- **Uso**: Feedback visual, celebraciones, gamificación
- **Beneficio**: Experiencia más divertida

### 3. **EmojiHub** ⭐⭐
- **Descripción**: Emojis categorizados
- **Uso**: Reacciones, feedback visual
- **Beneficio**: Comunicación más expresiva

---

## 📊 APIs para Estadísticas

### 1. **Chart.js (no es API, pero útil)**
- **Descripción**: Librería de gráficos
- **Uso**: Visualizar estadísticas de estudiantes
- **Beneficio**: Dashboards atractivos

### 2. **Google Charts**
- **Descripción**: API de gráficos de Google
- **Uso**: Gráficos interactivos
- **Beneficio**: Visualización avanzada

---

## 🔐 APIs para Autenticación

### 1. **Auth0** ⭐⭐⭐⭐
- **URL**: https://auth0.com/docs/api
- **Descripción**: Plataforma de autenticación
- **Uso**: Login social, 2FA, SSO
- **Beneficio**: Autenticación robusta

### 2. **Google OAuth** ⭐⭐⭐⭐
- **Descripción**: Login con Google
- **Uso**: Autenticación simplificada
- **Beneficio**: Menos fricción para usuarios

---

## 🚀 Plan de Implementación

### Fase 1: Críticas (Inmediato)
1. **Judge0 CE** - Ejecución de código
2. **GitHub API** - Detección de plagio externo
3. **VirusTotal** - Seguridad

### Fase 2: Importantes (1-2 meses)
4. **Sendgrid** - Notificaciones
5. **Google Analytics** - Métricas
6. **Perspective** - Moderación

### Fase 3: Mejoras (3-6 meses)
7. **Roboflow** - Análisis de imágenes
8. **Kaggle** - Datasets educativos
9. **Auth0** - Autenticación avanzada

### Fase 4: Opcionales (6+ meses)
10. **Unsplash/Giphy** - UX mejorada
11. **KONTESTS** - Gamificación
12. **Cloudmersive NLP** - NLP avanzado

---

## 💰 Consideraciones de Costos

### APIs Gratuitas (Sin límites o límites altos)
- GitHub API: 5,000 requests/hora
- Unsplash: 50 requests/hora
- Giphy: Sin límite
- Postman Echo: Sin límite
- KONTESTS: Sin límite

### APIs con Tier Gratuito Generoso
- Judge0: 50 requests/día (gratis)
- Sendgrid: 100 emails/día (gratis)
- VirusTotal: 4 requests/minuto (gratis)
- Imgur: 12,500 requests/día (gratis)
- Mockaroo: 200 requests/día (gratis)

### APIs de Pago (Considerar presupuesto)
- Auth0: $23/mes (después de tier gratuito)
- Google Analytics: Gratis (versión estándar)
- Roboflow: $0.0001/imagen
- Perspective: $1/1000 requests

---

## 📝 Ejemplo de Integración: Judge0

### 1. Configurar API Key

```javascript
// .env
JUDGE0_API_KEY=tu-api-key-aqui
JUDGE0_API_URL=https://judge0-ce.p.rapidapi.com
```

### 2. Crear Servicio

```javascript
// services/code_executor.js
class CodeExecutor {
  async executeCode(sourceCode, languageId, testCases) {
    // Crear submission
    const submission = await this.createSubmission(
      sourceCode,
      languageId,
      testCases[0].input
    );
    
    // Esperar resultado
    const result = await this.getSubmissionResult(submission.token);
    
    // Validar output
    return this.validateOutput(result, testCases[0].expected);
  }
  
  async createSubmission(code, langId, stdin) {
    const response = await fetch(`${JUDGE0_API_URL}/submissions`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-RapidAPI-Key': JUDGE0_API_KEY
      },
      body: JSON.stringify({
        source_code: Buffer.from(code).toString('base64'),
        language_id: langId,
        stdin: Buffer.from(stdin).toString('base64')
      })
    });
    
    return response.json();
  }
}
```

### 3. Integrar en Evaluador

```javascript
// classes/ai_evaluator.php
public function evaluate_with_execution($submission) {
    // Evaluación estática con IA (actual)
    $ai_evaluation = $this->evaluate_with_ai($submission);
    
    // Evaluación dinámica con Judge0 (nuevo)
    $execution_result = $this->execute_code($submission);
    
    // Combinar resultados
    return [
        'ai_score' => $ai_evaluation['score'],
        'execution_score' => $execution_result['score'],
        'final_score' => ($ai_evaluation['score'] + $execution_result['score']) / 2,
        'feedback' => $this->combine_feedback($ai_evaluation, $execution_result)
    ];
}
```

---

## 🎯 Beneficios de Integrar APIs

### 1. Evaluación Más Completa
- Análisis estático (IA actual)
- Análisis dinámico (ejecución de código)
- Detección de plagio externo (GitHub)

### 2. Mejor Experiencia de Usuario
- Notificaciones automáticas
- Interfaz más atractiva
- Feedback más rico

### 3. Mayor Seguridad
- Escaneo de archivos
- Moderación de contenido
- Autenticación robusta

### 4. Escalabilidad
- Servicios en la nube
- APIs optimizadas
- Infraestructura profesional

---

## 📚 Recursos Adicionales

### Documentación
- [Judge0 Docs](https://ce.judge0.com/)
- [GitHub API Docs](https://docs.github.com/en/rest)
- [Sendgrid Docs](https://docs.sendgrid.com/)

### Tutoriales
- [Integrating Judge0 with Node.js](https://dev.to/judge0/integrating-judge0-with-nodejs)
- [GitHub API Best Practices](https://docs.github.com/en/rest/guides/best-practices-for-integrators)

### Comunidad
- [Judge0 Discord](https://discord.gg/judge0)
- [GitHub Discussions](https://github.com/orgs/community/discussions)

---

## ✅ Checklist de Implementación

### Antes de Integrar una API
- [ ] Leer documentación completa
- [ ] Verificar límites de rate
- [ ] Revisar costos
- [ ] Probar en entorno de desarrollo
- [ ] Implementar manejo de errores
- [ ] Configurar variables de entorno
- [ ] Documentar integración

### Durante la Integración
- [ ] Crear servicio/clase dedicada
- [ ] Implementar caché si es necesario
- [ ] Agregar logs
- [ ] Escribir tests
- [ ] Actualizar documentación

### Después de Integrar
- [ ] Monitorear uso
- [ ] Revisar costos reales
- [ ] Optimizar requests
- [ ] Recopilar feedback de usuarios

---

## 🎓 Conclusión

Las APIs públicas pueden transformar el proyecto de un sistema básico de evaluación a una plataforma completa de aprendizaje con:

- ✅ Ejecución real de código
- ✅ Detección de plagio externo
- ✅ Notificaciones automáticas
- ✅ Análisis avanzado
- ✅ Mejor UX
- ✅ Mayor seguridad

**Recomendación**: Empezar con Judge0 y GitHub API, que son las más impactantes para el proyecto.

---

**Documento creado:** Marzo 6, 2026
**Fuente:** [public-apis/public-apis](https://github.com/public-apis/public-apis)
**Licencia:** MIT
