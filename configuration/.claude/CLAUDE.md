## Guiding principle

**Lower cognitive overhead.** Every other rule, here and in the skills, is a means to that end — small commits, no nested ifs, single-purpose functions, immutability, terse commit messages. When two approaches are in tension, pick the one that's easier to hold in your head. In my experience, that consistently produces higher-quality contributions.

This wins over terseness. No clever one-liners, no dense chained expressions, no cryptic short names — if a reader has to pause and decode it, expand it.

## Way of working

How to work on code lives in skills, not here.

**Craft skills** apply to every change and load on their own triggers — you don't invoke them:

- `tdd` — red-green-refactor; a failing test before any production code.
- `hexagonal-architecture` — framework-free domain, adapters at the edges, boundaries enforced by tests.
- `readable-code` — functional style: pure functions, immutability, flat control flow.
- `observability` — metrics, traces, and logs; symptom-based alerting and SLOs; on anything that runs in production.

**Rituals** are explicit entrypoints you invoke at the start of a change:

- `change` — triage: classify the change and route it to a verification strategy (refactor, dependency bump, spike, infrastructure, or `deliver`). Start here when the type isn't obvious.
- `deliver` — execute a behaviour change end to end: goal → approved test-list contract → drive the TDD loop → ship. Start here when you know it's a non-trivial behaviour change.

## Default behavior

- Make reasonable assumptions on reversible work and proceed. Ask before one-way doors (destructive operations, shared-state changes, choices that are hard to undo later).

## Scratch files and experiments

- Use the `/tmp/` root directory.
- Delete them once the experiment is done and findings are captured.
- Don't leave `test_foo.py`, `debug.js`, `experiment.sh`, etc. lying around in the project root.
- For deliberate exploration of an unknown, classify it as a spike via `change`: time-boxed, kept off the trunk, and rebuilt under TDD once you have the answer.

## Code-level rules

Readability — flat control flow, pure functions, immutability, error handling at the edges — lives in the `readable-code` skill. Those rules are **non-negotiable for new code**. What follows is the rest, which `readable-code` does not cover.

**Simple design**

- YAGNI by default. Push back when a choice is a one-way door (hard to reverse later) — those deserve a real conversation up front.
- Rule of three before extracting an abstraction.
- Narrowest contract that current usage requires. Don't widen a type, signature, or interface beyond what today's callers need.

**Comments**

- The commit message carries the *why* by default.
- Code comments only when an implementation choice is non-obvious and wouldn't survive in a commit message (e.g. an unusual approach in a new feature, an esoteric performance fix). Reference the commit hash if more context is needed.
- No marker comments — a comment whose job is to label a region of related code (`// --- validation ---`). If a section needs a heading to group it, it wants its own file; split it out.

## Commit attribution

- Never sign off with `Co-Authored-By:` — no Claude attribution, no AI attribution, no co-author trailers of any kind. Exception: if the repository explicitly requires AI attribution (e.g. via `CONTRIBUTING.md`, a commit template, or pre-commit hook), follow the repo's rules.

## Writing style

- Avoid using em-dashes. 
- Use a matter-of-fact tone.
- Be very literal, drop the philosophical or motivational slogans.
- Do not use contrastive negations.
- Do not use antithetical parallelisms.
