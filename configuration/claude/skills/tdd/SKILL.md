---
name: tdd
description: Use for ALL production code changes — new features, bug fixes, refactoring inside the green-bar safety net. Enforces the red-green-refactor cycle, one commit per green bar, one commit equals one behavior change, refactoring only when green, and conventional commit messages. Non-negotiable for any code that ships.
---

# Test-Driven Development

Every line of production code is written in response to a failing test. No exceptions.

The reason isn't dogma — it's that tests written after the code test what you wrote, not what you wanted. They drift toward implementation, miss edge cases, and provide no design pressure. Test-first inverts that.

## The cycle: red-green-refactor-mutate

### Red — write a failing test

- Describe the behavior you want, not the code that will produce it.
- Run the test. Confirm it fails. Confirm it fails for the **right reason** (the behavior is missing), not the wrong one (typo, missing import).
- A test that passes the first time is suspect — either the behavior already exists or the test doesn't test what you think.

### Green — minimum code to pass

- Write the smallest amount of production code that makes the test pass.
- "Smallest" includes returning a hardcoded value if that's what passes the current test. The next test will force you to generalize.
- Resist adding behavior the tests don't demand. That code has no test, by definition.

### Refactor — only when green

- After green, look at the code (test and production). Is there a structural improvement worth making?
- Refactor in small steps. After each step, run the tests. They must stay green.
- Not every green bar needs a refactor. Most don't. Refactoring without a reason is just churn.
- If a refactor breaks tests, revert. The refactor was wrong, or the tests were too tightly coupled to the old structure.

### Mutate — verify the tests bite

Red-green-refactor proves behavior works *now*. Mutation testing proves the tests will catch regressions *later*.

- Run mutation testing on the changed code. Surviving mutants reveal tests that pass without genuinely exercising the behavior.
- Fix or add tests until the mutants die.
- Cadence: every commit if the runner is fast; otherwise per-feature or before the PR. Don't let it become a once-a-quarter event — the value is catching weak tests while they're fresh.

## Commit discipline

### One commit per green bar

After every green bar, commit. Two reasons:

1. The repository becomes a fine-grained safety net — any failure can be bisected to a single behavior change.
2. It forces small steps. If you can't commit after green, your step was too big.

### One commit equals one behavior change

A commit changes one thing: one new behavior, one bug fix, one refactor. Mixed commits ("added feature X and refactored Y") are nearly impossible to review, revert, or understand later.

If a refactor opportunity appears mid-feature:

- Set the feature work aside.
- Do the refactor as its own commit (refactor on green, tests pass).
- Resume the feature.

### Conventional commits

```
feat: <new behavior>
fix: <bug fix>
refactor: <structural change, no behavior change>
test: <add or change tests, no production change>
docs: <documentation only>
chore: <tooling, dependencies, config>
```

Subject line: imperative mood, lowercase, no period, under ~70 characters. Body explains *why* if the diff doesn't make it obvious. Skip the body when the subject says it all.

## Test design — the short version

A reader with zero project context should follow a test top-to-bottom without chasing helpers, fixtures, or base classes.

- Inline values. Repeat setup. Name things explicitly.
- Duplication in tests is cheaper than indirection.
- Tests are hermetic — no shared state, no order dependence, no clock or env reliance. Flakes are bugs, not retries.
- Test behavior, not implementation. A test that breaks when you rename a private method is testing the wrong thing.

## The pyramid

Most projects converge on a similar shape:

- **Unit tests** — bulk of the suite. Pure functions and small modules. Fast, deterministic, run on every change.
- **Integration tests** — at trust boundaries. Real database, real HTTP server, real file system. Fewer, slower, catch wiring bugs.
- **End-to-end tests** — anchors, not coverage. Typically one per feature (the walking skeleton's acceptance test), kept green as you grow real behavior beneath it.

Each level catches things the level above can't. Unit tests can't catch wiring; E2E can't tell you which unit broke.

## Anti-patterns

- ❌ Writing production code before a failing test exists.
- ❌ Multiple unrelated changes in one commit.
- ❌ Refactoring on a red bar.
- ❌ Tests that pass without the production code (they don't actually test it).
- ❌ Tests coupled to internal structure — spies on private methods, asserting call order of helpers.
- ❌ Skipping the "confirm it fails for the right reason" step.
- ❌ Adding behavior "while you're in there" without a test.

## Done

Before considering a change complete:

- [ ] Every production line traces back to a failing test that demanded it.
- [ ] Each commit changes one behavior.
- [ ] All tests pass.
- [ ] Refactor opportunities have been assessed (and either taken in their own commit or consciously deferred).
- [ ] Mutation testing run on the changed code; no surviving mutants.
- [ ] Commit messages follow conventional commits.
