gnu_ln := $(shell &>/dev/null ln --help; echo $$?)

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
zim: ~/.zim/modules/asciiship/asciiship.zsh-theme
zim: ## Install the Zim Zsh configuration framework

~/.zim:
	@rm -vf -- $(zdotfiles)
	curl -fsS https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh
	rm -rf $@/modules/asciiship
	@rm -vf -- $(zdotfiles)

# Zsh dot files must be installed *after* Zim itself, otherwise the installation
# gets aborted prematurely with the message "Zim already installed".
$(zdotfiles): | ~/.zim
ifeq ($(gnu_ln),0)
	ln -srTf -- $(subst .,zsh/,$(notdir $@)) $@
else
	@rm -vf -- $@
	ln -sf -- $(abspath $(subst .,zsh/,$(notdir $@))) $@
endif

~/.zim/modules/asciiship/asciiship.zsh-theme:
	zsh -ic 'zimfw install'

# ---------- Git ----------

.PHONY: git
git: ~/.gitconfig ## Configure the Git revision control system

~/.gitconfig:
ifeq ($(gnu_ln),0)
	ln -srTf -- gitconfig $@
else
	@rm -vf -- $@
	ln -sf -- $(abspath gitconfig) $@
endif

# -------- WezTerm --------

.PHONY: wezterm
wezterm: ~/.config/wezterm
wezterm: ~/.wezterm.sh
wezterm: ## Set up the WezTerm terminal emulator and its shell integration

~/.config/wezterm: | ~/.config
ifeq ($(gnu_ln),0)
	ln -srTf -- wezterm $@
else
	@rm -rvf -- $@
	ln -sf -- $(abspath wezterm) $@
endif

~/.wezterm.sh:
	curl -fsSo $@ https://raw.githubusercontent.com/wez/wezterm/main/assets/shell-integration/wezterm.sh

# -------- Neovim ---------

.PHONY: nvim clean-nvim
nvim: ~/.config/nvim ## Configure the Neovim text editor

~/.config:
	@mkdir $@

~/.config/nvim: | ~/.config
ifeq ($(gnu_ln),0)
	ln -srTf -- nvim $@
else
	@rm -rvf -- $@
	ln -sf -- $(abspath nvim) $@
endif

clean-nvim: ## Delete the Neovim state and caches
	@rm -rvf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim ~/.config/nvim

# ---------- Vim ----------

.PHONY: vim
vim: ~/.vimrc ## Configure the Vim text editor

~/.vimrc:
ifeq ($(gnu_ln),0)
	ln -srTf -- vimrc $@
else
	@rm -vf -- $@
	ln -sf -- $(abspath vimrc) $@
endif

# -------- direnv ---------

.PHONY: direnv
direnv: ~/.config/direnv ## Set up direnv

~/.config/direnv: | ~/.config
ifeq ($(gnu_ln),0)
	ln -srTf -- direnv $@
else
	@rm -rvf -- $@
	ln -sf -- $(abspath direnv) $@
endif

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
