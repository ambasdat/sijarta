import express from "express";
import client from "./db";
import { allowRoles } from "./auth";

const app = express.Router();

app.get("/", allowRoles(['pekerja']), async (req, res) => {
  try {
    const pekerjaId = req.userId;
    const kategori = req.query.kategori || null; // Get kategori dari query, null jika tidak ada
    const subkategori = req.query.subkategori || null; // Get subkategori dari query, null jika tidak ada
    const selectedKategori = kategori
    const selectedSubkategori = subkategori
    console.log(kategori);
    console.log(subkategori);

    const { rows: pekerjaKategori } = await client.query(
      "SELECT * FROM get_pekerja_category($1)",
      [pekerjaId]
    );
    
    const pekerjaKategoriDict = transformKategoriData(pekerjaKategori);
  
    const { rows: orderResultRaw } = await client.query(
      "SELECT * FROM filter_pemesanan($1, $2, $3)",
      [pekerjaId, kategori, subkategori]
    );

    const orderResult = orderResultRaw.map(order => ({
      ...order,
      totalbiaya: formatCurrency(Number(order.totalbiaya)),
    }));

    res.render("pekerjaan/main", {
      message: req.query.message || "",
      selectedKategori,
      selectedSubkategori,
      pekerjaKategoriDict,
      pekerjaKategoriDictJson: JSON.stringify(pekerjaKategoriDict),
      orderResult,
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
    const searchKeyword = req.query.searchKeyword || '';
    const searchStatus = req.query.searchStatus || null;

    const { rows: statusResultRaw } = await client.query(
      "SELECT * FROM filter_status($1, $2, $3)",
      [pekerjaId, searchKeyword, searchStatus]
    );

    const statusResult = statusResultRaw.map(order => ({
      ...order,
      totalbiaya: formatCurrency(Number(order.totalbiaya)),
    }));
    
    res.render("pekerjaan/status", {
      message: req.query.message || "",
      searchKeyword,
      searchStatus,
      statusResult,
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
        // nextIdStatus = "996980f3-cc47-4edb-a8cc-10ec02939479";
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

const formatCurrency = (amount: number) => {
  return amount.toLocaleString("id-ID");
};
