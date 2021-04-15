" Configuration for Goyo
" ======================

" Don't hide line numbers when switching to Goyo mode.
let g:goyo_linenr = 1

" We need to make some things happen when going in and out of Goyo.

function! s:goyo_enter()
  " Redraw the color scheme as the gutter changes color for some reason.
  call g:RefreshColorScheme()
  " Don't render marks in the gutter.
  exec 'MarkologyDisable'
  " Wrap all lines.
  let s:was_wrap = &wrap
  set wrap
endfunction

function! s:goyo_leave()
  " Redraw the color scheme as the gutter changes color for some reason.
  call g:RefreshColorScheme()
  " Render marks in the gutter.
  exec 'MarkologyEnable'
  " If we were previously wrapping lines, do that, otherwise don't.
  if s:was_wrap
    set wrap
  else
    set nowrap
  endif
endfunction

augroup local
  autocmd User GoyoEnter nested call <SID>goyo_enter()
  autocmd User GoyoLeave nested call <SID>goyo_leave()
augroup END

" Give ourselves a shortcut for toggling Goyo.

nnoremap <Leader>go :Goyo<CR>
