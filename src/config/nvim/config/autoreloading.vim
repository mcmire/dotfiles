" Auto-reloading
" ==============
"
" By default, [Vim periodically saves changes][recover] you've made to a file
" that you haven't explicitly saved. It does so by keeping a "swap file" -- a
" copy of the current file, plus your new changes, in the same directory as that
" file. While this sounds like a great feature, it's completely useless if you
" get into a habit of saving all the time. It's also a bit of a pain, because
" very commonly you'll open a file only to get a message informing you that
" contents of the file are in conflict with the contents of the swap file. For
" this reason, it's better to simply disable swap files:
"
" [recover]: http://vimdoc.sourceforge.net/htmldoc/recover.html

" COPIED
set noswapfile

" The downside of disabling the swapfile is that if you attempt to modify a file
" outside of Vim, Vim will no longer detect it, as it would have if you'd had
" swapfiles enabled. The following bit of voodoo makes it so that Vim does
" detect outside changes and prompts you accordingly (or simply reloads the file
" if you haven't modified it).
"
" Sources:
"
" * https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
" * https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
" * https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread

" SKIPPED (DEFAULT)
set autoread

" COPIED
augroup local
  autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
        \ if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif
  autocmd FileChangedShellPost *
        \ silent !echo "File changed on disk. Buffer reloaded."
augroup END
