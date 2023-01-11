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
Plug 'neoclide/coc.nvim', { 'commit': '0fd56dd' }
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
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'aliou/bats.vim'
Plug 'avakhov/vim-yaml'
Plug 'dart-lang/dart-vim-plugin'
Plug 'datwaft/prolog-syntax-vim', { 'branch': 'main' }
Plug 'djbender/vim-slim'
Plug 'cespare/vim-toml', { 'branch': 'main' }
Plug 'editorconfig/editorconfig-vim'
" JSON plugin which fixes autoindentation within arrays
Plug 'jakar/vim-json'
Plug 'jtratner/vim-flavored-markdown'
Plug 'jxnblk/vim-mdx-js'
Plug 'kchmck/vim-coffee-script'
Plug 'leafgarland/typescript-vim'
Plug 'moll/vim-node'
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

"Plug 'github/copilot.vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
Plug 'jeetsukumaran/vim-markology'
Plug 'junegunn/goyo.vim'
Plug 'reedes/vim-pencil'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-unimpaired'
