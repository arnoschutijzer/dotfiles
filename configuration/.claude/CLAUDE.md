## Guiding principle

**Lower cognitive overhead.** Every other rule in this file is a means to that end — small commits, no nested ifs, single-purpose functions, immutability, terse commit messages. When two approaches are in tension, pick the one that's easier to hold in your head. In my experience, that consistently produces higher-quality contributions.

This wins over terseness. No clever one-liners, no dense chained expressions, no cryptic short names — if a reader has to pause and decode it, expand it.

## Default behavior

- Make reasonable assumptions on reversible work and proceed. Ask before one-way doors (destructive operations, shared-state changes, choices that are hard to undo later).

## Scratch files and experiments

When running quick experiments, throwaway scripts, or test files:
- Use the `/tmp/` root directory.
- Delete them once the experiment is done and findings are captured
- Don't leave `test_foo.py`, `debug.js`, `experiment.sh`, etc. lying around in the project root

## Code practices

**Control flow**
- No `else`, no nested `if`. Use early return + fallthrough.
- Symmetric branches that produce a value: ternary or extract a function — don't split into two negated ifs.

**TDD**
- New features: red → green → refactor. No production code without a failing test first.
- Changing existing code: follow Fowler's *Refactoring* — small, behavior-preserving steps.
- Run the test suite after every meaningful change.

**Tests**
- Bias toward unit tests. Integration tests at boundaries; end-to-end sparingly.
- Be critical about DRY in tests. Clarity wins over deduplication every time.
- A reader with zero project context should be able to understand a test without a guide. If they need to chase shared fixtures, helpers, or base classes to follow the flow, the test is too clever.
- Inline values, repeat setup, name things explicitly — duplication in tests is cheaper than indirection.
- Tests are hermetic. No shared state, no order dependence, no clock or env reliance. Flakes are bugs, not retries.
- Test data is local to the test. No reliance on globally-seeded fixtures or shared DB state.

**Simple design**
- YAGNI by default. Push back when a choice is a one-way door (hard to reverse later) — those deserve a real conversation up front.
- Rule of three before extracting an abstraction.

**Breaking changes**
- Expand → migrate → contract. Add the new path alongside the old, migrate callers or data, then remove the old. Never a single big-bang rename.
- Each phase ships independently and keeps the system working.

**State**
- Default to immutability and pure functions wherever the language allows.

**Comments**
- The commit message carries the *why* by default.
- Code comments only when an implementation choice is non-obvious and wouldn't survive in a commit message (e.g. an unusual approach in a new feature, an esoteric performance fix). Reference the commit hash if more context is needed.

## Commits

**Granularity**
- Prefer smaller, functionally-scoped commits — each one a coherent change.
- Avoid squash-merging PRs — preserve granular history.
- Prefer several small backwards-compatible "prep" commits before the feature commit, over one big mixed commit.
- Boy Scout rule applies *only when*: (a) the area is covered by tests, and (b) the cleanup can be committed separately.

**Messages**
- [Conventional Commits](https://www.conventionalcommits.org/) is non-negotiable (`feat:`, `fix:`, `refactor:`, `chore:`, `docs:`, `test:`, etc.).
- Keep messages short and to the point.
- Describe *what* and *why* in the body when the code isn't obvious enough on its own. Skip the body when the subject says it all.
- Never sign off with `Co-Authored-By:` — no Claude attribution, no AI attribution, no co-author trailers of any kind. Exception: if the repository explicitly requires AI attribution (e.g. via `CONTRIBUTING.md`, a commit template, or pre-commit hook), follow the repo's rules.
