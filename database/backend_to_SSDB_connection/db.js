const sql = require('mssql');
require('dotenv').config();

const config = {

    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,

    server: process.env.DB_SERVER,
    database: process.env.DB_DATABASE,

    port: parseInt(process.env.DB_PORT),

    options: {
        encrypt: false,
        trustServerCertificate: true
    }

};

const pool = new sql.ConnectionPool(config);

pool.connect()
    .then(() => {
        console.log('Connected to SQL Server');
    })
    .catch(err => {
        console.error(err);
    });

module.exports = {
    sql,
    pool
};
