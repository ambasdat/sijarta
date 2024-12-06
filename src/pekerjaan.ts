import express from "express";
import client from "./db";
import { allowRoles } from "./auth";

const app = express.Router();

app.get("/", allowRoles(['pekerja']), async (req, res) => {
  try {
    const pekerjaId = req.userId;
    var kategori = req.query.kategori || null; // Get kategori dari query, null jika tidak ada
    var subkategori = req.query.subkategori || null; // Get subkategori dari query, null jika tidak ada
    const selectedKategori = kategori
    const selectedSubkategori = subkategori
    // If kategori = '0' set to semua
    if (kategori === '0'){kategori = null};
    if (subkategori === '0'){subkategori = null};

    const { rows: pekerjaKategori } = await client.query(
      "SELECT * FROM get_pekerja_category($1)",
      [pekerjaId]
    );
    
    const pekerjaKategoriDict = transformKategoriData(pekerjaKategori);
  
    const { rows: orderResult } = await client.query(
      "SELECT * FROM filter_pemesanan($1, $2, $3)",
      [pekerjaId, kategori, subkategori]
    );

    res.render("pekerjaan/main", {
      message: req.query.message || "",
      pekerjaKategoriDict,
      pekerjaKategoriDictJson: JSON.stringify(pekerjaKategoriDict),
      orderResult,
      selectedKategori,
      selectedSubkategori,
    });
  } catch(error) {
    console.error("Error fetching data:", error);
    res.status(500).send("Internal Server Error");
  }
});

app.post("/kerjakan", allowRoles(['pekerja']), async (req, res) => {
  try {
    const pekerjaId = req.userId;
    const { idtrpemesanan: idTrPemesanan } = req.body;

    await client.query(
      "SELECT handle_kerjakan_pesanan($1, $2)",
      [idTrPemesanan, pekerjaId]
    );
    res.redirect("/pekerjaan?message=Success");
  } catch (error) {
    console.error("Error:", error);
    res.status(500).send("Internal Server Error");
  }
});

app.get("/status", allowRoles(['pekerja']), async (req, res) => {
  try{
    const pekerjaId = req.userId;
    const searchQuery = req.query.searchQuery || '';
    const status = req.query.status || null;

    const { rows: statusResult } = await client.query(
      "SELECT * FROM filter_status($1, $2, $3)",
      [pekerjaId, searchQuery, status]
    );

    res.render("pekerjaan/status", {
      message: req.query.message || "",
      statusResult
    });
  } catch (error) {
    console.error("Error fetching data:", error);
    res.status(500).send("Internal Server Error");
  }
});

app.post("/status/update-status", allowRoles(['pekerja']), async (req, res) => {
  try {
    const pekerjaId = req.userId;
    const { idtrpemesanan: idTrPemesanan, idstatus: idStatus } = req.body;

    let nextIdStatus = ""
    switch (idStatus) {
      case "57fc8243-eb71-47a5-b74d-81fba6a94f82":
        nextIdStatus = "996980f3-cc47-4edb-a8cc-10ec02939479";
        break;
      case "996980f3-cc47-4edb-a8cc-10ec02939479":
        nextIdStatus = "1fe77476-1194-4de7-b7f9-72c8cdd3ef68";
        break;
      case "1fe77476-1194-4de7-b7f9-72c8cdd3ef68":
        nextIdStatus = "3d436422-152e-4b22-b978-49012b58e1f8";
        break
      case "":
        console.log("DATA DUMMY ERROR")
        nextIdStatus = "996980f3-cc47-4edb-a8cc-10ec02939479";
        break;
    }
    
    await client.query(
      'SELECT handle_update_status($1, $2)', 
      [idTrPemesanan, nextIdStatus]
    );

    res.redirect("/pekerjaan/status?message=Success");
  } catch (error) {
    console.error("Error:", error);
    res.status(500).send("Internal Server Error");
  }
});

export default app;

// ___________________ UTILITY FUNCTION ___________________

// Fungsi untuk reshape data kategori ke dalam bentuk map
const transformKategoriData = (data: any[]) => {
  return data.reduce((result: any[], item: { kid: any; kname: any; sname: string | number; sid: any; }) => {
    let existingKategori = result.find((category) => category.kid === item.kid);

    if (!existingKategori) {
      // Jika kategorinya belum ada buat entri baru
      existingKategori = {
        kid: item.kid,
        kname: item.kname,
        subkategori: {}, // Initialize subkategori
      };
      result.push(existingKategori);
    }

    // tambah subkategori ke kategori yang sudah ada
    existingKategori.subkategori[item.sname] = item.sid;

    return result;
  }, []);
};