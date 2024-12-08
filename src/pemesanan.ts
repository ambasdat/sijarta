import express from "express";
import { allowRoles } from "./auth";
import client from "./db";

const app = express.Router();

function titleCase(str: string): string {
  return str.split(' ').map(word => word.charAt(0).toUpperCase() + word.slice(1).toLowerCase()).join(' ');
}

function hargaToRupiah(str: string): string {
  return str.replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1.") + ",00";
}

app.get("/", allowRoles(["pengguna"]) , async (req, res) => {
  try {
    const berhasilBatal = req.cookies.berhasil == undefined ? false : req.cookies.berhasil == "true";
    const userId = req.userId;
    const k = req.query.k as string || "";
    const s = req.query.s as string || "";
    const data = await client.query(`SELECT * FROM getPemesanan($1, $2, $3);`, [userId, k, s]);
    const sub = await client.query(`SELECT "NamaSubkategori" FROM "SUBKATEGORI_JASA";`);
    const status = await client.query(`SELECT "Status" FROM "STATUS_PESANAN"`);

    data.rows.forEach(async (row) => {
      row.NamaSubkategori = titleCase(row.NamaSubkategori);
      row.TotalBiaya = hargaToRupiah(row.TotalBiaya);
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

    res.clearCookie("berhasil");
    res.render("pemesanan/main", {data: data.rows, sub: sub.rows, status: status.rows, isMes: berhasilBatal});
  }
  catch (error) {
    console.error(error);
    res.status(500).send("An error occurred while fetching data.");
  }
});

app.get("/nyoba", async (req, res) => {
  try {
    const berhasilBatal = req.cookies.berhasil == undefined ? false : req.cookies.berhasil == "true";
    const userId = '81ebf7b7-1ee3-4da4-b04c-4d1202460288';
    const k = req.query.k as string || "";
    const s = req.query.s as string || "";
    const data = await client.query(`SELECT * FROM getPemesanan($1, $2, $3);`, [userId, k, s]);
    const sub = await client.query(`SELECT "NamaSubkategori" FROM "SUBKATEGORI_JASA";`);
    const status = await client.query(`SELECT "Status" FROM "STATUS_PESANAN"`);

    data.rows.forEach(async (row) => {
      row.NamaSubkategori = titleCase(row.NamaSubkategori);
      row.TotalBiaya = hargaToRupiah(row.TotalBiaya);
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

    res.clearCookie("berhasil");
    res.render("pemesanan/main", {data: data.rows, sub: sub.rows, status: status.rows, isMes: berhasilBatal});
  }
  catch (error) {
    console.error(error);
    res.status(500).send("An error occurred while fetching data.");
  }
});

app.post("/batal/:id", allowRoles(["pengguna"]), async (req, res) => {
  try {
    const id = req.params.id;
    await client.query(`SELECT batalPesan($1);`, [id]);
    res.cookie("berhasil", true);
    res.redirect("/pemesanan");
  }
  catch (error) {
    console.error(error);
    res.status(500).send("An error occurred while fetching data.");
  }
});

export default app;
