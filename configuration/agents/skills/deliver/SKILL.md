---
name: deliver
description: Learn the functional domain, turn a goal into an ordered test list, get the list approved, then drive the TDD loop one item at a time to done. Use at the start of any non-trivial change.
argument-hint: [goal]
---

# Deliver a change

Do not run `deliver` on a small change: write the failing test, make it pass, commit. Return here
once the change outgrows one.

## 0. Resume check

Look for an open pull request for this branch. With one open, read its goal, test list, decisions,
and open questions, then run the repository's verification command. Continue at the first pending
item when verification matches the list. When they diverge, stop and report the divergence.

## 1. Clarify

- Restate the change ($ARGUMENTS) in at most two sentences and list any term whose meaning drives
  the design.
- Interview the user relentlessly, one question at a time, each with your recommended answer. Wait
  for the answer before asking the next one; several at once is bewildering.
- Walk down the decision tree, settling each dependency before the decision that rests on it.
- Look up every fact yourself, in the code, the filesystem, or the tools. Put every decision to the
  user and wait for it.
- Do not start work until the user confirms you have reached a shared understanding.

## 2. Learn the functional domain

A test list is only as good as your grasp of the domain it describes. Before enumerating:

- Read the code, the documentation, and the existing tests covering this area. Name what already
  exists, so the list adds behavior instead of repeating it.
- Take the domain's vocabulary from the user, use those words in the test names, and sharpen a fuzzy
  or overloaded term into one canonical name: "you said account, do you mean the Customer or the
  User?"
- Check each claim against the code and surface any contradiction: "the code cancels a whole order,
  you said partial cancellation is possible, which is right?"
- Ask for rules, not implementation: what makes an input invalid, what happens at each boundary,
  which combinations cannot occur, what the system does when a rule is broken.
- Invent concrete scenarios that probe the edge of a relationship and force the user to be precise
  about where one concept ends and the next begins.
- Ask for a concrete example of every rule, and for the cases that have gone wrong before. Each
  example becomes an item on the test list.
- Keep drilling until you can state the behavior back in the domain's own words and the user
  confirms it. A rule with no example, or an example no rule explains, is an open question.

Where the repository already has a `CONTEXT.md`, record a resolved term there as you settle it, as a
glossary entry with no implementation detail. Where it does not, do not create one.

## 3. Enumerate

Turn the agreed plan into an ordered test list:

- One line per behavior, phrased as a test name.
- Most-central and simplest first; edge cases, failure paths, and integration last.
- Each item vertical: one input to one output, end to end, asserting one behavior.
- An item with no testable unit (a CI workflow line, a deploy manifest) lists its strongest check: a
  dry run, a plan, a schema validation, one run of the deployed path that proves it responds.

## 4. Approve

Present the list and stop until the user approves it. Write no code before approval. On approval,
create the branch and push it.

## 5. Work the list

Work top to bottom, one item per cycle. Each cycle follows `tdd`: red, green, refactor, then run the
repository's verification command and commit.

After the first green cycle, open the draft pull request with `gh pr create --draft --assignee @me`.
Its body carries four sections and nothing else:

- Goal: one line.
- Test list: a checklist, `- [ ]` pending and `- [x]` done, one line per item.
- Decisions: one line each with its reason, added only, never edited. Omit when there are none.
- Open questions: one line each while open. Delete the entry once answered.

Every body line is a bullet or a checkbox. No background section, no approach summary, no progress
narrative, no closing paragraph.

After each green cycle, tick the item and add a decision line only when a decision was made. Do not
describe the cycle. Append scope-refining tests and keep going. On a scope-expanding behavior, stop
and bring the proposed items back for approval. Flag any decision that meets the `adr` criteria.

## 6. Hand off

With the list empty and the verification command passing, let CI run. Leave the checklist and the
decisions on the pull request; never commit them. Where the repository already has `docs/adr/`,
offer an ADR for each flagged decision (see `adr`).
