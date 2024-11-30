import express from "express";
import client from "./db";

const app = express.Router();

app.get("/", (_, res) => {
  res.render("auth/main");
});

app.get("/login", (_, res) => {
  res.render("auth/login");
});

app.post("/login", async (req, res) => {
  try {
    const query = await client.query(
      'SELECT login($1::VARCHAR, $2::VARCHAR)',
      [req.body.phone, req.body.password]
    );

    res.cookie("userid", query.rows[0].login);
    res.redirect("/home");
  } catch (err: any) {
    res.render("auth/login", {
      error: true,
      message: err.message,
    });
  }
});

app.get("/register", (_, res) => {
  res.render("auth/register/main");
});

app.get("/register/pekerja", (_, res) => {
  res.render("auth/register/pekerja");
});

app.post("/register/pekerja", async (req, res) => {
  try {
    await client.query(
      `SELECT insert_pekerja(
         $1::VARCHAR, -- nama
         $2::CHAR(1), -- jenis kelamin
         $3::VARCHAR, -- nomor hp
         $4::VARCHAR, -- password
         $5::DATE,    -- tanggal lahir
         $6::VARCHAR, -- alamat
         $7::VARCHAR, -- nama bank
         $8::VARCHAR, -- nomor rekening
         $9::VARCHAR, -- npwp
         $10::VARCHAR -- link foto
       );`,
      [
        req.body.nama,
        req.body.jenisKelamin,
        req.body.phone,
        req.body.password,
        req.body.dob,
        req.body.address,
        req.body.bank,
        req.body.norek,
        req.body.npwp,
        req.body.url,
      ]
    );

    res.redirect("/auth/login");
  } catch (err: any) {
    res.render("auth/register/pekerja", {
      error: true,
      message: err.message,
    });
  }
})

app.get("/register/pengguna", (_, res) => {
  res.render("auth/register/pengguna");
});

app.post("/register/pengguna", async (req, res) => {
  try {
    await client.query(
      `SELECT insert_pelanggan(
         $1::VARCHAR, -- nama 
         $2::CHAR(1), -- jk 
         $3::VARCHAR, -- nohp 
         $4::VARCHAR, -- pwd 
         $5::DATE,    -- tglLahir 
         $6::VARCHAR  -- alamat 
       );`,
      [
        req.body.nama,
        req.body.jenisKelamin,
        req.body.phone,
        req.body.password,
        req.body.dob,
        req.body.address,
      ]
    );

    res.redirect("/auth/login")
  } catch (err: any) {
    res.render("auth/register/pengguna", {
      error: true,
      message: err.message,
    });
  }
});

app.post("/logout", (_, res) => {
  res.clearCookie("userid");
  res.redirect("/auth");
})

export default app;
