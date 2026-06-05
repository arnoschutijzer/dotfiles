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

## Why it pays off

A framework-free domain is unit-testable in isolation, so it pairs directly with the `tdd`
skill: domain behavior gets fast tests through its ports, with no container, database, or
network in the loop.

Tests that exercise the ports from outside, acceptance tests through the inbound port and
contract tests at the outbound ports, live in the `testing` skill.

## Boundaries as tests

A boundary violation, the domain reaching for a framework, is a hazardous state. Encode it
as an **architecture test** in the suite: assert that the domain package imports nothing from
framework or adapter packages. The verification gate then checks structure alongside behavior,
so the boundary holds without anyone policing it by eye.

Express the architecture test in whatever the stack provides: a dependency-direction
assertion, an import-linter rule, a module boundary check. The rule is identical everywhere;
its expression is stack-specific and lives with the language skill or the repository.
