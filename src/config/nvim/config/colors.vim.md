*(← Back to [index](../README.md))*

# Color settings

I use [Solarized] as my color scheme. While it isn't perfect -- namely, the
contrast between the colors could be higher -- it is the only color scheme as
far as I know that was designed from the start to look good in both dark and
light modes and whose colors were set using color theory techniques instead of
mere eyeballing. (I also use it in my terminal as well.)

[Solarized]: http://ethanschoonover.com/solarized

The full list of colors in the colorscheme are located [here][color-values].

[color-values]: https://github.com/altercation/solarized/blob/e40cd4130e2a82f9b03ada1ca378b7701b1a9110/vim-colors-solarized/colors/solarized.vim#L91

Usually I use the dark mode, but when I'm outside or in a sunny place, I'll use
light mode. It's helpful to be able to switch between the two, so first we start
off with a few functions to do just that:

``` vim
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
  " FIXME
  highlight SpecialKey ctermfg=237
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
  highlight SpecialKey ctermfg=237
endfunction

function! s:ToggleColorScheme()
  if s:color_scheme_type == "dark"
    call s:UseLightColorScheme()
  else
    call s:UseDarkColorScheme()
  endif
endfunction
```

We set dark mode as the default:

```
call s:UseDarkColorScheme()
```

The `ToggleColorScheme` command (or <kbd>,</kbd><kbd>t</kbd><kbd>h</kbd>) will safdlkjsdlfkj
flip between the two modes:

```
command! -nargs=0 ToggleColorScheme call s:ToggleColorScheme()
nnoremap <Leader>th :ToggleColorScheme<CR>
```

It's helpful to highlight the current line so we know where we are at any given
time:

``` vim
set cursorline
```

We highlight extra whitespace (tagged in our [whitespace settings])
using the Solarized red color:

[whitespace settings]: whitespace.vim.md

``` vim
highlight ExtraWhitespace ctermbg=160 ctermfg=230
```

We highlight characters that exceed the line length (tagged in our [line
width settings]) also using Solarized red:

[line width settings]: line-width.vim.md

``` vim
highlight CharsExceedingLineLength ctermbg=125 ctermfg=230
```
