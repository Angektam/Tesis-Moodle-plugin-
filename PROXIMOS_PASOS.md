# 🎯 Próximos Pasos - Plan de Acción

**Fecha**: Marzo 13, 2026  
**Estado del Proyecto**: Plugin funcional en modo demo

---

## ✅ Estado Actual

- ✅ Plugin Moodle instalado y funcional
- ✅ OpenAI API Key configurada
- ✅ Modo demo funcionando
- ✅ Estructura básica completa
- ✅ Documentación organizada

---

## 🚀 Fase 1: Configuración OpenAI para Evaluación Real

### Objetivo
Cambiar del modo demo a evaluación real con IA

### Pasos

1. **Verificar API Key actual**
   ```bash
   node -e "require('dotenv').config(); console.log('API Key:', process.env.OPENAI_API_KEY ? 'Configurada ✅' : 'Falta ❌')"
   ```

2. **Desactivar modo demo en Moodle**
   - Ir a: Administración del sitio → Plugins → Módulos de actividad → AI Assignment
   - Desmarcar "Modo Demo"
   - Ingresar tu OpenAI API Key
   - Guardar cambios

3. **Probar evaluación real**
   - Crear una tarea de prueba
   - Enviar una solución
   - Verificar que la evaluación usa OpenAI (no simulación)

### Resultado Esperado
- Evaluaciones con análisis detallado de IA
- Feedback personalizado y preciso
- Puntajes más justos y consistentes

---

## 👥 Fase 2: Pruebas con Múltiples Estudiantes

### Objetivo
Validar el sistema con carga real de usuarios

### Pasos

1. **Crear usuarios de prueba**
   ```bash
   # Ver archivo USUARIOS_PRUEBA.md para credenciales
   ```
   - Profesor: `profesor@test.com`
   - Estudiante 1: `estudiante1@test.com`
   - Estudiante 2: `estudiante2@test.com`
   - Estudiante 3: `estudiante3@test.com`

2. **Crear curso de prueba**
   - Nombre: "Programación 101 - Pruebas"
   - Inscribir a los 3 estudiantes
   - Crear 2-3 tareas diferentes

3. **Escenarios de prueba**
   
   **Tarea 1: Factorial (Python)**
   - Estudiante 1: Solución correcta
   - Estudiante 2: Solución con errores menores
   - Estudiante 3: Solución incorrecta

   **Tarea 2: FizzBuzz (JavaScript)**
   - Estudiante 1: Solución óptima
   - Estudiante 2: Solución funcional pero ineficiente
   - Estudiante 3: Solución parcial

4. **Verificar**
   - Todas las evaluaciones se completan
   - Los puntajes son coherentes
   - El feedback es útil
   - No hay errores en logs

### Resultado Esperado
- Sistema estable con múltiples usuarios
- Evaluaciones consistentes
- Tiempos de respuesta aceptables (<5 segundos)

---

## 📊 Fase 3: Dashboard con Datos Reales

### Objetivo
Verificar que el dashboard muestra información correcta

### Pasos

1. **Generar datos de prueba**
   - Mínimo 10 entregas de diferentes estudiantes
   - Variedad de puntajes (60-100)
   - Diferentes fechas de entrega

2. **Verificar métricas del dashboard**
   - Total de entregas
   - Promedio de calificaciones
   - Distribución de puntajes
   - Gráficos de tendencias

3. **Probar filtros**
   - Por estudiante
   - Por rango de fechas
   - Por puntaje

4. **Exportar reportes**
   - CSV con todas las entregas
   - PDF con estadísticas

### Resultado Esperado
- Dashboard muestra datos precisos
- Gráficos se actualizan correctamente
- Exportación funciona sin errores

---

## 🔍 Fase 4: Detección de Plagio

### Objetivo
Activar y probar el sistema de detección de plagio

### Pasos

1. **Configurar comparación AST**
   - Ya implementado en `demo-standalone/services/ast_comparator.js`
   - Probar con código similar

