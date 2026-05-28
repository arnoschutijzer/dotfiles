.PHONY: all
all: base setup

## help: print this help message
.PHONY: help
help:
	@echo 'Usage:'
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' |  sed -e 's/^/ /'

## base: install homebrew + mise (the foundation)
.PHONY: base
base:
	. ./setup_homebrew.sh
	. ./setup_mise.sh

## setup: per-tool install + configure
.PHONY: setup
setup:
	. ./install_go_deps.sh
	. ./configure_tools.sh
	. ./setup_macos.sh
	. ./generate_git_config.sh
	. ./configure_git.sh
	. ./configure_shell.sh
	. ./install_fonts.sh

## apps: DEPRECATED alias for base (removed in the contract step)
.PHONY: apps
apps: base

## configure: DEPRECATED alias for setup (removed in the contract step)
.PHONY: configure
configure: setup

## upgrade: upgrade installed apps
.PHONY: upgrade
upgrade:
	brew upgrade --greedy && brew cleanup
	mas upgrade
	make cleanup

## deps: export apps to a file
.PHONY: deps
deps:
	. ./get_brew_deps.sh

## cleanup: clean up leftover caches
.PHONY: cleanup
cleanup:
	brew cleanup --prune=all
