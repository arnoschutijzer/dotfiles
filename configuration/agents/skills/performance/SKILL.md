---
name: performance
description: "Performance testing: whether the system meets its performance objectives under realistic load. Covers the kinds of test (load, stress, soak, spike), what to measure (latency percentiles, throughput, saturation, error rate), the tie to service-level objectives, and code-level micro-benchmarks. Use this when checking whether a change holds up under load, sizing capacity, choosing which performance signal to measure, or benchmarking a hot path. For gating a measurement as a regression test, see the `testing` skill's performance.md."
---

# Performance testing

Performance testing measures whether the system meets its performance objectives under realistic
conditions: the latency a caller sees, the throughput it sustains, and how it behaves as load
rises. It sits off the unit pyramid. It exercises the whole running system under load, so it runs
against a deployed system, slow and broad, on its own schedule.

## Kinds of test

Each kind puts the system under a different load shape and answers a different question:

- **Load**: the expected peak load, held steady. Does the system meet its objectives under the
  traffic it is built for?
- **Stress**: load pushed past the expected peak until something gives. Where is the limit, and
  how does the system behave when it reaches it?
- **Soak (endurance)**: a moderate load held for hours or days. Does a slow leak or drift appear
  that a short run hides, such as growing memory or a filling connection pool?
- **Spike**: a sudden jump from low to high load. Does the system absorb the surge and recover
  afterward?

## What to measure

Measure the signal a caller feels, at the edge where they enter:

- **Latency** as percentiles. Report p50, p95, and p99. An average hides the tail, and the tail is
  what a fraction of users experience on every request.
- **Throughput**: requests or operations completed per unit of time at a given load.
- **Saturation**: how full the constrained resource is (the pool, the queue, the CPU, the disk),
  which predicts where the next limit will fall.
- **Error rate under load**: the share of requests that fail as load rises. A system that stays
  fast by shedding requests is still failing its objective.

These are the golden signals under deliberate load. The `observability` skill covers capturing
them in production; a performance test drives them on demand before a change ships.

## Tie to service-level objectives

A performance objective is meaningful once it is stated as a target: a latency percentile or a
success rate over a window. That target is a service-level objective, defined in the
`observability` skill. A performance test validates the objective before production, so a
regression surfaces in a test run before the error budget burns down. State the objective first,
then measure against it.

## Micro-benchmarks

A micro-benchmark measures one function or one hot path in isolation. It answers a narrower
question than a load test: is this specific piece of code fast enough, and did a change make it
slower?

Micro-benchmarks are easy to get wrong. Guard against the common faults:

- **Warm-up**: a runtime with a JIT or a cold cache is slow on its first iterations. Discard the
  warm-up and measure the steady state.
- **Dead-code elimination**: a compiler that sees an unused result can delete the work being
  timed. Consume the result so the work survives optimization.
- **Isolation**: build the input outside the timed region and measure the one operation under
  test, so the number reflects the operation and not its setup.

Pin a micro-benchmark against a baseline, the same way a system-level test is pinned, so a
regression is caught by comparison. The `testing` skill's `performance.md` covers baselines and
gating a comparison in CI.
