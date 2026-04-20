// Configuración
const API_URL = 'http://localhost:3000/api';

// Almacenamiento local
let problems = JSON.parse(localStorage.getItem('problems')) || [];
let submissions = JSON.parse(localStorage.getItem('submissions')) || [];

// Inicialización
document.addEventListener('DOMContentLoaded', () => {
    loadProblems();
    loadSubmissions();
    
    document.getElementById('createProblemForm').addEventListener('submit', createProblem);
});

// Funciones de navegación
function showTab(tabName) {
    document.querySelectorAll('.content').forEach(c => c.classList.remove('active'));
    document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
    
    document.getElementById(tabName).classList.add('active');
    event.target.classList.add('active');
    
    if (tabName === 'student') loadProblems();
    if (tabName === 'results') loadSubmissions();
}

// Crear problema
function createProblem(e) {
    e.preventDefault();
    
    const problem = {
        id: Date.now(),
        name: document.getElementById('problemName').value,
        description: document.getElementById('problemDescription').value,
        type: 'programming', // Siempre programación
        solution: document.getElementById('problemSolution').value,
        createdAt: new Date().toISOString()
    };
    
    problems.push(problem);
    localStorage.setItem('problems', JSON.stringify(problems));
    
    showNotification('✅ Tarea de programación creada exitosamente', 'success');
    e.target.reset();
    loadProblems();
}


// Cargar problemas
function loadProblems() {
    const container = document.getElementById('problemsList');
    
    if (problems.length === 0) {
        container.innerHTML = '<div class="alert alert-info"><i class="fas fa-info-circle"></i> No hay tareas de programación disponibles</div>';
        return;
    }
    
    container.innerHTML = problems.map(p => `
        <div class="card">
            <h3><i class="fas fa-code"></i> ${p.name}</h3>
            <span class="badge badge-programming">Programación</span>
            <p style="margin: 10px 0;">${p.description || 'Sin descripción'}</p>
            <button class="btn btn-primary" onclick="openSubmitModal(${p.id})">
                <i class="fas fa-paper-plane"></i> Enviar Solución
            </button>
        </div>
    `).join('');
}

// Abrir modal de envío
function openSubmitModal(problemId) {
    const problem = problems.find(p => p.id === problemId);
    
    document.getElementById('modalBody').innerHTML = `
        <h2><i class="fas fa-code"></i> ${problem.name}</h2>
        <p><strong>Tipo:</strong> Programación</p>
        <p>${problem.description || ''}</p>
        
        <div class="form-group" style="margin-top: 20px;">
            <label>Tu código:</label>
            <textarea id="studentAnswer" rows="12" style="font-family: 'Courier New', monospace;" placeholder="Escribe tu código aquí..."></textarea>
        </div>
        
        <button class="btn btn-success" onclick="submitAnswer(${problemId})">
            <i class="fas fa-check"></i> Enviar Código
        </button>
    `;
    
    document.getElementById('modal').style.display = 'block';
}

// Cerrar modal
function closeModal() {
    document.getElementById('modal').style.display = 'none';
}

// Enviar respuesta
async function submitAnswer(problemId) {
    const answer = document.getElementById('studentAnswer').value;
    
    if (!answer.trim()) {
        showNotification('⚠️ Por favor escribe tu código', 'warning');
        return;
    }
    
    closeModal();
    showNotification('🤖 Evaluando tu código con IA...', 'info');
    
    const problem = problems.find(p => p.id === problemId);
    
    try {
        const evaluation = await evaluateWithAI(answer, problem.solution);
        
        const submission = {
            id: Date.now(),
            problemId: problemId,
            problemName: problem.name,
            answer: answer,
            evaluation: evaluation,
            submittedAt: new Date().toISOString()
        };
        
        submissions.push(submission);
        localStorage.setItem('submissions', JSON.stringify(submissions));
        
        showNotification('✅ Evaluación completada!', 'success');
        
        // Ejecutar detección de plagio automáticamente
        setTimeout(() => {
            checkPlagiarismForSubmission(submission);
        }, 1000);
        
        // Cambiar a pestaña de resultados
        setTimeout(() => {
            document.querySelectorAll('.tab')[2].click();
        }, 1500);
        
    } catch (error) {
        showNotification('❌ Error al evaluar: ' + error.message, 'danger');
    }
}

