if which brew &>/dev/null; then
  fzf_path=$(brew --prefix fzf)

  # Setup fzf
  # ---------
  if [[ ! "$PATH" == *$fzf_path/bin* ]]; then
    PATH="$fzf_path/bin:$PATH"
  fi

  # Auto-completion
  # ---------------
  if [[ $- == *i* && -f "$fzf_path/shell/completion.zsh" ]]; then
    source "$fzf_path/shell/completion.zsh" 2> /dev/null
  fi

  # Key bindings
  # ------------
  if [[ -f $fzf_path/shell/key-bindings.zsh ]]; then
    source "$fzf_path/shell/key-bindings.zsh"
  fi
fi
