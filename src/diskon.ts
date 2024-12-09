import express from "express";
import client from "./db";
import { format, addDays } from 'date-fns';  // Import date-fns for date manipulation


const app = express.Router();

app.get("/", async (req, res): Promise<void> => {
  try {
    // Fetch promos and vouchers
    const promosResult = await client.query(`SELECT * FROM get_promos();`);
    const vouchersResult = await client.query(`SELECT * FROM get_all_voucher_details($1::UUID);`, [req.userId]);
    const userVouchersResult = await client.query(`SELECT * FROM get_users_vouchers($1::UUID);`, [req.userId]);

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
    const { userId, voucherCode, paymentMethod} = req.body;

    const voucherResult = await client.query("SELECT * FROM buy_voucher($1, $2, $3);", [
      userId,
      voucherCode,
      paymentMethod
    ]);

    res.status(200).json({ success: true, message: "Voucher purchased successfully." });
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
});

export default app;