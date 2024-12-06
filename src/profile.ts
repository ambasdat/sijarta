import express from "express";
import client from "./db";

const app = express.Router();

app.all("/:userId", async (req, res) => {
  const userId = req.params.userId;
  let error = null;

  if (req.method === 'POST') {
    if (req.userId != userId) {
      return res.redirect("/home");
    }

    if (req.userType === 'pekerja') {
      try {
        await client.query(
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
            userId,
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
      } catch (err: any) {
        error = err.message;
      }
    } else if (req.userType === 'pengguna') {
      try {
        await client.query(
          `SELECT update_profile_pelanggan(
             $1::UUID,    -- pekerjaId
             $2::VARCHAR, -- nama
             $3::CHAR(1), -- jenis kelamin
             $4::VARCHAR, -- nomor hp
             $5::DATE,    -- tanggal lahir
             $6::VARCHAR  -- alamat
           );`,
          [
            userId,
            req.body.nama,
            req.body.jenisKelamin,
            req.body.phone,
            req.body.dob,
            req.body.address,
          ]
        );
      } catch (err: any) {
        error = err.message;
      }
    } else {
      res.redirect('/auth');
    }
  }

  const pekerja = await client.query(
    `SELECT * FROM "USER" u JOIN "PEKERJA" p ON p."Id" = u."Id" WHERE u."Id" = $1`,
    [userId]
  );

  if (pekerja.rowCount != null && pekerja.rowCount > 0) {
    const p = pekerja.rows[0];
    return res.render("profile/pekerja", {
      pekerja: p,
      error,
      isError: !!error,
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
      error,
      isError: !!error,
      isSelf: req.userId && p.Id === req.userId,
    });
  }

  return res.render("404");
})

export default app;
