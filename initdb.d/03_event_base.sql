-- Base event table
CREATE TABLE events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    event_type VARCHAR(100) NOT NULL,
    metadata JSONB DEFAULT '{}'::jsonb
);

-- Create event tables for each specific event type
CREATE TABLE pet_arrived_events (
    pet_id UUID NOT NULL,
    name VARCHAR(100) NOT NULL,
    species VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL
) INHERITS (events);

CREATE TABLE pet_born_events (
    pet_id UUID NOT NULL,
    name VARCHAR(100) NOT NULL,
    species VARCHAR(50) NOT NULL,
    mother_id UUID NOT NULL,
    price DECIMAL(10,2) NOT NULL
) INHERITS (events);

CREATE TABLE pet_sold_events (
    pet_id UUID NOT NULL,
    customer_id UUID NOT NULL,
    sale_price DECIMAL(10,2) NOT NULL
) INHERITS (events);

CREATE TABLE pet_price_change_events (
    pet_id UUID NOT NULL,
    new_price DECIMAL(10,2) NOT NULL,
    old_price DECIMAL(10,2) NOT NULL
) INHERITS (events);

CREATE TABLE pet_lost_events (
    pet_id UUID NOT NULL,
    lost_date DATE NOT NULL,
    last_seen_location TEXT
) INHERITS (events);

CREATE TABLE pet_found_events (
    pet_id UUID NOT NULL,
    found_date DATE NOT NULL,
    found_location TEXT
) INHERITS (events);
