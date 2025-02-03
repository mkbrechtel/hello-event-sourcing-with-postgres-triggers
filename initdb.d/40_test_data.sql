DO $$
DECLARE
    fluffy_id UUID := uuid_generate_v4();
    whiskers_id UUID := uuid_generate_v4();
    rover_id UUID := uuid_generate_v4();
    hammy_id UUID := uuid_generate_v4();
    bella_id UUID := uuid_generate_v4();
    max_id UUID := uuid_generate_v4();
    charlie_id UUID := uuid_generate_v4();
    axolotl_id UUID := uuid_generate_v4();
    octopus_id UUID := uuid_generate_v4();
    sandpuppy_id UUID := uuid_generate_v4();
    customer1_id UUID := uuid_generate_v4();
    customer2_id UUID := uuid_generate_v4();
    customer3_id UUID := uuid_generate_v4();
    mother_cat_id UUID := uuid_generate_v4();
BEGIN
    -- Mother cat arrives
    INSERT INTO pet_arrived_events (
        pet_id, name, species, price, event_type, created_at
    ) VALUES (
        mother_cat_id, 'Luna', 'Cat', 150.00, 'PET_ARRIVED', '2025-01-01 10:00:00'
    );

    -- Fluffy arrives
    INSERT INTO pet_arrived_events (
        pet_id, name, species, price, event_type, created_at
    ) VALUES (
        fluffy_id, 'Fluffy', 'Cat', 100.00, 'PET_ARRIVED', '2025-01-05 14:30:00'
    );

    -- Whiskers is born
    INSERT INTO pet_born_events (
        pet_id, name, species, mother_id, price, event_type, created_at
    ) VALUES (
        whiskers_id, 'Whiskers', 'Cat', mother_cat_id, 80.00, 'PET_BORN', '2025-01-15 09:15:00'
    );

    -- Rover the dog arrives
    INSERT INTO pet_arrived_events (
        pet_id, name, species, price, event_type, created_at
    ) VALUES (
        rover_id, 'Rover', 'Dog', 200.00, 'PET_ARRIVED', '2025-01-20 11:45:00'
    );

    -- Hammy the hamster arrives
    INSERT INTO pet_arrived_events (
        pet_id, name, species, price, event_type, created_at
    ) VALUES (
        hammy_id, 'Hammy', 'Hamster', 25.00, 'PET_ARRIVED', '2025-01-25 16:20:00'
    );

    -- Bella the cat arrives
    INSERT INTO pet_arrived_events (
        pet_id, name, species, price, event_type, created_at
    ) VALUES (
        bella_id, 'Bella', 'Cat', 130.00, 'PET_ARRIVED', '2025-02-01 10:00:00'
    );

    -- Max the dog arrives
    INSERT INTO pet_arrived_events (
        pet_id, name, species, price, event_type, created_at
    ) VALUES (
        max_id, 'Max', 'Dog', 250.00, 'PET_ARRIVED', '2025-02-05 13:30:00'
    );

    -- Charlie the hamster arrives
    INSERT INTO pet_arrived_events (
        pet_id, name, species, price, event_type, created_at
    ) VALUES (
        charlie_id, 'Charlie', 'Hamster', 30.00, 'PET_ARRIVED', '2025-02-10 15:45:00'
    );

    -- Axolotl arrives
    INSERT INTO pet_arrived_events (
        pet_id, name, species, price, event_type, created_at
    ) VALUES (
        axolotl_id, 'Axel', 'Axolotl', 75.00, 'PET_ARRIVED', '2025-02-12 09:00:00'
    );

    -- Octopus arrives
    INSERT INTO pet_arrived_events (
        pet_id, name, species, price, event_type, created_at
    ) VALUES (
        octopus_id, 'Otto', 'Octopus', 200.00, 'PET_ARRIVED', '2025-02-13 14:00:00'
    );

    -- Sand puppy arrives
    INSERT INTO pet_arrived_events (
        pet_id, name, species, price, event_type, created_at
    ) VALUES (
        sandpuppy_id, 'Sandy', 'Sand Puppy', 150.00, 'PET_ARRIVED', '2025-02-14 11:30:00'
    );

    -- Price changes
    INSERT INTO pet_price_change_events (
        pet_id, new_price, old_price, event_type, created_at
    ) VALUES (
        fluffy_id, 120.00, 100.00, 'PET_PRICE_CHANGE', '2025-02-15 09:00:00'
    );

    INSERT INTO pet_price_change_events (
        pet_id, new_price, old_price, event_type, created_at
    ) VALUES (
        max_id, 280.00, 250.00, 'PET_PRICE_CHANGE', '2025-02-20 14:15:00'
    );

    -- Additional price changes
    INSERT INTO pet_price_change_events (
        pet_id, new_price, old_price, event_type, created_at
    ) VALUES (
        axolotl_id, 95.00, 75.00, 'PET_PRICE_CHANGE', '2025-02-22 10:00:00'
    );

    INSERT INTO pet_price_change_events (
        pet_id, new_price, old_price, event_type, created_at
    ) VALUES (
        octopus_id, 250.00, 200.00, 'PET_PRICE_CHANGE', '2025-02-23 11:00:00'
    );

    -- Rover gets lost
    INSERT INTO pet_lost_events (
        pet_id, lost_date, last_seen_location, event_type, created_at
    ) VALUES (
        rover_id, '2025-02-25', 'Back yard', 'PET_LOST', '2025-02-25 17:30:00'
    );

    -- Charlie gets lost
    INSERT INTO pet_lost_events (
        pet_id, lost_date, last_seen_location, event_type, created_at
    ) VALUES (
        charlie_id, '2025-02-26', 'Exercise wheel', 'PET_LOST', '2025-02-26 12:00:00'
    );

    -- Rover is found
    INSERT INTO pet_found_events (
        pet_id, found_date, found_location, event_type, created_at
    ) VALUES (
        rover_id, '2025-02-28', 'Park', 'PET_FOUND', '2025-02-28 10:45:00'
    );

    -- Sales
    INSERT INTO pet_sold_events (
        pet_id, customer_id, sale_price, event_type, created_at
    ) VALUES (
        fluffy_id, customer1_id, 120.00, 'PET_SOLD', '2025-03-01 11:20:00'
    );

    INSERT INTO pet_sold_events (
        pet_id, customer_id, sale_price, event_type, created_at
    ) VALUES (
        hammy_id, customer2_id, 25.00, 'PET_SOLD', '2025-03-05 15:30:00'
    );

    INSERT INTO pet_sold_events (
        pet_id, customer_id, sale_price, event_type, created_at
    ) VALUES (
        bella_id, customer3_id, 130.00, 'PET_SOLD', '2025-03-10 16:45:00'
    );

    INSERT INTO pet_sold_events (
        pet_id, customer_id, sale_price, event_type, created_at
    ) VALUES (
        axolotl_id, customer2_id, 95.00, 'PET_SOLD', '2025-03-20 11:30:00'
    );

END;
$$;
