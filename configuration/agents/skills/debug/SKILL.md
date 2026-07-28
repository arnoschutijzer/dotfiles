---
name: debug
description: Drive a bug fix from a reported failure to a proven root cause, capture that cause in a failing test, then fix and verify under TDD. Use when behavior is wrong and the cause is not yet known.
argument-hint: [the failure]
---

# Debug a failure

Restate the failure ($ARGUMENTS) in one sentence. If the goal is already known, run `deliver`
instead.

## 1. Reproduce

Get a reliable, on-demand reproduction before touching production code. Prefer a failing test; use a
documented, re-runnable manual reproduction when no test can drive it. When the failure appears only
in CI, treat the CI run as the evidence: fetch its logs and reproduce its conditions, including
environment, test order, and state left by earlier tests. Prove flakiness from evidence before
accepting it as the cause.

## 2. Find the root cause

- Form a hypothesis and prove it from evidence before editing production code: logs, traces, a
  bisect, a minimal reproduction narrowed by elimination, or production telemetry.
- Blame the environment, the configuration, or a dependency only when the evidence points there.
- Fix the cause, not the symptom. A null check over a null-pointer exception whose real source is a
  shape mismatch leaves the bug in place.
- Check reachability first: grep for callers, confirm the feature is still configured, scan recent
  commits. Unreachable code or an abandoned feature makes the change a deletion. If reachability is
  unclear, say so and stop.
- When logs, a bisect, and a minimal reproduction have not settled the cause, run competing
  hypotheses in parallel across subagents, then take the one the evidence supports.

## 3. Capture the cause in a failing test

Write one test that reproduces the cause. Confirm it fails for the reason the hypothesis predicts; a
failure for another reason means the test or the hypothesis is wrong. Commit that test on its own,
red.

## 4. Fix and verify

- The reproducing test passes and the full suite passes.
- Check whether the same cause exists elsewhere; name the instances and propose a separate change.

## When to stop

- No reproduction after a genuine attempt: gather more evidence (logging, the actual failing input).
- The evidence does not prove a hypothesis.
- The fix grows into new behavior: run `triage`, then `deliver`.
