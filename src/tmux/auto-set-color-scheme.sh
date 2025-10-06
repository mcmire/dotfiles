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
  bg_0="#112e38"
  bg_1="#163945"
  bg_2="#284954"
  dim_0="#61777c"
  fg_0="#9faeae"
  fg_1="#bfd0d0"

  red="#f13c3e"
  green="#69ad21"
  yellow="#d1a416"
  blue="#3a82f8"
  magenta="#e75bb3"
  cyan="#42bdaa"
  orange="#e26f35"
  violet="#9b72e9"

  br_red="#ff4b49"
  br_green="#78be2e"
  br_yellow="#e4b424"
  br_blue="#4a91ff"
  br_magenta="#fb69c4"
  br_cyan="#50cfba"
  br_orange="#f67e41"
  br_violet="#ab80fc"
elif [[ $color_scheme_mode == "light" ]]; then
  bg_0="#faf0d2"
  bg_1="#e4dec4"
  bg_2="#c4c3b0"
  dim_0="#7e8783"
  fg_0="#43545a"
  fg_1="#2d3c42"

  red="#c00221"
  green="#3f8100"
  yellow="#9b7600"
  blue="#005dcc"
  magenta="#b73088"
  cyan="#038d7c"
  orange="#b04713"
  violet="#714cbc"

  br_red="#b9001e"
  br_green="#3a7b00"
  br_yellow="#957000"
  br_blue="#0059c6"
  br_magenta="#b12b82"
  br_cyan="#008777"
  br_orange="#a9430f"
  br_violet="#6b47b6"
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
