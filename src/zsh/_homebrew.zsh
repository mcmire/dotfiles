if [[ -d /opt/homebrew ]]; then
  # Support Apple Silicon computers
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  # Support Intel computers
  eval "$(/usr/local/bin/brew shellenv)"
fi
