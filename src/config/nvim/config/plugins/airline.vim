" Configuration for Airline
" =========================

" We configure the look of [Airline]:
"
" [Airline]: https://github.com/vim-airline/vim-airline

let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols_branch = ''
let g:airline_symbols_readonly = ''
let g:airline_symbols_linenr = ''

" We tell Vim to always show a status line (which Airline replaces) regardless
" of how many windows are visible, otherwise Airline only appears for split
" windows:

set laststatus=2

" Since Airline already shows the mode, hide the mode that Vim displays by
" default (e.g. `--- INSERT ---`):

set noshowmode
