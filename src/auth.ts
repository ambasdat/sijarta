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

app.post("/register/pekerja", async (req, res) => {
  const rows = await client.query(
    `INSERT INTO "USER" ("Nama", "JenisKelamin", "NoHP", "Pwd", "TglLahir", "Alamat", "SaldoMyPay")
     VALUES ($1, $2, $3, $4, $5, $6, 0)
     RETURNING "Id"`,
    [req.body.nama, req.body.jenisKelamin, req.body.phone, req.body.password, req.body.dob, req.body.address]
  );

  await client.query(
    `INSERT INTO "PEKERJA" ("Id", "NamaBank", "NomorRekening", "NPWP", "LinkFoto")
     VALUES ($1, $2, $3, $4, $5)`,
    [rows.rows[0].Id, req.body.bank, req.body.norek, req.body.npwp, req.body.url]
  );

  res.redirect("/auth/login");
})

app.get("/register/pengguna", (req, res) => {
  res.render("auth/register/pengguna");
});

app.post("/register/pengguna", async (req, res) => {
  const rows = await client.query(
    `INSERT INTO "USER" ("Nama", "JenisKelamin", "NoHP", "Pwd", "TglLahir", "Alamat", "SaldoMyPay")
     VALUES ($1, $2, $3, $4, $5, $6, 0)
     RETURNING "Id"`,
    [req.body.nama, req.body.jenisKelamin, req.body.phone, req.body.password, req.body.dob, req.body.address]
  );

  await client.query(
    `INSERT INTO "PELANGGAN" ("Id", "Level") VALUES ($1, 0)`,
    [rows.rows[0].Id]
  );

  res.redirect("/auth/login")
});

app.post("/logout", (req, res) => {
  res.clearCookie("userid");
  res.redirect("/auth");
})

export default app;
