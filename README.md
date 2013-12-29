# dotfiles

This is where I keep configuration for zsh, RubyGems, git, and other stuff.

## Prerequisites

This configuration is moderately reliant on zsh, so you'll want to install that
first. Because I am not a zsh guru, I use oh-my-zsh, so install that first:

    git clone http://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

Then, set zsh as your default shell:

    chsh -s zsh

## Installation

First, clone this repo somewhere. I recommend you put it in your ~/code folder
because you may want to come back to it later, or fork it.

Next, run the install script:

    script/install

By default this will copy the files to your home directory, but if you've
forked this repo and plan on developing it further, then you may want to create
symlinks instead:

    script/install --link

If you want to know what this will do first, say:

    script/install --dry-run

Finally, for further help, say:

    script/install --help

## Author

Elliot Winkler (<elliot.winkler@gmail.com>)
