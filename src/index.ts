import express from 'express';
import path from 'path';
import { engine } from 'express-handlebars';

import auth from './auth';
import mypay from './mypay';
import testimoni from './testimoni';
import diskon from './diskon'

const app = express();

app.engine('.hbs', engine({ extname: '.hbs' }));
app.set('view engine', '.hbs');
app.set('views', path.resolve(process.cwd(), 'templates'));

app.use('/auth', auth);
app.use('/mypay', mypay);
app.use('/testimoni', testimoni);
app.use('/diskon', diskon);

app.get('/', (_req, res) => res.render('main', { name: 'World' }));

app.listen(3000, () => console.log('http://localhost:3000'));
