---
name: testing
description: "Testing strategies beyond the unit cycle: acceptance tests through real adapters, consumer-driven contract tests, test data builders and deterministic fixtures, and property-based testing. Use when a change needs a feature covered end to end, a service boundary covered, test data built, or an invariant asserted over many inputs."
---

# Testing strategies

## Acceptance tests

- Drive the system from outside through its inbound port (HTTP handler, CLI command, message
  consumer). Assert the outcome the caller observes; leave internal state unasserted.
- Wire the real outbound adapters. Stub at the port only what you cannot run locally or make
  deterministic, such as a payment gateway or the clock.
- Write the acceptance test first, then implement with unit cycles. It stays red until the last
  unit is in place.
- One per user-facing behavior, covering the happy path and the failure paths a caller observes.
  Edge cases belong in unit tests.

## Contract tests

- Cover a cross-service interaction with a contract both sides verify, so neither side has to run
  the other service.
- Consumer-driven: the consumer states the requests it makes and the responses it needs. The
  provider verifies that contract in its own build and fails when it stops honoring it.
- Assert request and response shape at the consumer's outbound port and the provider's inbound
  port. Business logic stays in domain unit tests.
- Change a contract through expand-contract, keeping one artifact in version control that both
  builds verify.

## Test data

- A builder returns a valid value with sensible defaults; override only the field under test. Build
  through the domain's existing value types.
- Build inline at the test by default. Extract a shared builder only at the third occurrence.
- Prefer a recorded response, documented payload, or schema example over an invented value.
- Anonymize anything production-derived before it lands in the repository. No real names, emails,
  or identifiers in fixtures.
- When the behavior reads the clock, randomness, the locale, or the timezone, inject it in the test
  and fix its value. Set up only the data the behavior needs.

## Property-based tests

- Use a property when a behavior has an invariant that example tests would sample at only a few
  points. An example test asserts one input against one expected output; keep both kinds.
- Kinds: round-trip (`decode(encode(x)) == x`), idempotence (`f(f(x)) == f(x)`), a structural
  invariant across the operation, and agreement with a simpler reference implementation.
- Generate through the domain's value types where they exist, otherwise reject invalid values in
  the generator. Keep constructor validation in its own test.
- Act on the minimal failing case shrinking produces. Seed the generator, record the seed on
  failure, and add an example test for that case once fixed.
