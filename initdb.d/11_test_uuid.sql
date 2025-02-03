DO $$
DECLARE
    prev_uuid uuid;
    curr_uuid uuid;
    i integer;
BEGIN
    -- Generate array of 10000 UUIDs and verify they are sequential
    SELECT uuid_generate_v7() INTO prev_uuid;

    FOR i IN 1..10000 LOOP
        SELECT uuid_generate_v7() INTO curr_uuid;

        -- Verify current UUID is greater than previous
        ASSERT curr_uuid > prev_uuid, 
            format('UUID sequence broken at iteration %s: %s is not greater than %s', 
                   i, curr_uuid, prev_uuid);

        prev_uuid := curr_uuid;
    END LOOP;

    RAISE NOTICE 'Test passed: 10000 UUIDs verified to be properly sequential';
END;
$$;
