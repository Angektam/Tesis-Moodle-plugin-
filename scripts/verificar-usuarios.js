// Verificar qué usuarios existen en la base de datos de Moodle
require('dotenv').config();
const mysql = require('mysql2/promise');

async function verificarUsuarios() {
    const connection = await mysql.createConnection({
        host: process.env.DB_HOST || 'localhost',
        user: process.env.DB_USER || 'root',
        password: process.env.DB_PASS || '',
        database: process.env.DB_NAME || 'moodle'
    });

    console.log('🔍 Verificando usuarios en Moodle...\n');

    // Buscar usuarios existentes
    const [usuarios] = await connection.execute(`
        SELECT id, username, firstname, lastname, email, auth, confirmed
        FROM mdl_user
        WHERE username IN ('admin', 'alumno1', 'alumno2', 'alumno3', 'alumno4', 'alumno5')
        OR id <= 10
        ORDER BY id
    `);

    if (usuarios.length === 0) {
        console.log('❌ No se encontraron usuarios en la base de datos');
    } else {
        console.log('✅ Usuarios encontrados:\n');
        console.table(usuarios.map(u => ({
            ID: u.id,
            Usuario: u.username,
            Nombre: `${u.firstname} ${u.lastname}`,
            Email: u.email,
            Confirmado: u.confirmed ? '✓' : '✗'
        })));
    }

    await connection.end();
}

verificarUsuarios().catch(console.error);
