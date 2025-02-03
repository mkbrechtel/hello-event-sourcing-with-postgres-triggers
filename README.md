# Hello! – Event Sourcing with Postgres Triggers

A prototype implementation of event sourcing architecture using Postgres triggers for immediate materialization of read models.

Inspired by [this (german) article](https://www.heise.de/blog/Event-Sourcing-Die-bessere-Art-zu-entwickeln-10258295.html) / [this (german) video](https://www.youtube.com/watch?v=ss9wnixCGRY)  from Golo Roden.

## Key Concepts

- Events are stored in dedicated event tables with UUIDv7 IDs for sequential ordering
- Postgres triggers automatically maintain read-only materialized views of business aggregates
- Read models are always consistent with event history
- Simple architecture that leverages Postgres features rather than external components

## Example Model

The example implementation models a simple pet store with the following events:

- `PetArrived` - A new pet arrives at the store
- `PetBorn` - A pet is born to a mother already in the store
- `PetSold` - A pet is sold to a customer
- `PetPriceChange` - The price of a pet is updated
- `PetLost` - A pet goes missing
- `PetFoundAgain` - A lost pet is found

Each event is stored in its own table that inherits from a base `events` table containing common fields like:

- `id` (UUIDv7 for temporal ordering)
- `created_at` timestamp 
- `event_type`
- `metadata`

The events are processed by Postgres triggers to maintain a read-only `pets` table that shows the current state of each pet including:

- Basic details (name, species)
- Current price
- Status (available, sold, lost)
- Ownership information
- Audit fields (created/updated timestamps)

This provides a simple example of event sourcing while maintaining immediately consistent read models through database triggers.

## Running the Example

To run this example, you'll need Podman and Podman Compose installed. Then:

### Start Postgres
podman-compose up -d

# Connect to the database
podman-compose exec postgres psql -U postgres hello

# Try running some test queries
```sql
SELECT * FROM pets;
SELECT * FROM events;
```
