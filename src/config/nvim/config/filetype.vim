" File type settings
" ==================

" Some types of files use different settings. Some files that have a certain
" extension are incorrectly assigned the wrong file type. This file attempts to
" address both of these issues.
"
" To start with, most files use soft tabs, but Makefiles are different because
" they literally do not work unless they have real ones:

augroup local
  autocmd FileType make setl noexpandtab
augroup END

" A lot of files that we use in the Ruby world don't end in `.rb`. This is
" unfortunate, but it means they aren't highlighted like Ruby files, so we make
" them highlighted appropriately:

augroup local
  autocmd BufRead,BufNewFile {config.ru,Gemfile,Guardfile,Rakefile,Thorfile,Vagrantfile,Appraisals,Bowerfile,*.gemspec} set ft=ruby
augroup END

" JSHint, ESLint, and Babel configuration files are JSON files, so they
" need to be highlighted as such as well:

augroup local
  autocmd BufNewFile,BufRead {.jshintrc,.eslintrc,.babelrc} set ft=json
augroup END

" .js.coffee files are CoffeeScript files too:

augroup local
  autocmd BufNewFile,BufRead {.js.coffee} set ft=coffee
augroup END

" Syntax-highlight JSX in JavaScript and TypeScript files regardless of
" extension:

augroup local
  autocmd BufNewFile,BufRead *.{js,jsx} set ft=javascript.jsx
  autocmd BufNewFile,BufRead *.{ts,tsx} set ft=typescript.jsx
augroup END

" For some reason, auto-indentation isn't enabled in Markdown files, so we
" explicitly enable that too:

augroup local
  autocmd BufRead,BufNewFile *.{md,mkd,mkdn,mark*} setl ft=markdown autoindent
augroup END

" Python encourages you to use [PEP8](http://www.python.org/dev/peps/pep-0008/)
" and so we enforce that here:

augroup local
  autocmd FileType python setl softtabstop=4 tabstop=4 shiftwidth=4 textwidth=79
augroup END

" Elm people use 4 spaces instead of 2 as well:

augroup local
  autocmd FileType elm setl softtabstop=4 tabstop=4 shiftwidth=4 textwidth=80
augroup END

" Usually, `.` is treated as a word boundary. So when using <kbd>w</kbd> or
" <kbd>b</kbd> to navigate by word, the cursor will stop at a period. In text,
" this makes sense, and in most programming languages, this makes sense too, as
" dots are usually tokens. But in Clojure, dots denote namespaces. So `foo.bar`
" means the `bar` function in the `foo` namespace. We want to treat this as a
" single unit from a navigation standpoint, so we make that happen here.
" ([Source][customizing-word-separators])
"
" [customizing-word-separators]: http://stackoverflow.com/questions/225266/customising-word-separators-in-vi

augroup local
  autocmd FileType clojure set iskeyword-=.
augroup END

" Skim is Slim, but for JavaScript, and its files end in `.skim`. Since the
" syntax looks just like Slim, we can borrow Slim's syntax highlighting:

augroup local
  autocmd BufRead,BufNewFile *.skim set ft=slim
augroup END

" Haml Coffee is a version of Haml that uses CoffeeScript instead of ERB, and
" its files end in `.hamlc`. Since they are mostly Haml files, we highlight them
" as such:

augroup local
  autocmd BufRead,BufNewFile *.hamlc set ft=haml
augroup END

" Lastly, in the event that we edit our crontabs, we ask Vim to make a backup
" copy of those files in a way that is compatible with `crontab -e`:

augroup local
  autocmd BufEnter /private/tmp/crontab.* setl backupcopy=yes
augroup END
