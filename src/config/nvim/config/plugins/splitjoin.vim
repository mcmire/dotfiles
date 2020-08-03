" Configuration for splitjoin
" ===========================

" [splitjoin] has some strange default behavior, so we attempt to corral it.
" First, we specify that when taking a hash split across multiple lines and
" turning it into a single line, keep the curly braces around the hash:
"
" [splitjoin]: https://github.com/AndrewRadev/splitjoin.vim

let g:splitjoin_ruby_curly_braces = 0

" Next we tell the plugin that when splitting up a method that's one line into
" multiple lines, place the arguments on their own line instead of placing the
" first argument on the same line as the method call:

let g:splitjoin_ruby_hanging_args = 0