// Verificar plagio para un envío específico
async function checkPlagiarismForSubmission(newSubmission) {
    // Buscar otros envíos del mismo problema
    const sameProblems = submissions.filter(s => 
        s.problemId === newSubmission.problemId && 
        s.id !== newSubmission.id
    );
    
    if (sameProblems.length === 0) {
        console.log('No hay otros envíos para comparar');
        return;
    }
    
    console.log(`🔍 Verificando plagio automáticamente con ${sameProblems.length} envíos...`);
    
    let highSimilarityFound = false;
    
    for (const otherSubmission of sameProblems) {
        try {
            const similarity = await compareSimilarity(
                newSubmission.answer,
                otherSubmission.answer
            );
            
            // Si se detecta alta similitud, mostrar alerta
            if (similarity >= 70) {
                highSimilarityFound = true;
                showNotification(
                    `⚠️ Alerta: Se detectó ${similarity}% de similitud con otro envío`,
                    'warning'
                );
                break;
            }
        } catch (error) {
            console.error('Error al comparar:', error);
        }
    }
    
    if (!highSimilarityFound && sameProblems.length > 0) {
        console.log('✅ No se detectó plagio');
    }
}


// Evaluar con IA (solo programación)
async function evaluateWithAI(studentAnswer, teacherSolution) {
    const response = await fetch(`${API_URL}/evaluate`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            studentAnswer,
            teacherSolution
        })
    });
    
    if (!response.ok) {
        const error = await response.json();
        throw new Error(error.error || 'Error al evaluar el código');
    }
    
    return await response.json();
}


// Cargar envíos
function loadSubmissions() {
    const container = document.getElementById('submissionsList');
    
    if (submissions.length === 0) {
        container.innerHTML = '<div class="alert alert-info"><i class="fas fa-info-circle"></i> No tienes envíos de código aún</div>';
        return;
    }
    
    container.innerHTML = submissions.slice().reverse().map(s => {
        const gradeClass = s.evaluation.score >= 70 ? 'success' : 'warning';
        
        // Verificar si hay plagio detectado
        let plagiarismAlert = '';
        const sameProblems = submissions.filter(sub => 
            sub.problemId === s.problemId && 
            sub.id !== s.id
        );
        
        if (sameProblems.length > 0) {
            plagiarismAlert = `
                <div style="margin-top: 10px; padding: 10px; background: #e7f3ff; border-left: 4px solid #0f6cbf; border-radius: 4px;">
                    <small><i class="fas fa-shield-alt"></i> <strong>Detección de Plagio:</strong> Verificado automáticamente con ${sameProblems.length} envío(s) similar(es)</small>
                </div>
            `;
        }
        
        return `
            <div class="card">
                <div style="display: flex; justify-content: space-between; align-items: center;">
                    <div>
                        <h3><i class="fas fa-code"></i> ${s.problemName}</h3>
                        <p style="color: #666; font-size: 14px;">
                            <i class="fas fa-clock"></i> ${new Date(s.submittedAt).toLocaleString('es-ES')}
                        </p>
                    </div>
                    <div class="grade">${Math.round(s.evaluation.score)}%</div>
                </div>
                
                <div class="progress-bar">
                    <div class="progress-fill" style="width: ${s.evaluation.score}%"></div>
                </div>
                
                ${plagiarismAlert}
                
                <div class="alert alert-${gradeClass}" style="margin-top: 15px;">
                    <strong><i class="fas fa-comment"></i> Feedback:</strong><br>
                    ${s.evaluation.feedback}
                </div>
                
                <details style="margin-top: 15px;">
                    <summary style="cursor: pointer; font-weight: 600; color: #0f6cbf;">
                        <i class="fas fa-chevron-down"></i> Ver análisis detallado
                    </summary>
                    <div style="margin-top: 15px; padding: 15px; background: #f8f9fa; border-radius: 6px;">
                        ${s.evaluation.analysis}
                    </div>
                </details>
                
                <details style="margin-top: 10px;">
                    <summary style="cursor: pointer; font-weight: 600; color: #666;">
                        <i class="fas fa-code"></i> Ver tu código
                    </summary>
                    <pre style="margin-top: 10px;">${s.answer}</pre>
                </details>
            </div>
        `;
    }).join('');
}


