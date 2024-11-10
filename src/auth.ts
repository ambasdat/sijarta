import express from 'express';

const app = express.Router();

app.get('/', (req, res) => {
	res.render('auth/main');
});

app.get('/login', (req, res) => {
	res.render('auth/login');
});

app.get('/register', (req, res) => {
	res.render('auth/register/main');
});

app.get('/register/pekerja', (req, res) => {
	res.render('auth/register/pekerja');
});

app.get('/register/pengguna', (req, res) => {
	res.render('auth/register/pengguna');
});

export default app;
