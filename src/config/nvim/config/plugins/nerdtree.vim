" Configuration for NERDTree
" ==========================

" `,tt` toggles the [NERDTree]:
"
" [NERDTree]: https://github.com/scrooloose/nerdtree

nnoremap <silent> <Leader>tt :NERDTreeToggle<CR>

" `,tf` tells NERDTree to open the tree and jump to the file that's currently
" open. To get this to work properly, we first open the NERDTree in the current
" working directory, then we jump to the file; this way the find doesn't change
" the root directory that the tree is set to.

nnoremap <silent> <Leader>tf :NERDTree<CR><C-w>p:NERDTreeFind<CR>

" We tell NERDTree to ignore `.pyc` (Python), `.rbc` (Rubinius), and swap files
" by default:

let NERDTreeIgnore=['\.pyc$', '\.rbc$', '\~$']

" Lastly, we make it so that if the only buffer you have open is a NERDTree and
" you close it, you also close Vim:

augroup local
  autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
augroup END
