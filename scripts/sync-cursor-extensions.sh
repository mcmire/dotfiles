#!/usr/bin/env bash

set -euo pipefail

OUR_FILE="$DOTFILES_PROJECT_DIR/src/cursor/extensions.json"
THEIR_FILE="$HOME/.cursor/extensions/extensions.json"

main() {
  local extension_name
  local extension_version

  if ! type cursor &>/dev/null; then
    echo "Cursor not installed, skipping extension syncing."
    exit
  fi

  if [[ -f $OUR_FILE ]]; then
    echo "Using extensions.json to update list of installed extensions."
    cat "$OUR_FILE" | {
      while read -r line; do
        #if [[ "$line" =~ ^([^@]+)@(.+)$ ]]; then
          #extension_name="${BASH_REMATCH[1]}"
          #extension_version="${BASH_REMATCH[2]}"
        #fi
        cursor --install-extension "$line"
      done
    }
  else
    echo "extensions.json did not exist, populating."
    cursor --list-extensions --show-versions > "$OUR_FILE"
  fi
}

main "$@"
