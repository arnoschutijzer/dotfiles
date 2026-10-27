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

## rex beta

Download the macOS beta from the [Rex tester portal](https://www.superlogical.com/rex/docs/installation).
The CLI is available inside Rex terminals.

`make configure` runs `./configure_rex.sh`. To configure only Rex, run that
script directly. It symlinks `configuration/rex/` to
`${XDG_CONFIG_HOME:-$HOME/.config}/rex`, preserving any existing file,
directory, or different symlink. If it skips your existing configuration,
merge your settings into the tracked files and move the old path aside before
rerunning. Run the script from a checkout you intend to keep: the symlink
points to that checkout.

`configuration/rex/init.lua` binds Cmd+D to split the focused pane to the right.
After editing it, validate and apply it from a local Rex terminal:

```sh
rex config check
rex config reload
```

Rex requires an explicit reload. If the server uses `REX_CONFIG`, it reads that
file instead of the default path managed by this script. See the
[configuration documentation](https://www.superlogical.com/rex/docs/customize/config).

Apply the font-size preset (two steps above default) from a focused Rex terminal:

```sh
rex do "${XDG_CONFIG_HOME:-$HOME/.config}/rex/appearance.lua"
```

The preset resets the font size before increasing it twice, so repeated runs
keep the same size. Run it explicitly; reloading `init.lua` does not apply it.

From a Rex terminal in your project directory, open a Development tab containing
two side-by-side shells in that directory:

```sh
rex do "${XDG_CONFIG_HOME:-$HOME/.config}/rex/workspaces/development.lua" cwd="$PWD"
```

Each invocation creates a new tab in the current session. For another session,
pass `-s SESSION` to `rex do`; `cwd` must be an absolute path on that session's
server. See the [Lua scripting documentation](https://www.superlogical.com/rex/docs/automate/lua-scripts).
