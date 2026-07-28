---
name: adr
description: Write an architecture decision record: when a decision warrants one, the four sections, the per-repo location and numbering, and the supersede rule. Use when a delivery or design decision meets the criteria, or when revisiting a past decision.
---

# Architecture decision records

A repository opts in to ADRs by having a `docs/adr/` directory. Where it has none, record every
decision in the pull request body and do not create the directory.

In a repository that has one, offer an ADR only when all three of these hold. When any one is
missing, skip the ADR and record the decision in the pull request body, which is discarded when the
work ships.

- **Hard to reverse.** The cost of changing your mind later is meaningful.
- **Surprising without context.** A future reader will ask why it was done this way.
- **The result of a real trade-off.** There were genuine alternatives and you picked one for
  specific reasons.

## Location

One decision per file, named `NNNN-short-title.md` with a zero-padded sequence number. Commit it
alongside the code that implements the decision and review it in the same pull request. Never delete
an ADR.

## Format

Four sections, kept short, with no status line.

- **Title**: `NNNN. The decision in a few words.`
- **Context**: the constraints that forced a choice.
- **Decision**: what was chosen, stated plainly.
- **Consequences**: the effects on later work, including the options now ruled out.

## Superseding

Do not rewrite a merged ADR, including when a later change reverses it. Write a new ADR that
supersedes it, state that in its Context, and add a pointer under the old ADR's title:

`Superseded by [NNNN](NNNN-short-title.md).`
