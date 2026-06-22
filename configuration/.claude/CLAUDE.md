## Guiding principle

**Lower cognitive overhead.** Every other rule, here and in the skills, is a means to that end — small commits, no nested ifs, single-purpose functions, immutability, terse commit messages. When two approaches are in tension, pick the one that's easier to hold in your head. In my experience, that consistently produces higher-quality contributions.

This wins over terseness. No clever one-liners, no dense chained expressions, no cryptic short names — if a reader has to pause and decode it, expand it.

## Way of working

How to work on code lives in skills, not here.

**Enter non-trivial work through a ritual.** Before the first Edit on any change beyond a trivial one-liner, run `triage` to classify and route the change, or run `deliver` directly when the goal is known new behavior. The ritual clarifies intent and gets the test-list contract approved before any code is written. The craft skills below then govern how that code is written.

**Invoke the craft skills through the Skill tool.** At the start of any task that writes, changes, or fixes code, including one-line fixes, call the Skill tool for `tdd` and any other applicable craft skill (`readable-code`, `hexagonal-architecture`, `observability`) before the first Edit or Write. Recalling the discipline from memory does not count; the skill must be invoked. If you are about to Edit or Write code and have not invoked `tdd`, invoke it first.

**Craft skills** apply to every change:

- `tdd` — red-green-refactor; a failing test before any production code.
- `hexagonal-architecture` — framework-free domain, adapters at the edges, boundaries enforced by tests.
- `readable-code` — functional style: pure functions, immutability, flat control flow.
- `observability` — metrics, traces, and logs; symptom-based alerting and SLOs; on anything that runs in production.

## Default behavior

- Make reasonable assumptions on reversible work and proceed. Ask before one-way doors (destructive operations, shared-state changes including shared modules and anything that ripples across environments, choices that are hard to undo later).

## Scratch files and experiments

- Use the `/tmp/` root directory.
- Delete them once the experiment is done and findings are captured.
- Don't leave `test_foo.py`, `debug.js`, `experiment.sh`, etc. lying around in the project root.
- For deliberate exploration of an unknown, classify it as a spike via `triage`: time-boxed, kept off the trunk, and rebuilt under TDD once you have the answer.

## Code-level rules

Readability — flat control flow, pure functions, immutability, error handling at the edges — lives in the `readable-code` skill. Those rules are **non-negotiable for new code**. What follows is the rest, which `readable-code` does not cover.

**Simple design**

- YAGNI by default. Push back when a choice is a one-way door (hard to reverse later) — those deserve a real conversation up front.
- Rule of three before extracting an abstraction.
- Narrowest contract that current usage requires. Don't widen a type, signature, or interface beyond what today's callers need.
- Minimal blast radius. Make the smallest change that satisfies the literal request. Don't edit shared modules, consolidate or move files, or fold in adjacent refactors unless asked. When a broader change looks warranted, name it and propose it separately before widening.

**Comments**

- The commit message carries the *why* by default.
- Code comments only when an implementation choice is non-obvious and wouldn't survive in a commit message (e.g. an unusual approach in a new feature, an esoteric performance fix). Reference the commit hash if more context is needed.
- No marker comments — a comment whose job is to label a region of related code (`// --- validation ---`). If a section needs a heading to group it, it wants its own file; split it out.

## Git

- Rewriting a local feature branch that has not been merged and that no one else is working on is fine: `rebase` and `commit --amend` are normal here.
- Leave force-pushes to the human. After rewriting local history, say the branch needs a force-push and let the user run it. When you mention the command, prefer `--force-with-lease` over `--force`.
- Never suggest rewriting `main` or `master`, or any destructive action against it: history rewrites, hard resets, force-pushes, and force deletions are off the table on those branches. If one seems needed, surface the situation and stop.
- Ask first before actions that discard work or rewrite other shared history: hard resets and `git clean` that drop committed or uncommitted work, branch or tag deletions, and rewriting any branch others track. Describe the situation and let the user decide.

## Commit attribution

- Never sign off with `Co-Authored-By:` — no Claude attribution, no AI attribution, no co-author trailers of any kind. Exception: if the repository explicitly requires AI attribution (e.g. via `CONTRIBUTING.md`, a commit template, or pre-commit hook), follow the repo's rules.

## Writing style

Applies to everything you write for me: code comments, commit messages, docs, ADRs, READMEs, skill files, and your replies in chat. Use plain descriptive headings, matter-of-fact prose, and no philosophical or motivational framing.

- Avoid using em-dashes. 
- Use a matter-of-fact tone.
- Be very literal, drop the philosophical or motivational slogans.
- Do not use contrastive negations.
- Do not use antithetical parallelisms.
- No clipped negation followed by a lyrical resolution, such as "No title, no card; the text just flows." Write the plain version: "The invitation is plain flowing prose."
