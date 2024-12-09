import express from "express";
import client from "./db";
import { allowRoles } from "./auth";

const app = express.Router();

/**
 * This function is used to convert a string representing a number in rupiah into
 * a string with the correct formatting, e.g. "1000" will be converted into "1.000,00"
 * @param {string} str - The string to be converted
 * @return {string} The converted string
 */
function hargaToRupiah(str: string): string {
  return str.replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1.") + ",00";
}

/**
 * This route is used to fetch a subcategory page based on the provided subcategory id
 * It will fetch the description of the subcategory, the list of workers offering the subcategory, the sessions available for the subcategory, and the testimonies for the subcategory
 * The page will also show the option to join the subcategory for workers, and the option to book a session for customers
 * @param {string} id - The id of the subcategory
 */
app.get("/:id", async (req, res) => {
  try {
    const berhasil = req.cookies.berhasil == undefined ? false : req.cookies.berhasil == "true";
    const idsub = req.params.id;

    const desc = await client.query(`SELECT * FROM getDesc($1);`, [idsub]);
    const pekerja = await client.query(`SELECT * FROM getPekerja($1);`, [desc.rows[0].KatID]);
    const sesi = await client.query(`SELECT * FROM getSession($1);`, [idsub]);
    const testimoni = await client.query(`SELECT * FROM getTestimoni($1);`, [idsub]);

    const isPelanggan = req.userType === "pengguna";
    const isGuest = req.userType === "guest";
    var isWorkerAtKategori = false;
    
    pekerja.rows.forEach((row) => {
      const oid = row.Id as string || "";
      if (oid === req.userId) {
        isWorkerAtKategori = true;
      }
    });

    sesi.rows.forEach((row) => {
      row.Harga = hargaToRupiah(row.Harga);
    });

    const canJoin = !(isGuest || isPelanggan || isWorkerAtKategori);
    res.clearCookie("berhasil");
    res.render("subkategori/subkategori.hbs", {desc: desc.rows[0], sesi: sesi.rows, pekerja: pekerja.rows, testimoni: testimoni.rows, isPelanggan: isPelanggan, canJoin: canJoin, berhasil: berhasil});
  }
  catch (error) {
    console.error("Error fetching testimonies:", error);
    res.status(500).send("An error occurred while fetching testimonies.");
  }
});

/**
 * Route to handle joining a subcategory's category by a worker.
 * 
 * @route POST /:subId/:katId/join
 * @access Restricted to users with the 'pekerja' role.
 * 
 * @param {string} subId - The ID of the subcategory.
 * @param {string} katId - The ID of the category.
 * 
 * @middleware allowRoles(["pekerja"]) - Ensures that only users with the 'pekerja' role can access this route.
 * 
 * @returns Redirects to the subcategory page upon successful joining.
 *          Sets a 'berhasil' cookie to true for successful operation indication.
 *          Responds with a 500 status code and error message if an error occurs.
 */
app.post("/:subId/:katId/join", allowRoles(["pekerja"]), async (req, res) => {
  try {
    const katId = req.params.katId;
    const subId = req.params.subId;
    const userId = req.userId;
    await client.query(`SELECT insertPekerjaKategori($1, $2);`, [katId, userId]);

    res.cookie("berhasil", true);
    res.redirect(`/subkategori/${subId}`);
  }
  catch (error) {
    console.error("Error processing request:", error);
    res.status(500).send("An error occurred while processing the request.");
  }
});

/**
 * Route to render the order page for a specific subcategory and session.
 * 
 * @route GET /:id/:sesi
 * @access Restricted to users with the 'pengguna' role.
 * 
 * @param {string} id - The ID of the subcategory.
 * @param {string} sesi - The session ID of the service.
 * @param {string} d - The discount code to apply, if any.
 * 
 * @middleware allowRoles(["pengguna"]) - Ensures that only users with the 'pengguna' role can access this route.
 * 
 * @returns Renders the order page with the subcategory, session, and discount code information.
 *          If the discount code is invalid, displays an error message.
 *          If the discount code is valid, displays a success message.
 *          Responds with a 500 status code and error message if an error occurs.
 */
