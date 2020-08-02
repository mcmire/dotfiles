export NODE_PATH="/usr/local/lib/node:/usr/local/lib/node_modules:./node_modules:$NODE_PATH"

export PATH="./node_modules/.bin:$PATH"

if [[ -o login ]]; then
  export NODE_PATH="$(npm root -g):$NODE_PATH"
fi
