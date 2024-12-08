DROP FUNCTION IF EXISTS getDesc(p_id UUID);
DROP FUNCTION IF EXISTS getSession(p_id UUID);
DROP FUNCTION IF EXISTS getPekerja(p_id UUID);
DROP FUNCTION IF EXISTS getTestimoni(p_id UUID);
DROP FUNCTION IF EXISTS getHargaSesi(p_id UUID, p_sesi INT);
DROP FUNCTION IF EXISTS getDiskon(p_uid UUID ,p_kode VARCHAR, p_harga DECIMAL);
DROP FUNCTION IF EXISTS insertTransaksi(p_tgl DATE, p_harga DECIMAL, p_uid UUID, p_sid UUID, p_sesi INT, p_diskon VARCHAR, p_metodebayar UUID);
DROP FUNCTION IF EXISTS updateVoucher(p_uid UUID, p_kode VARCHAR);

CREATE OR REPLACE FUNCTION getDesc(p_id UUID)
    RETURNS TABLE(
        "SubId" UUID,
        "Sub" VARCHAR,
        "Desc" TEXT,
        "Kat" VARCHAR,
        "KatID" UUID
    ) AS
    $$
        BEGIN
            RETURN QUERY
            SELECT
                SJ."Id",
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
                SL."SubkategoriId" = p_id
            ORDER BY
                SL."Sesi";
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

CREATE OR REPLACE FUNCTION getHargaSesi(p_id UUID, p_sesi INT)
    RETURNS INTEGER AS
    $$
        DECLARE
            harga DECIMAL;
        BEGIN
            SELECT
                SL."Harga" INTO harga
            FROM
                "SESI_LAYANAN" AS SL
            WHERE
                SL."SubkategoriId" = p_id
                AND SL."Sesi" = p_sesi;

            RETURN harga;
        END;
    $$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION getDiskon(p_uid UUID ,p_kode VARCHAR, p_harga DECIMAL)
    RETURNS DECIMAL AS
    $$
        DECLARE
            RESULT DECIMAL;
            id UUID;
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM "DISKON" WHERE "Kode" = p_kode)
                THEN RETURN 0;
            END IF;

            IF EXISTS (SELECT 1 FROM "DISKON" WHERE "Kode" = p_kode AND p_harga < "MinTrPemesanan")
                THEN RETURN 0;
            END IF;

            IF EXISTS (SELECT 1 FROM "PROMO" WHERE "Kode" = p_kode)
                THEN 
                IF EXISTS (SELECT 1 FROM "PROMO" WHERE "Kode" = p_kode AND CURRENT_DATE > "TglAkhirBerlaku")
                    THEN RETURN 0;
                ELSE
                    SELECT "Potongan" INTO RESULT FROM "DISKON" WHERE "Kode" = p_kode;
                    RETURN RESULT;
                END IF;
            END IF;

            IF NOT EXISTS (SELECT 1 FROM "TR_PEMBELIAN_VOUCHER" WHERE "IdPelanggan" = p_uid AND "IdVoucher" = p_kode)
                THEN RETURN 0;
            END IF;

            IF EXISTS (
                SELECT 1 
                FROM "TR_PEMBELIAN_VOUCHER" AS TPV JOIN "VOUCHER" AS V ON TPV."IdVoucher" = V."Kode"
                WHERE TPV."IdPelanggan" = p_uid AND TPV."IdVoucher" = p_kode AND (CURRENT_DATE > "TglAkhir" OR TPV."TelahDigunakan" >= V."KuotaPenggunaan")
            )
                THEN RETURN 0;
            END IF;

            SELECT "Id" INTO id FROM "TR_PEMBELIAN_VOUCHER" WHERE "IdPelanggan" = p_uid AND "IdVoucher" = p_kode;

            SELECT "Potongan" INTO RESULT FROM "DISKON" WHERE "Kode" = p_kode;
            RETURN RESULT;
        END;
    $$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION insertTransaksi(
        p_tgl DATE,
        p_harga DECIMAL,
        p_uid UUID,
        p_sid UUID,
        p_sesi INT,
        p_diskon VARCHAR,
        p_metodebayar UUID
    )
        RETURNS VOID AS
        $$
            DECLARE
                id UUID;
                id_status UUID;
            BEGIN
                SELECT GEN_RANDOM_UUID() INTO id;
                IF p_diskon = '' THEN p_diskon := NULL; END IF;
                INSERT INTO "TR_PEMESANAN_JASA" ("Id", "TglPemesanan", "TotalBiaya", "IdPelanggan", "IdKategoriJasa", "Sesi", "IdDiskon", "IdMetodeBayar")
                VALUES (id, p_tgl, p_harga, p_uid, p_sid, p_sesi, p_diskon, p_metodebayar);

                SELECT "Id" INTO id_status FROM "STATUS_PESANAN" WHERE "Status" = 'Menunggu Pembayaran';
                INSERT INTO "TR_PEMESANAN_STATUS" ("IdTrPemesanan", "IdStatus", "TglWaktu")
                VALUES (id, id_status, NOW());
            END;
        $$
        LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION updateVoucher(p_uid UUID, p_kode VARCHAR)
    RETURNS VOID AS
    $$
        BEGIN
            UPDATE "TR_PEMBELIAN_VOUCHER" SET "TelahDigunakan" = "TelahDigunakan" + 1 WHERE "IdPelanggan" = p_uid AND "IdVoucher" = p_kode;
        END;
    $$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION insertPekerjaKategori(p_id UUID, p_pekerja UUID)
    RETURNS VOID AS
    $$
        BEGIN
            INSERT INTO "PEKERJA_KATEGORI_JASA" ("PekerjaId", "KategoriJasaId")
            VALUES (p_pekerja, p_id);
        END;
    $$
    LANGUAGE plpgsql;