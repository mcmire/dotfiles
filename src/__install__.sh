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

if which launchctl &>/dev/null && [[ -d $HOME/obsidian-vault ]] && [[ -n "${DOTFILES_PROJECT_DIR:-}" ]]; then
  banner "Setting up Obsidian vault syncing"

  for launch_agent in com.elliotwinkler.sync-obsidian-vault-periodically com.elliotwinkler.sync-obsidian-vault-when-changed; do
    echo
    echo "Enabling ${launch_agent}"
    echo
    launchctl unload $HOME/Library/LaunchAgents/${launch_agent}.plist || true
    cat $DOTFILES_PROJECT_DIR/extras/LaunchAgents/${launch_agent}.plist.tpl | sed -Ee 's|{{ HOME }}|'$HOME'|' > /tmp/${launch_agent}.plist
    cp -f /tmp/${launch_agent}.plist $HOME/Library/LaunchAgents/${launch_agent}.plist
    rm /tmp/${launch_agent}.plist
    chmod 644 $HOME/Library/LaunchAgents/${launch_agent}.plist
    launchctl load $HOME/Library/LaunchAgents/${launch_agent}.plist
  done
fi

success "Done!"
