import express from "express";
import { Request, Response, NextFunction } from "express";

import client from "./db";
import { allowRoles } from "./auth";

const app = express.Router();

function titleCase(str: string): string {
  return str.split(' ').map(word => word.charAt(0).toUpperCase() + word.slice(1).toLowerCase()).join(' ');
}

function parseQueryForHome(query: Array<any>) {
  const result = [];
  const map : {[index: string]: number} = {};
  for (const row of query) {
    if (!map.hasOwnProperty(row.Kat)) {
      map[row.Kat] = result.length;
      const temp : Object[] = [];
      result.push({Kat: row.Kat, Sub: temp,});
    }
    result[map[row.Kat]].Sub.push({Sub: titleCase(row.Sub), Id: row.Id});
  }

  return result;
}

app.get("/", async (req, res) => {
  try {
    const s = req.query.s as string || "";
    const k = req.query.k as string || "";
    const result = await client.query(`SELECT * FROM getAllForHome($1, $2);`, [s, k]);
    const NamaKategori = await client.query(`SELECT "NamaKategori" FROM "KATEGORI_JASA";`);
    const data = parseQueryForHome(result.rows);
    res.render("home/home.hbs", {data: data, NamaKategori: NamaKategori.rows});
  } 
  catch (error) {
    console.error(error);
    res.status(500).send("An error occurred while fetching data.");
  }
});

app.get("/nyoba", async (req, res) => {
  try {
    const s = req.query.s as string || "";
    const k = req.query.k as string || "";
    const result = await client.query(`SELECT * FROM getAllForHome($1, $2);`, [s, k]);
    const NamaKategori = await client.query(`SELECT "NamaKategori" FROM "KATEGORI_JASA";`);
    const data = parseQueryForHome(result.rows);
    // const isGuest = req.userType === "guest";
    const isGuest = false;
    res.render("home/home.hbs", {data: data, guest: isGuest, NamaKategori: NamaKategori.rows});
  } 
  catch (error) {
    console.error(error);
    res.status(500).send("An error occurred while fetching data.");
  }
});

export default app;
