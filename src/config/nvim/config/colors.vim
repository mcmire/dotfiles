" Solarized color values:
" https://github.com/altercation/vim-colors-solarized/blob/master/colors/solarized.vim#L91

function! s:UseLightColorScheme()
  let s:color_scheme_type="light"
  set background=light
  silent! colorscheme solarized
  let g:airline_theme="solarized"
  let g:airline_solarized_bg="dark"
  highlight ColorColumn ctermbg=7
  highlight SignColumn ctermbg=7
  highlight LineNr ctermbg=7
  highlight MatchParen ctermbg=13 ctermfg=7
endfunction

function! s:UseDarkColorScheme()
  let s:color_scheme_type="dark"
  set background=dark
  silent! colorscheme solarized
  let g:airline_theme="solarized"
  let g:airline_solarized_bg="light"
  highlight ColorColumn ctermbg=0
  highlight SignColumn ctermbg=0
  highlight LineNr ctermbg=0
  highlight MatchParen ctermbg=13 ctermfg=0
endfunction

function! s:ToggleColorScheme()
  if s:color_scheme_type == "dark"
    call s:UseLightColorScheme()
  else
    call s:UseDarkColorScheme()
  endif
endfunction

command! -nargs=0 ToggleColorScheme call s:ToggleColorScheme()

nnoremap <Leader>th :ToggleColorScheme<CR>

" The terminal has 256 color support
set t_Co=256

" Set color column (git, normal, long, longer)
set colorcolumn=72,80,100,120

" Highlight the current line
set cursorline

" Set default theme
call s:UseDarkColorScheme()
