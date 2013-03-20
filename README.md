# dotfiles

This is where I keep configuration for zsh, RubyGems, git, Clojure, Java, and
other stuff.

## Installation

First install oh-my-zsh:

    git clone http://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

Then, run the install script:

    script/install

## How it works

The install script will copy over anything in src/ as a dotfile. That is,
src/ackrc is copied to ~/.ackrc, src/inputrc is copied to ~/.inputrc, etc. If a
file ends in .erb it will be evaluated as an ERB template and the resulting
content will copied to the dotfile (@options refer to the options parsed from
the command line). The script takes care not to overwrite any files, unless you
specify --force-update or --force-all. If you want to know what it will do
before running it for real, say `script/install --verbose --dry-run`.

## Author

Elliot Winkler (<elliot.winkler@gmail.com>)
