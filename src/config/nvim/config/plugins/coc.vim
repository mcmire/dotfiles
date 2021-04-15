" Configuration for Coc
" =====================

let g:coc_global_extensions = [
  \ 'coc-tsserver',
  \ 'coc-prettier',
  \ 'coc-json'
  \ ]

"function! s:EnableCocGlobalExtensions() abort
  "let eslint_config_files = globpath('.', '.eslintrc*', 0, 1)

  "if len(l:eslint_config_files) > 0 && len(join(readfile(l:eslint_config_files[0], '', 1), '\n')) > 0
    "" TODO: this will add eslint globally, is that what we want?
    "let g:coc_global_extensions += ['coc-eslint']
  "elseif isdirectory('./node_modules') && isdirectory('./node_modules/prettier')
    "" TODO: this will add prettier globally, is that what we want?
    "let g:coc_global_extensions += ['coc-prettier']
  "endif
"endfunction

function! ShowDocIfNoDiagnostic(timer_id) abort
  if (coc#util#has_float() == 0)
    silent call CocActionAsync('doHover')
  endif
endfunction

function! s:ShowHoverDoc() abort
  call timer_start(500, 'ShowDocIfNoDiagnostic')
endfunction

augroup local
  "autocmd FileType javascript call s:EnableCocGlobalExtensions()
  "autocmd FileType jsx call s:EnableCocGlobalExtensions()
  "autocmd FileType ruby call s:EnableCocGlobalExtensions()
  "autocmd FileType typescript call s:EnableCocGlobalExtensions()
  "autocmd FileType tsx call s:EnableCocGlobalExtensions()
  "autocmd FileType typescriptreact call s:EnableCocGlobalExtensions()

  " When cursoring over a word, if there is a diagnostic, show it, otherwise
  " show the documentation
  " Source: <https://thoughtbot.com/blog/modern-typescript-and-react-development-in-vim>
  "autocmd CursorHoldI * call s:ShowHoverDoc()
  "autocmd CursorHold * call s:ShowHoverDoc()
augroup END

nnoremap <silent> gd <Plug>(coc-definition)
"nnoremap <silent> gt <Plug>(coc-type-definition)
nnoremap <silent> gr <Plug>(coc-references)
nnoremap <silent> [g <Plug>(coc-diagnostic-prev)
nnoremap <silent> ]g <Plug>(coc-diagnostic-next)
nnoremap <silent> <Leader>cd :<C-u>CocList diagnostics<CR>
" TODO: This currently conflicts with NERDCommenter
"nnoremap <silent> <Leader>cs :<C-u>CocList -I symbols<cr>
nnoremap <Leader>ca <Plug>(coc-codeaction)
nnoremap <leader>cr <Plug>(coc-rename)
nnoremap <leader>cf <Plug>(coc-fix-current)
