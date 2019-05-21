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
" mostly the same except for two sets of four colors which swap places. The
" common set of colors are:

let s:yellow="#b58900"
let s:orange="#cb4b16"
let s:red="#dc322f"
let s:magenta="#d33682"
let s:violet="#6c71c4"
let s:blue="#268bd2"
let s:cyan="#2aa198"
let s:green="#859900"

" The remaining colors are listed below. (The full list of colors in the
" colorscheme are located [here][color-values].)
"
" [color-values]: https://github.com/altercation/solarized/blob/e40cd4130e2a82f9b03ada1ca378b7701b1a9110/vim-colors-solarized/colors/solarized.vim#L91
"
" Both modes have their uses. We assume that you'll be indoors and that you'll
" want to use dark mode most of the time. But you may find yourself outdoors and
" in this case light mode may be more handy. So we provide a way to switch
" between the two easily.

" First, we enable RGB color support. This lets us use hex codes for colors
" instead of numbers:

set termguicolors

" Then we define a few functions:

function! s:UseDarkColorScheme()
  let s:base03="#002b36"
  let s:base02="#073642"
  let s:base01="#586e75"
  let s:base00="#657b83"
  let s:base0="#839496"
  let s:base1="#93a1a1"
  let s:base2="#eee8d5"
  let s:base3="#fdf6e3"

  let s:color_scheme_type="dark"
  set background=dark
  silent! colorscheme solarized
  let g:airline_theme="solarized"
  let g:airline_solarized_bg="dark"

  call s:SetHighlights()
endfunction

function! s:UseLightColorScheme()
  let s:base3="#002b36"
  let s:base2="#073642"
  let s:base1="#586e75"
  let s:base0="#657b83"
  let s:base00="#839496"
  let s:base01="#93a1a1"
  let s:base02="#eee8d5"
  let s:base03="#fdf6e3"

  let s:color_scheme_type="light"
  set background=light
  silent! colorscheme solarized
  let g:airline_theme="solarized"
  let g:airline_solarized_bg="light"

  call s:SetHighlights()
endfunction

function! s:SetHighlights()
  exec 'highlight SpecialKey guifg=' . s:base1 . ' guibg=' . s:base3
  exec 'highlight SignColumn guibg=' . s:base3
  exec 'highlight ExtraWhitespace guifg=' . s:base3 . ' guibg=' . s:red
  exec 'highlight CharsExceedingLineLength guifg=' . s:base3 . ' guibg=' . s:red
  exec 'highlight IncSearch cterm=NONE gui=NONE guifg=' . s:base03 . ' guibg=' . s:yellow
  exec 'highlight Search cterm=NONE gui=NONE guifg=' . s:base03 . ' guibg=' . s:orange
  exec 'highlight MatchParen guifg=' . s:base03 . ' guibg=' . s:base01
endfunction

function! s:ToggleColorScheme()
  if s:color_scheme_type == "dark"
    call s:UseLightColorScheme()
  else
    call s:UseDarkColorScheme()
  endif
endfunction

" We set up a mapping so you can use `,th` to flip between the two modes:

command! -nargs=0 ToggleColorScheme call s:ToggleColorScheme()
nnoremap <Leader>th :ToggleColorScheme<CR>

" Finally, we set dark mode as the default:

call s:UseDarkColorScheme()
