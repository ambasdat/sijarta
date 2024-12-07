DROP FUNCTION IF EXISTS getPemesanan(p_uid UUID, p_sub VARCHAR, p_status VARCHAR);
DROP FUNCTION IF EXISTS existTestimoni(p_id UUID);

CREATE OR REPLACE FUNCTION getPemesanan(p_uid UUID, p_sub VARCHAR, p_status VARCHAR)
    RETURNS TABLE(
        "Id" UUID,
        "NamaSubkategori" VARCHAR,
        "Sesi" INT,
        "TotalBiaya" DECIMAL,
        "Nama" VARCHAR,
        "Status" VARCHAR
    ) AS
    $$
        BEGIN
            RETURN QUERY
            WITH ranked_rows AS (
                SELECT
                    TPJ."Id",
                    SJ."NamaSubkategori",
                    TPJ."Sesi",
                    TPJ."TotalBiaya",
                    U."Nama",
                    SP."Status",
                    TPS."TglWaktu",
                    ROW_NUMBER() OVER (PARTITION BY TPJ."Id" ORDER BY TPS."TglWaktu" DESC) AS row_num
                FROM
                    "TR_PEMESANAN_JASA" AS TPJ
                    JOIN "SUBKATEGORI_JASA" AS SJ ON TPJ."IdKategoriJasa" = SJ."Id"
                    LEFT JOIN "USER" AS U ON TPJ."IdPekerja" = U."Id"
                    JOIN "TR_PEMESANAN_STATUS" AS TPS ON TPJ."Id" = TPS."IdTrPemesanan"
                    JOIN "STATUS_PESANAN" AS SP ON TPS."IdStatus" = SP."Id"
                WHERE
                    TPJ."IdPelanggan" = p_uid
                    AND (p_sub = '' OR SJ."NamaSubkategori" = p_sub)
                    AND (p_status = '' OR SP."Status" = p_status)
            )
            SELECT
                r."Id",
                r."NamaSubkategori",
                r."Sesi",
                r."TotalBiaya",
                r."Nama",
                r."Status"
            FROM
                ranked_rows as r
            WHERE
                r.row_num = 1
            ORDER BY
                r."TglWaktu" DESC;
        END;
    $$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION existTestimoni(p_id UUID)
    RETURNS BOOLEAN AS
    $$
        BEGIN
            RETURN EXISTS (
                SELECT
                    1
                FROM
                    "TESTIMONI" AS T
                WHERE
                    T."IdTrPemesanan" = p_id
            );
        END;
    $$
    LANGUAGE plpgsql;