# Hello! – Event Sourcing with Postgres

A prototype implementation of event sourcing architecture using Postgres views and materialized views for querying current and historical states.

Inspired by [this article](https://www.heise.de/blog/Event-Sourcing-Die-bessere-Art-zu-entwickeln-10258295.html) / [this video](https://www.youtube.com/watch?v=ss9wnixCGRY) from Golo Roden.

## Key Concepts

- Events are stored in dedicated event tables with UUIDv7 IDs for sequential ordering
- Unified event view provides flexible querying of the event stream
- Materialized views maintain read models with point-in-time snapshots
- Simple architecture that leverages Postgres features rather than external components

## Example Model

The example implementation models a simple pet store with the following events:

- `PetArrived` - A new pet arrives at the store
- `PetBorn` - A pet is born to a mother already in the store
- `PetSold` - A pet is sold to a customer
- `PetPriceChange` - The price of a pet is updated
- `PetLost` - A pet goes missing
- `PetFoundAgain` - A lost pet is found

> In our little pet store, so cozy and bright,
> We track all the moments, from morning till night.
> But one special event you won't find in our code,
> Is when pets cross that final, rainbow road.

> For this is a happy example, you see,
> Where pets live forever, as they should be.
> No PetDied events in our database here,
> Just joyful moments we hold so dear!

Each event is stored in its own table that inherits from a base `events` table containing common fields like:

- `id` (UUIDv7 for temporal ordering)
- `created_at` timestamp 
- `event_type`
- `metadata`

The events are unified in a view that provides flexible querying capabilities. The current state is maintained in materialized views that can show:

- Basic details (name, species)
- Current price
- Status (available, sold, lost)
- Ownership information
- Audit fields (created/updated timestamps)

This provides a flexible event sourcing implementation that allows querying both current and historical states.

## Running the Example

To run this example, you'll need Podman and Podman Compose installed. Then:

### Start Postgres
podman-compose up -d

# Connect to the database
podman-compose exec postgres psql -U postgres hello

# Try running some test queries
```sql
SELECT * FROM unified_events;
SELECT * FROM pets_state;
SELECT * FROM pets_state_snapshot;
```
