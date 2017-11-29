" Plugin configuration
" ====================

" This file is where any settings related to plugins go.

" NERDTree
" --------

" `,tt` toggles the [NERDTree]:
"
" [NERDTree]: https://github.com/scrooloose/nerdtree

nnoremap <silent> <Leader>tt :NERDTreeToggle<CR>

" `,tf` tells NERDTree to open the tree and jump to the file that's currently
" open. To get this to work properly, we first open the NERDTree in the current
" working directory, then we jump to the file; this way the find doesn't change
" the root directory that the tree is set to.

nnoremap <silent> <Leader>tf :NERDTree<CR><C-w>p:NERDTreeFind<CR>

" We tell NERDTree to ignore `.pyc` (Python), `.rbc` (Rubinius), and swap files
" by default:

let NERDTreeIgnore=['\.pyc$', '\.rbc$', '\~$']

" Lastly, we make it so that if the only buffer you have open is a NERDTree and
" you close it, you also close Vim:

augroup local
  autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
augroup END

" Ctrl-P
" ------

" The installation instructions for [Ctrl-P] say that we must do this in order
" for the plugin to work:
"
" [Ctrl-P]: https://github.com/ctrlpvim/ctrlp.vim

set runtimepath^=~/.vim/bundle/ctrlp

" We position Ctrl-P at the top, set the maximum number of matches to 20, and
" have better matches appear before worse ones:

let g:ctrlp_match_window_bottom = 0
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_max_height = 20

" Usually Ctrl-P's working directory is the same as the open file, but since we
" usually have whole projects open, it's better to use the current working
" directory:

let g:ctrlp_working_path_mode = 'w'

" We use Ag to generate search results:

if executable('ag')
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

" Lastly, we make it easier to search by tag. (I added this when I was
" experimenting with tag generation, but I didn't get very far.)

noremap <Leader>pt :CtrlPTag<CR>

" Ack.vim
" -------

" [Ag] is used to search through projects, but in a roundabout way. Here we
" actually use [Ack.vim], as it's more maintained, but we just override it to
" use Ag:
"
" [Ag]: https://github.com/ggreer/the_silver_searcher
" [Ack.vim]: https://github.com/mileszs/ack.vim

let g:ackprg = 'ag --vimgrep'

" By default, `:Ack` will jump to the first result automatically, but `:Ack!`
" won't, so we simply remap it:

cnoreabbrev Ack Ack!

" NERDCommenter
" -------------

" [NERDCommenter] has trouble applying Ruby comments for some reason, so we help
" it out:
"
" [NERDCommenter]: https://github.com/scrooloose/nerdcommenter

let g:NERDCustomDelimiters = {
      \ 'ruby': { 'left': '# ' }
      \ }

" indentLine
" ----------

" Here we specify how to show the vertical lines that [indentLine] displays. The
" color 10 here is the [same color that Solarized uses for
" "base01"][solarized-10].
"
" [indentLine]: https://github.com/Yggdroot/indentLine
" [solarized-10]: https://github.com/altercation/vim-colors-solarized/blob/528a59f26d12278698bb946f8fb82a63711eec21/colors/solarized.vim#L287

let g:indentLine_char = '⡇'
let g:indentLine_color_term = 10

" coffee-script
" -------------

" The [CoffeeScript plugin][coffee-script-vim] is a bit overzealous in its
" highlighting. Here we turn off highlighting for curly braces, square brackets,
" parentheses and operators:
"
" [coffee-script-vim]: https://github.com/kchmck/vim-coffee-script

hi link coffeeObject NONE
hi link coffeeBracket NONE
hi link coffeeCurly NONE
hi link coffeeParen NONE
hi link coffeeSpecialOp NONE

hi clear Operator
hi clear SpecialOp

" Since CoffeeScript is installed via npm globally, we tell the plugin where to
" find it:

let coffee_compiler = "/usr/local/bin/coffee"

" Airline
" -------

" We configure the look of [Airline]:
"
" [Airline]: https://github.com/vim-airline/vim-airline

let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols_branch = ''
let g:airline_symbols_readonly = ''
let g:airline_symbols_linenr = ''

" We tell Vim to always show a status line (which Airline replaces) regardless
" of how many windows are visible, otherwise Airline only appears for split
" windows:

set laststatus=2

