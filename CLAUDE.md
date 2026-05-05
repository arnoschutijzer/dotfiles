# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A macOS dotfiles repository that manages system configuration, applications, development tools, and shell environment through Homebrew and shell scripts. All dotfiles are **symlinked** (not copied) from `configuration/` to their target locations.

## Commands

`make` runs the full setup. `make help` lists the rest of the targets.

## Architecture

### Orchestration

`Makefile` is the entry point. `make all` runs two phases: **`apps`** (install) then **`configure`** (symlink dotfiles, apply system settings). Read the Makefile for what each phase actually runs.

### Brewfile

`configuration/Brewfile` manages all dependencies in one file: taps, brew formulae, casks, MAS apps, and VSCode extensions. When adding dependencies, add them here — not in separate install scripts.

### Git Identity

`.gitconfig` uses `[includeIf]` to load different identities based on directory:
- `~/` → `~/.gitconfig-personal`
- `~/development/skryv/` → `~/.gitconfig-work`

These identity files are generated interactively by `generate_git_config.sh` and are **not** tracked in the repo.

### Shell

Zsh with oh-my-zsh and Starship prompt. Plugins: git, z, ssh-agent. zsh-autosuggestions is sourced directly from Homebrew. PATH additions include `~/bin` and GPG agent setup for commit signing.

### Tool Versions

[mise](https://mise.jdx.dev/) manages runtime versions for Node, Java, Maven, Terraform, and Go. It replaces nvm, jenv, pyenv, goenv, and tenv. Global tool versions and mise settings are configured by `configure_mise.sh`. Python is managed by uv.

## Conventions

- All configuration files live in `configuration/` and are symlinked to their destinations by the configure scripts.
- Scripts are sourced (`. ./script.sh`) from the Makefile, not executed as subprocesses.
- Scripts should be non-destructive: check for existing files/configs before overwriting.
- Homebrew is the single source of truth for all installable system dependencies. Runtime versions (Node, Java, Go, Terraform) are managed by mise. Prefer Homebrew over mise for tools that don't need version pinning, since `brew upgrade` handles auto-updates.
