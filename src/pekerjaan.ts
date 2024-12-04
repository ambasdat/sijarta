import express from "express";
import client from "./db";

const app = express.Router();

// Function to transform pekerja category data
const transformCategoryData = (data: any[]) => {
  return data.reduce((result: any[], item: { kid: any; kname: any; sname: string | number; sid: any; }) => {
    let existingCategory = result.find((category) => category.kid === item.kid);

    if (!existingCategory) {
      // If the category does not exist, create a new entry
      existingCategory = {
        kid: item.kid,
        kname: item.kname,
        subcategories: {}, // Initialize subcategories as an empty object
      };
      result.push(existingCategory);
    }

    // Add the subcategory to the existing category
    existingCategory.subcategories[item.sname] = item.sid;

    return result;
  }, []);
};


app.get("/", async (req, res) => {
  var kategori = req.query.kategori || null; // Get category from query, or null if not provided
  var subkategori = req.query.subkategori || null; // Get subcategory from query, or null if not provided
  const selectedKategori = kategori
  const selectedSubkategori = subkategori

  // If category or subcategory is '0', set them to null
  if (kategori === '0'){kategori = null};
  if (subkategori === '0'){subkategori = null};

  const pekerjaId = '196b292e-d564-4508-94ce-f049e07e8688';

  const { rows: pekerja_kategori } = await client.query(
    "SELECT * FROM get_pekerja_category($1)",
    [pekerjaId]
  );
  
  // Transform data using the separate function
  const pekerja_kategori_dict = transformCategoryData(pekerja_kategori);

  const { rows: order_result } = await client.query(
    "SELECT * FROM filter_pemesanan($1, $2, $3)",
    [pekerjaId, kategori, subkategori]
  );

  console.log(pekerja_kategori_dict);
  console.log(order_result)

  res.render("pekerjaan/main", {
    pekerja_kategori_dict,
    pekerja_kategori_dict_json: JSON.stringify(pekerja_kategori_dict),
    order_result,
    selectedKategori,
    selectedSubkategori,
  });
});

app.post("/kerjakan", async (req, res) => {
  const { idtrpemesanan } = req.body;  // The id of the order to be processed

  // Perform the necessary query to process the order
  const pekerjaId = '196b292e-d564-4508-94ce-f049e07e8688';
  
  // Here you could perform any necessary updates or actions for the order
  await client.query(
    "SELECT update_pesanan_dikerjakan($1, $2)",
    [idtrpemesanan, pekerjaId]
  )
    // Redirect to the same page after processing the order
    res.redirect("/pekerjaan");
});

app.get("/status", (req, res) => {
  res.render("pekerjaan/status");
});

export default app;