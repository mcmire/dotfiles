#!/bin/bash

set -euo pipefail

# Hide output because Tinty seems to run hooks asynchronously or something
~/.iterm/apply-tinty-colorscheme.py &>/dev/null
~/.tmux/apply-tinty-colorscheme.sh &>/dev/null
