" Whitespace settings
" ===================

" This file has a few concerns. First let's start with indentation characters.
" We configure Vim to use soft tabs across the board, where 1 tab = 2 spaces:

" COPIED
set tabstop=2 shiftwidth=2 softtabstop=2 expandtab

" In the event that a file has tabs, we draw attention to them here with a
" special character. We also accentuate a line that has nothing but spaces, as
" well as spaces at the end of a line. Finally, if a line is too long to fit on
" the screen, we add a character at the end to indicate the continuation.

" COPIED
set list
" ALREADY DEFAULT
set listchars=tab:⊢—,trail:⋅,nbsp:⋅,extends:⨠

" By default, when joining two lines with `J`, two spaces will separate
" the lines. This is a holdover from typewriters and we don't need that anymore:

" ALREADY DEFAULT
set nojoinspaces

" `listchars` turns trailing spaces into special characters, but here we tag
" them specifically with the syntax group of `ExtraWhitespace`. The color
" assigned to this group is specified in the [color settings file].
"
" [color settings file]: colors.vim.md

augroup local
  autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
  autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
  autocmd InsertLeave * match ExtraWhitespace /\s\+$/
  autocmd BufWinLeave * call clearmatches()
augroup END

" Finally, here we provide a simple way to trim trailing whitespace in a file
" with `,tw`. (This function was taken from the [Vim
" wiki][remove-unwanted-spaces].)
"
" [remove-unwanted-spaces]: http://vim.wikia.com/wiki/Remove_unwanted_spaces

function! TrimWhiteSpace()
  %s/\s*$//
  exec "''"
endfunction
nnoremap <Leader>tw :call TrimWhiteSpace()<CR>
