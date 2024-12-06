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

    res.render("diskon/main", { promos, vouchers});
  } catch (error) {
    console.error("Error fetching promos and vouchers:", error);
    res.status(500).send("An error occurred while fetching discounts.");
  }
});

app.post("/buy-voucher", async (req, res): Promise<void> => {
  
  try {
    const { userId, voucherCode, paymentMethod } = req.body;
    
    const voucherQuery = `
      SELECT "Harga" FROM "VOUCHER" WHERE "Kode" = $1
    `;
    const voucherResult = await client.query(voucherQuery, [voucherCode]);

    if (voucherResult.rowCount === 0) {
      res.status(404).json({ error: "Voucher not found." });
      return;
    }

    const voucherPrice = voucherResult.rows[0].Harga;

    if (paymentMethod === "MyPay") {
      const userQuery = `
        SELECT "SaldoMyPay" FROM "USER" WHERE "Id" = $1::UUID
      `;
      const userResult = await client.query(userQuery, [userId]);

      if (userResult.rowCount === 0) {
        res.status(404).json({ error: "User not found. UserId = " + userId});
      }

      const userBalance = userResult.rows[0].SaldoMyPay;

      if (userBalance < voucherPrice) {
        res.status(400).json({ error: "Uang tidak cukup" });
        return;
      }

      const updateBalanceQuery = `
        UPDATE "USER"
        SET "SaldoMyPay" = "SaldoMyPay" - $1
        WHERE "Id" = $2::UUID
      `;
      await client.query(updateBalanceQuery, [voucherPrice, userId]);
    }

    res.status(200).json({ success: true, message: "Voucher purchased successfully." });
  } catch (error) {
    console.error("Error buying voucher:", error);
    res.status(500).json({ error: "An error occurred while processing your request." });
  }
});

export default app;
