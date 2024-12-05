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
    desc.rows[0].Sub = titleCase(desc.rows[0].Sub);
    desc.rows[0].Kat = titleCase(desc.rows[0].Kat);
    const isPelanggan = req.userType === "pengguna";
    res.render("subkategori/subkategori.hbs", {desc: desc.rows[0], isPelanggan: isPelanggan});
}
  catch (error) {
    console.error("Error fetching testimonies:", error);
    res.status(500).send("An error occurred while fetching testimonies.");
  }
});

export default app;
