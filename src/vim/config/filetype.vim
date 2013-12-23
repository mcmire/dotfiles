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

  " Make Python files follow PEP8 (http://www.python.org/dev/peps/pep-0008/)
  autocmd FileType python set softtabstop=4 tabstop=4 shiftwidth=4 textwidth=79

  " Fix crontab editing
  autocmd BufEnter /private/tmp/crontab.* setl backupcopy=yes

  " In Clojure, words that contains dots are usually namespaces
  " Source: <http://stackoverflow.com/questions/225266/customising-word-separators-in-vi>
  autocmd FileType clojure set iskeyword-=.
augroup END
