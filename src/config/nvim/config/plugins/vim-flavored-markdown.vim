" Configuration for vim-flavored-markdown
" =======================================

augroup local
  " Here we're simply configuring the [vim-flavored-markdown] plugin so that it
  " highlights all Markdown files as Github-Flavored Markdown:
  "
  " [vim-flavored-markdown]: https://github.com/jtratner/vim-flavored-markdown
  autocmd BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown

  " Fix lists so that when adding a new item to a list, we do not end up in the
  " next indentation level:
  " (source: <https://github.com/plasticboy/vim-markdown/issues/126#issuecomment-640890790>)
  autocmd FileType markdown,ghmarkdown set comments=b:*,b:-,b:+,b:1.,n:>
augroup END
