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
--   $5::VARCHAR, -- password
--   $6::DATE,    -- tanggal lahir
--   $7::VARCHAR, -- alamat
--   $8::VARCHAR, -- nama bank
--   $9::VARCHAR, -- nomor rekening
--   $10::VARCHAR, -- npwp
--   $11::VARCHAR -- link foto
-- );

-- CREATE OR REPLACE FUNCTION update_profile_pelanggan (
--
-- ) RETURNS VOID AS $$
-- $$ LANGUAGE plpgsql;
