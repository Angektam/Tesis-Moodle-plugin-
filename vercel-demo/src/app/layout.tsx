import type { Metadata } from 'next'
import './globals.css'

export const metadata: Metadata = {
  title: 'AI Assignment — Demo',
  description: 'Plugin de evaluación automática con IA para Moodle',
}

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="es">
      <body>{children}</body>
    </html>
  )
}
