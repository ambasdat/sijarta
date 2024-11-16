import express from 'express';

const app = express.Router();

const jobs = [
  {
    subkategori: "Daily Cleaning",
    namaPelanggan: "John Doe",
    tanggalPemesanan: "2024-11-16",
    tanggalPekerjaan: "2024-11-17",
    totalBiaya: "Rp 200,000",
    statusPesanan: "Menunggu Pekerja Berangkat"
  },
  {
    subkategori: "Cuci Sofa",
    namaPelanggan: "Jane Smith",
    tanggalPemesanan: "2024-11-14",
    tanggalPekerjaan: "2024-11-15",
    totalBiaya: "Rp 500,000",
    statusPesanan: "Pekerja Tiba Di Lokasi"
  },
  {
    subkategori: "Massage Therapy",
    namaPelanggan: "Alice Brown",
    tanggalPemesanan: "2024-11-15",
    tanggalPekerjaan: "2024-11-16",
    totalBiaya: "Rp 300,000",
    statusPesanan: "Pelayanan Jasa Sedang Dilakukan"
  },
  {
    subkategori: "Massage Therapy",
    namaPelanggan: "Alice Brown",
    tanggalPemesanan: "2024-11-30",
    tanggalPekerjaan: "2024-12-5",
    totalBiaya: "Rp 300,000",
    statusPesanan: "Pesanan Selesai"
  }
];

app.get('/', (req, res) => {
  res.render('order/orders', { jobs: JSON.stringify(jobs) });
});

app.get('/jobs', (req, res) => {
  res.render('order/jobs', { jobs: JSON.stringify(jobs) });
});

export default app;
