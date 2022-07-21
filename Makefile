# ---------- Zsh ---------- 

.PHONY: $(ZDOTFILES)
# list of files inside zsh/ without directory name
ZDOTFILES := $(foreach f,$(wildcard zsh/*),$(notdir $(f)))

.PHONY: zim
zim: ~/.zim $(ZDOTFILES) ## Install the Zim Zsh configuration framework
	$(info => Execute 'zimfw install' after restarting the terminal)

~/.zim:
	curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh

$(ZDOTFILES):
	ln -sf -- $(abspath zsh/$@) ~/.$@

# ---------- Vim ----------

.PHONY: vim
vim: ~/.vim ~/.vimrc ## Configure the Vim text editor

~/.vimrc:
	ln -sf -- $(abspath vimrc) $@

~/.vim:
	@rm -vf -- $@
	ln -sf -- $(abspath vim) $@

# ---------- tmux ----------

.PHONY: tmux
tmux: ~/.tmux ~/.tmux.conf ## Configure the tmux terminal multiplexer

~/.tmux.conf:
	ln -sf -- $(abspath tmux.conf) $@

~/.tmux:
	@rm -vf -- $@
	ln -sf -- $(abspath tmux) $@

# ---------- Misc ---------- 

.DEFAULT_GOAL := help

.PHONY: help
help:
# source: https://github.com/jessfraz/dotfiles/blob/master/Makefile
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
