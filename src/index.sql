CREATE OR REPLACE FUNCTION get_user_type(user_id UUID)
RETURNS TEXT AS $$
DECLARE
  is_user BOOLEAN;
  is_pelanggan BOOLEAN;
  is_pekerja BOOLEAN;
BEGIN
  SELECT COUNT(1) = 1 INTO is_user
  FROM "USER"
  WHERE "Id" = user_id;

  IF NOT is_user THEN
    RETURN 'guest';
  END IF;

  SELECT COUNT(1) = 1 INTO is_pelanggan
  FROM "PELANGGAN"
  WHERE "Id" = user_id;

  SELECT COUNT(1) = 1 INTO is_pekerja
  FROM "PEKERJA"
  WHERE "Id" = user_id;

  RETURN CASE
    WHEN is_pelanggan THEN 'pengguna'
    WHEN is_pekerja THEN 'pekerja'
    ELSE 'guest'
  END;
END;
$$ LANGUAGE plpgsql;
