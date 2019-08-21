" Mappings
" ========

" `,ep` lets us **e**dit the list of **p**lugins:

nmap <Leader>ep :tabe ~/.config/nvim/plugins.vim<CR>

" `,ip` lets us **i**nstall **p**lugins:

nmap <Leader>ip :source ~/.config/nvim/plugins.vim<CR> :PlugInstall<CR>

" `,rv` lets us **r**eload the **V**im configuration if we need to:

nmap <Leader>rv :source ~/.config/nvim/init.vim<CR>

" Every once in a while it's useful to explicitly drop into paste mode. We can
" do that with `F3`:

set pastetoggle=<F3>

" Moving between windows is so common that it should be easier. With these
" mappings, we can simply use `Ctrl` and a direction key:

noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-h> <C-w>h
noremap <C-l> <C-w>l
noremap <C-_> <C-w>_

" `\<` and `\>` are useful for indenting a selection of text, but unfortunately,
" after you do so, the selection goes away. The following mappings prevents that
" from happening (`gv` will take all text that was last selected and re-select
" it):

vnoremap < <gv
vnoremap > >gv

" It's very common, especially when writing text such as in Markdown documents,
" Git commits or code comments, to want to re-format a paragraph. `gq` will do
" this, but we map it to `Q`:

noremap Q gq

" `C` is the same thing as saying `c$`; `D` is the same as `d$`. So why not do
" the same for `y$`?

nnoremap Y y$

" `K` is a useless mapping and may do something evil (although what exactly it
" does has been lost to the sands of time):

noremap K <Esc>

" In the [search settings](search.vim.md), we configure `/` to highlight
" matches. It's common to want to clear that highlight, so `,h` lets you do this
" with ease:

nnoremap <Leader>h :nohls<CR>
inoremap <Leader>h <C-O>:nohls<CR>

" Now for a few mappings that make pasting easier.
"
" `,p$` will paste, overwriting everything to the end of the line:

nmap <Leader>p$ "_Dp

" `,po` will open a new line and paste into that line:

nmap <Leader>po o<Space><Backspace><Esc>p

" `,pc` will paste, overwriting the current line:

nmap <Leader>pc "_ddP

" Finally, `,pw` will paste, overwriting the current word:

nmap <Leader>pw viw"_dP

" Now for some formatting-related mappings.
"
" `,gqc` reformats a selected comment block by ensuring that all lines are
" `textwidth` characters long, removing and repositioning `#` appropriately.

vmap <Leader>gqc <Leader>jc<S-V>gqc

" `,jc` takes a selection containing a multi-line comment block and joins it
" into one line. It is used internally by `,gqc`, but may be useful on its own. 
vmap <Leader>jc :s/\v[\n ]+#[ ]+/ /g<CR>:nohls<CR>i<Space>#<Space><Esc>

" `,gqp` will reformat the paragraph that surrounds the cursor:

nmap <Leader>gqp vipQ$

" `,tc` lets you close a tab quickly without having to close all of the buffers
" inside of it:

nmap <Leader>tc :tabc<CR>

" We recommend you make Escape more easy to press. But if you enjoy jamming a
" couple of characters together then you can do that easily as well:

imap jj <Esc>
imap jk <Esc>
imap kj <Esc>

" When saving a file that has syntax or other errors, Neomake will populate the
" gutter with symbols, but it will not list the errors in the quickfix window
" unless you say so. `,el` will **l**ist the **e**rrors and `,ef` will jump to
" the **f**irst **e**rror:

nmap <Leader>el :lopen<CR>
nmap <Leader>ef :ll 1<CR>

" When working with hashes in Ruby, it's sometimes useful to be able to quickly
" convert all of the keys in that hash from symbols to strings, or vice versa.
" This adds `,sym` and `,str` to let you do that:

vmap <Leader>sym :s/\v["']([^"']+)["'] \=\> /\1: /g<CR>:nohls<CR>
vmap <Leader>str :s/\v%(:([^:]+) \=\>\|([^[:space:]:]+): )/'\1\2' => /g<CR>:nohls<CR>

" When running tests, it's helpful to know the path of the test file you're
" working on so you can feed it to `rspec`. `,cp` will copy the path to the
" clipboard so you can paste it in another terminal window:
nmap <Leader>cp :let @* = expand("%")<CR>

" Since we've modified the `syn sync` command to start from 256 lines up from
" the current line by default (see optimizations.vim), sometimes this messes
" causes highlighting to get messed up, so we give ourselves a way to
" reset highlighting for the whole file:
nmap <Leader>sr :syntax sync fromstart

" Finally, when modifying a colorscheme, sometimes it's helpful to know which
" syntax group the cursor sits within. `,syn` lets us do this
" ([source][identify-syntax-group]):
"
" [identify-syntax-group]: http://vim.wikia.com/wiki/Identify_the_syntax_highlighting_group_used_at_the_cursor

map <Leader>si :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

nmap <Leader>w :wa<CR>
