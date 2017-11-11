let s:current_directory = expand("<sfile>:p:h")

function! s:load_file(path) abort
  let l:full_path = s:current_directory . "/config/" . a:path . ".vim"
  exec "source " . l:full_path
endfunction

call s:load_file("start")
call s:load_file("basics")
call s:load_file("magic")
call s:load_file("colors")
call s:load_file("whitespace")
call s:load_file("line-wrapping")
call s:load_file("search")
call s:load_file("completion")
call s:load_file("filetype")
call s:load_file("folding")
call s:load_file("window")
call s:load_file("scrolling")
call s:load_file("mappings")
call s:load_file("plugin-config")
call s:load_file("optimizations")
call s:load_file("line-width")
call s:load_file("clipboard")
