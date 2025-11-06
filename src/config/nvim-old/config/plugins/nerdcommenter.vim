" Configuration for NERDCommenter
" ===============================

" [NERDCommenter] has trouble applying Ruby comments for some reason, so we help
" it out:
"
" [NERDCommenter]: https://github.com/preservim/nerdcommenter

" Turn off default mappings so we can assign our own that don't conflict with
" other plugins (such as CoC)
" See this link for how these mappings are created:
" <https://github.com/preservim/nerdcommenter/blob/f8671f783baeb0739f556d9b6c440ae1767340d6/plugin/nerdcommenter.vim#L52>
let g:NERDCreateDefaultMappings = 0
nmap <leader>cc :call nerdcommenter#Comment("n", "Comment")<CR>
xmap <leader>cc :call nerdcommenter#Comment("x", "Comment")<CR>
nmap <leader>c<Space> :call nerdcommenter#Comment("n", "Toggle")<CR>
xmap <leader>c<Space> :call nerdcommenter#Comment("n", "Toggle")<CR>

let g:NERDCustomDelimiters = {
      \ 'ruby': { 'left': '# ' },
      \ 'jsx': { 'left': '{/* ', 'right': ' */}' },
      \ 'javascript': { 'left': '// ' }
      \ }
