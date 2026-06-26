---
name: hexagonal-architecture
description: Hexagonal (ports and adapters) design, a framework-free domain surrounded by adapters, with ports between them, and boundaries enforced by architecture tests. Use this whenever structuring a module, deciding where code belongs, adding a dependency on a framework or external service, or reviewing whether business logic has leaked into the edges. Apply when designing or refactoring any non-trivial component, in any language.
---

# Hexagonal architecture

Structure code as a framework-free domain surrounded by adapters, with ports between them.

## The shape

- **Domain**: business logic and rules. Imports nothing framework-specific: no web, no ORM,
  no broker client. Depends only on its own ports.
- **Ports**: interfaces the domain owns and defines, expressed in the domain's language.
  Inbound ports describe what the domain offers; outbound ports describe what the domain needs.
- **Adapters**: sit at the edges and depend inward. Inbound adapters (HTTP, CLI, message
  consumers) call inbound ports. Outbound adapters (persistence, external services) implement
  outbound ports.

Dependencies point inward. The domain stays unaware of any adapter.

## Invariants live in the domain

The domain expresses its rules as types. A value object validates in its constructor and cannot exist in an invalid state; an `Email`, `Quantity`, or `NonEmptyList<T>` typed at compile time is valid by construction. Downstream code that takes the type already knows the rule holds, so it carries no guard.

Push each invariant as far up this stack as the language allows:

1. The type itself makes the bad case unrepresentable.
2. A constructor on a value object throws on invalid input.
3. A runtime guard at a call site.
4. A check in the adapter (form validation, request schema).

Layer one is the strongest because it removes the check from every consumer downstream. Reach for a lower layer only when the language cannot express the rule structurally. A guard duplicated across call sites, or a validation rule repeated in each inbound adapter, is the symptom of an invariant that should have been a type.

## Why it pays off

A framework-free domain is unit-testable in isolation, so it pairs directly with the `tdd`
skill: domain behavior gets fast tests through its ports, with no container, database, or
network in the loop.

Testing strategies that exercise the ports live in the `testing` skill: acceptance tests through
the inbound port, and contract tests at the outbound ports.

## Boundaries as tests

A boundary violation, the domain reaching for a framework, is a hazardous state. Encode it
as an **architecture test** in the suite: assert that the domain package imports nothing from
framework or adapter packages. The verification gate then checks structure alongside behavior,
so the boundary holds without anyone policing it by eye.

Express the architecture test in whatever the stack provides: a dependency-direction
assertion, an import-linter rule, a module boundary check. The rule is identical everywhere;
its expression is stack-specific and lives with the language skill or the repository.
