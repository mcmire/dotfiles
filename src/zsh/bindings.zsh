# Sources:
# * http://dougblack.io/words/zsh-vi-mode.html
# * http://superuser.com/a/648046
# * http://ivyl.0xcafe.eu/2013/02/03/refining-zsh
# * https://emily.st/2013/05/03/zsh-vi-cursor/

# Engage Vi mode!
bindkey -v

# Use vim cli mode
bindkey '^P' up-history
bindkey '^N' down-history

# backspace and ^h working even after
# returning from command mode
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char

# ctrl-w removed word backwards
bindkey '^w' backward-kill-word
# But treat dashes, underscores, etc. as delimiters instead of just spaces
autoload -U select-word-style
select-word-style bash

# ctrl-r starts searching history backward
bindkey '^r' history-incremental-search-backward

# Reduce delay in switching between modes
export KEYTIMEOUT=1

# Tell zsh not to wait after pressing Escape
bindkey -M vicmd '^[' undefined-key
# Don't mess with existing widgets
bindkey -rM viins '^X'
bindkey -M viins '^X,' _history-complete-newer \
                 '^X/' _history-complete-older \
                 '^X`' _bash_complete-word

# Switch the cursor between line and block modes when going between command and
# insert mode.
#
# This was cobbled together from ChatGPT and also this source:
#
# - <https://unix.stackexchange.com/questions/433273/changing-cursor-style-based-on-mode-in-both-zsh-and-vim>
#
# We are using an ANSI escape seqeunce to set the cursor shape. Different
# terminals and terminal multiplexers have different levels of support for ANSI
# escape sequences. See here for some background info:
#
# - <https://jvns.ca/blog/2025/03/07/escape-code-standards/>
# - <https://iterm2.com/documentation-escape-codes.html>
# - <https://github.com/tmux/tmux/blob/882fb4d295deb3e4b803eb444915763305114e4f/tools/ansicode.txt>
#
# Setting the cursor shape used to be complicated, but is much improved on
# recent versions of tmux because it passes escape sequences through by default:
#
# - <https://github.com/tmux/tmux/wiki/FAQ#what-is-the-passthrough-escape-sequence-and-how-do-i-use-it>
#
# Some old resources which may or may not be relevant:
#
# - <http://micahelliott.com/posts/2015-07-20-vim-zsh-tmux-cursor.html>
# - <http://stackoverflow.com/questions/30985436/>
# - <https://bbs.archlinux.org/viewtopic.php?id=95078>
# - <http://unix.stackexchange.com/questions/115009/>
# - <https://vt100.net/docs/vt510-rm/DECSCUSR.html>
# - <https://github.com/jszakmeister/vim-togglecursor/blob/master/plugin/togglecursor.vim>

zle-keymap-select() {
  case $KEYMAP in
    vicmd)
      # Switch to a block
      print -n '\e[2 q'
      ;;
    viins|main|)
      # Switch to a line
      print -n '\e[6 q'
      ;;
  esac
}

zle-line-init() {
  # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
  zle -K viins
  # Default cursor is a line
  print -n '\e[6 q'
}

zle -N zle-keymap-select
zle -N zle-line-init

# Reset to line cursor on exit
trap 'print -n "\e[6 q"' EXIT
