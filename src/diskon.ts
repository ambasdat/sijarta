import express from "express";
import client from "./db";

const app = express.Router();

app.get("/", async (req, res): Promise<void> => {
  try {
    const promosQuery = `
      SELECT P."Kode", P."TglAkhirBerlaku"
      FROM "PROMO" P
      JOIN "DISKON" D ON P."Kode" = D."Kode"
    `;
    const promosResult = await client.query(promosQuery);

    const vouchersQuery = `
      SELECT 
        V."Kode",
        D."Potongan",
        D."MinTrPemesanan",
        V."JmlHariBerlaku",
        V."KuotaPenggunaan",
        V."Harga"
      FROM "VOUCHER" V
      JOIN "DISKON" D ON V."Kode" = D."Kode"
    `;
    const vouchersResult = await client.query(vouchersQuery);

    const promos = promosResult.rows;
    const vouchers = vouchersResult.rows;

    res.render("diskon/main", { promos, vouchers });
  } catch (error) {
    console.error("Error fetching promos and vouchers:", error);
    res.status(500).send("An error occurred while fetching discounts.");
  }
});

export default app;
