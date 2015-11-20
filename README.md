# vimfiles

I use Vim daily. I made my own configuration. And here it is!

## Prerequisites

### Neovim

First of all, I'm using Neovim, not straight Vim. You can install this using
Homebrew:

    brew install neovim/neovim/neovim

If you are using my [dotfiles][dotfiles], then you can move on to the next step,
as I've set up `v` to open Neovim. Otherwise, you'll need to add them yourself.
Configure your shell to add the following alias:

    alias v="nvim"

Now you can simply say `v` to start Neovim (which I'll simply refer to as Vim
from here on out).

### iTerm

You'll need to use iTerm. Mainly this is because presently, it needs to be
configured to work with Neovim -- in the future that won't be necessary, but for
now, that's what works best.

With that out of the way, there are three configuration changes you'll need to
make with regard to iTerm.

* You'll want to change the color scheme to Solarized Dark/Light. You can
  download the color scheme files [here][solarized]. Look for a directory that
  corresponds to iTerm, then double-click on the color scheme files (dark *and*
  light) to install them.

* You'll want to make sure iTerm is using a Powerline-compatible
  font, that is, a font that's patched to support Powerline characters (such as
  arrows and icons and things). There's a list of fonts you can choose from
  [here][powerline-fonts]. Whichever one you download, drop it in
  `~/Library/Fonts` and you can use it right away. **Make sure that the
  "non-ASCII" font is also set to the same Powerline font as the "normal" font,
  otherwise you'll get strange "X" characters in place of the Powerline
  characters.**

* You'll also need to go into Preferences and override the mapping for
  <kbd>Ctrl-H</kbd>. Right now there's a [bug][neovim-bug] in Neovim whereby it
  treats <kbd>Ctrl-H</kbd> as <kbd>Backspace</kbd>. To fix this, you'll need to
  make <kbd>Ctrl-H</kbd> equivalent to `<Escape>[104;5u`. To do this:

  1. Inside of **Preferences**, click on **Keys**.
  2. Press `+` to add a new mapping.
  3. Click inside of **Keyboard Shortcut**, then press <kbd>Ctrl-H</kbd>.
  4. For **Action**, choose "Send Escape Action", and for **Esc+**, type
     `[104;5u`.

## Installation

Now for the fun stuff.

First, you need to download this repo to your computer somehow. You'll probably
want to come back to these files later, make modifications to them, and push
them up, so I recommend forking this repo. Put it in a convenient place you'll
remember, such as the same place you store code.

If you already have Vim installed, then you'll want to make sure you remove all
of those configuration files first. At a minimum, you'll want to run:

    mv ~/.vim ~/.vim.old
    mv ~/.vimrc ~/.vimrc.old

Next, run the install script. Since you probably forked the repo in the first
step above, you'll want to symlink all of the files in this repo to appropriate
places in your HOME directory. You can do that with:

    script/install --link

If you want to know what this will do first, say:

    script/install --link --dry-run

For further help, say:

    script/install --help

## Post install

Now you're ready to install a bunch of Vim plugins. You can do that by opening
Vim (remember, `v`) and running:

    :PlugInstall

After you run this, close Vim and re-open it.

You shouldn't have any problems doing this step, but if you do, please [create
an issue][issues].

## What's inside

Here's a rundown of (almost) everything my configuration does:

### Basics

* Use VimPlug to manage plugins
* Show line numbers
* Show line/column in status bar
* Hide buffers when they are not displayed (vs. unloading them)
* Remove delay after pressing Escape and clearing the visual selection
* Use modelines and check 10 lines to read them
* Fix so typing '#' (which is a comment in CoffeeScript, and elsewhere) does not
  jump to the start of the line
* Enable per-directory .vimrc's

### Magic

* Auto-reload files that are modified outside of Vim
* Auto-source vim config when it's modified
* Remember the last location in an file when reopening it

### Colors

* Enable 256-color support
* Use [Solarized][solarized] color scheme -- use `:ToggleTheme` to switch
  between dark and light
