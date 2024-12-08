import express from "express";
import client from "./db";
import { allowRoles } from "./auth";

const app = express.Router();

function titleCase(str: string): string {
  return str.split(' ').map(word => word.charAt(0).toUpperCase() + word.slice(1).toLowerCase()).join(' ');
}

function hargaToRupiah(str: string): string {
  return str.replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1.") + ",00";
}

app.get("/pengguna", (req, res) => {
  res.render("subkategori/pengguna.hbs");
});

app.get("/pekerja", (req, res) => {
  res.render("subkategori/pekerja.hbs");
});

app.get("/:id", async (req, res) => {
  try {
    const berhasil = req.cookies.berhasil == undefined ? false : req.cookies.berhasil == "true";
    const idsub = req.params.id;
    const desc = await client.query(`SELECT * FROM getDesc($1);`, [idsub]);
    const pekerja = await client.query(`SELECT * FROM getPekerja($1);`, [desc.rows[0].KatID]);
    const sesi = await client.query(`SELECT * FROM getSession($1);`, [idsub]);
    const testimoni = await client.query(`SELECT * FROM getTestimoni($1);`, [idsub]);
    desc.rows[0].Sub = titleCase(desc.rows[0].Sub);
    desc.rows[0].Kat = titleCase(desc.rows[0].Kat);
    const isPelanggan = req.userType === "pengguna";
    const isGuest = req.userType === "guest";
    var isWorkerAtKategori = false;
    pekerja.rows.forEach((row) => {
      const oid = row.Id as string || "";
      if (oid === req.userId) {
        isWorkerAtKategori = true;
      }
    });
    sesi.rows.forEach((row) => {
      row.Harga = hargaToRupiah(row.Harga);
    });
    const canJoin = !(isGuest || isPelanggan || isWorkerAtKategori);

    res.clearCookie("berhasil");
    res.render("subkategori/subkategori.hbs", {desc: desc.rows[0], sesi: sesi.rows, pekerja: pekerja.rows, testimoni: testimoni.rows, isPelanggan: isPelanggan, canJoin: canJoin, berhasil: berhasil});
  }
  catch (error) {
    console.error("Error fetching testimonies:", error);
    res.status(500).send("An error occurred while fetching testimonies.");
  }
});

app.get("/:id/:sesi", allowRoles(['pengguna']), async (req, res) => {
  try {
    const kode = req.query.d as string || "";
    const userId = req.userId;
    const idsub = req.params.id;
    const sesi = req.params.sesi;
    const hargaQuery = await client.query(`SELECT * FROM getHargaSesi($1, $2);`, [idsub, sesi]);
    const diskonQuery = await client.query(`SELECT getDiskon($1 ,$2, $3);`, [userId, kode, hargaQuery.rows[0].gethargasesi]);
    const metodeBayar = await client.query(`SELECT * FROM "METODE_BAYAR";`);
    const harga = hargaQuery.rows[0].gethargasesi - diskonQuery.rows[0].getdiskon;
    const hargaDisplay = hargaToRupiah(harga.toString());
    res.render("subkategori/pesan.hbs", {harga: harga, hargaDisplay: hargaDisplay, idsub: idsub, sesi: sesi, metodeBayar: metodeBayar.rows, kode: kode, errDiskon: req.query.d != undefined && diskonQuery.rows[0].getdiskon == 0});
  } 
  catch (error) {
    console.error("Error processing request:", error);
    res.status(500).send("An error occurred while processing the request.");
  }
});

app.post("/:id/:sesi", allowRoles(['pengguna']), async (req, res) => {
  try {
    const userId = req.userId;
    const tanggal = req.body.tanggal;
    const idsub = req.params.id;
    const sesi = req.params.sesi;
    const hargaQuery = await client.query(`SELECT * FROM getHargaSesi($1, $2);`, [idsub, sesi]);
    const diskonQuery = await client.query(`SELECT getDiskon($1 ,$2, $3);`, [userId, req.body.diskon, hargaQuery.rows[0].gethargasesi]);
    const kode = diskonQuery.rows[0].getdiskon == 0 ? "" : req.body.diskon;
    const harga = hargaQuery.rows[0].gethargasesi - diskonQuery.rows[0].getdiskon;
    const metode = req.body.bayar;
    await client.query(
      `SELECT insertTransaksi(
        $1,
        $2,
        $3,
        $4,
        $5,
        $6,
        $7
      );`,
      [
        tanggal,
        harga,
        userId,
        idsub,
        sesi,
        kode,
        metode
      ]
    );
    await client.query(`SELECT updateVoucher($1, $2)`, [userId, kode]);
    res.redirect("/pemesanan");
  } 
  catch (error) {
    console.error("Error processing request:", error);
    res.status(500).send("An error occurred while processing the request.");
  }
});

app.get("/:id/:sesi/diskon", (req, res) => {
  const id = req.params.id;
  const sesi = req.params.sesi;
  const kode = req.query.d;
  res.redirect(`/subkategori/${id}/${sesi}?d=${kode}`);
});

app.post("/:subId/:katId/join", allowRoles(["pekerja"]), async (req, res) => {
  try {
    const katId = req.params.katId;
    const subId = req.params.subId;
    const userId = req.userId;
    await client.query(`SELECT insertPekerjaKategori($1, $2);`, [katId, userId]);
    res.cookie("berhasil", true);
    res.redirect(`/subkategori/${subId}`);
  }
  catch (error) {
    console.error("Error processing request:", error);
    res.status(500).send("An error occurred while processing the request.");
  }
});

export default app;