// Análisis de plagio
async function analyzePlagiarism() {
    const container = document.getElementById('plagiarismResults');
    
    if (submissions.length < 2) {
        container.innerHTML = '<div class="alert alert-warning"><i class="fas fa-exclamation-triangle"></i> Se necesitan al menos 2 envíos de código para analizar plagio</div>';
        return;
    }
    
    container.innerHTML = '<div class="loading"><div class="spinner"></div><p>Analizando similitudes de código con IA...</p></div>';
    
    try {
        const pairs = [];
        
        // Comparar todos los pares de envíos del mismo problema
        for (let i = 0; i < submissions.length; i++) {
            for (let j = i + 1; j < submissions.length; j++) {
                if (submissions[i].problemId === submissions[j].problemId) {
                    const similarity = await compareSimilarity(
                        submissions[i].answer,
                        submissions[j].answer
                    );
                    
                    pairs.push({
                        submission1: submissions[i],
                        submission2: submissions[j],
                        similarity: similarity
                    });
                }
            }
        }
        
        // Ordenar por similitud
        pairs.sort((a, b) => b.similarity - a.similarity);
        
        displayPlagiarismResults(pairs);
        
    } catch (error) {
        container.innerHTML = `<div class="alert alert-danger"><i class="fas fa-times-circle"></i> Error: ${error.message}</div>`;
    }
}

// Comparar similitud entre dos códigos
async function compareSimilarity(answer1, answer2) {
    const response = await fetch(`${API_URL}/compare`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            answer1,
            answer2
        })
    });
    
    if (!response.ok) {
        const error = await response.json();
        throw new Error(error.error || 'Error al comparar similitud');
    }
    
    const data = await response.json();
    return data.similarity;
}


// Mostrar resultados de plagio
function displayPlagiarismResults(pairs) {
    const container = document.getElementById('plagiarismResults');
    
    if (pairs.length === 0) {
        container.innerHTML = '<div class="alert alert-success"><i class="fas fa-check-circle"></i> No se encontraron pares de código para comparar</div>';
        return;
    }
    
    const highSimilarity = pairs.filter(p => p.similarity >= 70).length;
    const mediumSimilarity = pairs.filter(p => p.similarity >= 40 && p.similarity < 70).length;
    const lowSimilarity = pairs.filter(p => p.similarity < 40).length;
    
    let html = `
        <div class="alert alert-info" style="margin-top: 20px;">
            <strong><i class="fas fa-check-circle"></i> Análisis de plagio completado:</strong> 
            ${pairs.length} pares de código analizados
        </div>
        
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px; margin: 20px 0;">
            <div style="text-align: center; padding: 20px; background: #f8d7da; border-radius: 8px;">
                <div style="font-size: 32px; font-weight: bold; color: #721c24;">${highSimilarity}</div>
                <div style="color: #721c24;"><i class="fas fa-exclamation-triangle"></i> Alta (70-100%)</div>
            </div>
            <div style="text-align: center; padding: 20px; background: #fff3cd; border-radius: 8px;">
                <div style="font-size: 32px; font-weight: bold; color: #856404;">${mediumSimilarity}</div>
                <div style="color: #856404;"><i class="fas fa-exclamation-circle"></i> Media (40-69%)</div>
            </div>
            <div style="text-align: center; padding: 20px; background: #d4edda; border-radius: 8px;">
                <div style="font-size: 32px; font-weight: bold; color: #155724;">${lowSimilarity}</div>
                <div style="color: #155724;"><i class="fas fa-check"></i> Baja (0-39%)</div>
            </div>
        </div>
    `;
    
    pairs.forEach(pair => {
        const color = pair.similarity >= 70 ? '#dc3545' : pair.similarity >= 40 ? '#ffc107' : '#28a745';
        const level = pair.similarity >= 70 ? 'Alta' : pair.similarity >= 40 ? 'Media' : 'Baja';
        const icon = pair.similarity >= 70 ? 'fa-exclamation-circle' : pair.similarity >= 40 ? 'fa-exclamation-triangle' : 'fa-check-circle';
        
        html += `
            <div class="card" style="border-left: 4px solid ${color};">
                <h4 style="color: ${color};">
                    <i class="fas ${icon}"></i> Similitud ${level}: ${pair.similarity}%
                </h4>
                <p style="color: #666; margin: 10px 0;">
                    <i class="fas fa-code"></i> Tarea: ${pair.submission1.problemName}
                </p>
                
                <div class="progress-bar">
                    <div class="progress-fill" style="width: ${pair.similarity}%; background: ${color};"></div>
                </div>
                
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-top: 20px;">
                    <div>
                        <p style="font-weight: 600;"><i class="fas fa-user"></i> Código 1</p>
                        <pre style="font-size: 12px; max-height: 200px; overflow-y: auto;">${pair.submission1.answer}</pre>
                    </div>
                    <div>
                        <p style="font-weight: 600;"><i class="fas fa-user"></i> Código 2</p>
                        <pre style="font-size: 12px; max-height: 200px; overflow-y: auto;">${pair.submission2.answer}</pre>
                    </div>
                </div>
                
                ${pair.similarity >= 70 ? `
                <div class="alert alert-danger" style="margin-top: 15px;">
                    <strong><i class="fas fa-flag"></i> Alerta de Plagio:</strong> Alta similitud detectada. Se recomienda revisión manual.
                </div>
                ` : ''}
            </div>
        `;
    });
    
    container.innerHTML = html;
}

