import express from "express";

const app = express.Router();

app.get("/", (req, res) => {
  res.render("auth/main");
});

app.get("/login", (req, res) => {
  res.render("auth/login");
});

app.post("/login", (req, res) => {
  if (req.body.phone == "123" && req.body.password == "123")
    res.redirect("/home")
  else
    res.render("auth/login", { error: true });
});

app.get("/register", (req, res) => {
  res.render("auth/register/main");
});

app.get("/register/pekerja", (req, res) => {
  res.render("auth/register/pekerja");
});

app.get("/register/pengguna", (req, res) => {
  res.render("auth/register/pengguna");
});

app.post("/logout", (req, res) => {
  res.redirect("/auth");
})

export default app;
