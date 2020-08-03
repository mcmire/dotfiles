function! RubyfmtFix(buffer) abort
  return { 'command': 'rubyfmt' }
endfunction

call ale#fix#registry#Add(
      \ 'rubyfmt',
      \ 'RubyfmtFix',
      \ ['ruby'],
      \ 'Fix Ruby files with rubyfmt.'
      \ )
