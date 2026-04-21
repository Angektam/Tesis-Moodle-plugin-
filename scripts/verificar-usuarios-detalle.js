// Verificar detalles completos de usuarios en Moodle
require('dotenv').config();
const mysql = require('mysql2/promise');

async function verificarUsuariosDetalle() {
    const connection = await mysql.createConnection({
        host: process.env.DB_HOST || 'localhost',
        user: process.env.DB_USER || 'root',
        password: process.env.DB_PASS || '',
        database: process.env.DB_NAME || 'moodle'
    });

    console.log('🔍 Verificando detalles de usuarios...\n');

    // Buscar todos los usuarios no guest
    const [usuarios] = await connection.execute(`
        SELECT 
            u.id,
            u.username,
            u.firstname,
            u.lastname,
            u.email,
            u.confirmed,
            u.suspended,
            u.deleted,
            u.auth
        FROM mdl_user u
        WHERE u.username != 'guest'
        AND u.deleted = 0
        ORDER BY u.id
    `);

    console.log('✅ Usuarios activos en Moodle:\n');
    console.table(usuarios.map(u => ({
        ID: u.id,
        Usuario: u.username,
        Nombre: `${u.firstname} ${u.lastname}`,
        Email: u.email,
        Confirmado: u.confirmed ? '✓' : '✗',
        Suspendido: u.suspended ? '✗' : '✓',
        Auth: u.auth
    })));

    // Verificar roles
    console.log('\n📋 Verificando roles de usuarios...\n');
    const [roles] = await connection.execute(`
        SELECT 
            u.username,
            r.shortname as rol,
            c.fullname as contexto
        FROM mdl_role_assignments ra
        JOIN mdl_user u ON ra.userid = u.id
        JOIN mdl_role r ON ra.roleid = r.id
        JOIN mdl_context ctx ON ra.contextid = ctx.id
        LEFT JOIN mdl_course c ON ctx.instanceid = c.id AND ctx.contextlevel = 50
        WHERE u.username IN ('admin', 'alumno1', 'alumno2', 'alumno3', 'alumno4', 'alumno5', 
                             'estudiante1', 'estudiante2', 'estudiante3')
        ORDER BY u.username, r.shortname
    `);

    if (roles.length > 0) {
        console.table(roles);
    } else {
        console.log('⚠️  No se encontraron roles asignados a estos usuarios');
    }

    await connection.end();
}

verificarUsuariosDetalle().catch(console.error);
