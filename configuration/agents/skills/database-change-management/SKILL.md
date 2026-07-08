---
name: database-change-management
description: "Evolve a database schema or the shape of persisted data without breaking a running system: expand-contract migrations, backward-compatible steps, versioned forward-only migration files, online backfills, all driven and verified under TDD. Use whenever a change adds, alters, renames, or removes a column, table, index, or constraint, changes a stored data shape, or backfills existing rows, in any language or store."
---

# Database change management

Change the schema in small, backward-compatible steps, each one releasable on its own, so each
deploy and its migration can run as separate, independent steps.

## Compatibility during rollout

A deploy and its migration run at separate times. When the rollout runs old and new
application versions at the same time against the same database, a schema change that only the
new code understands breaks the old code still serving traffic. Under that deploy model every
schema change is a compatibility problem first, and the expand-contract steps below apply.

Confirm the deploy model before applying them. When the deploy guarantees no version overlap,
such as a maintenance window or a single instance taken down and replaced, the migration and
its code ship together and the compatibility steps collapse to a direct change. Default to
assuming overlap, since rolling deploys are the common case.

## Expand-contract

Evolve through parallel change. Each step stays backward-compatible:

1. **Expand.** Add the new structure additively (a nullable column, a new table, a new index).
   Old code ignores it; new code can start writing it. Backward-compatible, so it ships and
   rolls back freely.
2. **Migrate.** Backfill existing rows, and where both shapes must stay live, dual-write to old
   and new. The application reads whichever shape is authoritative for that step.
3. **Contract.** Once nothing reads or writes the old structure, remove it in its own later
   deploy.

Each step is a separate, backward-compatible deploy. Rollback is staying on the prior step,
which is already deployed and backward-compatible. This is the persistence-layer form of an
opt-in feature toggle: the schema ships ahead of the code that depends on it.

## Migrations as artifacts

- Versioned, ordered, and checked into version control alongside the code that needs them.
- Applied by a migration tool (the stack's Flyway, Liquibase, Alembic, or equivalent), which
  owns running them against every environment.
- Forward-only and immutable once applied or shipped. A mistake in a released migration is
  corrected by adding a new migration; the released one stays as it was applied.
- One concern per migration. Keep DDL (structure) and DML (data) in separate migrations and
  separate commits, so the data move and the structure change deploy and revert independently.

## Hazardous operations

Some single statements lock a table or break compatibility. Decompose each into expand-contract:

- **Rename a column or table.** Add the new name, dual-write, backfill, switch reads, drop the
  old name. A direct rename breaks every running old instance at once.
- **Add a NOT NULL column.** Add it nullable with a default, backfill, then add the constraint.
- **Change a column type.** Add a new column of the new type, dual-write and backfill, switch
  reads, drop the old.
- **Add an index on a large table.** Build it online or concurrently where the store supports
  it, so the migration does not hold a write lock.
- **Drop a column or table.** Only after confirming no deployed code path references it. This
  is the contract step, gated on the expand having fully rolled out.

Which statements lock, and the safe online form of each, depend on the store. See the `mysql`
or `postgres` skill for the locking behavior of the store in use.

## Backfills

- A large backfill runs in batches, outside the deploy's critical path, as its own online data
  migration. A single unbatched UPDATE over a large table locks it.
- Make the backfill idempotent and resumable, so a failure partway through restarts without
  double-applying.
- Emit progress while it runs: rows processed, batches remaining, and error rate, so a stall
  or a double-apply is visible before the backfill finishes (see the `observability` skill).
- Treat the backfill as a data change with its own verification, separate from the DDL that
  made room for it.

## Persistence is an outbound adapter

Persistence is an outbound adapter (see `hexagonal-architecture`). The schema and its
migrations live at that edge, and the domain stays unaware of them. A migration is an adapter
concern; the domain speaks in values, and the adapter maps them to and from the stored shape.

## Verification

A schema change is driven under `tdd` like any other:

- The migration applies cleanly against a representative copy of the schema, from the current
  version forward, with no manual step.
- During the transition, a test proves the application works against both the old and the new
  shape, since both run during a rollout.
- A backfill has a test that asserts the migrated data is correct, including the rows that were
  malformed or null before.
- The full suite stays green against the migrated schema.

## When to stop

- The change cannot be made backward-compatible in one step: stop and decompose it into expand,
  migrate, and contract deploys.
- A backfill would lock a production table: stop and rebatch it as an online migration that runs
  outside the deploy.
- A step's rollback is destructive (it would drop a column new code already wrote to): stop,
  because that signals the steps are ordered wrong.

## Done

The schema reached its target shape through backward-compatible steps, each migration is a
versioned forward-only artifact, every transitional state has a test, large data moves ran
online and idempotently, and the suite is green against the final schema.
