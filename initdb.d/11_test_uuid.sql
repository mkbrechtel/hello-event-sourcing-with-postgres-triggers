-- hello-event-sourcing-with-postgres-triggers/initdb.d/02_test_uuid.sql
DO $$
DECLARE
    uuid1 uuid;
    uuid2 uuid;
    uuid3 uuid;
BEGIN
    -- Generate three UUIDs in sequence
    SELECT uuid_generate_v7() INTO uuid1;
    PERFORM pg_sleep(0.001); -- Small delay
    SELECT uuid_generate_v7() INTO uuid2;
    PERFORM pg_sleep(0.001);
    SELECT uuid_generate_v7() INTO uuid3;

    -- Output the results
    RAISE NOTICE 'UUID1: %', uuid1;
    RAISE NOTICE 'UUID2: %', uuid2;
    RAISE NOTICE 'UUID3: %', uuid3;
    
    -- Verify they are in sequence
    ASSERT uuid1 < uuid2, 'UUID1 should be less than UUID2';
    ASSERT uuid2 < uuid3, 'UUID2 should be less than UUID3';
    
    RAISE NOTICE 'Test passed: UUIDs are properly sequential';
END;
$$;
