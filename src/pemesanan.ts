import express from "express";
import { allowRoles } from "./auth";
import client from "./db";

const app = express.Router();

function titleCase(str: string): string {
  return str.split(' ').map(word => word.charAt(0).toUpperCase() + word.slice(1).toLowerCase()).join(' ');
}

app.get("/", allowRoles(["pengguna"]) , async (req, res) => {
  try {
    const userId = req.userId;
    const k = req.query.k as string || "";
    const s = req.query.s as string || "";
    const data = await client.query(`SELECT * FROM getPemesanan($1, $2, $3);`, [userId, k, s]);
    const sub = await client.query(`SELECT "NamaSubkategori" FROM "SUBKATEGORI_JASA";`);
    const status = await client.query(`SELECT "Status" FROM "STATUS_PESANAN"`);

    data.rows.forEach(async (row) => {
      row.NamaSubkategori = titleCase(row.NamaSubkategori);
      row.canBatal = row.Status === 'Menunggu Pembayaran' || row.Status === 'Mencari Pekerja Terdekat';
      row.canTestimoni = row.Status === 'Pesanan selesai';
      if (row.canTestimoni) {
        const exist = await client.query(`SELECT * FROM existTestimoni($1);`, [row.Id]);
        row.canTestimoni = !exist.rows[0].existtestimoni;
      }
    });
    sub.rows.forEach((row) => {
      row.display = titleCase(row.NamaSubkategori);
    });

    res.render("pemesanan/main", {data: data.rows, sub: sub.rows, status: status.rows});
  }
  catch (error) {
    console.error(error);
    res.status(500).send("An error occurred while fetching data.");
  }
});

app.get("/nyoba", async (req, res) => {
  try {
    const userId = 'de19a8b8-df16-426e-86d4-28e6fa75d95c';
    const k = req.query.k as string || "";
    const s = req.query.s as string || "";
    const data = await client.query(`SELECT * FROM getPemesanan($1, $2, $3);`, [userId, k, s]);
    const sub = await client.query(`SELECT "NamaSubkategori" FROM "SUBKATEGORI_JASA";`);
    const status = await client.query(`SELECT "Status" FROM "STATUS_PESANAN"`);

    data.rows.forEach(async (row) => {
      row.NamaSubkategori = titleCase(row.NamaSubkategori);
      row.canBatal = row.Status === 'Menunggu Pembayaran' || row.Status === 'Mencari Pekerja Terdekat';
      row.canTestimoni = row.Status === 'Pesanan selesai';
      if (row.canTestimoni) {
        const exist = await client.query(`SELECT * FROM existTestimoni($1);`, [row.Id]);
        row.canTestimoni = !exist.rows[0].existtestimoni;
      }
    });
    sub.rows.forEach((row) => {
      row.display = titleCase(row.NamaSubkategori);
    });

    res.render("pemesanan/main", {data: data.rows, sub: sub.rows, status: status.rows});
  }
  catch (error) {
    console.error(error);
    res.status(500).send("An error occurred while fetching data.");
  }
});

export default app;
