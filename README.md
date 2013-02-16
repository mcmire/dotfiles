
# vimfiles

I use Vim daily. I made my own configuration. And here it is!

Here are some of the features of the configuration:

* Use Pathogen to manage plugins
* Fix so typing '#' does not jump to the start of the line
* Enable per-directory .vimrc's
* Remove trailing whitespace when a file is saved
* Auto-save all open files when Vim loses focus
* Set three color columns at 80, 100, and 120 characters
* Set tabstop to 2 spaces always; use tabs by default, but use spaces for
  frequently used file formats (Ruby, JavaScript, Markdown, HTML)
* Set textwidth to 80 characters for Ruby files
* For wrapped lines, j and k jump to the next row rather than the next line
* Quick way to toggle hard wrap
* Incremental search
* Wildignore Ruby/Rails-specific files
* Remember the last location in an file when reopening it
* Manual setting of Ruby filetype for Gemfile, Rakefile, etc.
* *.json files get a JavaScript filetype
* Always show at least 3 lines above/below cursor and at least 7 columns next to
  the cursor even when scrolling
* Fix the cursor when using vim via iTerm2
* New splits go below the current buffer, and also to the right
* % to bounce from do to end in Ruby files
* Map ,v to open .vimrc, ,gv to open .gvimrc
* Mappings for easier window and tab switching
* Map Q and Y to useful things
* Make Ctrl-\ clear the current highlight
* Many mapping for pasting lines at various places
* Easy way to convert strings to symbols and vice versa within a selection
* Easy way to start a search using the word under the cursor
* ,gqc formats comment blocks; ,gqp formats paragraphs
* Override CoffeeScript syntax highlighting not to be so annoying
* Reasonable NERDTree, Command-T, Powerline, and ShowMarks configuration

These are the plugins that I use on a regular basis:

* Ack
* Command-T
* FormatComment
* Indent Guides
* NERDCommenter
* NERDTree
* Powerline
* ragtag
* ShowMarks
* SuperTab

Here are the language files I've got installed:

* CoffeeScript
* JavaScript
* Mustache
* Puppet
* Ruby
* SCSS
* Slim
* YAML

## Installing vimfiles

    script/install

## Author

Elliot Winkler (<elliot.winkler@gmail.com>)

