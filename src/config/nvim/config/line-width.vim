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

" COPIED
set textwidth=80

" However, for Git commit messages, Tim Pope [recommends][git-line-length] using
" a line length of 72 characters, and GitHub's UI -- likely inspired by Mr. Pope
" -- also assumes this length as well when it displays messages for individual
"  commits. So we set this as well:
"
" [git-line-length]: http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html

" COPIED
augroup local
  autocmd FileType gitcommit setl textwidth=72
augroup END

" We also set a width of 100 for Cucumber files since those tend to run longer
" than your average Ruby file:

" COPIED
augroup local
  autocmd FileType cucumber setl textwidth=100
augroup END

" Whatever the textwidth is set to, we draw a vertical line at that width (the
" color for which is defined in [colors]):
"
" [colors]: ./colors.vim
" COPIED
set colorcolumn=+0
