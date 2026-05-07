---
name: adr
description: Use when a non-trivial architectural or technology decision is being made — choosing a library, picking between two viable designs, deviating from a project convention, or any choice that future-you will want to understand the reasoning behind. Always asks the user before creating anything (opt-in). ADRs are long-lived, committed to the project at docs/adr/NNNN-title.md, and capture context, the decision, and its consequences.
---

# Architecture Decision Records

An ADR captures *why* a decision was made, in the moment it was made. The diff shows what changed; the ADR shows what the alternatives were and why they lost.

ADRs are not for every decision. They're for the ones future-you (or a new contributor) will look at and ask "why on earth did they do it this way?"

## When an ADR is worth writing

- Choosing a library or framework where alternatives existed.
- Picking between two viable designs.
- Deviating from an established project convention.
- Any decision that's expensive to reverse later.
- Resolving a real tradeoff (performance vs clarity, consistency vs flexibility, build vs buy).

## When it isn't

- Local code style inside a function.
- Anything obvious from reading the diff.
- Decisions with one viable option (no real choice, no need to record).
- Bug fixes (the commit message is enough).

## Process

### 1. Ask before creating — always

ADRs are opt-in. When a decision fitting the criteria above appears, ask the user:

> "This looks like an architectural decision worth recording — [one-sentence summary]. Want to capture this as an ADR?"

If they say no, drop it. Do not nag and do not ask again for the same decision.

### 2. Find the next number

ADRs are numbered sequentially: `0001-`, `0002-`, etc. Look in `docs/adr/` for the highest existing number and add one. If `docs/adr/` doesn't exist, create it; this is ADR `0001`.

### 3. Write the ADR

Filename: `docs/adr/NNNN-short-kebab-title.md`

Format:

```markdown
# NNNN — Short title

- **Status**: Accepted
- **Date**: YYYY-MM-DD

## Context

What is the situation that demands a decision? What forces are at play (technical, organizational, performance, deadlines, team knowledge)? Two or three short paragraphs.

## Decision

The decision, in one or two sentences. What we're doing.

## Consequences

What becomes easier as a result. What becomes harder. What we'll have to do later because of this. Be honest about the downsides — an ADR with no downsides is hiding something.
```

Status values:

- **Proposed** — under discussion, not yet committed.
- **Accepted** — decided and in effect.
- **Superseded by NNNN** — replaced by a later ADR. Reference the new one.
- **Deprecated** — no longer applies, no replacement.

### 4. ADRs are immutable once accepted

To change a decision, write a new ADR that supersedes the old one. Update the old one's status to `Superseded by NNNN` — that's the only edit allowed after acceptance.

### 5. Commit the ADR with the change

The ADR commit and the implementation commit can be the same commit, or separate. Either works. Don't merge an implementation referencing ADR-NNNN without ADR-NNNN existing.

## Format notes — keep it short

- Three sections is the whole format. Add an "Alternatives considered" subsection only if there were specific named alternatives worth documenting.
- Aim for one screen. If it's longer, you're documenting a design, not a decision.
- Plain language. No jargon you haven't defined.

## Anti-patterns

- ❌ Writing an ADR after the fact "to document what we did". The point is to capture the *reasoning*, which evaporates within days.
- ❌ Editing an accepted ADR. Supersede instead.
- ❌ ADRs for every small decision. They become noise and stop being read.
- ❌ Skipping consequences because they're inconvenient.
- ❌ Creating an ADR without asking the user first.

## Done

- [ ] User confirmed they want the ADR.
- [ ] File created at `docs/adr/NNNN-short-title.md` with the next sequential number.
- [ ] Status, Date, Context, Decision, Consequences all present.
- [ ] Fits on one screen.
