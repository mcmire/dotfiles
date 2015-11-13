augroup local
  " make uses real tabs
  autocmd FileType make setl noexpandtab

  " Many Ruby files aren't named that way
  autocmd BufRead,BufNewFile {config.ru,Gemfile,Guardfile,Rakefile,Thorfile,Vagrantfile,Appraisals,Bowerfile,*.gemspec} set ft=ruby

  " Highlight Haml Coffee files as Haml
  autocmd BufRead,BufNewFile *.hamlc set ft=haml

  " Turn on autoindentation since vim-markdown does not include this
  autocmd BufRead,BufNewFile *.{md,mkd,mkdn,mark*} setl ft=markdown autoindent

  " Highlight JSON files and JSHint/ESLint config files as JavaScript
  autocmd BufNewFile,BufRead {*.json,.jshintrc,.eslintrc} set ft=javascript
  " Also highlight .es6 files as JavaScript (sprockets-es6)
  autocmd BufRead,BufNewFile *.es6 setfiletype javascript

  " Make Python files follow PEP8 (http://www.python.org/dev/peps/pep-0008/)
  autocmd FileType python set softtabstop=4 tabstop=4 shiftwidth=4 textwidth=79

  " Fix crontab editing
  autocmd BufEnter /private/tmp/crontab.* setl backupcopy=yes

  " In Clojure, words that contains dots are usually namespaces
  " Source: <http://stackoverflow.com/questions/225266/customising-word-separators-in-vi>
  autocmd FileType clojure set iskeyword-=.

  " Support Skim (Slim for JavaScript)
  autocmd BufRead,BufNewFile *.skim set ft=slim
augroup END
