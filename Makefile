# ---------- Zsh ----------

# generate list of Zsh dot files based on contents of zsh/ directory
# e.g. ~/.zshrc ~/.zprofile ...
ZDOTFILES := $(foreach f,$(wildcard zsh/*),~/.$(notdir $(f)))

.PHONY: zim
zim: $(ZDOTFILES) ## Install the Zim Zsh configuration framework
	zsh -ic 'zimfw install'

~/.zim:
	curl -fsS https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh

# Zsh dot files must be installed *after* Zim itself, otherwise the installation
# gets aborted prematurely with the message "Zim already installed".
$(ZDOTFILES): ~/.zim
	ln -sf -- $(abspath $(subst .,zsh/,$(notdir $@))) $@

# -------- LunarVim --------

.PHONY: lvim clean-lvim
lvim: ~/.config/lvim ## Configure the LunarVim layer for Neovim

~/.local/share/lunarvim: LV_BRANCH := release-1.3/neovim-0.9
~/.local/share/lunarvim:
	$(eval LV_INSTALL := $(shell mktemp))
	curl -fsS https://raw.githubusercontent.com/LunarVim/LunarVim/$(LV_BRANCH)/utils/installer/install.sh -o $(LV_INSTALL)
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

# ---------- fzf ----------

FZF_VERSION := 0.41.1

.PHONY: fzf
fzf: ~/.local/share/fzf/shell/completion.zsh
fzf: ~/.local/share/fzf/shell/key-bindings.zsh
fzf: ~/.local/share/fzf/bin/fzf
fzf: ## Install the fzf fuzzy-finder

~/.local/share/fzf:
	@mkdir $@

~/.local/share/fzf/shell: | ~/.local/share/fzf
	@mkdir $@

~/.local/share/fzf/bin/fzf: FZF_VERSION | ~/.local/share/fzf
	curl -fsSo ~/.local/share/fzf/install https://raw.githubusercontent.com/junegunn/fzf/$(FZF_VERSION)/install
	chmod +x ~/.local/share/fzf/install
	~/.local/share/fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish
	rm ~/.local/share/fzf/install

~/.local/share/fzf/shell/%.zsh: FZF_VERSION | ~/.local/share/fzf/shell
	curl -fsSo $@ https://raw.githubusercontent.com/junegunn/fzf/$(FZF_VERSION)/shell/$(notdir $@)

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

.PHONY: phony
# source: https://stackoverflow.com/a/74378629
define DEPENDABLE_VAR
$(1):
	echo -n $($(1)) > $(1)
ifneq ("$(file <$(1))","$($(1))")
$(1): phony
endif
endef

$(eval $(call DEPENDABLE_VAR,FZF_VERSION))
