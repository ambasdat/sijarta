-- _____________________ MAJOR FUNCTION _____________________

-- get_pekerja_category
CREATE OR REPLACE FUNCTION get_pekerja_category(
    pekerjaId_param UUID
)
RETURNS TABLE (
    kId UUID,      -- Category ID
    kName VARCHAR,  -- Category Name
    sId UUID,      -- Subcategory ID
    sName VARCHAR   -- Subcategory Name
) AS $$
BEGIN
    RETURN QUERY
    SELECT  
        k."Id" AS "kId", 
        k."NamaKategori" AS "kName", 
        s."Id" AS "sId", 
        s."NamaSubkategori" AS "sName"
    FROM "KATEGORI_JASA" k
    LEFT JOIN "SUBKATEGORI_JASA" s 
        ON k."Id" = s."KategoriJasaId"
    WHERE k."Id" IN (
        SELECT "KategoriJasaId" 
        FROM "PEKERJA_KATEGORI_JASA" 
        WHERE "PekerjaId" = pekerjaId_param
    );
END;
$$ LANGUAGE plpgsql;




-- filter_pemesanan
CREATE OR REPLACE FUNCTION filter_pemesanan(
    pekerjaId_param UUID, 
    kid_param UUID DEFAULT NULL, 
    sid_param UUID DEFAULT NULL
)
RETURNS TABLE (
    IdTrPemesanan UUID,
    TglPemesanan DATE,
    TglPekerjaan DATE,
    TotalBiaya DECIMAL,
    NamaPelanggan VARCHAR,
    NamaSubkategoriJasa VARCHAR
) AS $$
BEGIN
    IF sid_param IS NOT NULL THEN
        -- Case 1: Filter directly by sid
        RETURN QUERY
        SELECT
            tj."Id",
            tj."TglPemesanan",
            tj."TglPekerjaan",
            tj."TotalBiaya",
            u."Nama",
            sub."NamaSubkategori"
        FROM "TR_PEMESANAN_JASA" tj
        LEFT JOIN "TR_PEMESANAN_STATUS" ts ON tj."Id" = ts."IdTrPemesanan"
        LEFT JOIN "USER" u ON tj."IdPelanggan" = u."Id"
        LEFT JOIN "SUBKATEGORI_JASA" sub ON tj."IdKategoriJasa" = sub."Id"
        LEFT JOIN "STATUS_PESANAN" sp ON ts."IdStatus" = sp."Id"
        WHERE tj."IdKategoriJasa" = sid_param
        AND sp."Status" = 'Mencari Pekerja Terdekat'
        AND NOT EXISTS (
            SELECT 1
            FROM "TR_PEMESANAN_STATUS" ts2
            WHERE ts2."IdTrPemesanan" = tj."Id"
            AND ts2."IdStatus" IN (
                '57fc8243-eb71-47a5-b74d-81fba6a94f82',  -- Menunggu Pekerja Berangkat
                '996980f3-cc47-4edb-a8cc-10ec02939479',  -- Pekerja tiba di lokasi
                '1fe77476-1194-4de7-b7f9-72c8cdd3ef68',  -- Pelayanan jasa sedang dilakukan
                '3d436422-152e-4b22-b978-49012b58e1f8',  -- Pesanan selesai
                'd9521320-0b6e-4bf7-971f-b3cb7edec92f'   -- Pesanan dibatalkan
            )
        )
        ORDER BY tj."TglPemesanan" ASC;
    ELSIF kid_param IS NOT NULL THEN
        -- Case 2: Filter by `kid` from get_category(pekerjaId)
        RETURN QUERY
        SELECT
            tj."Id",
            tj."TglPemesanan",
            tj."TglPekerjaan",
            tj."TotalBiaya",
            u."Nama",
            sub."NamaSubkategori"
        FROM "TR_PEMESANAN_JASA" tj
        LEFT JOIN "TR_PEMESANAN_STATUS" ts ON tj."Id" = ts."IdTrPemesanan"
        LEFT JOIN "USER" u ON tj."IdPelanggan" = u."Id"
        LEFT JOIN "SUBKATEGORI_JASA" sub ON tj."IdKategoriJasa" = sub."Id"
        LEFT JOIN "STATUS_PESANAN" sp ON ts."IdStatus" = sp."Id"
        WHERE tj."IdKategoriJasa" IN (
            SELECT pk.sid
            FROM get_pekerja_category(pekerjaId_param) pk
            WHERE pk.kid = kid_param
        )
        AND sp."Status" = 'Mencari Pekerja Terdekat'
        AND NOT EXISTS (
            SELECT 1
            FROM "TR_PEMESANAN_STATUS" ts2
            WHERE ts2."IdTrPemesanan" = tj."Id"
            AND ts2."IdStatus" IN (
                '57fc8243-eb71-47a5-b74d-81fba6a94f82',  -- Menunggu Pekerja Berangkat
                '996980f3-cc47-4edb-a8cc-10ec02939479',  -- Pekerja tiba di lokasi
                '1fe77476-1194-4de7-b7f9-72c8cdd3ef68',  -- Pelayanan jasa sedang dilakukan
                '3d436422-152e-4b22-b978-49012b58e1f8',  -- Pesanan selesai
                'd9521320-0b6e-4bf7-971f-b3cb7edec92f'   -- Pesanan dibatalkan
            )
        )
        ORDER BY tj."TglPemesanan" ASC;
    ELSE
        -- Case 1: Filter using get_category(pekerjaId) without additional conditions
        RETURN QUERY
        SELECT
            tj."Id",
            tj."TglPemesanan",
            tj."TglPekerjaan",
            tj."TotalBiaya",
            u."Nama",
            sub."NamaSubkategori"
        FROM "TR_PEMESANAN_JASA" tj
        LEFT JOIN "TR_PEMESANAN_STATUS" ts ON tj."Id" = ts."IdTrPemesanan"
        LEFT JOIN "USER" u ON tj."IdPelanggan" = u."Id"
        LEFT JOIN "SUBKATEGORI_JASA" sub ON tj."IdKategoriJasa" = sub."Id"
        LEFT JOIN "STATUS_PESANAN" sp ON ts."IdStatus" = sp."Id"
        WHERE tj."IdKategoriJasa" IN (
            SELECT pk.sid
            FROM get_pekerja_category(pekerjaId_param) pk
        )
        AND sp."Status" = 'Mencari Pekerja Terdekat'
        AND NOT EXISTS (
            SELECT 1
            FROM "TR_PEMESANAN_STATUS" ts2
            WHERE ts2."IdTrPemesanan" = tj."Id"
            AND ts2."IdStatus" IN (
                '57fc8243-eb71-47a5-b74d-81fba6a94f82',  -- Menunggu Pekerja Berangkat
                '996980f3-cc47-4edb-a8cc-10ec02939479',  -- Pekerja tiba di lokasi
                '1fe77476-1194-4de7-b7f9-72c8cdd3ef68',  -- Pelayanan jasa sedang dilakukan
                '3d436422-152e-4b22-b978-49012b58e1f8',  -- Pesanan selesai
                'd9521320-0b6e-4bf7-971f-b3cb7edec92f'   -- Pesanan dibatalkan
            )
        )
        ORDER BY tj."TglPemesanan" ASC;
    END IF;
