#!/usr/bin/env bash

set -euo pipefail

# ---
# This file configures tmux to use the Solarized color scheme. It is adapted
# from the files within <https://github.com/seebi/tmux-colors-solarized>, but
# uses RGB values for colors instead of relying on terminal colors or tmux's
# `colour*` values (which only gives us 256 colors to work with instead of the
# full 16 million).
#
# Roughly inspired by: <https://grrr.tech/posts/2020/switch-dark-mode-os/>
# ---

# First, let's start out by determing whether we are using the light or dark
# version of the color scheme. This is based on the output of
# `color-scheme-mode`, which ultimately relies on ~/.color-scheme-mode:

color_scheme_mode=$(color-scheme-mode)

# Then we'll define the colors that do not change in Solarized:

yellow="#b58900"
orange="#cb4b16"
red="#dc322f"
magenta="#d33682"
violet="#6c71c4"
blue="#268bd2"
cyan="#2aa198"
green="#859900"

# Next we'll define the remaining colors, which swap places between light and
# dark modes:

if [[ $color_scheme_mode == "light" ]]; then
  base3="#002b36"
  base2="#073642"
  base1="#586e75"
  base0="#657b83"
  base00="#839496"
  base01="#93a1a1"
  base02="#eee8d5"
  base03="#fdf6e3"
elif [[ $color_scheme_mode == "dark" ]]; then
  base03="#002b36"
  base02="#073642"
  base01="#586e75"
  base00="#657b83"
  base0="#839496"
  base1="#93a1a1"
  base2="#eee8d5"
  base3="#fdf6e3"
fi

# Next we'll define some functions that will get applied when deactivating and
# reactivating the current session. This will be useful later for breaking out
# a tmux-within-a-tmux:

apply-to-all-windows() {
  # window-status-* options are window-local and must be run per-window in order
  # to take effect. Unfortunately there isn't a great way to do this but
  # it is planned in the future: <https://github.com/tmux/tmux/issues/2495>
  local active_window_index=$(tmux run-shell 'echo #I')
  for index in $(tmux list-windows -F '#I'); do
    tmux select-window -t $index
    tmux "$@"
  done
  tmux select-window -t $active_window_index
}

deactivate() {
  tmux set-option prefix None
  tmux set-option key-table off
  tmux set-option status-style "fg=${base03},bg=${base01}"
  apply-to-all-windows \
    set-option window-status-format " (#I) #W " ';' \
    set-option window-status-current-format "#[fg=${base0}] (#I) #W #[default]"
  tmux if-shell -F '#{pane_in_mode}' 'send-keys -X cancel'
  tmux refresh-client -S
}

reactivate() {
  tmux set-option -u prefix
  tmux set-option -u key-table
  tmux set-option -u status-style
  apply-to-all-windows \
    set-option -u window-status-format ';' \
    set-option -u window-status-current-format
  tmux refresh-client -S
}

# Usually though we will apply a base layer of styles:

main() {
  # Base status bar style
  tmux set-option -g status-style "fg=${base00},bg=${base02}"
  # Window title style
  tmux set-option -g window-status-format " #[fg=${base1}](#I)#[default] #W "
  tmux set-option -g window-status-current-format "#[fg=${base02},bold,bg=${blue}] (#I) #W #[default]"
  tmux set-option -g window-status-separator " "
  # Pane border style
  tmux set-option -g pane-border-style "fg=${base02}"
  tmux set-option -g pane-active-border-style "fg=${base01}"
  # Message text style
  tmux set-option -g message-style "fg=${orange},bg=${base02}"
  # Pane number display
  tmux set-option -g display-panes-colour "${orange}"
  tmux set-option -g display-panes-active-colour "${blue}"

  # Let's also clean up some parts of the UI:

  # Clear the left part of the status bar (no need to show the tmux index)
  tmux set-option -g status-left ''
  # Clear the right part of the status bar (no need for the clock)
  tmux set-option -g status-right ''

  # The last part of this file makes it possible to work with a
  # tmux-within-a-tmux. It's only here because it involves changing the color
  # scheme.
  #
  # Source: <https://github.com/samoshkin/tmux-config/blob/master/tmux/tmux.conf>

  # While inside of a tmux-within-a-tmux, F12 will tell the outer session to
  # ignore keypresses, forwarding all of them to the inner session
  tmux bind-key -T root F12 run-shell "$0 --deactivate"

  # F12 turns back on the outer session
  tmux bind-key -T off F12 run-shell "$0 --reactivate"
}

if [[ $# -eq 0 ]]; then
  main
else
  for arg in "$@"; do
    case $arg in
      --deactivate)
        deactivate
        ;;
      --reactivate)
        reactivate
        ;;
      *)
        echo "ERROR: Unknown argument $arg."
        exit 1
        ;;
    esac
  done
fi
