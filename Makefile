.PHONY: all
all: bootstrap apps configure
	@echo
	@echo "Done. Reload the shell to pick up the new config: exec zsh -l"

## help: print this help message
.PHONY: help
help:
	@echo 'Usage:'
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' |  sed -e 's/^/ /'

## bootstrap: install homebrew, then the gpg and ssh keys from proton pass
.PHONY: bootstrap
bootstrap:
	. ./bootstrap.sh

## apps: install apps and runtimes
.PHONY: apps
apps:
	. ./install_brew_deps.sh
	. ./configure_mise.sh
	. ./install_go_deps.sh

## configure: configure git, fonts, shell, tools, mac settings...
.PHONY: configure
configure:
	. ./configure_mac.sh
	. ./generate_git_config.sh
	. ./configure_git.sh
	. ./install_fonts.sh
	. ./configure_shell.sh
	. ./configure_tools.sh
	. ./configure_agents.sh

## upgrade: upgrade installed apps
.PHONY: upgrade
upgrade:
	. ./upgrade_apps.sh
	make cleanup

## deps: export apps to a file
.PHONY: deps
deps:
	. ./get_brew_deps.sh

## vm: boot a throwaway macos vm with this working tree in it and open a shell
.PHONY: vm
vm:
	OPEN_SHELL=1 ./tests/makefile-in-vm.zsh

## cleanup: clean up leftover caches
.PHONY: cleanup
cleanup:
	brew cleanup --prune=all