app.get("/:id/:sesi", allowRoles(['pengguna']), async (req, res) => {
  try {
    const kode = req.query.d as string || "";
    const userId = req.userId;
    const idsub = req.params.id;
    const sesi = req.params.sesi;

    const hargaQuery = await client.query(`SELECT * FROM getHargaSesi($1, $2);`, [idsub, sesi]);
    const diskonQuery = await client.query(`SELECT getDiskon($1 ,$2, $3);`, [userId, kode, hargaQuery.rows[0].gethargasesi]);
    const metodeBayar = await client.query(`SELECT * FROM "METODE_BAYAR";`);

    const harga = hargaQuery.rows[0].gethargasesi - diskonQuery.rows[0].getdiskon;
    const hargaDisplay = hargaToRupiah(harga.toString());

    const errorMessage = req.query.d != undefined && diskonQuery.rows[0].getdiskon == 0;
    const successMessage = req.query.d != undefined && diskonQuery.rows[0].getdiskon > 0;
    res.render("subkategori/pesan.hbs", {harga: harga, hargaDisplay: hargaDisplay, idsub: idsub, sesi: sesi, metodeBayar: metodeBayar.rows, kode: kode, errDiskon: errorMessage, sucDiskon: successMessage});
  } 
  catch (error) {
    console.error("Error processing request:", error);
    res.status(500).send("An error occurred while processing the request.");
  }
});

/**
 * @route POST /:id/:sesi
 * @access Restricted to users with the 'pengguna' role.
 * 
 * @param {string} id - The ID of the subcategory.
 * @param {string} sesi - The session ID of the service.
 * 
 * @description
 * This route handles the booking of a session within a specific subcategory. It calculates the price after applying any
 * applicable discounts and processes the transaction. Upon successful booking, the user is redirected to the /pemesanan page.
 * 
 * @middleware allowRoles(["pengguna"]) - Ensures that only users with the 'pengguna' role can access this route.
 * 
 * @body {string} tanggal - The booking date.
 * @body {string} diskon - The discount code, if any.
 * @body {string} bayar - The payment method.
 * 
 * @returns
 * - Redirects to the /pemesanan page upon successful booking.
 * - Updates the voucher usage count in the database.
 * - Responds with a 500 status code and error message if an error occurs.
 */
app.post("/:id/:sesi", allowRoles(['pengguna']), async (req, res) => {
  try {
    const userId = req.userId;
    const tanggal = req.body.tanggal;
    const idsub = req.params.id;
    const sesi = req.params.sesi;

    const hargaQuery = await client.query(`SELECT * FROM getHargaSesi($1, $2);`, [idsub, sesi]);
    const diskonQuery = await client.query(`SELECT getDiskon($1 ,$2, $3);`, [userId, req.body.diskon, hargaQuery.rows[0].gethargasesi]);

    const kode = diskonQuery.rows[0].getdiskon == 0 ? "" : req.body.diskon;
    const harga = hargaQuery.rows[0].gethargasesi - diskonQuery.rows[0].getdiskon;
    const metode = req.body.bayar;

    await client.query(
      `SELECT insertTransaksi(
        $1,
        $2,
        $3,
        $4,
        $5,
        $6,
        $7
      );`,
      [
        tanggal,
        harga,
        userId,
        idsub,
        sesi,
        kode,
        metode
      ]
    );

    await client.query(`SELECT updateVoucher($1, $2)`, [userId, kode]);
    res.redirect("/pemesanan");
  } 
  catch (error) {
    console.error("Error processing request:", error);
    res.status(500).send("An error occurred while processing the request.");
  }
});

/**
 * @description This route will redirect to subkategori page with diskon query
 *              parameter. If query parameter `d` is not provided, it will
 *              redirect to subkategori page without diskon query parameter.
 * @route GET /:id/:sesi/diskon
 * @param {string} id - id of subkategori
 * @param {string} sesi - number of sesi
 * @param {string} d - diskon code (optional)
 * @returns {Redirect} redirect to subkategori page with or without diskon
 *                     query parameter
 */
app.get("/:id/:sesi/diskon", (req, res) => {
  const id = req.params.id;
  const sesi = req.params.sesi;
  const kode = req.query.d;

  if (kode) {
    res.redirect(`/subkategori/${id}/${sesi}?d=${kode}`);
  }
  else {
    res.redirect(`/subkategori/${id}/${sesi}`);
  }
});


export default app;
