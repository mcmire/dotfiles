if [[ $DOTFILES_INSIDE_SUBSHELL -ne 1 ]]; then
  # Ensure perl6 is visible from anywhere
  export PATH="/opt/rakudo:$PATH"
fi
