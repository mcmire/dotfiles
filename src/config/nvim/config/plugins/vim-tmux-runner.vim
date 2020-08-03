" Configuration for vim-tmux-runner
" =================================

" Here we configure [vim-tmux-runner] so that before a command gets run, the
" prompt within the Tmux pane in question is cleared:
"
" [vim-tmux-runner]: https://github.com/christoomey/vim-tmux-runner

let g:VtrClearSequence = "clear"

" We map `,roh` so that we can easily open a tmux pane to the right within Vim.
" This is useful for running tests.

nmap <leader>roh :VtrOpenRunner({'orientation': 'h', 'percentage': 36})<CR>

" We also map `,roc` so that we can close this pane.

nmap <leader>roc :VtrKillRunner<CR>
