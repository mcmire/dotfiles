# dotfiles

This repo provisions and maintains an environment
optimized for web development on a Mac.
It is updated very frequently!

## What's inside

This environment installs the following pieces of software:

### Tools

* **zsh** — the new standard in shells
* **[tmux]** — corral projects and their many sessions
* **[iTerm]** — a more capable terminal than Terminal.app
* **[Neovim]** — a slimmer and more modern fork of Vim
* **[Git]** — the king of version control software
* **[tig]** — a semi-graphical UI for git
* **[asdf]** — the one language version manager to rule them all
* **[autojump]** — no more setting up aliases to jump directly to projects
* **[fzf]** — a faster and more pleasant version of `Ctrl-R`
* **[direnv]** — automatically load `.env` files in projects
* **[ngrok]** — expose a local server for remote access
* **[heroku]** — interact with Heroku-deployed apps

[tmux]: https://github.com/tmux/tmux/wiki
[iTerm]: https://www.iterm2.com/
[Neovim]: https://neovim.io/
[Git]: https://git-scm.com/
[tig]: https://jonas.github.io/tig/
[asdf]: https://asdf-vm.com/
[autojump]: https://github.com/wting/autojump
[fzf]: https://github.com/junegunn/fzf
[direnv]: https://direnv.net/
[ngrok]: https://ngrok.com/
[heroku]: https://github.com/heroku/cli

### Applications

* **Google Chrome** — the new Internet Explorer
* **Firefox** — for when Chrome doesn't work
* **Slack** — everyone's favorite chat app
* **[1Password]** — a slick password manager
* **[Simplenote]** — a small but mighty cross-platform notes app
* **[Spectacle]** — a way to place your windows with hotkeys
* **[Stay]** — saves and restores locations of windows after switching monitors
* **[Amphetamine]** — keeps your computer from going to sleep
* **[Numi]** — a more capable and pleasant calculator app
* **[Dropbox]** — everyone's favorite cloud storage service
* **Visual Studio Code** — when you don't feel like using Vim
* **Microsoft To Do** — everyone's favorite replacement for Wunderlist

[1Password]: https://1password.com/
[Spectacle]: https://www.spectacleapp.com/
[Stay]: https://cordlessdog.com/stay/
[Numi]: https://numi.app/
[Dropbox]: https://www.dropbox.com/
[Amphetamine]: https://apps.apple.com/us/app/amphetamine/id937984704
[Simplenote]: https://simplenote.com/

### Databases

* **PostgreSQL** — the fully capable opensource database
* **Redis** — the fully capable ultra-light cache store
* **SQLite** — the pocket, ultra embeddable database

### Languages

* Ruby
* Node
* Python

## Installation

So you want to use these dotfiles? Read on!

> NOTE: As indicated above,
> this whole environment assumes that you are using macOS.
> If you're using Linux, then none of this will really work.
> Sorry :(

### Step 1: Fork this repo

First, you need to get these files onto your computer somehow.
You might be tempted to clone this repo and then modify the files inside.
You're perfectly free to do this, of course,
but in the long run,
**you are better off creating your own dotfiles**.
Therefore, it is recommended to fork this repo
so that you can push your own changes up to it later.
So click that button in the top-right corner!

Back? Good.

At this point, you should be reading this from your own fork.
Now clone your fork in a convenient place you'll remember,
such as the same place you store code:

    cd ~/your-code-directory
    git clone git@github.com:yourusername/dotfiles.git

### Step 2: Clear the way

If you already have some amount of dotfiles in your home directory,
you will want to back them up
and move them out of the way before you go any further
(you can remove them later, at your leisure, of course –
or you can integrate them into this config).

### Step 3: Run the install script

Next, you'll want to run the script that comes bundled with this repo.
This script will actually install all of the files as symlinks into your home directory,
which will allow you to edit them through your forked repo location.
Run the script like so, supplying your Git name and email:

    bin/manage install --git-name "Your Name" --git-email "your@email.com" --dry-run

Note the use of `--dry-run` on the end.
This will tell you what would have been installed,
but nothing has happened yet!
Take a moment to look over the output and verify that everything makes sense.
If you're good, then run it again without `--dry-run`:

    bin/manage install --git-name "Your Name" --git-email "your@email.com"

If you are informed that macOS Command Line Tools is not installed,
make sure to install it and then re-run the script.

### Step 4: Install tmux plugins

After installing symlinks,
there's one final step you'll need to perform.
Launch tmux by saying:

    tmux

You may receive a warning at the top of the screen,
but ignore that and press <kbd>Enter</kbd>.
Press <kbd>Ctrl</kbd> + <kbd>Space</kbd> followed by <kbd>Shift</kbd> + <kbd>I</kbd>.
After a brief delay,
plugins will be installed that are necessary for tmux for fully work.
Then say:

    exit

and finally:

    tmux

and you should no longer receive the warning.

## What next?

Once you've installed this configuration onto your own machine,
it's up to you to figure out how you want to customize it!
Spend some time going through the files,
particularly the zsh configuration located in `zshrc`, `zshenv`, and `zsh/`,
as well as the tmux config located at `tmux.conf`.
**Everything should serve a purpose.
If you don't need it, don't be afraid to toss it out!**

Finally, update this README to match any changes you end up making.
Who knows — you might inspire someone else to create their own dotfiles repo!

## Uninstalling everything

If you've given these dotfiles a try and they're not for you, no worries!
Simply run the following to remove all of the symlinks:

    script/manage uninstall --dry-run

As with the installation step,
this will merely tell you what uninstallation would have done, but not do anything just yet.
Review the output, and if everything looks good here, then run:

    script/manage uninstall

If you backed up your previous dotfiles,
you are now free to move them back.
