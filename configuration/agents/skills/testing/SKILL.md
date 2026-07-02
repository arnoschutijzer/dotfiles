---
name: testing
description: "Testing strategies around the unit loop and where each fits: acceptance tests driven from outside through real adapters, consumer-driven contract tests at the ports, test data builders and deterministic fixtures, and property-based testing over generated inputs. Use this when deciding how to test a change beyond a single unit test, covering a feature end to end, a service boundary, the data a test needs, or an invariant over many inputs. Routes to a detail file per strategy. Complements the `tdd` skill, which owns the red-green-refactor unit loop."
---

# Testing strategies

The unit loop covers one behavior per test with the smallest code that passes. This skill covers
the strategies around that loop: how to test a feature end to end, how to pin a service boundary,
how to build the data a test needs, and how to assert an invariant over many inputs.

## Position on the pyramid

The strategies sit on a pyramid, against the boundary between the domain and its adapters:

- **Unit tests** are the base: fast, numerous, run against the domain through its ports.
- **Acceptance tests** are the top: few, slow, broad. They drive the system from outside through
  its inbound port and exercise the real adapters. See `acceptance.md`.
- **Contract tests** sit at the outbound seams, where the system meets another service across a
  port. They pin the interaction without a full end-to-end. See `contract.md`.

Two strategies are techniques used inside tests at every level of the pyramid:

- **Test data** builders and fixtures construct the values a test needs. See `test-data.md`.
- **Property-based testing** generates inputs and asserts an invariant. See `property-based.md`.

## How they compose

The strategies stack. A test data builder constructs the input for a unit test, an acceptance
test, and a property. A property can assert an invariant that a contract relies on. An acceptance
test runs unit cycles on the inside while it stays red on the outside.

## Routing

Read the detail file for the strategy in play:

- `acceptance.md`: outside-in through the inbound port, real adapters, the double loop.
- `contract.md`: consumer-driven contracts at the outbound ports.
- `test-data.md`: builders and factories, deterministic fixtures, anonymized data.
- `property-based.md`: generated inputs, invariants, shrinking to a minimal case.
