" Configuration for vim-test
" =================================

" We configure [vim-test] so that we use vim-tmux-runner to run tests:
"
" [vim-test]: https://github.com/vim-test/vim-test

let test#strategy = "vtr"

" And to use Spring if possible in Rails projects:

let test#ruby#use_spring_binstub = 1

" And to look for Jest files that end in '.mjs':

let g:test#javascript#jest#file_pattern = '\v(__tests__/.*|(spec|test))\.(js|jsx|coffee|ts|tsx|mjs)$'

" And we create some mappings:
"
" * `,tA` to run [A]ll of the tests in the current file
" * `,tr` to run the test that's [r]ight here
" * `,tl` to run whichever spec was run [l]ast

map <leader>tA :TestFile<CR>
map <leader>tr :TestNearest<CR>
map <leader>tl :TestLast<CR>
