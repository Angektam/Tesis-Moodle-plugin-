// Resetear contraseñas de usuarios de prueba en Moodle
require('dotenv').config();
const mysql = require('mysql2/promise');
const crypto = require('crypto');

// Función para generar hash de contraseña compatible con Moodle
function generarHashMoodle(password) {
    // Moodle usa bcrypt, pero para pruebas podemos usar un hash simple
    // En producción, Moodle usa password_hash() de PHP con bcrypt
    return crypto.createHash('md5').update(password).digest('hex');
}

async function resetearPasswords() {
    const connection = await mysql.createConnection({
        host: process.env.DB_HOST || 'localhost',
        user: process.env.DB_USER || 'root',
        password: process.env.DB_PASS || '',
        database: process.env.DB_NAME || 'moodle'
    });

    console.log('🔐 Reseteando contraseñas de usuarios de prueba...\n');

    const usuarios = [
        { username: 'admin', password: 'Admin123!' },
        { username: 'estudiante1', password: 'estudiante1' },
        { username: 'estudiante2', password: 'estudiante2' },
        { username: 'estudiante3', password: 'estudiante3' },
        { username: 'alumno1', password: 'alumno1' },
        { username: 'alumno2', password: 'alumno2' },
        { username: 'alumno3', password: 'alumno3' },
        { username: 'alumno4', password: 'alumno4' },
        { username: 'alumno5', password: 'alumno5' }
    ];

    for (const user of usuarios) {
        const hash = generarHashMoodle(user.password);
        
        try {
            await connection.execute(
                'UPDATE mdl_user SET password = ? WHERE username = ?',
                [hash, user.username]
            );
            console.log(`✅ ${user.username.padEnd(15)} → contraseña: ${user.password}`);
        } catch (error) {
            console.log(`❌ Error con ${user.username}: ${error.message}`);
        }
    }

    console.log('\n📋 Resumen de credenciales:\n');
    console.log('┌─────────────────┬─────────────────┐');
    console.log('│ Usuario         │ Contraseña      │');
    console.log('├─────────────────┼─────────────────┤');
    usuarios.forEach(u => {
        console.log(`│ ${u.username.padEnd(15)} │ ${u.password.padEnd(15)} │`);
    });
    console.log('└─────────────────┴─────────────────┘');

    await connection.end();
}

resetearPasswords().catch(console.error);
