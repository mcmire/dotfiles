" Configuration for miniyank
" ===========================

" Pasting a block selection in Neovim is broken[1], so use the miniyank plugin
" to fix this.
"
" [1]: https://github.com/neovim/neovim/issues/1822#issuecomment-233152833

map p <Plug>(miniyank-startput)
map P <Plug>(miniyank-startPut)
