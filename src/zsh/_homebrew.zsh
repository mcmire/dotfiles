if which /opt/homebrew/bin/brew &>/dev/null; then
  # Support Apple Silicon computers
  eval "$(/opt/homebrew/bin/brew shellenv)"
if which /usr/local/bin/brew &>/dev/null; then
  # Support Intel computers
  eval "$(/usr/local/bin/brew shellenv)"
else
  # Running on Termux, ignore
fi
