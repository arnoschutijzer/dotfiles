.PHONY: all
all: apps configure

.PHONY: apps
apps:
	source ./install_brew_deps.sh
	source ./install_appstore_apps.sh

.PHONY: configure
configure:
	source ./configure_git.sh
	source ./configure_mac.sh
	source ./configure_shell.sh

.PHONY: upgrade
upgrade:
	brew upgrade --greedy && brew cleanup
	mas upgrade

.PHONY: deps
deps:
	source ./get_brew_deps.sh
