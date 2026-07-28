---
name: readable-code
description: "Readable code through functional style: pure functions, immutability, value types, flat control flow, error handling, comments, and commit messages. Use on every change you write, including one-line fixes, and when choosing a branching style, designing a value type, extracting a function, or writing a commit message, in any language."
---

# Readable code

## Pure functions and immutability

- Prefer pure functions: the output depends only on the input, with no side effect.
- Keep the core a chain of pure transformations. Put I/O, persistence, time, and randomness in the
  adapters at the edges.
- Treat values as immutable by default. Build a fresh value on change. Allow local mutation once a
  measurement justifies it.

## Value types

- Reach for a small value type over a bare primitive when the value carries a constraint or a named
  concept: an `Email`, a positive `Quantity`, a non-empty set.
- Validate in the constructor, once. Callers of the type do not re-check it.

## Flat control flow

- Flatten branching with guard clauses and early returns. Handle the exceptional case first and
  return. Keep the main path at one indent level.
- Use short-circuiting for simple either-or logic.
- Extract a helper when a branch carries a named concept worth a name. Leave a simple if-else alone;
  do not wrap a three-line branch in a helper or a strategy.

## Error handling

- Model an expected failure in the return: an explicit result or error value the caller must handle.
- Reserve exceptions for a broken invariant the caller cannot handle.
- Validate at the boundary with a guard clause and reject bad input.
- Surface an error with the operation that failed and the inputs that mattered, then propagate.
  Never swallow an error.

## Comments

- The commit message carries the *why* by default.
- Write a code comment only when an implementation choice is non-obvious and would not survive in a
  commit message. Reference the commit hash when more context is needed.
- No marker comments (`// --- validation ---`). If a region needs a heading, split it into its own
  file.

## Commit messages

- Conventional Commits format. Terse heading.
- Add a body only for a *why* the heading and the diff cannot convey. Do not restate the diff.
