" Folding settings
" ================

" Every once in a while I find myself in a file that has a lot of sections --
" too many sections -- and I need to focus on one thing and hide everything
" else. Folding is a decent way to do this.
"
" First we enable it:

set foldenable

" Now, there are different strategies that Vim can use for marking foldable
" sections. One way is to use the tokens that come out of the syntax highlighter
" for the type of file you've got open. Unfortunately, [this causes severe
" performance problems in Ruby files][no-foldmethod-syntax]. Another way is to
" tell Vim explicitly where the fold boundaries are by using a special syntax.
" This gets tiresome after a while. So the best way I've found, the way that
" strikes a good balance, is to use the indentation of lines in the file.
"
" [no-foldmethod-syntax]: https://github.com/vim-ruby/vim-ruby/issues/8#issuecomment-327162

set foldmethod=indent

" We assume that none of the lines in the file will ever be indented more than 6
" times. We start by setting the `foldlevel` to the maximum number, meaning that
" all folds will be open by default:

set foldlevel=6

" We tell Vim that 6 is the maximum `foldlevel` possible:

set foldnestmax=6

" We allow single lines to be folded:

set foldminlines=0

" And lastly, we show indicators in the gutter that reveal where the fold
" boundaries are:

set foldcolumn=6
