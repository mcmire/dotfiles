augroup local
  " make uses real tabs
  autocmd FileType make setl noexpandtab

  " Many Ruby files aren't named that way
  autocmd BufRead,BufNewFile {config.ru,Gemfile,Guardfile,Rakefile,Thorfile,Vagrantfile,Appraisals} set ft=ruby

  " haml-coffee
  autocmd BufRead,BufNewFile *.hamlc set ft=haml

  " Turn on autoindentation since vim-markdown does not include this
  autocmd BufRead,BufNewFile *.{md,mkd,mkdn,mark*} setl ft=markdown autoindent

  " Add JSON syntax highlighting
  autocmd BufNewFile,BufRead *.json set ft=javascript

  " Make Python follow PEP8 ( http://www.python.org/dev/peps/pep-0008/ )
  autocmd FileType python set softtabstop=4 tabstop=4 shiftwidth=4 textwidth=79

  " Fix crontab editing
  autocmd BufEnter /private/tmp/crontab.* setl backupcopy=yes
augroup END

" Use modeline overrides
set modeline
set modelines=10

" Allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Paste mode
set pastetoggle=<F3>

" Turn off some line specific stuff that is annoying
" Using autocmd here since formatoptions may be specified by the
" filetype - you can see what these options are with :h fo-table
set formatoptions=tcroqvb
augroup local
  autocmd FileType * setl formatoptions=tcroqvb
augroup END

" Enable Ctrl-N, Ctrl-P in tab completion
set wildmenu
