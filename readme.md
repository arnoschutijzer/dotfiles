# dotfiles

:information_desk_person:

```bash
# install everything
$ make
```

`make` runs three phases in order.

1. `bootstrap` installs Homebrew, then `gnupg`, `gh` and `proton-pass-cli`, then
   pulls the GPG signing keys and the GitHub SSH key out of Proton Pass
1. `apps` installs the full Brewfile and the mise runtimes
1. `configure` symlinks the dotfiles and applies the macOS settings

The order is load bearing. Nothing runs without Homebrew, `proton-pass-cli` has
to exist before the keys can be read, and the signing keys have to reach the
keyring before `generate_git_config.sh` writes the git identities. Bootstrap
installs only the three formulae it needs, so importing a key does not wait on
casks and App Store downloads.

## on a new machine

`make` stops and prints the command when it needs one of these.

1. `pass-cli login`, before `make`, so bootstrap can read the vault
1. `gh auth login`, for pull requests and repo clones
1. `exec zsh -l` afterwards, to pick up the new shell config

## manual steps

1. Import Raycast settings
1. Install Zed CLI into PATH
1. Turn off all menu bar items in Settings -> Menu Bar -> Allow in the Menu Bar
1. Pull a local model for oMLX/Hermes on demand, e.g.
   `hf download mlx-community/Qwen3.8-27B-4bit`, then `hermes model` to select
   it. The oMLX provider is registered by `configure_hermes.sh`; the cloud
   provider stays the Hermes default.
