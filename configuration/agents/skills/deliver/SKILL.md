---
name: deliver
description: Turn a goal into an ordered test list, get it approved as the contract, then drive the TDD loop one item at a time to done. Use at the start of any non-trivial change.
disable-model-invocation: true
argument-hint: [goal]
---

# Deliver a change

Run this at the start of any non-trivial change. It produces the contract, then drives the
test-driven loop from the `tdd` skill to done.

## In-flight surface

The in-flight surface holds the contract while the branch is live: the test list with each
item's state, the decision log, and the open questions. It is the pull request: the test list
is a checklist in the PR body, and the decision log and open questions live in the body or in
comments. A repository may override the surface in its own agent instructions (`AGENTS.md` or
`CLAUDE.md`); the override owns where state and the log live.

Durable decisions, the ones a future reader will need the reasoning for, graduate into ADRs in
`docs/adr/` (see the `adr` skill). They outlive the branch.

Rollout safety is a Clarify question. For new behavior that is risky or hard to reverse,
raise an opt-in toggle as an option and let the user decide; pair it with a named removal
trigger (a usage signal, a date, or a metric threshold). If a toggle lands on the plan, its
on-state and off-state tests belong in the test list, and the toggle and trigger are
recorded on the in-flight surface. Rollback is then a config flip, and the toggle gets stripped under a
follow-up cycle once the trigger fires.

## 0. Resume check

Look for an open pull request for this branch. If one exists, this is a resume:

1. Read it: the goal, the test list with each item's state, the decision log, the open questions.
2. Run the repository's verification to confirm the real state of the code.
3. Reconcile. If verification matches the plan, continue at the first pending item. If they
   diverge (the plan marks an item done but its test is red, or passing work is unrecorded),
   stop and surface the divergence rather than guessing.

With no open pull request yet, start fresh below.

## 1. Clarify

Restate the change ($ARGUMENTS) in your own words first, and call out any term whose meaning
drives the design. A restated interpretation lets the user catch a misread while it is still
cheap to correct. Then interview the user relentlessly about every aspect until you reach a
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

On approval, create the branch for the change and push it. The pull request that holds the
contract is opened after the first green cycle, once a commit exists to open it against (see
step 4). Until then, keep the approved contract ready to write into the PR body:

- The goal.
- The ordered test list, each item marked pending or done.
- A decision log: the choices made during Clarify and their reasons. Append-only.
- Open questions: anything that triggered a stop and awaits an answer.

The pull request is how state survives a session boundary. Treat it as part of the work.

## 4. Drive

Work the list top to bottom, one item per cycle. Each cycle follows the `tdd` skill: red,
green, refactor, then run the repository's verification.

After the first green cycle a commit exists on the branch: open the draft pull request with
`gh pr create --draft --assignee @me` and write the contract into its body (the goal, the test
list as a checklist, the decision log, the open questions).

After each green cycle, update the pull request: mark the item done and record any decision
or learning. Append scope-refining tests to the list and keep going. On a scope-expanding
behavior, stop and bring the proposed items back for approval. Flag any decision that clears the
ADR bar (see the `adr` skill) as you record it.

## 5. Hand off

List empty and verification green:

- Graduate the flagged decisions into `docs/adr/` as ADRs (see the `adr` skill), committed on
  the branch so they merge to trunk.
- Hand to CI, the release gate.
- The pull request's checklist and log stay on the PR; they are never committed, so trunk
  carries only the code and its ADRs once the work ships.
