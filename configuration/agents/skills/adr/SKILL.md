---
name: adr
description: Write an architecture decision record for a decision a future reader will need the reasoning for. Covers the bar for warranting an ADR, the MADR format, the per-repo location, numbering, and the supersede rule. Use when a delivery or design decision clears the bar, or when revisiting a past decision.
---

# Architecture decision records

An ADR captures a decision and the reasoning behind it so a future reader does not have to
reconstruct it. Write one when a decision clears the bar below. Decisions under the bar stay on
the branch's in-flight surface and are discarded when the work ships.

## The bar

Write an ADR when a decision is any of:

- A one-way door: hard to reverse once shipped.
- Cross-cutting structure: a boundary, a stack split, a persistence shape, a dependency choice,
  anything that shapes more than the change in front of you.
- A rejected obvious alternative: the straightforward option was turned down for a reason that
  is not visible in the code.

When a decision is none of these, leave it on the in-flight surface.

## Location

ADRs live in `docs/adr/` in the repository, one per file, named `NNNN-short-title.md` with a
zero-padded sequence number (`0001-...`, `0002-...`). They are committed alongside the code that
implements them, reviewed in the same pull request, and never deleted.

## Format

Keep it short. Four sections:

- **Title**: `NNNN. The decision in a few words.`
- **Context**: the forces at play and the constraints that made this a decision worth recording.
- **Decision**: what was chosen, stated plainly.
- **Consequences**: what becomes easier, what becomes harder, what is now ruled out.

A live ADR carries no status line. Once superseded it gains a pointer directly under the title,
described below.

## Immutable and superseded

An ADR is a historical record. Do not rewrite its decision when circumstances change. Write a
new ADR that supersedes it, and add a pointer line directly under the old ADR's title:

`Superseded by [NNNN](NNNN-short-title.md).`

The new ADR states in its context that it supersedes the old one. The chain of pointers is the
history of how the decision evolved.

## Lifecycle

An ADR is committed in the pull request that introduces the decision. The review weighs the
decision. Merging the PR accepts it, and the file needs no further edit. A later reversal
supersedes the ADR with a new one rather than editing it.
