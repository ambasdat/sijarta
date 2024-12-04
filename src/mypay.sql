-- get_user_details
CREATE OR REPLACE FUNCTION get_user_details(userId UUID)
RETURNS TABLE(
    "Nama" VARCHAR,
    "SaldoMyPay" VARCHAR,
    "NoHP" VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT u."Nama", TO_CHAR(u."SaldoMyPay", 'FM9,999,999,999')::VARCHAR AS "SaldoMyPay", u."NoHP"
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
    SELECT TO_CHAR(t."Nominal", 'FM9,999,999,999')::VARCHAR AS "Nominal", t."Tgl", k."Nama"
    FROM "TR_MYPAY" t
    LEFT JOIN "KATEGORI_TR_MYPAY" k 
    ON k."Id" = t."KategoriId"
    WHERE t."UserId" = userId;
END;
$$ LANGUAGE plpgsql;


-- insert_new_tr
CREATE OR REPLACE FUNCTION insert_new_tr(userId_param UUID, nominal_param DECIMAL, kategoriId_param UUID)
RETURNS VOID AS $$
BEGIN
    -- Insert a new row into the transactions table
    INSERT INTO "TR_MYPAY" ("UserId", "Tgl", "Nominal", "KategoriId")
    VALUES (userId_param, CURRENT_DATE, nominal_param, kategoriId_param);
END;
$$ LANGUAGE plpgsql;

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
    PERFORM insert_new_tr(
        userId_param,
        topup_amount_param,
        'ad98db8d-2f94-4176-9f47-7c5ed55cdeb4'
    );
END;
$$ LANGUAGE plpgsql;

-- handle_pay


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

-- handle_tf
CREATE OR REPLACE FUNCTION handle_tf(userId_param UUID, noHp_param VARCHAR, tf_amount_param DECIMAL)
RETURNS VOID AS $$
DECLARE
    recipient_id UUID;
    sender_balance DECIMAL;
BEGIN
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
    PERFORM insert_new_tr(
        userId_param,
        tf_amount_param,
        '2bbabdf1-f34a-4ce5-8b56-3a0ce95947a1'
    );
END;
$$ LANGUAGE plpgsql;


-- handle_wd
