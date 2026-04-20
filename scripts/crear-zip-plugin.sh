#!/bin/bash

clear
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                                                              ║"
echo "║   Crear ZIP del Plugin para Instalación en Moodle          ║"
echo "║                                                              ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# Verificar si existe la carpeta moodle-plugin
if [ ! -d "moodle-plugin" ]; then
    echo "ERROR: No se encontró la carpeta moodle-plugin"
    echo "Asegúrate de ejecutar este script desde la raíz del proyecto"
    exit 1
fi

echo "Creando archivo ZIP..."
echo ""

# Eliminar ZIP anterior si existe
if [ -f "aiassignment.zip" ]; then
    rm aiassignment.zip
    echo "ZIP anterior eliminado"
fi

# Crear ZIP excluyendo archivos innecesarios
cd moodle-plugin
zip -r ../aiassignment.zip . \
    -x "*.git*" \
    -x "*.md" \
    -x "demo*.html" \
    -x "vista-previa*.html" \
    -x "dashboard-demo.html" \
    -x "*.DS_Store"
cd ..

if [ -f "aiassignment.zip" ]; then
    echo ""
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                                                              ║"
    echo "║   ✓ ZIP CREADO EXITOSAMENTE                                ║"
    echo "║                                                              ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo ""
    echo "Archivo: aiassignment.zip"
    echo "Ubicación: $(pwd)/aiassignment.zip"
    echo "Tamaño: $(du -h aiassignment.zip | cut -f1)"
    echo ""
    echo "SIGUIENTE PASO:"
    echo "1. Inicia sesión en Moodle como administrador"
    echo "2. Ve a: Site administration → Plugins → Install plugins"
    echo "3. Sube el archivo aiassignment.zip"
    echo "4. Sigue las instrucciones en pantalla"
    echo ""
    echo "Documentación: moodle-plugin/INSTALACION_DESDE_INTERFAZ.md"
else
    echo ""
    echo "ERROR: No se pudo crear el archivo ZIP"
    echo "Verifica que zip esté instalado: sudo apt install zip"
fi

echo ""
