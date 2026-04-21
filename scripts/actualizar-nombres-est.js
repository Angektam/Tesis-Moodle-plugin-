require('dotenv').config();
const mysql = require('mysql2/promise');

const nombres = [
    ['est01', 'Carlos',    'García'],
    ['est02', 'María',     'López'],
    ['est03', 'Pedro',     'Martínez'],
    ['est04', 'Ana',       'Rodríguez'],
    ['est05', 'Luis',      'Hernández'],
    ['est06', 'Sofía',     'Jiménez'],
    ['est07', 'Diego',     'Torres'],
    ['est08', 'Valentina', 'Flores'],
    ['est09', 'Andrés',    'Vargas'],
    ['est10', 'Camila',    'Reyes'],
    ['est11', 'Sebastián', 'Cruz'],
    ['est12', 'Isabella',  'Morales'],
    ['est13', 'Mateo',     'Ortiz'],
    ['est14', 'Lucía',     'Mendoza'],
    ['est15', 'Nicolás',   'Castillo'],
    ['est16', 'Gabriela',  'Ramos'],
    ['est17', 'Felipe',    'Gutiérrez'],
    ['est18', 'Daniela',   'Sánchez'],
    ['est19', 'Tomás',     'Ramírez'],
    ['est20', 'Valeria',   'Núñez'],
    ['est21', 'Emilio',    'Peña'],
    ['est22', 'Renata',    'Aguilar'],
    ['est23', 'Joaquín',   'Medina'],
    ['est24', 'Mariana',   'Vega'],
    ['est25', 'Rodrigo',   'Herrera'],
    ['est26', 'Natalia',   'Ríos'],
    ['est27', 'Alejandro', 'Mora'],
    ['est28', 'Paula',     'Delgado'],
    ['est29', 'Ignacio',   'Fuentes'],
    ['est30', 'Catalina',  'Espinoza'],
];

async function main() {
    const c = await mysql.createConnection({
        host: process.env.DB_HOST, user: process.env.DB_USER,
        password: process.env.DB_PASS, database: process.env.DB_NAME
    });

    const stmt = await c.prepare('UPDATE mdl_user SET firstname=?, lastname=? WHERE username=?');
    for (const [username, firstname, lastname] of nombres) {
        const [r] = await stmt.execute([firstname, lastname, username]);
        console.log(r.affectedRows > 0 ? `✅ ${username} → ${firstname} ${lastname}` : `⚠️  ${username} no encontrado`);
    }
    await stmt.close();
    await c.end();
    console.log('\n✨ Listo.');
}

main().catch(console.error);
