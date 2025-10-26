# Ctrl-D will exit the currently running shell,
# and also closes the tmux pane that shell is running in.
# http://superuser.com/questions/479600/how-can-i-prevent-tmux-exiting-with-ctrl-d
set -o ignoreeof

# Focused and non-focused panes get different background colors
export TINTED_TMUX_OPTION_ACTIVE=1

# Add a basic statusbar
export TINTED_TMUX_OPTION_STATUSBAR=1
