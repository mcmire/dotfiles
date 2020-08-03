" Configuration for neco-ghc
" ==========================

" Here we configure tab completion for Haskell files:

let g:haskellmode_completion_ghc = 1
autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc
