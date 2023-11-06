" Configuration for prolog-syntax-vim
" ===================================

augroup local
  autocmd FileType prolog call s:UpdatePrologSyntaxHighlighting()
augroup END

function! s:UpdatePrologSyntaxHighlighting()
  " Don't bold variables
  highlight prologVariable cterm=NONE ctermfg=yellow guifg=#FFCB6B gui=NONE

  " But highlight defined predicate names
  highlight prologFunctor cterm=bold ctermfg=14 guifg=#268bd2 gui=bold
endfunction
