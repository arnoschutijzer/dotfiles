# Property-based testing

Instead of asserting one example, state a property that holds for every valid input, generate many
inputs, and let the framework search for a counterexample.

## Part of the unit loop

A failing property is a failing test: red, green, refactor, like any example test. Reach for it
when a behavior has an invariant that example tests would only sample at a few points.

## Kinds of property

- **Round-trip**: decoding an encoded value returns the original (`decode(encode(x)) == x`).
- **Idempotence**: applying twice equals applying once (`f(f(x)) == f(x)`).
- **Invariant**: a structural fact holds across the operation, such as a sorted list keeping the
  same length and elements as its input.
- **Model-based**: the implementation agrees with a simpler reference implementation on every
  input.

## Generating inputs

Generate inputs through the domain's value types, so every generated value is valid by
construction. The property then exercises the behavior itself, and constructor validation keeps
its own test.

## Shrinking

On failure the framework shrinks the input to the minimal case that still fails. That minimal case
is the bug report. Pin it as an example test once fixed, so the specific regression stays covered
after the property moves on.

## Reproducibility

Seed the generator and record the seed on failure, so a counterexample reproduces on the next run.

## Relation to example tests

Use property-based tests alongside example tests. Examples document the intended cases; properties
cover the inputs between them.
