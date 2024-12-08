-- _____________________ UTILITY FUNCTIONS _____________________

-- insert_new_tr_mypay
CREATE OR REPLACE FUNCTION insert_new_tr_mypay(userId_param UUID, nominal_param DECIMAL, kategoriId_param UUID)
RETURNS VOID AS $$
BEGIN
    -- Insert a new row into the transactions table
    INSERT INTO "TR_MYPAY" ("UserId", "Tgl", "Nominal", "KategoriId")
    VALUES (userId_param, CURRENT_DATE, nominal_param, kategoriId_param);
END;
$$ LANGUAGE plpgsql;

-- check_noHp_exists
CREATE OR REPLACE FUNCTION check_noHp_exists(noHp_param VARCHAR)
RETURNS UUID AS $$
DECLARE
    user_id UUID;
BEGIN
    SELECT "Id" 
    INTO user_id
    FROM "USER"
    WHERE "NoHP" = noHp_param;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'NoHP not found';
    END IF;

    RETURN user_id;
END;
$$ LANGUAGE plpgsql;




-- _____________________ MAJOR FUNCTIONS _____________________

-- get_user_details
CREATE OR REPLACE FUNCTION get_user_details(userId UUID)
RETURNS TABLE(
    "Nama" VARCHAR,
    "SaldoMyPay" VARCHAR,
    "NoHP" VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        u."Nama", 
        REPLACE(TO_CHAR(u."SaldoMyPay", 'FM9,999,999,999'), ',', '.')::VARCHAR AS "SaldoMyPay", 
        u."NoHP"
    FROM "USER" u
    WHERE u."Id" = userId;
END;
$$ LANGUAGE plpgsql;




-- get_user_transactions
CREATE OR REPLACE FUNCTION get_user_transactions(userId UUID)
RETURNS TABLE (
    "Nominal" VARCHAR,
    "Tgl" DATE,
    "Nama" VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        REPLACE(TO_CHAR(t."Nominal", 'FM9,999,999,999'), ',', '.')::VARCHAR AS "Nominal", 
        t."Tgl", 
        k."Nama"
    FROM "TR_MYPAY" t
    LEFT JOIN "KATEGORI_TR_MYPAY" k 
        ON k."Id" = t."KategoriId"
    WHERE t."UserId" = userId;
END;
$$ LANGUAGE plpgsql;




-- get_user_order
CREATE OR REPLACE FUNCTION get_user_order(
    pelangganId_param UUID
)
RETURNS TABLE (
    IdTrPemesanan UUID,
    TglPemesanan DATE,
    TglPekerjaan DATE,
    TotalBiaya DECIMAL,
    NamaSubkategoriJasa VARCHAR,
    Sesi INT,
    Status VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        tj."Id",
        tj."TglPemesanan",
        tj."TglPekerjaan",
        tj."TotalBiaya",
        sub."NamaSubkategori",
        tj."Sesi",
        sp."Status"
    FROM "TR_PEMESANAN_JASA" tj
    LEFT JOIN "TR_PEMESANAN_STATUS" ts ON tj."Id" = ts."IdTrPemesanan"
    LEFT JOIN "SUBKATEGORI_JASA" sub ON tj."IdKategoriJasa" = sub."Id"
    LEFT JOIN "STATUS_PESANAN" sp ON ts."IdStatus" = sp."Id"
    WHERE tj."IdPelanggan" = '64302ea1-212d-414c-a2db-1fad0b3c3b6e'
    AND sp."Id" = 'a7634d70-d6d8-42cf-90e3-dd069bf54e33'
    AND NOT EXISTS (
        SELECT 1
        FROM "TR_PEMESANAN_STATUS" ts2
        WHERE ts2."IdTrPemesanan" = tj."Id"
        AND ts2."IdStatus" IN (
            'e179caba-38d9-4636-ab2e-2032f5284714', -- Mencari Pekerja Terdekat
            '57fc8243-eb71-47a5-b74d-81fba6a94f82',  -- Menunggu Pekerja Berangkat
            '996980f3-cc47-4edb-a8cc-10ec02939479',  -- Pekerja tiba di lokasi
            '1fe77476-1194-4de7-b7f9-72c8cdd3ef68',  -- Pelayanan jasa sedang dilakukan
            '3d436422-152e-4b22-b978-49012b58e1f8',  -- Pesanan selesai
            'd9521320-0b6e-4bf7-971f-b3cb7edec92f'   -- Pesanan dibatalkan
        )
    )
    AND tj."IdMetodeBayar" = 'd36a743b-8015-4940-8ef4-0ec549d6b6ef';
END;
$$ LANGUAGE plpgsql;




-- handle_top_up
CREATE OR REPLACE FUNCTION handle_topup(userId_param UUID, topup_amount_param DECIMAL)
RETURNS VOID AS $$
BEGIN
    -- Validate that the top-up amount is greater than 0
    IF topup_amount_param <= 0 THEN
        RAISE EXCEPTION 'Top Up Amount Should be greater than 0';
    END IF;

    -- Update the user's SaldoMyPay
    UPDATE "USER"
    SET "SaldoMyPay" = "SaldoMyPay" + topup_amount_param
    WHERE "Id" = userId_param;

    -- Log the top-up transaction
    PERFORM insert_new_tr_mypay(
        userId_param,
        topup_amount_param,
        'ad98db8d-2f94-4176-9f47-7c5ed55cdeb4'
    );
END;
$$ LANGUAGE plpgsql;




-- handle_payment
CREATE OR REPLACE FUNCTION handle_payment(
    userId_param UUID, 
    idTrPemesanan_param UUID, 
    total_amount_param DECIMAL
)
RETURNS VOID AS $$
DECLARE
    user_balance DECIMAL;
BEGIN
    -- Validate that the totalAmount is greater than or equal to 0
    IF total_amount_param < 0 THEN
        RAISE EXCEPTION 'Amount should be greater than or equal to 0';
    END IF;

    -- Check the user's current balance
    SELECT "SaldoMyPay" 
    INTO user_balance
    FROM "USER"
    WHERE "Id" = userId_param;

    -- Ensure the user exists and has a balance
    IF user_balance IS NULL THEN
        RAISE EXCEPTION 'User not found';
    ELSIF user_balance < total_amount_param THEN
        RAISE EXCEPTION 'Insufficient balance';
    END IF;

    -- Update the order status to reflect payment (insert a new row in TR_PEMESANAN_JASA)
    INSERT INTO "TR_PEMESANAN_STATUS" ("IdTrPemesanan", "IdStatus", "TglWaktu")
    VALUES (idTrPemesanan_param, 'e179caba-38d9-4636-ab2e-2032f5284714', NOW());

    -- Reduce the user's balance by the totalAmount
    UPDATE "USER"
    SET "SaldoMyPay" = "SaldoMyPay" - total_amount_param
    WHERE "Id" = userId_param;

    -- Log the payment transaction
    PERFORM insert_new_tr_mypay(
        userId_param,
        total_amount_param,
        'bb453dbc-c5eb-4102-83e9-c13d1b14213a'
    );

END;
$$ LANGUAGE plpgsql;




-- handle_transfer
CREATE OR REPLACE FUNCTION handle_transfer(
    userId_param UUID,
    noHp_param VARCHAR, 
    tf_amount_param DECIMAL
)
RETURNS VOID AS $$
DECLARE
    recipient_id UUID;
    sender_balance DECIMAL;
BEGIN
    -- Validate that the transfer amount is greater than 0
    IF tf_amount_param <= 0 THEN
        RAISE EXCEPTION 'Transfer amount must be greater than 0';
    END IF;

    -- Check the sender's current balance
    SELECT "SaldoMyPay" 
    INTO sender_balance
    FROM "USER"
    WHERE "Id" = userId_param;

    -- Ensure the sender has enough balance
    IF sender_balance IS NULL THEN
        RAISE EXCEPTION 'Sender not found';
    ELSIF sender_balance < tf_amount_param THEN
        RAISE EXCEPTION 'Insufficient balance';
    END IF;

    -- Check if the recipient's NoHP exists
    recipient_id := check_noHp_exists(noHp_param);

    -- Deduct the transfer amount from the sender's SaldoMyPay
    UPDATE "USER"
    SET "SaldoMyPay" = "SaldoMyPay" - tf_amount_param
    WHERE "Id" = userId_param;

    -- Add the transfer amount to the recipient's SaldoMyPay
    UPDATE "USER"
    SET "SaldoMyPay" = "SaldoMyPay" + tf_amount_param
    WHERE "Id" = recipient_id;

    -- Log the transfer transaction for the sender
    PERFORM insert_new_tr_mypay(
        userId_param,
        tf_amount_param,
        '2bbabdf1-f34a-4ce5-8b56-3a0ce95947a1'
    );
END;
$$ LANGUAGE plpgsql;




-- handle_withdraw
CREATE OR REPLACE FUNCTION handle_withdraw(
    userId_param UUID, 
    wd_amount_param DECIMAL
)
RETURNS VOID AS $$
DECLARE
    user_balance DECIMAL;
BEGIN
    -- Validate that the totalAmount is greater than or equal to 0
    IF wd_amount_param <= 0 THEN
        RAISE EXCEPTION 'Amount should be greater than or equal to 0';
    END IF;

    -- Check the user's current balance
    SELECT "SaldoMyPay" 
    INTO user_balance
    FROM "USER"
    WHERE "Id" = userId_param;

    -- Ensure the user exists and has a balance
    IF user_balance IS NULL THEN
        RAISE EXCEPTION 'User not found';
    ELSIF user_balance < wd_amount_param THEN
        RAISE EXCEPTION 'Insufficient balance';
    END IF;

    -- Reduce the user's balance by the totalAmount
    UPDATE "USER"
    SET "SaldoMyPay" = "SaldoMyPay" - wd_amount_param
    WHERE "Id" = userId_param;

    -- Log the payment transaction
    PERFORM insert_new_tr_mypay(
        userId_param,
        wd_amount_param,
        'a5940249-15dd-47b0-bfe7-f042da5e8954'
    );
END;
$$ LANGUAGE plpgsql;




-- _____________________ MISC _____________________

-- select tj."Id", ts."IdStatus", sp."Status"
-- from "TR_PEMESANAN_JASA" tj
-- left join "TR_PEMESANAN_STATUS" ts
-- on tj."Id" = ts."IdTrPemesanan"
-- left join "STATUS_PESANAN" sp
-- on ts."IdStatus" = sp."Id"
-- where tj."IdPelanggan" = '64302ea1-212d-414c-a2db-1fad0b3c3b6e'

-- INSERT INTO "TR_PEMESANAN_STATUS" (
--   "IdTrPemesanan", "IdStatus", "TglWaktu"
-- )
-- VALUES 
--     ('24d73f22-301c-423b-b805-bbe78d584aa9', 'a7634d70-d6d8-42cf-90e3-dd069bf54e33', NOW()),
--     ('1a20d310-fe48-40da-80b2-3b8d841707ad', 'a7634d70-d6d8-42cf-90e3-dd069bf54e33', NOW()),
--     ('b2f8a34a-6eb2-4cf1-b2f8-340cb8355714', 'a7634d70-d6d8-42cf-90e3-dd069bf54e33', NOW());