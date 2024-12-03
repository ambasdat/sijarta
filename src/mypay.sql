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
