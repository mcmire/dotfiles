set tabstop=2 shiftwidth=2 softtabstop=2 expandtab

set list listchars=tab:⊢—,trail:⋅,nbsp:⋅,extends:⨠

set showbreak=‣

" Highlight trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
augroup local
  autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
  autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
  autocmd InsertLeave * match ExtraWhitespace /\s\+$/
  autocmd BufWinLeave * call clearmatches()
augroup END

" Provide an easy way to trim whitespace
" This used to happen automatically, but this may create unnecessary changes
"  in Git if other people don't do this.
" This is why we highlight trailing whitespace above :)
" Copied from <http://vim.wikia.com/wiki/Remove_unwanted_spaces>
function! TrimWhiteSpace()
  %s/\s*$//
  exec "''"
endfunction
nnoremap <Leader>tw :call TrimWhiteSpace()<CR>

hi SpecialKey ctermfg=237
