set foldenable

"" NOTE!!!
"" Setting foldmethod to syntax will cause all sorts of problems.
"" See: <https://github.com/vim-ruby/vim-ruby/issues/8#issuecomment-327162>
"" And also: <http://vim.wikia.com/wiki/Keep_folds_closed_while_inserting_text>
set foldmethod=indent
set foldlevel=6    " start with no folding, but ready to go
set foldminlines=0 " Allow folding single lines
set foldnestmax=6  " Set max fold nesting level
"set foldcolumn=4 " Show fold column
