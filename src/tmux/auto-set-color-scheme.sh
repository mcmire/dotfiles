#!/usr/bin/env bash

set -euo pipefail

# ---
# This file configures tmux to use the Selenized color scheme, adapted
# from <https://github.com/jan-warchol/selenized/blob/master/the-values.md>.
# Note we use RGB values for colors instead of relying on ANSI terminal colors
# or tmux's `colour*` values (which only gives us 256 colors to work with
# instead of the full 16 million).
#
# The light/dark switching is roughly inspired by:
# <https://grrr.tech/posts/2020/switch-dark-mode-os/>
# ---

# First, let's start out by determing whether we are using the light or dark
# version of the color scheme. This is based on the output of
# `color-scheme-mode`, which ultimately relies on ~/.color-scheme-mode:

color_scheme_mode=$(color-scheme-mode)

# Next we'll define the two versions. These are based on "Selenized Dark"
# and "Selenized Light".

if [[ $color_scheme_mode == "dark" ]]; then
  bg_0="#103c48"
  bg_1="#174956"
  bg_2="#325b66"
  dim_0="#72898f"
  fg_0="#adbcbc"
  fg_1="#cad8d9"

  red="#fa5750"
  green="#75b938"
  yellow="#dbb32d"
  blue="#4695f7"
  magenta="#f275be"
  cyan="#41c7b9"
  orange="#ed8649"
  violet="#af88eb"

  br_red="#ff665c"
  br_green="#84c747"
  br_yellow="#ebc13d"
  br_blue="#58a3ff"
  br_magenta="#ff84cd"
  br_cyan="#53d6c7"
  br_orange="#fd9456"
  br_violet="#bd96fa"
elif [[ $color_scheme_mode == "light" ]]; then
  bg_0="#fbf3db"
  bg_1="#e9e4d0"
  bg_2="#cfcebe"
  dim_0="#909995"
  fg_0="#53676d"
  fg_1="#3a4d53"

  red="#d2212d"
  green="#489100"
  yellow="#ad8900"
  blue="#0072d4"
  magenta="#ca4898"
  cyan="#009c8f"
  orange="#c25d1e"
  violet="#8762c6"

  br_red="#cc1729"
  br_green="#428b00"
  br_yellow="#a78300"
  br_blue="#006dce"
  br_magenta="#c44392"
  br_cyan="#00978a"
  br_orange="#bc5819"
  br_violet="#825dc0"
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
  tmux set-option status-style "fg=${fg_1},bg=${bg_1}"
  apply-to-all-windows \
    set-option window-status-format " (#I) #W " ';' \
    set-option window-status-current-format "#[fg=${fg_1}] (#I) #W #[default]"
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
  tmux set-option -g status-style "fg=${fg_0},bg=${bg_0}"
  # Window title style
  tmux set-option -g window-status-format " #[fg=${fg_1}](#I)#[default] #W "
  tmux set-option -g window-status-current-format "#[fg=${bg_0},bold,bg=${blue}] (#I) #W #[default]"
  tmux set-option -g window-status-separator " "
  # Pane border style
  tmux set-option -g pane-border-style "fg=${fg_1}"
  tmux set-option -g pane-active-border-style "fg=${fg_1}"
  # Message text style
  tmux set-option -g message-style "fg=${orange},bg=${bg_1}"
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
