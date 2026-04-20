/**
 * AST Comparator Service
 * Compara código usando Abstract Syntax Trees para detectar plagio estructural
 * Soporta: JavaScript, Python, Java, C++
 */

const acorn = require('acorn');

class ASTComparator {
    constructor() {
        this.supportedLanguages = ['javascript', 'python', 'java', 'cpp', 'c'];
    }

    /**
     * Compara dos códigos usando análisis AST
     * @param {string} code1 - Primer código
     * @param {string} code2 - Segundo código
     * @param {string} language - Lenguaje de programación
     * @returns {Object} Resultado con similarity score y detalles
     */
    async compare(code1, code2, language = 'javascript') {
        try {
            language = language.toLowerCase();

            // Python → microservicio Python AST (ast.parse nativo)
            if (language === 'python' || language === 'py') {
                return await this.comparePython(code1, code2);
            }

            // JavaScript → acorn AST
            if (language === 'javascript' || language === 'js' || language === 'node') {
                return this.compareJavaScript(code1, code2);
            }

            // Otros lenguajes → análisis estructural
            return this.compareStructural(code1, code2, language);

        } catch (error) {
            console.error('Error en comparación AST:', error);
            return { similarity: 0, method: 'error', error: error.message };
        }
    }

    /**
     * Compara código Python usando el microservicio python_ast_service.py
     */
    async comparePython(code1, code2) {
        try {
            const fetch = require('node-fetch');
            const res = await fetch('http://localhost:5001/compare', {
                method:  'POST',
                headers: { 'Content-Type': 'application/json' },
                body:    JSON.stringify({ code1, code2 }),
                timeout: 5000,
            });
            if (!res.ok) throw new Error(`HTTP ${res.status}`);
            const data = await res.json();
            return {
                similarity: data.similarity,
                method:     'ast_python',
                language:   'python',
                details:    data.details || {},
            };
        } catch (e) {
            // Servicio no disponible → fallback estructural
            console.warn('[ASTComparator] Python AST service no disponible, usando fallback.');
            return this.compareStructural(code1, code2, 'python');
        }
    }

    /**
     * Compara código JavaScript usando AST
     */
    compareJavaScript(code1, code2) {
        try {
            // Limpiar y validar código
            const cleanCode1 = this.cleanCode(code1);
            const cleanCode2 = this.cleanCode(code2);

            // Validar que no estén vacíos
            if (!cleanCode1 || !cleanCode2) {
                return this.compareStructural(code1, code2, 'javascript');
            }

            // Intentar parsear con diferentes configuraciones
            let ast1, ast2;
            
            try {
                ast1 = acorn.parse(cleanCode1, { 
                    ecmaVersion: 2022,
                    sourceType: 'module',
                    allowReturnOutsideFunction: true,
                    allowImportExportEverywhere: true,
                    allowAwaitOutsideFunction: true
                });
            } catch (e) {
                // Intentar como script en lugar de módulo
                try {
                    ast1 = acorn.parse(cleanCode1, { 
                        ecmaVersion: 2022,
                        sourceType: 'script',
                        allowReturnOutsideFunction: true
                    });
                } catch (e2) {
                    throw e; // Usar el error original
                }
            }

            try {
                ast2 = acorn.parse(cleanCode2, { 
                    ecmaVersion: 2022,
                    sourceType: 'module',
                    allowReturnOutsideFunction: true,
                    allowImportExportEverywhere: true,
                    allowAwaitOutsideFunction: true
                });
            } catch (e) {
                try {
                    ast2 = acorn.parse(cleanCode2, { 
                        ecmaVersion: 2022,
                        sourceType: 'script',
                        allowReturnOutsideFunction: true
                    });
                } catch (e2) {
                    throw e;
                }
            }

            // Extraer características estructurales
            const features1 = this.extractFeatures(ast1);
            const features2 = this.extractFeatures(ast2);

            // Calcular similitud
            const similarity = this.calculateSimilarity(features1, features2);

            return {
                similarity: Math.round(similarity * 100),
                method: 'ast',
                language: 'javascript',
                details: {
                    code1_features: features1,
                    code2_features: features2,
                    structural_match: similarity > 0.85
                }
            };

        } catch (error) {
            // Si falla el parsing, usar método estructural (sin mostrar warning repetido)
            return this.compareStructural(code1, code2, 'javascript');
        }
    }

