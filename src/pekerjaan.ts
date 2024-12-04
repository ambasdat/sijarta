import express from "express";
import client from "./db";

const app = express.Router();

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


app.get("/", async (req, res) => {
  const pekerjaId = '196b292e-d564-4508-94ce-f049e07e8688';
  var kategori = req.query.kategori || null; // Get kategori dari query, null jika tidak ada
  var subkategori = req.query.subkategori || null; // Get subkategori dari query, null jika tidak ada
  const selectedKategori = kategori
  const selectedSubkategori = subkategori

  // If kategori = '0' set to semua
  if (kategori === '0'){kategori = null};
  if (subkategori === '0'){subkategori = null};

  
  try {
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

app.post("/kerjakan", async (req, res) => {
  const pekerjaId = '196b292e-d564-4508-94ce-f049e07e8688';
  const { idtrpemesanan: idTrPemesanan } = req.body;
  try {
    await client.query(
      "SELECT update_pesanan_dikerjakan($1, $2)",
      [idTrPemesanan, pekerjaId]
    )
  } catch (error) {
    console.error("Error fetching data:", error);
    res.status(500).send("Internal Server Error");
    res.redirect("/pekerjaan");
  }


});

app.get("/status", (req, res) => {
  res.render("pekerjaan/status");
});

export default app;