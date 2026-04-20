# 🎯 Modo Demo vs Modo Real

## ⚠️ Problema: Cuota de OpenAI Excedida

Tu cuenta de OpenAI ha excedido la cuota disponible. Esto significa que no puedes hacer llamadas a la API hasta que:

1. Agregues créditos a tu cuenta
2. O esperes a que se renueve tu cuota mensual

---

## 🎭 Solución: Modo Demo

He creado un **servidor demo** que simula las respuestas de IA sin necesidad de OpenAI.

### ✅ Ventajas del Modo Demo:

- ✅ Funciona sin créditos de OpenAI
- ✅ Respuestas instantáneas
- ✅ Perfecto para demos y presentaciones
- ✅ Muestra todas las funcionalidades del plugin
- ✅ Evaluación basada en análisis de código simple

### ⚠️ Limitaciones del Modo Demo:

- ❌ No usa IA real
- ❌ Evaluación menos precisa
- ❌ Feedback genérico (no personalizado)

---

## 🚀 Cómo Usar Cada Modo

### Modo Demo (Actual - Sin OpenAI)

```cmd
npm run demo
```

**Cuándo usar:**
- Para demos y presentaciones
- Para probar la interfaz
- Cuando no tienes créditos de OpenAI
- Para desarrollo sin gastar créditos

---

### Modo Real (Con OpenAI)

```cmd
npm start
```

**Requisitos:**
1. API key válida de OpenAI
2. Créditos disponibles en tu cuenta
3. Archivo `.env` configurado

**Cuándo usar:**
- Para evaluación real de código
- Para producción
- Cuando necesitas feedback preciso de IA
- Para detección de plagio avanzada

---

## 💰 Solucionar Problema de Cuota

### Opción 1: Agregar Créditos

1. Ve a: https://platform.openai.com/account/billing
2. Agrega un método de pago
3. Compra créditos (mínimo $5)
4. Espera unos minutos
5. Usa `npm start` para el modo real

### Opción 2: Esperar Renovación

Si tienes el plan gratuito:
- Se renueva mensualmente
- Límite: $5 de créditos gratis
- Verifica tu límite en: https://platform.openai.com/account/usage

### Opción 3: Usar Modo Demo

- No requiere créditos
- Funciona inmediatamente
- Perfecto para demos

---

## 📊 Comparación

| Característica | Modo Demo | Modo Real | Modo Entrenamiento 🆕 |
|----------------|-----------|-----------|----------------------|
| **Requiere OpenAI** | ❌ No | ✅ Sí | ❌ No |
| **Costo** | Gratis | ~$0.0003 por evaluación | Gratis |
| **Precisión** | Media | Alta | Media-Alta |
| **Feedback** | Genérico | Personalizado | Basado en patrones |
| **Velocidad** | Rápido | 2-5 segundos | Instantáneo (0.1s) |
| **Para Demos** | ✅ Perfecto | ✅ Perfecto | ✅ Perfecto |
| **Para Producción** | ⚠️ No recomendado | ✅ Recomendado | ✅ Recomendado |
| **Requiere Configuración** | ❌ No | ✅ API Key | ✅ Agregar ejemplos |
| **Funciona Offline** | ✅ Sí | ❌ No | ✅ Sí |

---

## 🎯 Recomendación

**Para tu tesis y presentaciones:**

1. **Usa Modo Entrenamiento** 🆕 para:
   - Evaluaciones rápidas y gratis
   - Demos sin gastar créditos
   - Mostrar evaluaciones consistentes
   - Funcionar sin internet

2. **Usa Modo Demo** para:
   - Demos en clase
   - Pruebas de interfaz
   - Screenshots y videos
   - Desarrollo sin gastar créditos

3. **Usa Modo Real** para:
   - Validar que la IA funciona correctamente
   - Mostrar evaluaciones reales (1-2 ejemplos)
   - Documentar resultados precisos
   - Casos únicos no cubiertos por entrenamiento

---

## 🔄 Cambiar Entre Modos

### Detener servidor actual:
```cmd
Ctrl + C (en la terminal del servidor)
```

### Iniciar Modo Demo:
```cmd
npm run demo
```

### Iniciar Modo Real:
```cmd
npm start
```

---

## 📝 Ejemplo de Uso

### Modo Demo (Actual)

```
1. npm run demo
2. Abre: http://localhost:3000/plugin-funcional.html
3. Crea tareas y envía código
4. Ve evaluaciones simuladas instantáneas
```

### Modo Real (Cuando tengas créditos)

```
1. Agrega créditos a OpenAI
2. Verifica .env tiene tu API key
3. npm start
4. Abre: http://localhost:3000/plugin-funcional.html
5. Ve evaluaciones reales con IA
```

---

## 💡 Consejo para tu Tesis

Para tu presentación y documentación:

1. **Usa Modo Demo** para la mayoría de las demos
2. **Graba 1-2 videos** con Modo Real mostrando evaluaciones reales
3. **Toma screenshots** de ambos modos
4. **Documenta** que el sistema puede funcionar con o sin IA real

Esto demuestra:
- ✅ Flexibilidad del sistema
- ✅ Funcionalidad completa
- ✅ Alternativas para diferentes escenarios

---

## 🎉 Estado Actual

✅ **Modo Demo está funcionando**
✅ **Modo Entrenamiento implementado** 🆕
✅ **Plugin completamente funcional**
✅ **Listo para demos y presentaciones**

Puedes usar el plugin ahora mismo sin necesidad de créditos de OpenAI.

### 🆕 Nuevo: Sistema de Entrenamiento

**Cómo empezar:**
1. Abre `plugin-funcional.html`
2. Ve a la pestaña "Entrenamiento"
3. Importa `ejemplos-entrenamiento.json`
4. ¡Ya tienes 15 ejemplos para evaluar sin API!

**Documentación completa:** `ENTRENAMIENTO_IA.md`

---

¿Preguntas? Lee la documentación completa en:
- `INICIAR_SERVIDOR.md`
- `CONFIGURAR_API_KEY.md`
- `INSTRUCCIONES_PLUGIN_FUNCIONAL.md`
