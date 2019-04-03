# dotfiles

This repo holds a fully-fledged environment for working well as a developer.

## What's inside

Most of the environment created here makes it easier to work with the following
tools and languages:

* zsh
* Git
* tmux
* Ruby/RubyGems
* JavaScript

But it also makes use of some handy tools:

* [autojump] — No more setting up aliases to jump directly to projects!
* [fzf] — No more searching through command history! Like `Ctrl-R`, but on
  steroids.
* [hub] — Like `git` but with some extra features, such as being able to check
  out pull requests by using the URL instead of hunting for the branch name.

[autojump]: https://github.com/wting/autojump
[fzf]: https://github.com/junegunn/fzf
[hub]: https://github.com/github/hub

## Making this your own

### Prequisites

Want this configuration for yourself? There are a few things you'll need first.

#### zsh

First, this configuration assumes use of zsh as the shell, so you'll need that
to begin with. Install it via Homebrew...

    brew install zsh

...then set it as your default shell:

    sudo dscl . -create /Users/$USER UserShell /usr/local/bin/zsh

In addition, you will need to prevent OS X from loading its zsh configuration.
You can do that by saying:

    sudo mv /etc/zprofile /etc/zprofile.old

#### Ruby

Although OS X ships with Ruby, it's better to use a version manager, as you will
likely need to install multiple versions of Ruby in the future. This
configuration uses `rbenv` to do this. You can install that with:

    brew install rbenv

To install the latest version of Ruby, say:

    ruby_version=$(rbenv install --list | grep -v 'preview\|dev' | egrep '^\s+\d' | tail -n 1 | sed -Ee 's/^[ ]+//g')
    rbenv install $ruby_version
    rbenv global $ruby_version

#### Python

OS X also ships with Python, but again, it's better to use a version manager,
for similar reasons. This configuration uses `pyenv`, which you can install
with:

    brew install pyenv

To install the latest version of Python, say:

    python_version=$(pyenv install --list | grep -v '\db\d\|dev' | egrep '^\s+\d' | tail -n 1 | sed -Ee 's/^[ ]+//g')
    pyenv install $python_version
    pyenv global $python_version

Any Pythons installed via `pyenv` will automatically include Pip. If you need to
upgrade it, you can run:

    pip install --upgrade pip

#### Node

This configuration also uses `nvm` to manage Node versions. You can install it
with:

    brew install node nvm

To install the latest version of Node, say:

    nvm install $(nvm ls-remote | tail -n 1 | sed -Ee 's/'"$(printf '\x1b')"'\[[[:digit:]]+;[[:digit:]]+m//g' | sed -Ee 's/^->?[ ]+v//')

#### tmux

tmux is invaluable for managing different sessions within a project (and for
grouping projects together so that you can work on multiple at the same time).
For instance, you might 

    brew install tmux

To help with copying and pasting within tmux, you'll also want
`reattach-to-user-namespace`:

    brew install reattach-to-user-namespace

#### Extra packages

Finally, you'll want to install the tools mentioned above:

    brew install autojump fzf hub

### Running the install script

Now that you have the prerequisites out of the way, you can get started using
this configuration.

First, you need to get these files onto your computer somehow. Rather than
merely cloning this repo and then modifying the files therein, the goal of this
configuration is to **get you on a path to creating your own dotfiles**.
Therefore, you'll want to fork this repo so that you can push changes up to
it later. Once you've done this, you can then clone your fork in a convenient
place you'll remember, such as the same place you store code:

    cd ~/your-code-directory
    git clone git@github.com:yourusername/dotfiles.git

Now, chances are you already have some amount of dotfiles in your home
directory. In that case, you will probably want to move them out of the way
before you go any further (you can remove them later, at your leisure, of
course).

Next, run the install script that comes bundled with this repo. Since you forked
the repo, it's best that you install all of the files here as symlinks. This
will allow you to edit them through your forked repo location. Furthermore,
since you're probably running this for the first time, you'll want to provide
your Git name and email, which will be used to author commits:

    script/install --link --git-name "Your Name" --git-email "your@email.com"

After you've done this, open tmux. You may receive a warning at the top of the
screen, but ignore that and press Enter. Press <kbd>Ctrl</kbd> +
<kbd>Space</kbd> followed by <kbd>Shift</kbd> + <kbd>I</kbd>. After a brief
delay, plugins will be installed that are necessary for tmux for fully work.
Then restart tmux, and you should no longer receive the warning.

### Optional tasks

Besides running the install script, there may be some little things you'll have
to do to make life easier. These are completely optional:

* If you want to be able to use VS Code, this will enable key repeating there:
  ```
  defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
  ```

### Known issues

If, after starting tmux, you receive a warning about `powerline.conf` not being
able to be loaded, your local Python directory may be owned by root instead of
you. You can change the ownership like this:

    sudo chown -R $USER:staff ~/Library/Python

## What next?

Once you've installed this configuration onto your own machine, it's up to you
to figure out how you want to customize it! Spend some time going through the
files, particularly the zsh configuration located in `zshrc`, `zshenv`, and
`zsh/`, as well as the tmux config located at `tmux.conf`. Everything should
serve a purpose. If you don't need it, don't be afraid to toss it out.

Finally, update this README to match any changes you end up making. Who knows —
you might inspire someone else to create their own dotfiles repo!
