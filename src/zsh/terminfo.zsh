# We provide our own terminfo which adds support for strikethrough.
# - See: https://gpanders.com/blog/the-definitive-guide-to-using-tmux-256color-on-macos/
# - Related: https://github.com/neovim/neovim/discussions/24346#discussioncomment-9061675
export TERMINFO_DIRS=$HOME/.local/share/terminfo:$TERMINFO_DIRS
