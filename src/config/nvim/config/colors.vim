" Solarized color values:
" https://github.com/altercation/vim-colors-solarized/blob/master/colors/solarized.vim#L91

function! s:UseLightTheme()
  let s:color_scheme_type="light"
  set background=light
  silent! colorscheme solarized
  hi ColorColumn guibg=#c0c0c0 ctermbg=231
  let g:airline_theme="solarized"
endfunction

function! s:UseDarkTheme()
  let s:color_scheme_type="dark"
  set background=dark
  silent! colorscheme solarized
  hi ColorColumn guibg=#17191A ctermbg=234
  let g:airline_theme="solarized"
endfunction

function! s:ToggleTheme()
  if s:color_scheme_type == "dark"
    call s:UseLightTheme()
  else
    call s:UseDarkTheme()
  endif
endfunction

command! -nargs=0 ToggleTheme call s:ToggleTheme()

nnoremap <Leader>th :ToggleTheme<CR>

" The terminal has 256 color support
set t_Co=256

" Set color column (git, normal, long, longer)
set colorcolumn=72,80,100,120

" Highlight the current line
set cursorline

" Set default theme
call s:UseDarkTheme()

highlight ColorColumn ctermbg=0
highlight SignColumn ctermbg=0
highlight LineNr ctermbg=0
