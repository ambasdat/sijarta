INSERT INTO "USER" (
  "Id", "Nama", "JenisKelamin", "NoHP", 
  "Pwd", "TglLahir", "Alamat", "SaldoMyPay"
) 
VALUES 
  (
    '64302ea1-212d-414c-a2db-1fad0b3c3b6e', 
    'FirAS Cheese', 'L', '01234567891', 
    'otato3288', '2005-10-08', 'Tangerang', 
    100000
  ), 
  (
    '81ebf7b7-1ee3-4da4-b04c-4d1202460288', 
    'Hawk Tuah', 'P', '01234567892', 
    'dbsi3479', '1998-07-15', 'Jakarta', 
    250000
  ), 
  (
    'cefe54f7-d053-4459-95f9-79381583b4c0', 
    'Robert J. Oppenheimer', 'L', '01234567893', 
    '34tfvy334', '1985-02-21', 'Bandung', 
    75000
  ), 
  (
    '7641cc47-df84-414a-9847-ddcdc2ff5e89', 
    'Shinmen Takezo', 'L', '01234567894', 
    '34yv5bvy4', '1995-04-10', 'Surabaya', 
    150000
  ), 
  (
    'de19a8b8-df16-426e-86d4-28e6fa75d95c', 
    'Miyamoto Musashi', 'L', '01234567895', 
    '6oin7ujy', '2000-12-05', 'Yogyakarta', 
    300000
  ), 
  (
    'f864622f-e148-4d45-8253-e31fe71754bd', 
    'Anastasia Theresia', 'P', '01234567896', 
    '234qcfwq', '1993-11-30', 'Malang', 
    125000
  ), 
  (
    '196b292e-d564-4508-94ce-f049e07e8688', 
    'Mai Sakurajima', 'P', '01234567897', 
    'fg4355', '1978-09-25', 'Bogor', 
    50000
  ), 
  (
    'feb41656-f881-46c4-9e0f-370e6473ebfa', 
    'Ryan Gosling', 'L', '01234567898', 
    '3g4f4t3v', '1989-06-17', 'Semarang', 
    225000
  ), 
  (
    '3b930fcd-bda9-4c36-90b7-c02525984abe', 
    'Vincent Orang Dua', 'L', '01234567899', 
    '56bu56vu5', '1990-01-01', 'Medan', 
    90000
  ), 
  (
    'a050fd67-53a0-4659-b7ef-f510566a0f7e', 
    'Sumanto', 'L', '01234567890', 'm7k98oqwe', 
    '1999-03-14', 'Bekasi', 175000
  );

INSERT INTO "PELANGGAN" ("Id", "Level") 
VALUES 
  (
    '64302ea1-212d-414c-a2db-1fad0b3c3b6e', 
    'Basic'
  ), 
  (
    '81ebf7b7-1ee3-4da4-b04c-4d1202460288', 
    'Silver'
  ), 
  (
    'cefe54f7-d053-4459-95f9-79381583b4c0', 
    'Gold'
  ), 
  (
    '7641cc47-df84-414a-9847-ddcdc2ff5e89', 
    'Gold'
  ), 
  (
    'de19a8b8-df16-426e-86d4-28e6fa75d95c', 
    'Silver'
  );

INSERT INTO "PEKERJA" (
  "Id", "NamaBank", "NomorRekening", 
  "NPWP", "LinkFoto", "Rating", "JmlPesananSelesai"
) 
VALUES 
  (
    'f864622f-e148-4d45-8253-e31fe71754bd', 
    'GoPay', '1234567890', 'NPWP123456', 
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ8oa_Ry-VkvI6BaxO7JTRMbCjUNW88GeUZJQ&s', 
    4.5, 15
  ), 
  (
    '196b292e-d564-4508-94ce-f049e07e8688', 
    'OVO', '0987654321', 'NPWP654321', 
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgABrPnPoMy3TPsdJ6ME_zrzQ4F8rXrOpiiw&s', 
    4.8, 22
  ), 
  (
    'feb41656-f881-46c4-9e0f-370e6473ebfa', 
    'Virtual Account BCA', '1122334455', 'NPWP998877', 
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTVsYw1PibCT0vRTU00sCzMl8EvEmLEwJs1jw&s', 
    4.2, 10
  ), 
  (
    '3b930fcd-bda9-4c36-90b7-c02525984abe', 
    'Virtual Account BNI', '5566778899', 'NPWP445566', 
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS0GEi8cFQDZ839O6WKomzwhrvVi-14owZ2sA&s', 
    4.9, 30
  ), 
  (
    'a050fd67-53a0-4659-b7ef-f510566a0f7e', 
    'Virtual Account Mandiri', '6677889900', 'NPWP223344', 
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSJcHUgyQjd7q7f1rRwwM1BS-LjoUfH8qln1Q&s', 
    4.7, 18
  );

INSERT INTO "KATEGORI_TR_MYPAY" ("Id", "Nama") 
VALUES 
  (
    'ad98db8d-2f94-4176-9f47-7c5ed55cdeb4', 
    'topup MyPay'
  ), 
  (
    'bb453dbc-c5eb-4102-83e9-c13d1b14213a', 
    'membayar transaksi jasa'
  ), 
  (
    '2bbabdf1-f34a-4ce5-8b56-3a0ce95947a1', 
    'transfer MyPay ke pengguna lain'
  ), 
  (
    '466a7907-9252-470c-9a87-7501491a2def', 
    'menerima honor transaksi jasa'
  ), 
  (
    'a5940249-15dd-47b0-bfe7-f042da5e8954', 
    'withdrawal MyPay ke rekening bank'
  ),
  (
    '6f4ffb85-9e44-49e4-9e6b-87d297d5134d',
    'Pembelian Voucher'
  );

