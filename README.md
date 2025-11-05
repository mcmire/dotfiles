# dotfiles

These are my dotfiles.
They hold configuration for all of the essential tools I use
to write code and generally be productive.
I update it all the time!

## [What's in the box?][se7en]

[se7en]: https://youtu.be/1giVzxyoclE?t=122

### Terminal-based tools

* **[zsh]** — the new standard in shells
* **[iTerm]** — a more capable terminal emulator
* **[tmux]** — corral projects and their many sessions
* **[Neovim]** — a slimmer and more modern fork of Vim
  ([More details →](#neovim-configuration))
* **[Git]** — the king of version control software
* **[asdf]** — the one language version manager to rule them all
* **[autojump]** — no more setting up aliases to jump directly to projects
* **[fzf]** — a faster and more pleasant version of `Ctrl-R`

[zsh]: https://www.zsh.org/
[tmux]: https://github.com/tmux/tmux/wiki
[iTerm]: https://www.iterm2.com/
[Neovim]: https://neovim.io/
[Git]: https://git-scm.com/
[asdf]: https://asdf-vm.com/
[autojump]: https://github.com/wting/autojump
[fzf]: https://github.com/junegunn/fzf

### Applications

* **[Chrome]** — still has the best devtools
* **[1Password]** — the easiest password manager
* **[Obsidian]** — create your own personal knowledge base
* **[Dash]** — search documentation for all kinds of programming languages
* **[Moom]** — control placement of your windows using keybindings
* **[Stay]** — remembers window placement when connecting and discnnnecting monitors
* **[Numi]** — a fancy calculator app without any fancy buttons

[Chrome]: https://www.google.com/chrome/
[1Password]: https://1password.com
[Obsidian]: https://obsidian.md
[Dash]: https://kapeli.com/dash
[Moom]: https://manytricks.com/moom
[Stay]: https://cordlessdog.com/stay
[Numi]: https://numi.app

### Neovim configuration

Neovim is preconfigured with the following features:

#### Sensible defaults

* Lines in files of most filetypes are hard-wrapped to 80 characters
* The system clipboard is used for copying/pasting
* Incremental search provides more feedback than the default search behavior
* Configuration files for various language-specific tools
  (e.g. `Rakefile`, `Gemfile`, and `*.gemspec` for Ruby;
  `.jshintrc` and `.eslintrc` for JavaScript)
  are syntax highlighted correctly

#### Sensible mappings

* `,` is the leader key (so no finger gymnastics)
* `Ctrl-{H,J,K,L}` lets you navigate to windows in Vim *and to panes in tmux*
* `j` and `k` always place the cursor one line below or above, regardless of
  whether lines are being wrapped
* `%` bounces between the start and end of blocks (in languages that make it
  possible to do so)
* `<` and `>` no longer lose drop the selection when indenting a selected block
  of text
* `Q` lets you reformat paragraphs

#### Handy plugins

* **[VimPlug][vim-plug]**
  — a fast plugin manager
* **[NERDTree][vim-nerdtree]**
  — a simple file tree
* **[Ctrl-P][vim-ctrl-p]**
  — a fuzzy file finder for quickly jumping to files
* **[Ack][vim-ack] + [Ag][ag]**
  — a way to search across a project lightning quick
* **[NERDCommenter][vim-nerdcommenter]**
  — an easy way to comment and uncomment lines
* **[SuperTab][vim-supertab]**
  — an autocompleter that stays out of your way
* **[AutoPairs][auto-pairs]**
  — adds matching parentheses, braces, brackets, and quotes as you type them
  (but can be toggled on/off as needed)
* **[endwise][vim-endwise]**
  — like AutoPairs but for Ruby blocks
* **[indentLine][indentLine]**
  — adds vertical lines at regular indentation levels
  so that you can quickly tell if a line is misindented
* **[surround][vim-surround]**
  — a way to quickly surround text with quotes,
  parentheses, braces, etc.
* **[togglecursor][vim-togglecursor]**
  — makes insert and command modes more obvious
  by switching the cursor when switching modes
* **[CoC][coc]**
  — brings Vim closer to an IDE-like experience
  with autocompletion, documentation, linting, and formatting
  (works best with language servers like TypeScript)
* ...and more!

[vim-plug]: https://github.com/junegunn/vim-plug
[vim-nerdtree]: http://github.com/scrooloose/nerdtree
[vim-ctrl-p]: http://github.com/kien/ctrlp.vim
[vim-ack]: https://github.com/mileszs/ack.vim
[ag]: https://github.com/ggreer/the_silver_searcher
[vim-supertab]: http://github.com/ervandew/supertab
[vim-togglecursor]: https://github.com/jszakmeister/vim-togglecursor
[vim-nerdcommenter]: http://github.com/scrooloose/nerdcommenter
[vim-endwise]: https://github.com/tpope/vim-endwise
[vim-surround]: http://github.com/tpope/vim-surround
[vim-textobj-rubyblock]: http://github.com/nelstrom/vim-textobj-rubyblock
[coc]: https://github.com/neoclide/coc.nvim
[indentLine]: https://github.com/Yggdroot/indentLine
[auto-pairs]: https://github.com/eapache/auto-pairs
[fast-fold]: https://github.com/Konfekt/FastFold

### macOS customizations

* Use `~/Screenshots` to save screenshots instead of the desktop
* Disable auto-capitalization, smart characters, auto-correct, spell check, and grammar check
* Disable press-and-hold for keys
* Speed up keyboard repeat rate
* Use Caps Lock for Escape (for Vim)
* Make the Function key functional
* Disable most trackpad gestures
* Enable filename extensions by default in Finder
* Use plain text mode for TextEdit

### App customizations

* Allow tmux to access the clipboard by default
* Configure Moom so you can fully maximize any window with Cmd-F

### Automations

* Back up Obsidian to GitHub automatically
* Back up files to `rsync.net` automatically

## How do I use these dotfiles?

### Step 1: Fork this repo

You might be tempted to clone this repo,
but the author feels that the best development environment is the one _you_ control.
Therefore, it is recommended to fork this repo
so that you can make changes to this configuration at will
and push them up to your own account.
Scroll up to the top
and click that **Fork** button in the top-right corner now!

### Step 2: Clone your fork

At this point, you should be reading this README from your own fork.
Now open a terminal
and clone your fork in a convenient place you'll remember,
such as the same place you store code:

    cd ~/your-code-directory
    git clone git@github.com:yourusername/dotfiles.git

(You may need to install the macOS developer tools to run `git`.
If that's the case,
accept the prompt that appears
and then re-run the second command above.)

### Step 3: Clear the way

If you already have some amount of dotfiles in your home directory,
you will want to back them up
and move them out of the way before you go any further.
For instance:

    mv ~/.vimrc ~/.vimrc.old
    mv ~/.zshrc ~/.zshrc.old
    mv ~/.zshenv ~/.zshenv.old

### Step 4: Run the install script

Next, you'll want to run the script that comes bundled with this repo.
This script will install all of the files in this repo as symlinks into your home directory.
This has the advantage of allowing you to edit them through your forked repo location.
Run the script like so, supplying your Git name and email:

    bin/manage install --git-name "Your Name" --git-email "your@email.com" --dry-run

Note the use of `--dry-run` on the end.
This will tell you what would have been installed,
but nothing has happened yet!
Take a moment to look over the output and verify that it makes sense.
If it makes sense, then run it again without `--dry-run`:

    bin/manage install --git-name "Your Name" --git-email "your@email.com"

### Step 5: Verify the installation

Open iTerm and make sure that everything is good.
It should look like this:

![Example of iTerm](./docs/iterm.png)

If you get an error from `op` (1Password),
log into your 1Password app, go to Settings, go to Developer,
and check "Integrate with 1Password CLI".
Then restart iTerm.

Once you are here, you can load a colorscheme.
Run:

    tinty install
    tinty apply <colorscheme>

(You can see a list of colorschemes by running `tinty list`,
or by visiting <https://tinted-theming.github.io/tinted-gallery/>).

You may need to add an iTerm profile with the same name as your colorscheme.
If so, do that and then re-run the `tinty apply` command.

### Step 6: Install tmux plugins

Launch tmux by running this from iTerm:

    tmux

Press <kbd>Ctrl</kbd> + <kbd>Space</kbd> followed by <kbd>Shift</kbd> + <kbd>I</kbd>.
After a brief delay,
plugins will be installed that are necessary for tmux for fully work.

### Step 7: Install Vim plugins

Launch Vim by running this from any directory in iTerm:

    v

The first time you run this,
Neovim (thanks to Lazy) should install all plugins.
Just sit back and relax.

### Step 8 (optional): Log in to Github (for Copilot)

To use Copilot, run:

    :Copilot auth

If this doesn't work, then it probably means you don't have Node 22.x installed.
You can do this by modifying `~/.tool-versions` and adding `nodejs <version>`,
replacing `<version>` as appropriate.
Then run `asdf install`.

### Prologue: Making your own changes

So you've installed this configuration onto your own machine. Now what?
Now you get to customize it!
For instance, maybe you want to customize how the prompt looks,
or maybe you want to customize how tmux looks,
or maybe you want to switch from `zsh` back to `bash`.

To do this, it's helpful to know where things are.
Here are some key areas and what files control what things:

* **Shell configuration.**
  Starts in `src/zshrc`, which loads files in `src/zsh/`.
* **tmux configuration.**
  Located in `src/tmux.conf`.
* **Neovim configuration.**
  Located in `src/config/nvim`, but starts in `init.lua` and then branches out from there.
  For instance, `basics.lua` sets the leader key to to `,`;
  `mappings.lua` sets `Ctrl-{H,J,K,L}`;
  `line-width-settings.lua` sets the text width to 80 characters.
  Feel free to modify these files as you see fit.
  You can read about how Neovim starts [here](https://neovim.io/doc/user/starting.html#initialization).
  You can also learn more about a particular setting through `:help`.
  For instance, try `:help textwidth` or `:help colorcolumn`.)
  You can add any files you want to this folder,
  as long as you load them in `src/config/nvim/init.lua`.
* **Neovim plugins.**
  Plugins are initialized in `src/config/nvim/lazy.vim`,
  but are configured in `src/config/nvim/plugins`.
  There is a lot here, but don't panic!
  First, it's probably a good idea to read up on the most frequently used plugins mentioned at the beginning of this README.
  Learn what they do and how you can make use of them.
  If you don't feel like you need a plugin, feel free to disable it!
  You can do this by commenting it out in `lazy.vim`.
  Then exit and reload Neovim.

If you end up adding a new file to `src/`,
make sure to run `bin/manage install` again
so that a symlink gets put in the right place.

**Everything should serve a purpose.
If you don't need it, don't be afraid to toss it out!**

Finally, update this README to match any changes you end up making.
Who knows — you might inspire someone else to create their own dotfiles repo!

## Uninstalling everything

Given these dotfiles a try and decided they're not for you?
No worries!
Simply run the following to remove all of the symlinks:

    script/manage uninstall --dry-run

As with the installation step,
this will merely tell you what uninstallation would have done, but not do anything just yet.
Review the output, and if everything looks good here, then run:

    script/manage uninstall

If you backed up your previous dotfiles,
you are now free to move them back.
