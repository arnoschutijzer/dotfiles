# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A macOS dotfiles repository that manages system configuration, applications, development tools, and shell environment through Homebrew and shell scripts. All dotfiles are **symlinked** (not copied) from `configuration/` to their target locations.

## Commands

```bash
make              # Full setup: installs apps + configures everything
make apps         # Install all Homebrew packages, casks, MAS apps, VSCode extensions
make configure    # Run all configuration scripts (mac defaults, git, shell, fonts, tools, mise)
make upgrade      # brew upgrade --greedy && brew cleanup; mas upgrade
make deps         # Export current brew state to configuration/Brewfile
make cleanup      # brew cleanup --prune=all
```

## Architecture

### Orchestration

`Makefile` is the entry point. `make all` runs two phases in order:

1. **`apps`** — runs `install_brew_deps.sh`, which does `brew bundle` from `configuration/Brewfile` and adds login items (Ghostty, Raycast, Slack)
2. **`configure`** — runs these scripts in sequence:
   - `configure_mac.sh` — macOS system defaults (Finder, Dock, keyboard)
   - `generate_git_config.sh` — interactive prompt to create `~/.gitconfig-personal` and `~/.gitconfig-work`
   - `configure_git.sh` — symlinks `.gitconfig` and `.gitignore_global`, inits Git LFS
   - `install_fonts.sh` — downloads Zed Mono and Geist Mono Nerd Font
   - `configure_shell.sh` — installs oh-my-zsh, symlinks `.zshrc`, `.zprofile`, `.vimrc`, `starship.toml`, ghostty config
   - `configure_tools.sh` — symlinks `.tflint.hcl`, creates `.terraformrc`, symlinks zed settings, configures Claude Code MCP servers
   - `configure_mise.sh` — configures mise settings and installs global tool versions (node, java, maven, terraform)

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
- Homebrew is the single source of truth for all installable system dependencies. Runtime versions (Node, Java, Go, Terraform) are managed by mise.
