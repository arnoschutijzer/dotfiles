# Performance testing

Turn a performance measurement into a repeatable test: record a baseline, run it in a controlled
environment, and fail the build when a change regresses past a threshold. The `performance` skill
covers the kinds of performance test and what to measure. This file covers making one of those
measurements a gate.

## Where it sits

A performance test is slow and broad, so it stays out of the fast unit suite that runs on every
save. A baseline comparison still belongs in a pull request: run it as a gate on the change, so a
regression is caught before merge. Reserve the long-running tests, such as a multi-hour soak or a
full-scale load run, for their own schedule.

## Baseline

A performance number means little on its own. Record a baseline: the measurement of the current
system under a fixed load, kept in version control. Every later run compares against it, so a
regression shows up as a change from a known-good reference. Update the baseline deliberately, in a
reviewed change, once a new level is accepted as the norm.

## A deterministic environment

A comparison is valid only when the run that set the baseline and the run that checks against it
differ in one thing: the code. Pin everything else.

- Run on consistent, dedicated hardware whose neighbors do not move the result.
- Warm up to steady state before measuring, so a cold cache or a JIT does not skew the first
  samples.
- Drive a controlled load profile: the same request mix, rate, and duration each run.
- Seed the data to a fixed size and shape, so the database the test hits is the same every time.

An uncontrolled environment produces numbers that move on their own, and a gate built on them
blocks good changes or passes bad ones.

## Gating in CI

Compare the run against the baseline and fail the build when it regresses past a threshold:

- Compare percentiles, so the tail is gated as well as the median.
- Allow for variance. A performance run has noise, so take several runs and compare a statistic: a
  median of runs, or a bound that accounts for the spread. Set the threshold wider than the noise,
  so a real regression trips the gate and ordinary jitter stays under it.
- Report the number on a pass, so a slow drift toward the threshold is visible before it trips.

For the service-level objectives a gate defends, see the `observability` skill.
