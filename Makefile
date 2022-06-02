.PHONY: all
all: apps configure

.PHONY: apps
apps:
	./install_brew_deps.sh
	./install_appstore_apps.sh

.PHONY: configure
configure:
	./configure_git.sh
	./configure_mac.sh
	./configure_shell.sh

.PHONY: upgrade
upgrade:
	brew upgrade --greedy && brew cleanup
	mas upgrade
	omz update

.PHONY: deps
deps:
	./get_brew_deps.sh
