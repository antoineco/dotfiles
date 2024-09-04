uname_s := $(shell uname -s)

# ---------- Nix ----------

.PHONY: nix
nix: /nix ## Install Nix

/nix:
	curl -fsSL https://install.determinate.systems/nix | sh -s -- install

# ---------- Zsh ----------

# generate list of Zsh dot files based on contents of zsh/ directory
# e.g. ~/.zshrc ~/.zprofile ...
zdotfiles := $(foreach f,$(wildcard zsh/*),~/.$(notdir $(f)))

.PHONY: zim
zim: $(zdotfiles)
zim: ~/.zim/modules/fzf/init.zsh
zim: ## Install the Zim Zsh configuration framework

# NOTE: the mtime of ~/.zim gets updated not only during the Zim installation,
# but also on various events such as 'zimfw update', compilation of zwc files,
# etc. This can cause dependants to be re-made, which is acceptable and
# compensated by touching the dependants in their respective goals.
~/.zim:
	@rm -vf -- $(zdotfiles)
	curl -fsS https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh

# Zsh dot files must be installed *after* Zim itself, otherwise the installation
# gets aborted prematurely with the message "Zim already installed".
$(zdotfiles): ~/.zim
ifeq ($(uname_s),Darwin)
	@rm -vf -- $@
	ln -sf -- $(abspath $(subst .,zsh/,$(notdir $@))) $@
else
	ln -srTf -- $(subst .,zsh/,$(notdir $@)) $@
endif
	touch $@

~/.zim/modules/fzf/init.zsh: $(filter %.zimrc,$(zdotfiles))
	zsh -ic 'zimfw install'
	touch $@

# -------- WezTerm --------

.PHONY: wezterm
wezterm: ~/.config/wezterm
wezterm: ~/.wezterm.sh
wezterm: ## Set up the WezTerm terminal emulator and its shell integration

~/.config/wezterm: | ~/.config
ifeq ($(uname_s),Darwin)
	@rm -rvf -- $@
	ln -sf -- $(abspath wezterm) $@
else
	ln -srTf -- wezterm $@
endif

~/.wezterm.sh:
	curl -fsSo $@ https://raw.githubusercontent.com/wez/wezterm/main/assets/shell-integration/wezterm.sh

# --------- Neovim ---------

.PHONY: nvim clean-nvim
nvim: ~/.config/nvim ## Configure the Neovim text editor

~/.config:
	@mkdir $@

~/.config/nvim: | ~/.config
ifeq ($(uname_s),Darwin)
	@rm -rvf -- $@
	ln -sf -- $(abspath nvim) $@
else
	ln -srTf -- nvim $@
endif

clean-nvim: ## Delete the Neovim state and caches
	@rm -rvf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim ~/.config/nvim

# ---------- Misc ---------- 

.DEFAULT_GOAL := help

.PHONY: help
help:
# source: https://github.com/jessfraz/dotfiles/blob/master/Makefile
# Results are prefixed with the file name when MAKEFILE_LIST has multiple
# values, so we need to additionally handle that case.
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sort \
	| awk 'BEGIN {FS = ":"}; {if (NF < 3) {$$3 = $$2; $$2 = $$1}; print $$2":" $$3}' \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