END;
$$ LANGUAGE plpgsql;




-- handle_kerjakan_pesanan
CREATE OR REPLACE FUNCTION handle_kerjakan_pesanan(
    idTrPemesanan_param UUID,
    pekerjaId_param UUID
)
RETURNS VOID AS $$
BEGIN
    -- Update the TR_PEMESANAN_STATUS table
    UPDATE "TR_PEMESANAN_JASA"
    SET 
        "IdPekerja" = pekerjaId_param,
        "TglPekerjaan" = CURRENT_DATE,
        "WaktuPekerjaan" = NOW() + INTERVAL '1 day' * "Sesi"
    WHERE "Id" = idTrPemesanan_param;

    -- Insert a new record into the TR_PEMESANAN_STATUS table
    INSERT INTO "TR_PEMESANAN_STATUS" (
        "IdTrPemesanan", 
        "IdStatus", 
        "TglWaktu"
    )
    VALUES (
        idTrPemesanan_param, 
        '57fc8243-eb71-47a5-b74d-81fba6a94f82',
        NOW()
    );
END;
$$ LANGUAGE plpgsql;




-- filter_status
CREATE OR REPLACE FUNCTION filter_status(
    pekerjaId_param UUID,
    searchQuery VARCHAR(255) DEFAULT NULL,
    statusId_param UUID DEFAULT NULL
)
RETURNS TABLE (
    IdTrPemesanan UUID,
    TglPekerjaan DATE,
    TglPemesanan DATE,
    TotalBiaya DECIMAL,
    NamaPelanggan VARCHAR,
    NamaSubkategoriJasa VARCHAR,
    IdStatus UUID,
    Status VARCHAR
) AS $$
BEGIN
    IF statusId_param IS NULL THEN
        RETURN QUERY
        SELECT
            tj."Id" AS IdTrPemesanan,
            tj."TglPekerjaan",
            tj."TglPemesanan",
            tj."TotalBiaya",
            u."Nama" AS NamaPelanggan,
            sub."NamaSubkategori" AS NamaSubkategoriJasa,
            sp."Id",
            sp."Status"
        FROM "TR_PEMESANAN_JASA" tj
        LEFT JOIN LATERAL (
            SELECT ts."IdStatus"
            FROM "TR_PEMESANAN_STATUS" ts
            WHERE ts."IdTrPemesanan" = tj."Id"
            ORDER BY ts."TglWaktu" DESC
            LIMIT 1
        ) latest ON TRUE
        LEFT JOIN "STATUS_PESANAN" sp ON sp."Id" = latest."IdStatus"
        LEFT JOIN "USER" u ON tj."IdPelanggan" = u."Id"
        LEFT JOIN "SUBKATEGORI_JASA" sub ON tj."IdKategoriJasa" = sub."Id"
        WHERE tj."IdPekerja" = pekerjaId_param
          AND (
              searchQuery = '' OR
              ( (u."Nama" || ' ' || sub."NamaSubkategori" || ' ' || sp."Status") ILIKE '%' || searchQuery || '%')
          )
        ORDER BY tj."TglPekerjaan" DESC;
    ELSE
        RETURN QUERY
        SELECT
            tj."Id" AS IdTrPemesanan,
            tj."TglPekerjaan",
            tj."TglPemesanan",
            tj."TotalBiaya",
            u."Nama" AS NamaPelanggan,
            sub."NamaSubkategori" AS NamaSubkategoriJasa,
            sp."Id",
            sp."Status"
        FROM "TR_PEMESANAN_JASA" tj
        LEFT JOIN LATERAL (
            SELECT ts."IdStatus"
            FROM "TR_PEMESANAN_STATUS" ts
            WHERE ts."IdTrPemesanan" = tj."Id"
            ORDER BY ts."TglWaktu" DESC
            LIMIT 1
        ) latest ON TRUE
        LEFT JOIN "STATUS_PESANAN" sp ON sp."Id" = latest."IdStatus"
        LEFT JOIN "USER" u ON tj."IdPelanggan" = u."Id"
        LEFT JOIN "SUBKATEGORI_JASA" sub ON tj."IdKategoriJasa" = sub."Id"
        WHERE tj."IdPekerja" = pekerjaId_param
          AND sp."Id" = statusId_param
          AND (
              searchQuery = '' OR
              ( (u."Nama" || ' ' || sub."NamaSubkategori" || ' ' || sp."Status") ILIKE '%' || searchQuery || '%')
          )
        ORDER BY tj."TglPekerjaan" DESC;
    END IF;
