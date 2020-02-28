" Optimizations
" =============

" This file contains a couple of optimizations to make Vim operate a little
" faster.
"
" First, the syntax highlighter will get tripped up on files that have super
" long lines, and when this happens, Vim will slow to a halt. To prevent this
" from happening, we stop the highlighting after 1000 characters. This can make
" lines following the offending line look funny, but it's the price we pay:

set synmaxcol=1000

" Second, we specify the strategy that Vim uses to perform syntax highlighting
" from any point in the file. All of them except one involve backtracking, but
" you can configure what previous part of the file Vim uses to determine the
" current syntax group. Here we tell it to start at 256 lines back in the file
" and parse all of the lines forward.

"syntax sync minlines=256