INSERT INTO "TR_MYPAY" (
  "Id", "UserId", "Tgl", "Nominal", "KategoriId"
) 
VALUES 
  (
    '6817f541-bd0d-4294-8e18-fae54decf789', 
    'f864622f-e148-4d45-8253-e31fe71754bd', 
    '2024-03-14', 20000, 'ad98db8d-2f94-4176-9f47-7c5ed55cdeb4'
  ), 
  (
    '4ccfa01a-7f56-4f81-a506-867fc097f735', 
    '3b930fcd-bda9-4c36-90b7-c02525984abe', 
    '2024-03-14', 25000, 'ad98db8d-2f94-4176-9f47-7c5ed55cdeb4'
  ), 
  (
    'b24e29ca-4c19-49b1-a7f1-93d48473d291', 
    'cefe54f7-d053-4459-95f9-79381583b4c0', 
    '2024-03-14', 50000, 'ad98db8d-2f94-4176-9f47-7c5ed55cdeb4'
  ), 
  (
    '980f9be8-611a-4c42-9d72-7f1065e5db49', 
    'de19a8b8-df16-426e-86d4-28e6fa75d95c', 
    '2024-03-14', 90000, 'ad98db8d-2f94-4176-9f47-7c5ed55cdeb4'
  ), 
  (
    '24441f71-b2d6-4dfe-917d-32799341b50e', 
    '64302ea1-212d-414c-a2db-1fad0b3c3b6e', 
    '2024-03-14', 30000, 'ad98db8d-2f94-4176-9f47-7c5ed55cdeb4'
  ), 
  (
    'bdfb1e82-9e75-4993-b9fc-9a92c0b65e8d', 
    'feb41656-f881-46c4-9e0f-370e6473ebfa', 
    '2024-03-14', 55000, 'ad98db8d-2f94-4176-9f47-7c5ed55cdeb4'
  ), 
  (
    '1bc1869c-cabf-4ddc-a117-e5a1e70d91aa', 
    '64302ea1-212d-414c-a2db-1fad0b3c3b6e', 
    '2024-03-14', 65000, 'bb453dbc-c5eb-4102-83e9-c13d1b14213a'
  ), 
  (
    '01aa2d2d-485e-4e31-bde0-65af51ce0772', 
    'cefe54f7-d053-4459-95f9-79381583b4c0', 
    '2024-03-14', 95000, 'bb453dbc-c5eb-4102-83e9-c13d1b14213a'
  ), 
  (
    '6e70d9ca-7bb7-4582-94fa-e91e0a87c47a', 
    '81ebf7b7-1ee3-4da4-b04c-4d1202460288', 
    '2024-03-14', 55000, 'bb453dbc-c5eb-4102-83e9-c13d1b14213a'
  ), 
  (
    'fe381229-6373-4795-ab48-20e1b3f65160', 
    'cefe54f7-d053-4459-95f9-79381583b4c0', 
    '2024-03-14', 95000, 'bb453dbc-c5eb-4102-83e9-c13d1b14213a'
  ), 
  (
    'aa45a556-8d79-4936-bad1-182e7be7df8d', 
    '64302ea1-212d-414c-a2db-1fad0b3c3b6e', 
    '2024-03-14', 99000, 'bb453dbc-c5eb-4102-83e9-c13d1b14213a'
  ), 
  (
    '9554648f-0420-4d88-940b-d6050708be3a', 
    'a050fd67-53a0-4659-b7ef-f510566a0f7e', 
    '2024-03-14', 12000, '2bbabdf1-f34a-4ce5-8b56-3a0ce95947a1'
  ), 
  (
    '6058cbe1-5e88-49e4-b13f-4272bcca23e7', 
    'cefe54f7-d053-4459-95f9-79381583b4c0', 
    '2024-03-14', 52000, '2bbabdf1-f34a-4ce5-8b56-3a0ce95947a1'
  ), 
  (
    '62ca843d-13a5-4470-889b-88640fd2f196', 
    'de19a8b8-df16-426e-86d4-28e6fa75d95c', 
    '2024-03-14', 34000, '2bbabdf1-f34a-4ce5-8b56-3a0ce95947a1'
  ), 
  (
    '61863705-890d-4e91-adb8-c80c190fb6ba', 
    'f864622f-e148-4d45-8253-e31fe71754bd', 
    '2024-03-14', 13000, '2bbabdf1-f34a-4ce5-8b56-3a0ce95947a1'
  ), 
  (
    '5d61314a-d3a5-461a-b5db-3b822f439219', 
    '3b930fcd-bda9-4c36-90b7-c02525984abe', 
    '2024-03-14', 55000, '2bbabdf1-f34a-4ce5-8b56-3a0ce95947a1'
  ), 
  (
    'd1d87a90-807d-4bd4-acb0-8f720a2b1c3d', 
    '196b292e-d564-4508-94ce-f049e07e8688', 
    '2024-03-14', 65000, '466a7907-9252-470c-9a87-7501491a2def'
  ), 
  (
    'f1a57f55-68d0-465f-a4da-7d91dcebbe81', 
    'a050fd67-53a0-4659-b7ef-f510566a0f7e', 
    '2024-03-14', 95000, '466a7907-9252-470c-9a87-7501491a2def'
  ), 
  (
    'f1b8695c-6a09-44cf-a804-fa058d6e86ce', 
    'f864622f-e148-4d45-8253-e31fe71754bd', 
    '2024-03-14', 55000, '466a7907-9252-470c-9a87-7501491a2def'
  ), 
  (
    '9efe484d-5094-4192-a6aa-98b5ab3b62c7', 
    '3b930fcd-bda9-4c36-90b7-c02525984abe', 
    '2024-03-14', 95000, '466a7907-9252-470c-9a87-7501491a2def'
  ), 
  (
    '6de276db-96b1-4abf-ad5f-618317a1c449', 
    'feb41656-f881-46c4-9e0f-370e6473ebfa', 
    '2024-03-14', 99000, '466a7907-9252-470c-9a87-7501491a2def'
  ), 
  (
    '9492fe9a-ba59-42ee-91a6-a764c1488516', 
    'feb41656-f881-46c4-9e0f-370e6473ebfa', 
    '2024-03-14', 55000, 'a5940249-15dd-47b0-bfe7-f042da5e8954'
  ), 
  (
    '4ae282ec-7d13-447e-a078-9a5ea1e526fa', 
    '64302ea1-212d-414c-a2db-1fad0b3c3b6e', 
    '2024-03-14', 55000, 'a5940249-15dd-47b0-bfe7-f042da5e8954'
  ), 
  (
    '9c70c377-f690-4c9d-b7a0-2f8797e09b02', 
    '7641cc47-df84-414a-9847-ddcdc2ff5e89', 
    '2024-03-14', 55000, 'a5940249-15dd-47b0-bfe7-f042da5e8954'
  ), 
  (
    '02d3f2f8-adf8-44cb-ae55-6c82d1dcf785', 
    'de19a8b8-df16-426e-86d4-28e6fa75d95c', 
    '2024-03-14', 55000, 'a5940249-15dd-47b0-bfe7-f042da5e8954'
  ), 
  (
    '37634e18-dda7-4fc6-9747-a220dff083c9', 
    '81ebf7b7-1ee3-4da4-b04c-4d1202460288', 
    '2024-03-14', 55000, 'a5940249-15dd-47b0-bfe7-f042da5e8954'
  );

INSERT INTO "KATEGORI_JASA" ("Id", "NamaKategori") 
VALUES 
  (
    'f9a05cb3-9a27-4983-8b72-333ad042fc2b', 
    'Home Cleaning'
  ), 
  (
    '405f61c8-452a-459f-9b29-9e2041d8bbf4', 
    'Deep Cleaning'
  ), 
  (
    '1a80b324-d6ba-4676-8296-08f0a55b2246', 
    'Plumbing Services'
  ), 
  (
    'de6e4316-3738-43e7-a408-b4cfd56edca2', 
    'Electrical Repairs'
  ), 
  (
    'd23e08e4-158d-44f0-94b1-43d5718a201e', 
    'Pest Control'
  );

INSERT INTO "PEKERJA_KATEGORI_JASA" ("PekerjaId", "KategoriJasaId") 
VALUES 
  (
    'f864622f-e148-4d45-8253-e31fe71754bd', 
    'f9a05cb3-9a27-4983-8b72-333ad042fc2b'
  ), 
  (
    'f864622f-e148-4d45-8253-e31fe71754bd', 
    '405f61c8-452a-459f-9b29-9e2041d8bbf4'
  ), 
  (
    'f864622f-e148-4d45-8253-e31fe71754bd', 
    '1a80b324-d6ba-4676-8296-08f0a55b2246'
  ), 
  (
    '196b292e-d564-4508-94ce-f049e07e8688', 
    'de6e4316-3738-43e7-a408-b4cfd56edca2'
  ), 
  (
    'feb41656-f881-46c4-9e0f-370e6473ebfa', 
    'd23e08e4-158d-44f0-94b1-43d5718a201e'
  ), 
  (
    'feb41656-f881-46c4-9e0f-370e6473ebfa', 
    'de6e4316-3738-43e7-a408-b4cfd56edca2'
  ), 
  (
    '3b930fcd-bda9-4c36-90b7-c02525984abe', 
    '405f61c8-452a-459f-9b29-9e2041d8bbf4'
  ), 
  (
    '3b930fcd-bda9-4c36-90b7-c02525984abe', 
    'd23e08e4-158d-44f0-94b1-43d5718a201e'
  ), 
  (
    'a050fd67-53a0-4659-b7ef-f510566a0f7e', 
    'f9a05cb3-9a27-4983-8b72-333ad042fc2b'
  ), 
  (
    'a050fd67-53a0-4659-b7ef-f510566a0f7e', 
    '405f61c8-452a-459f-9b29-9e2041d8bbf4'
  );

