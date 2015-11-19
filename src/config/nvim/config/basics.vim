syntax on
filetype plugin indent on

" Set mapleader, so that <Leader>-related stuff can be redefined
let mapleader = ','
let maplocalleader = ','

" Show line numbers
set number
" Show line and column number in status bar
set ruler
" When I enter text, use UTF-8
set encoding=utf-8
" Livin' on the edge!
set noswapfile
" Store lots of :cmdline history
set history=1000
" Hide buffers when not displayed (vs. unloading them)
set hidden
" Disable the splash screen
set shortmess+=I
" Remove delay after pressing Escape and clearing the visual selection
set timeoutlen=1000 ttimeoutlen=0

" Use modelines and check 10 lines to read them
set modeline modelines=10

" Fix so typing '#' does not jump to start of line
" http://stackoverflow.com/questions/2063175/vim-insert-mode-comments-go-to-start-of-line
set nosmartindent

" Per-directory .vimrc files
set exrc            " enable per-directory .vimrc files
set secure          " disable unsafe commands in local .vimrc files

" Allow backspacing over everything in insert mode
set backspace=indent,eol,start
