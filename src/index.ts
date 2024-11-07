import express from 'express';
import path from 'path';
import { engine } from 'express-handlebars';

const app = express();

app.engine('.hbs', engine({ extname: '.hbs' }));
app.set('view engine', '.hbs');
app.set('views', path.resolve(process.cwd(), 'templates'));

app.get('/', (_req, res) => {
	res.render('main', { name: 'World', layout: false });
})

app.listen(3000, () => console.log('http://localhost:3000'))