// Notificaciones
function showNotification(message, type) {
    const notification = document.getElementById('notification');
    notification.innerHTML = `<i class="fas fa-${type === 'success' ? 'check-circle' : type === 'danger' ? 'times-circle' : type === 'warning' ? 'exclamation-triangle' : 'info-circle'}"></i> ${message}`;
    notification.className = `notification alert alert-${type}`;
    notification.style.display = 'block';
    
    setTimeout(() => {
        notification.style.display = 'none';
    }, 3000);
}

// Cerrar modal al hacer clic fuera
window.onclick = function(event) {
    const modal = document.getElementById('modal');
    if (event.target === modal) {
        closeModal();
    }
}


// ============================================
// SISTEMA DE ENTRENAMIENTO DE IA
// ============================================

// Inicializar datos de entrenamiento
function initTrainingData() {
    if (!localStorage.getItem('trainingExamples')) {
        localStorage.setItem('trainingExamples', JSON.stringify([]));
    }
    updateTrainingStats();
    loadTrainingExamples();
}

// Actualizar estadísticas
function updateTrainingStats() {
    const examples = JSON.parse(localStorage.getItem('trainingExamples') || '[]');
    const goodCount = examples.filter(e => e.type === 'good').length;
    const badCount = examples.filter(e => e.type === 'bad').length;
    
    document.getElementById('trainingCount').textContent = examples.length;
    document.getElementById('goodExamplesCount').textContent = goodCount;
    document.getElementById('badExamplesCount').textContent = badCount;
}

// Agregar ejemplo de entrenamiento
document.getElementById('trainingForm')?.addEventListener('submit', function(e) {
    e.preventDefault();
    
    const example = {
        id: Date.now(),
        type: document.getElementById('exampleType').value,
        category: document.getElementById('exampleCategory').value,
        title: document.getElementById('exampleTitle').value,
        code: document.getElementById('exampleCode').value,
        notes: document.getElementById('exampleNotes').value,
        score: document.getElementById('exampleScore').value || null,
        createdAt: new Date().toISOString()
    };
    
    const examples = JSON.parse(localStorage.getItem('trainingExamples') || '[]');
    examples.push(example);
    localStorage.setItem('trainingExamples', JSON.stringify(examples));
    
    showNotification('✅ Ejemplo agregado exitosamente', 'success');
    this.reset();
    updateTrainingStats();
    loadTrainingExamples();
});

