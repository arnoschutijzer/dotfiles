# dotfiles

:information_desk_person:

```bash
# install everything
$ make
```

## manual steps

1. Install Visual Studio Code command into PATH
2. Import Raycast settings

## .gitconfig-personal & .gitconfig-work

```
[user]
# Please adapt and uncomment the following lines:
	name = Arno Schutijzer
	email = e@mail.com
	signingkey = <signingkey>
```

Find the signing key by running:

```bash
gpg --list-secret-keys --keyid-format=long
```

See the documentation [here](https://docs.github.com/en/authentication/managing-commit-signature-verification).
