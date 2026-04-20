/**
 * Script para crear el archivo ZIP del plugin de Moodle
 * Incluye solo los archivos necesarios para la instalación
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

console.log('📦 CREANDO PAQUETE ZIP DEL PLUGIN MOODLE\n');
console.log('═'.repeat(60));

// Archivos y carpetas a incluir
const filesToInclude = [
    // Archivos principales
    'version.php',
    'lib.php',
    'mod_form.php',
    'view.php',
    'index.php',
    'settings.php',
    'submit.php',
    'submission.php',
    'submissions.php',
    'dashboard.php',
    'plagiarism_report.php',
    
    // Carpetas completas
    'db/',
    'lang/',
    'classes/',
    'backup/',
    'amd/',
    'pix/',
    'styles/',
    
    // Documentación esencial
    'README.md',
    'INSTALACION.md'
];

// Archivos a excluir (documentación de desarrollo)
const filesToExclude = [
    '*.md',  // Excluir otros MD excepto los especificados
    'demo.html',
    'dashboard-demo.html',
    'vista-previa-completa.html',
    'ide_stubs.php'
];

const pluginDir = path.join(__dirname, '..', 'moodle-plugin');
const distDir = path.join(__dirname, '..', 'dist');
const zipName = 'mod_aiassignment.zip';
const zipPath = path.join(distDir, zipName);

// Crear carpeta dist si no existe
if (!fs.existsSync(distDir)) {
    fs.mkdirSync(distDir, { recursive: true });
    console.log('✅ Carpeta dist creada');
}

// Eliminar ZIP anterior si existe
if (fs.existsSync(zipPath)) {
    fs.unlinkSync(zipPath);
    console.log('🗑️  ZIP anterior eliminado');
}

console.log('\n📁 Archivos a incluir:');
filesToInclude.forEach(file => {
    console.log(`   • ${file}`);
});

console.log('\n🔨 Creando archivo ZIP...\n');

try {
    // Cambiar al directorio padre
    const parentDir = path.join(__dirname, '..');
    process.chdir(parentDir);
    
    console.log('🔨 Creando archivo ZIP con PowerShell...\n');
    
    // Crear ZIP usando PowerShell con sintaxis correcta
    const psCommand = `
        $source = "moodle-plugin"
        $destination = "${zipPath.replace(/\\/g, '\\\\')}"
        
        # Eliminar ZIP si existe
        if (Test-Path $destination) {
            Remove-Item $destination -Force
        }
        
        # Crear ZIP de toda la carpeta
        Compress-Archive -Path $source -DestinationPath $destination -Force
        
        Write-Host "✅ ZIP creado exitosamente"
    `;
    
    execSync(`powershell -Command "${psCommand}"`, { stdio: 'inherit' });
    
    console.log('\n✅ Archivo ZIP creado exitosamente!');
    console.log(`📦 Ubicación: ${zipPath}`);
    
    // Obtener tamaño del archivo
    const stats = fs.statSync(zipPath);
    const fileSizeInMB = (stats.size / (1024 * 1024)).toFixed(2);
    console.log(`📊 Tamaño: ${fileSizeInMB} MB`);
    
    console.log('\n' + '═'.repeat(60));
    console.log('\n📋 INSTRUCCIONES DE INSTALACIÓN:\n');
    console.log('1. Inicia sesión en Moodle como administrador');
    console.log('2. Ve a: Site administration → Plugins → Install plugins');
    console.log('3. Arrastra el archivo ZIP o haz clic en "Choose a file"');
    console.log(`4. Selecciona: ${zipPath}`);
    console.log('5. Haz clic en "Install plugin from the ZIP file"');
    console.log('6. Sigue las instrucciones en pantalla');
    console.log('7. Configura tu OpenAI API Key en la configuración del plugin');
    console.log('\n✅ ¡Listo para instalar en Moodle!\n');
    
} catch (error) {
    console.error('\n❌ Error al crear el ZIP:', error.message);
    console.error('\n💡 Intenta crear el ZIP manualmente:');
    console.error(`   1. Ve a la carpeta: ${pluginDir}`);
    console.error(`   2. Selecciona todos los archivos necesarios`);
    console.error(`   3. Crea un ZIP llamado: ${zipName}`);
    console.error(`   4. Guárdalo en: ${distDir}`);
    process.exit(1);
}
