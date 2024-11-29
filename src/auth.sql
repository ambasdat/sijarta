CREATE OR REPLACE FUNCTION insert_pekerja (
  nama VARCHAR,
  jk CHAR(1),
  nohp VARCHAR,
  pwd VARCHAR,
  tglLahir DATE,
  alamat VARCHAR,
  namaBank VARCHAR,
  nomorRekening VARCHAR,
  npwp VARCHAR,
  linkFoto VARCHAR
) RETURNS UUID AS $$
DECLARE
  id UUID;
BEGIN
  INSERT INTO "USER" ("Nama", "JenisKelamin", "NoHP", "Pwd", "TglLahir", "Alamat", "SaldoMyPay")
  VALUES (nama, jk, nohp, pwd, tglLahir, alamat, 0)
  RETURNING "Id" INTO id;

  INSERT INTO "PEKERJA" ("Id", "NamaBank", "NomorRekening", "NPWP", "LinkFoto")
  VALUES (id, namaBank, nomorRekening, npwp, linkFoto);

  RETURN id;
END;
$$ LANGUAGE plpgsql;

-- SELECT insert_pekerja(
--   $1::VARCHAR, -- nama
--   $2::CHAR(1), -- jenis kelamin
--   $3::VARCHAR, -- nomor hp
--   $4::VARCHAR, -- password
--   $5::DATE,    -- tanggal lahir
--   $6::VARCHAR, -- alamat
--   $7::VARCHAR, -- nama bank
--   $8::VARCHAR, -- nomor rekening
--   $9::VARCHAR, -- npwp
--   $10::VARCHAR -- link foto
-- );
