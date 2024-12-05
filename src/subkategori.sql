CREATE OR REPLACE FUNCTION getDesc(p_id UUID)
    RETURNS TABLE(
        "Sub" VARCHAR,
        "Desc" TEXT,
        "Kat" VARCHAR,
        "KatID" UUID
    ) AS
    $$
        BEGIN
            RETURN QUERY
            SELECT
                SJ."NamaSubkategori", 
                SJ."Deskripsi", 
                KJ."NamaKategori",
                KJ."Id"
            FROM
                "SUBKATEGORI_JASA" AS SJ
                JOIN "KATEGORI_JASA" AS KJ ON SJ."KategoriJasaId" = KJ."Id"
            WHERE
                SJ."Id" = p_id;
        END;
    $$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION getSession(p_id UUID)
    RETURNS TABLE(
        "Sesi" INT,
        "Harga" DECIMAL
    ) AS
    $$
        BEGIN
            RETURN QUERY
            SELECT 
                SL."Sesi", 
                SL."Harga"
            FROM 
                "SESI_LAYANAN" AS SL
            WHERE
                SL."SubkategoriId" = p_id;
        END;
    $$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION getPekerja(p_id UUID)
    RETURNS TABLE(
        "Id" UUID,
        "Nama" VARCHAR,
        "LinkFoto" VARCHAR
    ) AS
    $$
        BEGIN
            RETURN QUERY
            SELECT
                P."Id",
                U."Nama",
                P."LinkFoto"
            FROM
                "PEKERJA_KATEGORI_JASA" AS PKJ
                JOIN "PEKERJA" AS P ON PKJ."PekerjaId" = P."Id"
                JOIN "USER" AS U ON P."Id" = U."Id"
            WHERE
                PKJ."KategoriJasaId" = p_id;
        END;
    $$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION getTestimoni(p_id UUID)
    RETURNS TABLE(
        "NamaPelanggan" VARCHAR,
        "NamaPekerja" VARCHAR,
        "Tgl" DATE,
        "Teks" TEXT,
        "Rating" INT
    ) AS
    $$
        BEGIN
            RETURN QUERY
            SELECT
                UPEL."Nama" as "NamaPelanggan",
                UPEK."Nama" as "NamaPekerja",
                T."Tgl",
                T."Teks",
                T."Rating"
            FROM
                "TR_PEMESANAN_JASA" AS TPJ
                JOIN "PELANGGAN" AS PEL ON TPJ."IdPelanggan" = PEL."Id"
                JOIN "USER" AS UPEL ON PEL."Id" = UPEL."Id"
                JOIN "PEKERJA" AS PEK ON TPJ."IdPekerja" = PEK."Id"
                JOIN "USER" AS UPEK ON PEK."Id" = UPEK."Id"
                JOIN "TESTIMONI" AS T ON T."IdTrPemesanan" = TPJ."Id"
            WHERE
                TPJ."IdKategoriJasa" = p_id;
        END;
    $$
    LANGUAGE plpgsql;