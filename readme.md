# dotfiles

:information_desk_person:

```bash
# install everything
$ make
```

`make` runs three phases in order: `apps` installs Homebrew and everything in
the Brewfile, `bootstrap` pulls the GPG signing keys and the GitHub SSH key out
of Proton Pass, `configure` symlinks the dotfiles. The signing keys must reach
the keyring before `generate_git_config.sh` writes the git identities, which is
why bootstrap sits in the middle.

## on a new machine

`make` stops and prints the command when it needs one of these.

1. `pass-cli login`, before `make`, so bootstrap can read the vault
1. `gh auth login`, for pull requests and repo clones
1. `exec zsh -l` afterwards, to pick up the new shell config

## manual steps

1. Import Raycast settings
1. Install Zed CLI into PATH
1. Turn off all menu bar items in Settings -> Menu Bar -> Allow in the Menu Bar
