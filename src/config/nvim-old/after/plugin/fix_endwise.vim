" The vim-lua plugin breaks endwise. This makes it work again.
" Source: <https://github.com/tbastos/vim-lua/issues/10>
augroup local
  autocmd FileType lua
        \ let b:endwise_syngroups = b:endwise_syngroups . ',luaFuncKeyword'
augroup END
