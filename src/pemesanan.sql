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
        JOIN "USER" AS U ON TPJ."IdPekerja" = U."Id"
        JOIN "TR_PEMESANAN_STATUS" AS TPS ON TPJ."Id" = TPS."IdTrPemesanan"
        JOIN "STATUS_PESANAN" AS SP ON TPS."IdStatus" = SP."Id"
    WHERE
        TPJ."IdPelanggan" = '7641cc47-df84-414a-9847-ddcdc2ff5e89'
)
SELECT
    "Id",
    "NamaSubkategori",
    "Sesi",
    "TotalBiaya",
    "Nama",
    "Status"
FROM
    ranked_rows
WHERE
    row_num = 1
ORDER BY
    "TglWaktu" DESC;