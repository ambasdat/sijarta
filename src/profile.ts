import express from "express";

const app = express.Router();

app.get("/pekerja/:pekerjaId", (req, res) => {
  res.render("profile/pekerja");
});

app.post("/pekerja/:pekerjaId", (req, res) => {
  console.log(req.body);
  res.redirect(`/profile/pekerja/${req.params.pekerjaId}`);
});

app.get("/pengguna/:penggunaId", (req, res) => {
  res.render("profile/pengguna");
});

app.post("/pengguna/:penggunaId", (req, res) => {
  console.log(req.body);
  res.redirect(`/profile/pengguna/${req.params.penggunaId}`);
});

export default app;