    /**
     * Limpia el código antes de parsear
     */
    cleanCode(code) {
        if (!code || typeof code !== 'string') {
            return '';
        }

        return code
            .trim()
            // Eliminar BOM (Byte Order Mark)
            .replace(/^\uFEFF/, '')
            // Normalizar saltos de línea
            .replace(/\r\n/g, '\n')
            .replace(/\r/g, '\n');
    }

    /**
     * Extrae características del AST
     */
    extractFeatures(ast) {
        const features = {
            nodeTypes: {},
            depth: 0,
            totalNodes: 0,
            functions: 0,
            loops: 0,
            conditionals: 0,
            variables: 0,
            operators: [],
            structure: []
        };

        const traverse = (node, depth = 0) => {
            if (!node || typeof node !== 'object') return;

            features.totalNodes++;
            features.depth = Math.max(features.depth, depth);

            // Contar tipos de nodos
            const type = node.type;
            features.nodeTypes[type] = (features.nodeTypes[type] || 0) + 1;
            features.structure.push(type);

            // Identificar estructuras específicas
            switch (type) {
                case 'FunctionDeclaration':
                case 'FunctionExpression':
                case 'ArrowFunctionExpression':
                    features.functions++;
                    break;
                case 'ForStatement':
                case 'WhileStatement':
                case 'DoWhileStatement':
                case 'ForInStatement':
                case 'ForOfStatement':
                    features.loops++;
                    break;
                case 'IfStatement':
                case 'ConditionalExpression':
                case 'SwitchStatement':
                    features.conditionals++;
                    break;
                case 'VariableDeclaration':
                    features.variables++;
                    break;
                case 'BinaryExpression':
                case 'UnaryExpression':
                case 'LogicalExpression':
                    if (node.operator) {
                        features.operators.push(node.operator);
                    }
                    break;
            }

            // Recorrer hijos
            for (const key in node) {
                if (key === 'loc' || key === 'range' || key === 'start' || key === 'end') {
                    continue;
                }
                const child = node[key];
                if (Array.isArray(child)) {
                    child.forEach(c => traverse(c, depth + 1));
                } else if (child && typeof child === 'object') {
                    traverse(child, depth + 1);
                }
            }
        };

        traverse(ast);
        return features;
    }

    /**
     * Calcula similitud entre dos conjuntos de características
     */
    calculateSimilarity(features1, features2) {
        let totalScore = 0;
        let weights = 0;

        // 1. Similitud de estructura (30%)
        const structureSim = this.compareArrays(features1.structure, features2.structure);
        totalScore += structureSim * 0.30;
        weights += 0.30;

        // 2. Similitud de tipos de nodos (25%)
        const nodeTypesSim = this.compareObjects(features1.nodeTypes, features2.nodeTypes);
        totalScore += nodeTypesSim * 0.25;
        weights += 0.25;

        // 3. Similitud de características numéricas (20%)
        const numericSim = this.compareNumeric({
            functions: features1.functions,
            loops: features1.loops,
            conditionals: features1.conditionals,
            variables: features1.variables,
            depth: features1.depth
        }, {
            functions: features2.functions,
            loops: features2.loops,
            conditionals: features2.conditionals,
            variables: features2.variables,
            depth: features2.depth
        });
        totalScore += numericSim * 0.20;
        weights += 0.20;

        // 4. Similitud de operadores (15%)
        const operatorsSim = this.compareArrays(features1.operators, features2.operators);
        totalScore += operatorsSim * 0.15;
        weights += 0.15;

        // 5. Similitud de tamaño (10%)
        const sizeSim = 1 - Math.abs(features1.totalNodes - features2.totalNodes) / 
                        Math.max(features1.totalNodes, features2.totalNodes);
        totalScore += sizeSim * 0.10;
        weights += 0.10;

        return totalScore / weights;
    }

    /**
     * Compara dos arrays y retorna similitud
     */
    compareArrays(arr1, arr2) {
        if (arr1.length === 0 && arr2.length === 0) return 1;
        if (arr1.length === 0 || arr2.length === 0) return 0;

        const set1 = new Set(arr1);
        const set2 = new Set(arr2);
        const intersection = new Set([...set1].filter(x => set2.has(x)));
        const union = new Set([...set1, ...set2]);

        return intersection.size / union.size;
    }

    /**
     * Compara dos objetos y retorna similitud
     */
    compareObjects(obj1, obj2) {
        const keys1 = Object.keys(obj1);
        const keys2 = Object.keys(obj2);
        
        if (keys1.length === 0 && keys2.length === 0) return 1;
        if (keys1.length === 0 || keys2.length === 0) return 0;

        const allKeys = new Set([...keys1, ...keys2]);
        let similarity = 0;

        for (const key of allKeys) {
            const val1 = obj1[key] || 0;
            const val2 = obj2[key] || 0;
            const max = Math.max(val1, val2);
            if (max > 0) {
                similarity += Math.min(val1, val2) / max;
            }
        }

        return similarity / allKeys.size;
    }

