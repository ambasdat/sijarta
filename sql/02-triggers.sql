-- Ketika ada akun baru yang mendaftar, sistem terlebih dahulu mengecek apakah
-- no HP sudah terdaftar atau belum. Jika no HP sudah terdaftar, keluarkan
-- pesan error.
CREATE OR REPLACE FUNCTION check_new_user()
RETURNS TRIGGER AS $$
BEGIN
  IF (OLD."NoHP" <> NEW."NoHP") THEN
    IF EXISTS (SELECT 1 FROM "USER" WHERE "NoHP" = NEW."NoHP") THEN
      RAISE EXCEPTION 'No HP already used';
    END IF;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER trg_check_new_user
BEFORE INSERT OR UPDATE ON "USER"
FOR EACH ROW EXECUTE FUNCTION check_new_user();

-- Ketika ada user mendaftarkan akun baru sebagai pekerja maka sistem akan
-- terlebih dahulu memastikan bahwa tidak ada pekerja lain yang memiliki
-- kombinasi nama bank dan nomor rekening yang sama telah terdaftar, jika
-- ada maka keluarkan pesan error.
CREATE OR REPLACE FUNCTION check_new_pekerja()
RETURNS TRIGGER AS $$
BEGIN
  IF (OLD."NamaBank" <> NEW."NamaBank" OR OLD."NomorRekening" <> NEW."NomorRekening") THEN
    IF EXISTS (SELECT 1 FROM "PEKERJA" WHERE "NamaBank" = NEW."NamaBank" AND "NomorRekening" = NEW."NomorRekening") THEN
      RAISE EXCEPTION 'Bank information already used';
    END IF;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER trg_check_new_pekerja
BEFORE INSERT OR UPDATE ON "PEKERJA"
FOR EACH ROW EXECUTE FUNCTION check_new_pekerja();


CREATE OR REPLACE FUNCTION GET_TOTAL_PAYMENT(IDTR UUID)
  RETURNS INTEGER AS
  $$
  DECLARE
    RESULT INTEGER;
  BEGIN
    IF NOT EXISTS(
      SELECT 1
      FROM "TR_PEMESANAN_JASA"
      WHERE "Id" = IDTR
    )
    THEN
      RAISE EXCEPTION 'NO ID MATCH';
    END IF;
    
    SELECT "TotalBiaya" INTO RESULT
    FROM "TR_PEMESANAN_JASA"
    WHERE "Id" = IDTR;

    RETURN RESULT;
  END;
  $$
  LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION GET_USER_ID(IDTR UUID)
  RETURNS UUID AS
  $$
  DECLARE
    RESULT UUID;
  BEGIN
    IF NOT EXISTS(
      SELECT 1
      FROM "TR_PEMESANAN_JASA"
      WHERE "Id" = IDTR
    )
    THEN
      RAISE EXCEPTION 'NO ID MATCH';
    END IF;
    
    SELECT "IdPelanggan" INTO RESULT
    FROM "TR_PEMESANAN_JASA"
    WHERE "Id" = IDTR;

    RETURN RESULT;
  END;
  $$
  LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION RETURN_BALANCE()
  RETURNS TRIGGER AS
  $$ BEGIN
    IF NEW."IdStatus" IN (
      SELECT "Id"
      FROM "STATUS_PESANAN"
      WHERE "Status" = 'Pesanan dibatalkan'
    )
    THEN
      UPDATE "USER"
      SET "SaldoMyPay" = "SaldoMyPay" + GET_TOTAL_PAYMENT(NEW."IdTrPemesanan")
      WHERE "Id" = GET_USER_ID(NEW."IdTrPemesanan");
    END IF;
  
    RETURN NEW;
  END;
  $$
  LANGUAGE PLPGSQL;

CREATE OR REPLACE TRIGGER TRIGGER_RETURN_BALANCE
AFTER INSERT ON "TR_PEMESANAN_STATUS"
FOR EACH ROW EXECUTE FUNCTION RETURN_BALANCE();

-- Ketika pengguna ingin menggunakan voucher lakukan pengecekan bahwa voucher
-- yang digunakan tidak melewati batas jumlah penggunaan atau batasan hari
-- berlaku. Jika voucher telah melewati batas jumlah penggunaan atau batasan
-- hari berlaku maka keluarkan pesan error.
CREATE OR REPLACE FUNCTION validate_voucher_usage()
RETURNS TRIGGER AS $$
DECLARE
  v_end_date DATE;
BEGIN
  SELECT tpv."TglAkhir" INTO v_end_date
  FROM "TR_PEMBELIAN_VOUCHER" AS tpv
  WHERE tpv."IdPelanggan" = NEW."IdPelanggan" AND tpv."IdVoucher" = NEW."IdDiskon";

  IF v_end_date IS NULL
  THEN
    RETURN NEW;
  END IF;

  IF CURRENT_DATE > v_end_date
  THEN
    RAISE EXCEPTION 'Voucher % telah kedaluwarsa', NEW."IdDiskon";
  END IF;

  IF (SELECT COUNT(*) FROM "TR_PEMESANAN_JASA" WHERE "IdDiskon" = NEW."IdDiskon" AND "IdPelanggan" = NEW."IdPelanggan")
  >= (SELECT "KuotaPenggunaan" FROM "VOUCHER" WHERE "Kode" = NEW."IdDiskon")
  THEN
    RAISE EXCEPTION 'Voucher % telah mencapai batas maksimum penggunaan', NEW."IdDiskon";
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validate_voucher_usage
BEFORE INSERT OR UPDATE ON "TR_PEMESANAN_JASA"
FOR EACH ROW EXECUTE FUNCTION validate_voucher_usage();

