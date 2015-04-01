
all:
	@echo "Just install already."
	@echo "If you don’t have pkgmk, you might still be able to hack through"
	@echo " and install most of it."

install: install-zsh

install-zsh:
	 (cd zsh; . ./Pkgfile; build)

.PHONY: all install

