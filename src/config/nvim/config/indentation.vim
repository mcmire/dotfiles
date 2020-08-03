" Indentation configuration
" =========================

" Vim has built-in support for Lisp, Scheme, and to some extent, its derivatives
" such as Racket.
"
" Lisp has a specific style in terms of indentation. Most of the time, if you
" want to span a form onto multiple lines, you add a new line after the first
" argument to the name of the function you're calling, and then the subsequent
" lines are indented to align with the first argument:
"
"   (this-is-my-function foo
"                        bar
"                        baz)
"
" You can also add a new line after the name of the function, but then it gets
" indented by 3 spaces:
"
"   (this-is-my-function foo
"      bar
"      baz)
"
" But for special forms such as `if`, `let`, etc., subsequent lines are usually
" indented 2 spaces after the name of the form regardless of what's on the same
" line:
"
"   (if (eqv? 2 2)
"     (print "whatever")
"     (print "something else"))
"
" Vim's Lisp mode knows about these special forms via a list, `lispwords`. The
" thing is that each Lisp or Scheme derivative has its own forms that have
" special indentation rules. Specifically, Racket has some that come from
" popular packages, and so we add to that list here:

augroup local
  autocmd FileType racket setl lispwords+=describe,context,it
augroup END

" Sometimes if I get really lazy, I like to use the `=` key to indent things.
" Unfortunately, `=` doesn't work 100% for Lisp files. The scmindent plugin
" helps to solve this by giving you more control (than what `lispwords` gives
" you) for specifying how arguments to functions should be indented (provided
" they are on subsequent lines). So here we override the `=` key for Racket
" files to use `scmindent.rkt`, which is shipped with the plugin. (Technically,
" this section belongs in plugin-config.vim, but this and `lispwords` go
" hand-in-hand.)

augroup local
  autocmd FileType racket execute 'setlocal equalprg=' . g:plugin_dir . '/scmindent/scmindent.rkt'
augroup END
