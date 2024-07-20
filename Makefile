include gmsl

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

# ncurses uses the two-character hexadecimal form as the intermediate TERMINFO
# directory tree level on macOS.
# https://invisible-island.net/ncurses/man/term.5.html#h3-Mixed-case-Terminal-Names
terminfo_w := $(if $(uname_s:Darwin=),w,77)

.PHONY: wezterm
wezterm: ~/.config/wezterm
wezterm: ~/.terminfo/$(terminfo_w)/wezterm
wezterm: ~/.wezterm.sh
wezterm: ## Set up the WezTerm terminal emulator and its shell integration

~/.config/wezterm: | ~/.config
ifeq ($(uname_s),Darwin)
	@rm -rvf -- $@
	ln -sf -- $(abspath wezterm) $@
else
	ln -srTf -- wezterm $@
endif

~/.terminfo/$(terminfo_w)/wezterm:
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
ifeq ($(uname_s),Darwin)
	@rm -rvf -- $@
	ln -sf -- $(abspath nvim) $@
else
	ln -srTf -- nvim $@
endif

clean-nvim: ## Delete the Neovim state and caches
	@rm -rvf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim ~/.config/nvim

# ---------- Go -----------

GO_VERSION := 1.23rc1

.PHONY: go
go: ~/.local/share/go ## Install the Go programming language toolchain

~/.local/share/go$(GO_VERSION): | ~/.local/share
	@mkdir $@

~/.local/share/go$(GO_VERSION)/bin/go: | ~/.local/share/go$(GO_VERSION)
	$(eval os := $(call lc,$(uname_s)))
	$(eval mach := $(shell uname -m))
# ref: https://www.gnu.org/software/make/manual/html_node/Substitution-Refs.html
	$(eval arch := $(if $(mach:x86_64=),$(if $(mach:aarch64=),$(mach),arm64),amd64))
	curl -fsSLo ~/.local/share/golang.tgz https://go.dev/dl/go$(GO_VERSION).$(os)-$(arch).tar.gz
	tar -C $(dir $(abspath $(dir $@))) --strip-components=1 -xzf ~/.local/share/golang.tgz
	rm ~/.local/share/golang.tgz

~/.local/share/go: GO_VERSION | ~/.local/share/go$(GO_VERSION)/bin/go
ifeq ($(uname_s),Darwin)
	@rm -vf -- $@
	ln -sf -- go$(GO_VERSION) $@
else
	ln -sTf -- go$(GO_VERSION) $@
endif

# ---------- Rust ----------

rustdirs := ~/.rustup ~/.cargo

.PHONY: rust
rust: $(rustdirs) ## Install the Rust programming language toolchain

$(rustdirs):
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

gnu_make_version := $(subst ., ,$(MAKE_VERSION))

.PHONY: phony
# source: https://stackoverflow.com/a/74378629
define dependable-var
$(1):
	printf '%s' $($(1)) > $(1)
ifneq ($(call gte,$(word 1,$(gnu_make_version)),4),$(true))
	$$(error Unsupported Make version. \
		The 'file' built-in function is not available in GNU Make $(MAKE_VERSION), \
		please use GNU Make 4.0 or above)
endif
ifneq ("$(file <$(1))","$($(1))")
$(1): phony
endif
endef

$(eval $(call dependable-var,GO_VERSION))
