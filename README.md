# dotfiles

This is where I keep configuration for zsh, tmux, git, and other stuff.

## Prerequisites

### zsh

The configuration here relies on zsh, so you'll need that first. Install it via
Homebrew...

    brew install zsh

...then set it as your default shell:

    sudo dscl . -create /Users/$USER UserShell /usr/local/bin/zsh

In addition, you will need to prevent OS X from loading *its* zsh configuration.
You can do that by saying:

    sudo mv /etc/zprofile /etc/zprofile.old

### Ruby

Although OS X ships with Ruby, it's better to use a version manager. I recommend
`rbenv`. You can install that with:

    brew install rbenv

To install the latest version of Ruby, say:

    ruby_version=$(rbenv install --list | grep -v 'preview\|dev' | egrep '^\s+\d' | tail -n 1 | sed -Ee 's/^[ ]+//g')
    rbenv install $ruby_version
    rbenv global $ruby_version

## Python

Although OS X ships with Python, it's better to use a version manager. I
recommend `pyenv`. You can install that with:

    brew install pyenv

To install the latest version of Python, say:

    python_version=$(pyenv install --list | grep -v '\db\d\|dev' | egrep '^\s+\d' | tail -n 1 | sed -Ee 's/^[ ]+//g')
    pyenv install $python_version
    pyenv global $python_version

Any Pythons installed via `pyenv` will automatically include Pip. You may need
to upgrade it, however:

    pip install --upgrade pip

### Node

I use `nvm` to manage Node versions. You can install it with:

    brew install node nvm

To install the latest version of Node, say:

    nvm install $(nvm ls-remote | tail -n 1 | sed -Ee 's/'"$(printf '\x1b')"'\[[[:digit:]]+;[[:digit:]]+m//g' | sed -Ee 's/^->?[ ]+v//')

### tmux

You'll need **tmux 2.5** or higher. (Under tmux 2.0+, new windows will keep the
working directory, and 2.3+ supports copying to the clipboard automatically when
you select stuff with the mouse.) You can install it with:

    brew install tmux

To help with copying and pasting within tmux, you'll also want
`reattach-to-user-namespace`:

    brew install reattach-to-user-namespace

### Powerline

You'll need the Powerline support files for tmux:

    pip install powerline-status

### Extra packages

There are a few extra utilities that I make use that are super helpful in my
day-to-day:

* [autojump] lets you navigate quickly to projects.
* [fzf] gives you a fuzzy-finder on the command line. Super helpful for running
  tests.
* [hub] is `git` but with some extra features, such as being able to check out
  pull requests by using the URL instead of a branch name.

You can install these with:

    brew install autojump fzf hub

[autojump]: https://github.com/wting/autojump
[fzf]: https://github.com/junegunn/fzf
[hub]: https://github.com/github/hub

## Installation

Now for the fun part. To actually install the configuration inside this repo,
you'll need to clone it somewhere first. I recommend you put it in your `~/code`
folder because you may want to come back to it later, or fork it and make it
your own.

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

## Post-installation

There are also some little things you'll have to do to make life easier.
Eventually I'll probably make some kind of script to handle these cases, but for
now:

* To enable key-repeating for VS Code, run:
  ```
  defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
  ```

## Known issues

If, after starting tmux, you receive a warning about `powerline.conf` not being
able to be loaded, your local Python directory may be owned by root instead of
you. You can change the ownership like this:

    sudo chown -R $USER:staff ~/Library/Python

## Author

Elliot Winkler (<elliot.winkler@gmail.com>)