INSERT INTO "SUBKATEGORI_JASA" (
  "Id", "NamaSubkategori", "Deskripsi", 
  "KategoriJasaId"
) 
VALUES 
  (
    '260c03b2-48d5-43bc-8246-dfa9215406bf', 
    'Daily Cleaning', 'Membersihkan hunian secara umum seperti menyapu, mengepel, mengelap', 
    'f9a05cb3-9a27-4983-8b72-333ad042fc2b'
  ), 
  (
    'd5679a65-6ff5-4e1e-aac8-8761f03ec8be', 
    'Pembersihan Dapur dan Kulkas', 
    'Membersihkan area dapur termasuk peralatan dapur dan bagian dalam kulkAS secara menyeluruh', 
    'f9a05cb3-9a27-4983-8b72-333ad042fc2b'
  ), 
  (
    '16f9acb2-7af8-4007-bb68-b53e51338961', 
    'Cuci Kasur', 'Pencucian dan penghilangan noda dari permukaan kasur untuk kebersihan optimal', 
    '405f61c8-452a-459f-9b29-9e2041d8bbf4'
  ), 
  (
    '614cf8b2-6273-4c84-88e6-7e910295d457', 
    'Bersih Kamar Mandi', 'Membersihkan seluruh bagian kamar mandi termasuk lantai, dinding, dan peralatan sanitasi', 
    '405f61c8-452a-459f-9b29-9e2041d8bbf4'
  ), 
  (
    '0beb38a5-89fc-415b-82d7-2693273650be', 
    'Perbaikan Pipa Bocor', 'Perbaikan pipa yang bocOR atau rusak di dalam maupun di luar rumah', 
    '1a80b324-d6ba-4676-8296-08f0a55b2246'
  ), 
  (
    '8643f1ba-2fb0-486a-9d2c-61201073a171', 
    'Pembersihan Saluran Air', 'Pembersihan dan perbaikan saluran air yang tersumbat atau bermasalah', 
    '1a80b324-d6ba-4676-8296-08f0a55b2246'
  ), 
  (
    'ce40d185-7224-464f-a538-c39a64403b70', 
    'Pengendalian Tikus', 'Mengendalikan populasi tikus dan melakukan pembersihan area yang terkontaminasi', 
    'd23e08e4-158d-44f0-94b1-43d5718a201e'
  ), 
  (
    '06221f4d-486a-4aa7-8007-e81c7c0538d4', 
    'Pembasmian Kutu', 'Melakukan pembasmian kutu di rumah dan lingkungan sekitar', 
    'd23e08e4-158d-44f0-94b1-43d5718a201e'
  ), 
  (
    'ce249da5-507c-4fc5-901d-0d19e1013948', 
    'Instalasi Lampu', 'Instalasi dan penggantian lampu serta perlengkapan pencahayaan', 
    'de6e4316-3738-43e7-a408-b4cfd56edca2'
  ), 
  (
    'b7e6c0ce-085b-4de4-94b9-7329bf28514e', 
    'Perbaikan Saklar dan Stop Kontak', 
    'Memperbaiki saklar dan stop kontak yang rusak atau tidak berfungsi', 
    'de6e4316-3738-43e7-a408-b4cfd56edca2'
  );

INSERT INTO "SESI_LAYANAN" ("SubkategoriId", "Sesi", "Harga") 
VALUES 
  (
    '0beb38a5-89fc-415b-82d7-2693273650be', 
    1, 100000
  ), 
  (
    '0beb38a5-89fc-415b-82d7-2693273650be', 
    2, 150000
  ), 
  (
    '0beb38a5-89fc-415b-82d7-2693273650be', 
    3, 200000
  ), 
  (
    '614cf8b2-6273-4c84-88e6-7e910295d457', 
    1, 120000
  ), 
  (
    '614cf8b2-6273-4c84-88e6-7e910295d457', 
    2, 170000
  ), 
  (
    '614cf8b2-6273-4c84-88e6-7e910295d457', 
    3, 220000
  ), 
  (
    '16f9acb2-7af8-4007-bb68-b53e51338961', 
    1, 90000
  ), 
  (
    '16f9acb2-7af8-4007-bb68-b53e51338961', 
    2, 140000
  ), 
  (
    '16f9acb2-7af8-4007-bb68-b53e51338961', 
    3, 190000
  ), 
  (
    'd5679a65-6ff5-4e1e-aac8-8761f03ec8be', 
    1, 110000
  ), 
  (
    'd5679a65-6ff5-4e1e-aac8-8761f03ec8be', 
    2, 160000
  ), 
  (
    'd5679a65-6ff5-4e1e-aac8-8761f03ec8be', 
    3, 210000
  ), 
  (
    '260c03b2-48d5-43bc-8246-dfa9215406bf', 
    1, 100000
  ), 
  (
    '260c03b2-48d5-43bc-8246-dfa9215406bf', 
    2, 150000
  ), 
  (
    '260c03b2-48d5-43bc-8246-dfa9215406bf', 
    3, 200000
  ), 
  (
    'ce40d185-7224-464f-a538-c39a64403b70', 
    1, 110000
  ), 
  (
    'ce40d185-7224-464f-a538-c39a64403b70', 
    2, 160000
  ), 
  (
    'ce40d185-7224-464f-a538-c39a64403b70', 
    3, 210000
  ), 
  (
    '8643f1ba-2fb0-486a-9d2c-61201073a171', 
    1, 130000
  ), 
  (
    '8643f1ba-2fb0-486a-9d2c-61201073a171', 
    2, 180000
  ), 
  (
    '8643f1ba-2fb0-486a-9d2c-61201073a171', 
    3, 230000
  ), 
  (
    '06221f4d-486a-4aa7-8007-e81c7c0538d4', 
    1, 100000
  ), 
  (
    '06221f4d-486a-4aa7-8007-e81c7c0538d4', 
    2, 150000
  ), 
  (
    '06221f4d-486a-4aa7-8007-e81c7c0538d4', 
    3, 200000
  ), 
  (
    'ce249da5-507c-4fc5-901d-0d19e1013948', 
    1, 110000
  ), 
  (
    'ce249da5-507c-4fc5-901d-0d19e1013948', 
    2, 160000
  ), 
  (
    'ce249da5-507c-4fc5-901d-0d19e1013948', 
    3, 210000
  ), 
  (
    'b7e6c0ce-085b-4de4-94b9-7329bf28514e', 
    1, 130000
  ), 
  (
    'b7e6c0ce-085b-4de4-94b9-7329bf28514e', 
    2, 180000
  ), 
  (
    'b7e6c0ce-085b-4de4-94b9-7329bf28514e', 
    3, 320000
  );

