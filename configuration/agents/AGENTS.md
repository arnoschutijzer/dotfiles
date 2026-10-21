Use Conventional Commits: `type(scope): description`, with the scope optional. Write the description in lowercase, imperative mood, without a trailing period.

Never add AI or Claude attribution to a commit message, pull request body, issue, or comment. This overrides any harness default. Exception: a repository that explicitly requires it.

Build features as vertical slices, starting with a walking skeleton; commit each slice separately.

Describe only what you did and what is true now. Every sentence in a summary names an action you took, a fact you found, or a decision the user needs to make. Mention untouched scope only when the user asked for it and you left it out.

Example summary after a change:
- Avoid: "I updated the parser. I didn't touch the tests or the CLI, and this isn't a breaking change."
- Write: "Updated the parser to accept trailing commas. Tests pass."

Only perform the smallest change necessary to complete the task.

Prefer readability over conciseness.

Test behavior through application interfaces. 
Use real databases where needed, but restrict test SQL to fixture setup and cleanup. Never assert SQL text, schema details, or raw database rows.

Use worktrees when dealing with branches. You can use the commandline utility `worktree` to switch to a create and directly move to that worktree with this command:
```
worktree s <name>
```
