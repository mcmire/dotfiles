# Colors

I wanted to document how colors are synchronized
across iTerm 2, Neovim, and tmux.
This will be filled out later when I get some free time,
but see here for more in the meantime:

<https://grrr.tech/posts/2020/switch-dark-mode-os/>

Also see ideas here:

<https://superuser.com/questions/1190190/switch-colorscheme-in-terminal-vim-and-tmux-from-dark-to-light-with-one-command>

Also also:

<https://gist.github.com/jamesmacfie/2061023e5365e8b6bfbbc20792ac90f8>

Some random notes:

* We are defining a custom `terminfo` for `tmux-256color` in `src/terminfo/74/tmux-256color`.
  Not sure if this is needed anymore.
