import { NextRequest, NextResponse } from 'next/server'
import { getOpenAI, isDemoMode, demoEvaluate } from '@/lib/openai'

export async function POST(req: NextRequest) {
  try {
    const { studentAnswer, teacherSolution, type = 'programming' } = await req.json()

    if (!studentAnswer || !teacherSolution) {
      return NextResponse.json({ error: 'Faltan campos requeridos' }, { status: 400 })
    }

    if (isDemoMode()) {
      return NextResponse.json(demoEvaluate(studentAnswer, teacherSolution))
    }

    const openai = getOpenAI()

    const systemPrompt = `Eres un evaluador académico experto en ${type === 'math' ? 'matemáticas' : 'programación'}.
Evalúa la respuesta del estudiante comparándola con la solución de referencia.
Responde ÚNICAMENTE en JSON con esta estructura:
{
  "score": número entre 0 y 100,
  "feedback": "retroalimentación breve y constructiva (2-3 oraciones)",
  "analysis": "análisis detallado de la respuesta"
}`

    const userPrompt = `SOLUCIÓN DE REFERENCIA:\n\`\`\`\n${teacherSolution}\n\`\`\`\n\nRESPUESTA DEL ESTUDIANTE:\n\`\`\`\n${studentAnswer}\n\`\`\``

    const completion = await openai.chat.completions.create({
      model: 'gpt-4o-mini',
      messages: [
        { role: 'system', content: systemPrompt },
        { role: 'user', content: userPrompt },
      ],
      temperature: 0.3,
      response_format: { type: 'json_object' },
    })

    const result = JSON.parse(completion.choices[0].message.content || '{}')
    return NextResponse.json({ ...result, method: 'ai' })
  } catch (err: unknown) {
    const msg = err instanceof Error ? err.message : 'Error interno'
    return NextResponse.json({ error: msg }, { status: 500 })
  }
}
