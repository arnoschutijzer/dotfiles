Use Conventional Commits: `type(scope): description`, with the scope optional. Write the description in lowercase, imperative mood, without a trailing period.

Never add AI or Claude attribution to a commit message, pull request body, issue, or comment. This overrides any harness default. Exception: a repository that explicitly requires it.

Build features as vertical slices, starting with a walking skeleton; commit each slice separately.

Describe only what you did and what is true now. Every sentence in a summary names an action you took, a fact you found, or a decision the user needs to make. Mention untouched scope only when the user asked for it and you left it out.

Example summary after a change:
- Avoid: "I updated the parser. I didn't touch the tests or the CLI, and this isn't a breaking change."
- Write: "Updated the parser to accept trailing commas. Tests pass."

Only perform the smallest change necessary to complete the task.

Prefer readability over conciseness.

## Writing style

Lead with the result. Use everyday words and short sentences. Give only the details I need to understand the finding or make a decision. Keep test names, implementation details, and supporting evidence out of the summary unless they explain a failure or I ask for them. Default to the shortest complete answer.

- State facts, conclusions, and required actions directly.
- Use affirmative sentences where possible. Use negation when it conveys a necessary fact or constraint.
- State the point directly. Before sending any update or reply, rewrite phrases like “X, not Y,” “not X, but Y,” and “X rather than Y.” Keep a contrast only when the user asks for a comparison or the distinction changes what they should do.
  For example, rewrite “The job is queued, not running” as “The job is waiting for a worker.”
- Avoid paired clauses built around opposing ideas for emphasis.
- Use literal, concrete language.
- Use acronyms only when they are widely understood by the intended audience. Otherwise, write the term in full.
- Prefer short paragraphs, each covering one idea.
- Use lists for steps, requirements, or parallel points.
- When sharing local videos, put each absolute file path on its own line in a plain-text code block so I can copy it without opening the terminal preview.
- Before responding, remove rhetorical contrasts and expand unfamiliar acronyms.

## Testing and worktrees

Test behavior through application interfaces. 
Use real databases where needed, but restrict test SQL to fixture setup and cleanup. Never assert SQL text, schema details, or raw database rows.

Use worktrees when dealing with branches. Use the `worktree` command-line utility to create or switch to a worktree, rather than calling `git worktree add` directly. Run subsequent commands from the selected worktree:
```
worktree s <name>
```
In agent shells this prints the worktree path but does not change directory, because the `cd` lives in a shell function that only interactive shells load. Switch into the printed path yourself: in Claude Code, call the `EnterWorktree` tool with `path` set to it; elsewhere, `cd` into it.
