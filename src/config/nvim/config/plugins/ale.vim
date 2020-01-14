" Configuration for Ale
" =====================

" [Ale] has two distinct modes: linting and fixing. Linters pass code through a
" set of rules; fixers actually modify that code according to those rules.
"
" [Ale]: https://github.com/w0rp/ale

" === Linters and fixers ===

" First, let's define the linters that are available to Ale. We use:
"
" * [Standard] and [Rubocop] to lint Ruby files
" * [ESLint] to lint JavaScript files
" * [TSLint] to lint TypeScript files
" * [sass-lint] to lint SCSS files
" * [csslint] to lint CSS files
" * [elm-make] to lint Elm files

" [Standard]: https://github.com/testdouble/standard
" [Rubocop]: https://github.com/bbatsov/rubocop
" [ESLint]: http://eslint.org/
" [TSLint]: https://github.com/palantir/tslint
" [sass-lint]: https://www.npmjs.com/package/sass-lint
" [csslint]: http://csslint.net/
" [elm-make]: https://github.com/elm-lang/elm-make

let g:ale_linters = {
      \  'javascript': ['eslint'],
      \  'typescript': ['tsserver'],
      \  'scss': ['sasslint'],
      \  'sass': ['sasslint'],
      \  'css': ['stylelint'],
      \  'elm': ['make'],
      \}

" Now we'll define the fixers. We use:
"
" * [Prettier] to fix JavaScript, SCSS, and CSS files
" * [Rubocop] to fix Ruby files
" * [elm-format] to fix Elm files
"
" [Prettier]: https://github.com/prettier/prettier
" [Rubocop]: https://github.com/bbatsov/rubocop
" [elm-format]: https://github.com/avh4/elm-format

let g:ale_fixers = {
      \  'ruby': ['standardrb'],
      \  'javascript': ['prettier'],
      \  'scss': ['prettier'],
      \  'sass': ['prettier'],
      \  'css': ['prettier'],
      \  'elm': ['format'],
      \}

" === Other configuration ===

" Ale has some default behavior which is undesirable. We only want to lint when
" a file is saved, not when it is first opened, or when it is changed, or when
" we leave insert mode:

let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0
let g:ale_lint_on_insert_leave = 0

" And we customize the icons that appear in the gutter when issues are reported:

let g:ale_sign_error = 'X'
let g:ale_sign_warning = '!'

" We also fix Rubocop so that Bundler is used to run it:

let g:ale_ruby_rubocop_executable = 'bundle'

" Next, we configure the plugin not to fix files when they are saved:

let g:ale_fix_on_save = 0

" Here's a problem: Some of the linters run even if their configuration files
" don't exist. This currently happens for Ruby and JavaScript and is not very
" helpful. Ideally Ale should detect this, but it doesn't. Here's a fix in the
" meantime, gleaned from [this comment][ale-fix]:
"
" [ale-fix]: https://github.com/w0rp/ale/issues/940#issuecomment-380490927

function! s:DiscoverRubyLinters() abort
  let linters = []

  if findfile('.standard.yml', '.;') !=# ''
    call add(l:linters, 'standardrb')
  endif

  if findfile('.rubocop.yml', '.;') !=# ''
    call add(l:linters, 'rubocop')
  endif

  call add(l:linters, 'ruby')

  let g:ale_linters = { 'ruby': l:linters }
endfunction

function! s:DiscoverJavaScriptLinters() abort
  let linters = []
  let eslint_config_files = globpath('.', '.eslintrc*', 0, 1)

  if len(l:eslint_config_files) > 0 && len(join(readfile(l:eslint_config_files[0], '', 1), '\n')) > 0
    call add(l:linters, 'eslint')
  endif

  let g:ale_linters = { 'javascript': l:linters }
endfunction

augroup local
  autocmd BufEnter *.js call s:DiscoverJavaScriptLinters()
  autocmd BufEnter *.rb call s:DiscoverRubyLinters()
augroup END

" === Mappings ===

" We customize the mapping to go to the next linter error:
nmap <Leader>an <Plug>(ale_next_wrap)

" Elm is known to output detailed error messages. By default, Ale will show
" errors in a quickfix window, but you can reveal the full error message for a
" particular line in a larger window with :ALEDetail. Here we make that easier
" to open:
nmap <Leader>ae <Plug>(ale_detail)
" Instead, we bind this behavior to `,af`:
nmap <Leader>af <Plug>(ale_fix)

" Sometimes we need to figure out which linter Ale ran for the given file, or
" whether Ale even ran at all. We can use `,ai` to do this:
nmap <Leader>ai :ALEInfo<CR>
