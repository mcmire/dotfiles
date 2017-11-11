" Window settings
" ===============

" A window (which I find it more helpful to think of as a pane) could get
" squished if you create too many vertical splits. The [`winheight`][winheight]
" option sets the minimum height of a window when it is focused (as opposed to
" when it is not focused). Usually, a window that does not have focus will
" simply take up as much room as it has (the height is usually calculated
" automatically based on heights of other splits, but it could be set manually
" as well). But when that window receives focus, if it has a height of less than
" the minimum height, Vim will automatically expand the height to the min
" height, returning it to its former height when focus is lost.
"
" Here we choose a comfortable setting for the the minimum height:
"
" [winheight]: http://vimdoc.sourceforge.net/htmldoc/options.html#'winheight'

set winheight=10

" Additionally, we specify that when vertical splits are created from a window
" that has focus, they are placed below that window instead of above:

set splitbelow

" And when horizontal splits are created from a window that has focus, they are
" placed to the right of that window instead of to the left:

set splitright
