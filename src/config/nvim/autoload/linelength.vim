if exists('g:loaded_linelength')
  finish
endif
let g:loaded_linelength = 1

function! linelength#UnhighlightCharsExceedingLineLength()
  if exists('b:chars_exceeding_line_length_match') && b:chars_exceeding_line_length_match > 0
    silent! call matchdelete(b:chars_exceeding_line_length_match)
    let b:chars_exceeding_line_length_match = 0
  end
endfunction

function! linelength#HighlightCharsExceedingLineLength()
  let b:chars_exceeding_line_length_match = matchadd('CharsExceedingLineLength', '\%>' . &textwidth . 'v.\+', -1)
endfunction
