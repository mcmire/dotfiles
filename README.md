# vimfiles

I use Vim daily. I made my own configuration. And here it is!

Here's a rundown of everything it does:

* Use Vundle to manage plugins
* Show line numbers
* Show line/column in status bar
* Hide buffers when they are not displayed (vs. unloading them)
* Remove delay after pressing Escape and clearing the visual selection
* Fix so typing '#' does not jump to the start of the line
* Enable per-directory .vimrc's
* Remove trailing whitespace when a file is saved
* Auto-save all open files when Vim loses focus
* Enable 256-color support
* Use mokolai color scheme
* Set three color columns at 80, 100, and 120 characters
* Set tabstop to 2 spaces always; use tabs by default, but use spaces for
  frequently used file formats (Ruby, JavaScript, CoffeeScript, Markdown, HTML,
  XML, Haml, Sass, Vimscript)
* Set textwidth to 80 characters for Ruby files
* Set textwidth to 72 characters for git commit files
* For wrapped lines, j and k jump to the next row rather than the next line
* Add a quick way to toggle hard wrap
* Enable incremental search (when using `/` to search)
* Remember the last location in an file when reopening it
* Ensure config.ru, Gemfile, Rakefile, Thorfile, Vagrantfile, and Appraisals are
  all syntax-highlighted as Ruby files
* Ensure *.json files are syntax-highlighed as JavaScript files
* F3 toggles paste mode
* Auto-wrap text using textwidth; auto-wrap comments too, inserting the current
  comment leader; automatically insert the current comment leader after hitting
  'o' or 'O' in normal mode; allow formatting of comments with "gq"; only break
  a line at a blank entered during insert mode and as long as the line already
  is under the textwidth before entering insert mode
* Always show at least 3 lines above/below cursor and at least 7 columns next to
  the cursor even when scrolling
* Use a line for the cursor (instead of a block) when entering insert mode under
  iTerm2
* New splits go below the current buffer, and also to the right
* % to bounce from do to end in Ruby files
* Map ,evi to open .vimrc, ,evb to open .vimrc.bundles
* Mappings for easier window and tab switching
* Map Q and Y to useful things
* Make Ctrl-\ clear the current highlight
* Many mappings for pasting lines at various places
* ,gqc formats comment blocks; ,gqp formats paragraphs
* Add a mapping to easily close an entire tab

Plugin-specific configuration:

* Add mappings to easily toggle NERDTree and open the NERDTree highlighting the
  current file
* Modify Ctrl-P so it opens at the top, and uses Ag for searching
* Add a sensible mapping for NERDCommenter
* Enable IndentGuides on startup
* Modify CoffeeScript syntax highlighting to not be so annoying
* Add sensible mappings for vim-session
* Tell vim-ruby not to be so annoying with regard to indentation (using [my fork][vim-ruby])

These are the plugins that I use on a regular basis:

* Ag
* Ctrl-P
* FormatComment
* Indent Guides
* NERDCommenter
* NERDTree
* ragtag
* ShowMarks
* splitjoin
* SuperTab
* surround
* Syntastic
* vim-textobj-rubyblock
* Vundle

## Installation

Clone this repo, then run:

    git submodule update --init

Now run the install script:

    script/install

## How it works

The install script will copy over anything in src/ as a dotfile. That is,
src/vimrc is copied to ~/.vimrc, src/vim is copied to ~/.vim, etc. If a
file ends in .erb it will be evaluated as an ERB template and the resulting
content will copied to the dotfile (@options refer to the options parsed from
the command line). The script takes care not to overwrite any files, unless you
specify --force-update or --force-all. If you want to know what it will do
before running it for real, say `script/install --verbose --dry-run`.

## Author

Elliot Winkler (<elliot.winkler@gmail.com>)

[vim-ruby]: http://github.com/mcmire/vim-ruby
