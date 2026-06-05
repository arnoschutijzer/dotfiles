# Test data

Construct the values a test needs so the test reads clearly and its intent is obvious. The data a
test sets up is part of what the test communicates.

## Builders and factories

A builder creates a valid value with sensible defaults. The test overrides only the field under
test, so the one detail that matters stands out and the rest stays quiet. Build through the
domain's value types (see `readable-code`), so the data is valid by construction and a test never
asserts against an impossible value.

Keep a shared builder for the common valid case. Build an unusual case inline at the test, so a
reader sees the variation without chasing a helper. Apply the rule of three before extracting a
new shared builder.

## Deterministic fixtures

A test must not depend on ambient state. Inject the clock, seed randomness, and fix the locale and
timezone, the same independence rule the `tdd` skill states. A fixture built today gives the same
result next year, on any machine.

## Anonymized data

Generate synthetic data, or anonymize a production sample before it lands in the repository. Keep
personal data out of fixtures, the same rule `readable-code` and `observability` apply to logs. A
real name, email, or identifier copied from production into a test is a data leak that lives in
version control.

## Keep setup minimal

Set up only the data the behavior needs and let the defaults cover the rest. A test crowded with
irrelevant setup hides the one input that drives the outcome.
