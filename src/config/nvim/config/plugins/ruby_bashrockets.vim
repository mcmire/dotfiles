" Configuration for ruby_bashrockets
" ==================================

" [Bashrockets] is nice, but it doesn't have a convenient way to apply
" conversions across a selection, which is its most common use case. These two
" commands let us do that:
"
" [Bashrockets]: https://github.com/danchoi/ruby_bashrockets.vim

command! -range HashrocketStyle :<line1>,<line2>Bashrockets
command! -range KeywordArgumentStyle :<line1>,<line2>Hashrockets
