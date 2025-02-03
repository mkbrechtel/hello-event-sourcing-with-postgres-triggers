# Hello! – Event Sourcing with Postgres Triggers

A prototype implementation of event sourcing architecture using Postgres triggers for immediate materialization of read models.

## Key Concepts

- Events are stored in dedicated event tables with UUIDv7 IDs for sequential ordering
- Postgres triggers automatically maintain read-only materialized views of business aggregates
- Read models are always consistent with event history
- Simple architecture that leverages Postgres features rather than external components
