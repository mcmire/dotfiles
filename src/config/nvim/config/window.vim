" Window settings
" ===============

" It's pretty handy to be able to split windows, but once you create a lot of
" vertical splits, your windows can get squished. We can fix this, though.
" Usually, a window that does not have focus will simply take up as much room as
" it has (the height is usually calculated automatically based on heights of
" other splits, but it could be set manually as well). But, thanks to the
" [`winheight`][winheight] option, we can tell Vim to give active windows a
" minimum height so they expand automatically when they receive focus.
"
" [winheight]: http://vimdoc.sourceforge.net/htmldoc/options.html#'winheight'
"
" Here we choose a comfortable setting for the the minimum height:

" COPIED
set winheight=10

" Additionally, we specify that when vertical splits are created from a window
" that has focus, they are placed below that window instead of above:

" COPIED
set splitbelow

" And when horizontal splits are created from a window that has focus, they are
" placed to the right of that window instead of to the left:

" COPIED
set splitright
