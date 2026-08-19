---
name: deliver
description: "Deliver a non-trivial new behavior by learning the domain, obtaining approval for an ordered test list, and implementing one behavior at a time. Use when a feature or behavior change has multiple testable cases. Do not use for bug diagnosis, refactors, dependency updates, documentation, or configuration-only changes."
disable-model-invocation: true
policy:
  allow_implicit_invocation: false
---

# Deliver a change

## 1. Understand the behavior

- Restate the requested outcome in at most two sentences.
- Read the relevant code, documentation, and tests.
- Use the domain vocabulary already present in the request and codebase.
- Identify business rules, boundaries, failure behavior, and existing behavior.
- Ask one question only when a missing answer changes the result materially. Include a recommended
  answer.

## 2. Create the test list

Create an ordered list with one testable behavior per line:

- Put the central behavior first, then edge cases, failure paths, and integration behavior.
- State each item as a test name with one input and one observable output.

## 3. Obtain approval

Present the list. Wait for approval before changing production code. Treat explicit approval of a
previously presented list as sufficient.

## 4. Implement the list

- Work from top to bottom.
- Apply the `tdd` cycle to each behavior.
- Run the narrow test after each cycle and the repository verification after the list is complete.
- Commit each behavior when its cycle is green. One behavior, one commit.
- Add a refining test when it stays within the approved outcome.
- Stop for approval when a new behavior expands the outcome.
- Report the completed behaviors and verification results.