" Since Airline already shows the mode, hide the mode that Vim displays by
" default (e.g. `--- INSERT ---`):

set noshowmode

" ShowMarks
" ---------

" Here we configure [ShowMarks] so that its color fits with Solarized better:
"
" [ShowMarks]: https://github.com/vim-scripts/ShowMarks

hi default ShowMarksHLl cterm=bold ctermfg=darkblue ctermbg=233
hi default ShowMarksHLu cterm=bold ctermfg=darkblue ctermbg=233
hi default ShowMarksHLo cterm=bold ctermfg=darkblue ctermbg=233
hi default ShowMarksHLm cterm=bold ctermfg=darkblue ctermbg=233

" splitjoin
" ---------

" [splitjoin] has some strange default behavior, so we attempt to corral it.
" First, we specify that when taking a hash split across multiple lines and
" turning it into a single line, keep the curly braces around the hash:
"
" [splitjoin]: https://github.com/AndrewRadev/splitjoin.vim

let g:splitjoin_ruby_curly_braces = 0

" Next we tell the plugin that when splitting up a method that's one line into
" multiple lines, place the arguments on their own line instead of placing the
" first argument on the same line as the method call:

let g:splitjoin_ruby_hanging_args = 0

" vim-flavored-markdown
" ---------------------

" Here we're simply configuring the [vim-flavored-markdown] plugin so that it
" highlights all Markdown files as Github-Flavored Markdown:
"
" [vim-flavored-markdown]: https://github.com/jtratner/vim-flavored-markdown

augroup local
  autocmd BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown | setlocal textwidth=80
augroup END

" vim-slim
" --------

" `smartindent` messes things up for Slim files, so we disable that:

augroup local
  autocmd FileType slim setl nosmartindent
augroup END

" vim-tmux-runner
" ---------------

" Here we configure [vim-tmux-runner] so that before a command gets run, the
" prompt within the Tmux pane in question is cleared:
"
" [vim-tmux-runner]: https://github.com/christoomey/vim-tmux-runner

let g:VtrClearSequence = "clear"

" We also map `,o` so that we can easily open a pane that's
" 35% of the screen width. You may want to increase this size on larger screens.

nmap <leader>o :VtrOpenRunner({'orientation': 'h', 'percentage': 35})<CR>

" vim-spec-runner
" ---------------

" We configure [vim-spec-runner] so that commands are prepended with `bundle
" exec`:
"
" [vim-spec-runner]: https://github.com/gabebw/vim-spec-runner

let g:spec_runner_dispatcher = 'call VtrSendCommand("bundle exec {command}")'

" The plugin will automatically write the current file before running specs, but
" considering we don't autosave any other time we use Vim, we turn this off:

let g:disable_write_on_spec_run = 1

" Finally, we create some mappings:
"
" * `,t` to run the current spec file
" * `,s` to run just one spec (the one the cursor is within)
" * `,l` to run whichever command was run last

map <leader>t <plug>RunCurrentSpecFile
map <leader>s <plug>RunFocusedSpec
map <leader>l <plug>RunMostRecentSpec

" rainbow_parentheses
" -------------------

" We enable [Rainbow Parentheses] for Ruby and Clojure files:
"
" [Rainbow Parentheses]: https://github.com/kien/rainbow_parentheses.vim

augroup local
  autocmd VimEnter ruby,clojure RainbowParenthesesToggle
  autocmd Syntax   ruby,clojure RainbowParenthesesLoadRound
  autocmd Syntax   ruby,clojure RainbowParenthesesLoadSquare
  autocmd Syntax   ruby,clojure RainbowParenthesesLoadBraces
augroup END

" We also add a ton more variety to the colors:

let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['red',         'firebrick3'],
    \ ['brown',       'RoyalBlue3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['red',         'firebrick3'],
    \ ]

" vim-sexp
" --------

" We configure [vim-sexp] so that when editing Clojure files, parentheses,
" brackets and braces are not auto-paired:
"
" [vim-sexp]: https://github.com/guns/vim-sexp

let g:sexp_enable_insert_mode_mappings = 0

