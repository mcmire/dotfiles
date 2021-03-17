" Configuration for FastFold
" ==========================

" Usually setting foldmethod=syntax is a recipe for making Vim slow to a crawl.
" This is because Vim will compute folds as you are inserting text. FastFold
" overrides this behavior so that this computing happens at less frequent and
" more logical intervals. By default, this is:
"
" * when a file is saved
" * when zx, zX, za, zA, etc. are used
" * when ]z, [z, etc. are used

" But we also map ,ffu so we can manually compute folds as well:
nmap <Leader>ffu <Plug>(FastFoldUpdate)

" Furthermore, FastFold has to be enabled for specific file types, such as:

" ...Ruby
let g:ruby_fold = 1
" ...JavaScript
let g:javaScript_fold = 1
" ...XML
let g:xml_syntax_folding = 1

" ...and disabled for Elm, where it really doesn't work right:

let g:fastfold_skip_filetypes=['elm']

" Finally, these two mappings add text objects for folds:
xnoremap iz :<c-u>FastFoldUpdate<cr><esc>:<c-u>normal! ]zv[z<cr>
xnoremap az :<c-u>FastFoldUpdate<cr><esc>:<c-u>normal! ]zV[z<cr>
