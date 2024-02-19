include gmsl

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
	ln -srTf -- $(subst .,zsh/,$(notdir $@)) $@

# -------- WezTerm --------

.PHONY: wezterm
wezterm: ~/.terminfo/w/wezterm
wezterm: ~/.wezterm.sh
wezterm: ## Set up the shell for the WezTerm terminal emulator

~/.terminfo/w/wezterm:
	$(eval TMPFILE := $(shell mktemp))
	curl -fsSo $(TMPFILE) https://raw.githubusercontent.com/wez/wezterm/main/termwiz/data/wezterm.terminfo
	tic -x $(TMPFILE)
	rm $(TMPFILE)

~/.wezterm.sh:
	curl -fsSo $@ https://raw.githubusercontent.com/wez/wezterm/main/assets/shell-integration/wezterm.sh

# --------- Neovim ---------

.PHONY: nvim clean-nvim
nvim: ~/.config/nvim ## Configure the Neovim text editor

~/.config:
	@mkdir $@

~/.config/nvim: | ~/.config
	ln -srTf -- nvim $@

clean-nvim: ## Delete the Neovim state and caches
	@rm -rvf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim ~/.config/nvim

# ---------- fzf ----------

FZF_VERSION := 0.44.1

.PHONY: fzf
fzf: ~/.local/share/fzf/shell/completion.zsh
fzf: ~/.local/share/fzf/shell/key-bindings.zsh
fzf: ~/.local/share/fzf/bin/fzf
fzf: ## Install the fzf fuzzy-finder

~/.local:
	@mkdir $@

~/.local/share: | ~/.local
	@mkdir $@

~/.local/share/fzf: | ~/.local/share
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

# ---------- Go -----------

GO_VERSION := 1.22.0

.PHONY: go
go: ~/.local/share/go ## Install the Go programming language toolchain

~/.local/share/go$(GO_VERSION): | ~/.local/share
	@mkdir $@

~/.local/share/go$(GO_VERSION)/bin/go: | ~/.local/share/go$(GO_VERSION)
	$(eval OS := $(call lc,$(shell uname -s)))
	$(eval MACH := $(shell uname -m))
# ref: https://www.gnu.org/software/make/manual/html_node/Substitution-Refs.html
	$(eval ARCH := $(if $(MACH:x86_64=),$(if $(MACH:aarch64=),$(MACH),arm64),amd64))
	curl -fsSLo ~/.local/share/golang.tgz https://go.dev/dl/go$(GO_VERSION).$(OS)-$(ARCH).tar.gz
	tar -C $(dir $(abspath $(dir $@))) --strip-components=1 -xzf ~/.local/share/golang.tgz
	rm ~/.local/share/golang.tgz

~/.local/share/go: GO_VERSION | ~/.local/share/go$(GO_VERSION)/bin/go
	ln -sTf -- go$(GO_VERSION) $@

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
$(eval $(call DEPENDABLE_VAR,GO_VERSION))
