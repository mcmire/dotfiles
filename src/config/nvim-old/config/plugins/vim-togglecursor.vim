" Configuration for vim-togglecursor
" ==================================

" We configure [togglecursor] so that the default cursor is a non-blinking block
" in Command mode and a non-blinking vertical line in Insert mode.
"
" [togglecursor]: https://github.com/jszakmeister/vim-togglecursor

let g:togglecursor_default = 'block'
let g:togglecursor_insert = 'line'
let g:togglecursor_leave = 'block'
