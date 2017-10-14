*(← Back to [index](../README.md))*

# Mappings

Over time I've added a lot of different mappings to handle different cases.
Let's start with the basic ones.

<kbd>%</kbd> is one of my favorite keys -- it lets you bounce between the start
and end of `if` statements, loops, blocks in Ruby, etc. This mapping is provided
by the [`matchit`][matchit] plugin, which we have to enable:

[matchit]: https://neovim.io/doc/user/pi_matchit.html

``` vim
runtime! macros/matchit.vim
```

<kbd>,</kbd><kbd>e</kbd><kbd>p</kbd> lets us **e**dit the list of **p**lugins:

``` vim
nmap <Leader>ep :tabe ~/.config/nvim/plugins.vim<CR>
```

<kbd>,</kbd><kbd>i</kbd><kbd>p</kbd> lets us **i**nstall **p**lugins:

``` vim
nmap <Leader>ip :source ~/.config/nvim/plugins.vim<CR> :PlugInstall<CR>
```

<kbd>,</kbd><kbd>r</kbd><kbd>v</kbd> lets us **r**eload the **V**im
configuration if we need to:

``` vim
nmap <Leader>rv :source ~/.config/nvim/init.vim<CR>
```

Every once in a while it's useful to explicitly drop into paste mode. We can do
that with <kbd>F3</kbd>:

``` vim
set pastetoggle=<F3>
```

Moving between windows is so common that it should be easier. With these
mappings, we can simply use <kbd>Ctrl</kbd> and a direction key:

``` vim
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-h> <C-w>h
noremap <C-l> <C-w>l
noremap <C-_> <C-w>_
```

<kbd>\<</kbd> and <kbd>\></kbd> are useful for indenting a selection of text,
but unfortunately, after you do so, the selection goes away. The following
mappings prevents that from happening (<kbd>g</kbd><kbd>v</kbd> will take all
text that was last selected and re-select it):

``` vim
vnoremap < <gv
vnoremap > >gv
```

It's very common, especially when writing text such as in Markdown documents,
Git commits or code comments, to want to re-format a paragraph.
<kbd>g</kbd><kbd>q</kbd> will do this, but we map it to <kbd>Q</kbd>:

``` vim
noremap Q gq
```

<kbd>C</kbd> is the same thing as saying <kbd>c</kbd><kbd>$</kbd>; <kbd>D</kbd>
is the same as <kbd>d</kbd><kbd>$</kbd>. So why not do the same for
<kbd>y</kbd><kbd>$</kbd>?

``` vim
nnoremap Y y$
```

For some reason a while back, I found it useful to unmap <kbd>K</kbd>. I suppose
I may find this useful still, even if I don't know it.

``` vim
noremap K <Esc>
```

In the [search settings](search.vim.md), we configure <kbd>/</kbd> to highlight
matches. It's common to want to clear that highlight, so
<kbd>,</kbd><kbd>h</kbd> lets you do this with ease:

``` vim
nnoremap <Leader>h :nohls<CR>
inoremap <Leader>h <C-O>:nohls<CR>
```

Now for a few mappings that make pasting easier.

<kbd>,</kbd><kbd>p</kbd><kbd>$</kbd> will paste, overwriting everything to the
end of the line:

``` vim
nmap <Leader>p$ "_Dp
```

<kbd>,</kbd><kbd>p</kbd><kbd>o</kbd> will open a new line and paste into that
line:

```
nmap <Leader>po o<Space><Backspace><Esc>p
```

<kbd>,</kbd><kbd>p</kbd><kbd>c</kbd> will paste, overwriting the current line:

``` vim
nmap <Leader>pc "_ddP
```

Finally, <kbd>,</kbd><kbd>p</kbd><kbd>w</kbd> will paste, overwriting the
current word:

``` vim
nmap <Leader>pw viw"_dP
```

Now for some formatting-related mappings.
<kbd>,</kbd><kbd>g</kbd><kbd>q</kbd><kbd>c</kbd> reformats a selected comment
block by ensuring that all lines are `textwidth` characters long, removing and
repositioning `#` appropriately.

``` vim
vmap <Leader>gqc <Leader>jc<S-V>gqc
```

<kbd>,</kbd><kbd>j</kbd><kbd>c</kbd> takes a selection containing a multi-line
comment block and joins it into one line. It is used internally by `,gqc`, but
may be useful on its own.

``` vim
vmap <Leader>jc :s/\v[\n ]+#[ ]+/ /g<CR>:nohls<CR>i<Space>#<Space><Esc>
```

<kbd>,</kbd><kbd>g</kbd><kbd>q</kbd><kbd>p</kbd> will reformat the paragraph
that surrounds the cursor:

``` vim
nmap <Leader>gqp vipQ$
```

I use tabs a lot. <kbd>,</kbd><kbd>t</kbd><kbd>c</kbd> gives me a way to close a
tab quickly without having to close all the buffers inside it:

``` vim
nmap <Leader>tc :tabc<CR>
```

I map Caps Lock to Escape. I realize this is a pretty unusual setup (although I
really can't imagine why -- it's great!), so for Those People who are used to
jamming <kbd>j</kbd><kbd>j</kbd>, <kbd>j</kbd><kbd>k</kbd>, or
<kbd>k</kbd><kbd>j</kbd> I offer a way to do that:

``` vim
imap jj <Esc>
imap jk <Esc>
imap kj <Esc>
```

When saving a file that has syntax or other errors, Neomake will populate the
gutter with symbols, but it will not list the errors in the quickfix window
unless you say so. <kbd>,</kbd><kbd>e</kbd><kbd>l</kbd> will **l**ist the
**e**rrors and <kbd>,</kbd><kbd>e</kbd><kbd>f</kbd> will jump to the **f**irst
**e**rror:

``` vim
nmap <Leader>el :lopen<CR>
nmap <Leader>ef :ll 1<CR>
```

Finally, when modifying a colorscheme, sometimes it's helpful to know which
syntax group the cursor sits within.
<kbd>,</kbd><kbd>s</kbd><kbd>y</kbd><kbd>n</kbd> lets us do this
([source][identify-syntax-group]):

[identify-syntax-group]: http://vim.wikia.com/wiki/Identify_the_syntax_highlighting_group_used_at_the_cursor

``` vim
map <Leader>syn :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
```
