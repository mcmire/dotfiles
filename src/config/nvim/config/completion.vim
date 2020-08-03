" Completion settings
" ===================

" This file controls how completion works. In Vim there are two places where you
" can complete words: [Insert mode][ins-completion] and [Ex
" mode][cmdline-completion].
"
" [ins-completion]: http://vimdoc.sourceforge.net/htmldoc/insert.html#ins-completion
" [cmdline-completion]: http://vimdoc.sourceforge.net/htmldoc/cmdline.html#cmdline-completion
"
" We'll start with Insert-mode completion. [SuperTab] lets us use `Tab` to
" trigger this kind of completion. The [`wildmode`][wildmode] option controls
" what happens when you press Tab multiple times when there are multiple matches
" for the string you've typed. Here we specify that as long as `Tab` is pressed,
" an autocomplete menu should be shown, but that different things should happen
" the first time versus subsequent times. The first time, the string typed will
" be compared to the available matches, and the match chosen for autocompletion
" will be the longest subsequence of the string typed. After that, the match
" chosen for autocompletion will be the first one in the list.
"
" [wildmode]: http://vimdoc.sourceforge.net/htmldoc/options.html#'wildmode'
" [SuperTab]: http://github.com/ervandew/supertab

set wildmode=list:longest,list:full

" The [`wildignore`][wildignore] option controls the behavior of filename
" completion when entering commands in Ex mode. File paths that match the
" following patterns will not be completed:
"
" [wildignore]: http://vimdoc.sourceforge.net/htmldoc/options.html#'wildignore'

set wildignore+=.git,.svn,*.class,*.o,*.obj,*.rbc,features/cassettes,spec/cassettes,tmp/cache,vendor/gems/*,vendor/ruby/**

" The [`wildmenu`][wildmenu] option also controls the behavior of filename
" completion in the sense that it tells Vim to show a menu when there is more
" than one completion for the string typed. Filenames can be chosen with the
" arrow keys, `Tab`, or `Ctrl-P` and `Ctrl-N`.
"
" [wildmenu]: http://vimdoc.sourceforge.net/htmldoc/options.html#'wildmenu'

set wildmenu
