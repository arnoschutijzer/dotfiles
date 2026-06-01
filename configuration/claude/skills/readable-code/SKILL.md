---
name: readable-code
description: Readability through functional style: pure functions, immutability, flat control flow, observability at the edges, and clear commit messages. Use this on every piece of code you write or change, including new features, bug fixes, and refactors, and whenever choosing a branching style, designing data or value types, deciding where a function belongs, or deciding whether to extract one, or writing a commit message, in any language. Apply during the green and refactor steps of every change.
---

# Readable code

Write code that is easy to read and reason about, on every change: a new feature, a bug fix,
or a refactor. Readable code also lives in the right place: the `hexagonal-architecture` skill
governs where a piece belongs, and these habits govern how it reads once it is there.

## Pure functions

- Prefer pure functions: the output depends only on the input, with no side effect.
- Keep side effects (I/O, persistence, time, randomness) at the edges and keep the core a
  stack of pure transformations. This is the functional core, imperative shell split, and it
  maps onto the domain and adapters in the `hexagonal-architecture` skill.
- A pure function is trivially testable, which is why this reinforces the `tdd` skill: the
  core gets fast tests with no setup.

## Immutability

- Treat values as immutable by default. Build a fresh value when state changes and leave the
  original untouched.
- Immutable values are safe to share and pass around, and they remove a whole class of
  "who changed this?" defects.
- Allow mutation in a small, deliberate, local scope once a measurement justifies it.

## Value types

- Push a constraint into the type so an illegal value cannot be constructed. A non-empty set,
  a positive amount, an id of a fixed shape: wrap it in a small value type whose initializer is
  the only way to build one, and have that initializer reject bad input (throw a named error,
  or return an explicit result; see Error handling).
- The payoff is that validation happens once, at construction, so downstream code receives a
  value it can trust instead of re-checking at every call site.
- Keep the invariant in the domain type, not in a caller or a UI form. A form check holds only
  while that form is the sole way in; the type holds for every caller, including tests and
  later code.

## Flat control flow

- Flatten branching with guard clauses and early returns. Handle the exceptional case first
  and return, so the main path reads top to bottom at one indent level.
- Use short-circuiting for simple either-or logic.
- Extract a helper when a branch carries a named concept worth a name. The name is the payoff.
- Leave a simple if-else as it is. Wrapping a three-line branch in a helper or a strategy adds
  indirection that costs more readability than it returns.

## Error handling

- Model an expected failure as part of the return: an explicit result or error value the
  caller has to handle, so the failure path stays as visible as the success path.
- Reserve exceptions for the truly exceptional, like a broken invariant the caller cannot
  reasonably handle.
- Fail fast. Validate at the boundary with a guard clause and reject bad input before it
  travels deeper.
- Surface an error with the context a reader needs to act on, the operation that failed and
  the inputs that mattered, then let it propagate. A swallowed error hides the failure and
  makes the next bug harder to find.
- Translate failures at the boundary: the domain speaks in its own errors, and adapters turn
  infrastructure failures (network, database, timeout) into those domain terms. The
  `hexagonal-architecture` skill owns where that translation lives.

## Observability at the edges

- A log line is a side effect, so it lives in the imperative shell with the rest of the I/O.
  The pure core returns values, and the shell decides what to record, which keeps the logic
  clear to read.
- Emit structured fields (event, identifiers, outcome) and skip narration that restates the
  next line of code.
- Use levels with intent: error for something a human must act on, down to debug for
  development detail.
- Keep secrets and personal data out of logs.

What to instrument, how to alert, and metrics and traces live in the `observability` skill.

## Commit messages

A commit message is read far more often than it is written, so the same effort-for-the-reader
rule applies.

- Conventional Commits format.
- Keep it short: a terse heading, with any detail in the body. Be critical of what earns a
  place — add a body only for a *why* the heading and the diff can't convey, not to narrate
  the change.

## When in doubt

Readability is the reader's effort. If a reader has to hold state in their head to follow a
function, simplify it: make more of it pure, make its data immutable, or flatten its branches.
