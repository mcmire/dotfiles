#!/bin/bash

set -euo pipefail

real_tinty_path="$1"
colorscheme="$2"

echo "### Making sure that iTerm profile exists..."
~/.iterm/apply-tinty-colorscheme.py --verify "$colorscheme"
echo

echo "## Setting Tinty colorscheme to '$colorscheme'..."
$real_tinty_path apply "$colorscheme"
echo "Done."
echo

echo "### Applying Tinty colorscheme to iTerm..."
~/.iterm/apply-tinty-colorscheme.py
echo

echo "### Applying Tinty colorscheme to tmux..."
~/.tmux/apply-tinty-colorscheme.sh
echo "Done."
