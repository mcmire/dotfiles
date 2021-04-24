export NODE_PATH="./node_modules:$NODE_PATH"

if type npm &>/dev/null && [[ -o login ]]; then
  npm_root="$(npm root -g)"
  export NODE_PATH="$npm_root:$NODE_PATH"
fi
