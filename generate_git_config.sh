#!/bin/zsh

prompt_name () {
    echo "Enter your name:"
    read NAME
}

prompt_mail () {
    echo "Enter your $1 e-mail address you want to sign commits with:"
    read EMAIL
}

# The secret key is the one that can sign. A public-only key yields an id here
# that git then fails on at commit time.
signing_key_for () {
    gpg --list-secret-keys --keyid-format=long "$1" 2>/dev/null \
        | awk '/sec/{print $2}' | cut -d'/' -f2
}

for IDENTITY in personal work eno; do
    CONFIG=~/.gitconfig-$IDENTITY

    if [ -f "$CONFIG" ]; then
        echo "$CONFIG exists. Not touching it."
        continue
    fi

    if test -z "$NAME"; then
        prompt_name
    fi
    prompt_mail "$IDENTITY"

    SIGNINGKEY=$(signing_key_for "$EMAIL")

    # .gitconfig sets commit.gpgsign, so an empty signingkey breaks every commit.
    if [ -z "$SIGNINGKEY" ]; then
        echo "No GPG secret key for $EMAIL. Import it and rerun."
        echo "Skipped $CONFIG."
        continue
    fi

    cat > "$CONFIG" << EOF
[user]
        name = $NAME
        email = $EMAIL
        signingkey = $SIGNINGKEY
EOF
    echo "Wrote $CONFIG with signing key $SIGNINGKEY."
done
