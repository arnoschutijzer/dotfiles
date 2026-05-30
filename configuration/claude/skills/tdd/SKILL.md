---
name: tdd
description: Test-driven development discipline: red, green, refactor; one behavior per test; smallest code that passes. Use this whenever writing, changing, or fixing production code in any language, including quick fixes and small changes, to ensure a failing test exists before implementation and the code stays minimal. Apply on every code change, not only on new features.
---

# Test-driven development

Write a failing test before any production code. This holds for every change, including
small fixes.

## The cycle

1. **Red**: write one test for one behavior. Run it. Confirm it fails, and fails for the
   reason you expect. A failure for the wrong reason means the test itself is broken.
2. **Green**: write the smallest code that makes the test pass. Resist solving anything the
   current test does not demand.
3. **Refactor**: with the suite green, improve names, remove duplication, clarify structure.
   Hold behavior fixed here; the green suite is your safety net.

Repeat, one behavior per cycle.

## Writing tests

- One behavior per test. The test name states the behavior.
- Test through the domain's ports, so tests stay free of framework detail and the domain
  stays unit-testable (see the `hexagonal-architecture` skill).
- Assert an observable outcome, leaving implementation detail free to change.

## Minimal by default

- Build what the current test requires. Add generality when a later test demands it (YAGNI).
- Prefer the smallest clear change. Correct the design over patching the surface.
- Make it work, then right, then fast, in that order. Optimize once a test or a measurement
  asks for it.

## When to stop

Some conditions are hard stops. Halt rather than push through:

- Green won't come after a genuine attempt: stop and correct the design, rather than grinding
  on or forcing the bar.
- Never weaken or delete a test to make the bar go green, least of all an architecture or
  boundary test (see the `hexagonal-architecture` skill). The test is the safety net, not the
  obstacle; if green demands gutting it, stop.
- The smallest correct step is unclear and every option adds speculative scope: stop rather
  than guess.

## Done

A change is done when its behavior has a test, the full suite is green, and you have shown
the real verification output.
