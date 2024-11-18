import express from "express";

const app = express.Router();

app.get("/pengguna", (req, res) => {
  res.render("subkategori/pengguna.hbs");
});

app.get("/pekerja", (req, res) => {
  res.render("subkategori/pekerja.hbs");
});

export default app;
