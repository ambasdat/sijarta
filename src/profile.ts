import express from "express";

const app = express.Router();

app.get("/pekerja", (req, res) => {
  res.render("profile/pekerja");
});

app.post("/pekerja", (req, res) => {
  console.log(req.body);
  res.redirect("/profile/pekerja");
});

app.get("/pengguna", (req, res) => {
  res.render("profile/pengguna");
});

app.post("/pengguna", (req, res) => {
  console.log(req.body);
  res.redirect("/profile/pengguna");
});

export default app;
