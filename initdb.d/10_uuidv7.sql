CREATE EXTENSION IF NOT EXISTS "uuid-ossp" SCHEMA public;
CREATE EXTENSION IF NOT EXISTS "pgcrypto" SCHEMA public;

CREATE SEQUENCE IF NOT EXISTS uuid_v7_seq MAXVALUE 16383;

CREATE OR REPLACE FUNCTION uuid_generate_v7() 
RETURNS uuid
AS $$
DECLARE
    v_timestamp bigint;
    v_timestamp_hex varchar;
    v_seq int;
    v_seq_hex varchar;
    v_rand bytea;
    v_rand_hex varchar;
BEGIN
    -- Get current timestamp in milliseconds
    v_timestamp := (extract(epoch from clock_timestamp()) * 1000)::bigint;
    
    -- Get sequence and convert to hex (max 16383 to fit in 14 bits)
    v_seq := nextval('uuid_v7_seq');
    v_seq_hex := lpad(to_hex(v_seq), 4, '0');
    
    v_timestamp_hex := lpad(to_hex(v_timestamp), 12, '0');
    v_rand := public.gen_random_bytes(8);
    v_rand_hex := encode(v_rand, 'hex');
    
    RETURN (
        -- First 8 chars of timestamp
        substring(v_timestamp_hex, 1, 8) || '-' ||
        -- Next 4 chars of timestamp
        substring(v_timestamp_hex, 9, 4) || '-' ||
        -- Version 7 and first 3 chars of sequence
        '7' || substring(v_seq_hex, 1, 3) || '-' ||
        -- Variant (binary 10) and last char of sequence plus 2 random chars
        '8' || substring(v_seq_hex, 4, 1) || substring(v_rand_hex, 1, 2) || '-' ||
        -- Last 12 chars of random
        substring(v_rand_hex, 3, 12)
    )::uuid;
END;
$$ LANGUAGE plpgsql;
