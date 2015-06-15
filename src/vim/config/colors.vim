function! s:UseLightTheme()
  let s:color_scheme_type="light"
  set background=light
  silent! colorscheme earendel
  hi ColorColumn guibg=#c0c0c0 ctermbg=231
endfunction

function! s:UseDarkTheme()
  let s:color_scheme_type="dark"
  silent! colorscheme molokai
  hi ColorColumn guibg=#17191A ctermbg=234
endfunction

function! s:ToggleTheme()
  if s:color_scheme_type == "dark"
    call s:UseLightTheme()
  else
    call s:UseDarkTheme()
  endif
endfunction

command! -nargs=0 ToggleTheme call s:ToggleTheme()

" The terminal has 256 color support
set t_Co=256

" Set color column (git, normal, long, longer)
set colorcolumn=72,80,100,120

" Highlight the current line
set cursorline

" Set default theme
call s:UseDarkTheme()
