" Configuration for vim-tmux-runner
" =================================

" Here we configure [vim-tmux-runner] so that before a command gets run, the
" prompt within the Tmux pane in question is cleared:
"
" [vim-tmux-runner]: https://github.com/christoomey/vim-tmux-runner

let g:VtrClearSequence = "clear"

" We map `,roh` and `,rov` so that we can easily open a tmux pane within Vim.
" `,roh` creates a horizontal split and `,rov` creates a vertical split.

nmap <leader>roh :VtrOpenRunner({'orientation': 'h', 'percentage': 33})<CR>
nmap <leader>rov :VtrOpenRunner({'orientation': 'v', 'percentage': 20})<CR>

" We also map `,roc` so that we can close this pane.

nmap <leader>roc :VtrKillRunner<CR>
