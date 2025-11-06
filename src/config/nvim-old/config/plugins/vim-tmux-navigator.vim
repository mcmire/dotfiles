" Configuration for vim-tmux-navigator
" ====================================

" [vim-tmux-navigator] has perfectly sane default mappings; however, if you
" re-source your Vim configuration (say, after modifying it) then these mappings
" will go away. So here we redefine them:
"
" [vim-tmux-navigator]: https://github.com/christoomey/vim-tmux-navigator

let g:tmux_navigator_no_mappings = 1

"if exists("g:loaded_tmux_navigator")
  nmap <silent> <C-h> :TmuxNavigateLeft<cr>
  nmap <silent> <C-j> :TmuxNavigateDown<cr>
  nmap <silent> <C-k> :TmuxNavigateUp<cr>
  nmap <silent> <C-l> :TmuxNavigateRight<cr>
"endif
