# dotfiles

This is where I keep configuration for zsh, tmux, git, and other stuff.

## Prerequisites

The configuration here relies on zsh, so you'll need that first. Install it via
Homebrew

    brew install zsh

then set it as your default shell with the following command:

    chsh -s zsh

Next, you'll need **tmux 2.5** or higher. (Under tmux 2.0+, new windows will
keep the working directory, and 2.3+ supports copying to the clipboard
automatically when you select stuff with the mouse.) You can install it with:

    brew install tmux

If you already have it, you can update it with:

    brew upgrade tmux

Next, you'll need `reattach-to-user-namespace`. This helps with copying and
pasting within tmux:

    brew install reattach-to-user-namespace

Finally, you'll need to install the Powerline support files, which I use for
tmux (you may or may not have to run this with `sudo`):

    pip install --user powerline-status

## Installation

To actually install the configuration inside this repo, you'll need to clone it
somewhere first. I recommend you put it in your `~/code` folder because you may
want to come back to it later, or fork it and make it your own.

Then run the `install` script. The `--link` option will create symlinks to
relevant files in the cloned repo so that you can modify them later if need be.
Additionally, if you're running this script for the first time, you'll probably
want to provide your Git name and email, which will be used to author commits.

    script/install --link --git-name "Your Name" --git-email "your@email.com"

Finally, after you've done this, open tmux. You may receive a warning at the top
of the screen, but ignore that. Press <kbd>Ctrl</kbd> + <kbd>Space</kbd>
followed by <kbd>Shift</kbd> + <kbd>I</kbd>. This will install plugins that are
necessary for tmux for fully work. Then restart tmux.

## Known issues

If, after starting tmux, you receive a warning about `powerline.conf` not being
able to be loaded, your local Python directory may be owned by root instead of
you. You can change the ownership like this:

    sudo chown -R $USER:staff ~/Library/Python

## Author

Elliot Winkler (<elliot.winkler@gmail.com>)
