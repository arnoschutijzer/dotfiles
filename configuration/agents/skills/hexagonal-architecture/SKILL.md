---
name: hexagonal-architecture
description: "Design or implement ports-and-adapters boundaries with a framework-independent domain, domain-owned ports, edge adapters, and inward dependencies. Use when adding or changing a domain entity, use case, port, or adapter in a repository that uses hexagonal architecture, or when asked to introduce it, isolate an external dependency, or move business logic out of an adapter. Do not use for read-only architecture mapping or assessment."
---

# Hexagonal architecture

Dependencies point inward. The domain owns the interfaces it needs. Frameworks
and drivers stay at the edges.

Follow the layout and names of the existing slices. When the repository has
none, read `references/worked-example-go.md` and copy its layout, names, and
error translation. Outside Go, keep its structure and use the language's
idioms.

## Layers

- **Domain**: business rules and error values. Imports no web, ORM, broker, or
  logger. Entities validate at construction.
- **Ports**: interfaces the domain or use case declares. Inbound ports are
  offered operations. Outbound ports are needed capabilities.
- **Use cases**: orchestration. Imports no web, CLI, logger, or configuration.
  Accepts and returns plain boundary types.
- **Inbound adapters**: own the wire format, validate input, call a use case
  through an inbound port, map domain and use-case errors to protocol responses.
- **Outbound adapters**: implement outbound ports. Translate infrastructure
  failures into use-case-owned errors. Own the pool, retries, backoff, breaker.

## Rules

- Declare each outbound port in the use-case package that calls it.
- Name a port for the capability: `ReadingAppender`, not `TimescaleRepository`.
- Include only the methods the current caller uses.
- Route status and health reads through a use case too. An interface such as
  `StatusReader` does not provide a use case if it connects a handler directly
  to a database adapter.
- Inject time, randomness, identifiers, logging, and telemetry as ports.
- Use the injected clock for every time calculation.
- Translate every database and outbound HTTP failure into a use-case-owned
  error, including unexpected failures. Wrapping an infrastructure error with
  `%w` does not translate it. Do not expose it through an unwrap chain; keep
  infrastructure details in adapter diagnostics. Wrapping an already translated
  error is allowed. Inbound adapters map these errors to protocol responses.
- When the caller's context is cancelled or past its deadline, return
  `ctx.Err()` instead of a store failure. It belongs to the caller, not to the
  infrastructure.
- Wire adapters to ports in one composition root.
- Keep serialization tags and framework types out of boundary structs,
  including nested status and result types. Define request and response DTOs
  in the HTTP adapter and explicitly map them to and from boundary types.

## Anti-patterns

- An ORM record, driver error, or transport type in a port signature.
- A port declared by the adapter instead of the caller.
- One port for each adapter (`PostgresPort`) instead of one for each capability.
- An anemic entity: rules in the use case, data in the domain.
- One type shared by handler, use case, and persistence.
- Adapter construction outside the composition root.
- An inbound adapter that calls an outbound adapter directly.

## Feature slice

1. Read an adjacent slice. Copy its layout and names. If none exists, use the
   worked example.
2. Write the entity and its error values.
3. Declare the outbound port in the use-case package.
4. Write the use case. Test it against fakes.
5. Write the adapters last.

## Verification

- Trace each changed handler through a use case to its outbound ports. Check
  the composition root to confirm what each interface resolves to.
- Inspect boundary types and their nested types for serialization tags.
- Check adapter error paths, including fallback paths. Test that expected and
  unexpected infrastructure failures produce use-case-owned errors and do not
  expose driver or HTTP client errors through `errors.Is` or `errors.As`.

## Introduction

Do not convert the full repository.

1. Run the `create-hexagonal-graph` skill to map the current structure.
2. Select one slice that changes often.
3. Extract its entity and outbound port.
4. Leave other slices unchanged until asked.
