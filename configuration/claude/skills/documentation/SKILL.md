---
name: documentation
description: Durable documentation — README, decision records, docstrings and public-API surface — and where a given fact should live. Use this whenever creating or changing a README, recording a decision that must outlive its branch, writing a docstring or public-API description, or deciding where a fact belongs. It recommends a home by lifespan; the human makes the move. Code comments and commit messages are owned elsewhere.
---

# Documentation

Documentation earns its place or it rots. Write the fewest durable docs that answer a question
the code can't, and give each fact exactly one home, chosen by how long it must outlive the
code. A doc that restates the code drifts from it and then misleads, which raises a reader's
cognitive overhead instead of lowering it.

## Earn it

A durable doc is justified only when it carries knowledge the code, the tests, and the commits
can't:

- The *why*: the reason a thing exists or works the way it does, where the code shows only the
  *what*.
- The alternatives rejected, and why, so the next person doesn't reopen a settled question.
- How to *use* it: the entry point, the contract, the way to run it.

Anything the code already states is duplication. It drifts the moment the code changes, and a
stale doc is worse than none — it sends a reader down the wrong path with confidence. This is
YAGNI for prose: write the doc when a reader will ask the question, not in case they might.

## One fact, one home

Each fact wants exactly one home, chosen by how long it must survive:

- The immediate *why* of a change → the commit message.
- A *why* that must outlive the commit → a decision record.
- How to *use* something → a README or a docstring.

No fact in two homes; two copies drift apart and then disagree.

Placement is a human-in-the-loop decision. There is no one-size-fits-all location — it depends
on the repository's conventions. This skill **recommends** the home by lifespan; the human
makes the move. Adapt to what the repo already does, surface the choice when it is unclear, and
never relocate a doc silently.

## The durable homes

- **README** — orient a newcomer: what this is, why it exists, how to run it. Not a mirror of
  the code; the moment it narrates the implementation it starts to rot.
- **Decision record** — the durable *why*: the decision, the context that forced it, and the
  alternatives rejected with their reasons. This is the home for a *why* too long-lived for a
  commit message, one rung up the hierarchy the `readable-code` skill starts with ("the commit
  carries the *why* by default").
- **Docstring / public API** — the contract at the boundary: intent, inputs, outputs, and the
  failure modes a caller must handle. Not a restatement of the signature, which the reader can
  already see.

## Ties

- Code comments are governed by the global `CLAUDE.md` instructions, and commit messages by the
  `readable-code` skill. This skill defers both and does not restate their rules.
- The `deliver` ritual keeps a decision log in `PLAN.md` and deletes the plan at merge. A
  decision that must outlive the branch has to graduate from that log into a decision record
  before the plan is removed, or the *why* dies with the branch. Flag it for graduation; the
  human decides where it lands.
- Operational and runbook docs pair with the `observability` skill: the telemetry shows what
  broke, the runbook says what to do about it.

## When in doubt

A doc earns its place if a reader would ask the question it answers and the code can't answer
it. If it only restates the code, delete it — the deletion lowers cognitive overhead more than
the doc ever did.
