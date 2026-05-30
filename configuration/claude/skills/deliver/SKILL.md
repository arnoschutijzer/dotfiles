---
name: deliver
description: Turn a goal into an ordered test list, get it approved as the contract, then drive the TDD loop one item at a time to done. Use at the start of any non-trivial change.
disable-model-invocation: true
argument-hint: [goal]
---

# Deliver a change

Run this at the start of any non-trivial change. It produces the contract, then drives the
test-driven loop from the `tdd` skill to done.

## 0. Resume check

Look for a plan file on the branch (`PLAN.md` at the repo root). If one exists, this is a
resume, not a fresh start:

1. Read it: the goal, the test list with each item's state, the decision log, the open questions.
2. Run the repository's verification to confirm the real state of the code.
3. Reconcile. If verification matches the plan, continue at the first pending item. If they
   diverge (the plan marks an item done but its test is red, or passing work is unrecorded),
   stop and surface the divergence rather than guessing.

With no plan file, start fresh below.

## 1. Clarify

Interview the user relentlessly about every aspect of the change ($ARGUMENTS) until you reach a
shared understanding. Walk down each branch of the design tree, resolving the dependencies
between decisions one at a time. Ask one question at a time, and give your recommended answer
with each. When a question can be answered by exploring the codebase, explore it.

## 2. Enumerate

With the plan agreed, turn it into an ordered **test list**:

- One line per behavior, phrased as a test name.
- Ordered most-central and simplest first; edge cases, failure paths, and integration last.
- Each item vertical: one input to one output, end to end, so the trunk stays releasable after every cycle.
- Each item asserts one behavior, so the list length is the batch count.

## 3. Approve and persist

Present the list and halt. The approved list is the contract. Hold here until the human approves it.

On approval, write the plan to `PLAN.md` at the repo root and commit it to the branch:

- The goal.
- The ordered test list, each item marked pending or done.
- A decision log: the choices made during Clarify and their reasons. Append-only.
- Open questions: anything that triggered a stop and awaits an answer.

The plan file is how state survives a session boundary. Treat it as part of the work.

## 4. Drive

Work the list top to bottom, one item per cycle. Each cycle follows the `tdd` skill: red,
green, refactor, then run the repository's verification.

After each green cycle, update `PLAN.md`: mark the item done, record any decision or learning,
and commit it alongside the code. Append scope-refining tests to the list and keep going. On a
scope-expanding behavior, stop and bring the proposed items back for approval.

## 5. Hand off

List empty and verification green: hand to CI, the release gate. Remove `PLAN.md` as part of
the merge; trunk is the source of truth once the work ships.
