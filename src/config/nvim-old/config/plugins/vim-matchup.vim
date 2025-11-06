" Configuration for vim-matchup
" =============================

" [vim-matchup] can be slow on large files, so we attempt to mitigate that here
" by deferring highlighting:
"
" [vim-matchup]: https://github.com/andymass/vim-matchup

let g:matchup_matchparen_deferred = 1