// Cargar ejemplos de entrenamiento
function loadTrainingExamples(filter = 'all') {
    const examples = JSON.parse(localStorage.getItem('trainingExamples') || '[]');
    const filtered = filter === 'all' ? examples : examples.filter(e => e.type === filter);
    
    const container = document.getElementById('trainingExamplesList');
    if (!container) return;
    
    if (filtered.length === 0) {
        container.innerHTML = `
            <div class="empty-state">
                <i class="fas fa-inbox"></i>
                <p>No hay ejemplos de entrenamiento${filter !== 'all' ? ' de este tipo' : ''}</p>
            </div>
        `;
        return;
    }
    
    container.innerHTML = filtered.map(example => {
        const typeLabels = {
            good: { text: 'Código Bueno', class: 'badge-good', icon: 'check-circle' },
            bad: { text: 'Código Malo', class: 'badge-bad', icon: 'times-circle' },
            pattern: { text: 'Patrón Plagio', class: 'badge-pattern', icon: 'search' }
        };
        
        const typeInfo = typeLabels[example.type] || typeLabels.good;
        
        return `
            <div class="training-example ${example.type}">
                <div class="training-example-header">
                    <div class="training-example-title">
                        <i class="fas fa-${typeInfo.icon}"></i> ${example.title}
                    </div>
                    <span class="training-example-badge ${typeInfo.class}">
                        ${typeInfo.text}
                    </span>
                </div>
                
                <div class="training-example-meta">
                    <span><i class="fas fa-tag"></i> ${example.category}</span>
                    <span><i class="fas fa-calendar"></i> ${new Date(example.createdAt).toLocaleDateString()}</span>
                    ${example.score ? `<span><i class="fas fa-star"></i> Score: ${example.score}/100</span>` : ''}
                </div>
                
                <div class="training-example-code">${escapeHtml(example.code)}</div>
                
                ${example.notes ? `
                    <div class="training-example-notes">
                        <strong><i class="fas fa-sticky-note"></i> Notas:</strong> ${escapeHtml(example.notes)}
                    </div>
                ` : ''}
                
                <div class="training-example-actions">
                    <button class="btn btn-sm btn-secondary" onclick="useAsReference(${example.id})">
                        <i class="fas fa-copy"></i> Usar como Referencia
                    </button>
                    <button class="btn btn-sm btn-danger" onclick="deleteTrainingExample(${example.id})">
                        <i class="fas fa-trash"></i> Eliminar
                    </button>
                </div>
            </div>
        `;
    }).join('');
}

// Filtrar ejemplos
function filterTrainingExamples(type) {
    loadTrainingExamples(type);
}

// Usar ejemplo como referencia
function useAsReference(exampleId) {
    const examples = JSON.parse(localStorage.getItem('trainingExamples') || '[]');
    const example = examples.find(e => e.id === exampleId);
    
    if (example) {
        // Copiar al portapapeles
        navigator.clipboard.writeText(example.code).then(() => {
            showNotification('📋 Código copiado al portapapeles', 'success');
        });
    }
}

// Eliminar ejemplo
function deleteTrainingExample(exampleId) {
    if (!confirm('¿Estás seguro de eliminar este ejemplo?')) return;
    
    const examples = JSON.parse(localStorage.getItem('trainingExamples') || '[]');
    const filtered = examples.filter(e => e.id !== exampleId);
    localStorage.setItem('trainingExamples', JSON.stringify(filtered));
    
    showNotification('🗑️ Ejemplo eliminado', 'info');
    updateTrainingStats();
    loadTrainingExamples();
}

// Exportar datos de entrenamiento
function exportTrainingData() {
    const examples = JSON.parse(localStorage.getItem('trainingExamples') || '[]');
    
    if (examples.length === 0) {
        showNotification('⚠️ No hay datos para exportar', 'warning');
        return;
    }
    
    const dataStr = JSON.stringify(examples, null, 2);
    const dataBlob = new Blob([dataStr], { type: 'application/json' });
    const url = URL.createObjectURL(dataBlob);
    
    const link = document.createElement('a');
    link.href = url;
    link.download = `training-data-${Date.now()}.json`;
    link.click();
    
    showNotification('💾 Datos exportados exitosamente', 'success');
}

// Importar datos de entrenamiento
function importTrainingData() {
    const input = document.createElement('input');
    input.type = 'file';
    input.accept = '.json';
    
    input.onchange = (e) => {
        const file = e.target.files[0];
        const reader = new FileReader();
        
        reader.onload = (event) => {
            try {
                const imported = JSON.parse(event.target.result);
                
                if (!Array.isArray(imported)) {
                    throw new Error('Formato inválido');
                }
                
                const current = JSON.parse(localStorage.getItem('trainingExamples') || '[]');
                const merged = [...current, ...imported];
                localStorage.setItem('trainingExamples', JSON.stringify(merged));
                
                showNotification(`✅ ${imported.length} ejemplos importados`, 'success');
                updateTrainingStats();
                loadTrainingExamples();
            } catch (error) {
                showNotification('❌ Error al importar: archivo inválido', 'error');
            }
        };
        
        reader.readAsText(file);
    };
    
    input.click();
}

