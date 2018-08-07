" Starting settings
" =================

" Before we start configuring Vim, we need to do a couple of things.
"
" First, we need to load the plugins, which are kept
" [plugins.vim](../plugins.vim). We're using [VimPlug] as the plugin manager. It
" has some nifty features -- for instance, it installs new plugins in parallel
" and gives you a way to defer the loading of plugins until they're used.
"
" [VimPlug]: https://github.com/junegunn/vim-plug

let g:plugin_dir = stdpath('config') . '/plugged'
let s:plugin_config_file = stdpath('config') . '/plugins.vim'

call plug#begin(g:plugin_dir)

if filereadable(s:plugin_config_file)
  execute 'source ' . s:plugin_config_file
endif

call plug#end()

" Next, we need to set up [autocommands] (which we make use of later, in the
" [magic] file). (What's an autocommand? It's a command that runs whenever
" something happens in Vim.) When you define an autocommand, you can choose to
" place it in a group. All of the autocommands that we define in our Vim
" configuration will go in a group that we've called `local`. What does this
" give us? Well, in the event that our Vim configuration is reloaded without
" restarting Vim then we need to remove all of the autocommands that are
" currently present before we start re-adding them. Otherwise, we'll end up with
" duplicate autocommands.
"
" [magic]: magic.vim.md
" [autocommands]: http://vimdoc.sourceforge.net/htmldoc/autocmd.html

augroup local
  autocmd!
augroup END
