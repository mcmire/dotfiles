#!/usr/bin/env bash

set -euo pipefail

ASDF_DIRECTORY="$HOME/.asdf"
BOOTSTRAP="${BOOTSTRAP:-}"

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

if [[ $BOOTSTRAP ]]; then
  if ! type brew &>/dev/null; then
    if [[ -e /usr/local/Cellar || -e /opt/homebrew ]]; then
      error "It looks like Homebrew is already installed."
      echo "Try starting a new terminal session and then restarting this script."
      exit 1
    else
      banner "Installing Homebrew"
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

      echo
      success "Homebrew is now installed."
      echo "Please make a new tab and re-run this script."
      exit
    fi
  fi

  if ! [[ -e "/Applications/1Password 7.app" ]]; then
    banner "Installing 1Password..."
    brew install 1password

    echo
    echo "At this point you need to sign into 1Password, then sign into the App Store."
    echo "Once you've done that, re-run this script."
    exit 1
  fi

  if ! type mas &>/dev/null; then
    banner "Installing mas-cli..."
    brew install mas-cli/tap/mas
    mas_was_just_installed=1

    banner "Making sure that you are signed into the App Store"
    if ! mas account &>/dev/null; then
      error "It doesn't look like you are signed into the App Store."
      echo "Please do that and then rerun this script."
      exit 1
    fi
  fi

  banner "Installing missing Homebrew packages"
  brew bundle check || brew bundle

  if [[ $SHELL != $(which zsh) ]]; then
    banner "Updating shell to zsh"

    if [[ -d /opt/homebrew ]]; then
      sudo echo /opt/homebrew/bin/zsh >> /etc/shells
    else
      sudo echo /usr/local/bin/zsh >> /etc/shells
    fi

    chsh -s "$(which zsh)"
  fi

  banner "Fixing permissions on zsh share directory"
  if [[ -d /opt/homebrew ]]; then
    chmod -R 755 /opt/homebrew/share/zsh
  else
    chmod -R 755 /usr/local/share/zsh
  fi

  if ! [[ -d "$HOME/.zsh-async" ]]; then
    banner "Installing zsh-async"
    rm -rf "$HOME/.zsh-async"
    mkdir "$HOME/.zsh-async"
    curl -L https://api.github.com/repos/mafredri/zsh-async/tarball | \
      tar -x -z -f - -C "$HOME/.zsh-async" --strip-components 1
  fi

  if [[ -f /etc/zprofile ]]; then
    banner "Moving macOS's default zprofile out of the way"
    sudo mv /etc/zprofile /etc/zprofile.old
  fi

  if ! type asdf &>/dev/null; then
    banner "Loading asdf"
    source $ASDF_DIRECTORY/asdf.sh
  fi

  if ! [[ -d "$HOME/.tmux/plugins/tpm" ]]; then
    banner "Installing tpm"
    git clone "https://github.com/tmux-plugins/tpm" "$HOME/.tmux/plugins/tpm"
    $HOME/.tmux/plugins/tpm/bin/install_plugins
  fi

  for language in ruby python nodejs; do
    if ! [[ -d $ASDF_DIRECTORY/plugins/$language ]]; then
      banner "Installing $language plugin for asdf"
      asdf plugin add $language

      if [[ $language == "nodejs" ]]; then
        # Fix permissions on ~/.gnupg, which will be off on a fresh installation
        # Source: <https://gist.github.com/oseme-techguy/bae2e309c084d93b75a9b25f49718f85>
        chown -R $(whoami) ~/.gnupg/
        chmod 600 ~/.gnupg/*
        chmod 700 ~/.gnupg

        ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
      fi
    fi

    if [[ $(ls "$ASDF_DIRECTORY/installs/$language" | wc -l | sed -e 's/^ *//') -eq 0 ]]; then
      banner "Installing latest version of $language"

      if [[ $language == "nodejs" ]]; then
        # Use Rosetta for now as there are no Apple Silicon builds for Node yet
        # (although it's coming in Node 16).
        # See: <https://github.com/asdf-vm/asdf-nodejs/issues/189>
        arch -x86_64 asdf install $language latest
      else
        asdf install $language latest
      fi
    fi

    if [[ $(latest-version-of $language) != $(cat ~/.tool-versions | grep "^$language" | sed -e "s/^$language //") ]]; then
      banner "Making latest version of $language the default"
      asdf global $language $(latest-version-of $language)
    fi
  done

  if gem which neovim &>/dev/null; then
    banner "Installing Ruby plugin for Neovim"
    gem install neovim
  fi

  if pip show neovim &>/dev/null; then
    banner "Installing Python plugin for Neovim"
    pip install neovim
  fi

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

  banner "Making a bunch of configuration changes to MacOS..."
  extras/macos.sh
fi

success "Done!"
