import express from "express";
import client from "./db";

const app = express.Router();

app.get("/", async (req, res) => {
  try {
    // Retrieve userId (hardcoded for testing purposes)
    // const userId = req.params.userId
    const userId = '81ebf7b7-1ee3-4da4-b04c-4d1202460288';

    // // Query userDetails
    const userDetailsResult = await client.query("SELECT * FROM get_user_details($1)", [userId]);
    const userDetails = userDetailsResult.rows[0];

    // // Memastikan userDetails exists
    // if (!userDetails) {
    //   return res.status(404).send("User not found.");
    // }

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
  try{
    // Retrieve userId (hardcoded for testing purposes)
    // const userId = req.params.userId
    const userId = '81ebf7b7-1ee3-4da4-b04c-4d1202460288';

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

export default app;
