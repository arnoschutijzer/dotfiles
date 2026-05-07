---
name: starting-a-feature
description: Use at the very start of any new feature, functional change, or significant code addition — before writing tests or production code. Covers building a mental model, finding hooks in existing code, choosing between walking-skeleton or spike, planning as small shippable increments, and handling breaking changes via expand-migrate-contract. Triggers on "implement X", "add Y", "build a feature that...", or any greenfield work in a session.
---

# Starting a feature

The cheapest time to get a feature right is before any code is written. Spend that time on understanding, not typing.

## 1. Build the mental model

Before touching code, answer in your head (or out loud):

- **What is this, in one sentence?** Strip jargon. If you can't say it plainly, you don't understand it yet.
- **Who calls it? What does it call?** Trace the in-edges and out-edges.

Skip this and you'll discover the model halfway through implementation, when changing your mind is expensive.

## 2. Find the hooks

Read the existing code with the feature in mind. You're looking for:

- **Seams** — places where the new behavior plugs in cleanly (existing interfaces, dispatch tables, strategy points).
- **Gaps** — places where a small refactor would create a seam that doesn't exist yet. Do that refactor first, in its own commit, behavior-preserving.
- **Escape hatches** — feature flags, configuration switches, branch points already present.

If there is no clean hook, your first commits create one. The feature itself comes after.

## 3. Choose the path

Two modes, mutually exclusive:

| Situation | Skill to load next |
|---|---|
| You can describe the end-to-end shape — inputs, outputs, the path through the system | `walking-skeleton` |
| You don't know enough yet — unfamiliar API, unclear data shape, performance unknown | `spike-and-stabilize` |

If unsure, you're in spike territory. Pretending to know is more expensive than admitting you don't.

## 4. Plan as small shippable increments

Break the feature into a sequence where:

- Each increment is independently mergeable.
- Each increment leaves the system working — no half-finished state on trunk.
- The first increment is the smallest thing that delivers any value (often the walking skeleton).

If an increment can't ship because the feature is "incomplete", the increment is too big or needs to live behind a flag.

### Optional: write the plan down

For features with more than ~3 increments, the plan is worth writing down rather than holding in your head. Ask the user:

> "This breaks down into N increments — want me to capture them in a plan file before we start?"

If yes, write it to `docs/plans/<feature>.md`. Keep the plan as a flat checklist of increments with a one-line description each. Update it as you go. Delete it when the feature ships — the plan is a working document, not an artifact.

For ≤3 increments, skip the file. Hold the list in conversation.

## 5. Changing existing behavior — expand, migrate, contract

Never a big-bang rename. Three phases, each shipping independently:

1. **Expand** — add the new path alongside the old. Both work.
2. **Migrate** — move callers (or data) from old to new, one at a time.
3. **Contract** — remove the old path once nothing references it.

Each phase is a commit (or several). Trunk is shippable at every step.

## 6. Hand off to TDD

Once you know the shape and the first increment, load the `tdd` skill. No production code without a failing test.

## What this skill is not

- Not a planning document. The mental model lives in your head, not in a file.
- Not a design phase you finish before coding. It's the 5–15 minutes before the first test.

## Done

Before moving on:

- [ ] You can describe the feature in one sentence.
- [ ] You know where it plugs into existing code (or what seam you'll create first).
- [ ] You've chosen walking-skeleton or spike-and-stabilize and can say why.
- [ ] You have a first increment small enough to commit within an hour.
