#!/bin/bash

gpg --full-generate-key

echo "keys"
echo "$(gpg --list-secret-keys --keyid-format LONG | awk '/sec/{print $2}' | cut -d'/' -f 2 | xargs -L1 gpg --armor --export)"

echo "use agpg to configure the correct keys per repository"
