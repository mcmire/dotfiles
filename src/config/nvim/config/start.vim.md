*(← Back to [index](../README.md))*

# Starting settings

Before we start configuring Vim, we need to do a couple of things.

First, we need to load some Vim plugins; I keep a list of them in
[plugins.vim](../plugins.vim). [VimPlug] is my plugin manager of choice. It has
some nifty features -- for instance, it installs new plugins in parallel and
gives you a way to defer the loading of plugins until they're used.

[VimPlug]: https://github.com/junegunn/vim-plug

``` vim
call plug#begin(expand('~/.config/nvim/plugged'))

if filereadable(expand('~/.config/nvim/plugins.vim'))
  source ~/.config/nvim/plugins.vim
endif

call plug#end()
```

Next, we need to set up [autocommands] (which we make use of later, in the
[magic] file). (What's an autocommand? It's a command that runs whenever
something happens in Vim.) When you define an autocommand, you can choose to
place it in a group. All of the autocommands that we define in our Vim
configuration will go in a group that we've called `local`. What does this give
us? Well, in the event that our Vim configuration is reloaded without restarting
Vim then we need to remove all of the autocommands that are currently present
before we start re-adding them. Otherwise, we'll end up with duplicate
autocommands.

[magic]: magic.vim.md
[autocommands]: http://vimdoc.sourceforge.net/htmldoc/autocmd.html

``` vim
augroup local
  autocmd!
augroup END
```
