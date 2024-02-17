.PHONY: all
all: apps configure

.PHONY: apps
apps:
	. ./install_brew_deps.sh
	. ./install_appstore_apps.sh
	. ./install_go_deps.sh

.PHONY: configure
configure:
	. ./configure_git.sh
	. ./configure_mac.sh
	. ./configure_shell.sh
	. ./install_fonts.sh

.PHONY: upgrade
upgrade:
	brew upgrade --greedy && brew cleanup
	mas upgrade

.PHONY: deps
deps:
	. ./get_brew_deps.sh

.PHONY: cleanup
cleanup:
	brew cleanup --prune=all
