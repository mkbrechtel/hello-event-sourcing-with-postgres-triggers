CREATE VIEW unified_events AS
WITH event_union AS (
    -- Pet Arrived Events
    SELECT 
        id,
        created_at,
        event_type,
        pet_id,
        jsonb_build_object(
            'name', name,
            'species', species,
            'price', price
        ) as event_data,
        metadata
    FROM pet_arrived_events

    UNION ALL

    -- Pet Born Events
    SELECT 
        id,
        created_at,
        event_type,
        pet_id,
        jsonb_build_object(
            'name', name,
            'species', species,
            'mother_id', mother_id,
            'price', price
        ) as event_data,
        metadata
    FROM pet_born_events

    UNION ALL

    -- Pet Sold Events
    SELECT 
        id,
        created_at,
        event_type,
        pet_id,
        jsonb_build_object(
            'customer_id', customer_id,
            'sale_price', sale_price
        ) as event_data,
        metadata
    FROM pet_sold_events

    UNION ALL

    -- Price Change Events
    SELECT 
        id,
        created_at,
        event_type,
        pet_id,
        jsonb_build_object(
            'old_price', old_price,
            'new_price', new_price
        ) as event_data,
        metadata
    FROM pet_price_change_events

    UNION ALL

    -- Lost Events
    SELECT 
        id,
        created_at,
        event_type,
        pet_id,
        jsonb_build_object(
            'lost_date', lost_date,
            'last_seen_location', last_seen_location
        ) as event_data,
        metadata
    FROM pet_lost_events

    UNION ALL

    -- Found Events
    SELECT 
        id,
        created_at,
        event_type,
        pet_id,
        jsonb_build_object(
            'found_date', found_date,
            'found_location', found_location
        ) as event_data,
        metadata
    FROM pet_found_events
)
SELECT 
    id,
    created_at,
    event_type,
    pet_id,
    event_data,
    metadata
FROM event_union
ORDER BY id;
