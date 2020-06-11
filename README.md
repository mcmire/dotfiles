# dotfiles

This repo holds a fully-fledged environment for working well as a web developer
on a Mac.

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

[autojump]: https://github.com/wting/autojump
[fzf]: https://github.com/junegunn/fzf

## Making this your own

### Prequisites

#### macOS

As stated above, this whole environment assumes that you are using macOS. If you
do not have this, then you will need to adapt the instructions below to your
setup.

#### Command Line Tools

First, you will need to install the Command Line Tools if you have not already
done so. You can do this by saying:

    xcode-select --install

#### zsh

This configuration assumes use of zsh as the shell, so you'll need that as well.
Fortunately, newer versions of macOS starting with Catalina use zsh by default.
If you have an older Mac, though, you can install zsh via Homebrew:

    brew install zsh

Then you'll want to set it as your default shell:

    sudo dscl . -create /Users/$USER UserShell /usr/local/bin/zsh

In addition, you will need to prevent OS X from loading its zsh configuration.
You can do that by saying:

    sudo mv /etc/zprofile /etc/zprofile.old

#### asdf

`asdf` makes it super simple to manage and install different versions for
languages using one common tool. You'll want to install it with:

    brew install asdf

Run this command to load asdf:

    source $(brew --prefix asdf)/asdf.sh

then say:

    asdf plugin add ruby
    asdf plugin add python
    asdf plugin add nodejs

Note that in order to install Node packages you'll need to install some basic
packages:

    brew install coreutils gpg

Then you'll need to import GPG keys:

    ~/.asdf/plugins/nodejs/bin/import-release-team-keyring

Now you can install the latest version of each language:

    asdf install ruby latest
    asdf install python latest
    asdf install nodejs latest

And make the latest versions the default versions:

    latest-version-of() { echo $(asdf list $1 | grep -v 'preview\|dev' | egrep '^\s+\d' | tail -n 1 | sed -Ee 's/^[ ]+//g') }
    asdf global ruby $(latest-version-of ruby)
    asdf global python $(latest-version-of python)
    asdf global nodejs $(latest-version-of nodejs)

You can run this command to double-check the versions that asdf set:

    asdf current

Note that any Pythons installed will automatically include Pip. If you need to
upgrade it, you can run:

    pip install --upgrade pip

#### tmux

tmux is invaluable for managing different sessions within a project (and for
grouping projects together so that you can work on multiple projects at the same
time). You'll want to install tmux by saying:

    brew install tmux

To help with copying and pasting within tmux, you'll also want to install
`reattach-to-user-namespace`:

    brew install reattach-to-user-namespace

#### Extra packages

Finally, you'll want to install the remainder of the tools mentioned above:

    brew install autojump fzf

### Installing symlinks

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
course – or you can integrate them to this config).

Next, you will want to run the script that comes bundled with this repo. Since
you forked the repo, it's best that you install all of the files here as
symlinks. This will allow you to edit them through your forked repo location.
Furthermore, since you're probably running this for the first time, you'll want
to provide your Git name and email, which will be used to author commits:

    bin/manage install --git-name "Your Name" --git-email "your@email.com" --dry-run

This will tell you what would have been installed, but not actually do anything.
If everything looks good and makes sense here, then run:

    bin/manage install --git-name "Your Name" --git-email "your@email.com"

After you've done this, open tmux. You may receive a warning at the top of the
screen, but ignore that and press Enter. Press <kbd>Ctrl</kbd> +
<kbd>Space</kbd> followed by <kbd>Shift</kbd> + <kbd>I</kbd>. After a brief
delay, plugins will be installed that are necessary for tmux for fully work.
Then restart tmux, and you should no longer receive the warning.

### Optional tasks

Besides installing symlinks, there may be some little things you'll have to do
to make life easier. These are completely optional:

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
serve a purpose. If you don't need it, don't be afraid to toss it out!

Finally, update this README to match any changes you end up making. Who knows —
you might inspire someone else to create their own dotfiles repo!

## Uninstalling everything

To remove the symlinks created during the installation step, run:

    script/manage uninstall --dry-run

As with the installation step, that will merely tell you what uninstallation
would have done, but not do anything. If everything looks good here, then run:

    script/manage uninstall
