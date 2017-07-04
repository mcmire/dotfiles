*(← Back to [index](../README.md))*

# Line wrapping settings

This file concerns the behavior around soft wrapping and hard wrapping.

Let's start with soft wrapping. We do not turn on soft wrapping by default, but
we do provide a way to turn it on with <kbd>,wi</kbd>:

``` vim
map <Leader>wi :set invwrap<CR>
```

Then we specify that when it is enabled, lines will be broken by word
boundaries. To distinguish soft-wrapped lines from hard-wrapped ones, we indent
those lines and put an indicator before them:

``` vim
set linebreak breakindent showbreak="＞"
```

These next mappings are important: they give us a way to navigate over wrapped
lines by using the usual <kbd>j</kbd> and <kbd>k</kbd> (normally, we would have
to use <kbd>g</kbd><kbd>j</kbd> and <kbd>g</kbd><kbd>k</kbd>):

``` vim
nnoremap j gj
vnoremap j gj
nnoremap k gk
vnoremap k gk
```

Now for hard wrapping. We can control this through `formatoptions`; the options
we specify here signify the following:

* `t`: This option tells Vim to use `textwidth` to wrap lines.
* `c` / `r` / `o`: These options control how comment lines are wrapped. Whether
  these lines are being wrapped automatically as we are typing them, we insert a
  line break at the end of a line manually with Enter, or we add new lines using
  <kbd>o</kbd> or <kbd>O</kbd>, Vim will ensure that the characters that start
  the comment (`#`, `//`, `"`, etc.) are present at the beginning of the newly
  added line.
* `q`: This option allows us to format comments with <kbd>g</kbd><kbd>q</kbd>.
* `v` / `b`: These two options control how lines are auto-wrapped as we are
  typing them. Usually, as you type, as soon as the current line exceeds
  `textwidth`, a new line will be added and the word you're typing will be
  placed on that line. These options say two things: 1) that the auto-wrapping
  will occur when you type a space instead of immediately (so as not to be so
  jarring) and 2) that if the line already exceeds `linewidth`, don't bother
  with wrapping that line (again, so as not to be a surprise). This isn't
  perfect -- oftentimes, you still end up having to select that line and wrap it
  manually with <kbd>Q</kbd> -- but it works well for most cases.

``` vim
set formatoptions=tcroqvb
augroup local
  autocmd FileType * setl formatoptions=tcroqvb
augroup END
```

Finally, we provide a way to toggle hard wrapping with
<kbd>,</kbd><kbd>w</kbd><kbd>w</kbd>:

``` vim
let g:old_textwidth = 0
function! ToggleHardWrap()
  if &textwidth
    let g:old_textwidth = &textwidth
    let &textwidth = 0
  else
    let &textwidth = g:old_textwidth
  endif
endfunction
noremap <Leader>ww :call ToggleHardWrap()<CR>
```
