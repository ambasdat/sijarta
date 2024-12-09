DROP FUNCTION IF EXISTS getAllForHome(sub VARCHAR, kat VARCHAR);

CREATE OR REPLACE FUNCTION getAllForHome(sub VARCHAR, kat VARCHAR) 
    RETURNS TABLE(
        "Id" UUID,
        "Kat" VARCHAR,
        "Sub" JSON
    ) AS 
    $$
    BEGIN
        RETURN QUERY
        SELECT
            KJ."Id",
            KJ."NamaKategori",
            JSON_AGG(JSON_BUILD_OBJECT('Id', SJ."Id", 'Nama', SJ."NamaSubkategori"))
        FROM 
            "SUBKATEGORI_JASA" AS SJ
            LEFT JOIN "KATEGORI_JASA" AS KJ ON SJ."KategoriJasaId" = KJ."Id"
        WHERE
            (sub = '' OR SJ."NamaSubkategori" ILIKE '%' || sub || '%')
            AND (kat = '' OR KJ."NamaKategori" = kat)
        GROUP BY KJ."Id";
    END;
    $$
    LANGUAGE plpgsql;