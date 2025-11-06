" Configuration for vim-coffee-script
" ===================================

" The [CoffeeScript plugin][coffee-script-vim] is a bit overzealous in its
" highlighting. Here we turn off highlighting for curly braces, square brackets,
" parentheses and operators:
"
" [coffee-script-vim]: https://github.com/kchmck/vim-coffee-script

hi link coffeeObject NONE
hi link coffeeBracket NONE
hi link coffeeCurly NONE
hi link coffeeParen NONE
hi link coffeeSpecialOp NONE

hi clear Operator
hi clear SpecialOp

" Since CoffeeScript is installed via npm globally, we tell the plugin where to
" find it:

" TODO: Probably need to update this path to work with /usr/local and /opt/homebrew
let coffee_compiler = "/usr/local/bin/coffee"
