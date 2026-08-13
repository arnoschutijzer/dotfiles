---
name: tdd
description: "Develop a production behavior change with a red, green, refactor cycle, one observable behavior per test, and the smallest passing implementation. Use when adding or changing production behavior or implementing a defect fix after its cause is known. Do not use for bug diagnosis, documentation, formatting, comments, renames, or configuration-only changes."
---

# Test-driven development

Write a failing test before production code.

## The cycle

1. **Red**: write one test for one behavior. Run it. Confirm it fails for the reason you expect. If
   it fails for another reason, fix the test first.
2. **Green**: write the smallest code that makes the test pass.
3. **Refactor**: with the suite passing, improve names, remove duplication, clarify structure. Hold
   behavior fixed.

Repeat one behavior per cycle.

## Writing tests

- One behavior per test. The test name states the behavior.
- Assert an observable outcome, not an implementation detail.
- Delete a test that still passes when your production code is deleted. It exercises the framework.
- Inject the clock, the calendar, randomness, and the locale.

## Minimal implementation

- Build what the current test requires. Add generality when a later test demands it.
- When the smallest correct change is a design change, propose it before widening the diff.

## When to stop

- Stop, report, and correct the design when the suite will not pass after a genuine attempt.
- Stop and ask when the smallest correct step is unclear and every option adds speculative scope.
- Never weaken or delete a test to make the suite pass, including an architecture test.
