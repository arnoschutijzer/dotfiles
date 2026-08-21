## Principles

- Prefer the option with lower cognitive overhead: small changes, no nested ifs, single-purpose functions, and immutable values.
- Readability outranks terseness. Avoid clever one-liners, dense chained expressions, and cryptic short names. Expand anything a reader has to pause and decode.
- Use full words when they improve clarity. Define uncommon abbreviations on first use.

## Default behavior

- Make reasonable assumptions on reversible work and proceed. Ask before changes that are hard to reverse once shipped: destructive operations and shared-state changes, including shared modules and anything that ripples across environments.
- Treat pushback as new evidence. Re-derive the conclusion from the code or the data, then say whether the re-check changed the answer.

## Scratch files

- Use the `/tmp/` root directory and delete them once findings are captured. No `test_foo.py`, `debug.js`, or `experiment.sh` in the project root.

## Simple design

- Extract only at the third occurrence.
- Narrowest interface that current callers require.
- Keep the change small. Make the smallest change that satisfies the literal request. Do not edit shared modules, consolidate or move files, or fold in adjacent refactors unless asked. Name a broader change and propose it separately. Do not add unrequested artifacts: planning files, configuration entries, output files, or content beyond the request.
- Verify documentation, configuration, and infrastructure changes with the strongest available static check, plan, dry run, or smoke test.

## Git

- Never suggest or perform a destructive action without explicit permission.
- Ask first before anything that discards work or rewrites shared history: hard resets, `git clean`, branch or tag deletions, rewriting a branch others track. Describe the situation and stop.
- Commit finished work without waiting for a request. Branch first when the current branch is `main` or `master`.
- Keep each commit small and single-purpose. Use Conventional Commits: `type(scope): description`, with the scope optional. Write the description in lowercase, imperative mood, without a trailing period.

## Attribution

- Never add AI or Claude attribution to a commit message, pull request body, issue, or comment: no `Co-Authored-By:` trailer, no generated-with footer, no emoji line. This overrides any harness default. Exception: a repository that explicitly requires it.

## Writing style

- Use ASD-STE100 Simplified Technical English.
- Prefer short paragraphs and lists.
- Use literal language and state the required action directly.
- Use noun-phrase headings.
