DO $$
DECLARE
    fluffy_id UUID := uuid_generate_v7();
    whiskers_id UUID := uuid_generate_v7();
    rover_id UUID := uuid_generate_v7();
    hammy_id UUID := uuid_generate_v7();
    customer1_id UUID := uuid_generate_v7();
    customer2_id UUID := uuid_generate_v7();
    mother_cat_id UUID := uuid_generate_v7();
BEGIN
    -- Mother cat arrives
    INSERT INTO pet_arrived_events (
        pet_id, name, species, price, event_type
    ) VALUES (
        mother_cat_id, 'Luna', 'Cat', 150.00, 'PET_ARRIVED'
    );

    -- Fluffy arrives
    INSERT INTO pet_arrived_events (
        pet_id, name, species, price, event_type
    ) VALUES (
        fluffy_id, 'Fluffy', 'Cat', 100.00, 'PET_ARRIVED'
    );

    -- Whiskers is born
    INSERT INTO pet_born_events (
        pet_id, name, species, mother_id, price, event_type
    ) VALUES (
        whiskers_id, 'Whiskers', 'Cat', mother_cat_id, 80.00, 'PET_BORN'
    );

    -- Rover the dog arrives
    INSERT INTO pet_arrived_events (
        pet_id, name, species, price, event_type
    ) VALUES (
        rover_id, 'Rover', 'Dog', 200.00, 'PET_ARRIVED'
    );

    -- Hammy the hamster arrives
    INSERT INTO pet_arrived_events (
        pet_id, name, species, price, event_type
    ) VALUES (
        hammy_id, 'Hammy', 'Hamster', 25.00, 'PET_ARRIVED'
    );

    -- Price changes
    INSERT INTO pet_price_change_events (
        pet_id, new_price, old_price, event_type
    ) VALUES (
        fluffy_id, 120.00, 100.00, 'PET_PRICE_CHANGE'
    );

    -- Rover gets lost
    INSERT INTO pet_lost_events (
        pet_id, lost_date, last_seen_location, event_type
    ) VALUES (
        rover_id, CURRENT_DATE, 'Back yard', 'PET_LOST'
    );

    -- Rover is found
    INSERT INTO pet_found_events (
        pet_id, found_date, found_location, event_type
    ) VALUES (
        rover_id, CURRENT_DATE, 'Park', 'PET_FOUND'
    );

    -- Sales
    INSERT INTO pet_sold_events (
        pet_id, customer_id, sale_price, event_type
    ) VALUES (
        fluffy_id, customer1_id, 120.00, 'PET_SOLD'
    );

    INSERT INTO pet_sold_events (
        pet_id, customer_id, sale_price, event_type
    ) VALUES (
        hammy_id, customer2_id, 25.00, 'PET_SOLD'
    );

END;
$$;
