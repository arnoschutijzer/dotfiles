#!/bin/zsh

prompt_name () {
    echo "Enter your name:"
    read NAME
}
prompt_mail () {
    echo "Enter your $1 e-mail address you want to sign commits with:"
    read EMAIL
}
prompt_gpg () {
    SIGNINGKEY=$(gpg --list-sigs "$EMAIL" | awk '/sig/ && NR > 1 {print $2}' | tail -n +2 | tr -d '\n')
}

PERSONAL_CONFIG=~/.gitconfig-personal

if [ -f "$PERSONAL_CONFIG" ]; then
    echo "$PERSONAL_CONFIG exists. Not touching it."
else
    echo "$PERSONAL_CONFIG does not exist."
    prompt_name
    prompt_mail "personal"
    prompt_gpg
    cat > $PERSONAL_CONFIG << EOF
[user]
        name = $NAME
        email = $EMAIL
        signingkey = $SIGNINGKEY
EOF
fi

WORK_CONFIG=~/.gitconfig-work

if [ -f "$WORK_CONFIG" ]; then
    echo "$WORK_CONFIG exists. Not touching it."
else
    echo "$WORK_CONFIG does not exist."
    if test -z "$NAME"; then
        prompt_name
    fi
    prompt_mail "work"
    prompt_gpg
    cat > $WORK_CONFIG << EOF
[user]
        name = $NAME
        email = $EMAIL
        signingkey = $SIGNINGKEY
EOF
fi