INSERT INTO "DISKON" (
  "Kode", "Potongan", "MinTrPemesanan"
) 
VALUES 
  ('UNTUNG', 20000, 100000), 
  ('GACOR', 23000, 150000), 
  ('MANTAP', 22000, 200000), 
  ('MURAH', 25000, 100000), 
  ('BERKAH', 35000, 300000), 
  ('SUKSES', 5000, 80000), 
  ('HEBAT', 20000, 90000), 
  ('CEMERLANG', 20000, 250000), 
  ('ISTIMEWA', 10000, 90000), 
  ('BERSIH', 2000, 70000), 
  ('BERES', 20000, 100000), 
  ('GAJISEP24', 20000, 150000), 
  ('GAJIOKT24', 20000, 120000), 
  ('GAJINOV24', 30000, 330000), 
  ('AKHIRTAHUN24', 20000, 100000), 
  ('AWALTAHUN25', 30000, 430000), 
  ('MERDEKA25', 20000, 350000), 
  (
    'TANGGALSPESIALMEI', 10000, 60000
  ), 
  ('GAJISEP25', 20000, 210000), 
  ('GAJINOV25', 50000, 540000), 
  ('AKHIRTAHUN25', 20000, 140000);

INSERT INTO "VOUCHER" (
  "Kode", "JmlHariBerlaku", "KuotaPenggunaan", 
  "Harga"
) 
VALUES 
  ('UNTUNG', 30, 10, 1000), 
  ('GACOR', 25, 10, 1000), 
  ('MANTAP', 25, 7, 1500), 
  ('MURAH', 20, 7, 2000), 
  ('BERKAH', 15, 7, 2500), 
  ('SUKSES', 15, 5, 3000), 
  ('HEBAT', 20, 5, 3500), 
  ('CEMERLANG', 35, 5, 4000), 
  ('ISTIMEWA', 10, 3, 4500), 
  ('BERSIH', 10, 3, 5000), 
  ('BERES', 30, 3, 5500);

INSERT INTO "PROMO" ("Kode", "TglAkhirBerlaku") 
VALUES 
  ('GAJISEP24', DATE '2024-08-31'), 
  ('GAJIOKT24', DATE '2024-09-30'), 
  ('GAJINOV24', DATE '2024-10-29'), 
  (
    'AKHIRTAHUN24', DATE '2024-12-31'
  ), 
  ('AWALTAHUN25', DATE '2025-01-30'), 
  ('MERDEKA25', DATE '2025-08-17'), 
  (
    'TANGGALSPESIALMEI', DATE '2025-05-05'
  ), 
  ('GAJISEP25', DATE '2025-10-29'), 
  ('GAJINOV25', DATE '2025-11-29'), 
  (
    'AKHIRTAHUN25', DATE '2025-12-31'
  );

INSERT INTO "METODE_BAYAR" ("Id", "Nama") 
VALUES 
  (
    'd36a743b-8015-4940-8ef4-0ec549d6b6ef', 
    'MyPay'
  ), 
  (
    '3a3002e6-3ebe-4624-afee-ba43c336c97d', 
    'GoPay'
  ), 
  (
    '62fe7fb8-c22e-4bf3-acbf-9e9d2b8344ed', 
    'OVO'
  ), 
  (
    'bae3ec5f-9fca-4384-b601-bb8379ab2c2d', 
    'Virtual Account BCA'
  ), 
  (
    'e22f8d47-e2b7-4a8e-92c6-3ce541f11ca4', 
    'Virtual Account BNI'
  ), 
  (
    '84240525-7854-4ad2-bf3e-651b6168f27b', 
    'Virtual Account Mandiri'
  );

INSERT INTO "TR_PEMBELIAN_VOUCHER" (
  "Id", "TglAwal", "TglAkhir", "TelahDigunakan", 
  "IdPelanggan", "IdVoucher", "IdMetodeBayar"
) 
VALUES 
  (
    '4eedd904-a693-477b-867d-eb1777e09bb4', 
    '2024-10-01', '2024-11-01', 0, '64302ea1-212d-414c-a2db-1fad0b3c3b6e', 
    'UNTUNG', 'd36a743b-8015-4940-8ef4-0ec549d6b6ef'
  ), 
  (
    '125c257d-9ba4-474e-acba-949457ca8bb0', 
    '2024-09-15', '2024-10-15', 1, '64302ea1-212d-414c-a2db-1fad0b3c3b6e', 
    'GACOR', '3a3002e6-3ebe-4624-afee-ba43c336c97d'
  ), 
  (
    'f506682b-a394-4b50-a505-d6138c13860b', 
    '2024-09-20', '2024-10-20', 0, '64302ea1-212d-414c-a2db-1fad0b3c3b6e', 
    'MANTAP', '62fe7fb8-c22e-4bf3-acbf-9e9d2b8344ed'
  ), 
  (
    '1ee285a4-fb3d-4c4f-a2da-7daae6418a4e', 
    '2024-09-01', '2024-09-30', 2, '64302ea1-212d-414c-a2db-1fad0b3c3b6e', 
    'MURAH', 'bae3ec5f-9fca-4384-b601-bb8379ab2c2d'
  ), 
  (
    '017c0fb3-381e-4b39-8262-805e0eaad379', 
    '2024-08-25', '2024-09-25', 1, '81ebf7b7-1ee3-4da4-b04c-4d1202460288', 
    'BERKAH', 'e22f8d47-e2b7-4a8e-92c6-3ce541f11ca4'
  ), 
  (
    '394f59ec-0ee9-437c-b22e-12653823ed44', 
    '2024-10-05', '2024-11-05', 0, '81ebf7b7-1ee3-4da4-b04c-4d1202460288', 
    'SUKSES', '84240525-7854-4ad2-bf3e-651b6168f27b'
  ), 
  (
    '04adb3f8-6333-4a4c-8ace-b592b7d4d11f', 
    '2024-10-07', '2024-11-07', 0, '81ebf7b7-1ee3-4da4-b04c-4d1202460288', 
    'HEBAT', 'd36a743b-8015-4940-8ef4-0ec549d6b6ef'
  ), 
  (
    '4a37f61a-4b9e-4164-99b7-b46e8ba8d87e', 
    '2024-09-10', '2024-10-10', 1, '81ebf7b7-1ee3-4da4-b04c-4d1202460288', 
    'CEMERLANG', '3a3002e6-3ebe-4624-afee-ba43c336c97d'
  ), 
  (
    'a7b70e42-b681-4e2e-8f62-6fa1813ec583', 
    '2024-08-15', '2024-09-15', 1, 'cefe54f7-d053-4459-95f9-79381583b4c0', 
    'ISTIMEWA', '62fe7fb8-c22e-4bf3-acbf-9e9d2b8344ed'
  ), 
  (
    '0ad64697-825f-4a50-b099-07602f498313', 
    '2024-09-05', '2024-10-05', 0, 'cefe54f7-d053-4459-95f9-79381583b4c0', 
    'BERSIH', 'bae3ec5f-9fca-4384-b601-bb8379ab2c2d'
  ), 
  (
    'd9628b5f-5b83-415c-b2e6-2b44e9ba7131', 
    '2024-09-25', '2024-10-25', 0, 'cefe54f7-d053-4459-95f9-79381583b4c0', 
    'BERES', 'e22f8d47-e2b7-4a8e-92c6-3ce541f11ca4'
  ), 
  (
    '9b200fc3-ecd3-4cce-90cf-3743b9fd0825', 
    '2024-09-17', '2024-10-17', 1, 'cefe54f7-d053-4459-95f9-79381583b4c0', 
    'UNTUNG', '84240525-7854-4ad2-bf3e-651b6168f27b'
  ), 
  (
    'c16e6727-efb1-4811-a4e5-b36cc84aded5', 
    '2024-09-27', '2024-10-27', 1, '7641cc47-df84-414a-9847-ddcdc2ff5e89', 
    'GACOR', 'd36a743b-8015-4940-8ef4-0ec549d6b6ef'
  ), 
  (
    '47682fd8-9cac-4859-b701-c9470720383e', 
    '2024-10-08', '2024-11-08', 0, '7641cc47-df84-414a-9847-ddcdc2ff5e89', 
    'MANTAP', '3a3002e6-3ebe-4624-afee-ba43c336c97d'
  ), 
  (
    '26d45b94-1719-40cb-99ad-4ebff753fcb2', 
    '2024-09-19', '2024-10-19', 1, '7641cc47-df84-414a-9847-ddcdc2ff5e89', 
    'MURAH', '62fe7fb8-c22e-4bf3-acbf-9e9d2b8344ed'
  ), 
  (
    '67f424b6-d3fd-46ac-9289-4b83e337711f', 
    '2024-10-09', '2024-11-09', 0, 'de19a8b8-df16-426e-86d4-28e6fa75d95c', 
    'BERKAH', 'bae3ec5f-9fca-4384-b601-bb8379ab2c2d'
  ), 
  (
    'bb752189-d5e7-43c7-9f31-36296254ee6a', 
    '2024-09-18', '2024-10-18', 2, 'de19a8b8-df16-426e-86d4-28e6fa75d95c', 
    'SUKSES', 'e22f8d47-e2b7-4a8e-92c6-3ce541f11ca4'
  ), 
  (
    'f11370b4-62b1-44be-8c7e-3681cd36b82f', 
    '2024-09-28', '2024-10-28', 1, 'de19a8b8-df16-426e-86d4-28e6fa75d95c', 
    'HEBAT', '84240525-7854-4ad2-bf3e-651b6168f27b'
  );

