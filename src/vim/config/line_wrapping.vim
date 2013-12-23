" Soft wrap lines
set wrap linebreak

" Disable two-space joins
set nojoinspaces

" Turn off some line specific stuff that is annoying
" Using autocmd here since formatoptions may be specified by the
" filetype - you can see what these options are with :h fo-table
set formatoptions=tcroqvb
augroup local
  autocmd FileType * setl formatoptions=tcroqvb
augroup END

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
