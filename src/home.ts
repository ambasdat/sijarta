import express from 'express';

const app = express.Router();

app.get('/', (req, res) => {
    res.render('home/home.hbs');
});

export default app;