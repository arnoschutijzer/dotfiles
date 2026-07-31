.PHONY: all
all: apps bootstrap configure
	@echo
	@echo "Done. Reload the shell to pick up the new config: exec zsh -l"

## help: print this help message
.PHONY: help
help:
	@echo 'Usage:'
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' |  sed -e 's/^/ /'

## apps: install apps and runtimes
.PHONY: apps
apps:
	. ./install_brew_deps.sh
	. ./configure_mise.sh
	. ./install_go_deps.sh

## bootstrap: import signing and ssh keys from proton pass, check github auth
.PHONY: bootstrap
bootstrap:
	. ./bootstrap.sh

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
	brew upgrade --greedy --yes && brew cleanup
	sudo mas upgrade
	make cleanup

## deps: export apps to a file
.PHONY: deps
deps:
	. ./get_brew_deps.sh

## cleanup: clean up leftover caches
.PHONY: cleanup
cleanup:
	brew cleanup --prune=all
