CREATE OR REPLACE FUNCTION get_all_voucher_details(IdPelanggan UUID)
RETURNS TABLE(
  Kode VARCHAR, 
  Potongan DECIMAL,
  MinTrPemesanan INT,
  JmlHariBerlaku INT,
  KuotaPenggunaan INT,
  Harga DECIMAL
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    V."Kode",
    D."Potongan",
    D."MinTrPemesanan",
    V."JmlHariBerlaku",
    V."KuotaPenggunaan",
    V."Harga"
  FROM "VOUCHER" V
  JOIN "DISKON" D ON V."Kode" = D."Kode"
  WHERE V."Kode" NOT IN (
    SELECT T."IdVoucher" FROM "TR_PEMBELIAN_VOUCHER" T
    WHERE  T."IdVoucher" = V."Kode"
    AND T."IdPelanggan" = IdPelanggan
  );
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_users_vouchers(IdPelanggan UUID)
RETURNS TABLE(
  IdVoucher VARCHAR, 
  TglAkhir DATE,
  KuotaPenggunaan INT,
  TelahDigunakan INT
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    T."IdVoucher",
    T."TglAkhir",
    V."KuotaPenggunaan",
    T."TelahDigunakan"
  FROM "VOUCHER" V
  JOIN "TR_PEMBELIAN_VOUCHER" T ON T."IdVoucher" = V."Kode"
  WHERE T."IdPelanggan" = IdPelanggan
  AND T."TglAkhir" >= CURRENT_DATE; 
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION get_promos()
RETURNS TABLE(
  Kode VARCHAR, 
  TglAkhirBerlaku DATE
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    P."Kode",
    P."TglAkhirBerlaku"
  FROM "PROMO" P
  JOIN "DISKON" D ON P."Kode" = D."Kode";
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION buy_voucher(
  userId UUID,
  voucherCode VARCHAR,
  paymentMethod VARCHAR
) RETURNS DECIMAL AS $$
DECLARE
  SaldoMyPay DECIMAL;
  JmlHariBerlaku INT;
  Harga DECIMAL;
  IdMetodeBayar UUID;
BEGIN
  SELECT "SaldoMyPay" INTO SaldoMyPay
  FROM "USER"
  WHERE "Id" = userId;

  SELECT "Id" INTO IdMetodeBayar
  FROM "METODE_BAYAR"
  WHERE "Nama" = paymentMethod;

  IF SaldoMyPay IS NULL THEN
    RAISE EXCEPTION 'User tidak ditemukan.';
  END IF;

  SELECT "Harga", "JmlHariBerlaku" INTO Harga, JmlHariBerlaku
  FROM "VOUCHER"
  WHERE "Kode" = voucherCode;

  IF paymentMethod = 'MyPay' AND Harga > SaldoMyPay THEN
    RAISE EXCEPTION 'Saldo tidak cukup.';
  END IF;

  IF paymentMethod = 'MyPay' THEN
    INSERT INTO "TR_MYPAY" (
      "UserId", "Tgl", "Nominal", "KategoriId"
    ) 
    VALUES (
      userId, CURRENT_DATE, Harga, '6f4ffb85-9e44-49e4-9e6b-87d297d5134d'
    );
  END IF;

  UPDATE "USER"
  SET "SaldoMyPay" = "SaldoMyPay" - Harga
  WHERE "Id" = userId;

  INSERT INTO "TR_PEMBELIAN_VOUCHER" (
    "TglAwal", "TglAkhir", "TelahDigunakan", 
    "IdPelanggan", "IdVoucher", "IdMetodeBayar"
  )
  VALUES (
    CURRENT_DATE, CURRENT_DATE + JmlHariBerlaku * INTERVAL '1 day', 0, 
    userId, voucherCode, IdMetodeBayar
  );

  RETURN 0;
END;
$$ LANGUAGE plpgsql;


