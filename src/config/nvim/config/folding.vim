" Folding settings
" ================

" Every once in a while you may find myself in a file that has a lot of sections
" -- too many sections. Wouldn't you like to be able to focus on one part of the
" code and collapse everything else? Well, you're in luck, because you can do
" this with folding.
"
" To use folding, we first have to enable it:

set foldenable

" Now, in truth, not every section of code can be folded, but only the ones that
" Vim knows about. There are different strategies that Vim can use to identify
" foldable sections.
"
" One way is to get Vim to reuse the information the syntax highlighter has
" gleaned about the different parts of code you're writing. For instance, the
" syntax highlighter might identify that this section corresponds to a "block",
" and therefore it can be folded. " Unfortunately, [this method causes severe
" performance problems in Ruby files][no-foldmethod-syntax].
"
" [no-foldmethod-syntax]: https://github.com/vim-ruby/vim-ruby/issues/8#issuecomment-327162
"
" Another way is to put the onus on the code writer and tell Vim manually where
" the fold boundaries are by using a special syntax. However, this gets tedious
" fast.
"
" The best way, the one that strikes a good balance between these two methods,
" is to use the indentation of lines in the file. So all code that is nested
" under some other code by way of indentation could be collapsed:

set foldmethod=indent

" To do this, we have to place a limit on how deeply indented your code can be.
" We start by setting the `foldlevel` to the maximum number, meaning that all
" folds will be open by default:

set foldlevel=6

" We then tell Vim that 6 is the maximum `foldlevel` possible:

set foldnestmax=6

" Finally, we allow single lines to be folded:

set foldminlines=0
