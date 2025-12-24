# shellcheck shell=bash

DEBUG="${DEBUG:-false}"
USE_COLOR="${USE_COLOR:-true}"

color() {
  local color="$1"
  shift

  if [[ $USE_COLOR == "true" ]]; then
    echo -ne "\033[${color}m"
    echo -ne "$@"
    echo -ne "\033[0m"
  else
    echo -ne "$@"
  fi
}

red() {
  color 31 "$@"
}

green() {
  color 32 "$@"
}

yellow() {
  color 33 "$@"
}

blue() {
  color 34 "$@"
}

magenta() {
  color 35 "$@"
}

cyan() {
  color 36 "$@"
}

success() {
  green "$@" $'\n'
}

warn() {
  yellow "WARNING:" "$@" $'\n' >&2
}

error() {
  red "ERROR:" "$@" $'\n' >&2
}

info() {
  blue "$@" $'\n'
}

die() {
  error "$@" "Aborting."
  exit 1
}

debug() {
  if [[ $DEBUG == "true" ]]; then
    magenta '[DEBUG]' "$@" "\n" >&2
  fi
}

set-debug-mode() {
  DEBUG="$1"
}

set-color-mode() {
  USE_COLOR="$1"
}

# vi: ft=bash
