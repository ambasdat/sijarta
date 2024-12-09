import express from "express";
import client from "./db";

const app = express.Router();

/**
 * This function is used to parse query result for home page
 * @param {Array<Object>} query - The query result
 * @return {Array<Object>} The parsed query result
 */
function parseQueryForHome(query: Array<any>) {
  const result = [];
  const map : {[index: string]: number} = {};

  for (const row of query) {
    if (!map.hasOwnProperty(row.Kat)) {
      map[row.Kat] = result.length;
      const temp : Object[] = [];
      result.push({Kat: row.Kat, Sub: temp,});
    }
    
    result[map[row.Kat]].Sub.push({Sub: row.Sub, Id: row.Id});
  }

  return result;
}

/**
 * This function is used to handle GET request to home page
 * @param {Request} req - The request object
 * @param {Response} res - The response object
 */
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

export default app;