2. **Crear casos de prueba**
   
   **Caso 1: Plagio Obvio**
   - Estudiante A y B envían código idéntico
   - Esperado: Similitud > 95%

   **Caso 2: Plagio con Cambios Menores**
   - Estudiante A envía código
   - Estudiante B cambia nombres de variables
   - Esperado: Similitud > 80%

   **Caso 3: Código Original**
   - Dos soluciones diferentes al mismo problema
   - Esperado: Similitud < 60%

3. **Verificar reportes de plagio**
   - Ir a `plagiarism_report.php`
   - Ver pares de entregas sospechosas
   - Revisar análisis de similitud

4. **Configurar umbrales**
   - Umbral de alerta: 70%
   - Umbral crítico: 85%
   - Acción automática: Marcar para revisión

### Resultado Esperado
- Detección precisa de código similar
- Reportes claros y accionables
- Falsos positivos mínimos

---

## 🔧 Tareas Técnicas Adicionales

### Optimización
- [ ] Implementar caché para evaluaciones
- [ ] Optimizar consultas a base de datos
- [ ] Comprimir respuestas del servidor

### Seguridad
- [ ] Validar todas las entradas de usuario
- [ ] Sanitizar código antes de evaluar
- [ ] Implementar rate limiting

### Monitoreo
- [ ] Logs de errores
- [ ] Métricas de uso
- [ ] Alertas de fallos

---

## 📅 Cronograma Sugerido

| Fase | Tiempo Estimado | Prioridad |
|------|----------------|-----------|
| Fase 1: OpenAI Real | 30 minutos | 🔴 Alta |
| Fase 2: Múltiples Usuarios | 2 horas | 🔴 Alta |
| Fase 3: Dashboard | 1 hora | 🟡 Media |
| Fase 4: Plagio | 2 horas | 🟡 Media |
| Tareas Técnicas | 3 horas | 🟢 Baja |

**Total**: ~8 horas de trabajo

---

## 🎯 Criterios de Éxito

### Fase 1
- ✅ Evaluaciones usan OpenAI API
- ✅ Feedback es coherente y útil
- ✅ Sin errores de API

### Fase 2
- ✅ 3+ estudiantes pueden trabajar simultáneamente
- ✅ Todas las entregas se procesan correctamente
- ✅ Tiempos de respuesta < 5 segundos

### Fase 3
- ✅ Dashboard muestra datos precisos
- ✅ Gráficos se renderizan correctamente
- ✅ Exportación funciona

### Fase 4
- ✅ Detecta plagio obvio (>95% similitud)
- ✅ Identifica código similar (>80% similitud)
- ✅ No marca código original como plagio

---

## 🚨 Posibles Problemas y Soluciones

### Problema: API Key inválida
**Solución**: Verificar en https://platform.openai.com/api-keys

### Problema: Evaluaciones lentas
**Solución**: Cambiar a modelo más rápido o implementar caché

### Problema: Falsos positivos en plagio
**Solución**: Ajustar umbrales de similitud

### Problema: Dashboard no carga
**Solución**: Verificar permisos de base de datos

---

## 📚 Recursos Útiles

- [Documentación OpenAI](https://platform.openai.com/docs)
- [Guía de Pruebas](./GUIA_PRUEBAS_MANUAL.md)
- [Usuarios de Prueba](./USUARIOS_PRUEBA.md)
- [Comparación AST](./demo-standalone/AST_COMPARACION_README.md)

---

## ✅ Checklist General

- [ ] OpenAI API configurada y funcionando
- [ ] Modo demo desactivado
- [ ] 3+ usuarios de prueba creados
- [ ] 10+ entregas de prueba realizadas
- [ ] Dashboard verificado con datos reales
- [ ] Detección de plagio probada
- [ ] Documentación actualizada
- [ ] Sistema listo para producción

---

**Próxima acción recomendada**: Empezar con Fase 1 - Configurar OpenAI para evaluación real
