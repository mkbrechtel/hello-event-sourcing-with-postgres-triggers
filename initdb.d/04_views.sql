-- Create a view that builds the current state from events
CREATE VIEW pets_view AS
WITH ranked_events AS (
    -- Get initial pet state from arrived or born events
    SELECT 
        e.id as event_id,
        e.created_at,
        COALESCE(a.pet_id, b.pet_id) as pet_id,
        COALESCE(a.name, b.name) as name,
        COALESCE(a.species, b.species) as species,
        COALESCE(a.price, b.price) as initial_price,
        b.mother_id,
        'AVAILABLE'::text as initial_status,
        ROW_NUMBER() OVER (PARTITION BY COALESCE(a.pet_id, b.pet_id) ORDER BY e.created_at) as rn
    FROM events e
    LEFT JOIN pet_arrived_events a ON e.id = a.id
    LEFT JOIN pet_born_events b ON e.id = b.id
    WHERE e.event_type IN ('PET_ARRIVED', 'PET_BORN')
),
price_changes AS (
    -- Get latest price for each pet
    SELECT DISTINCT ON (pc.pet_id)
        pc.pet_id,
        pc.new_price as current_price
    FROM pet_price_change_events pc
    ORDER BY pc.pet_id, pc.created_at DESC
),
status_changes AS (
    -- Calculate current status based on all events
    SELECT DISTINCT ON (pet_id)
        CASE
            WHEN s.event_type = 'PET_SOLD' THEN 'SOLD'
            WHEN l.event_type = 'PET_LOST' AND f.event_type IS NULL THEN 'LOST'
            WHEN f.event_type = 'PET_FOUND' THEN 'AVAILABLE'
            ELSE 'AVAILABLE'
        END as status,
        CASE 
            WHEN s.event_type = 'PET_SOLD' THEN s.customer_id 
            ELSE NULL 
        END as customer_id,
        COALESCE(s.pet_id, l.pet_id, f.pet_id) as pet_id
    FROM events e
    LEFT JOIN pet_sold_events s ON e.id = s.id
    LEFT JOIN pet_lost_events l ON e.id = l.id
    LEFT JOIN pet_found_events f ON e.id = f.id
    WHERE e.event_type IN ('PET_SOLD', 'PET_LOST', 'PET_FOUND')
    ORDER BY pet_id, e.created_at DESC
)
SELECT 
    re.pet_id as id,
    re.name,
    re.species,
    COALESCE(pc.current_price, re.initial_price) as current_price,
    COALESCE(sc.status, re.initial_status) as status,
    sc.customer_id,
    re.mother_id,
    re.event_id as initial_event_id,
    re.created_at as created_at
FROM ranked_events re
LEFT JOIN price_changes pc ON re.pet_id = pc.pet_id
LEFT JOIN status_changes sc ON re.pet_id = sc.pet_id
WHERE re.rn = 1;

-- Create a materialized view for snapshots
CREATE MATERIALIZED VIEW pets_snapshot AS
SELECT * FROM pets_view;

-- Create an index on the materialized view
CREATE UNIQUE INDEX ON pets_snapshot (id);

-- Function to refresh the materialized view
CREATE OR REPLACE FUNCTION refresh_pets_snapshot()
RETURNS trigger AS $$
BEGIN
    REFRESH MATERIALIZED VIEW CONCURRENTLY pets_snapshot;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Trigger to refresh the materialized view when events are added
CREATE TRIGGER refresh_pets_snapshot_trigger
AFTER INSERT ON events
FOR EACH ROW
EXECUTE FUNCTION refresh_pets_snapshot();
