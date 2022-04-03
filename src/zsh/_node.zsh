if [[ $DOTFILES_INSIDE_SUBSHELL -ne 1 ]]; then
  export NODE_PATH="./node_modules:$NODE_PATH"
fi

if type npm &>/dev/null && [[ -o login ]]; then
  npm_root="$(npm root -g)"
  if [[ $DOTFILES_INSIDE_SUBSHELL -ne 1 ]]; then
    export NODE_PATH="$npm_root:$NODE_PATH"
  fi
fi
