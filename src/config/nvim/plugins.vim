" Plugins I use all the time
" ==========================

Plug '~/.config/nvim/plugged/vim-colors-solarized'

Plug 'AndrewRadev/splitjoin.vim'
Plug 'Konfekt/FastFold'
Plug 'Yggdroot/indentLine'
Plug 'andymass/vim-matchup'
Plug 'bfredl/nvim-miniyank'
Plug 'christoomey/vim-tmux-navigator'
Plug 'christoomey/vim-tmux-runner'
Plug 'eapache/auto-pairs'
Plug 'ervandew/supertab'
Plug 'godlygeek/tabular'
Plug 'itchyny/lightline.vim'
Plug 'jszakmeister/vim-togglecursor'
Plug 'kien/ctrlp.vim'
Plug 'mileszs/ack.vim'
Plug 'nelstrom/vim-textobj-rubyblock', { 'for': 'ruby' } | Plug 'kana/vim-textobj-user'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'w0rp/ale'
Plug 'vim-test/vim-test'

" Language-specific plugins
" -------------------------

Plug 'ElmCast/elm-vim'
Plug 'HerringtonDarkholme/yats'
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'aliou/bats.vim'
Plug 'avakhov/vim-yaml'
Plug 'dart-lang/dart-vim-plugin'
Plug 'djbender/vim-slim'
Plug 'cespare/vim-toml'
Plug 'editorconfig/editorconfig-vim'
" JSON plugin which fixes autoindentation within arrays
Plug 'jakar/vim-json'
Plug 'jtratner/vim-flavored-markdown'
Plug 'jxnblk/vim-mdx-js'
Plug 'kchmck/vim-coffee-script'
Plug 'pangloss/vim-javascript'
Plug 'tbastos/vim-lua'
Plug 'tpope/vim-cucumber'
Plug 'tpope/vim-haml'
" Make sure vim-projectionist is listed BEFORE vim-rails!
" See: <https://github.com/tpope/vim-rails/issues/330>
Plug 'tpope/vim-projectionist' | Plug 'tpope/vim-rails'
Plug 'vim-ruby/vim-ruby'
Plug 'yuezk/vim-js'

" Plugins I sometimes use (and may disable later)
" ===============================================

"Plug 'SirVer/ultisnips'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
Plug 'jeetsukumaran/vim-markology'
Plug 'junegunn/goyo.vim'
Plug 'reedes/vim-pencil'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-unimpaired'

" Plugins I enabled at one point but realized I might not need
" ============================================================

"Plug 'ap/vim-css-color'
"Plug 'briancollins/vim-jst'
"Plug 'cakebaker/scss-syntax.vim'
"Plug 'chr4/nginx.vim'
"Plug 'ciaranm/detectindent'
"Plug 'danchoi/ruby_bashrockets.vim'
"Plug 'digitaltoad/vim-pug'
"Plug 'ds26gte/scmindent'
"Plug 'eagletmt/neco-ghc'
"Plug 'elixir-lang/vim-elixir'
"Plug 'eraserhd/parinfer-rust', {'do':
        "\  'cargo build --release'}
"Plug 'frankier/vim-eve'
"Plug 'gisraptor/vim-lilypond-integrator'
"Plug 'guns/vim-clojure-highlight'
"Plug 'guns/vim-clojure-static'
"Plug 'guns/vim-sexp'
"Plug 'hallison/vim-ruby-sinatra'
"Plug 'jparise/vim-graphql'
"Plug 'junegunn/limelight.vim'
"Plug 'juvenn/mustache.vim'
"Plug 'kien/rainbow_parentheses.vim'
"Plug 'marcweber/vim-addon-mw-utils'
"Plug 'mcmire/vim-grakn'
"Plug 'noah/vim256-color'
"Plug 'othree/html5-syntax.vim'
"Plug 'posva/vim-vue'
"Plug 'reasonml-editor/vim-reason-plus'
"Plug 'shime/vim-livedown'
"Plug 'timburgess/extempore.vim'
"Plug 'tomtom/tlib_vim'
"Plug 'tpope/vim-bundler'
"Plug 'tpope/vim-classpath'
"Plug 'tpope/vim-dispatch'
"Plug 'tpope/vim-fireplace'
"Plug 'tpope/vim-git'
"Plug 'tpope/vim-rbenv'
"Plug 'tpope/vim-sexp-mappings-for-regular-people'
"Plug 'vim-scripts/FormatBlock'
"Plug 'vim-scripts/IndentAnything'
"Plug 'vim-scripts/scribble.vim'
"Plug 'wlangstroth/vim-racket'
"Plug 'https://gist.github.com/369178.git'   " less
