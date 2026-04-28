import { NextRequest, NextResponse } from 'next/server'
import { getOpenAI, isDemoMode, demoCompare } from '@/lib/openai'

export async function POST(req: NextRequest) {
  try {
    const { answer1, answer2 } = await req.json()

    if (!answer1 || !answer2) {
      return NextResponse.json({ error: 'Se requieren ambos códigos' }, { status: 400 })
    }

    if (isDemoMode()) {
      return NextResponse.json(demoCompare(answer1, answer2))
    }

    const openai = getOpenAI()

    const prompt = `Analiza la similitud entre estos dos códigos. Considera estructura, lógica y semántica.
Responde SOLO con un número del 0 al 100 (porcentaje de similitud):
- 0-30: Completamente diferentes
- 31-60: Algunas similitudes
- 61-85: Muy similares, posible colaboración
- 86-100: Prácticamente idénticos, alta probabilidad de plagio

CÓDIGO 1:\n\`\`\`\n${answer1}\n\`\`\`\n\nCÓDIGO 2:\n\`\`\`\n${answer2}\n\`\`\`\n\nResponde SOLO con el número:`

    const completion = await openai.chat.completions.create({
      model: 'gpt-4o-mini',
      messages: [{ role: 'user', content: prompt }],
      temperature: 0.2,
      max_tokens: 10,
    })

    const content = completion.choices[0].message.content || '0'
    const similarity = parseInt(content.match(/\d+/)?.[0] || '0')

    return NextResponse.json({ similarity: Math.min(100, Math.max(0, similarity)), method: 'ai' })
  } catch (err: unknown) {
    const msg = err instanceof Error ? err.message : 'Error interno'
    return NextResponse.json({ error: msg }, { status: 500 })
  }
}
