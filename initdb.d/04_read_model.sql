-- Read model for pets
CREATE TABLE pets (
    id UUID PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    species VARCHAR(50) NOT NULL,
    current_price DECIMAL(10,2),
    status VARCHAR(20) NOT NULL, -- 'AVAILABLE', 'SOLD', 'LOST'
    customer_id UUID,
    mother_id UUID,
    last_event_id UUID NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL
);

-- Trigger functions for each event type
CREATE OR REPLACE FUNCTION process_pet_arrived()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO pets (
        id, name, species, current_price, status, 
        last_event_id, created_at, updated_at
    ) VALUES (
        NEW.pet_id, NEW.name, NEW.species, NEW.price, 'AVAILABLE',
        NEW.id, NEW.created_at, NEW.created_at
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION process_pet_born()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO pets (
        id, name, species, current_price, status, mother_id,
        last_event_id, created_at, updated_at
    ) VALUES (
        NEW.pet_id, NEW.name, NEW.species, NEW.price, 'AVAILABLE', NEW.mother_id,
        NEW.id, NEW.created_at, NEW.created_at
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION process_pet_sold()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE pets 
    SET status = 'SOLD',
        customer_id = NEW.customer_id,
        last_event_id = NEW.id,
        updated_at = NEW.created_at
    WHERE id = NEW.pet_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create triggers
CREATE TRIGGER pet_arrived_trigger
    AFTER INSERT ON pet_arrived_events
    FOR EACH ROW
    EXECUTE FUNCTION process_pet_arrived();

CREATE TRIGGER pet_born_trigger
    AFTER INSERT ON pet_born_events
    FOR EACH ROW
    EXECUTE FUNCTION process_pet_born();

CREATE TRIGGER pet_sold_trigger
    AFTER INSERT ON pet_sold_events
    FOR EACH ROW
    EXECUTE FUNCTION process_pet_sold();
