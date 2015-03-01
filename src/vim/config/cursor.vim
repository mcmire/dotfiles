" Set custom cursor -- vertical bar in insert mode (iTerm2)
" From http://www.iterm2.com/#/section/documentation/escape_codes
" Also https://gist.github.com/andyfowler/1195581 for the tmux stuff
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
  silent !echo -ne "\033]Ptmux;\033\033]50;CursorShape=0\007\033\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
  silent !echo -ne "\033]50;CursorShape=0\007"
endif
