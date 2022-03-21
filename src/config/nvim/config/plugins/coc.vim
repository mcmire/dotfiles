" Configuration for Coc
" =====================

"\ 'coc-prettier',
let g:coc_global_extensions = [
      \ 'coc-eslint',
      \ 'coc-json',
      \ 'coc-tsserver',
      \ 'coc-stylelintplus',
      \ 'coc-css',
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
nmap <silent> <Leader>cd :<C-u>CocList diagnostics<CR>
" TODO: This currently conflicts with NERDCommenter
"nnoremap <silent> <Leader>cs :<C-u>CocList -I symbols<cr>
"nnoremap <Leader>ca <Plug>(coc-codeaction)
nmap <Leader>cr <Plug>(coc-rename)
nmap <Leader>cf <Plug>(coc-fix-current)
nmap <silent> K :call <SID>ShowDocumentation()<CR>

" Enable scrolling in floating windows (e.g. TypeScript errors)

nnoremap <expr><down> coc#float#has_scroll() ? coc#float#scroll(1) : "\<down>"
nnoremap <expr><up> coc#float#has_scroll() ? coc#float#scroll(0) : "\<up>"
