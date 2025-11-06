" Configuration for Ctrl-P
" ========================

" The installation instructions for [Ctrl-P] say that we must do this in order
" for the plugin to work:
"
" [Ctrl-P]: https://github.com/ctrlpvim/ctrlp.vim

set runtimepath^=~/.vim/bundle/ctrlp

" We position Ctrl-P at the top, set the maximum number of matches to 20, and
" have better matches appear before worse ones:

let g:ctrlp_match_window_bottom = 0
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_max_height = 20

" Usually Ctrl-P's working directory is the same as the open file, but since we
" usually have whole projects open, it's better to use the current working
" directory:

let g:ctrlp_working_path_mode = 'w'

" We use Ag to generate search results:

if executable('ag')
  let g:ctrlp_user_command = 'ag %s
        \ --path-to-ignore ~/.ignore
        \ --hidden
        \ --files-with-matches
        \ --nocolor
        \ --filename-pattern ""'
endif

" Lastly, we make it easier to search by tag. (I added this when I was
" experimenting with tag generation, but I didn't get very far.)

noremap <Leader>pt :CtrlPTag<CR>
