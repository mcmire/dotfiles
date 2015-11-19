" Syntax coloring lines that are too long as it just slows down the world
set synmaxcol=128

" I've got a fast terminal, send me more characters for redrawing
set ttyfast

" Limit the number of lines to scroll the screen
if !has("nvim")
  set ttyscroll=3
end

" Don't redraw screen while executing macros, registers, and other commands
" that have not been typed
set lazyredraw
