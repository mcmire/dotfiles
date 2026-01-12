if which brew &>/dev/null; then
  autojump_dir=$(brew --prefix autojump)

  [[ -s $autojump_dir/etc/autojump.sh ]] && source $autojump_dir/etc/autojump.sh
fi
