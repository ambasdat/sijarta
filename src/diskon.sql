CREATE OR REPLACE FUNCTION get_all_voucher_details()
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
  JOIN "DISKON" D ON V."Kode" = D."Kode";
END;
$$ LANGUAGE plpgsql;

