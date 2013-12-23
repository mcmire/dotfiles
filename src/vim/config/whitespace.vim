set tabstop=2 shiftwidth=2
augroup local
  autocmd FileType {ruby,css,javascript,coffee,html,xml,markdown,ghmarkdown,js,haml,sh,eruby,scss,vim,stylus,jade} set softtabstop=2 expandtab
augroup END

set list listchars=tab:⊢—,trail:⋅,nbsp:⋅,eol:¬,extends:⨠

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
endfunction
nnoremap <Leader>tw :call TrimWhiteSpace()<CR>

" Highlight leading tabs
highlight Indentation ctermfg=237
function! MatchIndentation()
  match Indentation /^\t\+/
endfunction
augroup local
  autocmd ColorScheme,BufWinEnter,BufEnter,BufLeave,InsertEnter,InsertLeave * call MatchIndentation()
augroup END
