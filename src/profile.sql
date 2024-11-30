CREATE OR REPLACE FUNCTION update_profile_pekerja (
  pekerjaId UUID,
  nama VARCHAR,
  jk CHAR(1),
  nohp VARCHAR,
  tglLahir DATE,
  alamat VARCHAR,
  namaBank VARCHAR,
  nomorRekening VARCHAR,
  npwp VARCHAR,
  linkFoto VARCHAR
) RETURNS VOID AS $$
BEGIN
  UPDATE "USER"
  SET
    "Nama" = nama,
    "JenisKelamin" = jk,
    "NoHP" = nohp,
    "TglLahir" = tglLahir,
    "Alamat" = alamat
  WHERE "Id" = pekerjaId;

  UPDATE "PEKERJA"
  SET
    "NamaBank" = namaBank,
    "NomorRekening" = nomorRekening,
    "NPWP" = npwp,
    "LinkFoto" = linkFoto
  WHERE "Id" = pekerjaId;
END;
$$ LANGUAGE plpgsql;

-- SELECT update_profile_pekerja(
--   $1::UUID,    -- pekerjaId
--   $2::VARCHAR, -- nama
--   $3::CHAR(1), -- jenis kelamin
--   $4::VARCHAR, -- nomor hp
--   $5::DATE,    -- tanggal lahir
--   $6::VARCHAR, -- alamat
--   $7::VARCHAR, -- nama bank
--   $8::VARCHAR, -- nomor rekening
--   $9::VARCHAR, -- npwp
--   $10::VARCHAR -- link foto
-- );

CREATE OR REPLACE FUNCTION update_profile_pelanggan (
  pelangganId UUID,
  nama VARCHAR,
  jk CHAR(1),
  nohp VARCHAR,
  tglLahir DATE,
  alamat VARCHAR
) RETURNS VOID AS $$
BEGIN
  UPDATE "USER"
  SET
    "Nama" = nama,
    "JenisKelamin" = jk,
    "NoHP" = nohp,
    "TglLahir" = tglLahir,
    "Alamat" = alamat
  WHERE "Id" = pelangganId;
END;
$$ LANGUAGE plpgsql;

-- SELECT update_profile_pelanggan(
--   $1::UUID,    -- pekerjaId
--   $2::VARCHAR, -- nama
--   $3::CHAR(1), -- jenis kelamin
--   $4::VARCHAR, -- nomor hp
--   $5::DATE,    -- tanggal lahir
--   $6::VARCHAR  -- alamat
-- );
