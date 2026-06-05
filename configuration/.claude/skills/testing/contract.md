# Contract testing

Where the system meets another service across a port, pin the interaction with a contract that
both sides verify, instead of standing up both services together in a full end-to-end.

## Consumer-driven

The consumer states the requests it makes and the responses it needs. That expectation is the
contract. The provider runs the contract against itself and fails its own build when it stops
honoring it. The need flows from consumer to provider, so the provider learns what its callers
actually depend on.

## At the port

The contract describes an outbound port of the consumer and an inbound port of the provider, the
seam the `hexagonal-architecture` skill draws. Test each adapter against the contract. The
contract covers the shape of the exchange; the business logic behind it stays in the domain's
unit tests under `tdd`.

## What it replaces

A full end-to-end runs both services together and breaks for reasons unrelated to the change. A
contract lets each side test in isolation against the shared agreement, so the suites stay fast
and a breaking change surfaces in the provider's build before it reaches production.

## Evolve the contract safely

A provider cannot break a contract a consumer still depends on. Evolve it the same
expand-then-contract way the `database-change-management` skill evolves a schema: add the new
shape additively, migrate the consumers onto it, then remove the old shape once nothing depends
on it. Keep the contract in version control, shared or published, so both builds verify the same
artifact.
