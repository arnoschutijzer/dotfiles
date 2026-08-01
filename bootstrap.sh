#!/bin/zsh
# Everything a bare machine needs before the other phases can run: Homebrew,
# the handful of tools that carry credentials, and the credentials themselves.
# The full Brewfile is deliberately not installed here, so a key import does not
# wait on casks and App Store downloads.

brew_missing () {
    ! /opt/homebrew/bin/brew --version > /dev/null 2>&1
}

xcode_license_unaccepted () {
    xcodebuild -version 2>&1 | grep -qi license
}

# 1. Sudo, once and up front. The Homebrew installer and the license accept both
# want it, minutes apart, and the default five minute timestamp expires inside a
# long install. Asking here beats a prompt surfacing halfway through a phase.
if brew_missing || xcode_license_unaccepted; then
    echo "Installing Homebrew and accepting the Xcode license both need sudo."
    if ! sudo -v; then
        echo "sudo declined. Nothing else in this phase can run."
        exit 1
    fi
fi

# 2. Homebrew. Its installer also pulls in the Xcode Command Line Tools.
# Test the binary, not PATH. Make runs this before the shell config is linked,
# so an installed brew is not yet on PATH and command -v would reinstall it.
if brew_missing; then
    echo "Installing Homebrew."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

eval "$(/opt/homebrew/bin/brew shellenv)"

# 3. Xcode. The command line tools carry git and the compilers the formulae build
# against. They refuse to run until the license is accepted, which blocks git
# itself, so this has to clear before anything else in the phase.
if ! xcode-select -p > /dev/null 2>&1; then
    echo "Installing the Xcode Command Line Tools. Finish the installer, then rerun make."
    xcode-select --install
    exit 1
fi

# Matching on the message keeps sudo out of the way on a machine that has only
# the command line tools, where xcodebuild is absent for an unrelated reason.
if xcode_license_unaccepted; then
    sudo xcodebuild -license accept
fi

# 4. The tools this script itself needs. gnupg holds the signing keys, pass-cli
# reads them out of the vault, gh authenticates the clones. The Brewfile installs
# these too, so `make apps` later is a no-op for them.
brew install --quiet gnupg gh proton-pass-cli

PASS_VAULT=Personal
SSH_KEY="$HOME/.ssh/github_rsa"

missing_ssh_key () {
    [ ! -f "$SSH_KEY" ]
}

missing_gpg_keys () {
    ! gpg --list-secret-keys --with-colons 2>/dev/null | grep -q '^sec:'
}

# 5. Vault session. Only demanded when something is actually absent, so a
# configured machine reruns make without logging in again.
if missing_ssh_key || missing_gpg_keys; then
    if ! pass-cli info > /dev/null 2>&1; then
        echo "Proton Pass holds the signing and SSH keys. Run: pass-cli login"
        exit 1
    fi
fi

# 6. GPG signing keys, one vault item per identity, discovered by title so no
# addresses live in this repo. generate_git_config.sh reads them in configure.
pass-cli item list --vault-name "$PASS_VAULT" 2>/dev/null \
    | sed -n 's/^- \[[^]]*\]: \(.*\) (state=Active)$/\1/p' \
    | grep ' GPG key$' \
    | while read -r ITEM; do
        EMAIL="${ITEM% GPG key}"

        if gpg --list-secret-keys "$EMAIL" > /dev/null 2>&1; then
            echo "GPG secret key for $EMAIL already present."
            continue
        fi

        echo "Importing GPG key for $EMAIL from Proton Pass."
        pass-cli item view --vault-name "$PASS_VAULT" --item-title "$ITEM" \
            --field "private key" 2>/dev/null | gpg --quiet --import

        # A stub export carries the public halves only and cannot sign.
        if gpg --list-secret-keys --keyid-format=long "$EMAIL" 2>/dev/null | grep -q '^sec#'; then
            echo "  WARNING: $EMAIL imported without secret material. Commits for this identity will not sign."
        fi
    done

# 7. SSH key. .gitconfig rewrites https github remotes to ssh, so clones need it.
if [ -f "$SSH_KEY" ]; then
    chmod 600 "$SSH_KEY"
    echo "$SSH_KEY exists. Not touching it."
else
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
    (umask 077 && pass-cli item view --vault-name "$PASS_VAULT" --item-title "github ssh" \
        --field note 2>/dev/null > "$SSH_KEY")
    echo "Wrote $SSH_KEY from Proton Pass."
fi

# 8. gh drives clones and pull requests. Nothing below depends on it, so warn only.
if gh auth status > /dev/null 2>&1; then
    echo "GitHub CLI already authenticated."
else
    echo "GitHub CLI not authenticated. Run: gh auth login"
fi
