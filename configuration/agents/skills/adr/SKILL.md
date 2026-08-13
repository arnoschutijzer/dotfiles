---
name: adr
description: "Create or supersede a concise architecture decision record for a hard-to-reverse choice with real alternatives that future readers cannot understand from the code alone. Use when the user asks to document an architecture decision or revisit a decision in a repository that already has docs/adr/."
---

# Architecture decision records

A repository opts in to ADRs by having a `docs/adr/` directory. If the directory is absent, report
that the repository does not use ADRs. Do not create the directory.

Create an ADR only when all three conditions hold. Otherwise, report that no ADR is required.

- **Hard to reverse.** The cost of changing your mind later is meaningful.
- **Surprising without context.** A future reader will ask why it was done this way.
- **The result of a real trade-off.** There were genuine alternatives and you picked one for
  specific reasons.

## Location

Create one decision per file. Name it `NNNN-short-title.md` with the next zero-padded sequence
number. Preserve existing ADRs.

## Format

Four sections, kept short, with no status line.

- **Title**: `NNNN. The decision in a few words.`
- **Context**: the constraints that forced a choice.
- **Decision**: what was chosen, stated plainly.
- **Consequences**: the effects on later work, including the options now ruled out.

## Superseding

Do not rewrite an existing ADR when a later decision reverses it. Write a new ADR that supersedes
it, state that in its Context, and add a pointer under the old ADR's title:

`Superseded by [NNNN](NNNN-short-title.md).`
