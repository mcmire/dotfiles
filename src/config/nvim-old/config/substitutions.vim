" Borrowed from Abolish:
" <https://github.com/tpope/vim-abolish/blob/880a562ff9176773897930b5a26a496f68e5a985/plugin/abolish.vim#L111>
function! CamelCase(word)
  let word = substitute(a:word, '-', '_', 'g')
  if word !~# '_' && word =~# '\l'
    return substitute(word,'^.','\l&','')
  else
    return substitute(word,'\C\(_\)\=\(.\)','\=submatch(1)==""?tolower(submatch(2)) : toupper(submatch(2))','g')
  endif
endfunction

function! PascalCase(word)
  return substitute(CamelCase(a:word),'^.','\u&','')
endfunction
