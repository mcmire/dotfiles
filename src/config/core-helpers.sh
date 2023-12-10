DEBUG="false"
USE_COLOR="true"

color() {
  local color="$1"
  shift

  if [[ $USE_COLOR == "true" ]]; then
    echo -ne "\033[${color}m"
    echo -n "$@"
    echo -e "\033[0m"
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
  green "$@" "\n"
}

error() {
  red "ERROR:" "$@" "\n"
}

info() {
  blue "$@" "\n"
}

die() {
  error "$* Aborting." >&2
  exit 1
}

debug() {
  if [[ $DEBUG == "true" ]]; then
    magenta "$@" "\n" >&2
  fi
}

set-debug-mode() {
  DEBUG="$1"
}

set-color-mode() {
  USE_COLOR="$1"
}
