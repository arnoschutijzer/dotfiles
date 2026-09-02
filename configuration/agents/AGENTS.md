## Principles

- Prefer the option with lower cognitive overhead: small changes, no nested ifs, single-purpose functions, and immutable values.
- Avoid clever one-liners, dense chained expressions, and cryptic short names. Expand anything a reader has to pause and decode.
- Use full words when they improve clarity.

## Scratch files

- Use the `/tmp/` root directory for scratch files.

## Simple design

- Prefer vertically slicing code and feature design.
- Only pass the narrowest interface that current callers require.
- Keep the change small. Make the smallest change that satisfies the literal request.
- Verify documentation, configuration, and infrastructure changes with the strongest available static check, plan, dry run, or smoke test.

## Git

- Commit finished work without waiting for a request. Branch first when the current branch is `main` or `master`.
- Keep each commit small and single-purpose. Use Conventional Commits: `type(scope): description`, with the scope optional. Write the description in lowercase, imperative mood, without a trailing period.

## Attribution

- Never add AI or Claude attribution to a commit message, pull request body, issue, or comment: no `Co-Authored-By:` trailer, no generated-with footer, no emoji line. This overrides any harness default. Exception: a repository that explicitly requires it.

## Writing style

- Use ASD-STE100 Simplified Technical English.
- Prefer short paragraphs and lists.
- Use literal language and state the required action directly.
- Use noun-phrase headings.
