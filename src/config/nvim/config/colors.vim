" Color settings
" ==============

" While there are certainly many color schemes available for Vim, this
" configuration makes use of [Solarized]. This color scheme was meticulously
" designed from the start to look good in both dark and light modes using color
" theory -- instead of mere eyeballing -- in order to create a harmonious
" palette.
"
" [Solarized]: http://ethanschoonover.com/solarized
"
" Solarized has two modes: dark and light. The colors between them are are
" mostly the same except for four colors which trade places with each other. The
" common set of colors are:
"
" | color   | cterm |
" |---------|-------|
" | yellow  |     3 |
" | orange  |     9 |
" | red     |     1 |
" | magenta |     5 |
" | violet  |    13 |
" | blue    |     4 |
" | cyan    |     6 |
" | green   |     2 |
"
" Dark mode has these additional colors:
"
" | color  | cterm | usage            |
" |--------|-------|------------------|
" | base00 |    11 |                  |
" | base01 |    10 |                  |
" | base02 |     0 |                  |
" | base03 |     8 | text background  |
" | base0  |    12 | text foreground  |
" | base1  |    14 |                  |
" | base2  |     7 |                  |
" | base3  |    15 |                  |
"
" Whereas light mode uses these colors:
"
" | color  | cterm | usage            |
" |--------|-------|------------------|
" | base00 |    12 |                  |
" | base01 |    14 |                  |
" | base02 |     7 |                  |
" | base03 |    15 | text background  |
" | base0  |    11 | text foreground  |
" | base1  |    10 |                  |
" | base2  |     0 |                  |
" | base3  |     8 |                  |
"
" (The full list of colors in the colorscheme are located [here][color-values].)
"
" [color-values]: https://github.com/altercation/solarized/blob/e40cd4130e2a82f9b03ada1ca378b7701b1a9110/vim-colors-solarized/colors/solarized.vim#L91
"
" Both modes have their uses. We assume that you'll be indoors and that you'll
" want to use dark mode most of the time. But you may find yourself outdoors and
" in this case light mode may be more handy.
"
" Here we make it possible to switch between the two easily. First, we define a
" couple of functions:

function! s:UseColorScheme(type)
  if a:type == "light"
    let s:color_scheme_type="light"
    set background=light
    silent! colorscheme solarized
    let g:airline_theme="solarized"
    let g:airline_solarized_bg="light"
    " fg=base1, bg=base3
    highlight SpecialKey guifg=#93a1a1 guibg=#fdf6e3
    " bg=base3
    highlight SignColumn guibg=#fdf6e3
    " fg=base3, bg=red
    highlight ExtraWhitespace guifg=#fdf6e3 guibg=#dc322f
    " fg=base3, bg=red
    highlight CharsExceedingLineLength guifg=#fdf6e3 guibg=#dc322f
    " fg=base3, bg=orange
    highlight IncSearch guifg=#fdf6e3 guibg=#cb4b16
  else
    let s:color_scheme_type="dark"
    set background=dark
    silent! colorscheme solarized
    let g:airline_theme="solarized"
    let g:airline_solarized_bg="dark"
    " fg=base01, bg=base03
    highlight SpecialKey guifg=#586e75 guibg=#002b36
    " bg=base03
    highlight SignColumn guibg=#002b36
    " fg=base03, bg=red
    highlight ExtraWhitespace guifg=#002b36 guibg=#dc322f
    " fg=base03, bg=red
    highlight CharsExceedingLineLength guifg=#002b36 guibg=#dc322f
    " fg=base03, bg=orange
    highlight IncSearch guifg=#002b36 guibg=#cb4b16
  end

endfunction

function! s:ToggleColorScheme()
  if s:color_scheme_type == "dark"
    call s:UseColorScheme("light")
  else
    call s:UseColorScheme("dark")
  endif
endfunction

" But you can use `,th` to flip between the two modes:

command! -nargs=0 ToggleColorScheme call s:ToggleColorScheme()
nnoremap <Leader>th :ToggleColorScheme<CR>

" Enable RGB color support:

set termguicolors

" and set dark mode as the default:

call s:UseColorScheme("dark")
