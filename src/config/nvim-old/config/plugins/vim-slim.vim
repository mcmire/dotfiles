" Configuration for vim-slim
" ==========================

" `smartindent` messes things up for Slim files, so we disable that:

augroup local
  autocmd FileType slim setl nosmartindent
augroup END
