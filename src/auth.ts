import express from "express";
import client from "./db";

const app = express.Router();

app.get("/", (req, res) => {
  res.render("auth/main");
});

app.get("/login", (req, res) => {
  res.render("auth/login");
});

app.post("/login", async (req, res) => {
  const query = await client.query(
    'SELECT * FROM "USER" WHERE "NoHP" = $1',
    [req.body.phone]
  );

  if (query.rowCount == 0) {
    return res.render("auth/login", { error: true });
  }

  const row = query.rows[0];

  if (row.Pwd != req.body.password) {
    return res.render("auth/login", { error: true });
  }

  res.cookie("userid", row.Id);

  res.redirect("/home");
});

app.get("/register", (req, res) => {
  res.render("auth/register/main");
});

app.get("/register/pekerja", (req, res) => {
  res.render("auth/register/pekerja");
});

app.post("/register/pekerja", (req, res) => {
  console.log(req.body);
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
  console.log(req.body);
  if (req.body.phone === "123")
    res.render("auth/register/pengguna", { phoneExists: true })
  else
    res.redirect("/auth/login")
});

app.post("/logout", (req, res) => {
  res.clearCookie("userid");
  res.redirect("/auth");
})

export default app;
