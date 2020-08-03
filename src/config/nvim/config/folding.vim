" Folding settings
" ================

" Every once in a while you may find yourself in a file that has a lot of
" sections — too many sections. Wouldn't you like to be able to focus on one
" part of the code and collapse everything else? Well, you're in luck, because
" you can do this with folding.
"
" Folding is disabled by default so we have to enable it first:

set foldenable

" Now, in truth, not every section of code can be folded, but only the ones that
" Vim knows about. There are different strategies to use to inform Vim of
" foldable sections.
"
" One way is to put the onus on the code writer and tell Vim manually where
" the fold boundaries are by using a special syntax. This is called "marker"
" mode. However, this gets tedious fast.
"
" Another way is to get Vim to reuse the information the syntax highlighter has
" gleaned about the different parts of code you're writing. For instance, the
" syntax highlighter might identify that this section corresponds to a "block",
" and therefore it can be folded. This is called "syntax" mode. However, this is
" known to be very unperformant (read: annoying), because Vim recomputes folds
" in real time as you're typing. ([It's particularly a problem when writing
" Ruby.][no-foldmethod-syntax]) However, we get around this by using the
" FastFold plugin, which uses syntax mode to compute folds *once* when the file
" is loaded and then switches into manual mode thereafter until you tell it.
"
" [no-foldmethod-syntax]: https://github.com/vim-ruby/vim-ruby/issues/8#issuecomment-327162

set foldmethod=syntax

" Even with FastFold, computing folds is expensive, so we have to place a limit
" on how many levels of indentation result in folds. 10 seems like a reasonable
" number:

set foldnestmax=10
"
" Then we set the `foldlevel` to the maximum number, meaning that all folds will
" be open by default:

set foldlevel=10

" Finally, we allow single lines to be folded:

set foldminlines=0