INSERT INTO "TR_PEMESANAN_JASA" (
  "Id", "TglPemesanan", "TglPekerjaan", 
  "WaktuPekerjaan", "TotalBiaya", 
  "IdPelanggan", "IdPekerja", "IdKategoriJasa", 
  "Sesi", "IdDiskon", "IdMetodeBayar"
) 
VALUES 
  (
    '6d06aca8-c3ad-4f46-b3df-d562dd22fd9a', 
    '2021-03-15', '2021-03-20', '2021-03-20 14:27:53', 
    690000, '7641cc47-df84-414a-9847-ddcdc2ff5e89', 
    'f864622f-e148-4d45-8253-e31fe71754bd', 
    '260c03b2-48d5-43bc-8246-dfa9215406bf', 
    1, NULL, 'd36a743b-8015-4940-8ef4-0ec549d6b6ef'
  ), 
  (
    '4aecc4c2-13fc-491c-910e-d6523f12f129', 
    '2021-05-20', '2021-05-29', '2021-05-29 11:57:16', 
    119000, '81ebf7b7-1ee3-4da4-b04c-4d1202460288', 
    'a050fd67-53a0-4659-b7ef-f510566a0f7e', 
    'd5679a65-6ff5-4e1e-aac8-8761f03ec8be', 
    1, 'UNTUNG', '3a3002e6-3ebe-4624-afee-ba43c336c97d'
  ), 
  (
    '8a355e41-e7fd-445d-a094-abedde646c34', 
    '2021-06-15', '2021-06-18', '2021-06-18 14:37:22', 
    122000, 'cefe54f7-d053-4459-95f9-79381583b4c0', 
    'a050fd67-53a0-4659-b7ef-f510566a0f7e', 
    '16f9acb2-7af8-4007-bb68-b53e51338961', 
    1, NULL, 'bae3ec5f-9fca-4384-b601-bb8379ab2c2d'
  ), 
  (
    '8ba2d0bf-1fb8-49df-a963-a3fe4f2ec5a7', 
    '2019-11-03', '2019-11-05', '2019-11-05 08:21:45', 
    107000, '81ebf7b7-1ee3-4da4-b04c-4d1202460288', 
    '3b930fcd-bda9-4c36-90b7-c02525984abe', 
    '614cf8b2-6273-4c84-88e6-7e910295d457', 
    1, 'ISTIMEWA', 'bae3ec5f-9fca-4384-b601-bb8379ab2c2d'
  ), 
  (
    '2334f103-e4b5-4a3a-ac6d-a9c9c466031c', 
    '2022-02-17', '2022-02-18', '2022-02-18 19:08:33', 
    141000, '64302ea1-212d-414c-a2db-1fad0b3c3b6e', 
    'f864622f-e148-4d45-8253-e31fe71754bd', 
    '0beb38a5-89fc-415b-82d7-2693273650be', 
    1, NULL, '84240525-7854-4ad2-bf3e-651b6168f27b'
  ), 
  (
    '489a3c4b-6d5d-447e-8a37-fbf06f5f62db', 
    '2020-08-29', '2020-08-30', '2020-08-30 12:15:57', 
    139000, 'cefe54f7-d053-4459-95f9-79381583b4c0', 
    'f864622f-e148-4d45-8253-e31fe71754bd', 
    '8643f1ba-2fb0-486a-9d2c-61201073a171', 
    1, NULL, '84240525-7854-4ad2-bf3e-651b6168f27b'
  ), 
  (
    '18724b2b-ae84-4ae3-b283-6fd32bf6c570', 
    '2023-04-12', '2023-04-16', '2023-04-16 23:45:10', 
    130000, '7641cc47-df84-414a-9847-ddcdc2ff5e89', 
    'feb41656-f881-46c4-9e0f-370e6473ebfa', 
    'ce40d185-7224-464f-a538-c39a64403b70', 
    1, 'UNTUNG', '84240525-7854-4ad2-bf3e-651b6168f27b'
  ), 
  (
    'f1079ee4-0ce6-4077-b684-cf6140af670e', 
    '2018-09-25', '2018-09-30', '2018-09-30 05:32:48', 
    146000, 'de19a8b8-df16-426e-86d4-28e6fa75d95c', 
    '3b930fcd-bda9-4c36-90b7-c02525984abe', 
    '06221f4d-486a-4aa7-8007-e81c7c0538d4', 
    1, NULL, '84240525-7854-4ad2-bf3e-651b6168f27b'
  ), 
  (
    '88cb54f1-dbc2-48a6-adae-30fdc8bb1b84', 
    '2021-01-19', '2021-01-21', '2021-01-21 16:08:26', 
    113000, '81ebf7b7-1ee3-4da4-b04c-4d1202460288', 
    '196b292e-d564-4508-94ce-f049e07e8688', 
    'ce249da5-507c-4fc5-901d-0d19e1013948', 
    1, NULL, 'd36a743b-8015-4940-8ef4-0ec549d6b6ef'
  ), 
  (
    '24d73f22-301c-423b-b805-bbe78d584aa9', 
    '2022-10-03', '2022-10-04', '2022-10-04 09:54:12', 
    124000, '64302ea1-212d-414c-a2db-1fad0b3c3b6e', 
    'feb41656-f881-46c4-9e0f-370e6473ebfa', 
    'b7e6c0ce-085b-4de4-94b9-7329bf28514e', 
    1, 'BERES', 'd36a743b-8015-4940-8ef4-0ec549d6b6ef'
  ), 
  (
    '518a9050-cd17-4a7e-af31-418e5a7d290d', 
    '2019-12-14', '2019-12-17', '2019-12-17 11:27:55', 
    137000, 'cefe54f7-d053-4459-95f9-79381583b4c0', 
    'a050fd67-53a0-4659-b7ef-f510566a0f7e', 
    'd5679a65-6ff5-4e1e-aac8-8761f03ec8be', 
    1, NULL, '84240525-7854-4ad2-bf3e-651b6168f27b'
  ), 
  (
    'c7c5d7d8-87a8-4934-af31-2d227a49b4ff', 
    '2020-07-08', '2020-07-13', '2020-07-13 15:03:41', 
    101000, 'de19a8b8-df16-426e-86d4-28e6fa75d95c', 
    'f864622f-e148-4d45-8253-e31fe71754bd', 
    '0beb38a5-89fc-415b-82d7-2693273650be', 
    1, NULL, 'd36a743b-8015-4940-8ef4-0ec549d6b6ef'
  ), 
  (
    '61a73148-41bd-44df-a476-a470b1afdf4d', 
    '2021-03-22', '2021-03-26', '2021-03-26 07:14:29', 
    137000, '7641cc47-df84-414a-9847-ddcdc2ff5e89', 
    'feb41656-f881-46c4-9e0f-370e6473ebfa', 
    'ce40d185-7224-464f-a538-c39a64403b70', 
    1, NULL, 'd36a743b-8015-4940-8ef4-0ec549d6b6ef'
  ), 
  (
    '08a6553f-b369-4282-a875-9ddbb6e2cecc', 
    '2023-09-11', '2023-09-13', '2023-09-13 13:48:19', 
    163000, '81ebf7b7-1ee3-4da4-b04c-4d1202460288', 
    'f864622f-e148-4d45-8253-e31fe71754bd', 
    '260c03b2-48d5-43bc-8246-dfa9215406bf', 
    1, 'BERES', '62fe7fb8-c22e-4bf3-acbf-9e9d2b8344ed'
  ), 
  (
    '4c9370ab-73d1-4efc-b9e5-62aedfd87453', 
    '2020-04-17', '2020-04-18', '2020-04-18 21:35:09', 
    154000, '64302ea1-212d-414c-a2db-1fad0b3c3b6e', 
    'feb41656-f881-46c4-9e0f-370e6473ebfa', 
    'ce40d185-7224-464f-a538-c39a64403b70', 
    1, NULL, 'd36a743b-8015-4940-8ef4-0ec549d6b6ef'
  ), 
  (
    'bda0acc3-9630-4bbe-85ff-99aa088efc9a', 
    '2019-02-05', '2019-02-09', '2019-02-09 17:23:46', 
    188000, '7641cc47-df84-414a-9847-ddcdc2ff5e89', 
    '3b930fcd-bda9-4c36-90b7-c02525984abe', 
    '16f9acb2-7af8-4007-bb68-b53e51338961', 
    1, NULL, '84240525-7854-4ad2-bf3e-651b6168f27b'
  ), 
  (
    '27c05352-6d95-44f8-9391-9f5507b9d630', 
    '2021-01-10', '2021-01-15', '2021-01-15 13:21:53', 
    142000, '81ebf7b7-1ee3-4da4-b04c-4d1202460288', 
    'a050fd67-53a0-4659-b7ef-f510566a0f7e', 
    '260c03b2-48d5-43bc-8246-dfa9215406bf', 
    1, NULL, '3a3002e6-3ebe-4624-afee-ba43c336c97d'
  ), 
  (
    '4c2c7dd5-274d-4b6d-a6d1-4208f38e924d', 
    '2021-12-12', '2021-12-17', '2021-12-17 10:27:50', 
    127000, 'cefe54f7-d053-4459-95f9-79381583b4c0', 
    '196b292e-d564-4508-94ce-f049e07e8688', 
    'ce249da5-507c-4fc5-901d-0d19e1013948', 
    1, NULL, '84240525-7854-4ad2-bf3e-651b6168f27b'
  ), 
  (
    'c56716cd-3feb-4a84-a207-95340ce34c68', 
    '2021-11-21', '2021-11-25', '2021-11-25 11:10:52', 
    166000, 'de19a8b8-df16-426e-86d4-28e6fa75d95c', 
    'f864622f-e148-4d45-8253-e31fe71754bd', 
    '260c03b2-48d5-43bc-8246-dfa9215406bf', 
    1, 'ISTIMEWA', 'd36a743b-8015-4940-8ef4-0ec549d6b6ef'
  ), 
  (
    '1a20d310-fe48-40da-80b2-3b8d841707ad', 
    '2021-09-13', '2021-09-20', '2021-09-20 09:28:54', 
    133000, '64302ea1-212d-414c-a2db-1fad0b3c3b6e', 
    '196b292e-d564-4508-94ce-f049e07e8688', 
    'ce249da5-507c-4fc5-901d-0d19e1013948', 
    1, NULL, '3a3002e6-3ebe-4624-afee-ba43c336c97d'
  ), 
  (
    '8542d1f2-2a98-4877-91b3-74d2220b44c2', 
    '2021-10-15', '2021-10-20', '2021-10-20 08:18:17', 
    174000, '81ebf7b7-1ee3-4da4-b04c-4d1202460288', 
    'a050fd67-53a0-4659-b7ef-f510566a0f7e', 
    '260c03b2-48d5-43bc-8246-dfa9215406bf', 
    1, NULL, '84240525-7854-4ad2-bf3e-651b6168f27b'
  ), 
  (
    'b0ecb229-f865-4c60-b7b1-4a055be8950c', 
    '2021-08-23', '2021-08-25', '2021-08-25 17:30:10', 
    159000, '7641cc47-df84-414a-9847-ddcdc2ff5e89', 
    '3b930fcd-bda9-4c36-90b7-c02525984abe', 
    '16f9acb2-7af8-4007-bb68-b53e51338961', 
    1, 'BERES', '3a3002e6-3ebe-4624-afee-ba43c336c97d'
  ), 
  (
    'a1ac879d-0c24-49e1-b7b9-db63248d4914', 
    '2021-06-01', '2021-06-07', '2021-06-07 18:19:34', 
    149000, 'cefe54f7-d053-4459-95f9-79381583b4c0', 
    'feb41656-f881-46c4-9e0f-370e6473ebfa', 
    'ce40d185-7224-464f-a538-c39a64403b70', 
    1, 'UNTUNG', '3a3002e6-3ebe-4624-afee-ba43c336c97d'
  ), 
  (
    'de7e9a20-f247-4dce-80b0-620784c8c95f', 
    '2021-04-12', '2021-04-17', '2021-04-17 15:01:07', 
    171000, '81ebf7b7-1ee3-4da4-b04c-4d1202460288', 
    '196b292e-d564-4508-94ce-f049e07e8688', 
    'ce249da5-507c-4fc5-901d-0d19e1013948', 
    1, NULL, '84240525-7854-4ad2-bf3e-651b6168f27b'
  ), 
  (
    'b2f8a34a-6eb2-4cf1-b2f8-340cb8355714', 
    '2021-07-17', '2021-07-20', '2021-07-20 16:23:40', 
    185000, '64302ea1-212d-414c-a2db-1fad0b3c3b6e', 
    'f864622f-e148-4d45-8253-e31fe71754bd', 
    '260c03b2-48d5-43bc-8246-dfa9215406bf', 
    1, 'ISTIMEWA', '62fe7fb8-c22e-4bf3-acbf-9e9d2b8344ed'
  );

