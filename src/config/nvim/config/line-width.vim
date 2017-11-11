" Line width settings
" ===================

" I don't like seeing long lines when I read code, so I don't like writing long
" lines, either. The Ruby style guide [recommends][ruby-line-length] using an
" 80-character limit, and I've found this to be an acceptable length, so we set
" that here:
"
" [ruby-line-length]: https://github.com/bbatsov/ruby-style-guide#80-character-limits

set textwidth=80

" However, for Git commit messages, Tim Pope [recommends][git-line-length] using
" a line length of 72 characters, and GitHub's UI also assumes this length as
" well when it displays messages for individual commits (I'm not sure where this
" comes from, but it's likely they took it from Tim Pope). So we set this as
" well:
"
" [git-line-length]: http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html

augroup local
  autocmd FileType gitcommit set textwidth=72
augroup END

" So we use 72 for commit messages and 80 for Ruby files, and generally that
" works great. However for other, more verbose languages, 100 or even 120
" characters may be the standard. For ultimate flexibility, we draw a column at
" all of these points (and the color for this is defined in [colors]):

set colorcolumn=72,80,100,120

" Finally, when a line exceeds the set `textwidth` we mark the characters that
" are past the limit with the `CharsExceedingLineLength` syntax group. (The
" color for this is also defined in [colors].)

function! HighlightCharsExceedingLineLength()
  call matchadd('CharsExceedingLineLength', '\%>' . &textwidth . 'v.\+', -1)
endfunction

augroup local
  autocmd BufNewFile * :call HighlightCharsExceedingLineLength()
  autocmd BufRead * :call HighlightCharsExceedingLineLength()
augroup END

" [colors]: colors.vim.md
