" Color settings
" ==============

" While there are certainly many color schemes available for Vim, this
" configuration makes use of [Solarized]. This color scheme was meticulously
" designed from the start to look good in both dark and light modes using color
" theory -- instead of mere eyeballing -- in order to create a harmonious
" palette.
"
" [Solarized]: http://ethanschoonover.com/solarized

" The very first thing we want to do is to enable RGB or "truecolor" support.
" This looks like a simple setting, but Neovim is only one part of the equation
" here. First we assume that you are using a terminal that already supports
" truecolor and have set it up appropriately already if necessary (iTerm2 is
" recommended as it already does just fine without having to do anything
" special). Second, we want to make this work inside of a tmux session, so we
" assume that tmux has been set up correctly as well.
"
" With that in mind, the following setting turns on truecolor mode in Neovim.
" This means that we can use hex codes for colors instead of numbers. It also
" means that any time we use `colorscheme` below and are setting foreground and
" background colors for things, we will want to make sure to use `guifg` and
" `guibg` instead of `ctermfg` and `ctermbg`.
"
" (For more on truecolor support in Neovim, say `:h true-color`. `:h terminfo`
" is also useful as well.)
"
" TODO: Use <https://github.com/lifepillar/vim-solarized8> which does all of
" this crap for us

set termguicolors

" We can use this function to verify truecolor support:

function! VimColorTest(outfile, fgend, bgend)
  let result = []
  for fg in range(a:fgend)
    for bg in range(a:bgend)
      let kw = printf('%-7s', printf('c_%d_%d', fg, bg))
      let h = printf('hi %s ctermfg=%d ctermbg=%d', kw, fg, bg)
      let s = printf('syn keyword %s %s', kw, kw)
      call add(result, printf('%-32s | %s', h, s))
    endfor
  endfor
  call writefile(result, a:outfile)
  execute 'edit '.a:outfile
  source %
endfunction

command! VimColorTest call VimColorTest('/tmp/vim-color-test.tmp', 255, 255)

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
"
" We'll define a few functions:

function! s:Chomp(string)
  return substitute(a:string, '\n\+$', '', '')
endfunction

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
  exec 'highlight SpecialKey guifg=' . s:base1 . ' guibg=' . s:base03
  exec 'highlight SignColumn guibg=' . s:base03
  exec 'highlight ExtraWhitespace guifg=' . s:base3 . ' guibg=' . s:red
  exec 'highlight CharsExceedingLineLength guifg=' . s:base3 . ' guibg=' . s:red
  exec 'highlight IncSearch cterm=NONE gui=NONE guifg=' . s:base03 . ' guibg=' . s:yellow
  exec 'highlight Search cterm=NONE gui=NONE guifg=' . s:base03 . ' guibg=' . s:orange
  exec 'highlight MatchParen guifg=' . s:base03 . ' guibg=' . s:base01
  exec 'highlight default MarkologyHLl guifg=' . s:base01 . ' guibg=' . s:base03
  exec 'highlight default MarkologyHLu guifg=' . s:base01 . ' guibg=' . s:base03
  exec 'highlight default MarkologyHLo guifg=' . s:base01 . ' guibg=' . s:base03
  exec 'highlight default MarkologyHLm guifg=' . s:base01 . ' guibg=' . s:base03
endfunction

function! s:ToggleColorScheme()
  " Switch the global color scheme mode, tell iTerm and tmux to switch,
  " then switch Vim.
  "
  " Roughly inspired by: <https://grrr.tech/posts/2020/switch-dark-mode-os/>

  let new_color_scheme_mode = s:Chomp(system('color-scheme-mode --toggle'))
  call system('propagate-color-scheme-mode')
  call RefreshColorScheme(new_color_scheme_mode)
endfunction

function! g:RefreshColorScheme(color_scheme_mode)
  if a:color_scheme_mode == "dark"
    call s:UseDarkColorScheme()
  elseif a:color_scheme_mode == "light"
    call s:UseLightColorScheme()
  else
    throw "Unknown color scheme mode " . a:color_scheme_mode
  endif
endfunction

" We set up a mapping so you can use `,th` to flip between the two modes:

command! -nargs=0 ToggleColorScheme call s:ToggleColorScheme()
nnoremap <Leader>th :ToggleColorScheme<CR>

" Finally, we determine what the current global color scheme type is ("dark" or
" "light"), and switch to that.

call g:RefreshColorScheme(s:Chomp(system('color-scheme-mode')))
