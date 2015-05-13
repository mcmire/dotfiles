" % to bounce from do to end etc.
runtime! macros/matchit.vim

" Easy way to update/reload vim files
nmap <Leader>evi :tabe ~/.vimrc<CR>
nmap <Leader>evb :tabe ~/.vimrc.bundles<CR>
nmap <Leader>evg :tabe ~/.gvimrc<CR>
nmap <Leader>rv :source ~/.vimrc<CR>

" Paste mode (because sometimes I am lazy)
set pastetoggle=<F3>

" Window movement
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-h> <C-w>h
noremap <C-l> <C-w>l
noremap <C-_> <C-w>_

" Tab movement
"noremap <C-e> gT
"noremap <C-t> gt

" pressing < and > in visual mode keeps the selection
vnoremap < <gv
vnoremap > >gv

" Map Q to something useful
noremap Q gq

" Make Y consistent with C and D
nnoremap Y y$

" Easier way to save
"map <C-s> <Esc>:w<CR>
"imap <C-s> <Esc>:w<CR>i
" Easy way to save and close the current buffer
"map <C-q> <Esc>:wq<CR>
"imap <C-q> <Esc>:wq<CR>

" I hit this way too often, let's just no-op it
noremap K <Esc>

" Make ,h clear the highlight as well as redraw
nnoremap <Leader>h :nohls<CR>
inoremap <Leader>h <C-O>:nohls<CR>

" Paste overwriting everything to the end of the line ($)
nmap <Leader>p$ "_Dp
" Open (o) a new line and paste into it
nmap <Leader>po o<Space><Backspace><Esc>p
" Paste overwriting the current (c) line
nmap <Leader>pc "_ddP
" Paste overwriting the current/next word (w)
nmap <Leader>pw viw"_dP

" Join comments so we can easily apply gqc
vmap <Leader>jc :s/\v[\n ]+#[ ]+/ /g<CR>:nohls<CR>i<Space>#<Space><Esc>
" A form of gqc that joins the selected comment lines first
vmap <Leader>gqc <Leader>jc<S-V>gqc
" Format paragraphs too
nmap <Leader>gqp vipQ$

" Quick way to close tabs
nmap <Leader>tc :tabc<CR>

" Identify syntax group at cursor
" http://vim.wikia.com/wiki/Identify_the_syntax_highlighting_group_used_at_the_cursor
map <Leader>syn :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" For Those People who don't have Caps Lock set to Escape
imap jj <Esc>
