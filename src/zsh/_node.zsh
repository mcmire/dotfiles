export NODE_PATH="./node_modules:$NODE_PATH"

if type npm &>/dev/null && [[ -o login ]]; then
  export NODE_PATH="$(npm root -g):$NODE_PATH"
fi
