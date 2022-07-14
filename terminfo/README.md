### terminfo

A collection of fairly up-to-date ncurses [terminfo][1] entries for the terminals I use.

Generated using the `infocmp -x` command on ncurses version 6.2.

Meant to be used on macOS as a replacement for the dated terminfo entries that ship with ncurses 5.7, to enable support
for modern capabilities such as italics, standout, highlights in text-based dialogs, etc.

Use the built-in `tic` utility to compile these files. The result is automatically written to the appropriate location
(typically `~/.terminfo/`). A more detailed procedure can be found at [Installing tmux-256color for macOS][3].

[1]: https://invisible-island.net/ncurses/ncurses.html#download_database
[2]: https://github.com/tmux/tmux/issues/435#issuecomment-393106753
[3]: https://gist.github.com/bbqtd/a4ac060d6f6b9ea6fe3aabe735aa9d95
