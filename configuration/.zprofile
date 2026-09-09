# The following lines were added by Docker Desktop to add commands to your PATH.
export PATH="$PATH:/Users/arno/.docker/bin"
# End of Docker Desktop section.

# Login shells run macOS path_helper (via /etc/zprofile) after .zshenv, which
# reorders PATH and pushes Homebrew and mise behind the system paths. path_helper
# keeps those entries but demotes them, so re-prepend the order snapshotted at the
# end of .zshenv (typeset -U drops the demoted duplicates), without re-running the
# brew/mise setup.
typeset -U path PATH
[[ -n "${DOTFILES_PATH:-}" ]] && path=("${(@s.:.)DOTFILES_PATH}" $path)
