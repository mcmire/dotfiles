#!/bin/bash

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

latest-version-of() {
  asdf list $1 | \
    grep -v 'preview\|dev' | \
    egrep '^\s+\d' | \
    tail -n 1 | \
    sed -Ee 's/^[ ]+//g'
}

if ! xcode-select -p &>/dev/null; then
  banner "Installing Command Line Tools"
  xcode-select --install

  echo "Please re-run this command when installation is complete!"
  exit
fi

banner "Installing missing Homebrew packages"
brew bundle check || brew bundle

if [[ $SHELL != $(which zsh) ]]; then
  banner "Updating shell to zsh"
  chsh -s "$(which zsh)"
fi

if [[ -f /etc/zprofile ]]; then
  banner "Moving macOS's default zprofile out of the way"
  sudo mv /etc/zprofile /etc/zprofile.old
fi

ASDF_DIRECTORY="$HOME/.asdf"

if ! type asdf &>/dev/null; then
  source $ASDF_DIRECTORY/asdf.sh
fi

for language in ruby python nodejs; do
  if ! [[ -d $ASDF_DIRECTORY/plugins/$language ]]; then
    banner "Installing $language plugin for asdf"
    asdf plugin add $language

    if [[ $language == "nodejs" ]]; then
      ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
    fi
  fi

  if [[ $(ls "$ASDF_DIRECTORY/installs/$language" | wc -l | sed -e 's/^ *//') -eq 0 ]]; then
    banner "Installing latest version of $language"
    asdf install ruby latest
  fi

  if [[ $(latest-version-of $language) != $(cat ~/.tool-versions | grep "^$language" | sed -e "s/^$language //") ]]; then
    banner "Making latest version of $language the default"
    asdf global $language $(latest-version-of $language)
  fi
done

banner "Upgrading pip"
pip install --upgrade pip

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

banner "Disabling press-and-hold"
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false

success "Done!"
