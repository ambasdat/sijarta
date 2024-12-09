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
  AND T."TglAkhir" < CURRENT_DATE; 
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


