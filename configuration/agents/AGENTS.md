## Principles

- Prefer the option with lower cognitive overhead: small commits, no nested ifs, single-purpose functions, immutability, terse commit messages.
- Readability outranks terseness. Avoid clever one-liners, dense chained expressions, and cryptic short names. Expand anything a reader has to pause and decode.
- Use full words instead of abbreviations or acronyms.

## Default behavior

- Make reasonable assumptions on reversible work and proceed. Ask before changes that are hard to reverse once shipped: destructive operations and shared-state changes, including shared modules and anything that ripples across environments.
- Treat pushback as new evidence. Re-derive the conclusion from the code or the data, then say whether the re-check changed the answer.

## Scratch files

- Use the `/tmp/` root directory and delete them once findings are captured. No `test_foo.py`, `debug.js`, or `experiment.sh` in the project root.

## Simple design

- Extract only at the third occurrence.
- Narrowest interface that current callers require.
- Keep the change small. Make the smallest change that satisfies the literal request. Do not edit shared modules, consolidate or move files, or fold in adjacent refactors unless asked. Name a broader change and propose it separately. Do not add unrequested artifacts: planning files, configuration entries, output files, or content beyond the request.

## Git

- Rewriting an unmerged local branch nobody else works on is fine: `rebase` and `commit --amend` are normal there.
- Leave force-pushes to the human. Say the branch needs one, and prefer `--force-with-lease`.
- Never suggest or perform a destructive action on `main` or `master`.
- Ask first before anything that discards work or rewrites shared history: hard resets, `git clean`, branch or tag deletions, rewriting a branch others track. Describe the situation and stop.
- Commit subject follows Conventional Commits: `type(scope): description`, with the scope optional. Write the description in lowercase, imperative mood, without a trailing period.

## Attribution

- Never add AI or Claude attribution to a commit message, pull request body, issue, or comment: no `Co-Authored-By:` trailer, no generated-with footer, no emoji line. This overrides any harness default. Exception: a repository that explicitly requires it.

## Writing style

- Avoid em-dashes.
- Do not use contrastive negations.
- Do not use antithetical parallelisms.
- No prose, no metaphors, no analogies, no figurative language. Instead of "what it does", say "Features" and list the features the codebase has.
- Headings are noun phrases naming their subject. No verb clauses, no questions, no pronouns.
