" The terminal has 256 color support
set t_Co=256

" Color scheme type
let s:color_scheme_type="dark"

" Set color scheme
if s:color_scheme_type == "dark"
  silent! colorscheme molokai
else
  set background=light
  silent! colorscheme earendel
endif

" Set color column
set colorcolumn=72,80,100,120
if s:color_scheme_type == "dark"
  hi ColorColumn guibg=#17191A ctermbg=234
else
  hi ColorColumn guibg=#c0c0c0 ctermbg=234
endif

set cursorline
