" Load NeoBundle
if has('vim_starting')
  if &compatible
    set nocompatible               " Be iMproved
  endif

  set runtimepath+=~/.config/nvim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.config/nvim/bundle/'))

" Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'

" Load the rest of the plugins
if filereadable(expand('~/.config/nvim/plugins.vim'))
  source ~/.config/nvim/plugins.vim
endif

call neobundle#end()

augroup local
  " Clear user-defined autocmd groups
  autocmd!

  " If we launched vim without specifying a target, we want to open the pwd
  autocmd VimEnter * if empty(argv()) | silent! edit . | endif
augroup END
