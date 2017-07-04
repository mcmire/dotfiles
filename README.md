# vimfiles

I ❤️ Vim. I use for both professional and personal projects pretty much every
day. Over time I've created my own configuration, and I thought I might share it
with you.

## What's inside

### Plugins

I use [VimPlug][vim-plug] to manage my plugins. Here are the ones that I use on
a regular basis, in rough order of importance:

* [NERDTree][vim-nerdtree]
* [Ctrl-P][vim-ctrl-p]
* [Ag][vim-ag]
* [Airline][vim-airline]
* [SuperTab][vim-supertab]
* [togglecursor][vim-togglecursor]
* [NERDCommenter][vim-nerdcommenter]
* [endwise][vim-endwise]
* [surround][vim-surround]
* [vim-textobj-rubyblock][vim-textobj-rubyblock]
* [Neomake][neomake]

[vim-plug]: https://github.com/junegunn/vim-plug
[vim-nerdtree]: http://github.com/scrooloose/nerdtree
[vim-ctrl-p]: http://github.com/kien/ctrlp.vim
[vim-ag]: http://github.com/rking/ag.vim'
[vim-airline]: http://github.com/bling/vim-airline
[vim-supertab]: http://github.com/ervandew/supertab
[vim-togglecursor]: https://github.com/jszakmeister/vim-togglecursor
[vim-nerdcommenter]: http://github.com/scrooloose/nerdcommenter
[vim-endwise]: https://github.com/tpope/vim-endwise
[vim-surround]: http://github.com/tpope/vim-surround
[vim-textobj-rubyblock]: http://github.com/nelstrom/vim-textobj-rubyblock
[neomake]: https://github.com/benekastah/neomake

### Other stuff

A while back I found this killer plugin called [literatevimrc]. It lets you
document your Vim configuration in Markdown alongside the Vim code itself.
[Take a look inside][documentation]!

[literatevimrc]: https://github.com/thcipriani/literate-vimrc
[documentation]: src/config/nvim#vim-configuration

## You can use it too

Want this configuration for yourself? Here's how to make that happen.

### Prerequisites

There are a few things you'll need first.

#### Neovim

First of all, I'm using Neovim, not straight Vim. You can install this using
Homebrew:

    brew install neovim/neovim/neovim

If you are using my [dotfiles][dotfiles], then you can move on to the next step,
as I've set up `v` to open Neovim. Otherwise, you'll need to add them yourself.
Configure your shell to add the following alias:

[dotfiles]: http://github.com/mcmire/dotfiles

    alias v="nvim"

Now you can say `v` to start Neovim.

#### iTerm

You'll need to use iTerm. Mainly this is because presently, it needs to be
configured to work with Neovim -- in the future that won't be necessary, but for
now, that's what works best.

With that out of the way, there are three configuration changes you'll need to
make with regard to iTerm.

* You'll want to change the color scheme to Solarized Dark/Light. You can
  download the color scheme files [here][solarized]. Look for a directory that
  corresponds to iTerm, then double-click on the color scheme files (dark *and*
  light) to install them.

[solarized]: https://github.com/altercation/solarized

* You'll want to make sure iTerm is using a Powerline-compatible
  font, that is, a font that's patched to support Powerline characters (such as
  arrows and icons and things). There's a list of fonts you can choose from
  [here][powerline-fonts]. Whichever one you download, drop it in
  `~/Library/Fonts` and you can use it right away. **Make sure that the
  "non-ASCII" font is also set to the same Powerline font as the "normal" font,
  otherwise you'll get strange "X" characters in place of the Powerline
  characters.**

[powerline-fonts]: https://github.com/Lokaltog/powerline-fonts

* You'll also need to go into Preferences and override the mapping for
  <kbd>Ctrl-H</kbd>. Right now there's a [bug][neovim-bug] in Neovim whereby it
  treats <kbd>Ctrl-H</kbd> as <kbd>Backspace</kbd>. To fix this, you'll need to
  make <kbd>Ctrl-H</kbd> equivalent to `<Escape>[104;5u`. To do this:

  1. Inside of **Preferences**, click on **Keys**.
  2. Press `+` to add a new mapping.
  3. Click inside of **Keyboard Shortcut**, then press <kbd>Ctrl-H</kbd>.
  4. For **Action**, choose "Send Escape Action", and for **Esc+**, type
     `[104;5u`.

[neovim-bug]: https://github.com/neovim/neovim/issues/2048

#### Ag (aka the Silver Searcher)

[Ag][ag] is used for searching through files. In addition, Ctrl-P is hooked up
to use Ag as its search engine.

[ag]: https://github.com/ggreer/the_silver_searcher

You can install Ag by saying:

    brew install ag

If you already have Ag, make sure you're on a recent version. You can upgrade by
saying:

    brew upgrade ag

### Installation

Now for the fun stuff.

First, you need to download this repo to your computer somehow. You'll probably
want to come back to these files later, make modifications to them, and push
them up, so I recommend forking this repo. Put it in a convenient place you'll
remember, such as the same place you store code.

If you already installed Vim at some point in the past, then you'll want to make
sure you remove all of those configuration files first. At a minimum, you'll
want to run:

    mv ~/.vim ~/.vim.old
    mv ~/.vimrc ~/.vimrc.old

Next, run the install script. Since you probably forked the repo in the first
step above, you'll want to symlink all of the files in this repo to appropriate
places in your HOME directory. You can do that with:

    script/install --link

If you want to know what this will do first, say:

    script/install --link --dry-run

For further help, say:

    script/install --help

### Post-installation

Now you're ready to install a bunch of Vim plugins. You can do that by opening
Vim (remember, `v`) and running:

    :PlugInstall

After you run this, close Vim and re-open it.

You shouldn't have any problems doing this step, but if you do, please [create
an issue][issues].

[issues]: http://github.com/mcmire/vimfiles/issues

## Who made this?

Elliot Winkler (<elliot.winkler@gmail.com>)

