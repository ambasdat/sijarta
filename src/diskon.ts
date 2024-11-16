import express from 'express';

const app = express.Router();



app.get('/', (req, res) => {
  const vouchers = [
    {
      kode: 'VOUCHER01',
      potongan: 50000,
      minTransaksi: 100000,
      jumlahHari: 30,
      kuotaPenggunaan: 100,
      harga: 150000
    },
    {
      kode: 'VOUCHER02',
      potongan: 30000,
      minTransaksi: 50000,
      jumlahHari: 15,
      kuotaPenggunaan: 200,
      harga: 100000
    },
    {
      kode: 'VOUCHER03',
      potongan: 25000,
      minTransaksi: 70000,
      jumlahHari: 60,
      kuotaPenggunaan: 50,
      harga: 120000
    },
    {
      kode: 'VOUCHER04',
      potongan: 100000,
      minTransaksi: 500000,
      jumlahHari: 90,
      kuotaPenggunaan: 20,
      harga: 500000
    }
  ];

  const promos = [
    {
      kode: 'PROMO01',
      tanggalAkhir: '2024-12-31'
    },
    {
      kode: 'PROMO02',
      tanggalAkhir: '2024-11-30'
    },
    {
      kode: 'PROMO03',
      tanggalAkhir: '2024-10-15'
    },
    {
      kode: 'PROMO04',
      tanggalAkhir: '2024-09-25'
    }
  ];

  res.render('diskon/main', { vouchers, promos });
});

export default app;
