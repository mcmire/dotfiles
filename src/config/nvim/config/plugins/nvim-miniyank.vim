" Configuration for miniyank
" ===========================

" Pasting a block selection in Neovim is broken[1], so use the miniyank plugin
" to fix this.
"
" [1]: https://github.com/neovim/neovim/issues/1822#issuecomment-233152833

map <Leader>pb <Plug>(miniyank-startput)
map <Leader>Pb <Plug>(miniyank-startPut)
