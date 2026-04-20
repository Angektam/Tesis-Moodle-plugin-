# 📁 Estructura Organizada del Proyecto

## Proyecto de Tesis: Detección de Plagio de Código Fuente con IA en Moodle

---

## 🎯 Nueva Estructura Propuesta

```
proyecto-tesis-plagio-ia/
│
├── 📁 docs/                           # Toda la documentación
│   ├── 📁 tesis/                      # Documentos de tesis
│   │   ├── TESIS_DETECCION_PLAGIO.md
│   │   ├── RESUMEN_PROYECTO.md
│   │   └── INDICE_PROYECTO.md
│   │
│   ├── 📁 instalacion/                # Guías de instalación
│   │   ├── INSTALACION_RAPIDA.md
│   │   ├── COMO_EMPEZAR.md
│   │   ├── CONFIGURAR_API_KEY.md
│   │   └── GUIA_INSTALACION_MOODLE_LOCAL.md
│   │
│   ├── 📁 usuario/                    # Manuales de usuario
│   │   ├── GUIA_RAPIDA.md
│   │   ├── CASOS_PRUEBA_MANUAL.md
│   │   └── MODO_DEMO_VS_REAL.md
│   │
│   └── 📁 tecnica/                    # Documentación técnica
│       ├── FUNCIONALIDAD_PLAGIO.md
│       ├── DETECCION_PLAGIO_AUTOMATICA.md
│       ├── ESTRUCTURA_BD.md
│       └── DIFERENCIAS_PLUGIN_VS_MOD.md
│
├── 📁 moodle-plugin/                  # Plugin principal para Moodle
│   ├── classes/
│   ├── db/
│   ├── lang/
│   ├── backup/
│   ├── docs/                          # Docs específicos del plugin
│   └── [archivos del plugin]
│
├── 📁 entrenamiento-ia/               # Sistema de entrenamiento IA
│   ├── ejemplos-codigo/
│   ├── ejemplos-entrenamiento.json
│   └── [documentación]
│
├── 📁 demo-standalone/                # Aplicación demo independiente
│   ├── server.js
│   ├── server-demo.js
│   ├── plugin-funcional.html
│   ├── plugin-funcional.js
│   ├── plugin-funcional.css
│   └── test-plugin-automatico.html
│
├── 📁 scripts/                        # Scripts de utilidad
│   ├── crear-zip-plugin.bat
│   ├── crear-zip-plugin.sh
│   ├── iniciar-plugin.bat
│   ├── habilitar-extensiones-php.bat
│   └── [otros scripts]
│
├── 📁 dist/                           # Archivos compilados/empaquetados
│   ├── aiassignment.zip
│   └── mod_aiassignment.zip
│
├── .env                               # Configuración
├── .env.example
├── package.json
├── README.md                          # Readme principal
└── LEEME.txt                          # Bienvenida
```

---

## 📋 Plan de Reorganización

### Fase 1: Crear Estructura de Carpetas
- ✅ Crear carpeta `docs/` con subcarpetas
- ✅ Crear carpeta `demo-standalone/`
- ✅ Crear carpeta `scripts/`
- ✅ Crear carpeta `dist/`

### Fase 2: Mover Documentación
- Mover documentos de tesis a `docs/tesis/`
- Mover guías de instalación a `docs/instalacion/`
- Mover manuales de usuario a `docs/usuario/`
- Mover docs técnicos a `docs/tecnica/`

### Fase 3: Organizar Código
- Mover archivos demo a `demo-standalone/`
- Mover scripts a `scripts/`
- Mover ZIPs a `dist/`

### Fase 4: Actualizar Referencias
- Actualizar README.md con nueva estructura
- Actualizar INDICE_PROYECTO.md
- Actualizar rutas en documentos

---

## 🎯 Beneficios de la Nueva Estructura

1. **Claridad**: Fácil encontrar documentación vs código
2. **Separación**: Docs, plugin, demo y scripts separados
3. **Profesional**: Estructura estándar de proyectos
4. **Mantenible**: Fácil agregar nuevos archivos
5. **Escalable**: Preparado para crecimiento

---

## 📝 Notas

- Los archivos del plugin Moodle permanecen en `moodle-plugin/`
- El sistema de entrenamiento permanece en `entrenamiento-ia/`
- Los archivos de configuración (.env, package.json) permanecen en raíz
- README.md y LEEME.txt permanecen en raíz como punto de entrada
