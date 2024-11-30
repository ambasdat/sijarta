CREATE OR REPLACE FUNCTION getAllForHome(sub VARCHAR, kat VARCHAR) 
    RETURNS TABLE(
        "Id" UUID,
        "Kat" VARCHAR,
        "Sub" VARCHAR
    ) AS 
    $$
    BEGIN
        RETURN QUERY
        SELECT 
            SJ."Id", 
            KJ."NamaKategori", 
            SJ."NamaSubkategori" 
        FROM 
            "SUBKATEGORI_JASA" AS SJ
            LEFT JOIN "KATEGORI_JASA" AS KJ ON SJ."KategoriJasaId" = KJ."Id"
        WHERE
            (sub = '' OR SJ."NamaSubkategori" ILIKE '%' || sub || '%')
            AND (kat = '' OR KJ."NamaKategori" = kat);
    END;
    $$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION isPelanggan(p_id UUID)
    RETURNS BOOLEAN AS
    $$
    BEGIN
        RETURN EXISTS (
            SELECT 1 FROM "PELANGGAN" WHERE "Id" = p_id
        );
    END;
    $$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION isPekerja(p_id UUID)
    RETURNS BOOLEAN AS
    $$
    BEGIN
        RETURN EXISTS (
            SELECT 1 FROM "PEKERJA" WHERE "Id" = p_id
        );
    END;
    $$
    LANGUAGE plpgsql;