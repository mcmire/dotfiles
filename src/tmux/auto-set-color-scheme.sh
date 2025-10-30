#!/usr/bin/env bash

# This file configures tmux to use the current Tinty color scheme.
# Note we use RGB values for colors instead of relying on ANSI terminal colors
# or tmux's `colour*` values (which only gives us 256 colors to work with
# instead of the full 16 million).
#
# The original inspiration for this script came from here (although it's been
# modified since): <https://grrr.tech/posts/2020/switch-dark-mode-os/>

set -euo pipefail

get-colors() {
  local color_scheme="$1"
  tinty list --json | \
    jq --raw-output --arg color_scheme "$color_scheme" 'map(select(.id == $color_scheme)) | .[0].palette | map_values(.hex_str) | to_entries | sort_by(.key) | map("\(.key) \(.value)") | .[]'
}

main() {
  local current_color_scheme
  if ! current_color_scheme="$(tinty current 2>/dev/null)"; then
    echo "Could not find color scheme"
    exit 1
  fi

  local colors
  if ! colors="$(get-colors "$current_color_scheme" 2>/dev/null)"; then
    echo "Invalid color scheme: $current_color_scheme"
    exit 1
  fi

  echo "$colors" | while read -r name value; do
    tmux set-environment -gh "$name" "$value"
    tmux source-file "$HOME/.tmux/custom-colors.conf"
  done
}

main "$@"
