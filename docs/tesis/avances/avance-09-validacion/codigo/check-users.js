require('dotenv').config();
const mysql = require('mysql2/promise');
mysql.createConnection({
    host: process.env.DB_HOST, user: process.env.DB_USER,
    password: process.env.DB_PASS, database: process.env.DB_NAME
}).then(async c => {
    const [r] = await c.execute(
        'SELECT username, firstname, lastname FROM mdl_user WHERE username LIKE "est%" OR username LIKE "alumno%" ORDER BY username LIMIT 15'
    );
    console.table(r);
    c.end();
});
