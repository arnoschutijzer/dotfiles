.PHONY: all
all: apps configure

## help: print this help message
.PHONY: help
help:
	@echo 'Usage:'
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' |  sed -e 's/^/ /'

## apps: install apps
.PHONY: apps
apps:
	. ./install_brew_deps.sh

## configure: configure git, fonts, shell, tools, mac settings...
.PHONY: configure
configure:
	. ./configure_mac.sh
	. ./generate_git_config.sh
	. ./configure_git.sh
	. ./install_fonts.sh
	. ./configure_shell.sh
	. ./configure_tools.sh

## upgrade: upgrade installed apps
.PHONY: upgrade
upgrade:
	brew upgrade --greedy && brew cleanup
	mas upgrade
	# clear uvx cache so the next Claude Code session pulls the latest Serena from git
	uv cache clean serena

## deps: export apps to a file
.PHONY: deps
deps:
	. ./get_brew_deps.sh

## cleanup: clean up leftover caches
.PHONY: cleanup
cleanup:
	brew cleanup --prune=all