    /**
     * Compara características numéricas
     */
    compareNumeric(obj1, obj2) {
        const keys = Object.keys(obj1);
        let similarity = 0;

        for (const key of keys) {
            const val1 = obj1[key] || 0;
            const val2 = obj2[key] || 0;
            const max = Math.max(val1, val2);
            if (max > 0) {
                similarity += 1 - Math.abs(val1 - val2) / max;
            } else {
                similarity += 1;
            }
        }

        return similarity / keys.length;
    }

    /**
     * Análisis estructural para lenguajes sin parser AST
     */
    compareStructural(code1, code2, language) {
        // Validar entrada
        if (!code1 || !code2 || typeof code1 !== 'string' || typeof code2 !== 'string') {
            return {
                similarity: 0,
                method: 'structural',
                language: language,
                details: {
                    error: 'Invalid input: code must be non-empty strings'
                }
            };
        }

        // Normalizar código
        const norm1 = this.normalizeCode(code1);
        const norm2 = this.normalizeCode(code2);

        // Validar que no estén vacíos después de normalizar
        if (!norm1 || !norm2) {
            return {
                similarity: 0,
                method: 'structural',
                language: language,
                details: {
                    error: 'Code is empty after normalization'
                }
            };
        }

        // Extraer tokens estructurales
        const tokens1 = this.extractStructuralTokens(norm1, language);
        const tokens2 = this.extractStructuralTokens(norm2, language);

        // Si no hay tokens, similitud 0
        if (tokens1.length === 0 && tokens2.length === 0) {
            return {
                similarity: 0,
                method: 'structural',
                language: language,
                details: {
                    tokens1_count: 0,
                    tokens2_count: 0,
                    error: 'No structural tokens found'
                }
            };
        }

        // Calcular similitud
        const similarity = this.compareArrays(tokens1, tokens2);

        return {
            similarity: Math.round(similarity * 100),
            method: 'structural',
            language: language,
            details: {
                tokens1_count: tokens1.length,
                tokens2_count: tokens2.length
            }
        };
    }

    /**
     * Normaliza código eliminando espacios, comentarios, etc.
     */
    normalizeCode(code) {
        return code
            .replace(/\/\*[\s\S]*?\*\//g, '') // Comentarios multilínea
            .replace(/\/\/.*/g, '') // Comentarios de línea
            .replace(/#.*/g, '') // Comentarios Python
            .replace(/\s+/g, ' ') // Espacios múltiples
            .trim();
    }

    /**
     * Extrae tokens estructurales del código
     */
    extractStructuralTokens(code, language) {
        const tokens = [];

        // Palabras clave comunes
        const keywords = {
            javascript: ['function', 'const', 'let', 'var', 'if', 'else', 'for', 'while', 'return', 'class'],
            python: ['def', 'class', 'if', 'elif', 'else', 'for', 'while', 'return', 'import'],
            java: ['public', 'private', 'class', 'void', 'int', 'if', 'else', 'for', 'while', 'return'],
            cpp: ['int', 'void', 'class', 'if', 'else', 'for', 'while', 'return', 'include'],
            c: ['int', 'void', 'if', 'else', 'for', 'while', 'return', 'include']
        };

        const langKeywords = keywords[language] || keywords.javascript;

        // Buscar palabras clave
        for (const keyword of langKeywords) {
            const regex = new RegExp(`\\b${keyword}\\b`, 'g');
            const matches = code.match(regex);
            if (matches) {
                tokens.push(...matches);
            }
        }

        // Buscar operadores
        const operators = ['+', '-', '*', '/', '=', '==', '!=', '<', '>', '<=', '>=', '&&', '||'];
        for (const op of operators) {
            const count = (code.match(new RegExp(`\\${op}`, 'g')) || []).length;
            for (let i = 0; i < count; i++) {
                tokens.push(op);
            }
        }

        // Buscar estructuras
        tokens.push(...(code.match(/\{/g) || []));
        tokens.push(...(code.match(/\}/g) || []));
        tokens.push(...(code.match(/\(/g) || []));
        tokens.push(...(code.match(/\)/g) || []));

        return tokens;
    }
}

module.exports = ASTComparator;
