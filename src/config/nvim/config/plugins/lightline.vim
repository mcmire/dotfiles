" Configuration for lightline
" =========================

" We configure the look of [lightline]:
"
" [lightline]: https://github.com/itchyny/lightline.vim

let g:lightline = {
      \   'colorscheme': 'solarized',
      \   'active': {
      \     'left': [
      \       ['mode', 'paste'],
      \       ['readonly', 'relativepath', 'modified']
      \     ],
      \     'right': [
      \       ['lineinfo'],
      \       ['percent'],
      \       ['fileformat', 'fileencoding', 'filetype']
      \     ]
      \   }
      \ }

" We tell Vim to always show a status line (which Airline replaces) regardless
" of how many windows are visible, otherwise Airline only appears for split
" windows:

set laststatus=2

" Since Airline already shows the mode, hide the mode that Vim displays by
" default (e.g. `--- INSERT ---`):

set noshowmode
