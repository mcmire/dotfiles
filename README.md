# dotfiles

This is where I keep configuration for zsh, RubyGems, git, and other stuff.

## Prerequisites

This configuration is moderately reliant on zsh, so you'll want to install that
first. You can set zsh as your default shell with the following command:

    chsh -s zsh

Next, you'll need to install the Powerline support files, which I use for tmux
(not Vim, which uses Airline):

    sudo pip install --user powerline-status

Finally, ensure that you're using tmux 2.0 or higher (this will make it so that
when you open a new window it keeps the current working directory). If you
already have tmux, you can update it with:

    brew upgrade tmux

## Installation

Next, clone this repo somewhere. I recommend you put it in your `~/code` folder
because you may want to come back to it later, or fork it.

Then run the `install` script. The following commands will create symlinks to
relevant files in the cloned repo so that you can modify them later if need be.

    script/install --link

Finally, after you've done this, open tmux. You may receive a warning at the top
of the screen, but ignore that. Press <kbd>Ctrl</kbd> + <kbd>Space</kbd>
followed by <kbd>Shift</kbd> + <kbd>I</kbd>. This will install plugins that are
necessary for tmux for fully work.

## Known issues

If, after starting tmux, you receive a warning about powerline.conf not being
able to be loaded, your local Python directory may be owned by root instead of
you. You can change the ownership like this:

    sudo chown -R $USER:staff ~/Library/Python

## Author

Elliot Winkler (<elliot.winkler@gmail.com>)
