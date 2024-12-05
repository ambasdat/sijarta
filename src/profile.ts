import express from "express";
import client from "./db";
import { allowRoles } from "./auth";

const app = express.Router();

app.get("/:userId", async (req, res) => {
  const userId = req.params.userId;

  const pekerja = await client.query(
    `SELECT * FROM "USER" u JOIN "PEKERJA" p ON p."Id" = u."Id" WHERE u."Id" = $1`,
    [userId]
  );

  if (pekerja.rowCount != null && pekerja.rowCount > 0) {
    const p = pekerja.rows[0];
    return res.render("profile/pekerja", {
      pekerja: p,
      isSelf: req.userId && p.Id === req.userId,
    });
  }

  const pelanggan = await client.query(
    `SELECT * FROM "USER" u JOIN "PELANGGAN" p ON p."Id" = u."Id" WHERE u."Id" = $1`,
    [userId]
  );

  if (pelanggan.rowCount != null && pelanggan.rowCount > 0) {
    const p = pelanggan.rows[0];
    return res.render("profile/pengguna", {
      pelanggan: p,
      isSelf: req.userId && p.Id === req.userId,
    });
  }

  return res.render("404");
})

app.post("/pekerja/:pekerjaId", allowRoles(['pekerja']), (req, res) => {
  const pekerjaId = req.params.pekerjaId;

  if (req.userId != pekerjaId) {
    return res.redirect("/home");
  }

  client.query(
    `SELECT update_profile_pekerja(
       $1::UUID,    -- pekerjaId
       $2::VARCHAR, -- nama
       $3::CHAR(1), -- jenis kelamin
       $4::VARCHAR, -- nomor hp
       $5::DATE,    -- tanggal lahir
       $6::VARCHAR, -- alamat
       $7::VARCHAR, -- nama bank
       $8::VARCHAR, -- nomor rekening
       $9::VARCHAR, -- npwp
       $10::VARCHAR -- link foto
     );`,
    [
      pekerjaId,
      req.body.nama,
      req.body.jenisKelamin,
      req.body.phone,
      req.body.dob,
      req.body.address,
      req.body.bank,
      req.body.norek,
      req.body.npwp,
      req.body.url,
    ]
  );

  res.redirect(`/profile/${pekerjaId}`);
});

app.post("/pengguna/:penggunaId", (req, res) => {
  const penggunaId = req.params.penggunaId;

  if (req.userId != penggunaId) {
    return res.redirect("/home");
  }

  client.query(
    `SELECT update_profile_pelanggan(
       $1::UUID,    -- pekerjaId
       $2::VARCHAR, -- nama
       $3::CHAR(1), -- jenis kelamin
       $4::VARCHAR, -- nomor hp
       $5::DATE,    -- tanggal lahir
       $6::VARCHAR  -- alamat
     );`,
    [
      penggunaId,
      req.body.nama,
      req.body.jenisKelamin,
      req.body.phone,
      req.body.dob,
      req.body.address,
    ]
  );

  res.redirect(`/profile/${penggunaId}`);
});

export default app;
