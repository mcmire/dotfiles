" Configuration for auto-pairs
" ============================

" AutoPairs is nice, but it has this weird behavior (especially noticeable in
" JavaScript files) where if you try to add an if statement, function, etc. in
" the middle of another function, as soon as you press } then AutoPairs will
" jump to the next }. This gets super annoying and there's actually a [fork][1]
" that fixes this behavior so that it will count however many brackets are open
" and ensure that they're all closed before jumping.
"
" [1]: https://github.com/eapache/auto-pairs

let g:AutoPairsUseInsertedCount = 1

" However, we make it so that it can be toggled with `,apt`:

let g:AutoPairsShortcutToggle = "<Leader>apt"

" We also provide some more mappings for working with auto-pairs in other ways,
" although truthfully, I don't use them that much:

let g:AutoPairsShortcutFastWrap = "<Leader>apw"
let g:AutoPairsShortcutJump = "<Leader>apj"
let g:AutoPairsShortcutBackInsert = "<C-n>"
