" ✨✨✨ Magic ✨✨✨
" ===================

" No Vim configuration would be complete without a little magic!
"
" Okay, "magic" is a little misleading. However you want to describe it, this
" file sets up some stuff that happens automatically without having to
" explicitly make them happen.
"
" First things first. When you start Vim (or, in our case, Neovim), you can
" choose to pass a file path to the `nvim` executable, or you can call `nvim`
" without any arguments. In the first case Vim will start by opening the file
" you've provided, but in the second case it will start with no files open and
" wait for you to do something. Using the NERDTree plugin, this isn't exactly
" desirable, because we might expect to be able to `Ctrl-L` over to switch from
" the tree pane to the file pane. The following autocommand opens an empty file
" in this case so that we can do this.

augroup local
  autocmd VimEnter * if empty(argv()) | silent! edit . | endif
augroup END

" Next, we make it so that when a file is opened, Vim will place the cursor at
" the last position that the cursor was when the file was closed. How does this
" work? It's already built into Vim, actually: the last-known position is stored
" in the [`"` mark][quote-mark]. Normally you can go to a mark with `\``, but
" this creates a slight annoyance. Whenever you navigate to some location in a
" file, Vim adds that location to a *[jumplist]*. (You can navigate backward and
" forward through the jumplist with `Ctrl-O` and `Ctrl-I`.) In this case, we
" want to jump to the mark, but not add that jump to the jumplist. So instead of
" using `\``, we use `g\``.
"
" [quote-mark]: http://vimdoc.sourceforge.net/htmldoc/motion.html#%27quote
" [jumplist]: http://vimdoc.sourceforge.net/htmldoc/motion.html#jumplist
"
" A couple of notes below:
"
" * We only make the jump if the last-known position that's been stored is still
"   valid for the file.
" * We make sure *not* to do this for commit messages. When you edit a commit
"   message, you're actually editing the same file every single time (albeit
"   with different contents), and so restoring the cursor position would be
"   surprising.

augroup local
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
augroup END

" Next, we make it so that when any of these configuration files are modified,
" the entire configuration is reloaded ([source][autoreloading-vimrc]):
"
" [autoreloading-vimrc]: http://vimcasts.org/episodes/updating-your-vimrc-file-on-the-fly/

augroup local
  autocmd BufWritePost ~/.config/nvim/{init,plugins}.vim source %
  autocmd BufWritePost ~/.config/nvim/config/*.vim.md source ~/.config/nvim/init.vim
augroup END
