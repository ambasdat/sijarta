import express from 'express';

const app = express.Router();

app.get('/:userId', (req, res) => {
  if (req.params.userId === 'pekerja')
    res.render('profile/pekerja');
  else
    res.render('profile/pengguna');
})

export default app;
