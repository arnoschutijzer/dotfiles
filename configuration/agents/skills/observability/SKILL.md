---
name: observability
description: Observability and operability: the three pillars (metrics, traces, logs), what to instrument, correlation across boundaries, symptom-based alerting, and SLOs. Use this whenever designing or extending a service, adding an endpoint or integration, deciding what to measure or trace, setting up alerting, dashboards, or health checks, or diagnosing a production incident, in any language. Apply on any change that runs in production, since this is how you measure change-failure-rate and time-to-restore.
---

# Observability

Production telemetry is the measurement layer for the two DORA stability signals:
change-failure-rate and time-to-restore. Instrument so that, during an incident, production
answers "what broke, and why" within minutes. This is the post-deploy half of trust but
verify: the verification gate confirms a change before merge, and telemetry confirms it holds
in production.

## Three pillars, three jobs

- **Metrics** tell you something is wrong: cheap, aggregate, and the right input for alerts.
- **Traces** tell you where it is wrong: the path of one request across service boundaries.
- **Logs** tell you why: the detail at a single point. The `readable-code` skill covers how
  log lines read and what to keep out of them.

Use each pillar for its own job, so one stays cheap to alert on and another stays rich to read.

## What to instrument

- Capture the four golden signals at every service edge: latency, traffic, errors, saturation.
- For a request handler, that reduces to rate, errors, and duration. For a resource (a pool,
  a queue, a disk), watch utilization, saturation, and errors.
- Emit telemetry from the adapters and keep the domain clean, the same edge the
  `hexagonal-architecture` skill draws. The domain returns values; the shell records them.
- On an error, capture enough context to reproduce it: the correlation id and the inputs that
  matter, with secrets and personal data excluded.

## Correlate across boundaries

Propagate a correlation or trace id through every hop: inbound request, outbound call, queue
message. With it, the metric, the trace, and the logs for one request line up into a single
story. This is the highest-leverage move for time-to-restore.

## Alert on symptoms

- Alert on what the user feels: a golden signal crossing a threshold, or an SLO burning.
  Symptom alerts stay few and stay actionable.
- Send cause-level detail to dashboards a human reads during diagnosis, so the alert says
  "users are seeing errors" and the dashboard says which dependency caused it.
- Map alert severity to the log levels in `readable-code`: page on error-grade symptoms and
  leave the rest for review.

## SLOs and error budgets

- Define healthy as a measurable objective: a target on latency or success rate over a window.
- The error budget is the production-side dial for the autonomy you set elsewhere. While the
  budget is healthy, keep shipping; once it burns, slow down and stabilize first.

## When in doubt

A change is observable when, during an incident, you can detect it from a symptom alert,
locate it with a trace, and explain it from structured logs, with no new instrumentation
added mid-incident. If any step would force you to add telemetry under fire, add it now.
