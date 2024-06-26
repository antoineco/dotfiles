include gmsl

UNAME_S := $(shell uname -s)

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
ifeq ($(UNAME_S), Darwin)
	@rm -vf -- $@
	ln -sf -- $(abspath $(subst .,zsh/,$(notdir $@))) $@
else
	ln -srTf -- $(subst .,zsh/,$(notdir $@)) $@
endif

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
ifeq ($(UNAME_S), Darwin)
	@rm -rvf -- $@
	ln -sf -- $(abspath nvim) $@
else
	ln -srTf -- nvim $@
endif

clean-nvim: ## Delete the Neovim state and caches
	@rm -rvf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim ~/.config/nvim

# ---------- fzf ----------

FZF_VERSION := 0.53.0

.PHONY: fzf
fzf: ~/.local/share/fzf/bin/fzf ## Install the fzf fuzzy-finder

~/.local:
	@mkdir $@

~/.local/share: | ~/.local
	@mkdir $@

~/.local/share/fzf: | ~/.local/share
	@mkdir $@

~/.local/share/fzf/bin/fzf: FZF_VERSION | ~/.local/share/fzf
	curl -fsSo ~/.local/share/fzf/install https://raw.githubusercontent.com/junegunn/fzf/$(FZF_VERSION)/install
	chmod +x ~/.local/share/fzf/install
	~/.local/share/fzf/install --bin
	rm ~/.local/share/fzf/install
	touch $@

# ---------- Go -----------

GO_VERSION := 1.23rc1

.PHONY: go
go: ~/.local/share/go ## Install the Go programming language toolchain

~/.local/share/go$(GO_VERSION): | ~/.local/share
	@mkdir $@

~/.local/share/go$(GO_VERSION)/bin/go: | ~/.local/share/go$(GO_VERSION)
	$(eval OS := $(call lc,$(UNAME_S)))
	$(eval MACH := $(shell uname -m))
# ref: https://www.gnu.org/software/make/manual/html_node/Substitution-Refs.html
	$(eval ARCH := $(if $(MACH:x86_64=),$(if $(MACH:aarch64=),$(MACH),arm64),amd64))
	curl -fsSLo ~/.local/share/golang.tgz https://go.dev/dl/go$(GO_VERSION).$(OS)-$(ARCH).tar.gz
	tar -C $(dir $(abspath $(dir $@))) --strip-components=1 -xzf ~/.local/share/golang.tgz
	rm ~/.local/share/golang.tgz

~/.local/share/go: GO_VERSION | ~/.local/share/go$(GO_VERSION)/bin/go
ifeq ($(UNAME_S), Darwin)
	@rm -vf -- $@
	ln -sf -- go$(GO_VERSION) $@
else
	ln -sTf -- go$(GO_VERSION) $@
endif

# ---------- Rust ----------

RUSTDIRS := ~/.rustup ~/.cargo

.PHONY: rust
rust: $(RUSTDIRS) ## Install the Rust programming language toolchain

$(RUSTDIRS):
	curl -fsS https://sh.rustup.rs | sh -s -- -y --no-modify-path

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
