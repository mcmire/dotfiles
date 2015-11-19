" Only load this indent file when no other was loaded.
if exists("b:did_indent")
   finish
endif
let b:did_indent = 1

" Dot is like indenting C
setlocal cindent

let b:undo_indent = "setl cin<"
