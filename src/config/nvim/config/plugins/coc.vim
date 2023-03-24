" Configuration for Coc
" =====================

"\ 'coc-prettier',
"\ 'coc-css',
" Use coc-tsserver 1.10.5 to match version of coc in June 2022
let g:coc_global_extensions = [
      \ 'coc-eslint',
      \ 'coc-json',
      \ 'coc-rust-analyzer',
      \ 'coc-tsserver@1.10.5',
      \ 'coc-stylelintplus',
      \ ]

function! s:ShowDocumentation() abort
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    silent call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> <Leader>d <Plug>(coc-diagnostic-info)
nmap <Leader>ca <Plug>(coc-codeaction-cursor)
nmap <Leader>cr <Plug>(coc-rename)
nmap <Leader>cf <Plug>(coc-fix-current)
nmap <silent> K :call <SID>ShowDocumentation()<CR>

" Enable scrolling in floating windows (e.g. TypeScript errors)

nnoremap <expr><down> coc#float#has_scroll() ? coc#float#scroll(1) : "\<down>"
nnoremap <expr><up> coc#float#has_scroll() ? coc#float#scroll(0) : "\<up>"