INSERT INTO "STATUS_PESANAN" ("Id", "Status") 
VALUES 
  (
    'a7634d70-d6d8-42cf-90e3-dd069bf54e33', 
    'Menunggu Pembayaran'
  ), 
  (
    'e179caba-38d9-4636-ab2e-2032f5284714', 
    'Mencari Pekerja Terdekat'
  ), 
  (
    '57fc8243-eb71-47a5-b74d-81fba6a94f82', 
    'Menunggu Pekerja Berangkat'
  ), 
  (
    '996980f3-cc47-4edb-a8cc-10ec02939479', 
    'Pekerja tiba di lokasi'
  ), 
  (
    '1fe77476-1194-4de7-b7f9-72c8cdd3ef68', 
    'Pelayanan jasa sedang dilakukan'
  ), 
  (
    '3d436422-152e-4b22-b978-49012b58e1f8', 
    'Pesanan selesai'
  ), 
  (
    'd9521320-0b6e-4bf7-971f-b3cb7edec92f', 
    'Pesanan dibatalkan'
  );

INSERT INTO "TR_PEMESANAN_STATUS" (
  "IdTrPemesanan", "IdStatus", "TglWaktu"
) 
VALUES 
  (
    '6d06aca8-c3ad-4f46-b3df-d562dd22fd9a', 
    'a7634d70-d6d8-42cf-90e3-dd069bf54e33', 
    '2021-03-15 15:21:11'
  ), 
  (
    '4aecc4c2-13fc-491c-910e-d6523f12f129', 
    'a7634d70-d6d8-42cf-90e3-dd069bf54e33', 
    '2024-05-20 13:16:45'
  ), 
  (
    '8a355e41-e7fd-445d-a094-abedde646c34', 
    'a7634d70-d6d8-42cf-90e3-dd069bf54e33', 
    '2021-06-15 09:28:34'
  ), 
  (
    '8ba2d0bf-1fb8-49df-a963-a3fe4f2ec5a7', 
    'a7634d70-d6d8-42cf-90e3-dd069bf54e33', 
    '2019-11-03 04:19:27'
  ), 
  (
    '2334f103-e4b5-4a3a-ac6d-a9c9c466031c', 
    'a7634d70-d6d8-42cf-90e3-dd069bf54e33', 
    '2022-02-17 12:34:56'
  ), 
  (
    '6d06aca8-c3ad-4f46-b3df-d562dd22fd9a', 
    'e179caba-38d9-4636-ab2e-2032f5284714', 
    '2021-03-15 15:26:01'
  ), 
  (
    '4aecc4c2-13fc-491c-910e-d6523f12f129', 
    'e179caba-38d9-4636-ab2e-2032f5284714', 
    '2021-05-29 10:50:10'
  ), 
  (
    '8a355e41-e7fd-445d-a094-abedde646c34', 
    'e179caba-38d9-4636-ab2e-2032f5284714', 
    '2021-06-18 09:43:44'
  ), 
  (
    '8ba2d0bf-1fb8-49df-a963-a3fe4f2ec5a7', 
    'e179caba-38d9-4636-ab2e-2032f5284714', 
    '2019-11-05 04:41:41'
  ), 
  (
    '2334f103-e4b5-4a3a-ac6d-a9c9c466031c', 
    'e179caba-38d9-4636-ab2e-2032f5284714', 
    '2022-02-18 12:04:06'
  ), 
  (
    '6d06aca8-c3ad-4f46-b3df-d562dd22fd9a', 
    '57fc8243-eb71-47a5-b74d-81fba6a94f82', 
    '2021-03-20 08:12:31'
  ), 
  (
    '4aecc4c2-13fc-491c-910e-d6523f12f129', 
    '57fc8243-eb71-47a5-b74d-81fba6a94f82', 
    '2021-05-29 10:52:23'
  ), 
  (
    '8a355e41-e7fd-445d-a094-abedde646c34', 
    '57fc8243-eb71-47a5-b74d-81fba6a94f82', 
    '2021-06-18 13:31:34'
  ), 
  (
    '8ba2d0bf-1fb8-49df-a963-a3fe4f2ec5a7', 
    '57fc8243-eb71-47a5-b74d-81fba6a94f82', 
    '2019-11-05 06:03:03'
  ), 
  (
    '2334f103-e4b5-4a3a-ac6d-a9c9c466031c', 
    '57fc8243-eb71-47a5-b74d-81fba6a94f82', 
    '2022-02-18 17:08:30'
  ), 
  (
    '6d06aca8-c3ad-4f46-b3df-d562dd22fd9a', 
    '996980f3-cc47-4edb-a8cc-10ec02939479', 
    '2021-03-20 10:42:13'
  ), 
  (
    '4aecc4c2-13fc-491c-910e-d6523f12f129', 
    '996980f3-cc47-4edb-a8cc-10ec02939479', 
    '2021-05-29 11:54:54'
  ), 
  (
    '8a355e41-e7fd-445d-a094-abedde646c34', 
    '996980f3-cc47-4edb-a8cc-10ec02939479', 
    '2021-06-18 14:31:42'
  ), 
  (
    '8ba2d0bf-1fb8-49df-a963-a3fe4f2ec5a7', 
    '996980f3-cc47-4edb-a8cc-10ec02939479', 
    '2019-11-05 08:14:42'
  ), 
  (
    '2334f103-e4b5-4a3a-ac6d-a9c9c466031c', 
    '996980f3-cc47-4edb-a8cc-10ec02939479', 
    '2022-02-18 19:06:39'
  ), 
  (
    '6d06aca8-c3ad-4f46-b3df-d562dd22fd9a', 
    '1fe77476-1194-4de7-b7f9-72c8cdd3ef68', 
    '2021-03-20 10:44:29'
  ), 
  (
    '4aecc4c2-13fc-491c-910e-d6523f12f129', 
    '1fe77476-1194-4de7-b7f9-72c8cdd3ef68', 
    '2021-05-29 11:57:16'
  ), 
  (
    '8a355e41-e7fd-445d-a094-abedde646c34', 
    '1fe77476-1194-4de7-b7f9-72c8cdd3ef68', 
    '2021-06-18 14:40:19'
  ), 
  (
    '8ba2d0bf-1fb8-49df-a963-a3fe4f2ec5a7', 
    '1fe77476-1194-4de7-b7f9-72c8cdd3ef68', 
    '2019-11-05 08:30:23'
  ), 
  (
    '2334f103-e4b5-4a3a-ac6d-a9c9c466031c', 
    '1fe77476-1194-4de7-b7f9-72c8cdd3ef68', 
    '2022-02-18 19:08:33'
  ), 
  (
    '6d06aca8-c3ad-4f46-b3df-d562dd22fd9a', 
    '3d436422-152e-4b22-b978-49012b58e1f8', 
    '2021-03-20 17:14:34'
  ), 
  (
    '4aecc4c2-13fc-491c-910e-d6523f12f129', 
    '3d436422-152e-4b22-b978-49012b58e1f8', 
    '2021-05-29 13:05:32'
  ), 
  (
    '8a355e41-e7fd-445d-a094-abedde646c34', 
    '3d436422-152e-4b22-b978-49012b58e1f8', 
    '2021-06-18 16:30:15'
  ), 
  (
    '8ba2d0bf-1fb8-49df-a963-a3fe4f2ec5a7', 
    '3d436422-152e-4b22-b978-49012b58e1f8', 
    '2019-11-05 10:15:46'
  ), 
  (
    '2334f103-e4b5-4a3a-ac6d-a9c9c466031c', 
    '3d436422-152e-4b22-b978-49012b58e1f8', 
    '2022-02-18 20:10:24'
  ), 
  (
    '08a6553f-b369-4282-a875-9ddbb6e2cecc', 
    'd9521320-0b6e-4bf7-971f-b3cb7edec92f', 
    '2023-09-11 12:10:49'
  ), 
  (
    '4c9370ab-73d1-4efc-b9e5-62aedfd87453', 
    'd9521320-0b6e-4bf7-971f-b3cb7edec92f', 
    '2020-04-17 01:43:44'
  ), 
  (
    'bda0acc3-9630-4bbe-85ff-99aa088efc9a', 
    'd9521320-0b6e-4bf7-971f-b3cb7edec92f', 
    '2019-02-05 12:23:55'
  ), 
  (
    '61a73148-41bd-44df-a476-a470b1afdf4d', 
    'd9521320-0b6e-4bf7-971f-b3cb7edec92f', 
    '2023-09-11 15:13:01'
  ), 
  (
    'c7c5d7d8-87a8-4934-af31-2d227a49b4ff', 
    'd9521320-0b6e-4bf7-971f-b3cb7edec92f', 
    '2020-07-08 23:44:10'
  ),
  (
    '489a3c4b-6d5d-447e-8a37-fbf06f5f62db',
    '57fc8243-eb71-47a5-b74d-81fba6a94f82',
    '2023-11-05 14:12:45'
  ),
  (
    '4c2c7dd5-274d-4b6d-a6d1-4208f38e924d',
    '57fc8243-eb71-47a5-b74d-81fba6a94f82',
    '2024-01-10 09:34:21'
  ),
  (
    '24d73f22-301c-423b-b805-bbe78d584aa9',
    '57fc8243-eb71-47a5-b74d-81fba6a94f82',
    '2023-12-20 18:27:33'
  ),
  (
    '1a20d310-fe48-40da-80b2-3b8d841707ad',
    '57fc8243-eb71-47a5-b74d-81fba6a94f82',
    '2023-10-15 06:19:57'
  ),
  (
    '27c05352-6d95-44f8-9391-9f5507b9d630',
    '57fc8243-eb71-47a5-b74d-81fba6a94f82',
    '2024-02-08 21:43:12'
  ),
  (
    '8542d1f2-2a98-4877-91b3-74d2220b44c2',
    '57fc8243-eb71-47a5-b74d-81fba6a94f82',
    '2023-09-25 13:15:03'
  ),
  (
    '518a9050-cd17-4a7e-af31-418e5a7d290d',
    '57fc8243-eb71-47a5-b74d-81fba6a94f82',
    '2024-03-14 11:20:56'
  ),
  (
    'c56716cd-3feb-4a84-a207-95340ce34c68',
    '57fc8243-eb71-47a5-b74d-81fba6a94f82',
    '2024-04-22 16:02:31'
  ),
  (
    'f1079ee4-0ce6-4077-b684-cf6140af670e',
    '57fc8243-eb71-47a5-b74d-81fba6a94f82',
    '2023-08-17 08:45:49'
  ),
  (
    'a1ac879d-0c24-49e1-b7b9-db63248d4914',
    '57fc8243-eb71-47a5-b74d-81fba6a94f82',
    '2023-07-30 23:56:18'
  ),
  (
    '88cb54f1-dbc2-48a6-adae-30fdc8bb1b84',
    '57fc8243-eb71-47a5-b74d-81fba6a94f82',
    '2024-01-05 07:14:22'
  ),
  (
    '18724b2b-ae84-4ae3-b283-6fd32bf6c570',
    '57fc8243-eb71-47a5-b74d-81fba6a94f82',
    '2023-06-13 17:50:08'
  ),
  (
    'b0ecb229-f865-4c60-b7b1-4a055be8950c',
    '57fc8243-eb71-47a5-b74d-81fba6a94f82',
    '2024-03-03 15:40:25'
  ),
  (
    'de7e9a20-f247-4dce-80b0-620784c8c95f',
    '57fc8243-eb71-47a5-b74d-81fba6a94f82',
    '2023-11-22 10:29:40'
  ),
  (
    'b2f8a34a-6eb2-4cf1-b2f8-340cb8355714',
    '57fc8243-eb71-47a5-b74d-81fba6a94f82',
    '2023-12-15 19:05:11'
  );


