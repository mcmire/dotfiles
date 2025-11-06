" When a line exceeds the set `textwidth` we mark the characters that are past
" the limit with the `CharsExceedingLineLength` syntax group. (The color for
" this is defined in [colors].)
"
" The reason why this is here and not in line-width.vim is that we need this to
" run after the [EditorConfig plugin][editorconfig] runs (as it sets linewidth).
"
" [colors]: ../../config/colors.vim
" [editorconfig]: https://github.com/editorconfig/editorconfig-vim

"call linelength#UnhighlightCharsExceedingLineLength()

"augroup local
  "autocmd BufReadPre,BufFilePre,OptionSet *.{rb,js,md} :call linelength#UnhighlightCharsExceedingLineLength()
  "autocmd BufReadPost,BufFilePost,OptionSet,BufNewFile *.{rb,js,md} :call linelength#HighlightCharsExceedingLineLength()
"augroup END
