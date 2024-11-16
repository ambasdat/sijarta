import express from 'express';

const app = express.Router();

app.get('/', (req, res) => {
	res.render('order/orders');
});

app.get('/jobs', (req, res) => {
	res.render('order/jobs');
});

export default app;
