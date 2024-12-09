import express from "express";
import client from "./db";
import { format, addDays } from 'date-fns';  // Import date-fns for date manipulation


const app = express.Router();

app.get("/", async (req, res): Promise<void> => {
  try {
    // Fetch promos and vouchers
    const promosResult = await client.query(`SELECT * FROM get_promos();`);
    const vouchersResult = await client.query(`SELECT * FROM get_all_voucher_details($1::UUID);`, [req.userId]);
    const userVouchersResult = await client.query(`SELECT * FROM get_users_vouchers($1::UUID);`,  [req.userId]);

    // console.log(userVouchersResult)

    const promos = promosResult.rows;
    const userVouchers = userVouchersResult.rows;

    // Process each voucher to calculate tglHabis
    const vouchers = vouchersResult.rows.map((voucher) => {
      const jmlhariberlaku = voucher.jmlhariberlaku;  // Get JmlHariBerlaku (days)
      
      // Get the current date
      const currentDate = new Date();

      // Calculate tglHabis by adding JmlHariBerlaku days to the current date
      const tglHabis = addDays(currentDate, jmlhariberlaku);  // Add days

      // Return the updated voucher with calculated tglHabis
      return {
        ...voucher,
        tglHabis: tglHabis.toISOString().split('T')[0],  // Format as YYYY-MM-DD
      };
    });

    // Pass promos and vouchers (with tglHabis) to the template
    res.render("diskon/main", { promos, vouchers, userVouchers });
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