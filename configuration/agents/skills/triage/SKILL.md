---
name: triage
description: "Classify a change and route it: refactor, dependency bump, spike, infrastructure, `deliver` for new behavior, or `debug` for a bug fix. Use at the start of a change when the type or verification approach is not obvious."
argument-hint: [what you want to change]
---

# Triage a change

Restate the change ($ARGUMENTS) in one sentence, then name the class and the route. Skip `triage` on
a small change. Stop for confirmation when a term whose meaning drives the design is genuinely
ambiguous, or when the change is hard to reverse once shipped.

## Classify

Does the change alter observable behavior? Does it touch existing code or integrations? Then check
two cases outside those questions: a spike (throwaway exploration to answer a question), and an
infrastructure or config change (Terraform, CI, deploy manifests).

## Route

- **New behavior, isolated or on existing code.** Run `deliver`.
- **A bug fix.** Run `debug`.
- **Behavior preserved (refactor, behavior-keeping migration).** Verify against the existing suite.
  Where coverage is thin on the behavior the change can break, add tests that assert the current
  behavior first.
- **Dependency bump.** Full regression suite, in its own commit. A major bump that forces code
  changes routes to the new-behavior path with its own failing tests.
- **Spike.** Time-box it, keep it off the main branch, and rebuild it through `triage` once you have
  the answer. TDD does not apply during a spike.
- **Infrastructure or config.** Verify through plan, dry-run, and one run of the deployed path that
  proves it responds.

If the work turns out to be a different kind than classified, classify again.
