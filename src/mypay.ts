import express from 'express';

const app = express.Router();

app.get('/', (req, res) => {
	res.render('mypay/main');
});

app.get('/transaction', (req, res) => {
	res.render('mypay/transaction');
});

export default app;
