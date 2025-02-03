DO $$
DECLARE
    pet_id UUID := uuid_generate_v7();
    customer_id UUID := uuid_generate_v7();
    pet_record RECORD;
BEGIN
    -- Insert a new pet arrival
    INSERT INTO pet_arrived_events (
        pet_id, name, species, price, event_type
    ) VALUES (
        pet_id, 'Fluffy', 'Cat', 100.00, 'PET_ARRIVED'
    );

    -- Change the price
    INSERT INTO pet_price_change_events (
        pet_id, new_price, old_price, event_type
    ) VALUES (
        pet_id, 120.00, 100.00, 'PET_PRICE_CHANGE'
    );

    -- Sell the pet
    INSERT INTO pet_sold_events (
        pet_id, customer_id, sale_price, event_type
    ) VALUES (
        pet_id, customer_id, 120.00, 'PET_SOLD'
    );

    -- Verify the final state
    SELECT * INTO pet_record FROM pets WHERE id = pet_id;
    
    RAISE NOTICE 'Pet ID: %', pet_record.id;
    RAISE NOTICE 'Name: %', pet_record.name;
    RAISE NOTICE 'Species: %', pet_record.species;
    RAISE NOTICE 'Status: %', pet_record.status;
    RAISE NOTICE 'Current Price: %', pet_record.current_price;
    RAISE NOTICE 'Customer ID: %', pet_record.customer_id;
END;
$$;

-- Add a simple verification query that will show in psql output
SELECT 
    p.id,
    p.name,
    p.species,
    p.status,
    p.current_price,
    p.customer_id
FROM pets p;
