" Configuration for lists.vim
" ===========================

" Add more convenient mappings for moving a list item up or down
nnoremap <C-S-k> :ListsMoveUp<CR>
nnoremap <C-S-j> :ListsMoveDown<CR>
nnoremap <M-k> :ListsMoveUp<CR>
nnoremap <M-j> :ListsMoveDown<CR>

" Enable list management automatically in Markdown files
augroup local
  autocmd FileType ghmarkdown :ListsEnable
augroup END
