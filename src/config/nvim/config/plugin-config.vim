" Plugin configuration
" ====================

" This file is where any settings related to plugins go.

let s:current_directory = expand("<sfile>:p:h")

function! s:load_file(path) abort
  let l:full_path = s:current_directory . "/plugins/" . a:path . ".vim"
  exec "source " . l:full_path
endfunction

call s:load_file("ack")
call s:load_file("airline")
call s:load_file("ale")
call s:load_file("auto-pairs")
call s:load_file("colorizer")
call s:load_file("ctrlp")
call s:load_file("elm-vim")
call s:load_file("FastFold")
call s:load_file("indentLine")
call s:load_file("limelight")
call s:load_file("neco-ghc")
call s:load_file("nerdcommenter")
call s:load_file("nerdtree")
call s:load_file("rainbow_parentheses")
call s:load_file("ruby_bashrockets")
call s:load_file("ShowMarks")
call s:load_file("splitjoin")
call s:load_file("UltiSnips")
call s:load_file("vim-coffee-script")
call s:load_file("vim-flavored-markdown")
call s:load_file("vim-javascript")
call s:load_file("vim-jsx")
call s:load_file("vim-matchup")
call s:load_file("vim-sexp")
call s:load_file("vim-slim")
call s:load_file("vim-spec-runner")
call s:load_file("vim-tmux-navigator")
call s:load_file("vim-tmux-runner")
call s:load_file("vim-togglecursor")