" Ale
" ---

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
      \  'ruby': ['rubocop'],
      \  'javascript': ['eslint'],
      \  'typescript': ['tslint'],
      \  'scss': ['sass-lint'],
      \  'css': ['csslint'],
      \  'elm': ['make'],
      \}

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
" * [Prettier] to fix JavaScript, TypeScript, SCSS, and CSS files
" * [Rubocop] to fix Ruby files
" * [elm-format] to fix Elm files
"
" [prettier]: https://github.com/prettier/prettier
" [Rubocop]: https://github.com/bbatsov/rubocop
" [elm-format]: https://github.com/avh4/elm-format

let g:ale_fixers = {
      \  'ruby': ['rubocop'],
      \  'javascript': ['prettier'],
      \  'typescript': ['prettier'],
      \  'scss': ['prettier'],
      \  'css': ['prettier'],
      \  'elm': ['format'],
      \}

" auto-pairs
" ----------

" [AutoPairs] used to be enabled by default, but now we disable it:
"
" [AutoPairs]: https://github.com/jiangmiao/auto-pairs

let g:AutoPairs = {}

" However, we make it so that it can be toggled with
" `,apt`:

let g:AutoPairsShortcutToggle = "<Leader>apt"

" We also provide some more mappings for working with auto-pairs in other ways,
" although truthfully, I don't use them that much:

let g:AutoPairsShortcutFastWrap = "<Leader>apw"
let g:AutoPairsShortcutJump = "<Leader>apj"
let g:AutoPairsShortcutBackInsert = "<C-n>"

" vim-tmux-navigator
" ------------------

" [vim-tmux-navigator] has perfectly sane default mappings; however, if you
" re-source your Vim configuration (say, after modifying it) then these mappings
" will go away. So here we redefine them:
"
" [vim-tmux-navigator]: https://github.com/christoomey/vim-tmux-navigator

let g:tmux_navigator_no_mappings = 1

nmap <silent> <C-h> :TmuxNavigateLeft<cr>
nmap <silent> <C-j> :TmuxNavigateDown<cr>
nmap <silent> <C-k> :TmuxNavigateUp<cr>
nmap <silent> <C-l> :TmuxNavigateRight<cr>

" Limelight
" ---------

" We configure [Limelight] so that the color it uses matches Solarized colors:
"
" [Limelight]: https://github.com/junegunn/limelight.vim

" TODO: Fix this color
let g:limelight_conceal_ctermfg = 239

" vim-togglecursor
" ----------------

" We configure [togglecursor] so that the default cursor is a non-blinking block
" in Command mode and a non-blinking vertical line in Insert mode.
"
" [togglecursor]: https://github.com/jszakmeister/vim-togglecursor

let g:togglecursor_default = 'block'
let g:togglecursor_insert = 'line'
let g:togglecursor_leave = 'block'

" ruby_bashrockets
" ----------------

" [Bashrockets] is nice, but it doesn't have a convenient way to apply
" conversions across a selection, which is its most common use case. These two
" commands let us do that:
"
" [Bashrockets]: https://github.com/danchoi/ruby_bashrockets.vim

command! -range HashrocketStyle :<line1>,<line2>Bashrockets
command! -range KeywordArgumentStyle :<line1>,<line2>Hashrockets

" Colorizer
" ---------

" By default, [Colorizer] doesn't turn on automatically. Here we turn it on for
" CSS and Sass files:
"
" [Colorizer]: https://github.com/lilydjwg/colorizer

let g:colorizer_auto_filetype = 'css,scss'

" The plugin also colorizes color strings in comments, but we turn that off here:

let g:colorizer_skip_comments = 1

" vim-jsx
" -------

" [This plugin][jsx] assumes that JSX files end in .jsx. This doesn't seem to be
" a standard in the JavaScript community; it makes more sense to allow JSX in
" any JavaScript file:
"
" [jsx]: https://github.com/mxw/vim-jsx

let g:jsx_ext_required = 0

" neco-ghc
" --------

" Here we configure tab completion for Haskell files:

let g:haskellmode_completion_ghc = 1
autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

" elm-vim
" -------
"
" [This plugin][elm-vim] causes Elm files you write to reformat themselves by
" way of elm-format on save. It's better to be explicit than implicit in these
" kinds of things. We've configured Ale so that you can do this manually with
" `,f`, so we can disable that behavior here:
"
" [elm-vim]: https://github.com/ElmCast/elm-vim

let g:elm_format_autosave = 0

" UltiSnips
" ---------

let g:UltiSnipsJumpForwardTrigger="<c-a>"
let g:UltiSnipsJumpBackwardTrigger="<c-s>"
