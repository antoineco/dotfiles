# ---------- Zsh ---------- 

# generate list of Zsh dot files based on contents of zsh/ directory
# e.g. ~/.zshrc ~/.zprofile ...
ZDOTFILES := $(foreach f,$(wildcard zsh/*),~/.$(notdir $(f)))

.PHONY: zim
zim: $(ZDOTFILES) ## Install the Zim Zsh configuration framework
	zsh -ic 'zimfw install'

~/.zim:
	curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh

# Zsh dot files must be installed *after* Zim itself, otherwise the installation
# gets aborted prematurely with the message "Zim already installed".
$(ZDOTFILES): ~/.zim
	ln -sf -- $(abspath $(subst .,zsh/,$(notdir $@))) $@

# -------- LunarVim --------

.PHONY: lvim clean-lvim
lvim: ~/.config/lvim ## Configure the LunarVim text editor

~/.local/share/lunarvim: LV_BRANCH := release-1.3/neovim-0.9
~/.local/share/lunarvim:
	$(eval LV_INSTALL := $(shell mktemp))
	curl -fsSL https://raw.githubusercontent.com/LunarVim/LunarVim/$(LV_BRANCH)/utils/installer/install.sh -o $(LV_INSTALL)
	@chmod -v +x $(LV_INSTALL)
	LV_BRANCH=$(LV_BRANCH) $(LV_INSTALL)
	@rm -vf $(LV_INSTALL)

~/.config:
	@mkdir $@

# The config must be installed *after* LunarVim, otherwise the installation
# script creates a copy of the existing config as a backup, and replaces it
# with its defaults.
~/.config/lvim: ~/.local/share/lunarvim | ~/.config
	@rm -rvf -- $@
	ln -sf -- $(abspath lvim) $@

clean-lvim:  ## Delete the LunarVim installation
	@rm -rvf ~/.local/share/lunarvim ~/.local/share/nvim ~/.local/state/nvim ~/.cache/lvim ~/.config/lvim ~/.local/bin/lvim

# ---------- Misc ---------- 

.DEFAULT_GOAL := help

.PHONY: help
help:
# source: https://github.com/jessfraz/dotfiles/blob/master/Makefile
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