END;
$$ LANGUAGE plpgsql;




-- handle_update_status
CREATE OR REPLACE FUNCTION handle_update_status(
    idTrPemesanan_param UUID,
    idStatus_param UUID
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO "TR_PEMESANAN_STATUS" ("IdTrPemesanan", "IdStatus", "TglWaktu")
    VALUES (idTrPemesanan_param, idStatus_param, NOW());
END;
$$ LANGUAGE plpgsql;




-- CREATE OR REPLACE FUNCTION increment_jml_pesanan_selesai(
--     pekerjaId_param UUID
-- )
-- RETURNS VOID AS $$
-- BEGIN
--     UPDATE "PekerjaTable" -- Replace "PekerjaTable" with your actual table name
--     SET "JmlPesananSelesai" = "JmlPesananSelesai" + 1
--     WHERE "Id" = pekerjaId_param;
-- END;
-- $$ LANGUAGE plpgsql;


-- _____________________ MISC _____________________

-- -- filter_pemesanan
-- CREATE OR REPLACE FUNCTION filter_pemesanan(
--     pekerjaId_param UUID, 
--     kid_param UUID DEFAULT NULL, 
--     sid_param UUID DEFAULT NULL
-- )
-- RETURNS TABLE (
--     IdTrPemesanan UUID,
--     TglPemesanan DATE,
--     TglPekerjaan DATE,
--     WaktuPekerjaan TIMESTAMP,
--     TotalBiaya DECIMAL,
--     IdPelanggan UUID,
--     NamaPelanggan VARCHAR,
--     IdPekerja UUID,
--     IdKategoriJasa UUID,
--     NamaSubkategoriJasa VARCHAR,
--     Sesi INT,
--     IdDiskon VARCHAR,
--     IdMetodeBayar UUID,
--     TglWaktu TIMESTAMP,
--     Status VARCHAR
-- ) AS $$
-- BEGIN
--     IF sid_param IS NOT NULL THEN
--         -- Case 1: Filter directly by sid
--         RETURN QUERY
--         SELECT
--             tj."Id",
--             tj."TglPemesanan",
--             tj."TglPekerjaan",
--             tj."WaktuPekerjaan",
--             tj."TotalBiaya",
--             tj."IdPelanggan",
--             u."Nama",
--             tj."IdPekerja",
--             tj."IdKategoriJasa",
--             sub."NamaSubkategori",
--             tj."Sesi",
--             tj."IdDiskon",
--             tj."IdMetodeBayar",
--             ts."TglWaktu",
--             sp."Status"
--         FROM "TR_PEMESANAN_JASA" tj
--         LEFT JOIN "TR_PEMESANAN_STATUS" ts ON tj."Id" = ts."IdTrPemesanan"
--         LEFT JOIN "USER" u ON tj."IdPelanggan" = u."Id"
--         LEFT JOIN "SUBKATEGORI_JASA" sub ON tj."IdKategoriJasa" = sub."Id"
--         LEFT JOIN "STATUS_PESANAN" sp ON ts."IdStatus" = sp."Id"
--         WHERE tj."IdKategoriJasa" = sid_param
--         AND sp."Status" = 'Mencari Pekerja Terdekat'
--         AND NOT EXISTS (
--             SELECT 1
--             FROM "TR_PEMESANAN_STATUS" ts2
--             WHERE ts2."IdTrPemesanan" = tj."Id"
--             AND ts2."IdStatus" IN (
--                 '57fc8243-eb71-47a5-b74d-81fba6a94f82',  -- Menunggu Pekerja Berangkat
--                 '996980f3-cc47-4edb-a8cc-10ec02939479',  -- Pekerja tiba di lokasi
--                 '1fe77476-1194-4de7-b7f9-72c8cdd3ef68',  -- Pelayanan jasa sedang dilakukan
--                 '3d436422-152e-4b22-b978-49012b58e1f8',  -- Pesanan selesai
--                 'd9521320-0b6e-4bf7-971f-b3cb7edec92f'   -- Pesanan dibatalkan
--             )
--         );
--     ELSIF kid_param IS NOT NULL THEN
--         -- Case 2: Filter by `kid` from get_category(pekerjaId)
--         RETURN QUERY
--         SELECT
--             tj."Id",
--             tj."TglPemesanan",
--             tj."TglPekerjaan",
--             tj."WaktuPekerjaan",
--             tj."TotalBiaya",
--             tj."IdPelanggan",
--             u."Nama",
--             tj."IdPekerja",
--             tj."IdKategoriJasa",
--             sub."NamaSubkategori",
--             tj."Sesi",
--             tj."IdDiskon",
--             tj."IdMetodeBayar",
--             ts."TglWaktu",
--             sp."Status"
--         FROM "TR_PEMESANAN_JASA" tj
--         LEFT JOIN "TR_PEMESANAN_STATUS" ts ON tj."Id" = ts."IdTrPemesanan"
--         LEFT JOIN "USER" u ON tj."IdPelanggan" = u."Id"
--         LEFT JOIN "SUBKATEGORI_JASA" sub ON tj."IdKategoriJasa" = sub."Id"
--         LEFT JOIN "STATUS_PESANAN" sp ON ts."IdStatus" = sp."Id"
--         WHERE tj."IdKategoriJasa" IN (
--             SELECT pk.sid
--             FROM get_pekerja_category(pekerjaId_param) pk
--             WHERE pk.kid = kid_param
--         )
--         AND sp."Status" = 'Mencari Pekerja Terdekat'
--         AND NOT EXISTS (
--             SELECT 1
--             FROM "TR_PEMESANAN_STATUS" ts2
--             WHERE ts2."IdTrPemesanan" = tj."Id"
--             AND ts2."IdStatus" IN (
--                 '57fc8243-eb71-47a5-b74d-81fba6a94f82',  -- Menunggu Pekerja Berangkat
--                 '996980f3-cc47-4edb-a8cc-10ec02939479',  -- Pekerja tiba di lokasi
--                 '1fe77476-1194-4de7-b7f9-72c8cdd3ef68',  -- Pelayanan jasa sedang dilakukan
--                 '3d436422-152e-4b22-b978-49012b58e1f8',  -- Pesanan selesai
--                 'd9521320-0b6e-4bf7-971f-b3cb7edec92f'   -- Pesanan dibatalkan
--             )
--         );
--     ELSE
--         -- Case 1: Filter using get_category(pekerjaId) without additional conditions
--         RETURN QUERY
--         SELECT
--             tj."Id",
--             tj."TglPemesanan",
--             tj."TglPekerjaan",
--             tj."WaktuPekerjaan",
--             tj."TotalBiaya",
--             tj."IdPelanggan",
--             u."Nama",
--             tj."IdPekerja",
--             tj."IdKategoriJasa",
--             sub."NamaSubkategori",
--             tj."Sesi",
--             tj."IdDiskon",
--             tj."IdMetodeBayar",
--             ts."TglWaktu",
--             sp."Status"
--         FROM "TR_PEMESANAN_JASA" tj
--         LEFT JOIN "TR_PEMESANAN_STATUS" ts ON tj."Id" = ts."IdTrPemesanan"
--         LEFT JOIN "USER" u ON tj."IdPelanggan" = u."Id"
--         LEFT JOIN "SUBKATEGORI_JASA" sub ON tj."IdKategoriJasa" = sub."Id"
--         LEFT JOIN "STATUS_PESANAN" sp ON ts."IdStatus" = sp."Id"
--         WHERE tj."IdKategoriJasa" IN (
--             SELECT pk.sid
--             FROM get_pekerja_category(pekerjaId_param) pk
--         )
--         AND sp."Status" = 'Mencari Pekerja Terdekat'
--         AND NOT EXISTS (
--             SELECT 1
--             FROM "TR_PEMESANAN_STATUS" ts2
--             WHERE ts2."IdTrPemesanan" = tj."Id"
--             AND ts2."IdStatus" IN (
--                 '57fc8243-eb71-47a5-b74d-81fba6a94f82',  -- Menunggu Pekerja Berangkat
--                 '996980f3-cc47-4edb-a8cc-10ec02939479',  -- Pekerja tiba di lokasi
--                 '1fe77476-1194-4de7-b7f9-72c8cdd3ef68',  -- Pelayanan jasa sedang dilakukan
--                 '3d436422-152e-4b22-b978-49012b58e1f8',  -- Pesanan selesai
--                 'd9521320-0b6e-4bf7-971f-b3cb7edec92f'   -- Pesanan dibatalkan
--             )
--         );
--     END IF;
-- END;
-- $$ LANGUAGE plpgsql;




-- SELECT * FROM filter_status(
--     'f864622f-e148-4d45-8253-e31fe71754bd',
--     'Cleaning',
--     NULL
-- );




-- SELECT *
-- FROM "TR_PEMESANAN_JASA" tj 
-- LEFT JOIN "TR_PEMESANAN_STATUS" ts ON tj."Id" = ts."IdTrPemesanan"
-- LEFT JOIN "STATUS_PESANAN" sp ON ts."IdStatus" = sp."Id"
-- WHERE tj."IdPekerja" = '196b292e-d564-4508-94ce-f049e07e8688';

-- INSERT INTO "TR_PEMESANAN_STATUS" (
--     "IdTrPemesanan",
--     "IdStatus",
--     "TglWaktu"
-- ) 
-- VALUES 
--     ('88cb54f1-dbc2-48a6-adae-30fdc8bb1b84', 'a7634d70-d6d8-42cf-90e3-dd069bf54e33', NOW()),
--     ('88cb54f1-dbc2-48a6-adae-30fdc8bb1b84', 'e179caba-38d9-4636-ab2e-2032f5284714', NOW());
