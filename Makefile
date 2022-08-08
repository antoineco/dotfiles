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

# ---------- NeoVim ----------

.PHONY: nvim
nvim: ~/.config/nvim ## Configure the NeoVim text editor

~/.config:
	@mkdir $@

~/.config/nvim: | ~/.config
	@rm -vf -- $@
	ln -sf -- $(abspath nvim) $@

# ---------- tmux ----------

.PHONY: tmux
tmux: ~/.tmux.conf ## Configure the tmux terminal multiplexer

~/.tmux.conf:
	ln -sf -- $(abspath tmux.conf) $@

# ---------- Misc ---------- 

.DEFAULT_GOAL := help

.PHONY: help
help:
# source: https://github.com/jessfraz/dotfiles/blob/master/Makefile
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
