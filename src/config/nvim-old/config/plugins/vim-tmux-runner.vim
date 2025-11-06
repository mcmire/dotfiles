" Configuration for vim-tmux-runner
" =================================

" Here we configure [vim-tmux-runner] so that before a command gets run, the
" prompt within the Tmux pane in question is cleared:
"
" [vim-tmux-runner]: https://github.com/christoomey/vim-tmux-runner

let g:VtrClearSequence = "clear"

" We map `,vor` so that we can easily open a tmux pane to the right within Vim.
" This is useful for running tests.

nmap <leader>vor :VtrOpenRunner({'orientation': 'h', 'percentage': 36})<CR>

" We also map `,vkr` so that we can close this pane.

nmap <leader>vkr :VtrKillRunner<CR>

" We also map `,vap` so that we can attach to an already opened pane.

nmap <leader>vap :VtrAttachToPane<CR>

" Finally, let's go ahead and try to attach to a running pane when Vim starts to
" reduce friction.

function! s:VtrAttachToPaneIfNecessary() abort
  if !exists('s:vtr_attached')
    exec ':VtrAttachToPane'
    let s:vtr_attached = 1
  endif
endfunction

"augroup local
  "autocmd BufRead * call s:VtrAttachToPaneIfNecessary()
"augroup END
