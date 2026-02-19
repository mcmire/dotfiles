#!/usr/bin/env bash

HOSTNAME="$(hostname -s)"
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
  print-with-color 34 "== $* =="
}

success() {
  print-with-color 32 "$@"
}

create-global-launch-daemon() {
  if which launchctl &>/dev/null; then
    local launch_agent="$1"

    echo "- Enabling $launch_agent"

    sudo launchctl unload "/Library/LaunchDaemons/${launch_agent}.plist" || true
    sed -Ee 's|{{ HOME }}|'"$HOME"'|' "$DOTFILES_PROJECT_DIR/extras/LaunchDaemons/${launch_agent}.plist.tpl" > "/tmp/${launch_agent}.plist"
    sudo cp -f "/tmp/${launch_agent}.plist" "/Library/LaunchDaemons/${launch_agent}.plist"
    rm "/tmp/${launch_agent}.plist"
    sudo chmod 644 "/Library/LaunchDaemons/${launch_agent}.plist"
    sudo launchctl load "/Library/LaunchDaemons/${launch_agent}.plist"
  fi
}

create-user-launch-agent() {
  if which launchctl &>/dev/null; then
    local launch_agent="$1"

    echo "- Enabling $launch_agent"

    launchctl unload "$HOME/Library/LaunchAgents/${launch_agent}.plist" || true
    sed -Ee 's|{{ HOME }}|'"$HOME"'|' "$DOTFILES_PROJECT_DIR/extras/LaunchAgents/${launch_agent}.plist.tpl" > "/tmp/${launch_agent}.plist"
    cp -f "/tmp/${launch_agent}.plist" "$HOME/Library/LaunchAgents/${launch_agent}.plist"
    rm "/tmp/${launch_agent}.plist"
    chmod 644 "$HOME/Library/LaunchAgents/${launch_agent}.plist"
    launchctl load "$HOME/Library/LaunchAgents/${launch_agent}.plist"
  fi
}

set-git-name-and-email() {
  if [[ -n "$GIT_NAME" ]]; then
    banner "Setting your Git name to $GIT_NAME"
    git config --global --unset-all user.name || true
    git config --global --add user.name "$GIT_NAME"
  fi

  if [[ -n "$GIT_EMAIL" ]]; then
    banner "Setting your Git email to $GIT_EMAIL"
    git config --global --unset-all user.email || true
    git config --global --add user.email "$GIT_EMAIL"
  fi
}

create-launch-agents-and-daemons() {
  if which launchctl &>/dev/null && [[ -n "$DOTFILES_PROJECT_DIR" ]]; then
    banner "Setting up automated backups"
    create-user-launch-agent "com.elliotwinkler.create-backup-periodically"

    if [[ -d "$HOME/obsidian-vault" ]]; then
      banner "Setting up Obsidian vault syncing"
      create-user-launch-agent com.elliotwinkler.sync-obsidian-vault-periodically
      create-user-launch-agent com.elliotwinkler.sync-obsidian-vault-when-changed
      create-user-launch-agent com.elliotwinkler.sync-writings-repo-periodically
      create-user-launch-agent com.elliotwinkler.sync-writings-repo-when-changed
    fi
  fi
}

sync-cursor-extensions() {
  if which cursor &>/dev/null; then
    banner "Syncing Cursor extensions"
    "$DOTFILES_PROJECT_DIR"/scripts/sync-cursor-extensions.sh
  fi
}

main() {
  set-git-name-and-email
  create-launch-agents-and-daemons
  sync-cursor-extensions

  success "Done!"
}

main "$@"