-- Ketika pekerja selesai mengerjakan pemesanan jasa yang dibuat oleh pengguna,
-- dan status pemesanan jasa berubah menjadi “Pesanan selesai” maka nominal
-- transaksi yang dibuat oleh pengguna akan otomatis di transferkan ke saldo
-- MyPay pekerja dengan kategori “menerima honor transaksi jasa”.

-- Step 1: Create a Stored Procedure to Process the Payment
CREATE OR REPLACE FUNCTION process_pekerja_payment() 
RETURNS TRIGGER AS $$
DECLARE
  v_total_biaya DECIMAL;
  v_pekerja_id UUID;
  v_level INT;
  v_pelanggan_id UUID;
  v_kategori_tr UUID;
BEGIN
  -- Proceed only if the status is "Pesanan selesai"
  IF NEW."IdStatus" = (SELECT "Id" FROM "STATUS_PESANAN" WHERE "Status" = 'Pesanan selesai') THEN

    -- Retrieve TotalBiaya and IdPekerja from TR_PEMESANAN_JASA
    SELECT tr_j."TotalBiaya", tr_j."IdPekerja", tr_j."IdPelanggan" INTO v_total_biaya, v_pekerja_id, v_pelanggan_id
    FROM "TR_PEMESANAN_JASA" tr_j
    WHERE tr_j."Id" = NEW."IdTrPemesanan";

    -- Retrieve the transaction category ID for "menerima honor transaksi jasa"
    SELECT "Id" INTO v_kategori_tr
    FROM "KATEGORI_TR_MYPAY"
    WHERE "Nama" = 'menerima honor transaksi jasa';

    -- Insert the transaction into TR_MYPAY
    INSERT INTO "TR_MYPAY" ("Id", "UserId", "Tgl", "Nominal", "KategoriId")
    VALUES (gen_random_uuid(), v_pekerja_id, CURRENT_DATE, v_total_biaya, v_kategori_tr);

    -- Update the worker's MyPay balance
    UPDATE "USER"
    SET "SaldoMyPay" = "SaldoMyPay" + v_total_biaya
    WHERE "Id" = v_pekerja_id;

    -- Update Jumlah Pesanan selesai dari Pekerja
    UPDATE "PEKERJA"
    SET "JmlPesananSelesai" = "JmlPesananSelesai" + 1
    WHERE "Id" = v_pekerja_id;

    -- Cari jumlah pemesanan yang dilakukan Pelanggan
    SELECT COUNT(*) INTO v_level
    FROM "TR_PEMESANAN_JASA" tpj
    JOIN "TR_PEMESANAN_STATUS" tps ON tpj."Id" = tps."IdTrPemesanan"
    WHERE
      "IdPelanggan" = '64302ea1-212d-414c-a2db-1fad0b3c3b6e' AND
      "IdStatus" = (SELECT "Id" FROM "STATUS_PESANAN" WHERE "Status" = 'Pesanan selesai');

    -- Update level Pelanggan
    UPDATE "PELANGGAN"
    SET "Level" = CASE
      WHEN v_level < 10 THEN 'Basic'
      WHEN v_level >= 10 AND v_level < 30 THEN 'Silver'
      WHEN v_level >= 30 THEN 'Gold'
    END
    WHERE "Id" = v_pelanggan_id;

  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Step 2: Create the Trigger on TR_PEMESANAN_STATUS
CREATE TRIGGER trg_pemesanan_status_update
AFTER INSERT OR UPDATE ON "TR_PEMESANAN_STATUS"
FOR EACH ROW
EXECUTE FUNCTION process_pekerja_payment();

-- Update rating pekerja ketika pekerja tersebut mendapatkan testimoni dari
-- user mengenai pekerjaan yang dilakukannya

CREATE OR REPLACE FUNCTION update_rating_pekerja ()
RETURNS TRIGGER AS $$
DECLARE
  IdTrPemesanan UUID;
  IdPekerja UUID;
  AvgRating FLOAT;
BEGIN
  IF (TG_OP = 'DELETE') THEN
    IdTrPemesanan := OLD."IdTrPemesanan";
  ELSE
    IdTrPemesanan := NEW."IdTrPemesanan";
  END IF;

  SELECT COALESCE("IdPekerja", NULL) INTO IdPekerja
  FROM "TR_PEMESANAN_JASA"
  WHERE "Id" = IdTrPemesanan;

  SELECT COALESCE(AVG("Rating"), 0) INTO AvgRating
  FROM "TR_PEMESANAN_JASA" tpj
  JOIN "TESTIMONI" ttm ON ttm."IdTrPemesanan" = tpj."Id"
  WHERE tpj."IdPekerja" = IdPekerja;

  UPDATE "PEKERJA"
  SET "Rating" = AvgRating
  WHERE "Id" = IdPekerja;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_rating_pekerja
AFTER INSERT OR UPDATE OR DELETE ON "TESTIMONI"
FOR EACH ROW
EXECUTE FUNCTION update_rating_pekerja();
