import OpenAI from 'openai'

export function getOpenAI() {
  const key = process.env.OPENAI_API_KEY
  if (!key) throw new Error('OPENAI_API_KEY not set')
  return new OpenAI({ apiKey: key })
}

export function isDemoMode() {
  return !process.env.OPENAI_API_KEY || process.env.DEMO_MODE === 'true'
}

/** Simulated evaluation for demo mode */
export function demoEvaluate(studentAnswer: string, teacherSolution: string) {
  const sim = similarText(studentAnswer, teacherSolution)
  const score = Math.min(95, Math.max(30, Math.round(sim * 100)))
  return {
    score,
    feedback: score >= 80
      ? '✅ Excelente solución. Tu código es correcto y bien estructurado.'
      : score >= 60
      ? '⚠️ Buena aproximación, pero hay áreas de mejora en la lógica.'
      : '❌ Tu solución difiere significativamente de la esperada. Revisa la lógica.',
    analysis: `Análisis estructural: ${score}% de similitud con la solución de referencia. Modo demo activo.`,
    method: 'demo',
  }
}

export function demoCompare(a: string, b: string) {
  const sim = Math.round(similarText(a, b) * 100)
  return { similarity: sim, method: 'demo' }
}

function similarText(a: string, b: string): number {
  const na = a.toLowerCase().replace(/\s+/g, '')
  const nb = b.toLowerCase().replace(/\s+/g, '')
  if (!na || !nb) return 0
  let matches = 0
  const min = Math.min(na.length, nb.length)
  for (let i = 0; i < min; i++) if (na[i] === nb[i]) matches++
  return matches / Math.max(na.length, nb.length)
}
