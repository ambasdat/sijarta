import express from 'express';
import path from 'path';
import { engine } from 'express-handlebars';

import auth from './auth';
import mypay from './mypay';
import home from './home';
import order from './order';

const app = express();

app.engine('.hbs', engine({ extname: '.hbs' }));
app.set('view engine', '.hbs');
app.set('views', path.resolve(process.cwd(), 'templates'));

app.use('/auth', auth);
app.use('/mypay', mypay);
app.use('/order', order)
app.use('/home', home);

app.get('/', (_req, res) => res.render('main', { name: 'World' }));

app.listen(3000, () => console.log('http://localhost:3000'));
