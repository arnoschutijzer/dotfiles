# AGENTS.md

- Configuration files live in `configuration/` and are symlinked (not copied) to their destinations by the configure scripts.
- Scripts should be non-destructive: check for existing files/configs before overwriting.
- Homebrew is the single source of truth for installable system dependencies. Runtime versions (Node, Java, Go, Terraform) are managed by mise. Prefer Homebrew over mise for tools that don't need version pinning, since `brew upgrade` handles auto-updates.
