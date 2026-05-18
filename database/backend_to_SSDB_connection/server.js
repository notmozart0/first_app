const express = require('express');
const { pool } = require('./db');
require('dotenv').config();

const app = express();

app.use(express.json());

app.get('/test-db', async (req, res) => {

    try {

        const result = await pool.request()
            .query('SELECT GETDATE() AS currentTime');

        res.json(result.recordset);

    } catch (err) {

        console.error('FULL ERROR:', err);

        res.status(500).json({
            message: 'Database connection failed',
            error: err.message
        });

    }

});

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
