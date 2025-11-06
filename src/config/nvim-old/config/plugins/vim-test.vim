" Configuration for vim-test
" =================================

" We configure [vim-test] so that we use vim-tmux-runner to run tests:
"
" [vim-test]: https://github.com/vim-test/vim-test

let test#strategy = "vtr"
"let test#strategy = "neovim"

" Prepend commands with `bundle exec` in Ruby projects that use Bundler:

let test#ruby#bundle_exec = 1

" Use Spring if possible in Rails projects:

let test#ruby#use_spring_binstub = 1

" Look for Jest files that end in '.mjs':

let g:test#javascript#jest#file_pattern = '\v(__tests__/.*|(spec|test))\.(js|jsx|coffee|ts|tsx|mjs)$'

" Here we create a custom function that will ultimately run a command that
" vim-test provides, but not before determining a proper 'project root' that
" vim-test will run its command within. We do this because some projects
" (especially JavaScript projects) are 'monorepos' which means there are
" multiple package.json files. In order to run tests for a component within a
" monorepo, we must first cd into that directory as if that component were its
" own repo. This solution accomplishes that by looking at the file that's open
" and trying to find some kind of 'marker' starting from the directory of that
" file and then searching upward.
"
" Source: <https://github.com/vim-test/vim-test/issues/272#issuecomment-515749091>

let g:workspace_root_markers = ['package.json', '.git']

function! s:RunVimTest(cmd)
  for marker in g:workspace_root_markers
    let marker_file = findfile(marker, expand('%:p:h') . ';')
    if strlen(marker_file) > 0
      echo '(1) Setting project root to ' . fnamemodify(marker_file, ":p:h")
      let g:test#project_root = fnamemodify(marker_file, ":p:h")
      break
    endif
    let marker_dir = finddir(marker, expand('%:p:h') . ';')
    if strlen(marker_dir) > 0
      echo '(2) Setting project root to ' . fnamemodify(marker_dir, ":p:h:h")
      let g:test#project_root = fnamemodify(marker_dir, ":p:h:h")
      break
    endif
  endfor

  execute a:cmd
endfunction

" And finally we create some mappings:
"
" * `,tA` to run [A]ll of the tests in the current file
" * `,tr` to run the test that's [r]ight at the cursor
" * `,tl` to run whichever spec was run [l]ast
" * `,ts` to run the full test [s]uite

nnoremap <leader>tA :call <SID>RunVimTest('TestFile')<cr>
nnoremap <leader>tr :call <SID>RunVimTest('TestNearest')<cr>
nnoremap <leader>tl :call <SID>RunVimTest('TestLast')<cr>
nnoremap <leader>ts :call <SID>RunVimTest('TestSuite')<cr>
