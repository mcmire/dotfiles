*(← Back to [index](../README.md))*

# Color settings

I use [Solarized] as my color scheme. While it isn't perfect -- namely, the
contrast between the colors could be higher -- it is the only color scheme as
far as I know that was designed from the start to look good in both dark and
light modes and whose colors were set using color theory techniques instead of
mere eyeballing. (I also use it in my terminal as well.)

[Solarized]: http://ethanschoonover.com/solarized

Solarized has two modes: dark and light. The colors between them are are mostly
the same except for four colors which trade places with each other. The common
set of colors are:

| color   | cterm |
|---------|-------|
| yellow  |     3 |
| orange  |     9 |
| red     |     1 |
| magenta |     5 |
| violet  |    13 |
| blue    |     4 |
| cyan    |     6 |
| green   |     2 |

Dark mode has these additional colors:

| color  | cterm | usage            |
|--------|-------|------------------|
| base00 |    11 |                  |
| base01 |    10 |                  |
| base02 |     0 |                  |
| base03 |     8 | text background  |
| base0  |    12 | text foreground  |
| base1  |    14 |                  |
| base2  |     7 |                  |
| base3  |    15 |                  |

Whereas light mode uses these colors:

| color  | cterm | usage            |
|--------|-------|------------------|
| base00 |    12 |                  |
| base01 |    14 |                  |
| base02 |     7 |                  |
| base03 |    15 | text background  |
| base0  |    11 | text foreground  |
| base1  |    10 |                  |
| base2  |     0 |                  |
| base3  |     8 |                  |

(The full list of colors in the colorscheme are located [here][color-values].)

[color-values]: https://github.com/altercation/solarized/blob/e40cd4130e2a82f9b03ada1ca378b7701b1a9110/vim-colors-solarized/colors/solarized.vim#L91

Usually I use the dark mode, but when I'm outside or in a sunny place, I'll use
light mode. It's helpful to be able to switch between the two, so first we start
off with a few functions to do just that:

``` vim
function! s:UseColorScheme(type)
  if a:type == "light"
    let s:color_scheme_type="light"
    set background=light
    silent! colorscheme solarized
    let g:airline_theme="solarized"
    let g:airline_solarized_bg="dark"
    highlight SpecialKey ctermfg=14 ctermbg=15
    highlight SignColumn ctermbg=15
  else
    let s:color_scheme_type="dark"
    set background=dark
    silent! colorscheme solarized
    let g:airline_theme="solarized"
    let g:airline_solarized_bg="light"
    highlight SpecialKey ctermfg=10 ctermbg=8
    highlight SignColumn ctermbg=8
  end

  highlight ExtraWhitespace ctermfg=0 ctermbg=1
  highlight CharsExceedingLineLength ctermfg=1
endfunction

function! s:ToggleColorScheme()
  if s:color_scheme_type == "dark"
    call s:UseColorScheme("light")
  else
    call s:UseColorScheme("dark")
  endif
endfunction
```

We set dark mode as the default:

```
call s:UseColorScheme("dark")
```

The `ToggleColorScheme` command (or <kbd>,</kbd><kbd>t</kbd><kbd>h</kbd>) will
flip between the two modes:

```
command! -nargs=0 ToggleColorScheme call s:ToggleColorScheme()
nnoremap <Leader>th :ToggleColorScheme<CR>
```