// Limpiar todos los datos
function clearTrainingData() {
    if (!confirm('⚠️ ¿Estás seguro? Esto eliminará TODOS los ejemplos de entrenamiento.')) return;
    
    localStorage.setItem('trainingExamples', JSON.stringify([]));
    showNotification('🗑️ Todos los datos eliminados', 'info');
    updateTrainingStats();
    loadTrainingExamples();
}

// Función auxiliar para escapar HTML
function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

// Mejorar evaluación con ejemplos de entrenamiento
async function evaluateWithTraining(studentAnswer, teacherSolution) {
    const examples = JSON.parse(localStorage.getItem('trainingExamples') || '[]');
    
    // Buscar ejemplos similares en la base de conocimiento
    const relevantExamples = examples.filter(ex => {
        const similarity = calculateCodeSimilarity(studentAnswer, ex.code);
        return similarity > 0.3; // 30% de similitud
    });
    
    // Si hay ejemplos relevantes, usarlos para mejorar la evaluación
    if (relevantExamples.length > 0) {
        const goodExamples = relevantExamples.filter(e => e.type === 'good');
        const badExamples = relevantExamples.filter(e => e.type === 'bad');
        
        let localScore = 50; // Score base
        
        // Ajustar score basado en similitud con ejemplos buenos/malos
        if (goodExamples.length > 0) {
            localScore += 20;
        }
        if (badExamples.length > 0) {
            localScore -= 20;
        }
        
        // Retornar evaluación local si no queremos gastar API
        return {
            score: Math.max(0, Math.min(100, localScore)),
            feedback: `Evaluación basada en ${relevantExamples.length} ejemplos de entrenamiento`,
            analysis: `Se encontraron ${goodExamples.length} patrones buenos y ${badExamples.length} patrones malos en tu código.`,
            usedTraining: true
        };
    }
    
    // Si no hay ejemplos relevantes, usar API normal
    return evaluateWithAI(studentAnswer, teacherSolution);
}

// Calcular similitud simple entre códigos
function calculateCodeSimilarity(code1, code2) {
    const normalize = (str) => str.toLowerCase().replace(/\s+/g, '').replace(/[^a-z0-9]/g, '');
    const n1 = normalize(code1);
    const n2 = normalize(code2);
    
    let matches = 0;
    const minLen = Math.min(n1.length, n2.length);
    
    for (let i = 0; i < minLen; i++) {
        if (n1[i] === n2[i]) matches++;
    }
    
    return matches / Math.max(n1.length, n2.length);
}

// Inicializar al cargar la página
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initTrainingData);
} else {
    initTrainingData();
}


// ============================================
// IMPORTAR ARCHIVOS DE CÓDIGO DIRECTAMENTE
// ============================================

// Importar archivos de código (.py, .js, .java, .cpp, etc.)
function importCodeFiles() {
    const input = document.createElement('input');
    input.type = 'file';
    input.multiple = true; // Permitir múltiples archivos
    input.accept = '.py,.js,.java,.cpp,.c,.cs,.php,.rb,.go,.rs,.ts,.jsx,.tsx,.kt,.swift'; // Extensiones permitidas
    
    input.onchange = async (e) => {
        const files = Array.from(e.target.files);
        
        if (files.length === 0) {
            showNotification('⚠️ No se seleccionaron archivos', 'warning');
            return;
        }
        
        let importados = 0;
        let errores = 0;
        
        for (const file of files) {
            try {
                const codigo = await leerArchivo(file);
                const ejemplo = procesarArchivoACodigo(file, codigo);
                
                // Agregar a la base de datos
                const examples = JSON.parse(localStorage.getItem('trainingExamples') || '[]');
                examples.push(ejemplo);
                localStorage.setItem('trainingExamples', JSON.stringify(examples));
                
                importados++;
            } catch (error) {
                console.error(`Error al importar ${file.name}:`, error);
                errores++;
            }
        }
        
        // Mostrar resultado
        if (importados > 0) {
            showNotification(`✅ ${importados} archivo(s) importado(s) exitosamente`, 'success');
            updateTrainingStats();
            loadTrainingExamples();
        }
        
        if (errores > 0) {
            showNotification(`⚠️ ${errores} archivo(s) con errores`, 'warning');
        }
    };
    
    input.click();
}

