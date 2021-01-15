export NODE_PATH="/usr/local/lib/node:/usr/local/lib/node_modules:./node_modules:$NODE_PATH"

if [[ -o login ]]; then
  export NODE_PATH="$(npm root -g):$NODE_PATH"
fi
