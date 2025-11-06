" Configuration for Ack.vim
" =========================

" [Ag] is used to search through projects, but in a roundabout way. Here we
" actually use [Ack.vim], as it's more maintained, but we just override it to
" use Ag:
"
" [Ag]: https://github.com/ggreer/the_silver_searcher
" [Ack.vim]: https://github.com/mileszs/ack.vim

let g:ackprg = 'ag --vimgrep --path-to-ignore ~/.ignore'

" By default, `:Ack` will jump to the first result automatically, but `:Ack!`
" won't, so we simply remap it:

cnoreabbrev Ack Ack!
