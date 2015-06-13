# dotfiles

This is where I keep configuration for zsh, RubyGems, git, and other stuff.

## Prerequisites

This configuration is moderately reliant on zsh, so you'll want to install that
first. Because I am not a zsh guru, I use oh-my-zsh, so install that first:

    git clone http://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

Then, set zsh as your default shell:

    chsh -s zsh

Next, you'll need to install Powerline, which I use for tmux (not vim, which
uses airline):

    (sudo) pip install powerline-status

## Installation

Next, clone this repo somewhere. I recommend you put it in your `~/code` folder
because you may want to come back to it later, or fork it.

Then run the `install` script. This will copy all of the files in this repo as
dotfiles in your home directory:

    script/install

By default this will copy the files, but if you've forked this repo and plan on
developing it further, then you may want to create symlinks instead:

    script/install --link

If you want to know what this command will do first, say:

    script/install --dry-run

Finally, for further help, say:

    script/install --help

## Author

Elliot Winkler (<elliot.winkler@gmail.com>)
