# Acceptance testing

Drive the system from the outside, through its inbound port, and assert an observable outcome.
Exercise the real adapters (a real database, the real wiring) so the test proves the pieces fit
together.

## The inbound port

Start where a user or a calling system enters: an inbound port such as an HTTP handler, a CLI
command, or a message consumer. Assert the outcome that caller would observe, such as the
response, the persisted record, or the published event. Leave internal state unasserted, so the
implementation stays free to change under a green test.

## Real adapters

Wire the actual outbound adapters: a real database in a container, a real queue. This is what
separates an acceptance test from a unit test, and it catches integration faults a mocked test
cannot see, such as a wrong column mapping or a serialization mismatch.

Stub only what you cannot run locally or cannot make deterministic, such as a third-party payment
gateway or the clock. Stub it at the port, so the substitution stays at the edge.

## The double loop

The outer test guides the inner loop:

1. Write a failing acceptance test for the behavior. It is red because nothing implements it yet.
2. Build the inside in small unit steps: red, green, refactor, one behavior at a time.
3. The acceptance test stays red across several unit cycles. It turns green once the last unit is
   in place.

## How many to write

Acceptance tests are slow and broad. Write one per user-facing behavior, covering the happy path
and the failure paths that matter to a caller. Push edge cases and branch coverage down to fast
unit tests.

## Determinism

Inject the clock, seed randomness, and fix the locale and timezone. Build the inputs with a test
data builder, so the setup reads as the one detail under test.
