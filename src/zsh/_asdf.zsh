if [[ $DOTFILES_INSIDE_SUBSHELL -ne 1 ]]; then
  export PATH="$HOME/.asdf/shims:$PATH"
fi
