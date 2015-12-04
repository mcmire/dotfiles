set textwidth=80

highlight CharsExceedingLineLength ctermbg=125 ctermfg=230

augroup local
  autocmd FileType gitcommit set textwidth=72
  autocmd BufNewFile * :call HighlightCharsExceedingLineLength()
  autocmd BufRead * :call HighlightCharsExceedingLineLength()
augroup END

function! HighlightCharsExceedingLineLength()
  call matchadd('CharsExceedingLineLength', '\%>80v.\+', -1)
endfunction
