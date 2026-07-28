---
name: hexagonal-architecture
description: "Ports and adapters: a framework-free domain, adapters at the edges, invariants as types, boundaries held by architecture tests. Use for a new port, adapter, or use case, a new external dependency reaching the domain, a change spanning more than one layer, or when business logic has leaked into the edges. Any language."
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

Organize by vertical slice: one package per user-facing operation, holding its use case and the
narrow ports it consumes, each declared in the consuming code. Two slices needing the same shape each
declare their own, and one adapter satisfies both structurally. No shared layer above the slices.

## Use cases

- One use case per user-facing operation, between the inbound adapter and the rest of the domain.
- A use case imports no web, no CLI, and no logger. It composes the domain packages, applies the
  rules, and returns a structured result.
- The inbound adapter reads and validates its own input, invokes the use case, and presents the
  result. Formatting and telemetry stay in the adapter.
- Report in-progress work through optional callbacks passed as ports, wired by the adapter.

## Invariants

Express domain rules as types. A value type validates in its constructor and cannot exist in an
invalid state. Push each invariant as far up this stack as the language allows:

1. The type itself makes the bad case unrepresentable.
2. A constructor on a value type throws on invalid input.
3. A runtime guard at a call site.
4. A check in the adapter (form validation, request schema).

A guard duplicated across call sites, or a validation repeated in each inbound adapter, means the
invariant should be a type; introduce it while changing the code that constructs the value.

## Architecture tests

Assert in the normal suite that the domain and use-case packages import nothing from framework or
adapter packages. Express it however the stack allows: a dependency-direction assertion, an
import-linter rule, a module boundary check. Add it when the assertion is already available, or when
creating a new module.
