" Configuration for NERDCommenter
" ===============================

" [NERDCommenter] has trouble applying Ruby comments for some reason, so we help
" it out:
"
" [NERDCommenter]: https://github.com/scrooloose/nerdcommenter

let g:NERDCustomDelimiters = {
      \ 'ruby': { 'left': '# ' }
      \ }
