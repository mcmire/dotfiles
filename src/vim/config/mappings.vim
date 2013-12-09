" % to bounce from do to end etc.
runtime! macros/matchit.vim

" Easy way to update/reload vim files
nmap <Leader>evi :tabe ~/.vimrc<CR>
nmap <Leader>evb :tabe ~/.vimrc.bundles<CR>
nmap <Leader>evg :tabe ~/.gvimrc<CR>
" http://vimcasts.org/episodes/updating-your-vimrc-file-on-the-fly/
augroup local
  autocmd BufWritePost ~/.vimrc,~/.vimrc.bundles,~/.gvimrc source %
augroup END

" Window movement
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-h> <C-w>h
noremap <C-l> <C-w>l
noremap <C-_> <C-w>_

" Tab movement
noremap <C-e> gT
noremap <C-t> gt

" pressing < and > in visual mode keeps the selection
vnoremap < <gv
vnoremap > >gv

" Map Q to something useful
noremap Q gq

" Make Y consistent with C and D
nnoremap Y y$

" Easier way to save
nnoremap <C-s> :w<CR>
inoremap <C-s> :w<CR>i
" Easy way to save and close the current buffer
nnoremap <C-q> :wq<CR>
inoremap <C-q> <Esc>:wq<CR>

" I hit this way too often, let's just no-op it
noremap K <Esc>

" Make <C-\> clear the highlight as well as redraw
nnoremap <C-\> :nohls<CR>
inoremap <C-\> <C-O>:nohls<CR>

" Cut a line without whitespace
" `"_d` puts the line into the "black-hole" register,
" See: <http://stackoverflow.com/questions/54255/in-vim-is-there-a-way-to-delete-without-putting-text-in-the-register>
nmap <Leader>dl ^v$hd"_dd
" Paste a string into the next line keeping the same indentation level
nmap <Leader>p> o<Space><Backspace><Esc>p
" Paste a string into the previous line keeping the same indentation level
nmap <Leader>P> O<Space><Backspace><Esc>p
" Open a new line at the end of the following line
nmap <Leader>oi j$a
" Paste overwriting the current selection, without first storing the text to be
" replaced in the current register
vmap <Leader>pp "_dP
" Paste overwriting the current line
nmap <Leader>pc "_ddP
nmap <Leader>pd "_ddP
" Paste overwriting everything to the end of the line ($)
nmap <Leader>pr "_Dp
nmap <Leader>p$ "_Dp
" Paste into the next line replacing it
nmap <Leader>po j"_ddP
" Paste into the previous line replacing it
nmap <Leader>Po k"_ddP

" Convert strings to symbols
vmap <Leader>csy :s/\v["']([^"']+)["'] \=\> /:\1 => /g<CR>:nohls<CR>
" Convert symbols to strings
vmap <Leader>cys :s/\v:([^:]+) \=\>/'\1' =>/g<CR>:nohls<CR>

" Search and replace word under cursor
" http://vim.wikia.com/wiki/Search_and_replace_the_word_under_the_cursor
nnoremap <Leader>se :%s/\<<C-r><C-w>\>/

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
