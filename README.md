# vimfiles

This is a fully-fledged Neovim configuration, ready to go for Ruby, Rails,
JavaScript, and JSX, as well as other languages such as Elm, Haskell, and
Clojure.

## What's inside

### Handy plugins

This configuration comes with a boatload of plugins for various use cases and
languages, but here are the most important ones:

* [NERDTree][vim-nerdtree] -- a simple file tree
* [Ctrl-P][vim-ctrl-p] -- a fuzzy file finder for quickly jumping to files
* [Ack][vim-ack] + [Ag][ag] -- a way to search across a project lightning quick
* [NERDCommenter][vim-nerdcommenter] -- an easy way to comment out lines and
  blocks of code and then uncomment them using the same mapping
* [SuperTab][vim-supertab] -- an autocomplete that's admittedly dumb, but also
  doesn't get in your way
* [Ale][ale] -- an asychronous linter that can also autoformat files
* [indentLine][indent-line] -- gives you a horizontal grid so you can quickly
  tell if a line is misindented
* [surround][vim-surround] -- a way to quickly surround a selection or text
  object with non-pairing or pairing characters (`"`", `'`', `(`, `)`, etc.)
* [togglecursor][vim-togglecursor] -- makes insert and command modes more
  obvious by switching the cursor (and does so in both iTerm and tmux)
* [vim-textobj-rubyblock][vim-textobj-rubyblock] -- adds Ruby blocks as text
  objects so that they can be manipulated and selected
* [endwise][vim-endwise] -- automatically adds `end` to a Ruby block in a
  non-intrusive manner

[vim-plug]: https://github.com/junegunn/vim-plug
[vim-nerdtree]: http://github.com/scrooloose/nerdtree
[vim-ctrl-p]: http://github.com/kien/ctrlp.vim
[vim-ack]: https://github.com/mileszs/ack.vim
[vim-supertab]: http://github.com/ervandew/supertab
[vim-togglecursor]: https://github.com/jszakmeister/vim-togglecursor
[vim-nerdcommenter]: http://github.com/scrooloose/nerdcommenter
[vim-endwise]: https://github.com/tpope/vim-endwise
[vim-surround]: http://github.com/tpope/vim-surround
[vim-textobj-rubyblock]: http://github.com/nelstrom/vim-textobj-rubyblock
[ale]: https://github.com/w0rp/ale
[indentLine]: https://github.com/Yggdroot/indentLine

### Sensible defaults

* Lines in files of most filetypes are hard-wrapped to 80 characters
* The system clipboard is used for copying/pasting
* Incremental search provides more feedback than the default search behavior
* `Rakefile`, `Gemfile`, and `*.gemspec` files are highlighted as Ruby files
* `.jshintrc` and `.eslintrc` are highlighted as JSON files

### Sensible mappings

* `,` is the leader key (so no finger gymnastics)
* `Ctrl-{H,J,K,L}` lets you navigate to windows in Vim *and to panes in tmux*
* `j` and `k` always place the cursor one line below or above, regardless of
  whether lines are being wrapped
* `%` bounces between the start and end of blocks (in languages that make it
  possible to do so)
* `<` and `>` no longer lose drop the selection when indenting a selected block
  of text
* `Q` lets you reformat paragraphs
* `Y` provides an analog to `C` and `D`

## Making this your own

Want this configuration for yourself? Read on.

### Prerequisites

There are a few things you'll need before you can install the files here.

#### Neovim

First, this configuration assumes you're using Neovim. You can install this
using Homebrew:

    brew install neovim/neovim/neovim

If you're using [mcmire/dotfiles][dotfiles], you're good to go here. Otherwise,
it's recommended that you add a short alias to your shell so that you can start
Neovim from any directory with `v`:

    alias v="nvim"

[dotfiles]: http://github.com/mcmire/dotfiles

#### iTerm

Next, you'll need to install iTerm if you don't already have it. Once you have
it, you'll want to drop into Preferences and make three changes.

##### Color scheme

In this configuration, Vim uses [Solarized] as its color scheme. Solarized is a
lovely color scheme as it has been finely crafted with **science** (okay,
light/perception theory) so that the difference between its dark and light modes
are only a few colors. In order to prevent your colors in Vim from looking off,
you'll need to configure iTerm to use Solarized as well.

To do this, first, download the color scheme files [here][solarized]. Look for a
directory that corresponds to iTerm, then double-click on the color scheme files
(dark *and* light).

This will install the color scheme files, but now we need to apply them. The
best way to do this is to click on the Profiles tab and create two new iTerm
profiles, one called Solarized Light, the other called Solarized Dark. Now you
can go into each profile, click on the Colors tab, and select a color preset.

[image]

##### Font

Now that you have two profiles, go into each one and configure them to use [Fira
Code] as the font. Fira Code is a cool font where common combinations of symbols
that we might use in everyday code (`->`, `...`, and `|>`, just to name a few)
are implemented as ligatures, so they appear closer together, thereby making it
possible to scan code more easily. More importantly, Fira Code contains symbols
that work perfectly with Powerline/Airline (you don't have to bother with any of
[these][powerline-fonts]).

[Solarized]: https://github.com/altercation/solarized
[Fira Code]: https://github.com/tonsky/FiraCode
[powerline-fonts]: https://github.com/Lokaltog/powerline-fonts

#### Ag (aka the Silver Searcher)

Vim is configured to use [Ag][ag] for fuzzy file finding, so you'll also need
this as well. You can install it with Homebrew:

[ag]: https://github.com/ggreer/the_silver_searcher

    brew install ag

If you already have Ag, make sure you're on a recent version. You can upgrade by
saying:

    brew upgrade ag

### Installing

Now that you have the prerequisites out of the way, you can actually install
these configuration files and get started Vimming.

First, you need to download this repo somehow. You'll probably want to come back
to these files later, make modifications to them, and push them up, so fork this
repo, then clone your fork in a convenient place you'll remember, such as the
same place you store code. For example:

    cd myawesomecode
    git clone git://github.com:myusername/vimfiles.git

If you already installed Vim at some point in the past, then you'll want to make
sure you remove all of those configuration files first. At a minimum, you'll
want to run:

    mv ~/.vim ~/.vim.old
    mv ~/.vimrc ~/.vimrc.old

Next, run the install script that comes bundled with this repo. Since you forked
the repo in the first step above, it's best that you install all of the files
here as *symlinks*. This will allow you to edit them *either* directly *or*
through your forked repo location:

    script/install --link --dry-run

You might have been a little scared to run that command, right? Don't worry --
nothing's actually happened yet. To confirm the installation, run:

    script/install --link

### After installing

You're almost there! Now you're ready to install plugins. You can do that by
opening Vim (remember, you can say `v` since you made an alias) and running:

    :PlugInstall

Now close Vim and re-open it, and you should be good to go!

### You're done!

Enjoy your shiny new Vim installation!
