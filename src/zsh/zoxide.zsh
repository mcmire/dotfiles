if which zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
else
  echo "It doesn't look like you have zoxide installed. Some features won't work."
fi
