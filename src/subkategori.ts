import express from "express";
import client from "./db";

const app = express.Router();

function titleCase(str: string): string {
  return str.split(' ').map(word => word.charAt(0).toUpperCase() + word.slice(1).toLowerCase()).join(' ');
}

app.get("/pengguna", (req, res) => {
  res.render("subkategori/pengguna.hbs");
});

app.get("/pekerja", (req, res) => {
  res.render("subkategori/pekerja.hbs");
});

app.get("/:id", async (req, res) => {
  try {
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
    const canJoin = !(isGuest || isPelanggan || isWorkerAtKategori);
    res.render("subkategori/subkategori.hbs", {desc: desc.rows[0], sesi: sesi.rows, pekerja: pekerja.rows, testimoni: testimoni.rows, isPelanggan: isPelanggan, canJoin: canJoin});
}
  catch (error) {
    console.error("Error fetching testimonies:", error);
    res.status(500).send("An error occurred while fetching testimonies.");
  }
});

export default app;
