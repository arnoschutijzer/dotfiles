---
name: hexagonal-architecture
description: "Design or implement ports-and-adapters boundaries with a framework-independent domain, domain-owned ports, edge adapters, and inward dependencies. Use when changing a repository that uses hexagonal architecture or when asked to introduce it, add a port or adapter, isolate an external dependency, or move business logic out of an adapter. Do not use for read-only architecture mapping or assessment."
---

# Hexagonal architecture

The domain is at the centre and owns the interfaces it needs. Frameworks,
drivers, and clients stay at the edges and depend inward. Dependency direction
is the rule. Layers are the result of the rule.

Read `references/worked-example-go.md` first. It contains one complete vertical
slice: domain, use case, both adapters, composition root, and test doubles. Copy
its layout, its names, and its error translation. Do not invent a different
structure.

## Layers

- **Domain**: business rules. Imports no web, no ORM, no broker client, and no
  logger. Entities validate their own data at construction. An invalid entity
  cannot exist. The domain declares the error values that all other layers use.
- **Ports**: interfaces that the domain or the use case owns and declares.
  Inbound ports are the operations the application offers. Outbound ports are
  the capabilities the application needs.
- **Use cases**: application orchestration. Imports no web, no CLI, no logger,
  and no configuration. Composes domain packages, applies the rules, and returns
  a structured result. Accepts and returns plain boundary types.
- **Inbound adapters**: HTTP, CLI, and message consumers. Each adapter owns its
  wire format, validates its input, calls a use case through an inbound port,
  maps domain errors to protocol responses, and presents the result.
- **Outbound adapters**: implementations of outbound ports. Each adapter
  translates infrastructure failures into domain errors and domain entities into
  infrastructure records. Each adapter owns its connection pool, retries,
  backoff, and circuit breaker.

## Decision rules

- Declare each outbound port in the package of the use case that calls it. Do
  not declare the port next to the adapter.
- Give each port the name of the capability, not the name of the technology.
  Use `ReadingAppender`, not `TimescaleRepository`.
- Keep each port narrow. Include only the methods that the current caller uses.
- Treat time, randomness, identifiers, logging, and telemetry as outbound
  capabilities. Inject them as ports.
- Translate errors at both edges. A driver error type in a use case is a defect.
- Construct the adapters and connect them to the ports in one composition root.
- Keep serialization tags and framework types out of boundary structs.

## Anti-patterns

These conditions agree with the offender rules in the `create-hexagonal-graph`
skill, which maps an existing repository against the same criteria.

- An ORM record, a driver error, or a transport type in a port signature.
- A port declared by the adapter instead of the caller.
- One port for each adapter, such as `PostgresPort`, instead of one port for
  each capability.
- An anemic entity: the use case holds the rules and the domain holds only data.
- One shared type used by the handler, the use case, and the persistence code.
- Adapter construction outside the composition root.
- An inbound adapter that calls an outbound adapter directly.

## Feature slice procedure

1. Read an adjacent slice. Copy its layout and its names. Consistency is more
   important than the ideal shape.
2. Write the domain entity and its error values.
3. Declare the outbound port in the use-case package.
4. Write the use case. Test it against fakes.
5. Write the adapters last.

## Introduction procedure

Do not convert the full repository.

1. Run the `create-hexagonal-graph` skill to map the current structure.
2. Select one slice that changes often.
3. Extract the domain entity and the outbound port for that slice only.
4. Add the architecture test with the first slice. Limit the test to the
   converted packages.
5. Leave all other slices unchanged until the user asks for more.

## Architecture test

Enforce the boundaries in the normal test suite. Use the dependency checker that
the repository already has, such as `import-linter`, `eslint-plugin-boundaries`,
or ArchUnit. If the repository has no checker, assert on the import graph. For
Go:

```sh
# Fails if a domain or use-case package reaches a framework or a driver.
# List the domain and use-case packages only. A `/...` glob also selects the
# adapter packages, which import drivers by design, and the check always fails.
# `grep -x` prevents a match on an unrelated path such as
# `vendor/golang.org/x/net/http`.
go list -deps ./internal/<slice> ./internal/<slice>/app \
  | grep -xE 'net/http|database/sql|github.com/jackc/.*|github.com/segmentio/kafka-go.*' \
  && exit 1
```

The command prints nothing and returns 1 for a clean slice. It prints the
forbidden package and returns 0 when a use case imports a driver.

A missing architecture test is an enforcement gap. It is not a dependency
violation. Report it as a gap.
