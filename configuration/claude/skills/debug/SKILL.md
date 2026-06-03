---
name: debug
description: Drive a bug fix from a reported failure to a proven root cause, capture that cause in a failing test, then fix and verify under TDD. Use when behavior is wrong and the cause is not yet known. Reached from the `change` router for the bug-fix route, or invoked directly.
disable-model-invocation: true
argument-hint: [the failure]
---

# Debug a failure

Run this when behavior is wrong and the cause is not yet known ($ARGUMENTS). It drives
diagnosis to a proven root cause, then the `tdd` loop to a verified fix. The `deliver` ritual
turns a known goal into behavior; this turns an unknown failure into a cause.

## 1. Reproduce

Get a reliable, on-demand reproduction before touching production code. A failing test where
you can drive it from one; a documented manual repro you can re-run otherwise. No repro means
no evidence the bug is understood and no proof it is gone.

## 2. Find the root cause

- Form a hypothesis about the cause and prove it from evidence before editing production code.
  Evidence is logs, traces, a decompiled artifact, a bisect, or a minimal repro narrowed by
  elimination. Production telemetry is the evidence trail (see the `observability` skill).
- Do not blame the environment, the configuration, or a dependency before the evidence points
  there. The first guess that points outward is usually wrong; prove it.
- Separate symptom from cause. A null-guard over an NPE whose real source is a shape mismatch
  hides the symptom and leaves the bug in place.
- When the cause is unclear, fan out a few subagents on competing hypotheses in parallel, then
  commit to the one the evidence supports.

## 3. Capture the cause in a failing test

Write one test that reproduces the underlying cause, not the surface symptom. Run it, confirm
it fails for the reason your hypothesis predicts. A failure for the wrong reason means the
test, or the hypothesis, is wrong. Commit that failing test on its own, so a teammate can
check it out and watch it go red.

## 4. Fix

Smallest correct change that makes the test pass — the green and refactor steps of the `tdd`
skill, written to read per the `readable-code` skill. Fix the cause where it lives. Don't
scatter guards across call sites to suppress the symptom.

## 5. Verify and widen the net

- The reproducing test passes and the full suite stays green.
- Ask whether the same cause exists elsewhere. When the bug was one instance of a class of
  mistake, search for its siblings and pin them too.
- Surface a feature toggle when the fix is risky or hard to reverse, paired with a removal
  trigger.

## When to stop

- No reproduction after a genuine attempt: stop and gather more evidence (more logging, the
  actual failing input) rather than guessing at a fix.
- The cause will not resolve to a proven hypothesis: stop rather than patch a guess.
- The fix grows into real new behavior: route back through `change` to the `deliver` ritual.

## Done

The cause is proven, its reproducing test was committed red then green, the full suite is
green, and the change kept a minimal blast radius.
