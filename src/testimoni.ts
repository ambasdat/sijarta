import express from 'express';

const app = express.Router();

const dummyData = {
  jasa: [
    { subkategori: "Subkategori 1", sesi: "2 jam", harga: "Rp30,000", namaPekerja: "Anto", status: "Selesai" },
    { subkategori: "Subkategori 2", sesi: "4 jam", harga: "Rp75,000", namaPekerja: "Beni", status: "Selesai" },
    { subkategori: "Subkategori 3", sesi: "3 jam", harga: "Rp65,000", namaPekerja: "Cory", status: "Selesai" },
  ],
};

app.get('/testimoni', (req, res) => {
  res.render('testimoni/main', { dummyData }); 
});

export default app;
