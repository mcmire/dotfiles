" Configuration for Copilot
" =========================

augroup local
  # Turn off Copilot until we need it
  autocmd BufNewFile,BufRead let b:copilot_enabled = v:false
augroup END