* Set four color columns at 72, 80, 100, and 120 characters

### Whitespace

* Set tabstop to 2 spaces always; use tabs by default, but use spaces for
  file formats I personally use (Ruby, CSS, JavaScript, CoffeeScript, HTML, XML,
  Markdown, Haml, Shell, ERB, Sass, Vimscript, Stylus, Jade)
* Display invisible characters: tabs, spaces, and end-of-line
* Highlight trailing whitespace, but provide a way to trim whitespace manually
  (`<Leader>tw`)
* Change the color of leading tabs to a dark color so it's not so overwhelming

### Line wrapping

* Soft wrap lines
* For wrapped lines, `j` and `k` jump to the next row rather than the next
  actual line
* Don't insert two spaces, but one space, after joining lines
* Turn on most of the `formatoptions`:
  * Auto-wrap text
  * Auto-wrap comments
  * Auto-insert comment leader
  * Allow formatting of comments using `gq`
  * In insert mode, auto-soft wrap only if the line was less than the wrap
    length before you entered insert mode (otherwise you can use `Q` to wrap)
* `<Leader>ww` toggles hard wrapping (which is on by default)
* `<Leader>wi` toggles soft wrapping (which is off by default)

### Searching

* Show all matches when you search (use `Ctrl-\` to clear)
* Enable incremental search (when using `/` to search)

### Filetype-based configuration

* Ensure config.ru, Gemfile, Rakefile, Thorfile, Vagrantfile, Appraisals, and
  Bowerfile are all syntax-highlighted as Ruby files
* Ensure Haml Coffee files are highlighted as Haml files
* Ensure JSON and *.jshintc files are highlighed as JavaScript files
* Make Python files follow PEP8

### Folding

* Enable folding
* Folding works according to indentation, and the max indentation level is 6

### Window

* New splits go below the current buffer, and also to the right

### Scrolling

* Always show at least 3 lines above/below cursor and at least 7 columns next to
  the cursor even when scrolling

### Cursor

* Use a line for the cursor (instead of a block) when entering insert mode under
  iTerm2, and also make sure this appears under tmux too

### Various mappings

* Map `%` to bounce from `do` to `end` in Ruby files
* Map `<Leader>evb` to open ~/.vimrc.bundles
* Map `F3` to easily toggle paste mode
* Map `Ctrl-{h,l,k,j}` to move between windows (left, right, up, down)
* Map `Q` to re-format the selection
* Map `Y` to yank to the end of the line (like `C` and `D`)
* No-op `K` as it doesn't do anything useful
* Map `Ctrl-S` to save, `Ctrl-Q` to save + quit
* Map `Ctrl-\` to clear the current highlight (no more typing `/asdf` or
  somesuch)
* Map `<Leader>tc` to close a tab
* Map `<Leader>po` to open a new line and paste into it
* Map `<Leader>pc` to paste overwriting the current line

### Plugins

#### NERDTree

* Open NERDTree as soon as you start Vim (I don't like that annoying splash
  screen)
* Map `<Leader>tt` to toggle the NERD tree
* Map `<Leader>tf` to open the NERD tree and then reveal the current file
* Close vim if the only window left open is a NERD tree

#### Ctrl-P

* Open at the top instead of the bottom
* Use Ag for searching so it's faster

#### IndentLines

* Use `¦` to show indentation levels. (This is more handy than you realize.)
* Set this token to a dark color so it isn't that noticeable

#### vim-coffee-script

* Don't highlight objects, brackets, curly braces, parentheses, or operators

#### Airline

* Show the Airline for all windows not just split windows
* Use Powerline symbols
* Tell vim to not show `-- INSERT --` in the status bar, as Airline already
  shows its own version of which mode you're in

#### splitjoin

* When splitting a line in Ruby that looks like `foo :x => 'y'`, don't
  add curly braces. (At least I think this is what this does)

#### vim-flavored-markdown

* Ensure that *.md and *.markdown files are highlighted as GitHub-flavored
  Markdown files and not regular Markdown files.

#### vim-slim

* Turn off smart indenting (I forget why now but it screws something up)

### Plugins

These are the plugins that I use on a regular basis, in rough order of
importance:

#### Essentials

* [VimPlug][vim-plug]
* [NERDTree][vim-nerdtree]
* [Ctrl-P][vim-ctrl-p]
* [Ag][vim-ag]
* [Airline][vim-airline]
* [SuperTab][vim-supertab]
* [vim-git][vim-git]
* [ragtag][vim-ragtag]
* [surround][vim-surround]

#### Not-so-essentials but still useful

* [Syntastic][vim-syntastic]
* [vim-textobj-rubyblock][vim-textobj-rubyblock]
* [indentLine][vim-indentline]
* [NERDCommenter][vim-nerdcommenter]
* [vim-session][vim-session]
* [ZoomWin][vim-zoomwin]

#### Syntax plugins

* [CoffeeScript][vim-coffeescript]
* [GitHub-flavored Markdown][vim-flavored-markdown]
* [HTML5][vim-html5-syntax]
* [Haml][vim-haml]
* [Jade][vim-jade]
* [JavaScript][vim-javascript]
* [Mustache][vim-mustache]
* [Ruby][vim-ruby]
* [Sass][vim-scss-syntax]
* [Sinatra][vim-ruby-sinatra]
* [Slim][vim-slim]
* [Stylus][vim-stylus]
* [YAML][vim-yaml]

## Author

Elliot Winkler (<elliot.winkler@gmail.com>)

[vim-plug]: https://github.com/junegunn/vim-plug
[vim-nerdtree]: http://github.com/scrooloose/nerdtree
[vim-ctrl-p]: http://github.com/kien/ctrlp.vim
[vim-ag]: http://github.com/rking/ag.vim'
[vim-airline]: http://github.com/bling/vim-airline
[vim-supertab]: http://github.com/ervandew/supertab
[vim-git]: http://github.com/tpope/vim-git
[vim-ragtag]: http://github.com/tpope/vim-ragtag
[vim-syntastic]: http://github.com/scrooloose/syntastic
[vim-surround]: http://github.com/tpope/vim-surround
[vim-textobj-rubyblock]: http://github.com/nelstrom/vim-textobj-rubyblock
[vim-indentline]: http://github.com/Yggdroot/indentLine
[vim-nerdcommenter]: http://github.com/scrooloose/nerdcommenter
[vim-session]: http://github.com/xolox/vim-session
[vim-zoomwin]: http://github.com/vim-scripts/ZoomWin
[vim-ruby]: http://github.com/mcmire/vim-ruby
[vim-coffeescript]: http://github.com/kchmck/vim-coffee-script
[vim-flavored-markdown]: http://github.com/jtratner/vim-flavored-markdown
[vim-html5-syntax]: http://github.com/othree/html5-syntax.vim
[vim-haml]: http://github.com/tpope/vim-haml
[vim-jade]: http://github.com/digitaltoad/vim-jade
[vim-javascript]: http://github.com/pangloss/vim-javascript
[vim-mustache]: http://github.com/juvenn/mustache.vim
[vim-ruby]: http://github.com/mcmire/vim-ruby
[vim-scss-syntax]: http://github.com/cakebaker/scss-syntax.vim
[vim-ruby-sinatra]: http://github.com/hallison/vim-ruby-sinatra
[vim-slim]: http://github.com/djbender/vim-slim
[vim-stylus]: http://github.com/wavded/vim-stylus
[vim-yaml]: http://github.com/avakhov/vim-yaml
[issues]: http://github.com/mcmire/vimfiles/issues
[dotfiles]: http://github.com/mcmire/dotfiles
[powerline-fonts]: https://github.com/Lokaltog/powerline-fonts
[solarized]: https://github.com/altercation/solarized
[neovim-bug]: https://github.com/neovim/neovim/issues/2048
[neovim-bugfix-iterm]: https://github.com/neovim/neovim/issues/2048#issuecomment-98192906
