## Guiding principle

**Lower cognitive overhead.** Every other rule in this file is a means to that end — small commits, no nested ifs, single-purpose functions, immutability, terse commit messages. When two approaches are in tension, pick the one that's easier to hold in your head. In my experience, that consistently produces higher-quality contributions.

This wins over terseness. No clever one-liners, no dense chained expressions, no cryptic short names — if a reader has to pause and decode it, expand it.

## Way of working

How to work on code lives in skills, not here. Load the relevant skill when its trigger fires:

- **`starting-a-feature`** — at the start of any new feature or significant change. Mental model, hooks in existing code, plan as small increments, expand-migrate-contract for breaking changes.
- **`walking-skeleton`** — when the feature's shape is clear. Build the smallest end-to-end slice anchored by an acceptance test.
- **`spike-and-stabilize`** — when the problem is unclear. Throwaway code in `/tmp/`, capture findings, delete the spike, restart under TDD.
- **`tdd`** — for any production code change. Red-green-refactor, one commit per green bar, one behavior per commit.
- **`adr`** — when a non-trivial architectural or technology decision is being made. Always opt-in; the skill asks before creating. ADRs live at `docs/adr/NNNN-title.md`.

## Default behavior

- Make reasonable assumptions on reversible work and proceed. Ask before one-way doors (destructive operations, shared-state changes, choices that are hard to undo later).

## Scratch files and experiments

- Use the `/tmp/` root directory.
- Delete them once the experiment is done and findings are captured.
- Don't leave `test_foo.py`, `debug.js`, `experiment.sh`, etc. lying around in the project root.
- For deliberate exploration of an unknown, use the `spike-and-stabilize` skill rather than ad-hoc experimentation.

## Code-level rules

These are local code decisions. Workflow lives in the skills above.

**Control flow**
- No `else`, no nested `if`. Use early return + fallthrough.
- Symmetric branches that produce a value: ternary or extract a function — don't split into two negated ifs.

**Simple design**
- YAGNI by default. Push back when a choice is a one-way door (hard to reverse later) — those deserve a real conversation up front.
- Rule of three before extracting an abstraction.

**State**
- Default to immutability and pure functions wherever the language allows.

**Comments**
- The commit message carries the *why* by default.
- Code comments only when an implementation choice is non-obvious and wouldn't survive in a commit message (e.g. an unusual approach in a new feature, an esoteric performance fix). Reference the commit hash if more context is needed.

## Commit attribution

- Never sign off with `Co-Authored-By:` — no Claude attribution, no AI attribution, no co-author trailers of any kind. Exception: if the repository explicitly requires AI attribution (e.g. via `CONTRIBUTING.md`, a commit template, or pre-commit hook), follow the repo's rules.
- Conventional Commits format and commit-granularity rules live in the `tdd` skill.
