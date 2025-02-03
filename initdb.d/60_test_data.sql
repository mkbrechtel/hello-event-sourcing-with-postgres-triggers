DO $$
DECLARE
    pet_id UUID := uuid_generate_v7();
    customer_id UUID := uuid_generate_v7();
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

END;
$$;

