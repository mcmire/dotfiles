set tabstop=2 shiftwidth=2
augroup local
  autocmd FileType {ruby,css,javascript,coffee,html,xml,markdown,ghmarkdown,js,haml,sh,eruby,scss,vim,stylus,jade} set softtabstop=2 expandtab
augroup END

set list listchars=tab:⊢—,trail:⋅,nbsp:⋅,eol:¬,extends:⨠

" Disable two-space joins
set nojoinspaces

set wrap linebreak showbreak=‣

" In Clojure, words that contains dots are usually namespaces
" Source: <http://stackoverflow.com/questions/225266/customising-word-separators-in-vi>
augroup local
  autocmd FileType clojure set iskeyword-=.
augroup END

" For wrapped lines, jump to the next row rather than the next line
nnoremap j gj
vnoremap j gj
nnoremap k gk
vnoremap k gk

" Toggle hard wrap
let g:old_textwidth = 0
function! ToggleHardWrap()
  if &textwidth
    let g:old_textwidth = &textwidth
    let &textwidth = 0
  else
    let &textwidth = g:old_textwidth
  endif
endfunction
noremap <Leader>ww :call ToggleHardWrap()<CR>

" Make it easy to toggle wrapping
map <Leader>wi :set invwrap<CR>

" Highlight trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
augroup local
  autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
  autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
  autocmd InsertLeave * match ExtraWhitespace /\s\+$/
  autocmd BufWinLeave * call clearmatches()
augroup END

" Highlight leading indentation
highlight Indentation ctermfg=235
augroup local
  " I don't know why we have to do this
  autocmd BufWinEnter * match Indentation /^\s\+/
  autocmd InsertEnter * match Indentation /^\s\+/
  autocmd InsertLeave * match Indentation /^\s\+/
augroup END
