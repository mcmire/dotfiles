# dotfiles

This is where I keep configuration for zsh, tmux, git, and other stuff.

## Prerequisites

### zsh

The configuration here relies on zsh, so you'll need that first. Install it via
Homebrew

    brew install zsh

then set it as your default shell:

    sudo dscl . -create /Users/$USER UserShell /usr/local/bin/zsh

In addition, you will need to prevent OS X from loading *its* zsh configuration.
You can do that by saying:

    sudo mv /etc/zprofile /etc/zprofile.old

### tmux

Next, you'll need **tmux 2.5** or higher. (Under tmux 2.0+, new windows will
keep the working directory, and 2.3+ supports copying to the clipboard
automatically when you select stuff with the mouse.) You can install it with:

    brew install tmux

### reattach-to-user-namespace

Next, you'll need `reattach-to-user-namespace`. This helps with copying and
pasting within tmux:

    brew install reattach-to-user-namespace

### Powerline

You'll also need the Powerline support files for tmux:

    pip install --user powerline-status

NOTE: This assumes that you've installed `pip`. As it is not present on new
Macs, you'll need to install it by [following this guide][installing-pip].

[installing-pip]: https://pip.pypa.io/en/stable/installing/#installing-with-get-pip-py

### Ruby

I use `rbenv` to manage Ruby. You can install it with:

    brew install rbenv

After this, you can install a Ruby version by saying:

    rbenv install SOME_RUBY_VERSION

### Node

I use `nvm` to manage Node. You can install it with:

    brew install node nvm

After this, you can install a Node version by saying:

    nvm install 9.10.1   # run `npm ls-remote` and use the last version listed

### Additional packages

You will also need:

* autojump: `brew install autojump`
* hub: `brew install hub`

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
of the screen, but ignore that and press Enter. Press <kbd>Ctrl</kbd> +
<kbd>Space</kbd> followed by <kbd>Shift</kbd> + <kbd>I</kbd>. After a brief
delay, plugins will be installed that are necessary for tmux for fully work.
Then restart tmux, and you should no longer receive the warning.

## Known issues

If, after starting tmux, you receive a warning about `powerline.conf` not being
able to be loaded, your local Python directory may be owned by root instead of
you. You can change the ownership like this:

    sudo chown -R $USER:staff ~/Library/Python

## Author

Elliot Winkler (<elliot.winkler@gmail.com>)
