import express from "express";
import { allowRoles } from "./auth";
import client from "./db";

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
 * This route is used to show the list of all pemesanan made by the user.
 * The user can filter the result by subkategori and status.
 * The user can also cancel the pemesanan if the status is 'Menunggu Pembayaran' or 'Mencari Pekerja Terdekat'.
 * If the status is 'Pesanan selesai', the user can make a testimoni.
 * The user can also view the detail of each pemesanan.
 * @param {string} k - The subkategori to be filtered
 * @param {string} s - The status to be filtered
 * @param {boolean} berhasilBatal - Whether the user has successfully canceled the pemesanan
 */
app.get("/", allowRoles(["pengguna"]) , async (req, res) => {
  try {
    const berhasilBatal = req.cookies.berhasil == undefined ? false : req.cookies.berhasil == "true";
    const userId = req.userId;
    const k = req.query.k as string || "";
    const s = req.query.s as string || "";

    const data = await client.query(`SELECT * FROM getPemesanan($1, $2, $3);`, [userId, k, s]);
    const sub = await client.query(`SELECT "NamaSubkategori" FROM "SUBKATEGORI_JASA";`);
    const status = await client.query(`SELECT "Status" FROM "STATUS_PESANAN"`);

    data.rows.forEach(async (row) => {
      row.TotalBiaya = hargaToRupiah(row.TotalBiaya);
      row.canBatal = row.Status === 'Menunggu Pembayaran' || row.Status === 'Mencari Pekerja Terdekat';
      row.canTestimoni = row.Status === 'Pesanan selesai';
      if (row.canTestimoni) {
        const exist = await client.query(`SELECT * FROM existTestimoni($1);`, [row.Id]);
        row.canTestimoni = !exist.rows[0].existtestimoni;
      }
      row.canDelete = row.Status === 'Pesanan selesai' && !row.canTestimoni;
    });

    res.clearCookie("berhasil");
    res.render("pemesanan/main", {data: data.rows, sub: sub.rows, status: status.rows, isMes: berhasilBatal});
  }
  catch (error) {
    console.error(error);
    res.status(500).send("An error occurred while fetching data.");
  }
});


/**
 * This route is used to cancel a pemesanan
 * @param {string} id - The id of the pemesanan to be canceled
 * @return {Promise<void>}
 */
app.post("/batal/:id", allowRoles(["pengguna"]), async (req, res) => {
  try {
    const id = req.params.id;
    await client.query(`SELECT batalPesan($1);`, [id]);

    res.cookie("berhasil", true);
    res.redirect("/pemesanan");
  }
  catch (error) {
    console.error(error);
    res.status(500).send("An error occurred while fetching data.");
  }
});

export default app;
