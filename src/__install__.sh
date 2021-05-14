#!/usr/bin/env bash

set -euo pipefail

something_already_printed=0

pad-from-existing-output() {
  if [[ $something_already_printed -eq 1 ]]; then
    echo
  fi
}

print-with-color() {
  pad-from-existing-output
  echo -ne "\033[${1}m"
  echo -n "${@:2}"
  echo -e "\033[0m"
  something_already_printed=1
}

banner() {
  print-with-color 34 "== $@ =="
}

success() {
  print-with-color 32 "$@"
}

if [[ ${GIT_NAME:-} ]]; then
  banner "Setting your Git name to $GIT_NAME"
  git config --global --unset-all user.name || true
  git config --global --add user.name "$GIT_NAME"
fi

if [[ ${GIT_EMAIL:-} ]]; then
  banner "Setting your Git email to $GIT_EMAIL"
  git config --global --unset-all user.email || true
  git config --global --add user.email "$GIT_EMAIL"
fi

success "Done!"
