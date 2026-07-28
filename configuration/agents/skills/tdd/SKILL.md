---
name: tdd
description: "Test-driven development: red, green, refactor; one behavior per test; the smallest code that passes. Use on every code change in any language, including quick fixes, small changes, bug fixes, and new features."
---

# Test-driven development

Write a failing test before any production code, on every change, including small fixes. A change
with no behavior to assert (a comment, a log level, a rename, a formatting pass, a config value)
has no test to write; run the suite and commit.

## The cycle

1. **Red**: write one test for one behavior. Run it. Confirm it fails for the reason you expect. If
   it fails for another reason, fix the test first.
2. **Green**: write the smallest code that makes the test pass.
3. **Refactor**: with the suite passing, improve names, remove duplication, clarify structure. Hold
   behavior fixed.

Repeat, one behavior per cycle. One commit per passing suite.

## Writing tests

- One behavior per test. The test name states the behavior.
- Assert an observable outcome, not an implementation detail.
- Delete a test that still passes when your production code is deleted. It exercises the framework.
- Inject the clock, the calendar, randomness, and the locale.
- Invoke `testing` when the change crosses one of these: a feature end to end, a service boundary,
  shared test data, an invariant over many inputs.

## Minimal implementation

- Build what the current test requires. Add generality when a later test demands it.
- When the smallest correct change is a design change, propose it before widening the diff.

## When to stop

- Stop, report, and correct the design when the suite will not pass after a genuine attempt.
- Stop and ask when the smallest correct step is unclear and every option adds speculative scope.
- Never weaken or delete a test to make the suite pass, including an architecture test.
