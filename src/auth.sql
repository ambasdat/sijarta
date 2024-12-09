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

  INSERT INTO "PEKERJA" ("Id", "NamaBank", "NomorRekening", "NPWP", "LinkFoto", "Rating", "JmlPesananSelesai")
  VALUES (id, namaBank, nomorRekening, npwp, linkFoto, 0, 0);

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

CREATE OR REPLACE FUNCTION insert_pelanggan (
  nama VARCHAR,
  jk CHAR(1),
  nohp VARCHAR,
  pwd VARCHAR,
  tglLahir DATE,
  alamat VARCHAR
) RETURNS UUID AS $$
DECLARE
  id UUID;
BEGIN
  INSERT INTO "USER" ("Nama", "JenisKelamin", "NoHP", "Pwd", "TglLahir", "Alamat", "SaldoMyPay")
  VALUES (nama, jk, nohp, pwd, tglLahir, alamat, 0)
  RETURNING "Id" INTO id;

  INSERT INTO "PELANGGAN" ("Id", "Level") VALUES (id, 'Basic');

  RETURN id;
END;
$$ LANGUAGE plpgsql;

-- SELECT insert_pelanggan(
--   $1::VARCHAR, -- nama 
--   $2::CHAR(1), -- jk 
--   $3::VARCHAR, -- nohp 
--   $4::VARCHAR, -- pwd 
--   $5::DATE,    -- tglLahir 
--   $6::VARCHAR  -- alamat 
-- );

CREATE OR REPLACE FUNCTION login(nohp VARCHAR, pwd VARCHAR)
RETURNS UUID AS $$
DECLARE
  id UUID;
  storedPwd VARCHAR;
BEGIN
  SELECT "Id", "Pwd" INTO id, storedPwd FROM "USER" WHERE "NoHP" = nohp;

  IF storedPwd IS NULL THEN
    RAISE EXCEPTION 'User with phone number % not found.', nohp;
  END IF;

  IF storedPwd <> pwd THEN
    RAISE EXCEPTION 'Incorrect password!';
  END IF;

  RETURN id;
END;
$$ LANGUAGE plpgsql;

-- SELECT login(
--   $1::VARCHAR, -- no hp
--   $2::VARCHAR  -- password
-- );
