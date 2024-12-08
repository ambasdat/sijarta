import express from "express";
import client from "./db";
import { allowRoles } from "./auth";

const app = express.Router();

app.get("/", allowRoles(['pekerja', 'pengguna']), async (req, res) => {
  try {
    const userId = req.userId;

    const { rows: userDetailsRaw } = await client.query(
      "SELECT * FROM get_user_details($1)",
      [userId]
    );

    let userDetails = {
      ...userDetailsRaw[0],
      ...processNameParts(userDetailsRaw[0].Nama),
    };

    // Format SaldoMyPay in userDetails
    userDetails = {
      ...userDetails,
      SaldoMyPay: formatCurrency(Number(userDetails.SaldoMyPay)), // Format SaldoMyPay field
    };

    const { rows: transactionHistoryRaw } = await client.query(
      "SELECT * FROM get_user_transactions($1)",
      [userId]
    );

    const transactionHistory = transactionHistoryRaw.map(transaction => ({
      ...transaction,
      Nominal: formatCurrency(Number(transaction.Nominal)),
    }));

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
    const isPengguna = req.userType === "pengguna";

    const { rows: userDetailsRaw} = await client.query(
      "SELECT * FROM get_user_details($1)", 
      [userId]
    );

    // USER DETAILS DATA
    let userDetails = {
      ...userDetailsRaw[0],
      ...processNameParts(userDetailsRaw[0].Nama),
    };
    userDetails = {
      ...userDetails,
      SaldoMyPay: formatCurrency(Number(userDetails.SaldoMyPay)),
    };

    // USER ORDERS DATA
    let userOrder;  // Initialize userOrder here
    if (isPengguna) {
      const { rows: userOrderResult } = await client.query(
        "SELECT * FROM get_user_order($1)",
        [userId]
      );
      userOrder = userOrderResult.map(order => ({
        ...order,
        totalbiaya: formatCurrency(Number(order.totalbiaya))
      }));
    } else {
      userOrder = null;
    }

    res.render("mypay/transaction",{
      isPengguna,
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
    const { serviceOrder: idTrPemesanan } = req.body;

    await client.query(
      'SELECT handle_payment($1, $2)',
      [userId, idTrPemesanan]
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

const formatCurrency = (amount: number) => {
  return amount.toLocaleString("id-ID");
};