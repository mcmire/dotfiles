" This function ensures that the NERDTree is open and the current working
" directory is set correctly, whether Vim was opened with no arguments or a
" single directory as the first argument.
"
" This script is in after/plugin since we need to provide our own autocmd after
" NERDTree's autocmds are defined.

function! ReplaceNERDTreeIfDirectory()
  if argc() == 0 || (argc() == 1 && isdirectory(argv(0)))
    " If the first argument is a directory...
    if argc() == 1 && isdirectory(argv(0))
      " Change the working directory to the first argument
      execute "cd" argv(0)
      " At this point, the only buffer open is a NERDTree that is pointing to
      " that directory. Replace that with an empty buffer.
      enew
    endif
    " Ensure that the NERDTree is open.
    NERDTree
  endif
endfunction

augroup NERDTreeHijackNetrw
  au VimEnter * if exists(":NERDTree") | call ReplaceNERDTreeIfDirectory() | endif
augroup END
