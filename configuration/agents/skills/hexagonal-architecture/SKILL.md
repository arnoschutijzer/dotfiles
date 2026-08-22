---
name: hexagonal-architecture
description: "Design or implement ports-and-adapters boundaries with a framework-independent domain, domain-owned ports, edge adapters, and inward dependencies. Use when changing a repository that uses hexagonal architecture or when asked to introduce it, add a port or adapter, isolate an external dependency, or move business logic out of an adapter. Do not use for read-only architecture mapping or assessment."
---

# Hexagonal architecture

## Structure

- **Domain**: business logic and rules. Imports nothing framework-specific: no web, no ORM, no
  broker client. Depends only on its own ports.
- **Ports**: interfaces the domain owns and defines, in its own language. Inbound ports are the
  operations the domain offers; outbound ports are the capabilities it needs.
- **Adapters**: at the edges, depending inward. Inbound adapters (HTTP, CLI, message consumers) call
  inbound ports. Outbound adapters (persistence, external services) implement outbound ports and
  translate infrastructure failures into the domain's own errors.
- Dependencies point inward.

## Use cases

- Keep application orchestration in a use case between the inbound adapter and the domain.
- A use case imports no web, no CLI, and no logger. It composes the domain packages, applies the
  rules, and returns a structured result.
- The inbound adapter reads and validates its own input, invokes the use case, and presents the
  result. Formatting and telemetry stay in the adapter.

## Composition

- Declare each outbound port near the use case that consumes it.
- Construct adapters and connect them to ports in one composition root.
- Keep adapter-specific types and failures outside the domain.

## Architecture tests

Assert in the normal suite that domain and use-case packages do not import framework or adapter
packages. Use the repository's existing dependency, import, or module-boundary checks.
