#!/bin/zsh
# Credentials the configure phase depends on. Runs after apps, so brew has
# already provided pass-cli, gpg and gh. Signing keys must exist in the keyring
# before generate_git_config.sh reads them.

eval "$(/opt/homebrew/bin/brew shellenv)"

PASS_VAULT=Personal
SSH_KEY="$HOME/.ssh/github_rsa"

missing_ssh_key () {
    [ ! -f "$SSH_KEY" ]
}

missing_gpg_keys () {
    ! gpg --list-secret-keys --with-colons 2>/dev/null | grep -q '^sec:'
}

# Only demand a vault session when something is actually absent, so a
# configured machine reruns make without logging in again.
if missing_ssh_key || missing_gpg_keys; then
    if ! pass-cli info > /dev/null 2>&1; then
        echo "Proton Pass holds the signing and SSH keys. Run: pass-cli login"
        exit 1
    fi
fi

# GPG signing keys, one vault item per identity, discovered by title so no
# addresses live in this repo.
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

# SSH key. .gitconfig rewrites https github remotes to ssh, so clones need this.
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

# gh drives the repo clones and pull requests but nothing below depends on it.
if gh auth status > /dev/null 2>&1; then
    echo "GitHub CLI already authenticated."
else
    echo "GitHub CLI not authenticated. Run: gh auth login"
fi
