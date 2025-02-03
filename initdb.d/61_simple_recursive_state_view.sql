CREATE VIEW pets_state AS
WITH RECURSIVE event_processing AS (
    -- Base case: First events for each pet (PET_ARRIVED or PET_BORN)
    SELECT 
        e.pet_id,
        e.id as event_id,
        e.created_at,
        e.event_type,
        e.event_data,
        process_event(
            (NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)::pet_state,
            e.id,
            e.event_type,
            e.created_at,
            e.event_data
        ) as current_state
    FROM unified_events e
    WHERE e.event_type IN ('PET_ARRIVED', 'PET_BORN')

    UNION ALL

    -- Recursive case: Process subsequent events
    SELECT 
        e.pet_id,
        e.id as event_id,
        e.created_at,
        e.event_type,
        e.event_data,
        process_event(
            ep.current_state,
            e.id,
            e.event_type,
            e.created_at,
            e.event_data
        ) as current_state
    FROM event_processing ep
    JOIN unified_events e ON e.pet_id = ep.pet_id
    WHERE e.id > ep.event_id
)
-- Select the final state for each pet
SELECT DISTINCT ON (ep.pet_id)
    (ep.current_state).pet_id,
    (ep.current_state).name,
    (ep.current_state).species,
    (ep.current_state).current_price,
    (ep.current_state).status,
    (ep.current_state).customer_id,
    (ep.current_state).mother_id,
    (ep.current_state).last_modified
FROM event_processing ep
ORDER BY ep.pet_id, ep.event_id DESC;

-- Test the view
SELECT * FROM pets_state;
