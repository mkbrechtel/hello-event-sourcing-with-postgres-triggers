CREATE TYPE pet_state AS (
    pet_id UUID,
    name VARCHAR(100),
    species VARCHAR(50),
    current_price DECIMAL(10,2),
    status VARCHAR(20),
    customer_id UUID,
    mother_id UUID,
    last_modified TIMESTAMP WITH TIME ZONE
);

CREATE OR REPLACE FUNCTION process_event(
    current_state pet_state,
    event_id UUID,
    event_type VARCHAR(100),
    event_time TIMESTAMP WITH TIME ZONE,
    event_data JSONB
) RETURNS pet_state AS $$
DECLARE
    new_state pet_state;
BEGIN
    -- Initialize new_state with current_state values
    new_state := current_state;
    
    -- Always update last_modified
    new_state.last_modified := event_time;

    CASE event_type
        WHEN 'PET_ARRIVED' THEN
            new_state.pet_id := current_state.pet_id;
            new_state.name := event_data->>'name';
            new_state.species := event_data->>'species';
            new_state.current_price := (event_data->>'price')::DECIMAL(10,2);
            new_state.status := 'AVAILABLE';

        WHEN 'PET_BORN' THEN
            new_state.pet_id := current_state.pet_id;
            new_state.name := event_data->>'name';
            new_state.species := event_data->>'species';
            new_state.current_price := (event_data->>'price')::DECIMAL(10,2);
            new_state.mother_id := (event_data->>'mother_id')::UUID;
            new_state.status := 'AVAILABLE';

        WHEN 'PET_SOLD' THEN
            new_state.status := 'SOLD';
            new_state.customer_id := (event_data->>'customer_id')::UUID;
            new_state.current_price := (event_data->>'sale_price')::DECIMAL(10,2);

        WHEN 'PET_PRICE_CHANGE' THEN
            new_state.current_price := (event_data->>'new_price')::DECIMAL(10,2);

        WHEN 'PET_LOST' THEN
            new_state.status := 'LOST';

        WHEN 'PET_FOUND' THEN
            new_state.status := 'AVAILABLE';

        ELSE
            RAISE EXCEPTION 'Unknown event type: %', event_type;
    END CASE;

    RETURN new_state;
END;
$$ LANGUAGE plpgsql;
