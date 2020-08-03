" Configuration for vim-spec-runner
" =================================

" We configure [vim-spec-runner] so that commands are prepended with `bundle
" exec`:
"
" [vim-spec-runner]: https://github.com/gabebw/vim-spec-runner

let g:spec_runner_dispatcher = 'call VtrSendCommand("bundle exec {command}")'

" The plugin will automatically write the current file before running specs, but
" considering we don't autosave any other time we use Vim, we turn this off:

let g:disable_write_on_spec_run = 1

" Finally, we create some mappings:
"
" * `,tA` to run [A]ll of the tests in the current file
" * `,tr` to run the test that's [R]ight here
" * `,tl` to run whichever spec was run [L]ast

map <leader>tA <plug>RunCurrentSpecFile
map <leader>tr <plug>RunFocusedSpec
map <leader>tl <plug>RunMostRecentSpec