// Leer contenido de un archivo
function leerArchivo(file) {
    return new Promise((resolve, reject) => {
        const reader = new FileReader();
        
        reader.onload = (event) => {
            resolve(event.target.result);
        };
        
        reader.onerror = (error) => {
            reject(error);
        };
        
        reader.readAsText(file);
    });
}

// Procesar archivo y convertir a formato de ejemplo
function procesarArchivoACodigo(file, codigo) {
    const nombre = file.name;
    const extension = nombre.split('.').pop().toLowerCase();
    
    // Detectar tipo basado en el nombre del archivo
    let tipo = 'good'; // Por defecto
    if (nombre.toLowerCase().includes('malo') || nombre.toLowerCase().includes('bad') || nombre.toLowerCase().includes('error')) {
        tipo = 'bad';
    } else if (nombre.toLowerCase().includes('patron') || nombre.toLowerCase().includes('pattern') || nombre.toLowerCase().includes('plagio')) {
        tipo = 'pattern';
    }
    
    // Detectar categoría basada en la extensión
    const categorias = {
        'py': 'python',
        'js': 'javascript',
        'jsx': 'javascript',
        'ts': 'javascript',
        'tsx': 'javascript',
        'java': 'java',
        'cpp': 'cpp',
        'c': 'cpp',
        'cs': 'cpp',
        'php': 'other',
        'rb': 'other',
        'go': 'other',
        'rs': 'other',
        'kt': 'other',
        'swift': 'other'
    };
    
    const categoria = categorias[extension] || 'other';
    
    // Extraer título del nombre del archivo
    let titulo = nombre.replace(/\.[^/.]+$/, ''); // Quitar extensión
    titulo = titulo.replace(/_/g, ' '); // Reemplazar guiones bajos
    titulo = titulo.replace(/\d+_/g, ''); // Quitar números al inicio
    titulo = titulo.charAt(0).toUpperCase() + titulo.slice(1); // Capitalizar
    
    // Extraer notas de los comentarios del código
    const notas = extraerNotasDeComentarios(codigo, extension);
    
    // Extraer calificación si está en los comentarios
    const score = extraerCalificacion(codigo);
    
    return {
        id: Date.now() + Math.random(), // ID único
        type: tipo,
        category: categoria,
        title: titulo,
        code: codigo,
        notes: notas || `Importado desde ${nombre}`,
        score: score,
        createdAt: new Date().toISOString()
    };
}

// Extraer notas de los comentarios del código
function extraerNotasDeComentarios(codigo, extension) {
    const lineas = codigo.split('\n');
    let notas = [];
    
    // Patrones de comentarios según el lenguaje
    const patronesComentario = {
        'py': /^#\s*(.+)$/,
        'js': /^\/\/\s*(.+)$/,
        'jsx': /^\/\/\s*(.+)$/,
        'ts': /^\/\/\s*(.+)$/,
        'tsx': /^\/\/\s*(.+)$/,
        'java': /^\/\/\s*(.+)$/,
        'cpp': /^\/\/\s*(.+)$/,
        'c': /^\/\/\s*(.+)$/,
        'cs': /^\/\/\s*(.+)$/
    };
    
    const patron = patronesComentario[extension];
    if (!patron) return '';
    
    // Buscar comentarios en las primeras 10 líneas
    for (let i = 0; i < Math.min(10, lineas.length); i++) {
        const linea = lineas[i].trim();
        const match = linea.match(patron);
        
        if (match) {
            const comentario = match[1];
            // Filtrar comentarios que parecen ser notas descriptivas
            if (comentario.toLowerCase().includes('ejemplo') ||
                comentario.toLowerCase().includes('tipo:') ||
                comentario.toLowerCase().includes('problema:') ||
                comentario.toLowerCase().includes('calificación') ||
                comentario.toLowerCase().includes('nota')) {
                notas.push(comentario);
            }
        }
    }
    
    return notas.join(' ');
}

// Extraer calificación de los comentarios
function extraerCalificacion(codigo) {
    const match = codigo.match(/calificaci[oó]n\s*esperada:\s*(\d+)/i);
    if (match) {
        return parseInt(match[1]);
    }
    return null;
}
