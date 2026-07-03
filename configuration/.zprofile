# Login shells run macOS path_helper (via /etc/zprofile) after .zshenv, which
# reorders PATH and pushes Homebrew and mise behind the system paths. Re-source
# the environment here, after path_helper, to restore the intended order.
source ~/.zshenv
