---
name: change
description: Classify a change request and route it to the right verification strategy — refactor, dependency bump, spike, infrastructure, the `deliver` ritual for new behavior, or the `debug` skill for a bug fix. Triage that picks the path before any code; it does not execute. Use at the start of a change when the type or verification approach isn't already obvious.
disable-model-invocation: true
argument-hint: [what you want to change]
---

# Make a change

Classify the change ($ARGUMENTS), state the route, then proceed. The classification picks the
verification strategy before any code is written.

## Classify

Answer two questions:

- Does the change alter observable behavior?
- Does it touch existing code or integrations?

Then check for two cases that sit outside those questions:

- A spike: throwaway exploration to answer a question.
- An infrastructure or config change: Terraform, CI, deploy manifests.

## Route

- **New behavior, isolated.** Run the `deliver` ritual. Fresh tests, TDD.
- **New behavior on existing code.** Run the `deliver` ritual, and verify against the existing
  suite as well. Where the touched code has no tests, write them first. Consider an opt-in
  toggle when the integration is risky or hard to reverse, paired with a named removal
  trigger.
- **A bug fix.** Run the `debug` skill: reproduce, prove the root cause, capture it in a
  failing test, then fix and verify against the existing suite.
- **Behavior preserved (refactor, behavior-keeping migration).** Lean on the existing suite as
  the safety net. Where coverage is thin, add characterization tests that pin current behavior
  first, then change under green.
- **Dependency bump.** Run the full regression suite, isolated in its own commit. A major bump
  that forces code changes routes back to the new-behavior path with its own failing tests.
- **Spike.** Time-box it, keep it off the trunk, and rebuild through this router once you have
  the answer. TDD is suspended here by design.
- **Infrastructure or config.** Verify through plan, dry-run, and a smoke check, since a unit
  suite does not apply.

## Proceed

Execute the routed strategy — `deliver` runs the full TDD contract; the other routes verify as
named above. If the work turns out to be a different kind than classified, re-run this router.
