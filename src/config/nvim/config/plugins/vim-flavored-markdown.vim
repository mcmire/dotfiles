" Configuration for vim-flavored-markdown
" =======================================

" Here we're simply configuring the [vim-flavored-markdown] plugin so that it
" highlights all Markdown files as Github-Flavored Markdown:
"
" [vim-flavored-markdown]: https://github.com/jtratner/vim-flavored-markdown

augroup local
  autocmd BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown
augroup END
