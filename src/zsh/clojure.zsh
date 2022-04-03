if [[ $DOTFILES_INSIDE_SUBSHELL -ne 1 ]]; then
  export PATH="$HOME/.cljr/bin:$PATH"
fi
