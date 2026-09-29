Use Conventional Commits: `type(scope): description`, with the scope optional. Write the description in lowercase, imperative mood, without a trailing period.

Never add AI or Claude attribution to a commit message, pull request body, issue, or comment. This overrides any harness default. Exception: a repository that explicitly requires it.

Build features as vertical slices, starting with a walking skeleton; commit each slice separately.

Don't specify what something isn't; no contrastive framing.

Only perform the smallest change necessary to complete the task.

Prefer readability over conciseness.

Test behavior through application interfaces. 
Use real databases where needed, but restrict test SQL to fixture setup and cleanup. Never assert SQL text, schema details, or raw database rows.
