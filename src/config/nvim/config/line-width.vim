" Line width settings
" ===================

" This configuration relies on the hopefully not too controversial idea that
" code that contains long lines, lines that cause the reader to scroll
" horizontally, are undesirable.

" In fact, the unofficial Ruby style guide [recommends][ruby-line-length] using
" an 80-character limit. This seems like an appropriate length for most code, so
" we set that across the board:
"
" [ruby-line-length]: https://github.com/bbatsov/ruby-style-guide#80-character-limits

set textwidth=80

" However, for Git commit messages, Tim Pope [recommends][git-line-length] using
" a line length of 72 characters, and GitHub's UI -- likely inspired by Mr. Pope
" -- also assumes this length as well when it displays messages for individual
"  commits. So we set this as well:
"
" [git-line-length]: http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html

augroup local
  autocmd FileType gitcommit setl textwidth=72
augroup END

" We also set a width of 100 for Cucumber files since those tend to run longer
" than your average Ruby file:

augroup local
  autocmd FileType cucumber setl textwidth=100
augroup END

" Whatever the textwidth is set to, we draw a vertical line one column beyond
" that width (the color for which is defined in [colors]):
set colorcolumn=+1

" Finally, when a line exceeds the set `textwidth` we mark the characters that
" are past the limit with the `CharsExceedingLineLength` syntax group. (The
" color for this is also defined in [colors].)

let b:chars_exceeding_line_length_match = 0

function! HighlightCharsExceedingLineLength()
  " Remove the existing match in case textwidth is changed
  if exists('b:chars_exceeding_line_length_match') && b:chars_exceeding_line_length_match > 0
    call matchdelete(b:chars_exceeding_line_length_match)
  end

  let b:chars_exceeding_line_length_match = matchadd('CharsExceedingLineLength', '\%>' . &textwidth . 'v.\+', -1)
endfunction

augroup local
  autocmd BufNewFile * :call HighlightCharsExceedingLineLength()
  autocmd BufRead * :call HighlightCharsExceedingLineLength()
  autocmd OptionSet textwidth :call HighlightCharsExceedingLineLength()
augroup END

" [colors]: colors.vim.md
