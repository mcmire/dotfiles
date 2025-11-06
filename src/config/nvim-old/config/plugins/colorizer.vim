" Configuration for Colorizer
" ===========================

" By default, [Colorizer] doesn't turn on automatically. Here we turn it on for
" CSS and Sass files:
"
" [Colorizer]: https://github.com/lilydjwg/colorizer

let g:colorizer_auto_filetype = 'css,scss'

" The plugin also colorizes color strings in comments, but we turn that off here:

let g:colorizer_skip_comments = 1
