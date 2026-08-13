---
name: debug
description: "Find, prove, and fix the root cause of incorrect behavior. Use when a failure, regression, crash, flaky test, or wrong result has an unknown cause. Do not use when the cause and required behavior are already known."
---

# Debug a failure

Restate the reported failure in one sentence.

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
- Check reachability first: search for callers, confirm the feature is still configured, scan recent
  commits. Unreachable code or an abandoned feature makes the change a deletion. If reachability is
  unclear, say so and stop.

## 3. Capture the cause in a failing test

Write one test that reproduces the cause. Confirm it fails for the reason the hypothesis predicts; a
failure for another reason means the test or the hypothesis is wrong.

## 4. Fix and verify

- The reproducing test passes and the full suite passes.
- Check whether the same cause exists elsewhere; name the instances and propose a separate change.
- Report the cause, its evidence, the fix, and the verification result.

## When to stop

- No reproduction after a genuine attempt: gather more evidence (logging, the actual failing input).
- The evidence does not prove a hypothesis.
- The fix requires new behavior outside the reported failure.
