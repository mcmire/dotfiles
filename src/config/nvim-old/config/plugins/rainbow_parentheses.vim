" Configuration for rainbow_parentheses
" =====================================

" We enable [Rainbow Parentheses] for Lisp, Scheme, Racket, and Clojure files:
"
" [Rainbow Parentheses]: https://github.com/kien/rainbow_parentheses.vim

augroup local
  autocmd FileType lisp,scheme,racket,clojure RainbowParenthesesActivate
  autocmd Syntax   lisp,scheme,racket,clojure RainbowParenthesesLoadRound
  autocmd Syntax   lisp,scheme,racket,clojure RainbowParenthesesLoadSquare
  autocmd Syntax   lisp,scheme,racket,clojure RainbowParenthesesLoadBraces
augroup END

" We also add a ton more variety to the colors:

let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['red',         'firebrick3'],
    \ ['brown',       'RoyalBlue3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['red',         'firebrick3'],
    \ ]
