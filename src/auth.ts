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

app.post("/register/pekerja", (req, res) => {
  const phoneExists = req.body.phone === "123";
  const bankExists = req.body.bank === "OVO" && req.body.norek === "123";
  const npwpExists = req.body.npwp === "123";

  if (phoneExists || bankExists || npwpExists)
    res.render("auth/register/pekerja", { phoneExists, bankExists, npwpExists })
  else
    res.redirect("/auth/login");
})

app.get("/register/pengguna", (req, res) => {
  res.render("auth/register/pengguna");
});

app.post("/register/pengguna", (req, res) => {
  if (req.body.phone === "123")
    res.render("auth/register/pengguna", { phoneExists: true })
  else
    res.redirect("/auth/login")
});

app.post("/logout", (req, res) => {
  res.redirect("/auth");
})

export default app;
