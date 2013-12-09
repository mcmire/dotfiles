" Copied from <http://vim.wikia.com/wiki/Remove_unwanted_spaces>
function! TrimWhiteSpace()
  %s/\s*$//
endfunction

nnoremap <Leader>tw :call TrimWhiteSpace()<CR>
