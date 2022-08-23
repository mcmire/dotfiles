if [[ $DOTFILES_INSIDE_SUBSHELL -ne 1 ]]; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi

if [[ -f ~/.cargo/env ]]; then
  source ~/.cargo/env
fi
