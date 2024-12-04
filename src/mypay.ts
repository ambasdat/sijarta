import express from "express";
import client from "./db";

const app = express.Router();

app.get("/", async (req, res) => {
  try {
    // Retrieve userId (hardcoded for testing purposes)
    // const userId = req.params.userId
    const userId = '64302ea1-212d-414c-a2db-1fad0b3c3b6e';

    // // Query userDetails
    const userDetailsResult = await client.query("SELECT * FROM get_user_details($1)", [userId]);
    const userDetails = userDetailsResult.rows[0];

    // // Query riwayat transaksi
    const transactionHistoryResult = await client.query("SELECT * FROM get_user_transactions($1)", [userId]);
    const transactionHistory = transactionHistoryResult.rows;

    // Render
    res.render("mypay/main", {
      userDetails,
      transactionHistory,
    });
  } catch (error) {
    console.error("Error fetching data:", error);
    res.status(500).send("Internal Server Error");
  }
});

app.get("/transaction", async (req, res) => {
  const message = req.query.message;
  console.log(message)

  try{
    // Retrieve userId (hardcoded for testing purposes)
    // const userId = req.params.userId
    const userId = '64302ea1-212d-414c-a2db-1fad0b3c3b6e';

    // Query userDetails
    const userDetailsResult = await client.query("SELECT * FROM get_user_details($1)", [userId]);
    const userDetails = userDetailsResult.rows[0];

    const nameParts = userDetails.Nama.split(" ");  // Split by spaces
    if (nameParts.length > 3) {
      // Split into first name and last name if there are more than 3 words
      userDetails.firstName = nameParts.slice(0, 2).join(" "); // First two words as first name
      userDetails.lastName = nameParts.slice(2).join(" ");  // Remaining words as last name
    } else {
      // If the name is 3 words or fewer, assign the whole name as firstName
      userDetails.firstName = userDetails.Nama;
      userDetails.lastName = '';  // Last name will be everything after the first name
    }

    const currentDate = `${(new Date()).getDate()} ${(new Date()).toLocaleString('en-US', { month: 'long' })} ${(new Date()).getFullYear()}`;

    // Render
    res.render("mypay/transaction",{
      userDetails,
      currentDate,
    });

  } catch(error) {
    console.error("Error fetching data:", error);
    res.status(500).send("Internal Server Error");
  }
});

app.post("/transaction/topup", async (req, res) => {
  const userId = '64302ea1-212d-414c-a2db-1fad0b3c3b6e';
  const topup_amount = req.body.topup_amount;
  let message = ""
  try{
    await client.query('SELECT handle_topup($1, $2)', [userId, topup_amount])
    message = "Success";
  } catch (error) {
    message = encodeURIComponent(error.message || 'Internal Server Error');
  }
  res.redirect(`/mypay/transaction?message=${message}`);
});

app.post("/transaction/pay", async (req, res) => {
  const topup_amount = req.body.topup_amount;
  console.log(topup_amount);
  res.redirect("/mypay/transaction");
});

app.post("/transaction/transfer", async (req, res) => {
  const userId = '64302ea1-212d-414c-a2db-1fad0b3c3b6e';
  const nohp = req.body.nohp;
  const tf_amount = req.body.tf_amount;
  let message = ""
  try{
    await client.query('SELECT handle_tf($1, $2, $3)', [userId, nohp, tf_amount]);
    message = "Success";
  } catch (error) {
    message = encodeURIComponent(error.message || 'Internal Server Error');
  }
  res.redirect(`/mypay/transaction?message=${message}`);
});

app.post("/transaction/withdraw", async (req, res) => {
  const bank = req.body.bank;
  const norek = req.body.norek;
  const wd_amount = req.body.wd_amount;
  console.log(bank);
  console.log(norek); 
  console.log(wd_amount);
  res.redirect("/mypay/transaction");
});

export default app;
