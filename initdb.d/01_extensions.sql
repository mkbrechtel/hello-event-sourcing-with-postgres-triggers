CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Custom function to generate UUIDv7
CREATE OR REPLACE FUNCTION uuid_generate_v7() 
RETURNS uuid
AS $$
DECLARE
    v_timestamp bigint;
    v_timestamp_hex varchar;
    v_rand bytea;
    v_rand_hex varchar;
BEGIN
    -- Get current timestamp in milliseconds
    v_timestamp := (extract(epoch from clock_timestamp()) * 1000)::bigint;
    v_timestamp_hex := lpad(to_hex(v_timestamp), 12, '0');
    v_rand := gen_random_bytes(10);
    v_rand_hex := encode(v_rand, 'hex');
    
    RETURN (
        -- First 8 chars of timestamp
        substring(v_timestamp_hex, 1, 8) || '-' ||
        -- Next 4 chars of timestamp
        substring(v_timestamp_hex, 9, 4) || '-' ||
        -- Version 7 and 3 chars of random
        '7' || substring(v_rand_hex, 1, 3) || '-' ||
        -- Variant (binary 10) and 3 chars of random
        '8' || substring(v_rand_hex, 4, 3) || '-' ||
        -- 12 chars of random
        substring(v_rand_hex, 7, 12)
    )::uuid;
END;
$$ LANGUAGE plpgsql;
