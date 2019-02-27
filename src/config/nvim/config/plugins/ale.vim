" Configuration for Ale
" =====================

" [Ale] has two distinct modes: linting and fixing.
"
" [Ale]: https://github.com/w0rp/ale
"
" When Ale lints a file, it checks its syntax (using an external tool) and
" reports any issues within Vim. When it *fixes* a file, it completely rewrites
" it so that it's formatted (again, using an external tool).
"
" So let's start with linting. We configure the plugin to lint the file being
" edited not as it is changed, not even when it is first opened, but only when
" it is saved:

let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0

" Now we configure Ale to use:
"
" * [Rubocop] to lint Ruby files
" * [ESLint] to lint JavaScript files
" * [TSLint] to lint TypeScript files
" * [sass-lint] to lint SCSS files
" * [csslint] to lint CSS files
" * [elm-make] to lint Elm files

" [Rubocop]: https://github.com/bbatsov/rubocop
" [ESLint]: http://eslint.org/
" [TSLint]: https://github.com/palantir/tslint
" [sass-lint]: https://www.npmjs.com/package/sass-lint
" [csslint]: http://csslint.net/
" [elm-make]: https://github.com/elm-lang/elm-make

let g:ale_linters = {
      \  'ruby': ['rubocop', 'ruby'],
      \  'javascript': ['eslint'],
      \  'typescript': ['tsserver'],
      \  'scss': ['sass-lint'],
      \  'css': ['csslint'],
      \  'elm': ['make'],
      \}

" We customize the mapping to go to the next linter error:
nmap <Leader>n <Plug>(ale_next_wrap)

" Finally, we customize the icons that appear in the gutter when issues are
" reported:

let g:ale_sign_error = 'X'
let g:ale_sign_warning = '!'

" Next, fixing. We configure the plugin not to fix files when they are saved:

let g:ale_fix_on_save = 0

" Instead, we bind this behavior to `,f`:

nmap <Leader>f <Plug>(ale_fix)

" Finally, we configure the plugin to use:
"
" * [Prettier] to fix JavaScript, SCSS, and CSS files
" * [Rubocop] to fix Ruby files
" * [elm-format] to fix Elm files
"
" [prettier]: https://github.com/prettier/prettier
" [Rubocop]: https://github.com/bbatsov/rubocop
" [elm-format]: https://github.com/avh4/elm-format

let g:ale_fixers = {
      \  'ruby': ['rubocop'],
      \  'javascript': ['prettier'],
      \  'scss': ['prettier'],
      \  'css': ['prettier'],
      \  'elm': ['format'],
      \}

augroup local
  " Here's a problem: Notice how above we have "eslint" enabled as a linter for
  " JavaScript, but what if a project doesn't have an .eslintrc file? Then
  " ESLint will run anyway, and it may give you warnings. Ideally Ale should
  " detect this, but it doesn't. Here's a fix in the meantime, gleaned from
  " [this comment][ale-fix]:
  "
  " [ale-fix]: https://github.com/w0rp/ale/issues/940#issuecomment-380490927

  autocmd FileType javascript let g:ale_linters = {
  \  'javascript': glob('.eslintrc*', '.;') == '' ? [] : ['eslint']
  \}

" We do the same thing for Ruby, which has the same problem:
  autocmd FileType ruby let g:ale_linters = {
  \  'ruby': findfile('.rubocop.yml', '.;') == '' ? ['ruby'] : ['rubocop', 'ruby']
  \}
augroup END
