# Acceptance testing

Drive the system from the outside, through its inbound port, and assert an observable outcome.
Exercise the real adapters (a real database, the real wiring) so the test proves the pieces fit
together.

## Enter through the inbound port

Start where a user or a calling system enters: the inbound port the `hexagonal-architecture`
skill defines, such as an HTTP handler, a CLI command, or a message consumer. Assert the outcome
that caller would observe, such as the response, the persisted record, or the published event.
Leave internal state unasserted, so the implementation stays free to change under a green test.

## Use real adapters

Wire the actual outbound adapters: a real database in a container, a real queue. This is what
separates an acceptance test from a unit test, and it catches the integration faults a mocked
test cannot see, such as a wrong column mapping or a serialization mismatch.

Stub only what you cannot run locally or cannot make deterministic, such as a third-party payment
gateway or the clock. Stub it at the port, the same seam `hexagonal-architecture` draws, so the
substitution stays at the edge.

## The double loop

An acceptance test sets the goal; `tdd` cycles reach it:

1. Write a failing acceptance test for the behavior. It is red because nothing implements it yet.
2. Drive the inside with `tdd`: red, green, refactor on units, one behavior at a time.
3. The acceptance test stays red across several unit cycles. It goes green when the last piece
   lands, which is the signal the feature is whole.

## Keep them few

Acceptance tests are slow and broad, so spend them where they earn it: one per user-facing
behavior, covering the happy path and the failure paths that matter to a caller. Push edge cases
and branch coverage down to fast unit tests under `tdd`.

## Keep them deterministic

Inject the clock, seed randomness, and fix the locale and timezone, the same independence rule
`tdd` states. Build the inputs with the builders from `test-data.md`, so the setup reads as the
one detail under test.
