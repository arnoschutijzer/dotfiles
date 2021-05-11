all: apps configure

apps:
	./install_brew_deps.sh
	./install_appstore_apps.sh
configure:
	./configure_git.sh
	./configure_mac.sh
	./configure_shell.sh
upgrade:
	brew upgrade --greedy && brew cleanup
	mas upgrade
deps:
	./get_brew_deps.sh