INSERT INTO "TESTIMONI" (
  "IdTrPemesanan", "Tgl", "Teks", "Rating"
) 
VALUES 
  (
    '6d06aca8-c3ad-4f46-b3df-d562dd22fd9a', 
    '2025-02-15', 'Pelayanan yang sangat memuaskan!', 
    5
  ), 
  (
    '4aecc4c2-13fc-491c-910e-d6523f12f129', 
    '2025-03-22', 'Harga sesuai dengan kualitas, recommended!', 
    4
  ), 
  (
    '8a355e41-e7fd-445d-a094-abedde646c34', 
    '2025-05-05', 'Pengalaman baik, hanya perlu perbaikan kecil.', 
    4
  ), 
  (
    '8ba2d0bf-1fb8-49df-a963-a3fe4f2ec5a7', 
    '2025-07-17', 'Kurang memuaskan, banyak keterlambatan.', 
    2
  ), 
  (
    '2334f103-e4b5-4a3a-ac6d-a9c9c466031c', 
    '2025-08-10', 'Layanan buruk, tidak akan menggunakan lagi.', 
    1
  ), 
  (
    '489a3c4b-6d5d-447e-8a37-fbf06f5f62db', 
    '2025-09-12', 'Mengesankan, saya akan kembali lagi!', 
    5
  ), 
  (
    '18724b2b-ae84-4ae3-b283-6fd32bf6c570', 
    '2025-10-19', 'Cukup baik, tetapi bisa lebih baik.', 
    3
  ), 
  (
    'f1079ee4-0ce6-4077-b684-cf6140af670e', 
    '2025-11-25', 'Saya sangat puas, profesional dan cepat.', 
    5
  ), 
  (
    '88cb54f1-dbc2-48a6-adae-30fdc8bb1b84', 
    '2025-12-03', 'Layanan cukup bagus tapi masih ada ruang untuk perbaikan.', 
    3
  ), 
  (
    '27c05352-6d95-44f8-9391-9f5507b9d630', 
    '2025-01-18', 'Pengalaman buruk, tidak sesuai ekspektasi.', 
    1
  ), 
  (
    '4c2c7dd5-274d-4b6d-a6d1-4208f38e924d', 
    '2025-03-27', 'Bagus, tapi customer service lambat merespon.', 
    3
  ), 
  (
    'c56716cd-3feb-4a84-a207-95340ce34c68', 
    '2025-04-07', 'Harga mahal, tapi kualitAS bagus.', 
    4
  ), 
  (
    '8542d1f2-2a98-4877-91b3-74d2220b44c2', 
    '2025-06-30', 'KualitAS baik tapi perlu ditingkatkan pelayanannya.', 
    4
  ), 
  (
    'b0ecb229-f865-4c60-b7b1-4a055be8950c', 
    '2025-07-05', 'Kecewa dengan hasilnya.', 
    2
  ), 
  (
    'de7e9a20-f247-4dce-80b0-620784c8c95f', 
    '2025-08-29', 'Sangat cepat dan efisien, luar biasa!', 
    5
  ), 
  (
    'a1ac879d-0c24-49e1-b7b9-db63248d4914', 
    '2025-10-14', 'Pelayanan cukup baik, akan menggunakan lagi.', 
    4
  ), 
  (
    'b2f8a34a-6eb2-4cf1-b2f8-340cb8355714', 
    '2025-12-21', 'Prosesnya lama dan tidak memuaskan.', 
    2
  );

