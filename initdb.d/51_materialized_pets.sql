CREATE OR REPLACE VIEW pets_state AS
WITH RECURSIVE event_timeline AS (
    -- Get all events for each pet, ordered by time
    SELECT 
        pet_id,
        id as event_id,
        created_at,
        event_type,
        event_data,
        ROW_NUMBER() OVER (PARTITION BY pet_id ORDER BY created_at, id) as event_seq
    FROM unified_events
),
pet_states AS (
    -- Start with initial state (PET_ARRIVED or PET_BORN events)
    SELECT 
        pet_id,
        event_id,
        created_at,
        event_seq,
        CASE 
            WHEN event_type = 'PET_ARRIVED' THEN jsonb_build_object(
                'name', event_data->>'name',
                'species', event_data->>'species',
                'price', (event_data->>'price')::decimal,
                'status', 'AVAILABLE',
                'mother_id', NULL
            )
            WHEN event_type = 'PET_BORN' THEN jsonb_build_object(
                'name', event_data->>'name',
                'species', event_data->>'species',
                'price', (event_data->>'price')::decimal,
                'status', 'AVAILABLE',
                'mother_id', (event_data->>'mother_id')::uuid
            )
        END as state
    FROM event_timeline
    WHERE event_type IN ('PET_ARRIVED', 'PET_BORN')
    AND event_seq = 1

    UNION ALL

    -- Recursively apply all subsequent events
    SELECT 
        e.pet_id,
        e.event_id,
        e.created_at,
        e.event_seq,
        CASE e.event_type
            WHEN 'PET_PRICE_CHANGE' THEN 
                ps.state || jsonb_build_object('price', (e.event_data->>'new_price')::decimal)
            
            WHEN 'PET_SOLD' THEN 
                ps.state || jsonb_build_object(
                    'status', 'SOLD',
                    'customer_id', (e.event_data->>'customer_id')::uuid,
                    'sale_price', (e.event_data->>'sale_price')::decimal
                )
            
            WHEN 'PET_LOST' THEN 
                ps.state || jsonb_build_object(
                    'status', 'LOST',
                    'last_seen_location', e.event_data->>'last_seen_location',
                    'lost_date', (e.event_data->>'lost_date')::date
                )
            
            WHEN 'PET_FOUND' THEN 
                ps.state || jsonb_build_object(
                    'status', 'AVAILABLE',
                    'found_location', e.event_data->>'found_location',
                    'found_date', (e.event_data->>'found_date')::date
                )
            
            ELSE ps.state
        END as state
    FROM event_timeline e
    JOIN pet_states ps ON e.pet_id = ps.pet_id AND e.event_seq = ps.event_seq + 1
)
-- Get the latest state for each pet
SELECT 
    pet_id as id,
    created_at as last_updated,
    (state->>'name')::text as name,
    (state->>'species')::text as species,
    (state->>'price')::decimal as price,
    (state->>'status')::text as status,
    (state->>'mother_id')::uuid as mother_id,
    (state->>'customer_id')::uuid as customer_id,
    (state->>'sale_price')::decimal as sale_price,
    (state->>'last_seen_location')::text as last_seen_location,
    (state->>'lost_date')::date as lost_date,
    (state->>'found_location')::text as found_location,
    (state->>'found_date')::date as found_date
FROM (
    SELECT DISTINCT ON (pet_id)
        pet_id,
        created_at,
        state
    FROM pet_states
    ORDER BY pet_id, event_seq DESC
) latest_states;

-- Create a materialized view for better performance
CREATE MATERIALIZED VIEW pets_state_snapshot AS
SELECT * FROM pets_state;

-- Create an index on the materialized view
CREATE UNIQUE INDEX ON pets_state_snapshot (id);

-- Function to refresh the materialized view
CREATE OR REPLACE FUNCTION refresh_pets_state_snapshot()
RETURNS trigger AS $$
BEGIN
    REFRESH MATERIALIZED VIEW CONCURRENTLY pets_state_snapshot;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Create a single trigger on the unified_events view
CREATE TRIGGER refresh_pets_state_snapshot
    AFTER INSERT ON events
    FOR EACH ROW
    EXECUTE FUNCTION refresh_pets_state_snapshot();
