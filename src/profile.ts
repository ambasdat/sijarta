import express from "express";
import client from "./db";

const app = express.Router();

app.get("/:userId", async (req, res) => {
  const userId = req.params.userId;

  const pekerja = await client.query(`SELECT * FROM "PEKERJA" WHERE "Id" = $1`, [userId]);

  if (pekerja.rowCount != null && pekerja.rowCount > 0) {
    return res.render("profile/pekerja");
  }

  const pelanggan = await client.query(`SELECT * FROM "PELANGGAN" WHERE "Id" = $1`, [userId]);

  if (pelanggan.rowCount != null && pelanggan.rowCount > 0) {
    return res.render("profile/pengguna");
  }

  return res.render("404");
})

app.post("/pekerja/:pekerjaId", (req, res) => {
  console.log(req.body);
  res.redirect(`/profile/pekerja/${req.params.pekerjaId}`);
});

app.post("/pengguna/:penggunaId", (req, res) => {
  console.log(req.body);
  res.redirect(`/profile/pengguna/${req.params.penggunaId}`);
});

export default app;
