---
name: hexagonal-architecture
description: "Design or implement ports-and-adapters boundaries with a framework-independent domain, domain-owned ports, edge adapters, and inward dependencies. Use when changing a repository that uses hexagonal architecture or when asked to introduce it, add a port or adapter, isolate an external dependency, or move business logic out of an adapter. Do not use for read-only architecture mapping or assessment."
---

# Hexagonal architecture

Dependencies point inward. The domain owns the interfaces it needs. Frameworks
and drivers stay at the edges.

Read `references/worked-example-go.md` and copy its layout, names, and error
translation.

## Layers

- **Domain**: business rules and error values. Imports no web, ORM, broker, or
  logger. Entities validate at construction.
- **Ports**: interfaces the domain or use case declares. Inbound ports are
  offered operations. Outbound ports are needed capabilities.
- **Use cases**: orchestration. Imports no web, CLI, logger, or configuration.
  Accepts and returns plain boundary types.
- **Inbound adapters**: own the wire format, validate input, call a use case
  through an inbound port, map domain errors to protocol responses.
- **Outbound adapters**: implement outbound ports. Translate infrastructure
  failures into domain errors. Own the pool, retries, backoff, breaker.

## Rules

- Declare each outbound port in the use-case package that calls it.
- Name a port for the capability: `ReadingAppender`, not `TimescaleRepository`.
- Include only the methods the current caller uses.
- Inject time, randomness, identifiers, logging, and telemetry as ports.
- Translate errors at both edges. A driver error in a use case is a defect.
- Wire adapters to ports in one composition root.
- Keep serialization tags and framework types out of boundary structs.

## Anti-patterns

Same criteria as the offender rules in `create-hexagonal-graph`.

- An ORM record, driver error, or transport type in a port signature.
- A port declared by the adapter instead of the caller.
- One port for each adapter (`PostgresPort`) instead of one for each capability.
- An anemic entity: rules in the use case, data in the domain.
- One type shared by handler, use case, and persistence.
- Adapter construction outside the composition root.
- An inbound adapter that calls an outbound adapter directly.

## Feature slice

1. Read an adjacent slice. Copy its layout and names.
2. Write the entity and its error values.
3. Declare the outbound port in the use-case package.
4. Write the use case. Test it against fakes.
5. Write the adapters last.

## Introduction

Do not convert the full repository.

1. Run `create-hexagonal-graph` to map the current structure.
2. Select one slice that changes often.
3. Extract its entity and outbound port.
4. Add the architecture test, limited to the converted packages.
5. Leave other slices unchanged until asked.

## Architecture test

Use the repository's checker (`import-linter`, `eslint-plugin-boundaries`,
ArchUnit). Otherwise assert on the import graph. For Go:

```sh
go list -deps ./internal/<slice> ./internal/<slice>/app \
  | grep -xE 'net/http|database/sql|github.com/jackc/.*|github.com/segmentio/kafka-go.*' \
  && exit 1
```

List the packages explicitly: a `/...` glob selects the adapter packages, which
import drivers by design, and the check never passes. `grep -x` prevents a match
on `vendor/golang.org/x/net/http`.

A missing architecture test is an enforcement gap, not a dependency violation.
