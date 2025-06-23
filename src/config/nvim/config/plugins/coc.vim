" Configuration for Coc
" =====================

" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable delays
" and poor user experience
set updatetime=300

" TODO: Bring these back, we had problems with them in the past
"\ 'coc-css',
"\ 'yaegassy/coc-astro',
let g:coc_global_extensions = [
      \ 'coc-deno',
      \ 'coc-eslint',
      \ 'coc-json',
      \ 'coc-prettier',
      \ 'coc-rust-analyzer',
      \ 'coc-tsserver',
      \ 'coc-stylelintplus'
      \ ]

" Tell CoC that files with a filetype of "ghmarkdown" are Markdown files, so
" that Prettier will run automatically for those files
let g:coc_filetype_map = {
      \ 'ghmarkdown': 'markdown',
      \ }

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for applying code actions at the cursor position
nmap <Leader>ca <Plug>(coc-codeaction-cursor)

" Symbol renaming
nmap <Leader>cr <Plug>(coc-rename)

" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <Leader>cf <Plug>(coc-fix-current)

" Format entire file
nmap <leader>cF <Plug>(coc-format)

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')

" Pop up documentation window for the current symbol
nmap <silent> K :call <SID>ShowDocumentation()<CR>

" Show diagnostic info for the current buffer
nmap <silent> <Leader>d <Plug>(coc-diagnostic-info)

" Enable scrolling in floating windows (e.g. TypeScript errors)
nmap <expr><down> coc#float#has_scroll() ? coc#float#scroll(1) : "\<down>"
nmap <expr><up> coc#float#has_scroll() ? coc#float#scroll(0) : "\<up>"

" Ctrl-\ triggers completion
imap <silent><expr> <c-\> coc#pum#visible() ? coc#pum#confirm() : coc#refresh()

function! s:ShowDocumentation() abort
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    silent call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction
