import express from "express";
import client from "./db";
import { allowRoles } from "./auth";

const app = express.Router();

app.get("/", allowRoles(['pekerja', 'pengguna']), async (req, res) => {
  try {
    const userId = req.userId;

    const { rows: userDetailsResult } = await client.query(
      "SELECT * FROM get_user_details($1)",
      [userId]
    );
    const userDetails = userDetailsResult[0];

    const { rows: transactionHistory } = await client.query(
      "SELECT * FROM get_user_transactions($1)",
      [userId]
    );

    res.render("mypay/main", {
      userDetails,
      transactionHistory,
    });
  } catch (error) {
    console.error("Error fetching data:", error);
    res.status(500).send("Internal Server Error");
  }
});

app.get("/transaction", allowRoles(['pekerja', 'pengguna']), async (req, res) => {
  try{
    const userId = req.userId;
    const message = req.query.message || "";

    const { rows: userDetailsResult} = await client.query(
      "SELECT * FROM get_user_details($1)", 
      [userId]
    );
    const userDetails = {
      ...userDetailsResult[0],
      ...processNameParts(userDetailsResult[0].Nama),
    };

    const { rows: userOrder } = await client.query(
      "SELECT * FROM get_user_order($1)",
      [userId]
    );
    
    res.render("mypay/transaction",{
      isPengguna: req.userType === "pengguna",
      message,
      userDetails,
      userOrder,
      currentDate: `${(new Date()).getDate()} ${(new Date()).toLocaleString('en-US', { month: 'long' })} ${(new Date()).getFullYear()}`,
    });
  } catch(error) {
    console.error("Error fetching data:", error);
    res.status(500).send("Internal Server Error");
  }
});

app.post("/transaction/topup", allowRoles(['pekerja', 'pengguna']), async (req, res) => {
  let message = ""
  
  try{
    const userId = req.userId;
    const topup_amount = req.body.topup_amount;

    await client.query(
      'SELECT handle_topup($1, $2)',
      [userId, topup_amount]
    );
    message = "Success";
  } catch (error) {
    message = encodeURIComponent(error.message || 'Internal Server Error');
  }
  res.redirect(`/mypay/transaction?message=${message}`);
});

app.post("/transaction/pay", allowRoles(['pengguna']), async (req, res) => {
  let message = "";
  
  try{
    const userId = req.userId;

    const { serviceOrder: serviceOrder } = req.body;
    const [idTrPemesanan, totalAmount] = serviceOrder.split(',');

    await client.query(
      'SELECT handle_payment($1, $2, $3)',
      [userId, idTrPemesanan, totalAmount]
    );
    message = "Success";
  } catch (error) {
    message = encodeURIComponent(error.message || 'Internal Server Error');
  }
  res.redirect(`/mypay/transaction?message=${message}`);
});

app.post("/transaction/transfer", allowRoles(['pekerja', 'pengguna']), async (req, res) => {
  let message = ""
  
  try{
    const userId = req.userId;
    const nohp = req.body.nohp;
    const tf_amount = req.body.tf_amount;

    await client.query(
      'SELECT handle_transfer($1, $2, $3)',
      [userId, nohp, tf_amount]
    );
    message = "Success";
  } catch (error) {
    message = encodeURIComponent(error.message || 'Internal Server Error');
  }

  res.redirect(`/mypay/transaction?message=${message}`);
});

app.post("/transaction/withdraw", allowRoles(['pekerja', 'pengguna']), async (req, res) => {
  let message = "";
  
  try{
    const userId = req.userId;

    const { wd_amount: wdAmount } = req.body;

    await client.query(
      'SELECT handle_withdraw($1, $2)',
      [userId, wdAmount]
    );
    message = "Success";
  } catch (error) {
    message = encodeURIComponent(error.message || 'Internal Server Error');
  }
  res.redirect(`/mypay/transaction?message=${message}`);
});

export default app;

// ____________________________ UTILITY FUNCTION ____________________________

function processNameParts(fullName: string) {
  const nameParts = fullName.split(" ")
  let firstName, lastName;

  if (nameParts.length > 3) {
    firstName = nameParts.slice(0, 2).join(" ");
    lastName = nameParts.slice(2).join(" ");
  } else {
    firstName = fullName;
    lastName = "";
  }

  return { firstName, lastName };
}